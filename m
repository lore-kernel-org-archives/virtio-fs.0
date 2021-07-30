From: Max Reitz <mreitz@redhat.com>
Date: Fri, 30 Jul 2021 17:01:30 +0200
Message-Id: <20210730150134.216126-7-mreitz@redhat.com>
In-Reply-To: <20210730150134.216126-1-mreitz@redhat.com>
References: <20210730150134.216126-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 06/10] virtiofsd: Let lo_inode_open() return
	a TempFd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Max Reitz <mreitz@redhat.com>

Strictly speaking, this is not necessary, because lo_inode_open() will
always return a new FD owned by the caller, so TempFd.owned will always
be true.

However, auto-cleanup is nice, and in some cases this plays nicely with
an lo_inode_fd() call in another conditional branch (see lo_setattr()).

Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 138 +++++++++++++------------------
 1 file changed, 59 insertions(+), 79 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 9e1bc37af8..292b7f7e27 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -291,10 +291,8 @@ static void temp_fd_clear(TempFd *temp_fd)
 /**
  * Return an owned fd from *temp_fd that will not be closed when
  * *temp_fd goes out of scope.
- *
- * (TODO: Remove __attribute__ once this is used.)
  */
-static __attribute__((unused)) int temp_fd_steal(TempFd *temp_fd)
+static int temp_fd_steal(TempFd *temp_fd)
 {
     if (temp_fd->owned) {
         temp_fd->owned = false;
@@ -673,9 +671,12 @@ static int lo_fd(fuse_req_t req, fuse_ino_t ino, TempFd *tfd)
  * when a malicious client opens special files such as block device nodes.
  * Symlink inodes are also rejected since symlinks must already have been
  * traversed on the client side.
+ *
+ * The fd is returned in tfd->fd.  The return value is 0 on success and -errno
+ * otherwise.
  */
-static int lo_inode_open(struct lo_data *lo, struct lo_inode *inode,
-                         int open_flags)
+static int lo_inode_open(const struct lo_data *lo, const struct lo_inode *inode,
+                         int open_flags, TempFd *tfd)
 {
     g_autofree char *fd_str = g_strdup_printf("%d", inode->fd);
     int fd;
@@ -694,7 +695,13 @@ static int lo_inode_open(struct lo_data *lo, struct lo_inode *inode,
     if (fd < 0) {
         return -errno;
     }
-    return fd;
+
+    *tfd = (TempFd) {
+        .fd = fd,
+        .owned = true,
+    };
+
+    return 0;
 }
 
 static void lo_init(void *userdata, struct fuse_conn_info *conn)
@@ -852,7 +859,12 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
         return;
     }
 
-    res = lo_inode_fd(inode, &inode_fd);
+    if (!fi && (valid & FUSE_SET_ATTR_SIZE)) {
+        /* We need an O_RDWR FD for ftruncate() */
+        res = lo_inode_open(lo, inode, O_RDWR, &inode_fd);
+    } else {
+        res = lo_inode_fd(inode, &inode_fd);
+    }
     if (res < 0) {
         saverr = -res;
         goto out_err;
@@ -900,18 +912,11 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
         if (fi) {
             truncfd = fd;
         } else {
-            truncfd = lo_inode_open(lo, inode, O_RDWR);
-            if (truncfd < 0) {
-                saverr = -truncfd;
-                goto out_err;
-            }
+            truncfd = inode_fd.fd;
         }
 
         saverr = drop_security_capability(lo, truncfd);
         if (saverr) {
-            if (!fi) {
-                close(truncfd);
-            }
             goto out_err;
         }
 
@@ -919,9 +924,6 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
             res = drop_effective_cap("FSETID", &cap_fsetid_dropped);
             if (res != 0) {
                 saverr = res;
-                if (!fi) {
-                    close(truncfd);
-                }
                 goto out_err;
             }
         }
@@ -934,9 +936,6 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
                 fuse_log(FUSE_LOG_ERR, "Failed to gain CAP_FSETID\n");
             }
         }
-        if (!fi) {
-            close(truncfd);
-        }
         if (res == -1) {
             goto out_err;
         }
