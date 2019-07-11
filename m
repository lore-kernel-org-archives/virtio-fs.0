From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Fri, 12 Jul 2019 06:35:42 +0800
Message-Id: <1562884542-72462-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] Virtiofs: fix null pointer deference in directIO
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Virtiofs has used memremap to create page structs for its managed memory
and set pagemap's type to MEMORY_DEVICE_FS_DAX.  Thus, the page from
virtiofs's managed memory is a ZONE_DEVICE page, if %devmap_managed_key
was enabled by pmem drivers, put_page() will run into
__put_devmap_managed_page().  However, as page_free ops is not defined, it
ends up with a NULL pointer dereference.

As virtiofs presents its managed memory range as a dax device, this patch
makes virtiofs mimic how nvdimm/pmem.c setups pagemap fsdax.

=================

[ 1223.732964] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[ 1223.733043] PGD 800000026bd91067 P4D 800000026bd91067 PUD 27631e067 PMD 0
[ 1223.733085] Oops: 0010 [#1] SMP PTI
[ 1223.733114] CPU: 1 PID: 16505 Comm: build Not tainted 4.19.48-dff9509 #1
[ 1223.733157] RIP: 0010:          (null)
[ 1223.733179] Code: Bad RIP value.
..
[ 1223.733671] Call Trace:
[ 1223.733704]  fuse_release_user_pages+0xad/0xb0
[ 1223.733751]  fuse_direct_io+0x3ec/0x6a0
[ 1223.733823]  fuse_dax_direct_write+0x3c/0x70
[ 1223.733863]  fuse_file_write_iter+0x2ea/0x4c0
[ 1223.733978]  __vfs_write+0xde/0x160
[ 1223.734009]  vfs_write+0xab/0x190
[ 1223.734061]  ksys_write+0x45/0xc0
[ 1223.734094]  do_syscall_64+0x6b/0x330
[ 1223.734214]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1223.734261] RIP: 0033:0x15536bcddfd0

The reproducer could be as simply as,

addr = mmap(..., fileA, ...);
fdB = open(fileB, O_DIRECT);
write(fdB, addr);

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/fuse/virtio_fs.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 05ea28c..9b3f2e9 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -538,6 +538,28 @@ static void virtio_fs_cleanup_dax(void *data)
 	put_dax(fs->dax_dev);
 }
 
+static void virtio_fs_release_pgmap_ops(void *_pgmap)
+{
+	dev_pagemap_put_ops();
+}
+
+static void virtio_fs_fsdax_pagefree(struct page *page, void *data)
+{
+	wake_up_var(&page->_refcount);
+}
+
+static int virtio_fs_setup_pagemap_fsdax(struct device *dev,
+					 struct dev_pagemap *pgmap)
+{
+	dev_pagemap_get_ops();
+	if (devm_add_action_or_reset(dev, virtio_fs_release_pgmap_ops, pgmap))
+		return -ENOMEM;
+	pgmap->type = MEMORY_DEVICE_FS_DAX;
+	pgmap->page_free = virtio_fs_fsdax_pagefree;
+
+	return 0;
+}
+
 static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
 {
 	struct virtio_shm_region cache_reg, journal_reg, vertab_reg;
@@ -600,7 +622,9 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
 	pgmap->altmap_valid = false;
 	pgmap->ref = &mi->ref;
 	pgmap->kill = virtio_fs_percpu_kill;
-	pgmap->type = MEMORY_DEVICE_FS_DAX;
+
+	if (virtio_fs_setup_pagemap_fsdax(&vdev->dev, pgmap))
+		return -ENOMEM;
 
 	/* Ideally we would directly use the PCI BAR resource but
 	 * devm_memremap_pages() wants its own copy in pgmap.  So
-- 
1.8.3.1

