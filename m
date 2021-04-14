From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 14 Apr 2021 16:51:37 +0100
Message-Id: <20210414155137.46522-26-dgilbert@redhat.com>
In-Reply-To: <20210414155137.46522-1-dgilbert@redhat.com>
References: <20210414155137.46522-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 25/25] virtiofsd: Ask qemu to drop CAP_FSETID
	if client asked for it
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, virtio-fs@redhat.com

From: Vivek Goyal <vgoyal@redhat.com>

If qemu guest asked to drop CAP_FSETID upon write, send that info
to qemu in SLAVE_FS_IO message so that qemu can drop capability
before WRITE. This is to make sure that any setuid bit is killed
on fd (if there is one set).

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/buffer.c         | 10 ++++++----
 tools/virtiofsd/fuse_common.h    |  6 +++++-
 tools/virtiofsd/fuse_lowlevel.h  |  6 +++++-
 tools/virtiofsd/fuse_virtio.c    |  5 ++++-
 tools/virtiofsd/passthrough_ll.c |  2 +-
 5 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/tools/virtiofsd/buffer.c b/tools/virtiofsd/buffer.c
index 8135d52d2a..b4cda7db9a 100644
--- a/tools/virtiofsd/buffer.c
+++ b/tools/virtiofsd/buffer.c
@@ -203,7 +203,7 @@ static ssize_t fuse_buf_fd_to_fd(const struct fuse_buf *dst, size_t dst_off,
 static ssize_t fuse_buf_copy_one(fuse_req_t req,
                                  const struct fuse_buf *dst, size_t dst_off,
                                  const struct fuse_buf *src, size_t src_off,
-                                 size_t len)
+                                 size_t len, bool dropped_cap_fsetid)
 {
     int src_is_fd = src->flags & FUSE_BUF_IS_FD;
     int dst_is_fd = dst->flags & FUSE_BUF_IS_FD;
@@ -211,7 +211,8 @@ static ssize_t fuse_buf_copy_one(fuse_req_t req,
     int dst_is_phys = src->flags & FUSE_BUF_PHYS_ADDR;
 
     if (src_is_phys && !src_is_fd && dst_is_fd) {
-        return fuse_virtio_write(req, dst, dst_off, src, src_off, len);
+        return fuse_virtio_write(req, dst, dst_off, src, src_off, len,
+                                 dropped_cap_fsetid);
     }
     assert(!src_is_phys && !dst_is_phys);
     if (!src_is_fd && !dst_is_fd) {
@@ -267,7 +268,7 @@ static int fuse_bufvec_advance(struct fuse_bufvec *bufv, size_t len)
 }
 
 ssize_t fuse_buf_copy(fuse_req_t req, struct fuse_bufvec *dstv,
-                      struct fuse_bufvec *srcv)
+                      struct fuse_bufvec *srcv, bool dropped_cap_fsetid)
 {
     size_t copied = 0, i;
 
@@ -309,7 +310,8 @@ ssize_t fuse_buf_copy(fuse_req_t req, struct fuse_bufvec *dstv,
         dst_len = dst->size - dstv->off;
         len = min_size(src_len, dst_len);
 
-        res = fuse_buf_copy_one(req, dst, dstv->off, src, srcv->off, len);
+        res = fuse_buf_copy_one(req, dst, dstv->off, src, srcv->off, len,
+                                dropped_cap_fsetid);
         if (res < 0) {
             if (!copied) {
                 return res;
diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
index beed03aa93..8a75729be9 100644
--- a/tools/virtiofsd/fuse_common.h
+++ b/tools/virtiofsd/fuse_common.h
@@ -733,10 +733,14 @@ size_t fuse_buf_size(const struct fuse_bufvec *bufv);
  * @param req The request this copy is part of
  * @param dst destination buffer vector
  * @param src source buffer vector
+ * @param dropped_cap_fsetid Caller has dropped CAP_FSETID. If work is handed
+ *        over to a different thread/process, CAP_FSETID needs to be dropped
+ *        there as well.
  * @return actual number of bytes copied or -errno on error
  */
 ssize_t fuse_buf_copy(fuse_req_t req,
-                      struct fuse_bufvec *dst, struct fuse_bufvec *src);
+                      struct fuse_bufvec *dst, struct fuse_bufvec *src,
+                      bool dropped_cap_fsetid);
 
 /**
  * Memory buffer iterator
diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index 24e580aafe..dfd7e1525c 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -2030,9 +2030,13 @@ int64_t fuse_virtio_io(struct fuse_session *se, VhostUserFSSlaveMsg *msg,
  * @param src The source (memory) buffer
  * @param src_off The GPA
  * @param len Length in bytes
+ * @param dropped_cap_fsetid Caller dropped CAP_FSETID. If it is being handed
+ *        over to different thread/process, CAP_FSETID needs to be dropped
+ *        before write.
  */
 ssize_t fuse_virtio_write(fuse_req_t req, const struct fuse_buf *dst,
                           size_t dst_off, const struct fuse_buf *src,
-                          size_t src_off, size_t len);
+                          size_t src_off, size_t len,
+                          bool dropped_cap_fsetid);
 
 #endif /* FUSE_LOWLEVEL_H_ */
diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 887e79a126..525452d036 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -1291,7 +1291,7 @@ int64_t fuse_virtio_io(struct fuse_session *se, VhostUserFSSlaveMsg *msg,
  */
 ssize_t fuse_virtio_write(fuse_req_t req, const struct fuse_buf *dst,
                           size_t dst_off, const struct fuse_buf *src,
-                          size_t src_off, size_t len)
+                          size_t src_off, size_t len, bool dropped_cap_fsetid)
 {
     VhostUserFSSlaveMsg *msg = g_malloc0(sizeof(VhostUserFSSlaveMsg) +
                                          sizeof(VhostUserFSSlaveMsgEntry));
@@ -1311,6 +1311,9 @@ ssize_t fuse_virtio_write(fuse_req_t req, const struct fuse_buf *dst,
     msg->entries[0].c_offset = (uintptr_t)src->mem + src_off;
     msg->entries[0].len = len;
     msg->entries[0].flags = VHOST_USER_FS_FLAG_MAP_W;
+    if (dropped_cap_fsetid) {
+        msg->flags |= VHOST_USER_FS_GENFLAG_DROP_FSETID;
+    }
 
     int64_t result = fuse_virtio_io(req->se, msg, dst->fd);
     fuse_log(FUSE_LOG_DEBUG, "%s: result=%ld\n", __func__, result);
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index b3954376b3..d0fa7de538 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2301,7 +2301,7 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
         }
     }
 
-    res = fuse_buf_copy(req, &out_buf, in_buf);
+    res = fuse_buf_copy(req, &out_buf, in_buf, fi->kill_priv);
     if (res < 0) {
         fuse_reply_err(req, -res);
     } else {
-- 
2.31.1

