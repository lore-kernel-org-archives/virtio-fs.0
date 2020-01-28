From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Tue, 28 Jan 2020 19:18:18 +0900
Message-ID: <20200128101819.21766-2-misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <20200128101819.21766-1-misono.tomohiro@jp.fujitsu.com>
References: <20200128101819.21766-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 1/2] virtiofsd: Fix xattr operations
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
 1. during setup of each thread, call unshare(CLONE_FS) so that chdir
    would not affect other threads
 2. in xattr operations (i.e. lo_getxattr), use
    fchdir(proc_loot_fd) + ...xattr() + fchdir(root.fd)
    instead of openat() + f...xattr() to avoid open files

With this patch, xfstests generic/062 passes on virtiofs.
This fix is suggested by Miklos Szeredi and Stefan Hajnoczi.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 tools/virtiofsd/fuse_virtio.c    |  13 ++++
 tools/virtiofsd/passthrough_ll.c | 100 +++++++++++++++++++------------
 tools/virtiofsd/seccomp.c        |  10 ++--
 3 files changed, 81 insertions(+), 42 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 1aac6b8687..ad03a7dcc0 100644
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
index f0093ab84e..6bcc33e0eb 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2362,6 +2362,7 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
     ssize_t ret;
     int saverr;
     int fd = -1;
+    bool dir_changed = false;
 
     inode = lo_inode(req, ino);
     if (!inode) {
@@ -2377,17 +2378,14 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
     fuse_log(FUSE_LOG_DEBUG, "lo_getxattr(ino=%" PRIu64 ", name=%s size=%zd)\n",
              ino, name, size);
 
-    if (inode->is_symlink) {
-        /* Sorry, no race free way to getxattr on symlink. */
-        saverr = EPERM;
-        goto out;
-    }
-
     sprintf(procname, "%i", inode->fd);
-    fd = openat(lo->proc_self_fd, procname, O_RDONLY);
-    if (fd < 0) {
+    ret = fchdir(lo->proc_self_fd);
+    if (ret < 0) {
+        /* should not happen */
+        fuse_log(FUSE_LOG_ERR, "lo_getxattr: fail fchdir to proc_self_fd\n");
         goto out_err;
     }
+    dir_changed = true;
 
     if (size) {
         value = malloc(size);
@@ -2395,7 +2393,7 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
             goto out_err;
         }
 
-        ret = fgetxattr(fd, name, value, size);
+        ret = getxattr(procname, name, value, size);
         if (ret == -1) {
             goto out_err;
         }
@@ -2406,7 +2404,7 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
 
         fuse_reply_buf(req, value, ret);
     } else {
-        ret = fgetxattr(fd, name, NULL, 0);
+        ret = getxattr(procname, name, NULL, 0);
         if (ret == -1) {
             goto out_err;
         }
@@ -2420,6 +2418,14 @@ out_free:
         close(fd);
     }
 
+    if (dir_changed) {
+        ret = fchdir(lo->root.fd);
+        if (ret < 0) {
+            /* should not happen */
+            fuse_log(FUSE_LOG_ERR, "lo_getxattr: fail fchdir to root.fd\n");
+        }
+    }
+
     lo_inode_put(lo, &inode);
     return;
 
@@ -2440,6 +2446,7 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
     ssize_t ret;
     int saverr;
     int fd = -1;
+    bool dir_changed = false;
 
     inode = lo_inode(req, ino);
     if (!inode) {
@@ -2455,17 +2462,14 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
     fuse_log(FUSE_LOG_DEBUG, "lo_listxattr(ino=%" PRIu64 ", size=%zd)\n", ino,
              size);
 
-    if (inode->is_symlink) {
-        /* Sorry, no race free way to listxattr on symlink. */
-        saverr = EPERM;
-        goto out;
-    }
-
     sprintf(procname, "%i", inode->fd);
-    fd = openat(lo->proc_self_fd, procname, O_RDONLY);
-    if (fd < 0) {
+    ret = fchdir(lo->proc_self_fd);
+    if (ret < 0) {
+        /* should not happen */
+        fuse_log(FUSE_LOG_ERR, "lo_listxattr: fail fchdir to proc_self_fd\n");
         goto out_err;
     }
+    dir_changed = true;
 
     if (size) {
         value = malloc(size);
@@ -2473,7 +2477,7 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
             goto out_err;
         }
 
-        ret = flistxattr(fd, value, size);
+        ret = listxattr(procname, value, size);
         if (ret == -1) {
             goto out_err;
         }
@@ -2484,7 +2488,7 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
 
         fuse_reply_buf(req, value, ret);
     } else {
-        ret = flistxattr(fd, NULL, 0);
+        ret = listxattr(procname, NULL, 0);
         if (ret == -1) {
             goto out_err;
         }
@@ -2498,6 +2502,14 @@ out_free:
         close(fd);
     }
 
+    if (dir_changed) {
+        ret = fchdir(lo->root.fd);
+        if (ret < 0) {
+            /* should not happen */
+            fuse_log(FUSE_LOG_ERR, "lo_listxattr: fail fchdir to root.fd\n");
+        }
+    }
+
     lo_inode_put(lo, &inode);
     return;
 
@@ -2518,6 +2530,7 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
     ssize_t ret;
     int saverr;
     int fd = -1;
+    bool dir_changed = false;
 
     inode = lo_inode(req, ino);
     if (!inode) {
@@ -2533,20 +2546,17 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
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
+    ret = fchdir(lo->proc_self_fd);
+    if (ret < 0) {
+        /* should not happen */
+        fuse_log(FUSE_LOG_ERR, "lo_setxattr: fail fchdir to proc_self_fd\n");
         saverr = errno;
         goto out;
     }
+    dir_changed = true;
 
-    ret = fsetxattr(fd, name, value, size, flags);
+    ret = setxattr(procname, name, value, size, flags);
     saverr = ret == -1 ? errno : 0;
 
     if (!saverr) {
@@ -2557,6 +2567,14 @@ out:
         close(fd);
     }
 
+    if (dir_changed) {
+        ret = fchdir(lo->root.fd);
+        if (ret < 0) {
+            /* should not happen */
+            fuse_log(FUSE_LOG_ERR, "lo_setxattr: fail fchdir to root.fd\n");
+        }
+    }
+
     lo_inode_put(lo, &inode);
     fuse_reply_err(req, saverr);
 }
@@ -2569,6 +2587,7 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *name)
     ssize_t ret;
     int saverr;
     int fd = -1;
+    bool dir_changed = false;
 
     inode = lo_inode(req, ino);
     if (!inode) {
@@ -2584,20 +2603,17 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *name)
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
+    ret = fchdir(lo->proc_self_fd);
+    if (ret < 0) {
+        /* should not happen */
+        fuse_log(FUSE_LOG_ERR, "lo_removexattr: fail fchdir to proc_self_fd\n");
         saverr = errno;
         goto out;
     }
+    dir_changed = true;
 
-    ret = fremovexattr(fd, name);
+    ret = removexattr(procname, name);
     saverr = ret == -1 ? errno : 0;
 
     if (!saverr) {
@@ -2608,6 +2624,14 @@ out:
         close(fd);
     }
 
+    if (dir_changed) {
+        ret = fchdir(lo->root.fd);
+        if (ret < 0) {
+            /* should not happen */
+            fuse_log(FUSE_LOG_ERR, "lo_removexattr: fail fchdir to root.fd\n");
+        }
+    }
+
     lo_inode_put(lo, &inode);
     fuse_reply_err(req, saverr);
 }
