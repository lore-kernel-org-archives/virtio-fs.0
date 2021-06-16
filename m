From: Ioannis Angelakopoulos <iangelak@redhat.com>
Date: Wed, 16 Jun 2021 15:39:18 -0400
Message-Id: <20210616193921.608720-4-iangelak@redhat.com>
In-Reply-To: <20210616193921.608720-1-iangelak@redhat.com>
References: <20210616193921.608720-1-iangelak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/6] virtiofsd: Specify size of notification
	buffer using config space
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com

From: Vivek Goyal <vgoyal@redhat.com>

Daemon specifies size of notification buffer needed and that should be
done using config space.

Only ->notify_buf_size value of config space comes from daemon. Rest of
it is filled by qemu device emulation code.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
---
 hw/virtio/vhost-user-fs.c                  | 27 +++++++++++++++++++
 include/hw/virtio/vhost-user-fs.h          |  4 ++-
 include/standard-headers/linux/virtio_fs.h |  2 ++
 tools/virtiofsd/fuse_virtio.c              | 31 ++++++++++++++++++++++
 4 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index c7fd5f3123..f510bd8029 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -36,15 +36,40 @@ static const int user_feature_bits[] = {
     VHOST_INVALID_FEATURE_BIT
 };
 
+static int vhost_user_fs_handle_config_change(struct vhost_dev *dev)
+{
+    return 0;
+}
+
+const VhostDevConfigOps fs_ops = {
+    .vhost_dev_config_notifier = vhost_user_fs_handle_config_change,
+};
+
 static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
     struct virtio_fs_config fscfg = {};
+    int ret;
+
+    /*
+     * As of now we only get notification buffer size from device. And that's
+     * needed only if notification queue is enabled.
+     */
+    if (fs->notify_enabled) {
+        ret = vhost_dev_get_config(&fs->vhost_dev, (uint8_t *)&fs->fscfg,
+                                   sizeof(struct virtio_fs_config));
+        if (ret < 0) {
+            error_report("vhost-user-fs: get device config space failed."
+                         " ret=%d", ret);
+            return;
+        }
+    }
 
     memcpy((char *)fscfg.tag, fs->conf.tag,
            MIN(strlen(fs->conf.tag) + 1, sizeof(fscfg.tag)));
 
     virtio_stl_p(vdev, &fscfg.num_request_queues, fs->conf.num_request_queues);
+    virtio_stl_p(vdev, &fscfg.notify_buf_size, fs->fscfg.notify_buf_size);
 
     memcpy(config, &fscfg, sizeof(fscfg));
 }
@@ -255,6 +280,8 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
     /* 1 high prio queue, 1 notification queue plus the number configured */
     fs->vhost_dev.nvqs = 2 + fs->conf.num_request_queues;
     fs->vhost_dev.vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
+
+    vhost_dev_set_config_notifier(&fs->vhost_dev, &fs_ops);
     ret = vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
                          VHOST_BACKEND_TYPE_USER, 0);
     if (ret < 0) {
diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
index 13e2cbc48e..03780322ee 100644
--- a/include/hw/virtio/vhost-user-fs.h
+++ b/include/hw/virtio/vhost-user-fs.h
@@ -14,6 +14,7 @@
 #ifndef _QEMU_VHOST_USER_FS_H
 #define _QEMU_VHOST_USER_FS_H
 
+#include "standard-headers/linux/virtio_fs.h"
 #include "hw/virtio/virtio.h"
 #include "hw/virtio/vhost.h"
 #include "hw/virtio/vhost-user.h"
@@ -37,11 +38,12 @@ struct VHostUserFS {
     struct vhost_virtqueue *vhost_vqs;
     struct vhost_dev vhost_dev;
     VhostUserState vhost_user;
+    struct virtio_fs_config fscfg;
     VirtQueue **req_vqs;
     VirtQueue *hiprio_vq;
     int32_t bootindex;
-    bool notify_enabled;
     /*< public >*/
+    bool notify_enabled;
 };
 
 #endif /* _QEMU_VHOST_USER_FS_H */
diff --git a/include/standard-headers/linux/virtio_fs.h b/include/standard-headers/linux/virtio_fs.h
index 6383d723a3..8f0075269a 100644
--- a/include/standard-headers/linux/virtio_fs.h
+++ b/include/standard-headers/linux/virtio_fs.h
@@ -17,6 +17,8 @@ struct virtio_fs_config {
 
 	/* Number of request queues */
 	uint32_t num_request_queues;
+	/* Size of notification buffer */
+	uint32_t notify_buf_size;
 } QEMU_PACKED;
 
 /* For the id field in virtio_pci_shm_cap */
diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 3ff4cc1430..f16801bbee 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -851,6 +851,35 @@ static bool fv_queue_order(VuDev *dev, int qidx)
     return false;
 }
 
+static uint64_t fv_get_protocol_features(VuDev *dev)
+{
+    return 1ull << VHOST_USER_PROTOCOL_F_CONFIG;
+}
+
+static int fv_get_config(VuDev *dev, uint8_t *config, uint32_t len)
+{
+    struct virtio_fs_config fscfg = {};
+    unsigned notify_size, roundto = 64;
+    union fuse_notify_union {
+        struct fuse_notify_poll_wakeup_out  wakeup_out;
+        struct fuse_notify_inval_inode_out  inode_out;
+        struct fuse_notify_inval_entry_out  entry_out;
+        struct fuse_notify_delete_out       delete_out;
+        struct fuse_notify_store_out        store_out;
+        struct fuse_notify_retrieve_out     retrieve_out;
+    };
+
+    notify_size = sizeof(struct fuse_out_header) +
+              sizeof(union fuse_notify_union);
+    notify_size = ((notify_size + roundto) / roundto) * roundto;
+
+    fscfg.notify_buf_size = notify_size;
+    memcpy(config, &fscfg, len);
+    fuse_log(FUSE_LOG_DEBUG, "%s:Setting notify_buf_size=%d\n", __func__,
+             fscfg.notify_buf_size);
+    return 0;
+}
+
 static const VuDevIface fv_iface = {
     .get_features = fv_get_features,
     .set_features = fv_set_features,
@@ -859,6 +888,8 @@ static const VuDevIface fv_iface = {
     .queue_set_started = fv_queue_set_started,
 
     .queue_is_processed_in_order = fv_queue_order,
+    .get_protocol_features = fv_get_protocol_features,
+    .get_config = fv_get_config,
 };
 
 /*
-- 
2.27.0

