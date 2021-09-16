From: Hanna Reitz <hreitz@redhat.com>
Date: Thu, 16 Sep 2021 10:40:41 +0200
Message-Id: <20210916084045.31684-9-hreitz@redhat.com>
In-Reply-To: <20210916084045.31684-1-hreitz@redhat.com>
References: <20210916084045.31684-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 08/12] virtiofsd: Pass lo_data to
	lo_inode_{fd, open}()
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

In order to be able to use file handles for identifying lo_inode
objects, we will add some global state to lo_data, which we will need in
a future function to be called from lo_inode_fd() and lo_inode_open().

To prepare for this, pass a (non-const) lo_data pointer to lo_inode_fd()
and lo_inode_open().

Signed-off-by: Hanna Reitz <hreitz@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 34 +++++++++++++++++---------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index d257eda129..bc3b803d46 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -647,7 +647,8 @@ static struct lo_inode *lo_inode(fuse_req_t req, fuse_ino_t ino)
     return elem->inode;
 }
 
-static int lo_inode_fd(const struct lo_inode *inode, TempFd *tfd)
+static int lo_inode_fd(struct lo_data *lo, const struct lo_inode *inode,
+                       TempFd *tfd)
 {
     *tfd = (TempFd) {
         .fd = inode->fd,
@@ -665,15 +666,16 @@ static int lo_inode_fd(const struct lo_inode *inode, TempFd *tfd)
 static int lo_fd(fuse_req_t req, fuse_ino_t ino, TempFd *tfd)
 {
     struct lo_inode *inode = lo_inode(req, ino);
+    struct lo_data *lo = lo_data(req);
     int res;
 
     if (!inode) {
         return -EBADF;
     }
 
-    res = lo_inode_fd(inode, tfd);
+    res = lo_inode_fd(lo, inode, tfd);
 
-    lo_inode_put(lo_data(req), &inode);
+    lo_inode_put(lo, &inode);
     return res;
 }
 
@@ -881,7 +883,7 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
             temp_fd_copy(&rw_fd, &path_fd);
         }
     } else {
-        res = lo_inode_fd(inode, &path_fd);
+        res = lo_inode_fd(lo, inode, &path_fd);
     }
     if (res < 0) {
         saverr = -res;
@@ -1128,7 +1130,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         name = ".";
     }
 
-    res = lo_inode_fd(dir, &dir_path_fd);
+    res = lo_inode_fd(lo, dir, &dir_path_fd);
     if (res < 0) {
         saverr = -res;
         goto out;
@@ -1383,7 +1385,7 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
         return;
     }
 
-    res = lo_inode_fd(dir, &dir_path_fd);
+    res = lo_inode_fd(lo, dir, &dir_path_fd);
     if (res < 0) {
         saverr = -res;
         goto out;
@@ -1469,13 +1471,13 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
         goto out;
     }
 
-    res = lo_inode_fd(inode, &path_fd);
+    res = lo_inode_fd(lo, inode, &path_fd);
     if (res < 0) {
         saverr = -res;
         goto out;
     }
 
-    res = lo_inode_fd(parent_inode, &parent_path_fd);
+    res = lo_inode_fd(lo, parent_inode, &parent_path_fd);
     if (res < 0) {
         saverr = -res;
         goto out;
@@ -1535,7 +1537,7 @@ static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
         goto out;
     }
 
-    res = lo_inode_fd(dir, &dir_path_fd);
+    res = lo_inode_fd(lo, dir, &dir_path_fd);
     if (res < 0) {
         goto out;
     }
@@ -1627,13 +1629,13 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
         goto out;
     }
 
-    res = lo_inode_fd(parent_inode, &parent_path_fd);
+    res = lo_inode_fd(lo, parent_inode, &parent_path_fd);
     if (res < 0) {
         fuse_reply_err(req, -res);
         goto out;
     }
 
-    res = lo_inode_fd(newparent_inode, &newparent_path_fd);
+    res = lo_inode_fd(lo, newparent_inode, &newparent_path_fd);
     if (res < 0) {
         fuse_reply_err(req, -res);
         goto out;
@@ -2181,7 +2183,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
         return;
     }
 
-    err = lo_inode_fd(parent_inode, &parent_path_fd);
+    err = lo_inode_fd(lo, parent_inode, &parent_path_fd);
     if (err < 0) {
         err = -err;
         goto out;
@@ -3135,7 +3137,7 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
     } else {
         g_auto(TempFd) path_fd = TEMP_FD_INIT;
 
-        ret = lo_inode_fd(inode, &path_fd);
+        ret = lo_inode_fd(lo, inode, &path_fd);
         if (ret < 0) {
             saverr = -ret;
             goto out;
@@ -3215,7 +3217,7 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
     } else {
         g_auto(TempFd) path_fd = TEMP_FD_INIT;
 
-        ret = lo_inode_fd(inode, &path_fd);
+        ret = lo_inode_fd(lo, inode, &path_fd);
         if (ret < 0) {
             saverr = -ret;
             goto out;
@@ -3371,7 +3373,7 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
             goto out;
         }
     } else {
-        ret = lo_inode_fd(inode, &path_fd);
+        ret = lo_inode_fd(lo, inode, &path_fd);
         if (ret < 0) {
             saverr = -ret;
             goto out;
@@ -3486,7 +3488,7 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
     } else {
         g_auto(TempFd) path_fd = TEMP_FD_INIT;
 
-        ret = lo_inode_fd(inode, &path_fd);
+        ret = lo_inode_fd(lo, inode, &path_fd);
         if (ret < 0) {
             saverr = -ret;
             goto out;
-- 
2.31.1

