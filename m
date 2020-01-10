From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Fri, 10 Jan 2020 10:07:22 +0900
Message-ID: <20200110010722.27491-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd: Fix xattr operations
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, vgoyal@redhat.com, stefanha@redhat.com, mszeredi@redhat.com

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

 Note: for a regular file/directory openat() + f...xattr()
       is still used for performance reason. Also we use
       O_RDONLY flag instead of O_RDWR in set/removexattr
       so that direcotry can be opened.

With this patch, xfstests generic/062 passes on virtiofs.
This fix is suggested by Miklos Szeredi and Stefan Hajnoczi.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
Hello,

This aproach is suggested in
https://www.redhat.com/archives/virtio-fs/2019-October/msg00046.html

Thanks,
Misono

 tools/virtiofsd/fuse_virtio.c    |  13 +++
 tools/virtiofsd/passthrough_ll.c | 167 +++++++++++++++++++++++--------
 tools/virtiofsd/seccomp.c        |   6 ++
 3 files changed, 142 insertions(+), 44 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 254b0a71cd..99339e17b2 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -460,6 +460,8 @@ err:
     return ret;
 }
 
+static __thread bool clone_fs_called;
+
 /* Process one FVRequest in a thread pool */
 static void fv_queue_worker(gpointer data, gpointer user_data)
 {
@@ -475,6 +477,17 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
 
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
index 83dd0084b4..5b69048ddd 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -133,6 +133,7 @@ struct lo_inode {
     GHashTable *posix_locks; /* protected by lo_inode->plock_mutex */
 
     bool is_symlink;
+    bool is_regular;
 };
 
 struct lo_cred {
@@ -1038,6 +1039,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         }
 
         inode->is_symlink = S_ISLNK(e->attr.st_mode);
+        inode->is_regular = S_ISREG(e->attr.st_mode) + S_ISDIR(e->attr.st_mode);
 
         /*
          * One for the caller and one for nlookup (released in
@@ -2345,6 +2347,7 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
     ssize_t ret;
     int saverr;
     int fd = -1;
+    bool dir_changed = false;
 
     inode = lo_inode(req, ino);
     if (!inode) {
@@ -2360,16 +2363,20 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
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
-        goto out_err;
+    if (inode->is_regular) {
+        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
+        if (fd < 0) {
+          goto out_err;
+        }
+    } else {
+        ret = fchdir(lo->proc_self_fd);
+        if (ret < 0) {
+            /* should not happen */
+            fuse_log(FUSE_LOG_ERR, "lo_getxattr: fail fchdir to proc_self_fd\n");
+            goto out_err;
+        }
+        dir_changed = true;
     }
 
     if (size) {
@@ -2378,7 +2385,11 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
             goto out_err;
         }
 
-        ret = fgetxattr(fd, name, value, size);
+        if (inode->is_regular) {
+            ret = fgetxattr(fd, name, value, size);
+        } else {
+            ret = getxattr(procname, name, value, size);
+        }
         if (ret == -1) {
             goto out_err;
         }
