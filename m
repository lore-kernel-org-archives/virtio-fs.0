From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri,  7 Aug 2020 15:55:11 -0400
Message-Id: <20200807195526.426056-6-vgoyal@redhat.com>
In-Reply-To: <20200807195526.426056-1-vgoyal@redhat.com>
References: <20200807195526.426056-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 05/20] virtio: Implement get_shm_region for
	MMIO transport
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com
Cc: kvm@vger.kernel.org, miklos@szeredi.hu, "Michael S. Tsirkin" <mst@redhat.com>, vgoyal@redhat.com

From: Sebastien Boeuf <sebastien.boeuf@intel.com>

On MMIO a new set of registers is defined for finding SHM
regions.  Add their definitions and use them to find the region.

Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
Cc: kvm@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>
---
 drivers/virtio/virtio_mmio.c     | 32 ++++++++++++++++++++++++++++++++
 include/uapi/linux/virtio_mmio.h | 11 +++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 627ac0487494..2697c492cf78 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -498,6 +498,37 @@ static const char *vm_bus_name(struct virtio_device *vdev)
 	return vm_dev->pdev->name;
 }
 
+static bool vm_get_shm_region(struct virtio_device *vdev,
+			      struct virtio_shm_region *region, u8 id)
+{
+	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
+	u64 len, addr;
+
+	/* Select the region we're interested in */
+	writel(id, vm_dev->base + VIRTIO_MMIO_SHM_SEL);
+
+	/* Read the region size */
+	len = (u64) readl(vm_dev->base + VIRTIO_MMIO_SHM_LEN_LOW);
+	len |= (u64) readl(vm_dev->base + VIRTIO_MMIO_SHM_LEN_HIGH) << 32;
+
+	region->len = len;
+
+	/* Check if region length is -1. If that's the case, the shared memory
+	 * region does not exist and there is no need to proceed further.
+	 */
+	if (len == ~(u64)0) {
+		return false;
+	}
+
+	/* Read the region base address */
+	addr = (u64) readl(vm_dev->base + VIRTIO_MMIO_SHM_BASE_LOW);
+	addr |= (u64) readl(vm_dev->base + VIRTIO_MMIO_SHM_BASE_HIGH) << 32;
+
+	region->addr = addr;
+
+	return true;
+}
+
 static const struct virtio_config_ops virtio_mmio_config_ops = {
 	.get		= vm_get,
 	.set		= vm_set,
@@ -510,6 +541,7 @@ static const struct virtio_config_ops virtio_mmio_config_ops = {
 	.get_features	= vm_get_features,
 	.finalize_features = vm_finalize_features,
 	.bus_name	= vm_bus_name,
+	.get_shm_region = vm_get_shm_region,
 };
 
 
diff --git a/include/uapi/linux/virtio_mmio.h b/include/uapi/linux/virtio_mmio.h
index c4b09689ab64..0650f91bea6c 100644
--- a/include/uapi/linux/virtio_mmio.h
+++ b/include/uapi/linux/virtio_mmio.h
@@ -122,6 +122,17 @@
 #define VIRTIO_MMIO_QUEUE_USED_LOW	0x0a0
 #define VIRTIO_MMIO_QUEUE_USED_HIGH	0x0a4
 
+/* Shared memory region id */
+#define VIRTIO_MMIO_SHM_SEL             0x0ac
+
+/* Shared memory region length, 64 bits in two halves */
+#define VIRTIO_MMIO_SHM_LEN_LOW         0x0b0
+#define VIRTIO_MMIO_SHM_LEN_HIGH        0x0b4
+
+/* Shared memory region base address, 64 bits in two halves */
+#define VIRTIO_MMIO_SHM_BASE_LOW        0x0b8
+#define VIRTIO_MMIO_SHM_BASE_HIGH       0x0bc
+
 /* Configuration atomicity value */
 #define VIRTIO_MMIO_CONFIG_GENERATION	0x0fc
 
-- 
2.25.4

