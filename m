From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 28 Apr 2021 12:00:41 +0100
Message-Id: <20210428110100.27757-8-dgilbert@redhat.com>
In-Reply-To: <20210428110100.27757-1-dgilbert@redhat.com>
References: <20210428110100.27757-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 07/26] DAX: virtio: Add shared memory
	capability
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, groug@kaod.org
Cc: virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Define a new capability type 'VIRTIO_PCI_CAP_SHARED_MEMORY_CFG'
and the data structure 'virtio_pci_cap64' to go with it.
They allow defining shared memory regions with sizes and offsets
of 2^32 and more.
Multiple instances of the capability are allowed and distinguished
by the 'id' field in the base capability.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 hw/virtio/virtio-pci.c | 20 ++++++++++++++++++++
 hw/virtio/virtio-pci.h |  4 ++++
 2 files changed, 24 insertions(+)

diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
index b321604d9b..493014fdf7 100644
--- a/hw/virtio/virtio-pci.c
+++ b/hw/virtio/virtio-pci.c
@@ -1138,6 +1138,26 @@ static int virtio_pci_add_mem_cap(VirtIOPCIProxy *proxy,
     return offset;
 }
 
+int virtio_pci_add_shm_cap(VirtIOPCIProxy *proxy,
+                           uint8_t bar, uint64_t offset, uint64_t length,
+                           uint8_t id)
+{
+    struct virtio_pci_cap64 cap = {
+        .cap.cap_len = sizeof cap,
+        .cap.cfg_type = VIRTIO_PCI_CAP_SHARED_MEMORY_CFG,
+    };
+    uint32_t mask32 = ~0;
+
+    cap.cap.bar = bar;
+    cap.cap.id = id;
+    cap.cap.length = cpu_to_le32(length & mask32);
+    cap.length_hi = cpu_to_le32((length >> 32) & mask32);
+    cap.cap.offset = cpu_to_le32(offset & mask32);
+    cap.offset_hi = cpu_to_le32((offset >> 32) & mask32);
+
+    return virtio_pci_add_mem_cap(proxy, &cap.cap);
+}
+
 static uint64_t virtio_pci_common_read(void *opaque, hwaddr addr,
                                        unsigned size)
 {
diff --git a/hw/virtio/virtio-pci.h b/hw/virtio/virtio-pci.h
index 2446dcd9ae..5e5c4a4c6d 100644
--- a/hw/virtio/virtio-pci.h
+++ b/hw/virtio/virtio-pci.h
@@ -252,4 +252,8 @@ void virtio_pci_types_register(const VirtioPCIDeviceTypeInfo *t);
  */
 unsigned virtio_pci_optimal_num_queues(unsigned fixed_queues);
 
+int virtio_pci_add_shm_cap(VirtIOPCIProxy *proxy,
+                           uint8_t bar, uint64_t offset, uint64_t length,
+                           uint8_t id);
+
 #endif
-- 
2.31.1