@@ -2389,7 +2400,11 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
 
         fuse_reply_buf(req, value, ret);
     } else {
-        ret = fgetxattr(fd, name, NULL, 0);
+        if (inode->is_regular) {
+            ret = fgetxattr(fd, name, NULL, 0);
+        } else {
+            ret = getxattr(procname, name, NULL, 0);
+        }
         if (ret == -1) {
             goto out_err;
         }
@@ -2403,6 +2418,14 @@ out_free:
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
 
@@ -2423,6 +2446,7 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
     ssize_t ret;
     int saverr;
     int fd = -1;
+    bool dir_changed = false;
 
     inode = lo_inode(req, ino);
     if (!inode) {
@@ -2438,16 +2462,20 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
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
-        goto out_err;
+    if (inode->is_regular) {
+        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
+        if (fd < 0) {
+          goto out_err;
+        }
+    } else {
+        ret = fchdir(lo->proc_self_fd);
+        if (ret < 0) {
+            /* should not happen */
+            fuse_log(FUSE_LOG_ERR, "lo_listxattr: fail fchdir to proc_self_fd\n");
+            goto out_err;
+        }
+        dir_changed = true;
     }
 
     if (size) {
@@ -2456,7 +2484,11 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
             goto out_err;
         }
 
-        ret = flistxattr(fd, value, size);
+        if (inode->is_regular) {
+            ret = flistxattr(fd, value, size);
+        } else {
+            ret = listxattr(procname, value, size);
+        }
         if (ret == -1) {
             goto out_err;
         }
@@ -2467,7 +2499,11 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
 
         fuse_reply_buf(req, value, ret);
     } else {
-        ret = flistxattr(fd, NULL, 0);
+        if (inode->is_regular) {
+            ret = flistxattr(fd, NULL, 0);
+        } else {
+            ret = listxattr(procname, NULL, 0);
+        }
         if (ret == -1) {
             goto out_err;
         }
@@ -2481,6 +2517,14 @@ out_free:
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
 
@@ -2501,6 +2545,7 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
     ssize_t ret;
     int saverr;
     int fd = -1;
+    bool dir_changed = false;
 
     inode = lo_inode(req, ino);
     if (!inode) {
@@ -2516,20 +2561,28 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
     fuse_log(FUSE_LOG_DEBUG, "lo_setxattr(ino=%" PRIu64,
              ", name=%s value=%s size=%zd)\n", ino, name, value, size);
 
-    if (inode->is_symlink) {
-        /* Sorry, no race free way to removexattr on symlink. */
-        saverr = EPERM;
-        goto out;
-    }
-
     sprintf(procname, "%i", inode->fd);
-    fd = openat(lo->proc_self_fd, procname, O_RDWR);
-    if (fd < 0) {
-        saverr = errno;
-        goto out;
+    if (inode->is_regular) {
+        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
+        if (fd < 0) {
+            saverr = errno;
+            goto out;
+        }
+
+        ret = fsetxattr(fd, name, value, size, flags);
+    } else {
+        ret = fchdir(lo->proc_self_fd);
+        if (ret < 0) {
+            /* should not happen */
+            fuse_log(FUSE_LOG_ERR, "lo_setxattr: fail fchdir to proc_self_fd\n");
+            saverr = errno;
+            goto out;
+        }
+        dir_changed = true;
+
+        ret = setxattr(procname, name, value, size, flags);
     }
 
-    ret = fsetxattr(fd, name, value, size, flags);
     saverr = ret == -1 ? errno : 0;
 
     if (!saverr) {
@@ -2540,6 +2593,14 @@ out:
         close(fd);
     }
 
+    if (dir_changed) {
+        ret = fchdir(lo->root.fd);
+        if (ret < 0) {
+          /* should not happen */
+          fuse_log(FUSE_LOG_ERR, "lo_setxattr: fail fchdir to root.fd\n");
+        }
+    }
+
     lo_inode_put(lo, &inode);
     fuse_reply_err(req, saverr);
 }
@@ -2552,6 +2613,7 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *name)
     ssize_t ret;
     int saverr;
     int fd = -1;
+    bool dir_changed = false;
 
     inode = lo_inode(req, ino);
     if (!inode) {
@@ -2567,20 +2629,28 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *name)
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
+    if (inode->is_regular) {
+        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
+        if (fd < 0) {
+            saverr = errno;
+            goto out;
+        }
+
+        ret = fremovexattr(fd, name);
+    } else {
+        ret = fchdir(lo->proc_self_fd);
+        if (ret < 0) {
+            /* should not happen */
+            fuse_log(FUSE_LOG_ERR, "lo_removexattr: fail fchdir to proc_self_fd\n");
+            saverr = errno;
+            goto out;
+        }
+        dir_changed = true;
+
+        ret = removexattr(procname, name);
     }
 
-    ret = fremovexattr(fd, name);
     saverr = ret == -1 ? errno : 0;
 
     if (!saverr) {
@@ -2591,6 +2661,14 @@ out:
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
@@ -3316,6 +3394,7 @@ int main(int argc, char *argv[])
         lo.source = strdup("/");
     }
     lo.root.is_symlink = false;
+    lo.root.is_regular = true;
     if (!lo.timeout_set) {
         switch (lo.cache) {
         case CACHE_NONE:
diff --git a/tools/virtiofsd/seccomp.c b/tools/virtiofsd/seccomp.c
index 33ec309fc8..87048c239e 100644
--- a/tools/virtiofsd/seccomp.c
+++ b/tools/virtiofsd/seccomp.c
@@ -37,6 +37,7 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(exit),
     SCMP_SYS(exit_group),
     SCMP_SYS(fallocate),
+    SCMP_SYS(fchdir),
     SCMP_SYS(fchmodat),
     SCMP_SYS(fchownat),
     SCMP_SYS(fcntl),
@@ -58,7 +59,9 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(getpid),
     SCMP_SYS(gettid),
     SCMP_SYS(gettimeofday),
+    SCMP_SYS(getxattr),
     SCMP_SYS(linkat),
+    SCMP_SYS(listxattr),
     SCMP_SYS(lseek),
     SCMP_SYS(madvise),
     SCMP_SYS(mkdirat),
@@ -81,6 +84,7 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(recvmsg),
     SCMP_SYS(renameat),
     SCMP_SYS(renameat2),
+    SCMP_SYS(removexattr),
     SCMP_SYS(rt_sigaction),
     SCMP_SYS(rt_sigprocmask),
     SCMP_SYS(rt_sigreturn),
@@ -88,10 +92,12 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(setresgid),
     SCMP_SYS(setresuid),
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


