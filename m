Date: Fri, 4 Feb 2022 20:43:28 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20220205014149.1189026-20-mst@redhat.com>
References: <20220205014149.1189026-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220205014149.1189026-1-mst@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PULL 19/32] qmp: decode feature & status bits in
	virtio-status
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Laurent Vivier <lvivier@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Amit Shah <amit@kernel.org>, Jason Wang <jasowang@redhat.com>, David Hildenbrand <david@redhat.com>, Markus Armbruster <armbru@redhat.com>, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Fam Zheng <fam@euphon.net>, Eric Blake <eblake@redhat.com>, Jonah Palmer <jonah.palmer@oracle.com>

From: Laurent Vivier <lvivier@redhat.com>

Display feature names instead of bitmaps for host, guest, and
backend for VirtIODevices.

Display status names instead of bitmaps for VirtIODevices.

Display feature names instead of bitmaps for backend, protocol,
acked, and features (hdev->features) for vhost devices.

Decode features according to device ID. Decode statuses
according to configuration status bitmap (config_status_map).
Decode vhost user protocol features according to vhost user
protocol bitmap (vhost_user_protocol_map).

Transport features are on the first line. Undecoded bits (if
any) are stored in a separate field.

Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
Message-Id: <1642678168-20447-6-git-send-email-jonah.palmer@oracle.com>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 qapi/virtio.json               | 156 ++++++++++++++---
 include/hw/virtio/vhost.h      |   3 +
 include/hw/virtio/virtio.h     |  18 ++
 hw/block/virtio-blk.c          |  29 ++++
 hw/char/virtio-serial-bus.c    |  11 ++
 hw/display/virtio-gpu-base.c   |  18 +-
 hw/input/virtio-input.c        |  10 ++
 hw/net/virtio-net.c            |  47 ++++++
 hw/scsi/virtio-scsi.c          |  17 ++
 hw/virtio/vhost-user-fs.c      |  10 ++
 hw/virtio/vhost-vsock-common.c |  10 ++
 hw/virtio/virtio-balloon.c     |  14 ++
 hw/virtio/virtio-crypto.c      |  10 ++
 hw/virtio/virtio-iommu.c       |  14 ++
 hw/virtio/virtio-mem.c         |  11 ++
 hw/virtio/virtio.c             | 297 ++++++++++++++++++++++++++++++++-
 16 files changed, 646 insertions(+), 29 deletions(-)

diff --git a/qapi/virtio.json b/qapi/virtio.json
index ba61d83df7..474a8bd64e 100644
--- a/qapi/virtio.json
+++ b/qapi/virtio.json
@@ -106,10 +106,10 @@
             'n-tmp-sections': 'int',
             'nvqs': 'uint32',
             'vq-index': 'int',
-            'features': 'uint64',
-            'acked-features': 'uint64',
-            'backend-features': 'uint64',
-            'protocol-features': 'uint64',
+            'features': 'VirtioDeviceFeatures',
+            'acked-features': 'VirtioDeviceFeatures',
+            'backend-features': 'VirtioDeviceFeatures',
+            'protocol-features': 'VhostDeviceProtocols',
             'max-queues': 'uint64',
             'backend-cap': 'uint64',
             'log-enabled': 'bool',
@@ -176,11 +176,11 @@
             'device-id': 'uint16',
             'vhost-started': 'bool',
             'device-endian': 'str',
-            'guest-features': 'uint64',
-            'host-features': 'uint64',
-            'backend-features': 'uint64',
+            'guest-features': 'VirtioDeviceFeatures',
+            'host-features': 'VirtioDeviceFeatures',
+            'backend-features': 'VirtioDeviceFeatures',
             'num-vqs': 'int',
-            'status': 'uint8',
+            'status': 'VirtioDeviceStatus',
             'isr': 'uint8',
             'queue-sel': 'uint16',
             'vm-running': 'bool',
@@ -222,14 +222,28 @@
 #            "name": "virtio-crypto",
 #            "started": true,
 #            "device-id": 20,
-#            "backend-features": 0,
+#            "backend-features": {
+#               "transports": [],
+#               "dev-features": []
+#            },
 #            "start-on-kick": false,
 #            "isr": 1,
 #            "broken": false,
-#            "status": 15,
+#            "status": {
+#               "statuses": ["ACKNOWLEDGE", "DRIVER", "FEATURES_OK",
+#                            "DRIVER_OK"]
+#            },
 #            "num-vqs": 2,
-#            "guest-features": 5100273664,
-#            "host-features": 6325010432,
+#            "guest-features": {
+#               "transports": ["EVENT_IDX", "INDIRECT_DESC", "VERSION_1"],
+#               "dev-features": []
+#            },
+#            "host-features": {
+#               "transports": ["PROTOCOL_FEATURES", "EVENT_IDX",
+#                              "INDIRECT_DESC", "VERSION_1", "ANY_LAYOUT",
+#                              "NOTIFY_ON_EMPTY"],
+#               "dev-features": []
+#            },
 #            "use-guest-notifier-mask": true,
 #            "vm-running": true,
 #            "queue-sel": 1,
@@ -257,22 +271,65 @@
 #               "max-queues": 1,
 #               "backend-cap": 2,
 #               "log-size": 0,
-#               "backend-features": 0,
+#               "backend-features": {
+#                  "transports": [],
+#                  "dev-features": []
+#               },
 #               "nvqs": 2,
-#               "protocol-features": 0,
+#               "protocol-features": {
+#                  "protocols": []
+#               },
 #               "vq-index": 0,
 #               "log-enabled": false,
