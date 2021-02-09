From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  9 Feb 2021 19:02:04 +0000
Message-Id: <20210209190224.62827-5-dgilbert@redhat.com>
In-Reply-To: <20210209190224.62827-1-dgilbert@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 04/24] DAX subprojects/libvhost-user: Add
	virtio-fs slave types
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

Add virtio-fs definitions to libvhost-user

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 subprojects/libvhost-user/libvhost-user.c | 41 +++++++++++++++++++++++
 subprojects/libvhost-user/libvhost-user.h | 31 +++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/subprojects/libvhost-user/libvhost-user.c b/subprojects/libvhost-user/libvhost-user.c
index 68eb165755..b35abdd9f9 100644
--- a/subprojects/libvhost-user/libvhost-user.c
+++ b/subprojects/libvhost-user/libvhost-user.c
@@ -2918,3 +2918,44 @@ vu_queue_push(VuDev *dev, VuVirtq *vq,
     vu_queue_flush(dev, vq, 1);
     vu_queue_inflight_post_put(dev, vq, elem->index);
 }
+
+int64_t vu_fs_cache_request(VuDev *dev, VhostUserSlaveRequest req, int fd,
+                            VhostUserFSSlaveMsg *fsm)
+{
+    int fd_num = 0;
+    bool res;
+    uint64_t payload = 0;
+    VhostUserMsg vmsg = {
+        .request = req,
+        .flags = VHOST_USER_VERSION | VHOST_USER_NEED_REPLY_MASK,
+        .size = sizeof(vmsg.payload.fs),
+        .payload.fs = *fsm,
+    };
+
+    if (fd != -1) {
+        vmsg.fds[fd_num++] = fd;
+    }
+
+    vmsg.fd_num = fd_num;
+
+    if (!vu_has_protocol_feature(dev, VHOST_USER_PROTOCOL_F_SLAVE_SEND_FD)) {
+        return -EINVAL;
+    }
+
+    pthread_mutex_lock(&dev->slave_mutex);
+    if (!vu_message_write(dev, dev->slave_fd, &vmsg)) {
+        pthread_mutex_unlock(&dev->slave_mutex);
+        return -EIO;
+    }
+
+    /* Also unlocks the slave_mutex */
+    res = vu_process_message_reply(dev, &vmsg, &payload);
+    if (!res) {
+        return -EIO;
+    }
+    /*
+     * Payload is delivered as uint64_t but is actually signed for
+     * errors.
+     */
+    return (int64_t)payload;
+}
diff --git a/subprojects/libvhost-user/libvhost-user.h b/subprojects/libvhost-user/libvhost-user.h
index 330b61c005..e12e9c1532 100644
--- a/subprojects/libvhost-user/libvhost-user.h
+++ b/subprojects/libvhost-user/libvhost-user.h
@@ -122,6 +122,24 @@ typedef enum VhostUserSlaveRequest {
     VHOST_USER_SLAVE_MAX
 }  VhostUserSlaveRequest;
 
+/* Structures carried over the slave channel back to QEMU */
+#define VHOST_USER_FS_SLAVE_ENTRIES 8
+
+/* For the flags field of VhostUserFSSlaveMsg */
+#define VHOST_USER_FS_FLAG_MAP_R (1ull << 0)
+#define VHOST_USER_FS_FLAG_MAP_W (1ull << 1)
+
+typedef struct {
+    /* Offsets within the file being mapped */
+    uint64_t fd_offset[VHOST_USER_FS_SLAVE_ENTRIES];
+    /* Offsets within the cache */
+    uint64_t c_offset[VHOST_USER_FS_SLAVE_ENTRIES];
+    /* Lengths of sections */
+    uint64_t len[VHOST_USER_FS_SLAVE_ENTRIES];
+    /* Flags, from VHOST_USER_FS_FLAG_* */
+    uint64_t flags[VHOST_USER_FS_SLAVE_ENTRIES];
+} VhostUserFSSlaveMsg;
+
 typedef struct VhostUserMemoryRegion {
     uint64_t guest_phys_addr;
     uint64_t memory_size;
@@ -197,6 +215,7 @@ typedef struct VhostUserMsg {
         VhostUserConfig config;
         VhostUserVringArea area;
         VhostUserInflight inflight;
+        VhostUserFSSlaveMsg fs;
     } payload;
 
     int fds[VHOST_MEMORY_BASELINE_NREGIONS];
@@ -693,4 +712,16 @@ void vu_queue_get_avail_bytes(VuDev *vdev, VuVirtq *vq, unsigned int *in_bytes,
 bool vu_queue_avail_bytes(VuDev *dev, VuVirtq *vq, unsigned int in_bytes,
                           unsigned int out_bytes);
 
+/**
+ * vu_fs_cache_request: Send a slave message for an fs client
+ * @dev: a VuDev context
+ * @req: The request type (map, unmap, sync)
+ * @fd: an fd (only required for map, else must be -1)
+ * @fsm: The body of the message
+ *
+ * Returns: 0 or above for success, nevative errno on error
+ */
+int64_t vu_fs_cache_request(VuDev *dev, VhostUserSlaveRequest req, int fd,
+                            VhostUserFSSlaveMsg *fsm);
+
 #endif /* LIBVHOST_USER_H */
-- 
2.29.2

