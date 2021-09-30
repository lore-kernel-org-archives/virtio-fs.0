From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Sep 2021 11:30:33 -0400
Message-Id: <20210930153037.1194279-10-vgoyal@redhat.com>
In-Reply-To: <20210930153037.1194279-1-vgoyal@redhat.com>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 09/13] virtiofsd: Specify size of notification
	buffer using config space
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, stefanha@redhat.com
Cc: vgoyal@redhat.com, miklos@szeredi.hu

Daemon specifies size of notification buffer needed and that should be
done using config space.

Only ->notify_buf_size value of config space comes from daemon. Rest of
it is filled by qemu device emulation code.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
---
 hw/virtio/vhost-user-fs.c                  | 27 +++++++++++++++++++
 include/hw/virtio/vhost-user-fs.h          |  2 ++
 include/standard-headers/linux/virtio_fs.h |  2 ++
 tools/virtiofsd/fuse_virtio.c              | 31 ++++++++++++++++++++++
 4 files changed, 62 insertions(+)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 6bafcf0243..68a94708b4 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -36,15 +36,41 @@ static const int user_feature_bits[] = {
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
+    Error *local_err = NULL;
+    int ret;
+
+    /*
+     * As of now we only get notification buffer size from device. And that's
+     * needed only if notification queue is enabled.
+     */
+    if (fs->notify_enabled) {
+        ret = vhost_dev_get_config(&fs->vhost_dev, (uint8_t *)&fs->fscfg,
+                                   sizeof(struct virtio_fs_config),
+                                   &local_err);
+        if (ret) {
+            error_report_err(local_err);
+            return;
+        }
+    }
 
     memcpy((char *)fscfg.tag, fs->conf.tag,
            MIN(strlen(fs->conf.tag) + 1, sizeof(fscfg.tag)));
 
     virtio_stl_p(vdev, &fscfg.num_request_queues, fs->conf.num_request_queues);
+    virtio_stl_p(vdev, &fscfg.notify_buf_size, fs->fscfg.notify_buf_size);
 
     memcpy(config, &fscfg, sizeof(fscfg));
 }
@@ -316,6 +342,7 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
                 sizeof(struct virtio_fs_config));
 
     vuf_create_vqs(vdev, true);
+    vhost_dev_set_config_notifier(&fs->vhost_dev, &fs_ops);
     ret = vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
                          VHOST_BACKEND_TYPE_USER, 0, errp);
     if (ret < 0) {
diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
index 95dc0dd402..3b114ee260 100644
--- a/include/hw/virtio/vhost-user-fs.h
+++ b/include/hw/virtio/vhost-user-fs.h
@@ -14,6 +14,7 @@
 #ifndef _QEMU_VHOST_USER_FS_H
 #define _QEMU_VHOST_USER_FS_H
 
+#include "standard-headers/linux/virtio_fs.h"
 #include "hw/virtio/virtio.h"
 #include "hw/virtio/vhost.h"
 #include "hw/virtio/vhost-user.h"
@@ -37,6 +38,7 @@ struct VHostUserFS {
     struct vhost_virtqueue *vhost_vqs;
     struct vhost_dev vhost_dev;
     VhostUserState vhost_user;
+    struct virtio_fs_config fscfg;
     VirtQueue **req_vqs;
     VirtQueue *hiprio_vq;
     VirtQueue *notification_vq;
diff --git a/include/standard-headers/linux/virtio_fs.h b/include/standard-headers/linux/virtio_fs.h
index b7f015186e..867d18acf6 100644
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
index f5b87a508a..3b720c5d4a 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -856,6 +856,35 @@ static bool fv_queue_order(VuDev *dev, int qidx)
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
@@ -864,6 +893,8 @@ static const VuDevIface fv_iface = {
     .queue_set_started = fv_queue_set_started,
 
     .queue_is_processed_in_order = fv_queue_order,
+    .get_protocol_features = fv_get_protocol_features,
+    .get_config = fv_get_config,
 };
 
 /*
-- 
2.31.1

