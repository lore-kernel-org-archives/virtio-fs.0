From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 22 Jun 2021 11:08:46 -0400
Message-Id: <20210622150852.1507204-2-vgoyal@redhat.com>
In-Reply-To: <20210622150852.1507204-1-vgoyal@redhat.com>
References: <20210622150852.1507204-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v7 1/7] virtiofsd: Fix fuse setxattr() API
	change issue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: miklos@szeredi.hu, vgoyal@redhat.com

With kernel header updates fuse_setxattr_in struct has grown in size.
But this new struct size only takes affect if user has opted in
for fuse feature FUSE_SETXATTR_EXT otherwise fuse continues to
send "fuse_setxattr_in" of older size. Older size is determined
by FUSE_COMPAT_SETXATTR_IN_SIZE.

Fix this. If we have not opted in for FUSE_SETXATTR_EXT, then
expect that we will get fuse_setxattr_in of size FUSE_COMPAT_SETXATTR_IN_SIZE
and not sizeof(struct fuse_sexattr_in).

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_common.h   | 5 +++++
 tools/virtiofsd/fuse_lowlevel.c | 7 ++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
index fa9671872e..0c2665b977 100644
--- a/tools/virtiofsd/fuse_common.h
+++ b/tools/virtiofsd/fuse_common.h
@@ -372,6 +372,11 @@ struct fuse_file_info {
  */
 #define FUSE_CAP_HANDLE_KILLPRIV_V2 (1 << 28)
 
+/**
+ * Indicates that file server supports extended struct fuse_setxattr_in
+ */
+#define FUSE_CAP_SETXATTR_EXT (1 << 29)
+
 /**
  * Ioctl flags
  *
diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 7fe2cef1eb..c2b6ff1686 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -1419,8 +1419,13 @@ static void do_setxattr(fuse_req_t req, fuse_ino_t nodeid,
     struct fuse_setxattr_in *arg;
     const char *name;
     const char *value;
+    bool setxattr_ext = req->se->conn.want & FUSE_CAP_SETXATTR_EXT;
 
-    arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
+    if (setxattr_ext) {
+        arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
+    } else {
+        arg = fuse_mbuf_iter_advance(iter, FUSE_COMPAT_SETXATTR_IN_SIZE);
+    }
     name = fuse_mbuf_iter_advance_str(iter);
     if (!arg || !name) {
         fuse_reply_err(req, EINVAL);
-- 
2.25.4

