DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=bytedance-com.20150623.gappssmtp.com; s=20150623;
	h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding;
	bh=SbwLdnYFbldU/6OiAnqS9qxT8bWYDXg0lrx9mudL7VA=;
	b=YITaapSk8bmSOwULFrSW0pKa23yGgrrZlcyiDyZfQjwWP4HRfmXSMHnmoN04iWV4Wj
	xwvEP/pznzlMwxiHnedxTRaYMI0OC8/H67bfwAPC3NUxbjLblr4siIqipqmxiLINlcIe
	1Arq62MKCy1OQd3zf+9kW2/mde01fJBcOxwi9X/6h1JJsFur5YDZtcMLRBef6nBx5Pv0
	kmbRrSlZnvI8+2UGBYNCvD1N3JCG9fJ73ub6icY0FcL4nESagwd7Cy/o/FIlhu4s4yqA
	bdNIZE3xuEddhb6PLIbHYFV728l8Ktv5QUWeXXcJV/VUABCQx4g12dWZLu377uisGob/
	wVcQ==
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Date: Wed, 16 Dec 2020 00:21:12 +0800
Message-Id: <20201215162119.27360-3-zhangjiachen.jaycee@bytedance.com>
In-Reply-To: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH 2/9] vhost: Add vhost-user message types for
	sending shared memory and file fds
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr . David Alan Gilbert" <dgilbert@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Xie Yongji <xieyongji@bytedance.com>
Cc: virtio-fs@redhat.com, Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>, qemu-devel@nongnu.org

This commit adds 4 new vhost-user message types,
    VHOST_USER_SET_SHM (41),
    VHOST_USER_SET_FD (42),
    VHOST_USER_SLAVE_SHM (slave type, 6),
    VHOST_USER_SLAVE_FD (slave type, 7),
and a vhost-user protocol feature,
    VHOST_USER_PROTOCOL_F_MAP_SHMFD (17).

They can be used by vhost-user devices or backend daemon to persist/restore
shared memory regions and opened file descriptors to/from QEMU.

This commit first implements 2 handlers for the 2 new slave message types
(vhost_user_slave_handle_shm and vhost_user_slave_handle_fd), then
implements some common interfaces for devices to use VHOST_USER_SET_SHM and
VHOST_USER_SET_FD (vhost_dev_set_shm and vhost_dev_set_fd).

This commit also defines some callback interfaces, which can be registered by
arbitrary vhost devices. (VhostDevShmOps is for VHOST_USER_SET_SHM and
VHOST_USER_SLAVE_SHM, and VhostDevFdOps is for VHOST_USER_SET_FD and
VHOST_USER_SLAVE_FD.)

The following commits will use the 4 new message types  to implement virtiofsd
crash reconnection.

Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 docs/interop/vhost-user.rst       |  41 ++++++++++
 hw/virtio/vhost-user.c            | 123 ++++++++++++++++++++++++++++++
 hw/virtio/vhost.c                 |  42 ++++++++++
 include/hw/virtio/vhost-backend.h |   6 ++
 include/hw/virtio/vhost.h         |  42 ++++++++++
 5 files changed, 254 insertions(+)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index 988f154144..515c879bd3 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -817,6 +817,7 @@ Protocol features
   #define VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS 14
   #define VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS  15
   #define VHOST_USER_PROTOCOL_F_STATUS               16
+  #define VHOST_USER_PROTOCOL_F_MAP_SHMFD            17
 
 Master message types
 --------------------
@@ -1330,6 +1331,26 @@ Master message types
   query the backend for its device status as defined in the Virtio
   specification.
 
+``VHOST_USER_SET_SHM``
+  :id: 41
+  :equivalent ioctl: N/A
+  :master payload: shared memory destription
+  :slave payload: N/A
+
+  When slave has ``VHOST_USER_PROTOCOL_F_MAP_SHMFD`` protocol feature, a
+  memfd is provided in the ancillary data of ``VHOST_USER_SET_SHM`` message,
+  the shared memory destription (ID, size and offset) is also provided in
+  the message.
+
+``VHOST_USER_SET_FD``
+  :id: 42
+  :equivalent ioctl: N/A
+  :master payload: fd destription
+  :slave payload: N/A
+
+  A fd is provided in the ancillary data of ``VHOST_USER_SET_FD`` message,
+  the fd destription (a unique key and an operation flag) is also provided
+  in the message.
 
 Slave message types
 -------------------
@@ -1415,6 +1436,26 @@ Slave message types
 
   The state.num field is currently reserved and must be set to 0.
 
