From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  9 Feb 2021 19:02:16 +0000
Message-Id: <20210209190224.62827-17-dgilbert@redhat.com>
In-Reply-To: <20210209190224.62827-1-dgilbert@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 16/24] DAX/unmap: virtiofsd: Add
	VHOST_USER_SLAVE_FS_IO
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

Define a new slave command 'VHOST_USER_SLAVE_FS_IO' for a
client to ask qemu to perform a read/write from an fd directly
to GPA.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 docs/interop/vhost-user.rst               | 11 +++
 hw/virtio/trace-events                    |  6 ++
 hw/virtio/vhost-user-fs.c                 | 84 +++++++++++++++++++++++
 hw/virtio/vhost-user.c                    |  4 ++
 include/hw/virtio/vhost-user-fs.h         |  2 +
 subprojects/libvhost-user/libvhost-user.h |  1 +
 6 files changed, 108 insertions(+)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index 1deedd3407..821712f4a2 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -1452,6 +1452,17 @@ Slave message types
   multiple chunks can be unmapped in one command.
   A reply is generated indicating whether unmapping succeeded.
 
+``VHOST_USER_SLAVE_FS_IO``
+  :id: 9
+  :equivalent ioctl: N/A
+  :slave payload: fd + n * (offset + address + len)
+  :master payload: N/A
+
+  Requests that the QEMU performs IO directly from an fd to guest memory
+  on behalf of the daemon; this is normally for a case where a memory region
+  isn't visible to the daemon. slave payload has flags which determine
+  the direction of IO operation.
+
 .. _reply_ack:
 
 VHOST_USER_PROTOCOL_F_REPLY_ACK
diff --git a/hw/virtio/trace-events b/hw/virtio/trace-events
index c62727f879..20557a078e 100644
--- a/hw/virtio/trace-events
+++ b/hw/virtio/trace-events
@@ -53,6 +53,12 @@ vhost_vdpa_get_features(void *dev, uint64_t features) "dev: %p features: 0x%"PRI
 vhost_vdpa_set_owner(void *dev) "dev: %p"
 vhost_vdpa_vq_get_addr(void *dev, void *vq, uint64_t desc_user_addr, uint64_t avail_user_addr, uint64_t used_user_addr) "dev: %p vq: %p desc_user_addr: 0x%"PRIx64" avail_user_addr: 0x%"PRIx64" used_user_addr: 0x%"PRIx64
 
+# vhost-user-fs.c
+
+vhost_user_fs_slave_io_loop(const char *name, uint64_t owr, int is_ram, int is_romd, size_t size) "region %s with internal offset 0x%"PRIx64 " ram=%d romd=%d mrs.size=%zd"
+vhost_user_fs_slave_io_loop_res(ssize_t transferred) "%zd"
+vhost_user_fs_slave_io_exit(int res, size_t done) "res: %d done: %zd"
+
 # virtio.c
 virtqueue_alloc_element(void *elem, size_t sz, unsigned in_num, unsigned out_num) "elem %p size %zd in_num %u out_num %u"
 virtqueue_fill(void *vq, const void *elem, unsigned int len, unsigned int idx) "vq %p elem %p len %u idx %u"
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 5f2fca4d82..357bc1d04e 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -23,6 +23,8 @@
 #include "hw/virtio/vhost-user-fs.h"
 #include "monitor/monitor.h"
 #include "sysemu/sysemu.h"