-#               "acked-features": 5100306432,
-#               "features": 13908344832
+#               "acked-features": {
+#                  "transports": ["EVENT_IDX", "INDIRECT_DESC", "VERSION_1",
+#                                 "ANY_LAYOUT", "NOTIFY_ON_EMPTY"],
+#                  "dev-features": ["MRG_RXBUF"]
+#               },
+#               "features": {
+#                  "transports": ["EVENT_IDX", "INDIRECT_DESC",
+#                                 "IOMMU_PLATFORM", "VERSION_1", "ANY_LAYOUT",
+#                                 "NOTIFY_ON_EMPTY"],
+#                  "dev-features": ["LOG_ALL", "MRG_RXBUF"]
+#               }
+#            },
+#            "backend-features": {
+#               "transports": ["PROTOCOL_FEATURES", "EVENT_IDX", "INDIRECT_DESC",
+#                              "VERSION_1", "ANY_LAYOUT", "NOTIFY_ON_EMPTY"],
+#               "dev-features": ["GSO", "CTRL_MAC_ADDR", "GUEST_ANNOUNCE", "CTRL_RX_EXTRA",
+#                                "CTRL_VLAN", "CTRL_RX", "CTRL_VQ", "STATUS", "MRG_RXBUF",
+#                                "HOST_UFO", "HOST_ECN", "HOST_TSO6", "HOST_TSO4",
+#                                "GUEST_UFO", "GUEST_ECN", "GUEST_TSO6", "GUEST_TSO4",
+#                                "MAC", "CTRL_GUEST_OFFLOADS", "GUEST_CSUM", "CSUM"]
 #            },
-#            "backend-features": 6337593319,
 #            "start-on-kick": false,
 #            "isr": 1,
 #            "broken": false,
-#            "status": 15,
+#            "status": {
+#               "statuses": ["ACKNOWLEDGE", "DRIVER", "FEATURES_OK", "DRIVER_OK"]
+#            },
 #            "num-vqs": 3,
-#            "guest-features": 5111807911,
-#            "host-features": 6337593319,
+#            "guest-features": {
+#               "transports": ["EVENT_IDX", "INDIRECT_DESC", "VERSION_1"],
+#               "dev-features": ["CTRL_MAC_ADDR", "GUEST_ANNOUNCE", "CTRL_VLAN",
+#                                "CTRL_RX", "CTRL_VQ", "STATUS", "MRG_RXBUF",
+#                                "HOST_UFO", "HOST_ECN", "HOST_TSO6",
+#                                "HOST_TSO4", "GUEST_UFO", "GUEST_ECN",
+#                                "GUEST_TSO6", "GUEST_TSO4", "MAC",
+#                                "CTRL_GUEST_OFFLOADS", "GUEST_CSUM", "CSUM"]
+#            },
+#            "host-features": {
+#               "transports": ["PROTOCOL_FEATURES", "EVENT_IDX",
+#                              "INDIRECT_DESC", "VERSION_1", "ANY_LAYOUT",
+#                              "NOTIFY_ON_EMPTY"],
+#               "dev-features": ["GSO", "CTRL_MAC_ADDR", "GUEST_ANNOUNCE",
+#                                "CTRL_RX_EXTRA", "CTRL_VLAN", "CTRL_RX",
+#                                "CTRL_VQ", "STATUS", "MRG_RXBUF", "HOST_UFO",
+#                                "HOST_ECN", "HOST_TSO4", "HOST_TSO4",
+#                                "GUEST_UFO", "GUEST_ECN", "GUEST_TSO6",
+#                                "GUEST_TSO4", "MAC", "CTRL_GUEST_OFFLOADS",
+#                                "GUEST_CSUM", "CSUM"]
+#            },
 #            "use-guest-notifier-mask": true,
 #            "vm-running": true,
 #            "queue-sel": 2,
@@ -288,3 +345,62 @@
   'data': { 'path': 'str' },
   'returns': 'VirtioStatus',
   'features': [ 'unstable' ] }
+
+##
+# @VirtioDeviceStatus:
+#
+# A structure defined to list the configuration statuses of a virtio
+# device
+#
+# @statuses: List of decoded configuration statuses of the virtio
+#            device
+#
+# @unknown-statuses: Virtio device statuses bitmap that have not been decoded
+#
+# Since: 7.0
+##
+
+{ 'struct': 'VirtioDeviceStatus',
+  'data': { 'statuses': [ 'str' ],
+            '*unknown-statuses': 'uint8' } }
+
+##
+# @VhostDeviceProtocols:
+#
+# A structure defined to list the vhost user protocol features of a
+# Vhost User device
+#
+# @protocols: List of decoded vhost user protocol features of a vhost
+#             user device
+#
+# @unknown-protocols: Vhost user device protocol features bitmap that
+#                     have not been decoded
+#
+# Since: 7.0
+##
+
+{ 'struct': 'VhostDeviceProtocols',
+  'data': { 'protocols': [ 'str' ],
+            '*unknown-protocols': 'uint64' } }
+
+##
+# @VirtioDeviceFeatures:
+#
+# The common fields that apply to most Virtio devices. Some devices
+# may not have their own device-specific features (e.g. virtio-rng).
+#
+# @transports: List of transport features of the virtio device
+#
+# @dev-features: List of device-specific features (if the device has
+#                unique features)
+#
+# @unknown-dev-features: Virtio device features bitmap that have not
+#                        been decoded
+#
+# Since: 7.0
+##
+
+{ 'struct': 'VirtioDeviceFeatures',
+  'data': { 'transports': [ 'str' ],
+            '*dev-features': [ 'str' ],
+            '*unknown-dev-features': 'uint64' } }
diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index 58a73e7b7a..4aaa21faf6 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -5,6 +5,9 @@
 #include "hw/virtio/virtio.h"
 #include "exec/memory.h"
 
