From: Hanna Reitz <hreitz@redhat.com>
Date: Thu, 16 Sep 2021 10:40:42 +0200
Message-Id: <20210916084045.31684-10-hreitz@redhat.com>
In-Reply-To: <20210916084045.31684-1-hreitz@redhat.com>
References: <20210916084045.31684-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 09/12] virtiofsd: Add lo_inode.fhandle
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Hanna Reitz <hreitz@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

This new field is an alternative to lo_inode.fd: Either of the two must
be set.  In case an O_PATH FD is needed for some lo_inode, it is either
taken from lo_inode.fd, if valid, or a temporary FD is opened with
open_by_handle_at().

Using a file handle instead of an FD has the advantage of keeping the
number of open file descriptors low.

Because open_by_handle_at() requires a mount FD (i.e. a non-O_PATH FD
opened on the filesystem to which the file handle refers), but every
lo_fhandle only has a mount ID (as returned by name_to_handle_at()), we
keep a hash map of such FDs in mount_fds (mapping ID to FD).
get_file_handle(), which is added by a later patch, will ensure that
every mount ID for which we have generated a handle has a corresponding
entry in mount_fds.  Every handle holds a strong reference to its mount
FD (lo_mount_fd.refcount) so we can clean up mount FDs when they are no
longer needed.

release_file_handle()'s drop_mount_fd_ref parameter may look a bit
strange at this point, because we always pass true for it, but it will
make more sense when we start generating file handles: At that point, we
will also use this function to clean up lo_fhandle object that do not
yet have a strong reference to an lo_mount_fd object, and then we will
need to be able to pass false for drop_mount_fd_ref.

Signed-off-by: Hanna Reitz <hreitz@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c      | 175 +++++++++++++++++++++++---
 tools/virtiofsd/passthrough_seccomp.c |   1 +
 2 files changed, 161 insertions(+), 15 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index bc3b803d46..bd8fc922ea 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -88,8 +88,18 @@ struct lo_key {
     uint64_t mnt_id;
 };
 
