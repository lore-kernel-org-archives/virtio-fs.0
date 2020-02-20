From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Thu, 20 Feb 2020 20:47:04 +0900
Message-ID: <20200220114704.11592-3-misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <20200220114704.11592-1-misono.tomohiro@jp.fujitsu.com>
References: <20200220114704.11592-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 2/2] virtiofs: Fix xattr operations
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: vgoyal@redhat.com

Current virtiofsd has problems about xattr operations and
they does not work properly for directory/symlink/special file.

The fundamental cause is that virtiofsd uses openat() + f...xattr()
systemcalls for xattr operation but we should not open symlink/special
file in the daemon. Therefore the function is restricted.

Fix this problem by:
 1. during setup of each thread, call unshare(CLONE_FS)
 2. in xattr operations (i.e. lo_getxattr), if inode is not a regular
    file or directory, use fchdir(proc_loot_fd) + ...xattr() +
    fchdir(root.fd) instead of openat() + f...xattr()

    (Note: for a regular file/directory openat() + f...xattr()
     is still used for performance reason)

With this patch, xfstests generic/062 passes on virtiofs.
This fix is suggested by Miklos Szeredi and Stefan Hajnoczi.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 tools/virtiofsd/fuse_virtio.c    | 13 +++++
 tools/virtiofsd/passthrough_ll.c | 99 +++++++++++++++++---------------
 tools/virtiofsd/seccomp.c        |  6 ++
 3 files changed, 71 insertions(+), 47 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 655b9a1413..21c5d76d58 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -463,6 +463,8 @@ err:
     return ret;
 }
 