+``VHOST_USER_SLAVE_SHM``
+  :id: 6
+  :equivalent ioctl: N/A
+  :master payload: shared memory destription
+  :master payload: N/A
+
+  A memfd is provided in the ancillary data of ``VHOST_USER_SLAVE_SHM``
+  message, the shared memory destription (ID, size and offset) is also
+  provided in the message.
+
+``VHOST_USER_SLAVE_FD``
+  :id: 7
+  :equivalent ioctl: N/A
+  :master payload: fd destription
+  :slave payload: N/A
+
+  A fd is provided in the ancillary data of ``VHOST_USER_SLAVE_FD`` message,
+  the fd destription (a unique key and an operation flag) is also provided
+  in the message.
+
 .. _reply_ack:
 
 VHOST_USER_PROTOCOL_F_REPLY_ACK
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 9c5b4f7fbc..2b5170e921 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -79,6 +79,7 @@ enum VhostUserProtocolFeature {
     VHOST_USER_PROTOCOL_F_RESET_DEVICE = 13,
     /* Feature 14 reserved for VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS. */
     VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS = 15,
+    VHOST_USER_PROTOCOL_F_MAP_SHMFD = 17,
     VHOST_USER_PROTOCOL_F_MAX
 };
 
@@ -124,6 +125,8 @@ typedef enum VhostUserRequest {
     VHOST_USER_GET_MAX_MEM_SLOTS = 36,
     VHOST_USER_ADD_MEM_REG = 37,
     VHOST_USER_REM_MEM_REG = 38,
+    VHOST_USER_SET_SHM = 41,
+    VHOST_USER_SET_FD = 42,
     VHOST_USER_MAX
 } VhostUserRequest;
 
@@ -132,6 +135,10 @@ typedef enum VhostUserSlaveRequest {
     VHOST_USER_SLAVE_IOTLB_MSG = 1,
     VHOST_USER_SLAVE_CONFIG_CHANGE_MSG = 2,
     VHOST_USER_SLAVE_VRING_HOST_NOTIFIER_MSG = 3,
+    VHOST_USER_SLAVE_VRING_CALL = 4,
+    VHOST_USER_SLAVE_VRING_ERR = 5,
+    VHOST_USER_SLAVE_SHM = 6,
+    VHOST_USER_SLAVE_FD = 7,
     VHOST_USER_SLAVE_MAX
 }  VhostUserSlaveRequest;
 