diff --git a/tools/virtiofsd/seccomp.c b/tools/virtiofsd/seccomp.c
index 2d9d4a7ec0..9ee99e4725 100644
--- a/tools/virtiofsd/seccomp.c
+++ b/tools/virtiofsd/seccomp.c
@@ -41,15 +41,12 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(exit),
     SCMP_SYS(exit_group),
     SCMP_SYS(fallocate),
+    SCMP_SYS(fchdir),
     SCMP_SYS(fchmodat),
     SCMP_SYS(fchownat),
     SCMP_SYS(fcntl),
     SCMP_SYS(fdatasync),
-    SCMP_SYS(fgetxattr),
-    SCMP_SYS(flistxattr),
     SCMP_SYS(flock),
-    SCMP_SYS(fremovexattr),
-    SCMP_SYS(fsetxattr),
     SCMP_SYS(fstat),
     SCMP_SYS(fstatfs),
     SCMP_SYS(fsync),
@@ -62,7 +59,9 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(getpid),
     SCMP_SYS(gettid),
     SCMP_SYS(gettimeofday),
+    SCMP_SYS(getxattr),
     SCMP_SYS(linkat),
+    SCMP_SYS(listxattr),
     SCMP_SYS(lseek),
     SCMP_SYS(madvise),
     SCMP_SYS(mkdirat),
@@ -85,6 +84,7 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(recvmsg),
     SCMP_SYS(renameat),
     SCMP_SYS(renameat2),
+    SCMP_SYS(removexattr),
     SCMP_SYS(rt_sigaction),
     SCMP_SYS(rt_sigprocmask),
     SCMP_SYS(rt_sigreturn),
@@ -98,10 +98,12 @@ static const int syscall_whitelist[] = {
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


