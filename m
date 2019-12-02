From: Fabiano Rosas <farosas@linux.ibm.com>
Date: Mon,  2 Dec 2019 17:26:39 -0300
Message-Id: <20191202202639.102322-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofs: Relax DAX window protection for ppc
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: qemu-ppc@nongnu.org, qemu-devel@nongnu.org

When setting up the DAX window during the virtiofs driver probe inside
the guest, the Linux arch-specific function arch_add_memory is called,
which on ppc tries to do a cache flush [1] of the recently added
memory. At this point the window is mmap'ed PROT_NONE by QEMU, which
causes the following:

<snip>
[   10.136703] virtio_fs virtio0: Cache len: 0x80000000 @ 0x210000000000
[   10.165106] radix-mmu: Mapped 0xc000210000000000-0xc000210080000000 with 1.00 GiB pages
error: kvm run failed Bad address
NIP c000000000072350   LR c000000000072304 CTR 0000000001000000 XER 0000000020040000 CPU#0
MSR 8000000002009033 HID0 0000000000000000  HF 8000000000000000 iidx 3 didx 3
TB 00000000 00000000 DECR 0
GPR00 c000000000072304 c0000000fa383100 c000000001190300 0000000000000000
GPR04 0000000000000001 0000000000000000 c0000000fa383208 0000000000000080
GPR08 c000210000000000 000000008000007f 0000000001000000 6874697720303030
<snip>

The problem is the same for the memory device removal path
(e.g. during filesystem unmount).

Since powerpc expects the memory to be accessible during device
addition/removal, this patch makes the DAX window readable at creation
and after virtio-fs unmap.

1 - https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fb5924fd

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 hw/virtio/vhost-user-fs.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 455e97beea..92958797d0 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -24,6 +24,16 @@
 #include "exec/address-spaces.h"
 #include "trace.h"
 
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
 uint64_t vhost_user_fs_slave_map(struct vhost_dev *dev, VhostUserFSSlaveMsg *sm,
                                  int fd)
 {
@@ -133,8 +143,8 @@ uint64_t vhost_user_fs_slave_unmap(struct vhost_dev *dev, VhostUserFSSlaveMsg *s
             continue;
         }
 
-        ptr = mmap(cache_host + sm->c_offset[i], sm->len[i],
-                PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
+        ptr = mmap(cache_host + sm->c_offset[i], sm->len[i], DAX_WINDOW_PROT,
+                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
         if (ptr != (cache_host + sm->c_offset[i])) {
             res = -errno;
             fprintf(stderr, "%s: mmap failed (%s) [%d] %"
@@ -485,8 +495,9 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
 
     if (fs->conf.cache_size) {
         /* Anonymous, private memory is not counted as overcommit */
-        cache_ptr = mmap(NULL, fs->conf.cache_size, PROT_NONE,
+        cache_ptr = mmap(NULL, fs->conf.cache_size, DAX_WINDOW_PROT,
                          MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+
         if (cache_ptr == MAP_FAILED) {
             error_setg(errp, "Unable to mmap blank cache");
             return;
-- 
2.23.0