@@ -218,6 +225,8 @@ typedef union {
         VhostUserCryptoSession session;
         VhostUserVringArea area;
         VhostUserInflight inflight;
+        VhostUserShm shm;
+        VhostUserFd fdinfo;
 } VhostUserPayload;
 
 typedef struct VhostUserMsg {
@@ -1393,6 +1402,36 @@ static int vhost_user_slave_handle_vring_host_notifier(struct vhost_dev *dev,
     return 0;
 }
 
+static int vhost_user_slave_handle_shm(struct vhost_dev *dev,
+                                       VhostUserShm *shm, int fd)
+{
+    int ret;
+
+    if (!dev->shm_ops) {
+        return -1;
+    }
+
+    if (dev->shm_ops->vhost_dev_slave_shm) {
+        ret = dev->shm_ops->vhost_dev_slave_shm(dev, shm, fd);
+    }
+    return ret;
+}
+
+static int vhost_user_slave_handle_fd(struct vhost_dev *dev,
+                                      VhostUserFd *fdinfo, int fd)
+{
+    int ret;
+    if (!dev->fd_ops) {
+        return -1;
+    }
+
+    if (dev->fd_ops->vhost_dev_slave_fd) {
+        ret = dev->fd_ops->vhost_dev_slave_fd(dev, fdinfo, fd);
+    }
+
+    return ret;
+}
+
 static void slave_read(void *opaque)
 {
     struct vhost_dev *dev = opaque;
@@ -1471,6 +1510,12 @@ static void slave_read(void *opaque)
         ret = vhost_user_slave_handle_vring_host_notifier(dev, &payload.area,
                                                           fd[0]);
         break;
+    case VHOST_USER_SLAVE_SHM:
+        ret = vhost_user_slave_handle_shm(dev, &payload.shm, fd[0]);
+        break;
+    case VHOST_USER_SLAVE_FD:
+        ret = vhost_user_slave_handle_fd(dev, &payload.fdinfo, fd[0]);
+        break;
     default:
         error_report("Received unexpected msg type: %d.", hdr.request);
         ret = -EINVAL;
@@ -2325,6 +2370,82 @@ static int vhost_user_set_inflight_fd(struct vhost_dev *dev,
     return 0;
 }
 
+
+/* The maximum shm number of a vhost-user deviceis MAX_SHM_NUM */
+#define MAX_SHM_NUM 128
+
+static int vhost_user_set_shm(struct vhost_dev *dev)
+{
+    int i;
+    int ret;
+    int memfd;
+    if (!dev->fd_ops) {
+        return -1;
+    }
+
+    if (!virtio_has_feature(dev->protocol_features,
+                            VHOST_USER_PROTOCOL_F_MAP_SHMFD)) {
+        return 0;
+    }
+
+    if (dev->shm_ops->vhost_dev_shm_info) {
+        for (i = 0; i < MAX_SHM_NUM; i++) {
+            VhostUserMsg msg = {
+                .hdr.request = VHOST_USER_SET_SHM,
+                .hdr.flags = VHOST_USER_VERSION,
+                .hdr.size = sizeof(msg.payload.shm),
+                .payload.shm.id = i,
+            };
+            ret = dev->shm_ops->vhost_dev_shm_info(dev, i,
+                                                   &msg.payload.shm.size,
+                                                   &msg.payload.shm.offset,
+                                                   &memfd);
+            if (ret == -1) {
+                continue;
+            }
+            if (vhost_user_write(dev, &msg, &memfd, 1) < 0) {
+                return -1;
+            }
+        }
+    }
+
+    return 0;
+}
+
+static void send_each_fd(gpointer key, gpointer value, gpointer opaque)
+{
+    int fd_key = GPOINTER_TO_INT(key);
+    int fd = GPOINTER_TO_INT(value);
+    struct vhost_dev *dev = opaque;
+    VhostUserMsg msg = {
+        .hdr.request = VHOST_USER_SET_FD,
+        .hdr.flags = VHOST_USER_VERSION,
+        .hdr.size = sizeof(msg.payload.fdinfo),
+    };
+    msg.payload.fdinfo.key = fd_key;
+    vhost_user_write(dev, &msg, &fd, 1);
+}
+
+static int vhost_user_set_fd(struct vhost_dev *dev)
+{
+    int ret;
+    GHashTable *fd_ht = NULL;
+
+    if (!dev->fd_ops || !dev->fd_ops->vhost_dev_fd_info) {
+        return -1;
+    }
+
+    ret = dev->fd_ops->vhost_dev_fd_info(dev, &fd_ht);
+    if (ret) {
+        return 0;
+    }
+
+    if (fd_ht != NULL) {
+        g_hash_table_foreach(fd_ht, send_each_fd, dev);
+    }
+    return 0;
+}
+
 bool vhost_user_init(VhostUserState *user, CharBackend *chr, Error **errp)
 {
     if (user->chr) {
@@ -2387,4 +2508,6 @@ const VhostOps user_ops = {
         .vhost_backend_mem_section_filter = vhost_user_mem_section_filter,
         .vhost_get_inflight_fd = vhost_user_get_inflight_fd,
         .vhost_set_inflight_fd = vhost_user_set_inflight_fd,
+        .vhost_set_shm = vhost_user_set_shm,
+        .vhost_set_fd = vhost_user_set_fd,
 };
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 614ccc2bcb..9acda4d69f 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1581,6 +1581,18 @@ void vhost_dev_set_config_notifier(struct vhost_dev *hdev,
     hdev->config_ops = ops;
 }
 
+void vhost_dev_set_shm_ops(struct vhost_dev *hdev,
+                           const VhostDevShmOps *ops)
+{
+    hdev->shm_ops = ops;
+}
+
+void vhost_dev_set_fd_ops(struct vhost_dev *hdev,
+                          const VhostDevFdOps *ops)
+{
+    hdev->fd_ops = ops;
+}
+
 void vhost_dev_free_inflight(struct vhost_inflight *inflight)
 {
     if (inflight && inflight->addr) {
@@ -1590,6 +1602,36 @@ void vhost_dev_free_inflight(struct vhost_inflight *inflight)
     }
 }
 
+int vhost_dev_set_shm(struct vhost_dev *dev)
+{
+    int r;
+
+    if (dev->vhost_ops->vhost_set_shm) {
+        r = dev->vhost_ops->vhost_set_shm(dev);
+        if (r) {
+            VHOST_OPS_DEBUG("vhost_dev_set_shm failed");
+            return -errno;
+        }
+    }
+
+    return 0;
+}
+
+int vhost_dev_set_fd(struct vhost_dev *dev)
+{
+    int r;
+
+    if (dev->vhost_ops->vhost_set_fd) {
+        r = dev->vhost_ops->vhost_set_fd(dev);
+        if (r) {
+            VHOST_OPS_DEBUG("vhost_dev_set_fd failed");
+            return -errno;
+        }
+    }
+
+    return 0;
+}
+
 static int vhost_dev_resize_inflight(struct vhost_inflight *inflight,
                                      uint64_t new_size)
 {
diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/vhost-backend.h
index 8a6f8e2a7a..af55b62133 100644
--- a/include/hw/virtio/vhost-backend.h
+++ b/include/hw/virtio/vhost-backend.h
@@ -125,6 +125,10 @@ typedef int (*vhost_get_device_id_op)(struct vhost_dev *dev, uint32_t *dev_id);
 
 typedef bool (*vhost_force_iommu_op)(struct vhost_dev *dev);
 
+typedef int (*vhost_set_shm_op)(struct vhost_dev *dev);
+
+typedef int (*vhost_set_fd_op)(struct vhost_dev *dev);
+
 typedef struct VhostOps {
     VhostBackendType backend_type;
     vhost_backend_init vhost_backend_init;
@@ -170,6 +174,8 @@ typedef struct VhostOps {
     vhost_vq_get_addr_op  vhost_vq_get_addr;
     vhost_get_device_id_op vhost_get_device_id;
     vhost_force_iommu_op vhost_force_iommu;
+    vhost_set_shm_op vhost_set_shm;
+    vhost_set_fd_op vhost_set_fd;
 } VhostOps;
 
 extern const VhostOps user_ops;
diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index 4a8bc75415..c1e6f32d13 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -60,6 +60,42 @@ typedef struct VhostDevConfigOps {
     int (*vhost_dev_config_notifier)(struct vhost_dev *dev);
 } VhostDevConfigOps;
 
+#ifndef VU_PERSIST_STRUCTS
+#define VU_PERSIST_STRUCTS
+
+typedef struct VhostUserShm {
+    int id;
+    uint64_t size;
+    uint64_t offset;
+} VhostUserShm;
+
+typedef enum VhostUserFdFlag {
+    VU_FD_FLAG_ADD = 0,
+    VU_FD_FLAG_DEL = 1,
+    VU_FD_FLAG_RESTORE = 2,
+    VU_FD_FLAG_MAX
+} VhostUserFdFlag;
+
+typedef struct VhostUserFd {
+    int key;
+    VhostUserFdFlag flag;
+} VhostUserFd;
+
+#endif
+
+typedef struct VhostDevShmOps {
+    int (*vhost_dev_slave_shm)(struct vhost_dev *dev,
+                               struct VhostUserShm *shm, int fd);
+    int (*vhost_dev_shm_info)(struct vhost_dev *dev, int shm_type,
+                              uint64_t *size, uint64_t *offset, int *memfd);
+} VhostDevShmOps;
+
+typedef struct VhostDevFdOps {
+    int (*vhost_dev_slave_fd)(struct vhost_dev *dev,
+                              struct VhostUserFd *fdinfo, int fd);
+    int (*vhost_dev_fd_info)(struct vhost_dev *dev, GHashTable **fd_ht_p);
+} VhostDevFdOps;
+
 struct vhost_memory;
 struct vhost_dev {
     VirtIODevice *vdev;
@@ -91,6 +127,8 @@ struct vhost_dev {
     QLIST_HEAD(, vhost_iommu) iommu_list;
     IOMMUNotifier n;
     const VhostDevConfigOps *config_ops;
+    const VhostDevShmOps *shm_ops;
+    const VhostDevFdOps *fd_ops;
 };
 
 struct vhost_net {
@@ -136,6 +174,8 @@ int vhost_dev_set_config(struct vhost_dev *dev, const uint8_t *data,
  */
 void vhost_dev_set_config_notifier(struct vhost_dev *dev,
                                    const VhostDevConfigOps *ops);
+void vhost_dev_set_shm_ops(struct vhost_dev *dev, const VhostDevShmOps *ops);
+void vhost_dev_set_fd_ops(struct vhost_dev *dev, const VhostDevFdOps *ops);
 
 void vhost_dev_reset_inflight(struct vhost_inflight *inflight);
 void vhost_dev_free_inflight(struct vhost_inflight *inflight);
@@ -146,4 +186,6 @@ int vhost_dev_set_inflight(struct vhost_dev *dev,
                            struct vhost_inflight *inflight);
 int vhost_dev_get_inflight(struct vhost_dev *dev, uint16_t queue_size,
                            struct vhost_inflight *inflight);
+int vhost_dev_set_shm(struct vhost_dev *dev);
+int vhost_dev_set_fd(struct vhost_dev *dev);
 #endif
-- 
2.20.1

