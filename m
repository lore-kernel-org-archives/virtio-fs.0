Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu, 20 Apr 2023 08:09:29 -0400
Message-Id: <20230420120948.436661-2-stefanha@redhat.com>
In-Reply-To: <20230420120948.436661-1-stefanha@redhat.com>
References: <20230420120948.436661-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 01/20] block/block-common: add zoned device
 structs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Julia Suvorova <jusual@redhat.com>, Eric Blake <eblake@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org, Cornelia Huck <cohuck@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Fam Zheng <fam@euphon.net>, Aarushi Mehta <mehta.aaru20@gmail.com>, Sam Li <faithilikerun@gmail.com>, Damien Le Moal <damien.lemoal@opensource.wdc.com>, Hannes Reinecke <hare@suse.de>, Dmitry Fomichev <dmitry.fomichev@wdc.com>

From: Sam Li <faithilikerun@gmail.com>

Signed-off-by: Sam Li <faithilikerun@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Acked-by: Kevin Wolf <kwolf@redhat.com>
Message-id: 20230324090605.28361-2-faithilikerun@gmail.com
[Adjust commit message prefix as suggested by Philippe Mathieu-Daudé
<philmd@linaro.org>.
--Stefan]
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/block/block-common.h | 43 ++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/include/block/block-common.h b/include/block/block-common.h
index b5122ef8ab..1576fcf2ed 100644
--- a/include/block/block-common.h
+++ b/include/block/block-common.h
@@ -75,6 +75,49 @@ typedef struct BlockDriver BlockDriver;
 typedef struct BdrvChild BdrvChild;
 typedef struct BdrvChildClass BdrvChildClass;
 
+typedef enum BlockZoneOp {
+    BLK_ZO_OPEN,
+    BLK_ZO_CLOSE,
+    BLK_ZO_FINISH,
+    BLK_ZO_RESET,
+} BlockZoneOp;
+
+typedef enum BlockZoneModel {
+    BLK_Z_NONE = 0x0, /* Regular block device */
+    BLK_Z_HM = 0x1, /* Host-managed zoned block device */
+    BLK_Z_HA = 0x2, /* Host-aware zoned block device */
+} BlockZoneModel;
+
+typedef enum BlockZoneState {
+    BLK_ZS_NOT_WP = 0x0,
+    BLK_ZS_EMPTY = 0x1,
+    BLK_ZS_IOPEN = 0x2,
+    BLK_ZS_EOPEN = 0x3,
+    BLK_ZS_CLOSED = 0x4,
+    BLK_ZS_RDONLY = 0xD,
+    BLK_ZS_FULL = 0xE,
+    BLK_ZS_OFFLINE = 0xF,
+} BlockZoneState;
+
+typedef enum BlockZoneType {
+    BLK_ZT_CONV = 0x1, /* Conventional random writes supported */
+    BLK_ZT_SWR = 0x2, /* Sequential writes required */
+    BLK_ZT_SWP = 0x3, /* Sequential writes preferred */
+} BlockZoneType;
+
+/*
+ * Zone descriptor data structure.
+ * Provides information on a zone with all position and size values in bytes.
+ */
+typedef struct BlockZoneDescriptor {
+    uint64_t start;
+    uint64_t length;
+    uint64_t cap;
+    uint64_t wp;
+    BlockZoneType type;
+    BlockZoneState state;
+} BlockZoneDescriptor;
+
 typedef struct BlockDriverInfo {
     /* in bytes, 0 if irrelevant */
     int cluster_size;
-- 
2.39.2

