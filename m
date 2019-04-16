From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed, 17 Apr 2019 02:03:14 +0800
Message-Id: <20190416180322.65113-2-bo.liu@linux.alibaba.com>
In-Reply-To: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/9] virtio-fs: fix multiple tag support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

While doing memremap from pci_dev's system bus address to kernel virtual
address, we assign a wrong value to the %end of pgmap.res, which ends up
with a wrong resource size in the process of memremap, and that further
prevent the second virtiofs pci device from being probed successfully.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/fuse/virtio_fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index d669512..68fd11b 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -589,7 +589,7 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
 	pgmap->res = (struct resource){
 		.name = "virtio-fs dax window",
 		.start = (phys_addr_t) cache_reg.addr,
-		.end = (phys_addr_t) cache_reg.addr + cache_reg.len,
+		.end = (phys_addr_t) cache_reg.addr + cache_reg.len - 1,
 	};
 
 	fs->window_kaddr = devm_memremap_pages(&vdev->dev, pgmap);
-- 
1.8.3.1

