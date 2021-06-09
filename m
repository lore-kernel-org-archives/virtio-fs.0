From: Max Reitz <mreitz@redhat.com>
Date: Wed,  9 Jun 2021 17:55:48 +0200
Message-Id: <20210609155551.44437-7-mreitz@redhat.com>
In-Reply-To: <20210609155551.44437-1-mreitz@redhat.com>
References: <20210609155551.44437-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 6/9] virtiofsd: Add lo_inode.fhandle
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Max Reitz <mreitz@redhat.com>

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
entry in mount_fds.

Signed-off-by: Max Reitz <mreitz@redhat.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c      | 116 ++++++++++++++++++++++----
 tools/virtiofsd/passthrough_seccomp.c |   1 +
 2 files changed, 102 insertions(+), 15 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 3014e8baf8..e665575401 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -88,8 +88,25 @@ struct lo_key {
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
+/* Maps mount IDs to an FD that we can pass to open_by_handle_at() */
+static GHashTable *mount_fds;
+pthread_rwlock_t mount_fds_lock = PTHREAD_RWLOCK_INITIALIZER;
+
 struct lo_inode {
+    /*
+     * Either of fd or fhandle must be set (i.e. >= 0 or non-NULL,
+     * respectively).
+     */
     int fd;
+    struct lo_fhandle *fhandle;
 
     /*
      * Atomic reference count for this object.  The nlookup field holds a
@@ -296,6 +313,44 @@ static int temp_fd_steal(TempFd *temp_fd)
     }
 }
 
+/**
+ * Open the given file handle with the given flags.
+ *
+ * The mount FD to pass to open_by_handle_at() is taken from the
+ * mount_fds hash map.
+ *
+ * On error, return -errno.
+ */
+static int open_file_handle(const struct lo_fhandle *fh, int flags)
+{
+    gpointer mount_fd_ptr;
+    int mount_fd;
+    bool found;
+    int ret;
+
+    ret = pthread_rwlock_rdlock(&mount_fds_lock);
+    if (ret) {
+        return -ret;
+    }
+
+    /* mount_fd == 0 is valid, so we need lookup_extended */
+    found = g_hash_table_lookup_extended(mount_fds,
+                                         GINT_TO_POINTER(fh->mount_id),
+                                         NULL, &mount_fd_ptr);
+    pthread_rwlock_unlock(&mount_fds_lock);
+    if (!found) {
+        return -EINVAL;
+    }
+    mount_fd = GPOINTER_TO_INT(mount_fd_ptr);
+
+    ret = open_by_handle_at(mount_fd, (struct file_handle *)&fh->handle, flags);
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
@@ -602,7 +657,11 @@ static void lo_inode_put(struct lo_data *lo, struct lo_inode **inodep)
     *inodep = NULL;
 
     if (g_atomic_int_dec_and_test(&inode->refcount)) {
-        close(inode->fd);
+        if (inode->fd >= 0) {
+            close(inode->fd);
+        } else {
+            g_free(inode->fhandle);
+        }
         free(inode);
     }
 }
@@ -629,10 +688,25 @@ static struct lo_inode *lo_inode(fuse_req_t req, fuse_ino_t ino)
 
 static int lo_inode_fd(const struct lo_inode *inode, TempFd *tfd)
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
+        fd = open_file_handle(inode->fhandle, O_PATH);
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
@@ -672,22 +746,32 @@ static int lo_fd(fuse_req_t req, fuse_ino_t ino, TempFd *tfd)
 static int lo_inode_open(const struct lo_data *lo, const struct lo_inode *inode,
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
+        fd = open_file_handle(inode->fhandle, open_flags);
+        if (fd < 0) {
+            return fd;
+        }
     }
 
     *tfd = (TempFd) {
@@ -3911,6 +3995,8 @@ int main(int argc, char *argv[])
     lo.root.fuse_ino = FUSE_ROOT_ID;
     lo.cache = CACHE_AUTO;
 
+    mount_fds = g_hash_table_new(NULL, NULL);
+
     /*
      * Set up the ino map like this:
      * [0] Reserved (will not be used)
diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
index 62441cfcdb..e948f25ac1 100644
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