@@ -1822,11 +1821,12 @@ static struct lo_dirp *lo_dirp(fuse_req_t req, struct fuse_file_info *fi)
 static void lo_opendir(fuse_req_t req, fuse_ino_t ino,
                        struct fuse_file_info *fi)
 {
+    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
     int error = ENOMEM;
     struct lo_data *lo = lo_data(req);
     struct lo_inode *inode;
     struct lo_dirp *d = NULL;
-    int fd;
+    int res;
     ssize_t fh;
 
     inode = lo_inode(req, ino);
@@ -1840,13 +1840,13 @@ static void lo_opendir(fuse_req_t req, fuse_ino_t ino,
         goto out_err;
     }
 
-    fd = lo_inode_open(lo, inode, O_RDONLY);
-    if (fd < 0) {
-        error = -fd;
+    res = lo_inode_open(lo, inode, O_RDONLY, &inode_fd);
+    if (res < 0) {
+        error = -res;
         goto out_err;
     }
 
-    d->dp = fdopendir(fd);
+    d->dp = fdopendir(temp_fd_steal(&inode_fd));
     if (d->dp == NULL) {
         goto out_errno;
     }
@@ -1876,8 +1876,6 @@ out_err:
     if (d) {
         if (d->dp) {
             closedir(d->dp);
-        } else if (fd != -1) {
-            close(fd);
         }
         free(d);
     }
@@ -2077,6 +2075,7 @@ static void update_open_flags(int writeback, int allow_direct_io,
 static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
                       int existing_fd, struct fuse_file_info *fi)
 {
+    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
     ssize_t fh;
     int fd = existing_fd;
     int err;
@@ -2093,16 +2092,18 @@ static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
             }
         }
 
-        fd = lo_inode_open(lo, inode, fi->flags);
+        err = lo_inode_open(lo, inode, fi->flags, &inode_fd);
 
         if (cap_fsetid_dropped) {
             if (gain_effective_cap("FSETID")) {
                 fuse_log(FUSE_LOG_ERR, "Failed to gain CAP_FSETID\n");
             }
         }
-        if (fd < 0) {
-            return -fd;
+        if (err < 0) {
+            return -err;
         }
+        fd = temp_fd_steal(&inode_fd);
+
         if (fi->flags & (O_TRUNC)) {
             int err = drop_security_capability(lo, fd);
             if (err) {
@@ -2212,8 +2213,9 @@ static struct lo_inode_plock *lookup_create_plock_ctx(struct lo_data *lo,
                                                       uint64_t lock_owner,
                                                       pid_t pid, int *err)
 {
+    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
     struct lo_inode_plock *plock;
-    int fd;
+    int res;
 
     plock =
         g_hash_table_lookup(inode->posix_locks, GUINT_TO_POINTER(lock_owner));
@@ -2230,15 +2232,15 @@ static struct lo_inode_plock *lookup_create_plock_ctx(struct lo_data *lo,
 
     /* Open another instance of file which can be used for ofd locks. */
     /* TODO: What if file is not writable? */
-    fd = lo_inode_open(lo, inode, O_RDWR);
-    if (fd < 0) {
-        *err = -fd;
+    res = lo_inode_open(lo, inode, O_RDWR, &inode_fd);
+    if (res < 0) {
+        *err = -res;
         free(plock);
         return NULL;
     }
 
     plock->lock_owner = lock_owner;
-    plock->fd = fd;
+    plock->fd = temp_fd_steal(&inode_fd);
     g_hash_table_insert(inode->posix_locks, GUINT_TO_POINTER(plock->lock_owner),
                         plock);
     return plock;
@@ -2454,6 +2456,7 @@ static void lo_flush(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
 static void lo_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
                      struct fuse_file_info *fi)
 {
+    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
     struct lo_inode *inode = lo_inode(req, ino);
     struct lo_data *lo = lo_data(req);
     int res;
@@ -2468,11 +2471,12 @@ static void lo_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
     }
 
     if (!fi) {
-        fd = lo_inode_open(lo, inode, O_RDWR);
-        if (fd < 0) {
-            res = -fd;
+        res = lo_inode_open(lo, inode, O_RDWR, &inode_fd);
+        if (res < 0) {
+            res = -res;
             goto out;
         }
+        fd = inode_fd.fd;
     } else {
         fd = lo_fi_fd(req, fi);
     }
@@ -2482,9 +2486,6 @@ static void lo_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
     } else {
         res = fsync(fd) == -1 ? errno : 0;
     }
-    if (!fi) {
-        close(fd);
-    }
 out:
     lo_inode_put(lo, &inode);
     fuse_reply_err(req, res);
@@ -3047,7 +3048,6 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
     struct lo_inode *inode;
     ssize_t ret;
     int saverr;
-    int fd = -1;
 
     if (block_xattr(lo, in_name)) {
         fuse_reply_err(req, EOPNOTSUPP);
@@ -3099,12 +3099,12 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
      * Otherwise, call fchdir() to avoid open().
      */
     if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
-        fd = lo_inode_open(lo, inode, O_RDONLY);
-        if (fd < 0) {
-            saverr = -fd;
+        ret = lo_inode_open(lo, inode, O_RDONLY, &inode_fd);
+        if (ret < 0) {
+            saverr = -ret;
             goto out;
         }
-        ret = fgetxattr(fd, name, value, size);
+        ret = fgetxattr(inode_fd.fd, name, value, size);
         saverr = ret == -1 ? errno : 0;
     } else {
         ret = lo_inode_fd(inode, &inode_fd);
@@ -3133,10 +3133,6 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
         fuse_reply_xattr(req, ret);
     }
 out_free:
-    if (fd >= 0) {
-        close(fd);
-    }
-
     lo_inode_put(lo, &inode);
     return;
 
@@ -3157,7 +3153,6 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
     struct lo_inode *inode;
     ssize_t ret;
     int saverr;
-    int fd = -1;
 
     inode = lo_inode(req, ino);
     if (!inode) {
@@ -3181,12 +3176,12 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
     }
 
     if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
-        fd = lo_inode_open(lo, inode, O_RDONLY);
-        if (fd < 0) {
-            saverr = -fd;
+        ret = lo_inode_open(lo, inode, O_RDONLY, &inode_fd);
+        if (ret < 0) {
+            saverr = -ret;
             goto out;
         }
-        ret = flistxattr(fd, value, size);
+        ret = flistxattr(inode_fd.fd, value, size);
         saverr = ret == -1 ? errno : 0;
     } else {
         ret = lo_inode_fd(inode, &inode_fd);
@@ -3273,10 +3268,6 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
         fuse_reply_xattr(req, ret);
     }
 out_free:
-    if (fd >= 0) {
-        close(fd);
-    }
-
     lo_inode_put(lo, &inode);
     return;
 
@@ -3299,7 +3290,6 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
     struct lo_inode *inode;
     ssize_t ret;
     int saverr;
-    int fd = -1;
     bool switched_creds = false;
     bool cap_fsetid_dropped = false;
     struct lo_cred old = {};
@@ -3345,9 +3335,9 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
      */
     open_inode = S_ISREG(inode->filetype) || S_ISDIR(inode->filetype);
     if (open_inode) {
-        fd = lo_inode_open(lo, inode, O_RDONLY);
-        if (fd < 0) {
-            saverr = -fd;
+        ret = lo_inode_open(lo, inode, O_RDONLY, &inode_fd);
+        if (ret < 0) {
+            saverr = -ret;
             goto out;
         }
     } else {
@@ -3382,8 +3372,7 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
         switched_creds = true;
     }
     if (open_inode) {
-        assert(fd >= 0);
-        ret = fsetxattr(fd, name, value, size, flags);
+        ret = fsetxattr(inode_fd.fd, name, value, size, flags);
         saverr = ret == -1 ? errno : 0;
     } else {
         ret = setxattr(procname, name, value, size, flags);
@@ -3402,10 +3391,6 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
     }
 
 out:
-    if (fd >= 0) {
-        close(fd);
-    }
-
     lo_inode_put(lo, &inode);
     g_free(mapped_name);
     fuse_reply_err(req, saverr);
@@ -3421,7 +3406,6 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
     struct lo_inode *inode;
     ssize_t ret;
     int saverr;
-    int fd = -1;
 
     if (block_xattr(lo, in_name)) {
         fuse_reply_err(req, EOPNOTSUPP);
@@ -3457,12 +3441,12 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
              name);
 
     if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
-        fd = lo_inode_open(lo, inode, O_RDONLY);
-        if (fd < 0) {
-            saverr = -fd;
+        ret = lo_inode_open(lo, inode, O_RDONLY, &inode_fd);
+        if (ret < 0) {
+            saverr = -ret;
             goto out;
         }
-        ret = fremovexattr(fd, name);
+        ret = fremovexattr(inode_fd.fd, name);
         saverr = ret == -1 ? errno : 0;
     } else {
         ret = lo_inode_fd(inode, &inode_fd);
@@ -3479,10 +3463,6 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
     }
 
 out:
-    if (fd >= 0) {
-        close(fd);
-    }
-
     lo_inode_put(lo, &inode);
     g_free(mapped_name);
     fuse_reply_err(req, saverr);
-- 
2.31.1

