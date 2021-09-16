From: Hanna Reitz <hreitz@redhat.com>
Date: Thu, 16 Sep 2021 10:40:37 +0200
Message-Id: <20210916084045.31684-5-hreitz@redhat.com>
In-Reply-To: <20210916084045.31684-1-hreitz@redhat.com>
References: <20210916084045.31684-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 04/12] virtiofsd: Use lo_inode_open() instead
	of openat()
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

The xattr functions want a non-O_PATH FD, so they reopen the lo_inode.fd
with the flags they need through /proc/self/fd.

Similarly, lo_opendir() needs an O_RDONLY FD.  Instead of the
/proc/self/fd trick, it just uses openat(fd, "."), because the FD is
guaranteed to be a directory, so this works.

All cases have one problem in common, though: In the future, when we may
have a file handle in the lo_inode instead of an FD, querying an
lo_inode FD may incur an open_by_handle_at() call.  It does not make
sense to then reopen that FD with custom flags, those should have been
passed to open_by_handle_at() instead.

Use lo_inode_open() instead of openat().  As part of the file handle
change, lo_inode_open() will be made to invoke openat() only if
lo_inode.fd is valid.  Otherwise, it will invoke open_by_handle_at()
with the right flags from the start.

Consequently, after this patch, lo_inode_open() is the only place to
invoke openat() to reopen an existing FD with different flags.

Signed-off-by: Hanna Reitz <hreitz@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 47 ++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 88318a4ba9..d76283d080 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -1745,18 +1745,26 @@ static void lo_opendir(fuse_req_t req, fuse_ino_t ino,
 {
     int error = ENOMEM;
     struct lo_data *lo = lo_data(req);
-    struct lo_dirp *d;
+    struct lo_inode *inode;
+    struct lo_dirp *d = NULL;
     int fd;
     ssize_t fh;
 
+    inode = lo_inode(req, ino);
+    if (!inode) {
+        error = EBADF;
+        goto out_err;
+    }
+
     d = calloc(1, sizeof(struct lo_dirp));
     if (d == NULL) {
         goto out_err;
     }
 
-    fd = openat(lo_fd(req, ino), ".", O_RDONLY);
-    if (fd == -1) {
-        goto out_errno;
+    fd = lo_inode_open(lo, inode, O_RDONLY);
+    if (fd < 0) {
+        error = -fd;
+        goto out_err;
     }
 
     d->dp = fdopendir(fd);
@@ -1780,11 +1788,13 @@ static void lo_opendir(fuse_req_t req, fuse_ino_t ino,
         fi->cache_readdir = 1;
     }
     fuse_reply_open(req, fi);
+    lo_inode_put(lo, &inode);
     return;
 
 out_errno:
     error = errno;
 out_err:
+    lo_inode_put(lo, &inode);
     if (d) {
         if (d->dp) {
             closedir(d->dp);
@@ -2989,7 +2999,6 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
         }
     }
 
-    sprintf(procname, "%i", inode->fd);
     /*
      * It is not safe to open() non-regular/non-dir files in file server
      * unless O_PATH is used, so use that method for regular files/dir
@@ -2997,13 +3006,15 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
      * Otherwise, call fchdir() to avoid open().
      */
     if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
-        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
+        fd = lo_inode_open(lo, inode, O_RDONLY);
         if (fd < 0) {
-            goto out_err;
+            saverr = -fd;
+            goto out;
         }
         ret = fgetxattr(fd, name, value, size);
         saverr = ret == -1 ? errno : 0;
     } else {
+        sprintf(procname, "%i", inode->fd);
         /* fchdir should not fail here */
         FCHDIR_NOFAIL(lo->proc_self_fd);
         ret = getxattr(procname, name, value, size);
@@ -3070,15 +3081,16 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
         }
     }
 
-    sprintf(procname, "%i", inode->fd);
     if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
-        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
+        fd = lo_inode_open(lo, inode, O_RDONLY);
         if (fd < 0) {
-            goto out_err;
+            saverr = -fd;
+            goto out;
         }
         ret = flistxattr(fd, value, size);
         saverr = ret == -1 ? errno : 0;
     } else {
+        sprintf(procname, "%i", inode->fd);
         /* fchdir should not fail here */
         FCHDIR_NOFAIL(lo->proc_self_fd);
         ret = listxattr(procname, value, size);
@@ -3175,7 +3187,6 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
                         const char *value, size_t size, int flags,
                         uint32_t extra_flags)
 {
-    char procname[64];
     const char *name;
     char *mapped_name;
     struct lo_data *lo = lo_data(req);
@@ -3221,16 +3232,15 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
     fuse_log(FUSE_LOG_DEBUG, "lo_setxattr(ino=%" PRIu64
              ", name=%s value=%s size=%zd)\n", ino, name, value, size);
 
-    sprintf(procname, "%i", inode->fd);
     /*
      * We can only open regular files or directories.  If the inode is
      * something else, we have to enter /proc/self/fd and use
      * setxattr() on the link's filename there.
      */
     if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
-        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
+        fd = lo_inode_open(lo, inode, O_RDONLY);
         if (fd < 0) {
-            saverr = errno;
+            saverr = -fd;
             goto out;
         }
     } else {
@@ -3264,6 +3274,9 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
         ret = fsetxattr(fd, name, value, size, flags);
         saverr = ret == -1 ? errno : 0;
     } else {
+        char procname[64];
+
+        sprintf(procname, "%i", inode->fd);
         ret = setxattr(procname, name, value, size, flags);
         saverr = ret == -1 ? errno : 0;
     }
@@ -3333,16 +3346,16 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
     fuse_log(FUSE_LOG_DEBUG, "lo_removexattr(ino=%" PRIu64 ", name=%s)\n", ino,
              name);
 
-    sprintf(procname, "%i", inode->fd);
     if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
-        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
+        fd = lo_inode_open(lo, inode, O_RDONLY);
         if (fd < 0) {
-            saverr = errno;
+            saverr = -fd;
             goto out;
         }
         ret = fremovexattr(fd, name);
         saverr = ret == -1 ? errno : 0;
     } else {
+        sprintf(procname, "%i", inode->fd);
         /* fchdir should not fail here */
         FCHDIR_NOFAIL(lo->proc_self_fd);
         ret = removexattr(procname, name);
-- 
2.31.1

