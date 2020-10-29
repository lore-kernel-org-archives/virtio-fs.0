From: Max Reitz <mreitz@redhat.com>
Date: Thu, 29 Oct 2020 18:17:41 +0100
Message-Id: <20201029171744.150726-5-mreitz@redhat.com>
In-Reply-To: <20201029171744.150726-1-mreitz@redhat.com>
References: <20201029171744.150726-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 4/7] virtiofsd: Add mount ID to the lo_inode
	key
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>

Using st_dev is not sufficient to uniquely identify a mount: You can
mount the same device twice, but those are still separate trees, and
e.g. by mounting something else inside one of them, they may differ.

Using statx(), we can get a mount ID that uniquely identifies a mount.
If that is available, add it to the lo_inode key.

Most of this patch is taken from Miklos's mail here:
https://marc.info/?l=fuse-devel&m=160062521827983
(virtiofsd-use-mount-id.patch attachment)

Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Max Reitz <mreitz@redhat.com>
---
I’m not sure how to better mark Miklos as the original author of this
patch, since he didn’t give an S-o-b on virtiofsd-use-mount-id.patch.
The best would be if he could give it now (or at least review or ack
this patch).

I made some changes, most notably:
- Set use_statx unconditionally, not just with announce_submounts.  It
  fixes a real bug that has nothing to do with submounts.

- Squashed some hunks into other patches of my series (thus directly
  obsoleting “Store every lo_inode's parent_dev”, and indirectly also
  “Add fuse_reply_attr_with_flags”)

- Spun out the configure check (whether statx() is available) into a
  dedicated patch, and translated it to Meson

- errno isn’t negative (the original patch checked for errno != -ENOSYS)
---
 tools/virtiofsd/passthrough_ll.c      | 95 ++++++++++++++++++++++++---
 tools/virtiofsd/passthrough_seccomp.c |  1 +
 2 files changed, 86 insertions(+), 10 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index a0beb986f3..34d107975f 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -94,6 +94,7 @@ struct lo_map {
 struct lo_key {
     ino_t ino;
     dev_t dev;
+    uint64_t mnt_id;
 };
 
 struct lo_inode {
@@ -166,6 +167,7 @@ struct lo_data {
     int readdirplus_set;
     int readdirplus_clear;
     int allow_direct_io;
+    bool use_statx;
     struct lo_inode root;
     GHashTable *inodes; /* protected by lo->mutex */
     struct lo_map ino_map; /* protected by lo->mutex */
@@ -219,7 +221,8 @@ static struct {
 /* That we loaded cap-ng in the current thread from the saved */
 static __thread bool cap_loaded = 0;
 
-static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st);
+static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st,
+                                uint64_t mnt_id);
 
 static int is_dot_or_dotdot(const char *name)
 {
@@ -741,12 +744,14 @@ out_err:
     fuse_reply_err(req, saverr);
 }
 
-static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st)
+static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st,
+                                uint64_t mnt_id)
 {
     struct lo_inode *p;
     struct lo_key key = {
         .ino = st->st_ino,
         .dev = st->st_dev,
+        .mnt_id = mnt_id,
     };
 
     pthread_mutex_lock(&lo->mutex);
@@ -774,6 +779,60 @@ static void posix_locks_value_destroy(gpointer data)
     free(plock);
 }
 
