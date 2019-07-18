From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu, 18 Jul 2019 16:13:55 +0100
Message-Id: <20190718151355.11461-3-dgilbert@redhat.com>
In-Reply-To: <20190718151355.11461-1-dgilbert@redhat.com>
References: <20190718151355.11461-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/2] virto/shared memory: Rework for
	standardised id field
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, vgoyal@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

During virtio shared memory standardisation we've
moved the 'id' field, out of a special capability
and into the main virtio_pci_cap.

The name of the new 64 bit extensions have changes
as well.

Fixup these changes;  this commit can probably be
squahed into:
   3d2660c667307350d17fdfb7148c8751a442aa6b   virtio: Implement get_shm_region for PCI transport

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 drivers/virtio/virtio_pci_modern.c |  8 ++++----
 include/uapi/linux/virtio_pci.h    | 14 ++++++--------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 51c9e6eca5ac..d7838bf0f237 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -468,13 +468,13 @@ static int virtio_pci_find_shm_cap(struct pci_dev *dev,
 		pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
                                                          cap_len),
                                      &cap_len);
-                if (cap_len != sizeof(struct virtio_pci_shm_cap)) {
+                if (cap_len != sizeof(struct virtio_pci_cap64)) {
 		        printk(KERN_ERR "%s: shm cap with bad size offset: %d size: %d\n",
                                __func__, pos, cap_len);
                         continue;
                 };
 
-		pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_shm_cap,
+		pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
                                                          id),
                                      &id);
                 if (id != required_id)
@@ -495,12 +495,12 @@ static int virtio_pci_find_shm_cap(struct pci_dev *dev,
 
                 /* and now the top half */
                 pci_read_config_dword(dev,
-                                      pos + offsetof(struct virtio_pci_shm_cap,
+                                      pos + offsetof(struct virtio_pci_cap64,
                                                      offset_hi),
                                       &tmp32);
                 res_offset |= ((u64)tmp32) << 32;
                 pci_read_config_dword(dev,
-                                      pos + offsetof(struct virtio_pci_shm_cap,
+                                      pos + offsetof(struct virtio_pci_cap64,
                                                      length_hi),
                                       &tmp32);
                 res_length |= ((u64)tmp32) << 32;
diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 961bb6e6315c..fe9f43680a1d 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -129,6 +129,12 @@ struct virtio_pci_cap {
 	__le32 length;		/* Length of the structure, in bytes. */
 };
 
+struct virtio_pci_cap64 {
+       struct virtio_pci_cap cap;
+       __le32 offset_hi;             /* Most sig 32 bits of offset */
+       __le32 length_hi;             /* Most sig 32 bits of length */
+};
+
 struct virtio_pci_notify_cap {
 	struct virtio_pci_cap cap;
 	__le32 notify_off_multiplier;	/* Multiplier for queue_notify_off. */
@@ -166,14 +172,6 @@ struct virtio_pci_cfg_cap {
 	__u8 pci_cfg_data[4]; /* Data for BAR access. */
 };
 
-/* Fields in VIRTIO_PCI_CAP_SHARED_MEMORY_CFG */
-struct virtio_pci_shm_cap {
-       struct virtio_pci_cap cap;
-       __le32 offset_hi;             /* Most sig 32 bits of offset */
-       __le32 length_hi;             /* Most sig 32 bits of length */
-        __u8   id;                    /* To distinguish shm chunks */
-};
-
 /* Macro versions of offsets for the Old Timers! */
 #define VIRTIO_PCI_CAP_VNDR		0
 #define VIRTIO_PCI_CAP_NEXT		1
-- 
2.21.0

