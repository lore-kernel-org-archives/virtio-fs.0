From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  9 Feb 2021 19:02:17 +0000
Message-Id: <20210209190224.62827-18-dgilbert@redhat.com>
In-Reply-To: <20210209190224.62827-1-dgilbert@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 17/24] DAX/unmap virtiofsd: Add wrappers for
	VHOST_USER_SLAVE_FS_IO
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Add a wrapper to send VHOST_USER_SLAVE_FS_IO commands and a
further wrapper for sending a fuse_buf write using the FS_IO
slave command.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.h | 25 ++++++++++++++++++++++
 tools/virtiofsd/fuse_virtio.c   | 38 +++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index 53439f5432..af928b262f 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -2012,4 +2012,29 @@ int64_t fuse_virtio_map(fuse_req_t req, VhostUserFSSlaveMsg *msg, int fd);
  */
 int64_t fuse_virtio_unmap(struct fuse_session *se, VhostUserFSSlaveMsg *msg);
 
+/**
+ * For use with virtio-fs; request IO directly to memory
+ *
+ * @param se The current session
+ * @param msg A set of IO requests
+ * @param fd The fd to map
+ * @return Length on success, negative errno on error
+ */
+int64_t fuse_virtio_io(struct fuse_session *se, VhostUserFSSlaveMsg *msg,
+                       int fd);
+
+/**
+ * For use with virtio-fs; wrapper for fuse_virtio_io for writes
+ * from memory to an fd
+ * @param req The request that triggered this action
+ * @param dst The destination (file) memory buffer
+ * @param dst_off Byte offset in the file
+ * @param src The source (memory) buffer
+ * @param src_off The GPA
+ * @param len Length in bytes
+ */
+ssize_t fuse_virtio_write(fuse_req_t req, const struct fuse_buf *dst,
+                          size_t dst_off, const struct fuse_buf *src,
+                          size_t src_off, size_t len);
+
 #endif /* FUSE_LOWLEVEL_H_ */
diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index f217a093c8..8feb3c0261 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -1062,3 +1062,41 @@ int64_t fuse_virtio_unmap(struct fuse_session *se, VhostUserFSSlaveMsg *msg)
     return vu_fs_cache_request(&se->virtio_dev->dev, VHOST_USER_SLAVE_FS_UNMAP,
                                -1, msg);
 }
+
+int64_t fuse_virtio_io(struct fuse_session *se, VhostUserFSSlaveMsg *msg,
+                       int fd)
+{
+    if (!se->virtio_dev) {
+        return -ENODEV;
+    }
+    return vu_fs_cache_request(&se->virtio_dev->dev, VHOST_USER_SLAVE_FS_IO,
+                               fd, msg);
+}
+
+/*
+ * Write to a file (dst) from an area of guest GPA (src) that probably
+ * isn't visible to the daemon.
+ */
+ssize_t fuse_virtio_write(fuse_req_t req, const struct fuse_buf *dst,
+                          size_t dst_off, const struct fuse_buf *src,
+                          size_t src_off, size_t len)
+{
+    VhostUserFSSlaveMsg msg = { 0 };
+
+    if (dst->flags & FUSE_BUF_FD_SEEK) {
+        msg.fd_offset[0] = dst->pos + dst_off;
+    } else {
+        off_t cur = lseek(dst->fd, 0, SEEK_CUR);
+        if (cur == (off_t)-1) {
+            return -errno;
+        }
+        msg.fd_offset[0] = cur;
+    }
+    msg.c_offset[0] = (uintptr_t)src->mem + src_off;
+    msg.len[0] = len;
+    msg.flags[0] = VHOST_USER_FS_FLAG_MAP_W;
+
+    int64_t result = fuse_virtio_io(req->se, &msg, dst->fd);
+    fuse_log(FUSE_LOG_DEBUG, "%s: result=%ld\n", __func__, result);
+    return result;
+}
-- 
2.29.2