+static __thread bool clone_fs_called;
+
 /* Process one FVRequest in a thread pool */
 static void fv_queue_worker(gpointer data, gpointer user_data)
 {
@@ -478,6 +480,17 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
 
     assert(se->bufsize > sizeof(struct fuse_in_header));
 
+    if (!clone_fs_called) {
+        int ret;
+
+        /* unshare FS for xattr operation */
+        ret = unshare(CLONE_FS);
+        /* should not fail */
+        assert(ret == 0);
+
+        clone_fs_called = true;
+    }
+
     /*
      * An element contains one request and the space to send our response
      * They're spread over multiple descriptors in a scatter/gather set
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 33cff8c2c8..7d648af916 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -130,7 +130,7 @@ struct lo_inode {
     pthread_mutex_t plock_mutex;
     GHashTable *posix_locks; /* protected by lo_inode->plock_mutex */
 
-    bool is_symlink;
+    mode_t filetype;
 };
 
 struct lo_cred {
@@ -734,7 +734,7 @@ static int utimensat_empty(struct lo_data *lo, struct lo_inode *inode,
     struct lo_inode *parent;
     char path[PATH_MAX];
 
-    if (inode->is_symlink) {
+    if (S_ISLNK(inode->filetype)) {
         res = utimensat(inode->fd, "", tv, AT_EMPTY_PATH);
         if (res == -1 && errno == EINVAL) {
             /* Sorry, no race free way to set times on symlink. */
@@ -1037,7 +1037,8 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
             goto out_err;
         }
 
-        inode->is_symlink = S_ISLNK(e->attr.st_mode);
+        /* cache only filetype */
+        inode->filetype = (e->attr.st_mode & S_IFMT);
 
         /*
          * One for the caller and one for nlookup (released in
@@ -1264,7 +1265,7 @@ static int linkat_empty_nofollow(struct lo_data *lo, struct lo_inode *inode,
     struct lo_inode *parent;
     char path[PATH_MAX];
 
-    if (inode->is_symlink) {
+    if (S_ISLNK(inode->filetype)) {
         res = linkat(inode->fd, "", dfd, name, AT_EMPTY_PATH);
         if (res == -1 && (errno == ENOENT || errno == EINVAL)) {
             /* Sorry, no race free way to hard-link a symlink. */
@@ -2378,12 +2379,6 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
     fuse_log(FUSE_LOG_DEBUG, "lo_getxattr(ino=%" PRIu64 ", name=%s size=%zd)\n",
              ino, name, size);
 
-    if (inode->is_symlink) {
-        /* Sorry, no race free way to getxattr on symlink. */
-        saverr = EPERM;
-        goto out;
-    }
-
     if (size) {
         value = malloc(size);
         if (!value) {
@@ -2392,12 +2387,19 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
     }
 
     sprintf(procname, "%i", inode->fd);
-    fd = openat(lo->proc_self_fd, procname, O_RDONLY);
-    if (fd < 0) {
-        goto out_err;
+    if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
+        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
+        if (fd < 0) {
+            goto out_err;
+        }
+        ret = fgetxattr(fd, name, value, size);
+    } else {
+        /* fchdir should not fail here */
+        assert(fchdir(lo->proc_self_fd) == 0);
+        ret = getxattr(procname, name, value, size);
+        assert(fchdir(lo->root.fd) == 0);
     }
 
-    ret = fgetxattr(fd, name, value, size);
     if (ret == -1) {
         goto out_err;
     }
@@ -2451,12 +2453,6 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
     fuse_log(FUSE_LOG_DEBUG, "lo_listxattr(ino=%" PRIu64 ", size=%zd)\n", ino,
              size);
 
-    if (inode->is_symlink) {
-        /* Sorry, no race free way to listxattr on symlink. */
-        saverr = EPERM;
-        goto out;
-    }
-
     if (size) {
         value = malloc(size);
         if (!value) {
@@ -2465,12 +2461,19 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
     }
 
     sprintf(procname, "%i", inode->fd);
-    fd = openat(lo->proc_self_fd, procname, O_RDONLY);
-    if (fd < 0) {
-        goto out_err;
+    if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
+        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
+        if (fd < 0) {
+            goto out_err;
+        }
+        ret = flistxattr(fd, value, size);
+    } else {
+        /* fchdir should not fail here */
+        assert(fchdir(lo->proc_self_fd) == 0);
+        ret = listxattr(procname, value, size);
+        assert(fchdir(lo->root.fd) == 0);
     }
 
-    ret = flistxattr(fd, value, size);
     if (ret == -1) {
         goto out_err;
     }
@@ -2524,20 +2527,21 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
     fuse_log(FUSE_LOG_DEBUG, "lo_setxattr(ino=%" PRIu64
              ", name=%s value=%s size=%zd)\n", ino, name, value, size);
 
-    if (inode->is_symlink) {
-        /* Sorry, no race free way to setxattr on symlink. */
-        saverr = EPERM;
-        goto out;
-    }
-
     sprintf(procname, "%i", inode->fd);
-    fd = openat(lo->proc_self_fd, procname, O_RDWR);
-    if (fd < 0) {
-        saverr = errno;
-        goto out;
+    if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
+        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
+        if (fd < 0) {
+            saverr = errno;
+            goto out;
+        }
+        ret = fsetxattr(fd, name, value, size, flags);
+    } else {
+        /* fchdir should not fail here */
+        assert(fchdir(lo->proc_self_fd) == 0);
+        ret = setxattr(procname, name, value, size, flags);
+        assert(fchdir(lo->root.fd) == 0);
     }
 
-    ret = fsetxattr(fd, name, value, size, flags);
     saverr = ret == -1 ? errno : 0;
 
     if (!saverr) {
@@ -2575,20 +2579,21 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *name)
     fuse_log(FUSE_LOG_DEBUG, "lo_removexattr(ino=%" PRIu64 ", name=%s)\n", ino,
              name);
 
-    if (inode->is_symlink) {
-        /* Sorry, no race free way to setxattr on symlink. */
-        saverr = EPERM;
-        goto out;
-    }
-
     sprintf(procname, "%i", inode->fd);
-    fd = openat(lo->proc_self_fd, procname, O_RDWR);
-    if (fd < 0) {
-        saverr = errno;
-        goto out;
+    if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
+        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
+        if (fd < 0) {
+            saverr = errno;
+            goto out;
+        }
+        ret = fremovexattr(fd, name);
+    } else {
+        /* fchdir should not fail here */
+        assert(fchdir(lo->proc_self_fd) == 0);
+        ret = removexattr(procname, name);
+        assert(fchdir(lo->root.fd) == 0);
     }
 
-    ret = fremovexattr(fd, name);
     saverr = ret == -1 ? errno : 0;
 
     if (!saverr) {
@@ -3185,7 +3190,7 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
         exit(1);
     }
 
-    root->is_symlink = false;
+    root->filetype = S_IFDIR;
     root->fd = fd;
     root->key.ino = stat.st_ino;
     root->key.dev = stat.st_dev;
diff --git a/tools/virtiofsd/seccomp.c b/tools/virtiofsd/seccomp.c
index 2d9d4a7ec0..bd9e7b083c 100644
--- a/tools/virtiofsd/seccomp.c
+++ b/tools/virtiofsd/seccomp.c
@@ -41,6 +41,7 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(exit),
     SCMP_SYS(exit_group),
     SCMP_SYS(fallocate),
+    SCMP_SYS(fchdir),
     SCMP_SYS(fchmodat),
     SCMP_SYS(fchownat),
     SCMP_SYS(fcntl),
@@ -62,7 +63,9 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(getpid),
     SCMP_SYS(gettid),
     SCMP_SYS(gettimeofday),
+    SCMP_SYS(getxattr),
     SCMP_SYS(linkat),
+    SCMP_SYS(listxattr),
     SCMP_SYS(lseek),
     SCMP_SYS(madvise),
     SCMP_SYS(mkdirat),
@@ -85,6 +88,7 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(recvmsg),
     SCMP_SYS(renameat),
     SCMP_SYS(renameat2),
+    SCMP_SYS(removexattr),
     SCMP_SYS(rt_sigaction),
     SCMP_SYS(rt_sigprocmask),
     SCMP_SYS(rt_sigreturn),
@@ -98,10 +102,12 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(setresuid32),
 #endif
     SCMP_SYS(set_robust_list),
+    SCMP_SYS(setxattr),
     SCMP_SYS(symlinkat),
     SCMP_SYS(time), /* Rarely needed, except on static builds */
     SCMP_SYS(tgkill),
     SCMP_SYS(unlinkat),
+    SCMP_SYS(unshare),
     SCMP_SYS(utimensat),
     SCMP_SYS(write),
     SCMP_SYS(writev),
-- 
2.21.1