+static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
+                    struct stat *statbuf, int flags, uint64_t *mnt_id)
+{
+    int res;
+
+#if defined(CONFIG_STATX) && defined(STATX_MNT_ID)
+    if (lo->use_statx) {
+        struct statx statxbuf;
+
+        res = statx(dirfd, pathname, flags, STATX_BASIC_STATS | STATX_MNT_ID,
+                    &statxbuf);
+        if (!res) {
+            memset(statbuf, 0, sizeof(*statbuf));
+            statbuf->st_dev = makedev(statxbuf.stx_dev_major,
+                                      statxbuf.stx_dev_minor);
+            statbuf->st_ino = statxbuf.stx_ino;
+            statbuf->st_mode = statxbuf.stx_mode;
+            statbuf->st_nlink = statxbuf.stx_nlink;
+            statbuf->st_uid = statxbuf.stx_uid;
+            statbuf->st_gid = statxbuf.stx_gid;
+            statbuf->st_rdev = makedev(statxbuf.stx_rdev_major,
+                                       statxbuf.stx_rdev_minor);
+            statbuf->st_size = statxbuf.stx_size;
+            statbuf->st_blksize = statxbuf.stx_blksize;
+            statbuf->st_blocks = statxbuf.stx_blocks;
+            statbuf->st_atim.tv_sec = statxbuf.stx_atime.tv_sec;
+            statbuf->st_atim.tv_nsec = statxbuf.stx_atime.tv_nsec;
+            statbuf->st_mtim.tv_sec = statxbuf.stx_mtime.tv_sec;
+            statbuf->st_mtim.tv_nsec = statxbuf.stx_mtime.tv_nsec;
+            statbuf->st_ctim.tv_sec = statxbuf.stx_ctime.tv_sec;
+            statbuf->st_ctim.tv_nsec = statxbuf.stx_ctime.tv_nsec;
+
+            if (statxbuf.stx_mask & STATX_MNT_ID) {
+                *mnt_id = statxbuf.stx_mnt_id;
+            } else {
+                *mnt_id = 0;
+            }
+            return 0;
+        } else if (errno != ENOSYS) {
+            return -1;
+        }
+        lo->use_statx = false;
+        /* fallback */
+    }
+#endif
+    res = fstatat(dirfd, pathname, statbuf, flags);
+    if (res == -1) {
+        return -1;
+    }
+    *mnt_id = 0;
+
+    return 0;
+}
+
 /*
  * Increments nlookup and caller must release refcount using
  * lo_inode_put(&parent).
@@ -784,6 +843,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
     int newfd;
     int res;
     int saverr;
+    uint64_t mnt_id;
     struct lo_data *lo = lo_data(req);
     struct lo_inode *inode = NULL;
     struct lo_inode *dir = lo_inode(req, parent);
@@ -811,12 +871,13 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         goto out_err;
     }
 
-    res = fstatat(newfd, "", &e->attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+    res = do_statx(lo, newfd, "", &e->attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW,
+                   &mnt_id);
     if (res == -1) {
         goto out_err;
     }
 
-    inode = lo_find(lo, &e->attr);
+    inode = lo_find(lo, &e->attr, mnt_id);
     if (inode) {
         close(newfd);
     } else {
@@ -838,6 +899,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         inode->fd = newfd;
         inode->key.ino = e->attr.st_ino;
         inode->key.dev = e->attr.st_dev;
+        inode->key.mnt_id = mnt_id;
         pthread_mutex_init(&inode->plock_mutex, NULL);
         inode->posix_locks = g_hash_table_new_full(
             g_direct_hash, g_direct_equal, NULL, posix_locks_value_destroy);
@@ -1090,15 +1152,23 @@ static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
                                     const char *name)
 {
     int res;
+    uint64_t mnt_id;
     struct stat attr;
+    struct lo_data *lo = lo_data(req);
+    struct lo_inode *dir = lo_inode(req, parent);
 
-    res = fstatat(lo_fd(req, parent), name, &attr,
-                  AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+    if (!dir) {
+        return NULL;
+    }
+
+    res = do_statx(lo, dir->fd, name, &attr,
+                   AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW, &mnt_id);
+    lo_inode_put(lo, &dir);
     if (res == -1) {
         return NULL;
     }
 
-    return lo_find(lo_data(req), &attr);
+    return lo_find(lo, &attr, mnt_id);
 }
 
 static void lo_rmdir(fuse_req_t req, fuse_ino_t parent, const char *name)
@@ -3266,6 +3336,7 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
 {
     int fd, res;
     struct stat stat;
+    uint64_t mnt_id;
 
     fd = open("/", O_PATH);
     if (fd == -1) {
@@ -3273,7 +3344,8 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
         exit(1);
     }
 
-    res = fstatat(fd, "", &stat, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+    res = do_statx(lo, fd, "", &stat, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW,
+                   &mnt_id);
     if (res == -1) {
         fuse_log(FUSE_LOG_ERR, "fstatat(%s): %m\n", lo->source);
         exit(1);
@@ -3283,6 +3355,7 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
     root->fd = fd;
     root->key.ino = stat.st_ino;
     root->key.dev = stat.st_dev;
+    root->key.mnt_id = mnt_id;
     root->nlookup = 2;
     g_atomic_int_set(&root->refcount, 2);
 }
@@ -3291,7 +3364,7 @@ static guint lo_key_hash(gconstpointer key)
 {
     const struct lo_key *lkey = key;
 
-    return (guint)lkey->ino + (guint)lkey->dev;
+    return (guint)lkey->ino + (guint)lkey->dev + (guint)lkey->mnt_id;
 }
 
 static gboolean lo_key_equal(gconstpointer a, gconstpointer b)
@@ -3299,7 +3372,7 @@ static gboolean lo_key_equal(gconstpointer a, gconstpointer b)
     const struct lo_key *la = a;
     const struct lo_key *lb = b;
 
-    return la->ino == lb->ino && la->dev == lb->dev;
+    return la->ino == lb->ino && la->dev == lb->dev && la->mnt_id == lb->mnt_id;
 }
 
 static void fuse_lo_data_cleanup(struct lo_data *lo)
@@ -3445,6 +3518,8 @@ int main(int argc, char *argv[])
         exit(1);
     }
 
+    lo.use_statx = true;
+
     se = fuse_session_new(&args, &lo_oper, sizeof(lo_oper), &lo);
     if (se == NULL) {
         goto err_out1;
diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
index eb9af8265f..751e15fa39 100644
--- a/tools/virtiofsd/passthrough_seccomp.c
+++ b/tools/virtiofsd/passthrough_seccomp.c
@@ -76,6 +76,7 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(mremap),
     SCMP_SYS(munmap),
     SCMP_SYS(newfstatat),
+    SCMP_SYS(statx),
     SCMP_SYS(open),
     SCMP_SYS(openat),
     SCMP_SYS(ppoll),
-- 
2.26.2

