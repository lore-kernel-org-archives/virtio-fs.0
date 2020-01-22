From: Xiao Yang <yangx.jy@cn.fujitsu.com>
Date: Wed, 22 Jan 2020 10:40:08 +0800
Message-ID: <20200122024008.28126-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd: Remove unused enum
	fuse_buf_copy_flags
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: dgilbert@redhat.com
Cc: virtio-fs@redhat.com

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 tools/virtiofsd/buffer.c         |  7 +++--
 tools/virtiofsd/fuse_common.h    | 46 +-------------------------------
 tools/virtiofsd/fuse_lowlevel.c  | 13 ++++-----
 tools/virtiofsd/fuse_lowlevel.h  | 35 ++----------------------
 tools/virtiofsd/passthrough_ll.c |  4 +--
 5 files changed, 13 insertions(+), 92 deletions(-)

diff --git a/tools/virtiofsd/buffer.c b/tools/virtiofsd/buffer.c
index 2b3d4d8653..3aefba13d5 100644
--- a/tools/virtiofsd/buffer.c
+++ b/tools/virtiofsd/buffer.c
@@ -207,7 +207,7 @@ static ssize_t fuse_buf_fd_to_fd(const struct fuse_buf *dst, size_t dst_off,
 static ssize_t fuse_buf_copy_one(fuse_req_t req,
                                  const struct fuse_buf *dst, size_t dst_off,
                                  const struct fuse_buf *src, size_t src_off,
-                                 size_t len, enum fuse_buf_copy_flags flags)
+                                 size_t len)
 {
     int src_is_fd = src->flags & FUSE_BUF_IS_FD;
     int dst_is_fd = dst->flags & FUSE_BUF_IS_FD;
@@ -267,7 +267,7 @@ static int fuse_bufvec_advance(struct fuse_bufvec *bufv, size_t len)
 }
 
 ssize_t fuse_buf_copy(fuse_req_t req, struct fuse_bufvec *dstv,
-                      struct fuse_bufvec *srcv, enum fuse_buf_copy_flags flags)
+                      struct fuse_bufvec *srcv)
 {
     size_t copied = 0, i;
 
@@ -309,8 +309,7 @@ ssize_t fuse_buf_copy(fuse_req_t req, struct fuse_bufvec *dstv,
         dst_len = dst->size - dstv->off;
         len = min_size(src_len, dst_len);
 
-        res = fuse_buf_copy_one(req, dst, dstv->off, src, srcv->off, len,
-                                flags);
+        res = fuse_buf_copy_one(req, dst, dstv->off, src, srcv->off, len);
         if (res < 0) {
             if (!copied) {
                 return res;
diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
index c8e3026735..aa7e6ed31a 100644
--- a/tools/virtiofsd/fuse_common.h
+++ b/tools/virtiofsd/fuse_common.h
@@ -617,48 +617,6 @@ enum fuse_buf_flags {
     FUSE_BUF_PHYS_ADDR = (1 << 4),
 };
 
-/**
- * Buffer copy flags
- */
-enum fuse_buf_copy_flags {
-    /**
-     * Don't use splice(2)
-     *
-     * Always fall back to using read and write instead of
-     * splice(2) to copy data from one file descriptor to another.
-     *
-     * If this flag is not set, then only fall back if splice is
-     * unavailable.
-     */
-    FUSE_BUF_NO_SPLICE = (1 << 1),
-
-    /**
-     * Force splice
-     *
-     * Always use splice(2) to copy data from one file descriptor
-     * to another.  If splice is not available, return -EINVAL.
-     */
-    FUSE_BUF_FORCE_SPLICE = (1 << 2),
-
-    /**
-     * Try to move data with splice.
-     *
-     * If splice is used, try to move pages from the source to the
-     * destination instead of copying.  See documentation of
-     * SPLICE_F_MOVE in splice(2) man page.
-     */
-    FUSE_BUF_SPLICE_MOVE = (1 << 3),
-
-    /**
-     * Don't block on the pipe when copying data with splice
-     *
-     * Makes the operations on the pipe non-blocking (if the pipe
-     * is full or empty).  See SPLICE_F_NONBLOCK in the splice(2)
-     * man page.
-     */
-    FUSE_BUF_SPLICE_NONBLOCK = (1 << 4),
-};
-
 /**
  * Single data buffer
  *
@@ -755,12 +713,10 @@ size_t fuse_buf_size(const struct fuse_bufvec *bufv);
  * @param req The request this copy is part of
  * @param dst destination buffer vector
  * @param src source buffer vector
- * @param flags flags controlling the copy
  * @return actual number of bytes copied or -errno on error
  */
 ssize_t fuse_buf_copy(fuse_req_t req,
-                      struct fuse_bufvec *dst, struct fuse_bufvec *src,
-                      enum fuse_buf_copy_flags flags);
+                      struct fuse_bufvec *dst, struct fuse_bufvec *src);
 
 /**
  * Memory buffer iterator
diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 3543cf293c..bba0001a2c 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -511,16 +511,14 @@ static int fuse_send_data_iov_fallback(struct fuse_session *se,
 
 static int fuse_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
                               struct iovec *iov, int iov_count,
-                              struct fuse_bufvec *buf, unsigned int flags)
+                              struct fuse_bufvec *buf)
 {
     size_t len = fuse_buf_size(buf);
-    (void)flags;
 
     return fuse_send_data_iov_fallback(se, ch, iov, iov_count, buf, len);
 }
 
-int fuse_reply_data(fuse_req_t req, struct fuse_bufvec *bufv,
-                    enum fuse_buf_copy_flags flags)
+int fuse_reply_data(fuse_req_t req, struct fuse_bufvec *bufv)
 {
     struct iovec iov[2];
     struct fuse_out_header out = {
@@ -531,7 +529,7 @@ int fuse_reply_data(fuse_req_t req, struct fuse_bufvec *bufv,
     iov[0].iov_base = &out;
     iov[0].iov_len = sizeof(struct fuse_out_header);
 
-    res = fuse_send_data_iov(req->se, req->ch, iov, 1, bufv, flags);
+    res = fuse_send_data_iov(req->se, req->ch, iov, 1, bufv);
     if (res <= 0) {
         fuse_free_req(req);
         return res;
@@ -2344,8 +2342,7 @@ int fuse_lowlevel_notify_delete(struct fuse_session *se, fuse_ino_t parent,
 }
 
 int fuse_lowlevel_notify_store(struct fuse_session *se, fuse_ino_t ino,
-                               off_t offset, struct fuse_bufvec *bufv,
-                               enum fuse_buf_copy_flags flags)
+                               off_t offset, struct fuse_bufvec *bufv)
 {
     struct fuse_out_header out = {
         .error = FUSE_NOTIFY_STORE,
@@ -2367,7 +2364,7 @@ int fuse_lowlevel_notify_store(struct fuse_session *se, fuse_ino_t ino,
     iov[1].iov_base = &outarg;
     iov[1].iov_len = sizeof(outarg);
 
-    res = fuse_send_data_iov(se, NULL, iov, 2, bufv, flags);
+    res = fuse_send_data_iov(se, NULL, iov, 2, bufv);
     if (res > 0) {
         res = -res;
     }
diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index c619c705fd..75d070afe4 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -1388,33 +1388,6 @@ int fuse_reply_buf(fuse_req_t req, const char *buf, size_t size);
 /**
  * Reply with data copied/moved from buffer(s)
  *
- * Zero copy data transfer ("splicing") will be used under
- * the following circumstances:
- *
- * 1. FUSE_CAP_SPLICE_WRITE is set in fuse_conn_info.want, and
- * 2. the kernel supports splicing from the fuse device
- *    (FUSE_CAP_SPLICE_WRITE is set in fuse_conn_info.capable), and
- * 3. *flags* does not contain FUSE_BUF_NO_SPLICE
- * 4. The amount of data that is provided in file-descriptor backed
- *    buffers (i.e., buffers for which bufv[n].flags == FUSE_BUF_FD)
- *    is at least twice the page size.
- *
- * In order for SPLICE_F_MOVE to be used, the following additional
- * conditions have to be fulfilled:
- *
- * 1. FUSE_CAP_SPLICE_MOVE is set in fuse_conn_info.want, and
- * 2. the kernel supports it (i.e, FUSE_CAP_SPLICE_MOVE is set in
-      fuse_conn_info.capable), and
- * 3. *flags* contains FUSE_BUF_SPLICE_MOVE
- *
- * Note that, if splice is used, the data is actually spliced twice:
- * once into a temporary pipe (to prepend header data), and then again
- * into the kernel. If some of the provided buffers are memory-backed,
- * the data in them is copied in step one and spliced in step two.
- *
- * The FUSE_BUF_SPLICE_FORCE_SPLICE and FUSE_BUF_SPLICE_NONBLOCK flags
- * are silently ignored.
- *
  * Possible requests:
  *   read, readdir, getxattr, listxattr
  *
@@ -1425,11 +1398,9 @@ int fuse_reply_buf(fuse_req_t req, const char *buf, size_t size);
  *
  * @param req request handle
  * @param bufv buffer vector
- * @param flags flags controlling the copy
  * @return zero for success, -errno for failure to send reply
  */
-int fuse_reply_data(fuse_req_t req, struct fuse_bufvec *bufv,
-                    enum fuse_buf_copy_flags flags);
+int fuse_reply_data(fuse_req_t req, struct fuse_bufvec *bufv);
 
 /**
  * Reply with data vector
@@ -1730,12 +1701,10 @@ int fuse_lowlevel_notify_delete(struct fuse_session *se, fuse_ino_t parent,
  * @param ino the inode number
  * @param offset the starting offset into the file to store to
  * @param bufv buffer vector
- * @param flags flags controlling the copy
  * @return zero for success, -errno for failure
  */
 int fuse_lowlevel_notify_store(struct fuse_session *se, fuse_ino_t ino,
-                               off_t offset, struct fuse_bufvec *bufv,
-                               enum fuse_buf_copy_flags flags);
+                               off_t offset, struct fuse_bufvec *bufv);
 
 /*
  * Utility functions
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index a87efcf9eb..c0d5655fa8 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2237,7 +2237,7 @@ static void lo_read(fuse_req_t req, fuse_ino_t ino, size_t size, off_t offset,
     buf.buf[0].fd = lo_fi_fd(req, fi);
     buf.buf[0].pos = offset;
 
-    fuse_reply_data(req, &buf, FUSE_BUF_SPLICE_MOVE);
+    fuse_reply_data(req, &buf);
 }
 
 static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
@@ -2270,7 +2270,7 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
         }
     }
 
-    res = fuse_buf_copy(req, &out_buf, in_buf, 0);
+    res = fuse_buf_copy(req, &out_buf, in_buf);
     if (res < 0) {
         fuse_reply_err(req, -res);
     } else {
-- 
2.21.0




