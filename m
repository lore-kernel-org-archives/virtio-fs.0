Return-Path: <mst@redhat.com>
Date: Mon, 16 May 2022 06:39:01 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20220516095448.507876-59-mst@redhat.com>
References: <20220516095448.507876-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220516095448.507876-1-mst@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 58/91] hw/virtio: move virtio-pci.h into shared
 include space
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, David Hildenbrand <david@redhat.com>, Eric Auger <eric.auger@redhat.com>, virtio-fs@redhat.com

From: Alex Bennée <alex.bennee@linaro.org>

This allows other device classes that will be exposed via PCI to be
able to do so in the appropriate hw/ directory. I resisted the
temptation to re-order headers to be more aesthetically pleasing.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20200925125147.26943-4-alex.bennee@linaro.org>

Message-Id: <20220321153037.3622127-2-alex.bennee@linaro.org>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 {hw => include/hw}/virtio/virtio-pci.h | 0
 hw/virtio/vhost-scsi-pci.c             | 2 +-
 hw/virtio/vhost-user-blk-pci.c         | 2 +-
 hw/virtio/vhost-user-fs-pci.c          | 2 +-
 hw/virtio/vhost-user-i2c-pci.c         | 2 +-
 hw/virtio/vhost-user-input-pci.c       | 2 +-
 hw/virtio/vhost-user-rng-pci.c         | 2 +-
 hw/virtio/vhost-user-scsi-pci.c        | 2 +-
 hw/virtio/vhost-user-vsock-pci.c       | 2 +-
 hw/virtio/vhost-vsock-pci.c            | 2 +-
 hw/virtio/virtio-9p-pci.c              | 2 +-
 hw/virtio/virtio-balloon-pci.c         | 2 +-
 hw/virtio/virtio-blk-pci.c             | 2 +-
 hw/virtio/virtio-input-host-pci.c      | 2 +-
 hw/virtio/virtio-input-pci.c           | 2 +-
 hw/virtio/virtio-iommu-pci.c           | 2 +-
 hw/virtio/virtio-net-pci.c             | 2 +-
 hw/virtio/virtio-pci.c                 | 2 +-
 hw/virtio/virtio-rng-pci.c             | 2 +-
 hw/virtio/virtio-scsi-pci.c            | 2 +-
 hw/virtio/virtio-serial-pci.c          | 2 +-
 21 files changed, 20 insertions(+), 20 deletions(-)
 rename {hw => include/hw}/virtio/virtio-pci.h (100%)

diff --git a/hw/virtio/virtio-pci.h b/include/hw/virtio/virtio-pci.h
similarity index 100%
rename from hw/virtio/virtio-pci.h
rename to include/hw/virtio/virtio-pci.h
diff --git a/hw/virtio/vhost-scsi-pci.c b/hw/virtio/vhost-scsi-pci.c
index cb71a294fa..08980bc23b 100644
--- a/hw/virtio/vhost-scsi-pci.c
+++ b/hw/virtio/vhost-scsi-pci.c
@@ -21,7 +21,7 @@
 #include "hw/virtio/vhost-scsi.h"
 #include "qapi/error.h"
 #include "qemu/module.h"
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "qom/object.h"
 
 typedef struct VHostSCSIPCI VHostSCSIPCI;
diff --git a/hw/virtio/vhost-user-blk-pci.c b/hw/virtio/vhost-user-blk-pci.c
index 33b404d8a2..eef8641a98 100644
--- a/hw/virtio/vhost-user-blk-pci.c
+++ b/hw/virtio/vhost-user-blk-pci.c
@@ -26,7 +26,7 @@
 #include "qapi/error.h"
 #include "qemu/error-report.h"
 #include "qemu/module.h"
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "qom/object.h"
 
 typedef struct VHostUserBlkPCI VHostUserBlkPCI;