+#include "exec/address-spaces.h"
+#include "trace.h"
 
 /*
  * The powerpc kernel code expects the memory to be accessible during
@@ -155,6 +157,88 @@ uint64_t vhost_user_fs_slave_unmap(struct vhost_dev *dev,
     return (uint64_t)res;
 }
 
+uint64_t vhost_user_fs_slave_io(struct vhost_dev *dev, VhostUserFSSlaveMsg *sm,
+                                int fd)
+{
+    VHostUserFS *fs = VHOST_USER_FS(dev->vdev);
+    if (!fs) {
+        /* Shouldn't happen - but seen it in error paths */
+        error_report("Bad fs ptr");
+        return (uint64_t)-1;
+    }
+
+    unsigned int i;
+    int res = 0;
+    size_t done = 0;
+
+    if (fd < 0) {
+        error_report("Bad fd for map");
+        return (uint64_t)-1;
+    }
+
+    for (i = 0; i < VHOST_USER_FS_SLAVE_ENTRIES && !res; i++) {
+        if (sm->len[i] == 0) {
+            continue;
+        }
+
+        size_t len = sm->len[i];
+        hwaddr gpa = sm->c_offset[i];
+
+        while (len && !res) {
+            MemoryRegionSection mrs = memory_region_find(get_system_memory(),
+                                                         gpa, len);
+            size_t mrs_size = (size_t)int128_get64(mrs.size);
+
+            if (!mrs_size) {
+                error_report("No guest region found for 0x%" HWADDR_PRIx, gpa);
+                res = -EFAULT;
+                break;
+            }
+
+            trace_vhost_user_fs_slave_io_loop(mrs.mr->name,
+                                          (uint64_t)mrs.offset_within_region,
+                                          memory_region_is_ram(mrs.mr),
+                                          memory_region_is_romd(mrs.mr),
+                                          (size_t)mrs_size);
+
+            void *hostptr = qemu_map_ram_ptr(mrs.mr->ram_block,
+                                             mrs.offset_within_region);
+            ssize_t transferred;
+            if (sm->flags[i] & VHOST_USER_FS_FLAG_MAP_R) {
+                /* Read from file into RAM */
+                if (mrs.mr->readonly) {
+                    res = -EFAULT;
+                    break;
+                }
+                transferred = pread(fd, hostptr, mrs_size, sm->fd_offset[i]);
+            } else {
+                /* Write into file from RAM */
+                assert((sm->flags[i] & VHOST_USER_FS_FLAG_MAP_W));
+                transferred = pwrite(fd, hostptr, mrs_size, sm->fd_offset[i]);
+            }
+            trace_vhost_user_fs_slave_io_loop_res(transferred);
+            if (transferred < 0) {
+                res = -errno;
+                break;
+            }
+            if (!transferred) {
+                /* EOF */
+                break;
+            }
+
+            done += transferred;
+            len -= transferred;
+        }
+    }
+    close(fd);
+
+    trace_vhost_user_fs_slave_io_exit(res, done);
+    if (res < 0) {
+        return (uint64_t)res;
+    }
+    return (uint64_t)done;
+}
+
 static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 21e40ff91a..0bc83c2714 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -137,6 +137,7 @@ typedef enum VhostUserSlaveRequest {
     VHOST_USER_SLAVE_VRING_ERR = 5,
     VHOST_USER_SLAVE_FS_MAP = 6,
     VHOST_USER_SLAVE_FS_UNMAP = 7,
+    VHOST_USER_SLAVE_FS_IO = 8,
     VHOST_USER_SLAVE_MAX
 }  VhostUserSlaveRequest;
 
@@ -1485,6 +1486,9 @@ static void slave_read(void *opaque)
     case VHOST_USER_SLAVE_FS_UNMAP:
         ret = vhost_user_fs_slave_unmap(dev, &payload.fs);
         break;
+    case VHOST_USER_SLAVE_FS_IO:
+        ret = vhost_user_fs_slave_io(dev, &payload.fs, fd[0]);
+        break;
 #endif
     default:
         error_report("Received unexpected msg type: %d.", hdr.request);
diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
index 25e14ab17a..ffd3165c29 100644
--- a/include/hw/virtio/vhost-user-fs.h
+++ b/include/hw/virtio/vhost-user-fs.h
@@ -69,5 +69,7 @@ uint64_t vhost_user_fs_slave_map(struct vhost_dev *dev, VhostUserFSSlaveMsg *sm,
                                  int fd);
 uint64_t vhost_user_fs_slave_unmap(struct vhost_dev *dev,
                                    VhostUserFSSlaveMsg *sm);
+uint64_t vhost_user_fs_slave_io(struct vhost_dev *dev, VhostUserFSSlaveMsg *sm,
+                                int fd);
 
 #endif /* _QEMU_VHOST_USER_FS_H */
diff --git a/subprojects/libvhost-user/libvhost-user.h b/subprojects/libvhost-user/libvhost-user.h
index 150b1121cc..a398148ed9 100644
--- a/subprojects/libvhost-user/libvhost-user.h
+++ b/subprojects/libvhost-user/libvhost-user.h
@@ -121,6 +121,7 @@ typedef enum VhostUserSlaveRequest {
     VHOST_USER_SLAVE_VRING_ERR = 5,
     VHOST_USER_SLAVE_FS_MAP = 6,
     VHOST_USER_SLAVE_FS_UNMAP = 7,
+    VHOST_USER_SLAVE_FS_IO = 8,
     VHOST_USER_SLAVE_MAX
 }  VhostUserSlaveRequest;
 
-- 
2.29.2

