From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  9 Feb 2021 19:02:07 +0000
Message-Id: <20210209190224.62827-8-dgilbert@redhat.com>
In-Reply-To: <20210209190224.62827-1-dgilbert@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 07/24] DAX: virtio-fs: Add vhost-user slave
	commands for mapping
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

The daemon may request that fd's be mapped into the virtio-fs cache
visible to the guest.
These mappings are triggered by commands sent over the slave fd
from the daemon.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 docs/interop/vhost-user.rst               | 20 +++++++++++++++++++
 hw/virtio/vhost-user-fs.c                 | 14 +++++++++++++
 hw/virtio/vhost-user.c                    | 14 +++++++++++++
 include/hw/virtio/vhost-user-fs.h         | 24 +++++++++++++++++++++++
 subprojects/libvhost-user/libvhost-user.h |  2 ++
 5 files changed, 74 insertions(+)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index d6085f7045..1deedd3407 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -1432,6 +1432,26 @@ Slave message types
 
   The state.num field is currently reserved and must be set to 0.
 
+``VHOST_USER_SLAVE_FS_MAP``
+  :id: 6
+  :equivalent ioctl: N/A
+  :slave payload: fd + n * (offset + address + len)
+  :master payload: N/A
+
+  Requests that the QEMU mmap the given fd into the virtio-fs cache;
+  multiple chunks can be mapped in one command.
+  A reply is generated indicating whether mapping succeeded.
+
+``VHOST_USER_SLAVE_FS_UNMAP``
+  :id: 7
+  :equivalent ioctl: N/A
+  :slave payload: n * (address + len)
+  :master payload: N/A
+
+  Requests that the QEMU un-mmap the given range in the virtio-fs cache;
+  multiple chunks can be unmapped in one command.
+  A reply is generated indicating whether unmapping succeeded.
+
 .. _reply_ack:
 
 VHOST_USER_PROTOCOL_F_REPLY_ACK
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index b077d8e705..78401d2ff1 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -34,6 +34,20 @@
 #define DAX_WINDOW_PROT PROT_NONE
 #endif
 
+uint64_t vhost_user_fs_slave_map(struct vhost_dev *dev, VhostUserFSSlaveMsg *sm,
+                                 int fd)
+{
+    /* TODO */
+    return (uint64_t)-1;
+}
+
+uint64_t vhost_user_fs_slave_unmap(struct vhost_dev *dev,
+                                   VhostUserFSSlaveMsg *sm)
+{
+    /* TODO */
+    return (uint64_t)-1;
+}
+
 static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 13789cc55e..21e40ff91a 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -12,6 +12,7 @@
 #include "qapi/error.h"
 #include "hw/virtio/vhost.h"
 #include "hw/virtio/vhost-user.h"
+#include "hw/virtio/vhost-user-fs.h"
 #include "hw/virtio/vhost-backend.h"
 #include "hw/virtio/virtio.h"
 #include "hw/virtio/virtio-net.h"
@@ -132,6 +133,10 @@ typedef enum VhostUserSlaveRequest {
     VHOST_USER_SLAVE_IOTLB_MSG = 1,
     VHOST_USER_SLAVE_CONFIG_CHANGE_MSG = 2,
     VHOST_USER_SLAVE_VRING_HOST_NOTIFIER_MSG = 3,
+    VHOST_USER_SLAVE_VRING_CALL = 4,
+    VHOST_USER_SLAVE_VRING_ERR = 5,
+    VHOST_USER_SLAVE_FS_MAP = 6,
+    VHOST_USER_SLAVE_FS_UNMAP = 7,
     VHOST_USER_SLAVE_MAX
 }  VhostUserSlaveRequest;
 
@@ -218,6 +223,7 @@ typedef union {
         VhostUserCryptoSession session;
         VhostUserVringArea area;
         VhostUserInflight inflight;
+        VhostUserFSSlaveMsg fs;
 } VhostUserPayload;
 
 typedef struct VhostUserMsg {
@@ -1472,6 +1478,14 @@ static void slave_read(void *opaque)
         ret = vhost_user_slave_handle_vring_host_notifier(dev, &payload.area,
                                                           fd[0]);
         break;
+#ifdef CONFIG_VHOST_USER_FS
+    case VHOST_USER_SLAVE_FS_MAP:
+        ret = vhost_user_fs_slave_map(dev, &payload.fs, fd[0]);
+        break;
+    case VHOST_USER_SLAVE_FS_UNMAP:
+        ret = vhost_user_fs_slave_unmap(dev, &payload.fs);
+        break;
+#endif
     default:
         error_report("Received unexpected msg type: %d.", hdr.request);
         ret = (uint64_t)-EINVAL;
diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
index 04596799e3..25e14ab17a 100644
--- a/include/hw/virtio/vhost-user-fs.h
+++ b/include/hw/virtio/vhost-user-fs.h
@@ -23,6 +23,24 @@
 #define TYPE_VHOST_USER_FS "vhost-user-fs-device"
 OBJECT_DECLARE_SIMPLE_TYPE(VHostUserFS, VHOST_USER_FS)
 
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
 typedef struct {
     CharBackend chardev;
     char *tag;
@@ -46,4 +64,10 @@ struct VHostUserFS {
     MemoryRegion cache;
 };
 
+/* Callbacks from the vhost-user code for slave commands */
+uint64_t vhost_user_fs_slave_map(struct vhost_dev *dev, VhostUserFSSlaveMsg *sm,
+                                 int fd);
+uint64_t vhost_user_fs_slave_unmap(struct vhost_dev *dev,
+                                   VhostUserFSSlaveMsg *sm);
+
 #endif /* _QEMU_VHOST_USER_FS_H */
diff --git a/subprojects/libvhost-user/libvhost-user.h b/subprojects/libvhost-user/libvhost-user.h
index e12e9c1532..150b1121cc 100644
--- a/subprojects/libvhost-user/libvhost-user.h
+++ b/subprojects/libvhost-user/libvhost-user.h
@@ -119,6 +119,8 @@ typedef enum VhostUserSlaveRequest {
     VHOST_USER_SLAVE_VRING_HOST_NOTIFIER_MSG = 3,
     VHOST_USER_SLAVE_VRING_CALL = 4,
     VHOST_USER_SLAVE_VRING_ERR = 5,
+    VHOST_USER_SLAVE_FS_MAP = 6,
+    VHOST_USER_SLAVE_FS_UNMAP = 7,
     VHOST_USER_SLAVE_MAX
 }  VhostUserSlaveRequest;
 
-- 
2.29.2