+struct lo_fhandle {
+    union {
+        struct file_handle handle;
+        char padding[sizeof(struct file_handle) + MAX_HANDLE_SZ];
+    };
+    int mount_id;
+};
+
 struct lo_inode {
+    /* fd or fhandle must be set (i.e. >= 0 or non-NULL, respectively) */
     int fd;
+    struct lo_fhandle *fhandle;
 
     /*
      * Atomic reference count for this object.  The nlookup field holds a
@@ -142,6 +152,19 @@ typedef struct xattr_map_entry {
     unsigned int flags;
 } XattrMapEntry;
 
+/*
+ * An O_RDONLY FD representing the mount it is on.  We need this for
+ * open_by_handle_at().
+ *
+ * The refcount is increased every time we store a file handle for
+ * this mount, and it is decreased every time we release such a stored
+ * file handle.
+ */
+struct lo_mount_fd {
+    int fd;
+    gint refcount;
+};
+
 struct lo_data {
     pthread_mutex_t mutex;
     int sandbox;
@@ -178,6 +201,10 @@ struct lo_data {
     /* If set, virtiofsd is responsible for setting umask during creation */
     bool change_umask;
     int user_posix_acl, posix_acl;
+
+    /* Maps (integer) mount IDs to lo_mount_fd objects */
+    GHashTable *mount_fds;
+    pthread_rwlock_t mount_fds_lock;
 };
 
 /**
@@ -316,6 +343,93 @@ static void temp_fd_copy(const TempFd *from, TempFd *to)
     };
 }
 
+static void free_lo_mount_fd(gpointer data)
+{
+    struct lo_mount_fd *mfd = data;
+
+    close(mfd->fd);
+    g_free(mfd);
+}
+
+/**
+ * Frees a file handle and optionally removes its reference to the
+ * associated mount FD.  (Passing NULL as @fh is OK.)
+ *
+ * Pass @drop_mount_fd_ref == true if and only if this handle has a
+ * strong reference to an lo_mount_fd object in the mount_fds hash
+ * table.  That is always the case for file handles stored in lo_inode
+ * objects.
+ */
+static void release_file_handle(struct lo_data *lo, struct lo_fhandle *fh,
+                                bool drop_mount_fd_ref)
+{
+    if (!fh) {
+        return;
+    }
+
+    if (drop_mount_fd_ref) {
+        struct lo_mount_fd *mfd;
+
+        if (pthread_rwlock_rdlock(&lo->mount_fds_lock)) {
+            fuse_log(FUSE_LOG_ERR, "%s(): Dropping mount FD reference failed "
+                     "(mount ID: %i)\n", __func__, fh->mount_id);
+        } else {
+            mfd = g_hash_table_lookup(lo->mount_fds,
+                                      GINT_TO_POINTER(fh->mount_id));
+            assert(mfd != NULL);
+
+            pthread_rwlock_unlock(&lo->mount_fds_lock);
+
+            if (g_atomic_int_dec_and_test(&mfd->refcount)) {
+                if (pthread_rwlock_wrlock(&lo->mount_fds_lock)) {
+                    fuse_log(FUSE_LOG_ERR, "%s(): Dropping mount FD reference "
+                             "failed (mount ID: %i)\n", __func__, fh->mount_id);
+                } else {
+                    /* Auto-closes the FD and frees mfd */
+                    g_hash_table_remove(lo->mount_fds,
+                                        GINT_TO_POINTER(fh->mount_id));
+                    pthread_rwlock_unlock(&lo->mount_fds_lock);
+                }
+            }
+        }
+    }
+
+    g_free(fh);
+}
+
+/**
+ * Open the given file handle with the given flags.
+ *
+ * The mount FD to pass to open_by_handle_at() is taken from the
+ * mount_fds hash map.
+ *
+ * On error, return -errno.
+ */
+static int open_file_handle(struct lo_data *lo, const struct lo_fhandle *fh,
+                            int flags)
+{
+    struct lo_mount_fd *mfd;
+    int ret;
+
+    ret = pthread_rwlock_rdlock(&lo->mount_fds_lock);
+    if (ret) {
+        return -ret;
+    }
+
+    mfd = g_hash_table_lookup(lo->mount_fds, GINT_TO_POINTER(fh->mount_id));
+    pthread_rwlock_unlock(&lo->mount_fds_lock);
+    if (!mfd) {
+        return -EINVAL;
+    }
+
+    ret = open_by_handle_at(mfd->fd, (struct file_handle *)&fh->handle, flags);
+    if (ret < 0) {
+        return -errno;
+    }
+
+    return ret;
+}
+
 /*
  * Load capng's state from our saved state if the current thread
  * hadn't previously been loaded.
@@ -622,7 +736,10 @@ static void lo_inode_put(struct lo_data *lo, struct lo_inode **inodep)
     *inodep = NULL;
 
     if (g_atomic_int_dec_and_test(&inode->refcount)) {
-        close(inode->fd);
+        if (inode->fd >= 0) {
+            close(inode->fd);
+        }
+        release_file_handle(lo, inode->fhandle, true);
         free(inode);
     }
 }
@@ -650,10 +767,25 @@ static struct lo_inode *lo_inode(fuse_req_t req, fuse_ino_t ino)
 static int lo_inode_fd(struct lo_data *lo, const struct lo_inode *inode,
                        TempFd *tfd)
 {
-    *tfd = (TempFd) {
-        .fd = inode->fd,
-        .owned = false,
-    };
+    if (inode->fd >= 0) {
+        *tfd = (TempFd) {
+            .fd = inode->fd,
+            .owned = false,
+        };
+    } else {
+        int fd;
+
+        assert(inode->fhandle != NULL);
+        fd = open_file_handle(lo, inode->fhandle, O_PATH);
+        if (fd < 0) {
+            return -errno;
+        }
+
+        *tfd = (TempFd) {
+            .fd = fd,
+            .owned = true,
+        };
+    }
 
     return 0;
 }
@@ -694,22 +826,32 @@ static int lo_fd(fuse_req_t req, fuse_ino_t ino, TempFd *tfd)
 static int lo_inode_open(struct lo_data *lo, struct lo_inode *inode,
                          int open_flags, TempFd *tfd)
 {
-    g_autofree char *fd_str = g_strdup_printf("%d", inode->fd);
+    g_autofree char *fd_str = NULL;
     int fd;
 
     if (!S_ISREG(inode->filetype) && !S_ISDIR(inode->filetype)) {
         return -EBADF;
     }
 
-    /*
-     * The file is a symlink so O_NOFOLLOW must be ignored. We checked earlier
-     * that the inode is not a special file but if an external process races
-     * with us then symlinks are traversed here. It is not possible to escape
-     * the shared directory since it is mounted as "/" though.
-     */
-    fd = openat(lo->proc_self_fd, fd_str, open_flags & ~O_NOFOLLOW);
-    if (fd < 0) {
-        return -errno;
+    if (inode->fd >= 0) {
+        /*
+         * The file is a symlink so O_NOFOLLOW must be ignored. We checked
+         * earlier that the inode is not a special file but if an external
+         * process races with us then symlinks are traversed here. It is not
+         * possible to escape the shared directory since it is mounted as "/"
+         * though.
+         */
+        fd_str = g_strdup_printf("%d", inode->fd);
+        fd = openat(lo->proc_self_fd, fd_str, open_flags & ~O_NOFOLLOW);
+        if (fd < 0) {
+            return -errno;
+        }
+    } else {
+        assert(inode->fhandle != NULL);
+        fd = open_file_handle(lo, inode->fhandle, open_flags);
+        if (fd < 0) {
+            return fd;
+        }
     }
 
     *tfd = (TempFd) {
@@ -4187,6 +4329,9 @@ int main(int argc, char *argv[])
     lo.root.fuse_ino = FUSE_ROOT_ID;
     lo.cache = CACHE_AUTO;
 
+    pthread_rwlock_init(&lo.mount_fds_lock, NULL);
+    lo.mount_fds = g_hash_table_new_full(NULL, NULL, NULL, free_lo_mount_fd);
+
     /*
      * Set up the ino map like this:
      * [0] Reserved (will not be used)
diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
index f49ed94b5e..af04c638cb 100644
--- a/tools/virtiofsd/passthrough_seccomp.c
+++ b/tools/virtiofsd/passthrough_seccomp.c
@@ -77,6 +77,7 @@ static const int syscall_allowlist[] = {
     SCMP_SYS(statx),
     SCMP_SYS(open),
     SCMP_SYS(openat),
+    SCMP_SYS(open_by_handle_at),
     SCMP_SYS(ppoll),
     SCMP_SYS(prctl), /* TODO restrict to just PR_SET_NAME? */
     SCMP_SYS(preadv),
-- 
2.31.1

