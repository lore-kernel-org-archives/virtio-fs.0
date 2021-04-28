From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 28 Apr 2021 12:00:53 +0100
Message-Id: <20210428110100.27757-20-dgilbert@redhat.com>
In-Reply-To: <20210428110100.27757-1-dgilbert@redhat.com>
References: <20210428110100.27757-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 19/26] DAX/unmap virtiofsd: Add wrappers for
	VHOST_USER_SLAVE_FS_IO
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, groug@kaod.org
Cc: virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Add a wrapper to send VHOST_USER_SLAVE_FS_IO commands and a
further wrapper for sending a fuse_buf write using the FS_IO
slave command.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.h | 25 +++++++++++++++++++
 tools/virtiofsd/fuse_virtio.c   | 43 +++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index 27b07bfc22..757cdae49b 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -2013,4 +2013,29 @@ int64_t fuse_virtio_map(fuse_req_t req, VhostUserFSSlaveMsg *msg, int fd);
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
index 85d90ca595..91317bade8 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -1141,3 +1141,46 @@ int64_t fuse_virtio_unmap(struct fuse_session *se, VhostUserFSSlaveMsg *msg)
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
+    VhostUserFSSlaveMsg *msg = g_malloc0(sizeof(VhostUserFSSlaveMsg) +
+                                         sizeof(VhostUserFSSlaveMsgEntry));
+
+    msg->count = 1;
+
+    if (dst->flags & FUSE_BUF_FD_SEEK) {
+        msg->entries[0].fd_offset = dst->pos + dst_off;
+    } else {
+        off_t cur = lseek(dst->fd, 0, SEEK_CUR);
+        if (cur == (off_t)-1) {
+            g_free(msg);
+            return -errno;
+        }
+        msg->entries[0].fd_offset = cur;
+    }
+    msg->entries[0].c_offset = (uintptr_t)src->mem + src_off;
+    msg->entries[0].len = len;
+    msg->entries[0].flags = VHOST_USER_FS_FLAG_MAP_W;
+
+    int64_t result = fuse_virtio_io(req->se, msg, dst->fd);
+    fuse_log(FUSE_LOG_DEBUG, "%s: result=%" PRId64 " \n", __func__, result);
+    g_free(msg);
+    return result;
+}
-- 
2.31.1

