From: Hanna Reitz <hreitz@redhat.com>
Date: Thu, 16 Sep 2021 10:40:39 +0200
Message-Id: <20210916084045.31684-7-hreitz@redhat.com>
In-Reply-To: <20210916084045.31684-1-hreitz@redhat.com>
References: <20210916084045.31684-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 06/12] virtiofsd: Let lo_fd() return a TempFd
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

Accessing lo_inode.fd must generally happen through lo_inode_fd(), and
lo_fd() is no exception; and then it must pass on the TempFd it has
received from lo_inode_fd().

(Note that all lo_fd() calls now use proper error handling, where all of
them were in-line before; i.e. they were used in place of the fd
argument of some function call.  This only worked because the only error
that could occur was that lo_inode() failed to find the inode ID: Then
-1 would be passed as the fd, which would result in an EBADF error,
which is precisely what we would want to return to the guest for an
invalid inode ID.
Now, though, lo_inode_fd() might potentially invoke open_by_handle_at(),
which can return many different errors, and they should be properly
handled and returned to the guest.  So we can no longer allow lo_fd() to
be used in-line, and instead need to do proper error handling for it.)

Signed-off-by: Hanna Reitz <hreitz@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 55 +++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 11 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index c5baa752e4..3bf20b8659 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -666,18 +666,19 @@ static int lo_inode_fd(const struct lo_inode *inode, TempFd *tfd)
  * they are done with the fd.  This will be done in a later patch to make
  * review easier.
  */
-static int lo_fd(fuse_req_t req, fuse_ino_t ino)
+static int lo_fd(fuse_req_t req, fuse_ino_t ino, TempFd *tfd)
 {
     struct lo_inode *inode = lo_inode(req, ino);
-    int fd;
+    int res;
 
     if (!inode) {
-        return -1;
+        return -EBADF;
     }
 
-    fd = inode->fd;
+    res = lo_inode_fd(inode, tfd);
+
     lo_inode_put(lo_data(req), &inode);
-    return fd;
+    return res;
 }
 
 /*
@@ -814,14 +815,19 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
 static void lo_getattr(fuse_req_t req, fuse_ino_t ino,
                        struct fuse_file_info *fi)
 {
+    g_auto(TempFd) path_fd = TEMP_FD_INIT;
     int res;
     struct stat buf;
     struct lo_data *lo = lo_data(req);
 
     (void)fi;
 
-    res =
-        fstatat(lo_fd(req, ino), "", &buf, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+    res = lo_fd(req, ino, &path_fd);
+    if (res < 0) {
+        return (void)fuse_reply_err(req, -res);
+    }
+
+    res = fstatat(path_fd.fd, "", &buf, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
     if (res == -1) {
         return (void)fuse_reply_err(req, errno);
     }
@@ -1547,6 +1553,7 @@ out:
 
 static void lo_rmdir(fuse_req_t req, fuse_ino_t parent, const char *name)
 {
+    g_auto(TempFd) parent_path_fd = TEMP_FD_INIT;
     int res;
     struct lo_inode *inode;
     struct lo_data *lo = lo_data(req);
@@ -1561,13 +1568,19 @@ static void lo_rmdir(fuse_req_t req, fuse_ino_t parent, const char *name)
         return;
     }
 
+    res = lo_fd(req, parent, &parent_path_fd);
+    if (res < 0) {
+        fuse_reply_err(req, -res);
+        return;
+    }
+
     inode = lookup_name(req, parent, name);
     if (!inode) {
         fuse_reply_err(req, EIO);
         return;
     }
 
-    res = unlinkat(lo_fd(req, parent), name, AT_REMOVEDIR);
+    res = unlinkat(parent_path_fd.fd, name, AT_REMOVEDIR);
 
     fuse_reply_err(req, res == -1 ? errno : 0);
     unref_inode_lolocked(lo, inode, 1);
@@ -1653,6 +1666,7 @@ out:
 
 static void lo_unlink(fuse_req_t req, fuse_ino_t parent, const char *name)
 {
+    g_auto(TempFd) parent_path_fd = TEMP_FD_INIT;
     int res;
     struct lo_inode *inode;
     struct lo_data *lo = lo_data(req);
@@ -1667,13 +1681,19 @@ static void lo_unlink(fuse_req_t req, fuse_ino_t parent, const char *name)
         return;
     }
 
+    res = lo_fd(req, parent, &parent_path_fd);
+    if (res < 0) {
+        fuse_reply_err(req, -res);
+        return;
+    }
+
     inode = lookup_name(req, parent, name);
     if (!inode) {
         fuse_reply_err(req, EIO);
         return;
     }
 
-    res = unlinkat(lo_fd(req, parent), name, 0);
+    res = unlinkat(parent_path_fd.fd, name, 0);
 
     fuse_reply_err(req, res == -1 ? errno : 0);
     unref_inode_lolocked(lo, inode, 1);
@@ -1753,10 +1773,16 @@ static void lo_forget_multi(fuse_req_t req, size_t count,
 
 static void lo_readlink(fuse_req_t req, fuse_ino_t ino)
 {
+    g_auto(TempFd) path_fd = TEMP_FD_INIT;
     char buf[PATH_MAX + 1];
     int res;
 
-    res = readlinkat(lo_fd(req, ino), "", buf, sizeof(buf));
+    res = lo_fd(req, ino, &path_fd);
+    if (res < 0) {
+        return (void)fuse_reply_err(req, -res);
+    }
+
+    res = readlinkat(path_fd.fd, "", buf, sizeof(buf));
     if (res == -1) {
         return (void)fuse_reply_err(req, errno);
     }
@@ -2554,10 +2580,17 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
 
 static void lo_statfs(fuse_req_t req, fuse_ino_t ino)
 {
+    g_auto(TempFd) path_fd = TEMP_FD_INIT;
     int res;
     struct statvfs stbuf;
 
-    res = fstatvfs(lo_fd(req, ino), &stbuf);
+    res = lo_fd(req, ino, &path_fd);
+    if (res < 0) {
+        fuse_reply_err(req, -res);
+        return;
+    }
+
+    res = fstatvfs(path_fd.fd, &stbuf);
     if (res == -1) {
         fuse_reply_err(req, errno);
     } else {
-- 
2.31.1

