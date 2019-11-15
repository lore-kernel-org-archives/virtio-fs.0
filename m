From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 15 Nov 2019 15:55:42 -0500
Message-Id: <20191115205543.1816-4-vgoyal@redhat.com>
In-Reply-To: <20191115205543.1816-1-vgoyal@redhat.com>
References: <20191115205543.1816-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/4] virtiofsd: Specify size of notification
	buffer using config space
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org
Cc: miklos@szeredi.hu, vgoyal@redhat.com

Daemon specifies size of notification buffer needed and that should be done
using config space.

Only ->notify_buf_size value of config space comes from daemon. Rest of
it is filled by qemu device emulation code.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 contrib/virtiofsd/fuse_virtio.c            | 26 +++++++++++++++++++++-
 hw/virtio/vhost-user-fs.c                  | 26 ++++++++++++++++++++++
 include/hw/virtio/vhost-user-fs.h          |  2 ++
 include/standard-headers/linux/virtio_fs.h |  2 ++
 4 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
index 411114c9b3..982b6ad0bd 100644
--- a/contrib/virtiofsd/fuse_virtio.c
+++ b/contrib/virtiofsd/fuse_virtio.c
@@ -109,7 +109,8 @@ static uint64_t fv_get_features(VuDev *dev)
     uint64_t features;
 
     features = 1ull << VIRTIO_F_VERSION_1 |
-               1ull << VIRTIO_FS_F_NOTIFICATION;
+               1ull << VIRTIO_FS_F_NOTIFICATION |
+               1ull << VHOST_USER_F_PROTOCOL_FEATURES;
 
     return features;
 }
@@ -927,6 +928,27 @@ static bool fv_queue_order(VuDev *dev, int qidx)
     return false;
 }
 
+static uint64_t fv_get_protocol_features(VuDev *dev)
+{
+	return 1ull << VHOST_USER_PROTOCOL_F_CONFIG;
+}
+
+static int fv_get_config(VuDev *dev, uint8_t *config, uint32_t len)
+{
+	struct virtio_fs_config fscfg = {};
+
+	fuse_log(FUSE_LOG_DEBUG, "%s:Setting notify_buf_size=%d\n", __func__,
+                 sizeof(struct fuse_notify_lock_out));
+	/*
+	 * As of now only notification related to lock is supported. As more
+	 * notification types are supported, bump up the size accordingly.
+	 */
+	fscfg.notify_buf_size = sizeof(struct fuse_notify_lock_out);
+
+	memcpy(config, &fscfg, len);
+	return 0;
+}
+
 static const VuDevIface fv_iface = {
     .get_features = fv_get_features,
     .set_features = fv_set_features,
@@ -935,6 +957,8 @@ static const VuDevIface fv_iface = {
     .queue_set_started = fv_queue_set_started,
 
     .queue_is_processed_in_order = fv_queue_order,
+    .get_protocol_features = fv_get_protocol_features,
+    .get_config = fv_get_config,
 };
 
 /*
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 5555fe9dbe..8dd9b1496f 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -277,16 +277,40 @@ uint64_t vhost_user_fs_slave_io(struct vhost_dev *dev, VhostUserFSSlaveMsg *sm,
     return (uint64_t)done;
 }
 
+static int vhost_user_fs_handle_config_change(struct vhost_dev *dev)
+{
+    return 0;
+}
+
+const VhostDevConfigOps fs_ops = {
+    .vhost_dev_config_notifier = vhost_user_fs_handle_config_change,
+};
 
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
+	if (ret < 0) {
+            error_report("vhost-user-fs: get device config space failed."
+                         " ret=%d\n", ret);
+            return;
+        }
+    }
 
     memcpy((char *)fscfg.tag, fs->conf.tag,
            MIN(strlen(fs->conf.tag) + 1, sizeof(fscfg.tag)));
 
     virtio_stl_p(vdev, &fscfg.num_request_queues, fs->conf.num_request_queues);
+    virtio_stl_p(vdev, &fscfg.notify_buf_size, fs->fscfg.notify_buf_size);
 
     memcpy(config, &fscfg, sizeof(fscfg));
 }
@@ -545,6 +569,8 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
     fs->vhost_dev.nvqs = 2 + fs->conf.num_request_queues;
 
     fs->vhost_dev.vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
+
+    vhost_dev_set_config_notifier(&fs->vhost_dev, &fs_ops);
     ret = vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
                          VHOST_BACKEND_TYPE_USER, 0);
     if (ret < 0) {
diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
index bd47e0da98..f667cc4b5a 100644
--- a/include/hw/virtio/vhost-user-fs.h
+++ b/include/hw/virtio/vhost-user-fs.h
@@ -14,6 +14,7 @@
 #ifndef _QEMU_VHOST_USER_FS_H
 #define _QEMU_VHOST_USER_FS_H
 
+#include "standard-headers/linux/virtio_fs.h"
 #include "hw/virtio/virtio.h"
 #include "hw/virtio/vhost.h"
 #include "hw/virtio/vhost-user.h"
@@ -58,6 +59,7 @@ typedef struct {
     struct vhost_virtqueue *vhost_vqs;
     struct vhost_dev vhost_dev;
     VhostUserState vhost_user;
+    struct virtio_fs_config fscfg;
 
     /*< public >*/
     MemoryRegion cache;
diff --git a/include/standard-headers/linux/virtio_fs.h b/include/standard-headers/linux/virtio_fs.h
index 9ee95f584f..719216a262 100644
--- a/include/standard-headers/linux/virtio_fs.h
+++ b/include/standard-headers/linux/virtio_fs.h
@@ -17,6 +17,8 @@ struct virtio_fs_config {
 
 	/* Number of request queues */
 	uint32_t num_request_queues;
+	/* Size of notification buffer */
+	uint32_t notify_buf_size;
 } QEMU_PACKED;
 
 #define VIRTIO_FS_PCI_CACHE_BAR 2
-- 
2.20.1