diff --git a/hw/virtio/vhost-user-fs-pci.c b/hw/virtio/vhost-user-fs-pci.c
index 2ed8492b3f..6829b8b743 100644
--- a/hw/virtio/vhost-user-fs-pci.c
+++ b/hw/virtio/vhost-user-fs-pci.c
@@ -14,7 +14,7 @@
 #include "qemu/osdep.h"
 #include "hw/qdev-properties.h"
 #include "hw/virtio/vhost-user-fs.h"
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "qom/object.h"
 
 struct VHostUserFSPCI {
diff --git a/hw/virtio/vhost-user-i2c-pci.c b/hw/virtio/vhost-user-i2c-pci.c
index 70b7b65fd9..00ac10941f 100644
--- a/hw/virtio/vhost-user-i2c-pci.c
+++ b/hw/virtio/vhost-user-i2c-pci.c
@@ -9,7 +9,7 @@
 #include "qemu/osdep.h"
 #include "hw/qdev-properties.h"
 #include "hw/virtio/vhost-user-i2c.h"
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 
 struct VHostUserI2CPCI {
     VirtIOPCIProxy parent_obj;
diff --git a/hw/virtio/vhost-user-input-pci.c b/hw/virtio/vhost-user-input-pci.c
index c9d3e9113a..b858898a36 100644
--- a/hw/virtio/vhost-user-input-pci.c
+++ b/hw/virtio/vhost-user-input-pci.c
@@ -9,7 +9,7 @@
 #include "hw/virtio/virtio-input.h"
 #include "qapi/error.h"
 #include "qemu/error-report.h"
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "qom/object.h"
 
 typedef struct VHostUserInputPCI VHostUserInputPCI;
diff --git a/hw/virtio/vhost-user-rng-pci.c b/hw/virtio/vhost-user-rng-pci.c
index c83dc86813..f64935453b 100644
--- a/hw/virtio/vhost-user-rng-pci.c
+++ b/hw/virtio/vhost-user-rng-pci.c
@@ -9,7 +9,7 @@
 #include "qemu/osdep.h"
 #include "hw/qdev-properties.h"
 #include "hw/virtio/vhost-user-rng.h"
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 
 struct VHostUserRNGPCI {
     VirtIOPCIProxy parent_obj;
diff --git a/hw/virtio/vhost-user-scsi-pci.c b/hw/virtio/vhost-user-scsi-pci.c
index d5343412a1..75882e3cf9 100644
--- a/hw/virtio/vhost-user-scsi-pci.c
+++ b/hw/virtio/vhost-user-scsi-pci.c
@@ -30,7 +30,7 @@
 #include "hw/pci/msix.h"
 #include "hw/loader.h"
 #include "sysemu/kvm.h"
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "qom/object.h"
 
 typedef struct VHostUserSCSIPCI VHostUserSCSIPCI;
diff --git a/hw/virtio/vhost-user-vsock-pci.c b/hw/virtio/vhost-user-vsock-pci.c
index 72a96199cd..e5a86e8013 100644
--- a/hw/virtio/vhost-user-vsock-pci.c
+++ b/hw/virtio/vhost-user-vsock-pci.c
@@ -10,7 +10,7 @@
 
 #include "qemu/osdep.h"
 
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "hw/qdev-properties.h"
 #include "hw/virtio/vhost-user-vsock.h"
 #include "qom/object.h"
diff --git a/hw/virtio/vhost-vsock-pci.c b/hw/virtio/vhost-vsock-pci.c
index 205da8d1f5..9f34414d38 100644
--- a/hw/virtio/vhost-vsock-pci.c
+++ b/hw/virtio/vhost-vsock-pci.c
@@ -13,7 +13,7 @@
 
 #include "qemu/osdep.h"
 
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "hw/qdev-properties.h"
 #include "hw/virtio/vhost-vsock.h"
 #include "qemu/module.h"
diff --git a/hw/virtio/virtio-9p-pci.c b/hw/virtio/virtio-9p-pci.c
index e07adcd9ea..94c14f0b98 100644
--- a/hw/virtio/virtio-9p-pci.c
+++ b/hw/virtio/virtio-9p-pci.c
@@ -15,7 +15,7 @@
 
 #include "qemu/osdep.h"
 
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "hw/9pfs/virtio-9p.h"
 #include "hw/qdev-properties.h"
 #include "qemu/module.h"
diff --git a/hw/virtio/virtio-balloon-pci.c b/hw/virtio/virtio-balloon-pci.c
index 79a3ba979a..ce2645ba71 100644
--- a/hw/virtio/virtio-balloon-pci.c
+++ b/hw/virtio/virtio-balloon-pci.c
@@ -14,7 +14,7 @@
 
 #include "qemu/osdep.h"
 
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "hw/qdev-properties.h"
 #include "hw/virtio/virtio-balloon.h"
 #include "qapi/error.h"
diff --git a/hw/virtio/virtio-blk-pci.c b/hw/virtio/virtio-blk-pci.c
index 9d5795810c..9743bee965 100644
--- a/hw/virtio/virtio-blk-pci.c
+++ b/hw/virtio/virtio-blk-pci.c
@@ -19,7 +19,7 @@
 
 #include "hw/qdev-properties.h"
 #include "hw/virtio/virtio-blk.h"
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "qapi/error.h"
 #include "qemu/module.h"
 #include "qom/object.h"
diff --git a/hw/virtio/virtio-input-host-pci.c b/hw/virtio/virtio-input-host-pci.c
index 0ac360de4f..cf8a9cf9e8 100644
--- a/hw/virtio/virtio-input-host-pci.c
+++ b/hw/virtio/virtio-input-host-pci.c
@@ -8,7 +8,7 @@
 
 #include "qemu/osdep.h"
 
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "hw/virtio/virtio-input.h"
 #include "qemu/module.h"
 #include "qom/object.h"
diff --git a/hw/virtio/virtio-input-pci.c b/hw/virtio/virtio-input-pci.c
index 48e9ff38e2..a9d0992389 100644
--- a/hw/virtio/virtio-input-pci.c
+++ b/hw/virtio/virtio-input-pci.c
@@ -8,7 +8,7 @@
 
 #include "qemu/osdep.h"
 
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "hw/qdev-properties.h"
 #include "hw/virtio/virtio-input.h"
 #include "qemu/module.h"
diff --git a/hw/virtio/virtio-iommu-pci.c b/hw/virtio/virtio-iommu-pci.c
index 6a1df7fe50..844d647704 100644
--- a/hw/virtio/virtio-iommu-pci.c
+++ b/hw/virtio/virtio-iommu-pci.c
@@ -11,7 +11,7 @@
 
 #include "qemu/osdep.h"
 
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "hw/virtio/virtio-iommu.h"
 #include "hw/qdev-properties.h"
 #include "hw/qdev-properties-system.h"
diff --git a/hw/virtio/virtio-net-pci.c b/hw/virtio/virtio-net-pci.c
index aa0b3caecb..e03543a70a 100644
--- a/hw/virtio/virtio-net-pci.c
+++ b/hw/virtio/virtio-net-pci.c
@@ -19,7 +19,7 @@
 
 #include "hw/qdev-properties.h"
 #include "hw/virtio/virtio-net.h"
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "qapi/error.h"
 #include "qemu/module.h"
 #include "qom/object.h"
diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
index 7cf1231c1c..602be7f83d 100644
--- a/hw/virtio/virtio-pci.c
+++ b/hw/virtio/virtio-pci.c
@@ -33,7 +33,7 @@
 #include "hw/pci/msix.h"
 #include "hw/loader.h"
 #include "sysemu/kvm.h"
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "qemu/range.h"
 #include "hw/virtio/virtio-bus.h"
 #include "qapi/visitor.h"
diff --git a/hw/virtio/virtio-rng-pci.c b/hw/virtio/virtio-rng-pci.c
index c1f916268b..151ece6f94 100644
--- a/hw/virtio/virtio-rng-pci.c
+++ b/hw/virtio/virtio-rng-pci.c
@@ -11,7 +11,7 @@
 
 #include "qemu/osdep.h"
 
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "hw/virtio/virtio-rng.h"
 #include "qapi/error.h"
 #include "qemu/module.h"
diff --git a/hw/virtio/virtio-scsi-pci.c b/hw/virtio/virtio-scsi-pci.c
index 97fab74236..e8e3442f38 100644
--- a/hw/virtio/virtio-scsi-pci.c
+++ b/hw/virtio/virtio-scsi-pci.c
@@ -18,7 +18,7 @@
 #include "hw/qdev-properties.h"
 #include "hw/virtio/virtio-scsi.h"
 #include "qemu/module.h"
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "qom/object.h"
 
 typedef struct VirtIOSCSIPCI VirtIOSCSIPCI;
diff --git a/hw/virtio/virtio-serial-pci.c b/hw/virtio/virtio-serial-pci.c
index 35bcd961c9..cea31adcc4 100644
--- a/hw/virtio/virtio-serial-pci.c
+++ b/hw/virtio/virtio-serial-pci.c
@@ -20,7 +20,7 @@
 #include "hw/qdev-properties.h"
 #include "hw/virtio/virtio-serial.h"
 #include "qemu/module.h"
-#include "virtio-pci.h"
+#include "hw/virtio/virtio-pci.h"
 #include "qom/object.h"
 
 typedef struct VirtIOSerialPCI VirtIOSerialPCI;
-- 
MST

