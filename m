From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  9 Feb 2021 19:02:06 +0000
Message-Id: <20210209190224.62827-7-dgilbert@redhat.com>
In-Reply-To: <20210209190224.62827-1-dgilbert@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 06/24] DAX: virtio-fs: Add cache BAR
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

Add a cache BAR into which files will be directly mapped.
The size can be set with the cache-size= property, e.g.
   -device vhost-user-fs-pci,chardev=char0,tag=myfs,cache-size=16G

The default is no cache.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
with PPC fixes by:
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 hw/virtio/vhost-user-fs-pci.c     | 25 ++++++++++++++++++++++++
 hw/virtio/vhost-user-fs.c         | 32 +++++++++++++++++++++++++++++++
 include/hw/virtio/vhost-user-fs.h |  2 ++
 3 files changed, 59 insertions(+)

diff --git a/hw/virtio/vhost-user-fs-pci.c b/hw/virtio/vhost-user-fs-pci.c
index 2ed8492b3f..0388e063c6 100644
--- a/hw/virtio/vhost-user-fs-pci.c
+++ b/hw/virtio/vhost-user-fs-pci.c
@@ -16,10 +16,14 @@
 #include "hw/virtio/vhost-user-fs.h"
 #include "virtio-pci.h"
 #include "qom/object.h"
+#include "standard-headers/linux/virtio_fs.h"
+
+#define VIRTIO_FS_PCI_CACHE_BAR 2
 
 struct VHostUserFSPCI {
     VirtIOPCIProxy parent_obj;
     VHostUserFS vdev;
+    MemoryRegion cachebar;
 };
 
 typedef struct VHostUserFSPCI VHostUserFSPCI;
@@ -39,6 +43,7 @@ static void vhost_user_fs_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
 {
     VHostUserFSPCI *dev = VHOST_USER_FS_PCI(vpci_dev);
     DeviceState *vdev = DEVICE(&dev->vdev);
+    uint64_t cachesize;
 
     if (vpci_dev->nvectors == DEV_NVECTORS_UNSPECIFIED) {
         /* Also reserve config change and hiprio queue vectors */
@@ -46,6 +51,26 @@ static void vhost_user_fs_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
     }
 
     qdev_realize(vdev, BUS(&vpci_dev->bus), errp);
+    cachesize = dev->vdev.conf.cache_size;
+
+    /*
+     * The bar starts with the data/DAX cache
+     * Others will be added later.
+     */
+    memory_region_init(&dev->cachebar, OBJECT(vpci_dev),
+                       "vhost-fs-pci-cachebar", cachesize);
+    if (cachesize) {
+        memory_region_add_subregion(&dev->cachebar, 0, &dev->vdev.cache);
+        virtio_pci_add_shm_cap(vpci_dev, VIRTIO_FS_PCI_CACHE_BAR, 0, cachesize,
+                               VIRTIO_FS_SHMCAP_ID_CACHE);
+    }
+
+    /* After 'realized' so the memory region exists */
+    pci_register_bar(&vpci_dev->pci_dev, VIRTIO_FS_PCI_CACHE_BAR,
+                     PCI_BASE_ADDRESS_SPACE_MEMORY |
+                     PCI_BASE_ADDRESS_MEM_PREFETCH |
+                     PCI_BASE_ADDRESS_MEM_TYPE_64,
+                     &dev->cachebar);
 }
 
 static void vhost_user_fs_pci_class_init(ObjectClass *klass, void *data)
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index ac4fc34b36..b077d8e705 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -24,6 +24,16 @@
 #include "monitor/monitor.h"
 #include "sysemu/sysemu.h"
 
+/*
+ * The powerpc kernel code expects the memory to be accessible during
+ * addition/removal.
+ */
+#if defined(TARGET_PPC64) && defined(CONFIG_LINUX)
+#define DAX_WINDOW_PROT PROT_READ
+#else
+#define DAX_WINDOW_PROT PROT_NONE
+#endif
+
 static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
@@ -163,6 +173,7 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
     VHostUserFS *fs = VHOST_USER_FS(dev);
+    void *cache_ptr;
     unsigned int i;
     size_t len;
     int ret;
@@ -202,6 +213,26 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
                    VIRTQUEUE_MAX_SIZE);
         return;
     }
+    if (fs->conf.cache_size &&
+        (!is_power_of_2(fs->conf.cache_size) ||
+          fs->conf.cache_size < qemu_real_host_page_size)) {
+        error_setg(errp, "cache-size property must be a power of 2 "
+                         "no smaller than the page size");
+        return;
+    }
+    if (fs->conf.cache_size) {
+        /* Anonymous, private memory is not counted as overcommit */
+        cache_ptr = mmap(NULL, fs->conf.cache_size, DAX_WINDOW_PROT,
+                         MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+        if (cache_ptr == MAP_FAILED) {
+            error_setg(errp, "Unable to mmap blank cache");
+            return;
+        }
+
+        memory_region_init_ram_ptr(&fs->cache, OBJECT(vdev),
+                                   "virtio-fs-cache",
+                                   fs->conf.cache_size, cache_ptr);
+    }
 
     if (!vhost_user_init(&fs->vhost_user, &fs->conf.chardev, errp)) {
         return;
@@ -277,6 +308,7 @@ static Property vuf_properties[] = {
     DEFINE_PROP_UINT16("num-request-queues", VHostUserFS,
                        conf.num_request_queues, 1),
     DEFINE_PROP_UINT16("queue-size", VHostUserFS, conf.queue_size, 128),
+    DEFINE_PROP_SIZE("cache-size", VHostUserFS, conf.cache_size, 0),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
index 0d62834c25..04596799e3 100644
--- a/include/hw/virtio/vhost-user-fs.h
+++ b/include/hw/virtio/vhost-user-fs.h
@@ -28,6 +28,7 @@ typedef struct {
     char *tag;
     uint16_t num_request_queues;
     uint16_t queue_size;
+    uint64_t cache_size;
 } VHostUserFSConf;
 
 struct VHostUserFS {
@@ -42,6 +43,7 @@ struct VHostUserFS {
     int32_t bootindex;
 
     /*< public >*/
+    MemoryRegion cache;
 };
 
 #endif /* _QEMU_VHOST_USER_FS_H */
-- 
2.29.2