+#define VHOST_F_DEVICE_IOTLB 63
+#define VHOST_USER_F_PROTOCOL_FEATURES 30
+
 /* Generic structures common for any vhost based device. */
 
 struct vhost_inflight {
diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 8f4e4c12a6..183d431b5a 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -71,6 +71,24 @@ typedef struct VirtQueueElement
 #define TYPE_VIRTIO_DEVICE "virtio-device"
 OBJECT_DECLARE_TYPE(VirtIODevice, VirtioDeviceClass, VIRTIO_DEVICE)
 
+typedef struct {
+    int virtio_bit;
+    const char *feature_name;
+} qmp_virtio_feature_map_t;
+
+extern qmp_virtio_feature_map_t serial_map[];
+extern qmp_virtio_feature_map_t blk_map[];
+extern qmp_virtio_feature_map_t gpu_map[];
+extern qmp_virtio_feature_map_t net_map[];
+extern qmp_virtio_feature_map_t scsi_map[];
+extern qmp_virtio_feature_map_t balloon_map[];
+extern qmp_virtio_feature_map_t iommu_map[];
+extern qmp_virtio_feature_map_t input_map[];
+extern qmp_virtio_feature_map_t fs_map[];
+extern qmp_virtio_feature_map_t vsock_map[];
+extern qmp_virtio_feature_map_t crypto_map[];
+extern qmp_virtio_feature_map_t mem_map[];
+
 enum virtio_device_endian {
     VIRTIO_DEVICE_ENDIAN_UNKNOWN,
     VIRTIO_DEVICE_ENDIAN_LITTLE,
diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
index 2e3809dafa..55d291ed7a 100644
--- a/hw/block/virtio-blk.c
+++ b/hw/block/virtio-blk.c
@@ -13,6 +13,7 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
+#include "qapi/qapi-visit-virtio.h"
 #include "qemu/iov.h"
 #include "qemu/module.h"
 #include "qemu/error-report.h"
@@ -32,10 +33,38 @@
 #include "hw/virtio/virtio-bus.h"
 #include "migration/qemu-file-types.h"
 #include "hw/virtio/virtio-access.h"
+#include "standard-headers/linux/vhost_types.h"
 
 /* Config size before the discard support (hide associated config fields) */
 #define VIRTIO_BLK_CFG_SIZE offsetof(struct virtio_blk_config, \
                                      max_discard_sectors)
+
+qmp_virtio_feature_map_t blk_map[] = {
+#define FEATURE_ENTRY(name) \
+    { VIRTIO_BLK_F_##name, #name }
+    FEATURE_ENTRY(SIZE_MAX),
+    FEATURE_ENTRY(SEG_MAX),
+    FEATURE_ENTRY(GEOMETRY),
+    FEATURE_ENTRY(RO),
+    FEATURE_ENTRY(BLK_SIZE),
+    FEATURE_ENTRY(TOPOLOGY),
+    FEATURE_ENTRY(MQ),
+    FEATURE_ENTRY(DISCARD),
+    FEATURE_ENTRY(WRITE_ZEROES),
+#ifndef VIRTIO_BLK_NO_LEGACY
+    FEATURE_ENTRY(BARRIER),
+    FEATURE_ENTRY(SCSI),
+    FEATURE_ENTRY(FLUSH),
+    FEATURE_ENTRY(CONFIG_WCE),
+#endif /* !VIRTIO_BLK_NO_LEGACY */
+#undef FEATURE_ENTRY
+#define FEATURE_ENTRY(name) \
+    { VHOST_F_##name, #name  }
+    FEATURE_ENTRY(LOG_ALL),
+#undef FEATURE_ENTRY
+    { -1, ""  }
+};
+
 /*
  * Starting from the discard feature, we can use this array to properly
  * set the config size depending on the features enabled.
diff --git a/hw/char/virtio-serial-bus.c b/hw/char/virtio-serial-bus.c
index 9f19fd0672..9de257541d 100644
--- a/hw/char/virtio-serial-bus.c
+++ b/hw/char/virtio-serial-bus.c
@@ -20,6 +20,7 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
+#include "qapi/qapi-visit-virtio.h"
 #include "qemu/iov.h"
 #include "qemu/main-loop.h"
 #include "qemu/module.h"
@@ -32,6 +33,16 @@
 #include "hw/virtio/virtio-serial.h"
 #include "hw/virtio/virtio-access.h"
 
+qmp_virtio_feature_map_t serial_map[] = {
+#define FEATURE_ENTRY(name) \
+    { VIRTIO_CONSOLE_F_##name, #name }
+    FEATURE_ENTRY(SIZE),
+    FEATURE_ENTRY(MULTIPORT),
+    FEATURE_ENTRY(EMERG_WRITE),
+#undef FEATURE_ENTRY
+    { -1, "" }
+};
+
 static struct VirtIOSerialDevices {
     QLIST_HEAD(, VirtIOSerial) devices;
 } vserdevices;
diff --git a/hw/display/virtio-gpu-base.c b/hw/display/virtio-gpu-base.c
index 8ba5da4312..796786ab40 100644
--- a/hw/display/virtio-gpu-base.c
+++ b/hw/display/virtio-gpu-base.c
@@ -12,13 +12,29 @@
  */
 
 #include "qemu/osdep.h"
-
+#include "standard-headers/linux/vhost_types.h"
 #include "hw/virtio/virtio-gpu.h"
 #include "migration/blocker.h"
 #include "qapi/error.h"
+#include "qapi/qapi-visit-virtio.h"
 #include "qemu/error-report.h"
 #include "trace.h"
 
+qmp_virtio_feature_map_t gpu_map[] = {
+#define FEATURE_ENTRY(name) \
+    { VIRTIO_GPU_F_##name, #name }
+    FEATURE_ENTRY(VIRGL),
+    FEATURE_ENTRY(EDID),
+    FEATURE_ENTRY(RESOURCE_UUID),
+    FEATURE_ENTRY(RESOURCE_BLOB),
+#undef FEATURE_ENTRY
+#define FEATURE_ENTRY(name) \
+    { VHOST_F_##name, #name }
+    FEATURE_ENTRY(LOG_ALL),
+#undef FEATURE_ENTRY
+    { -1, "" }
+};
+
 void
 virtio_gpu_base_reset(VirtIOGPUBase *g)
 {
diff --git a/hw/input/virtio-input.c b/hw/input/virtio-input.c
index 5b5398b3ca..fe0ed6d5b4 100644
--- a/hw/input/virtio-input.c
+++ b/hw/input/virtio-input.c
@@ -6,6 +6,7 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
+#include "qapi/qapi-visit-virtio.h"
 #include "qemu/iov.h"
 #include "qemu/module.h"
 #include "trace.h"
@@ -14,10 +15,19 @@
 #include "hw/qdev-properties.h"
 #include "hw/virtio/virtio-input.h"
 
+#include "standard-headers/linux/vhost_types.h"
 #include "standard-headers/linux/input.h"
 
 #define VIRTIO_INPUT_VM_VERSION 1
 
+qmp_virtio_feature_map_t input_map[] = {
+#define FEATURE_ENTRY(name) \
+    { VHOST_F_##name, #name }
+    FEATURE_ENTRY(LOG_ALL),
+#undef FEATURE_ENTRY
+    { -1, "" }
+};
+
 /* ----------------------------------------------------------------- */
 
 void virtio_input_send(VirtIOInput *vinput, virtio_input_event *event)
diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index 21328dc547..db3d4a0e0b 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -35,9 +35,11 @@
 #include "hw/qdev-properties.h"
 #include "qapi/qapi-types-migration.h"
 #include "qapi/qapi-events-migration.h"
+#include "qapi/qapi-visit-virtio.h"
 #include "hw/virtio/virtio-access.h"
 #include "migration/misc.h"
 #include "standard-headers/linux/ethtool.h"
+#include "standard-headers/linux/vhost_types.h"
 #include "sysemu/sysemu.h"
 #include "trace.h"
 #include "monitor/qdev.h"
@@ -90,6 +92,51 @@
                                          VIRTIO_NET_RSS_HASH_TYPE_TCP_EX | \
                                          VIRTIO_NET_RSS_HASH_TYPE_UDP_EX)
 
+qmp_virtio_feature_map_t net_map[] = {
+#define FEATURE_ENTRY(name) \
+    { VIRTIO_NET_F_##name, #name }
+    FEATURE_ENTRY(CSUM),
+    FEATURE_ENTRY(GUEST_CSUM),
+    FEATURE_ENTRY(CTRL_GUEST_OFFLOADS),
+    FEATURE_ENTRY(MTU),
+    FEATURE_ENTRY(MAC),
+    FEATURE_ENTRY(GUEST_TSO4),
+    FEATURE_ENTRY(GUEST_TSO6),
+    FEATURE_ENTRY(GUEST_ECN),
+    FEATURE_ENTRY(GUEST_UFO),
+    FEATURE_ENTRY(HOST_TSO4),
+    FEATURE_ENTRY(HOST_TSO6),
+    FEATURE_ENTRY(HOST_ECN),
+    FEATURE_ENTRY(HOST_UFO),
+    FEATURE_ENTRY(MRG_RXBUF),
+    FEATURE_ENTRY(STATUS),
+    FEATURE_ENTRY(CTRL_VQ),
+    FEATURE_ENTRY(CTRL_RX),
+    FEATURE_ENTRY(CTRL_VLAN),
+    FEATURE_ENTRY(CTRL_RX_EXTRA),
+    FEATURE_ENTRY(GUEST_ANNOUNCE),
+    FEATURE_ENTRY(MQ),
+    FEATURE_ENTRY(CTRL_MAC_ADDR),
+    FEATURE_ENTRY(HASH_REPORT),
+    FEATURE_ENTRY(RSS),
+    FEATURE_ENTRY(RSC_EXT),
+    FEATURE_ENTRY(STANDBY),
+    FEATURE_ENTRY(SPEED_DUPLEX),
+#ifndef VIRTIO_NET_NO_LEGACY
+    FEATURE_ENTRY(GSO),
+#endif /* VIRTIO_NET_NO_LEGACY */
+#undef FEATURE_ENTRY
+#define FEATURE_ENTRY(name) \
+    { VHOST_NET_F_##name, #name }
+    FEATURE_ENTRY(VIRTIO_NET_HDR),
+#undef FEATURE_ENTRY
+#define FEATURE_ENTRY(name) \
+    { VHOST_F_##name, #name }
+    FEATURE_ENTRY(LOG_ALL),
+#undef FEATURE_ENTRY
+    { -1, "" }
+};
+
 static const VirtIOFeature feature_sizes[] = {
     {.flags = 1ULL << VIRTIO_NET_F_MAC,
      .end = endof(struct virtio_net_config, mac)},
diff --git a/hw/scsi/virtio-scsi.c b/hw/scsi/virtio-scsi.c
index 2a6141d081..9ca8faa40e 100644
--- a/hw/scsi/virtio-scsi.c
+++ b/hw/scsi/virtio-scsi.c
@@ -15,7 +15,9 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
+#include "qapi/qapi-visit-virtio.h"
 #include "standard-headers/linux/virtio_ids.h"
+#include "standard-headers/linux/vhost_types.h"
 #include "hw/virtio/virtio-scsi.h"
 #include "migration/qemu-file-types.h"
 #include "qemu/error-report.h"
@@ -29,6 +31,21 @@
 #include "hw/virtio/virtio-access.h"
 #include "trace.h"
 
+qmp_virtio_feature_map_t scsi_map[] = {
+#define FEATURE_ENTRY(name) \
+    { VIRTIO_SCSI_F_##name, #name }
+    FEATURE_ENTRY(INOUT),
+    FEATURE_ENTRY(HOTPLUG),
+    FEATURE_ENTRY(CHANGE),
+    FEATURE_ENTRY(T10_PI),
+#undef FEATURE_ENTRY
+#define FEATURE_ENTRY(name) \
+    { VHOST_F_##name, #name }
+    FEATURE_ENTRY(LOG_ALL),
+#undef FEATURE_ENTRY
+    { -1, "" }
+};
+
 static inline int virtio_scsi_get_lun(uint8_t *lun)
 {
     return ((lun[2] << 8) | lun[3]) & 0x3FFF;
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index e513e4fdda..096cc07c44 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -15,6 +15,7 @@
 #include <sys/ioctl.h>
 #include "standard-headers/linux/virtio_fs.h"
 #include "qapi/error.h"
+#include "qapi/qapi-visit-virtio.h"
 #include "hw/qdev-properties.h"
 #include "hw/qdev-properties-system.h"
 #include "hw/virtio/virtio-bus.h"
@@ -23,6 +24,15 @@
 #include "hw/virtio/vhost-user-fs.h"
 #include "monitor/monitor.h"
 #include "sysemu/sysemu.h"
+#include "standard-headers/linux/vhost_types.h"
+
+qmp_virtio_feature_map_t fs_map[] = {
+#define FEATURE_ENTRY(name) \
+    { VHOST_F_##name, #name }
+    FEATURE_ENTRY(LOG_ALL),
+#undef FEATURE_ENTRY
+    { -1, "" }
+};
 
 static const int user_feature_bits[] = {
     VIRTIO_F_VERSION_1,
diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
index 416daf8554..047ebb7bd2 100644
--- a/hw/virtio/vhost-vsock-common.c
+++ b/hw/virtio/vhost-vsock-common.c
@@ -11,12 +11,22 @@
 #include "qemu/osdep.h"
 #include "standard-headers/linux/virtio_vsock.h"
 #include "qapi/error.h"
+#include "qapi/qapi-visit-virtio.h"
 #include "hw/virtio/virtio-access.h"
 #include "qemu/error-report.h"
 #include "hw/qdev-properties.h"
 #include "hw/virtio/vhost-vsock.h"
 #include "qemu/iov.h"
 #include "monitor/monitor.h"
+#include "standard-headers/linux/vhost_types.h"
+
+qmp_virtio_feature_map_t vsock_map[] = {
+#define FEATURE_ENTRY(name) \
+    { VHOST_F_##name, #name }
+    FEATURE_ENTRY(LOG_ALL),
+#undef FEATURE_ENTRY
+    { -1, "" }
+};
 
 const int feature_bits[] = {
     VIRTIO_VSOCK_F_SEQPACKET,
diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
index 236542fb53..6705314fd8 100644
--- a/hw/virtio/virtio-balloon.c
+++ b/hw/virtio/virtio-balloon.c
@@ -27,6 +27,7 @@
 #include "qapi/error.h"
 #include "qapi/qapi-events-machine.h"
 #include "qapi/visitor.h"
+#include "qapi/qapi-visit-virtio.h"
 #include "trace.h"
 #include "qemu/error-report.h"
 #include "migration/misc.h"
@@ -37,6 +38,19 @@
 
 #define BALLOON_PAGE_SIZE  (1 << VIRTIO_BALLOON_PFN_SHIFT)
 
+qmp_virtio_feature_map_t balloon_map[] = {
+#define FEATURE_ENTRY(name) \
+    { VIRTIO_BALLOON_F_##name, #name }
+    FEATURE_ENTRY(MUST_TELL_HOST),
+    FEATURE_ENTRY(STATS_VQ),
+    FEATURE_ENTRY(DEFLATE_ON_OOM),
+    FEATURE_ENTRY(FREE_PAGE_HINT),
+    FEATURE_ENTRY(PAGE_POISON),
+    FEATURE_ENTRY(REPORTING),
+#undef FEATURE_ENTRY
+    { -1, "" }
+};
+
 typedef struct PartiallyBalloonedPage {
     ram_addr_t base_gpa;
     unsigned long *bitmap;
diff --git a/hw/virtio/virtio-crypto.c b/hw/virtio/virtio-crypto.c
index 7d63b8c9a8..b938bd8964 100644
--- a/hw/virtio/virtio-crypto.c
+++ b/hw/virtio/virtio-crypto.c
@@ -16,6 +16,7 @@
 #include "qemu/main-loop.h"
 #include "qemu/module.h"
 #include "qapi/error.h"
+#include "qapi/qapi-visit-virtio.h"
 #include "qemu/error-report.h"
 
 #include "hw/virtio/virtio.h"
@@ -23,10 +24,19 @@
 #include "hw/qdev-properties.h"
 #include "hw/virtio/virtio-access.h"
 #include "standard-headers/linux/virtio_ids.h"
+#include "standard-headers/linux/vhost_types.h"
 #include "sysemu/cryptodev-vhost.h"
 
 #define VIRTIO_CRYPTO_VM_VERSION 1
 
+qmp_virtio_feature_map_t crypto_map[] = {
+#define FEATURE_ENTRY(name) \
+    { VHOST_F_##name, #name }
+    FEATURE_ENTRY(LOG_ALL),
+#undef FEATURE_ENTRY
+    { -1, "" }
+};
+
 /*
  * Transfer virtqueue index to crypto queue index.
  * The control virtqueue is after the data virtqueues
diff --git a/hw/virtio/virtio-iommu.c b/hw/virtio/virtio-iommu.c
index 15b3fa05de..bbb738201f 100644
--- a/hw/virtio/virtio-iommu.c
+++ b/hw/virtio/virtio-iommu.c
@@ -25,6 +25,7 @@
 #include "hw/virtio/virtio.h"
 #include "sysemu/kvm.h"
 #include "qapi/error.h"
+#include "qapi/qapi-visit-virtio.h"
 #include "qemu/error-report.h"
 #include "trace.h"
 
@@ -40,6 +41,19 @@
 #define VIOMMU_DEFAULT_QUEUE_SIZE 256
 #define VIOMMU_PROBE_SIZE 512
 
+qmp_virtio_feature_map_t iommu_map[] = {
+#define FEATURE_ENTRY(name) \
+    { VIRTIO_IOMMU_F_##name, #name }
+    FEATURE_ENTRY(INPUT_RANGE),
+    FEATURE_ENTRY(DOMAIN_RANGE),
+    FEATURE_ENTRY(MAP_UNMAP),
+    FEATURE_ENTRY(BYPASS),
+    FEATURE_ENTRY(PROBE),
+    FEATURE_ENTRY(MMIO),
+#undef FEATURE_ENTRY
+    { -1, "" }
+};
+
 typedef struct VirtIOIOMMUDomain {
     uint32_t id;
     GTree *mappings;
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 465a996214..31e7af834e 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -25,6 +25,7 @@
 #include "hw/virtio/virtio-mem.h"
 #include "qapi/error.h"
 #include "qapi/visitor.h"
+#include "qapi/qapi-visit-virtio.h"
 #include "exec/ram_addr.h"
 #include "migration/misc.h"
 #include "hw/boards.h"
@@ -32,6 +33,16 @@
 #include CONFIG_DEVICES
 #include "trace.h"
 
+qmp_virtio_feature_map_t mem_map[] = {
+#define FEATURE_ENTRY(name) \
+    { VIRTIO_MEM_F_##name, #name }
+#ifndef CONFIG_ACPI
+    FEATURE_ENTRY(ACPI_PXM),
+#endif /* CONFIG_ACPI */
+#undef FEATURE_ENTRY
+    { -1, "" }
+};
+
 /*
  * We only had legacy x86 guests that did not support
  * VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE. Other targets don't have legacy guests.
diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 59665f7d62..ccb5e2bd9e 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -34,10 +34,99 @@
 #include "sysemu/dma.h"
 #include "sysemu/runstate.h"
 #include "standard-headers/linux/virtio_ids.h"
+#include "standard-headers/linux/vhost_types.h"
+#include CONFIG_DEVICES
 
 /* QAPI list of realized VirtIODevices */
 static QTAILQ_HEAD(, VirtIODevice) virtio_list;
 
+/*
+ * Maximum size of virtio device config space
+ */
+#define VHOST_USER_MAX_CONFIG_SIZE 256
+
+enum VhostUserProtocolFeature {
+    VHOST_USER_PROTOCOL_F_MQ = 0,
+    VHOST_USER_PROTOCOL_F_LOG_SHMFD = 1,
+    VHOST_USER_PROTOCOL_F_RARP = 2,
+    VHOST_USER_PROTOCOL_F_REPLY_ACK = 3,
+    VHOST_USER_PROTOCOL_F_NET_MTU = 4,
+    VHOST_USER_PROTOCOL_F_SLAVE_REQ = 5,
+    VHOST_USER_PROTOCOL_F_CROSS_ENDIAN = 6,
+    VHOST_USER_PROTOCOL_F_CRYPTO_SESSION = 7,
+    VHOST_USER_PROTOCOL_F_PAGEFAULT = 8,
+    VHOST_USER_PROTOCOL_F_CONFIG = 9,
+    VHOST_USER_PROTOCOL_F_SLAVE_SEND_FD = 10,
+    VHOST_USER_PROTOCOL_F_HOST_NOTIFIER = 11,
+    VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD = 12,
+    VHOST_USER_PROTOCOL_F_RESET_DEVICE = 13,
+    VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS = 14,
+    VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS = 15,
+    VHOST_USER_PROTOCOL_F_MAX
+};
+
+static qmp_virtio_feature_map_t transport_map[] = {
+#define FEATURE_ENTRY(name) \
+    { VIRTIO_F_##name, #name }
+#ifndef VIRTIO_CONFIG_NO_LEGACY
+    FEATURE_ENTRY(NOTIFY_ON_EMPTY),
+    FEATURE_ENTRY(ANY_LAYOUT),
+#endif /* VIRTIO_CONFIG_NO_LEGACY */
+    FEATURE_ENTRY(VERSION_1),
+    FEATURE_ENTRY(IOMMU_PLATFORM),
+    FEATURE_ENTRY(RING_PACKED),
+    FEATURE_ENTRY(ORDER_PLATFORM),
+    FEATURE_ENTRY(SR_IOV),
+#undef FEATURE_ENTRY
+#define FEATURE_ENTRY(name) \
+    { VIRTIO_RING_F_##name, #name }
+    FEATURE_ENTRY(INDIRECT_DESC),
+    FEATURE_ENTRY(EVENT_IDX),
+#undef FEATURE_ENTRY
+#define FEATURE_ENTRY(name) \
+    { VHOST_USER_F_##name, #name }
+    FEATURE_ENTRY(PROTOCOL_FEATURES),
+#undef FEATURE_ENTRY
+    { -1, "" }
+};
+
+static qmp_virtio_feature_map_t vhost_user_protocol_map[] = {
+#define FEATURE_ENTRY(name) \
+    { VHOST_USER_PROTOCOL_F_##name, #name }
+    FEATURE_ENTRY(MQ),
+    FEATURE_ENTRY(LOG_SHMFD),
+    FEATURE_ENTRY(RARP),
+    FEATURE_ENTRY(REPLY_ACK),
+    FEATURE_ENTRY(NET_MTU),
+    FEATURE_ENTRY(SLAVE_REQ),
+    FEATURE_ENTRY(CROSS_ENDIAN),
+    FEATURE_ENTRY(CRYPTO_SESSION),
+    FEATURE_ENTRY(PAGEFAULT),
+    FEATURE_ENTRY(CONFIG),
+    FEATURE_ENTRY(SLAVE_SEND_FD),
+    FEATURE_ENTRY(HOST_NOTIFIER),
+    FEATURE_ENTRY(INFLIGHT_SHMFD),
+    FEATURE_ENTRY(RESET_DEVICE),
+    FEATURE_ENTRY(INBAND_NOTIFICATIONS),
+    FEATURE_ENTRY(CONFIGURE_MEM_SLOTS),
+#undef FEATURE_ENTRY
+    { -1, "" }
+};
+
+/* virtio device configuration statuses */
+static qmp_virtio_feature_map_t config_status_map[] = {
+#define STATUS_ENTRY(name) \
+    { VIRTIO_CONFIG_S_##name, #name }
+    STATUS_ENTRY(DRIVER_OK),
+    STATUS_ENTRY(FEATURES_OK),
+    STATUS_ENTRY(DRIVER),
+    STATUS_ENTRY(NEEDS_RESET),
+    STATUS_ENTRY(FAILED),
+    STATUS_ENTRY(ACKNOWLEDGE),
+#undef STATUS_ENTRY
+    { -1, "" }
+};
+
 /*
  * The alignment to use between consumer and producer parts of vring.
  * x86 pagesize again. This is the default, used by transports like PCI
@@ -3963,6 +4052,191 @@ static VirtIODevice *virtio_device_find(const char *path)
     return NULL;
 }
 
+#define CONVERT_FEATURES(type, map, is_status, bitmap)   \
+    ({                                                   \
+        type *list = NULL;                               \
+        type *node;                                      \
+        for (i = 0; map[i].virtio_bit != -1; i++) {      \
+            if (is_status) {                             \
+                bit = map[i].virtio_bit;                 \
+            }                                            \
+            else {                                       \
+                bit = 1ULL << map[i].virtio_bit;         \
+            }                                            \
+            if ((bitmap & bit) == 0) {                   \
+                continue;                                \
+            }                                            \
+            node = g_new0(type, 1);                      \
+            node->value = g_strdup(map[i].feature_name); \
+            node->next = list;                           \
+            list = node;                                 \
+            bitmap ^= bit;                               \
+        }                                                \
+        list;                                            \
+    })
+
+static VirtioDeviceStatus *qmp_decode_status(uint8_t bitmap)
+{
+    VirtioDeviceStatus *status;
+    uint8_t bit;
+    int i;
+
+    status = g_new0(VirtioDeviceStatus, 1);
+    status->statuses = CONVERT_FEATURES(strList, config_status_map, 1, bitmap);
+    status->has_unknown_statuses = bitmap != 0;
+    if (status->has_unknown_statuses) {
+        status->unknown_statuses = bitmap;
+    }
+
+    return status;
+}
+
+static VhostDeviceProtocols *qmp_decode_protocols(uint64_t bitmap)
+{
+    VhostDeviceProtocols *vhu_protocols;
+    uint64_t bit;
+    int i;
+
+    vhu_protocols = g_new0(VhostDeviceProtocols, 1);
+    vhu_protocols->protocols =
+                    CONVERT_FEATURES(strList,
+                                     vhost_user_protocol_map, 0, bitmap);
+    vhu_protocols->has_unknown_protocols = bitmap != 0;
+    if (vhu_protocols->has_unknown_protocols) {
+        vhu_protocols->unknown_protocols = bitmap;
+    }
+
+    return vhu_protocols;
+}
+
+static VirtioDeviceFeatures *qmp_decode_features(uint16_t device_id,
+                                                 uint64_t bitmap)
+{
+    VirtioDeviceFeatures *features;
+    uint64_t bit;
+    int i;
+
+    features = g_new0(VirtioDeviceFeatures, 1);
+    features->has_dev_features = true;
+
+    /* transport features */
+    features->transports = CONVERT_FEATURES(strList, transport_map, 0, bitmap);
+
+    /* device features */
+    switch (device_id) {
+#ifdef CONFIG_VIRTIO_SERIAL
+    case VIRTIO_ID_CONSOLE:
+        features->dev_features =
+            CONVERT_FEATURES(strList, serial_map, 0, bitmap);
+        break;
+#endif
+#ifdef CONFIG_VIRTIO_BLK
+    case VIRTIO_ID_BLOCK:
+        features->dev_features =
+            CONVERT_FEATURES(strList, blk_map, 0, bitmap);
+        break;
+#endif
+#ifdef CONFIG_VIRTIO_GPU
+    case VIRTIO_ID_GPU:
+        features->dev_features =
+            CONVERT_FEATURES(strList, gpu_map, 0, bitmap);
+        break;
+#endif
+#ifdef CONFIG_VIRTIO_NET
+    case VIRTIO_ID_NET:
+        features->dev_features =
+            CONVERT_FEATURES(strList, net_map, 0, bitmap);
+        break;
+#endif
+#ifdef CONFIG_VIRTIO_SCSI
+    case VIRTIO_ID_SCSI:
+        features->dev_features =
+            CONVERT_FEATURES(strList, scsi_map, 0, bitmap);
+        break;
+#endif
+#ifdef CONFIG_VIRTIO_BALLOON
+    case VIRTIO_ID_BALLOON:
+        features->dev_features =
+            CONVERT_FEATURES(strList, balloon_map, 0, bitmap);
+        break;
+#endif
+#ifdef CONFIG_VIRTIO_IOMMU
+    case VIRTIO_ID_IOMMU:
+        features->dev_features =
+            CONVERT_FEATURES(strList, iommu_map, 0, bitmap);
+        break;
+#endif
+#ifdef CONFIG_VIRTIO_INPUT
+    case VIRTIO_ID_INPUT:
+        features->dev_features =
+            CONVERT_FEATURES(strList, input_map, 0, bitmap);
+        break;
+#endif
+#ifdef CONFIG_VHOST_USER_FS
+    case VIRTIO_ID_FS:
+        features->dev_features =
+            CONVERT_FEATURES(strList, fs_map, 0, bitmap);
+        break;
+#endif
+#ifdef CONFIG_VHOST_VSOCK
+    case VIRTIO_ID_VSOCK:
+        features->dev_features =
+            CONVERT_FEATURES(strList, vsock_map, 0, bitmap);
+        break;
+#endif
+#ifdef CONFIG_VIRTIO_CRYPTO
+    case VIRTIO_ID_CRYPTO:
+        features->dev_features =
+            CONVERT_FEATURES(strList, crypto_map, 0, bitmap);
+        break;
+#endif
+#ifdef CONFIG_VIRTIO_MEM
+    case VIRTIO_ID_MEM:
+        features->dev_features =
+            CONVERT_FEATURES(strList, mem_map, 0, bitmap);
+        break;
+#endif
+    /* No features */
+    case VIRTIO_ID_9P:
+    case VIRTIO_ID_PMEM:
+    case VIRTIO_ID_RNG:
+    case VIRTIO_ID_IOMEM:
+    case VIRTIO_ID_RPMSG:
+    case VIRTIO_ID_CLOCK:
+    case VIRTIO_ID_MAC80211_WLAN:
+    case VIRTIO_ID_MAC80211_HWSIM:
+    case VIRTIO_ID_RPROC_SERIAL:
+    case VIRTIO_ID_MEMORY_BALLOON:
+    case VIRTIO_ID_CAIF:
+    case VIRTIO_ID_SIGNAL_DIST:
+    case VIRTIO_ID_PSTORE:
+    case VIRTIO_ID_SOUND:
+    case VIRTIO_ID_BT:
+    case VIRTIO_ID_I2C_ADAPTER:
+    case VIRTIO_ID_RPMB:
+    case VIRTIO_ID_VIDEO_ENCODER:
+    case VIRTIO_ID_VIDEO_DECODER:
+    case VIRTIO_ID_SCMI:
+    case VIRTIO_ID_NITRO_SEC_MOD:
+    case VIRTIO_ID_WATCHDOG:
+    case VIRTIO_ID_CAN:
+    case VIRTIO_ID_DMABUF:
+    case VIRTIO_ID_PARAM_SERV:
+    case VIRTIO_ID_AUDIO_POLICY:
+    case VIRTIO_ID_GPIO:
+        break;
+    default:
+        g_assert_not_reached();
+    }
+
+    features->has_unknown_dev_features = bitmap != 0;
+    if (features->has_unknown_dev_features) {
+        features->unknown_dev_features = bitmap;
+    }
+
+    return features;
+}
+
 VirtioStatus *qmp_x_query_virtio_status(const char *path, Error **errp)
 {
     VirtIODevice *vdev;
@@ -3978,9 +4252,12 @@ VirtioStatus *qmp_x_query_virtio_status(const char *path, Error **errp)
     status->name = g_strdup(vdev->name);
     status->device_id = vdev->device_id;
     status->vhost_started = vdev->vhost_started;
-    status->guest_features = vdev->guest_features;
-    status->host_features = vdev->host_features;
-    status->backend_features = vdev->backend_features;
+    status->guest_features = qmp_decode_features(vdev->device_id,
+                                                 vdev->guest_features);
+    status->host_features = qmp_decode_features(vdev->device_id,
+                                                vdev->host_features);
+    status->backend_features = qmp_decode_features(vdev->device_id,
+                                                   vdev->backend_features);
 
     switch (vdev->device_endian) {
     case VIRTIO_DEVICE_ENDIAN_LITTLE:
@@ -3995,7 +4272,7 @@ VirtioStatus *qmp_x_query_virtio_status(const char *path, Error **errp)
     }
 
     status->num_vqs = virtio_get_num_queues(vdev);
-    status->status = vdev->status;
+    status->status = qmp_decode_status(vdev->status);
     status->isr = vdev->isr;
     status->queue_sel = vdev->queue_sel;
     status->vm_running = vdev->vm_running;
@@ -4018,10 +4295,14 @@ VirtioStatus *qmp_x_query_virtio_status(const char *path, Error **errp)
         status->vhost_dev->n_tmp_sections = hdev->n_tmp_sections;
         status->vhost_dev->nvqs = hdev->nvqs;
         status->vhost_dev->vq_index = hdev->vq_index;
-        status->vhost_dev->features = hdev->features;
-        status->vhost_dev->acked_features = hdev->acked_features;
-        status->vhost_dev->backend_features = hdev->backend_features;
-        status->vhost_dev->protocol_features = hdev->protocol_features;
+        status->vhost_dev->features =
+            qmp_decode_features(vdev->device_id, hdev->features);
+        status->vhost_dev->acked_features =
+            qmp_decode_features(vdev->device_id, hdev->acked_features);
+        status->vhost_dev->backend_features =
+            qmp_decode_features(vdev->device_id, hdev->backend_features);
+        status->vhost_dev->protocol_features =
+            qmp_decode_protocols(hdev->protocol_features);
         status->vhost_dev->max_queues = hdev->max_queues;
         status->vhost_dev->backend_cap = hdev->backend_cap;
         status->vhost_dev->log_enabled = hdev->log_enabled;
-- 
MST

