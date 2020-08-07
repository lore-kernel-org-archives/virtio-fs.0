From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri,  7 Aug 2020 15:55:07 -0400
Message-Id: <20200807195526.426056-2-vgoyal@redhat.com>
In-Reply-To: <20200807195526.426056-1-vgoyal@redhat.com>
References: <20200807195526.426056-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 01/20] dax: Modify bdev_dax_pgoff() to handle
	NULL bdev
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com
Cc: miklos@szeredi.hu, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, vgoyal@redhat.com

virtiofs does not have a block device but it has dax device.
Modify bdev_dax_pgoff() to be able to handle that.

If there is no bdev, that means dax offset is 0. (It can't be a partition
block device starting at an offset in dax device).

This is little hackish. There have been discussions about getting rid
of dax not supporting partitions.

https://lore.kernel.org/linux-fsdevel/20200107125159.GA15745@infradead.org/

IMHO, this path can easily break exisitng users. For example
ioctl(BLKPG_ADD_PARTITION) will start breaking on block devices
supporting DAX. Also, I personally find it very useful to be able to
partition dax devices and still be able to use DAX.

Alternatively, I tried to store offset into dax device information in iomap
interface, but that got NACKed.

https://lore.kernel.org/linux-fsdevel/20200217133117.GB20444@infradead.org/

I can't think of a good path to solve this issue properly. So to make
progress, it seems this patch is least bad option for now and I hope
we can take it.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
---
 drivers/dax/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 8e32345be0f7..c4bec437e88b 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -46,7 +46,8 @@ EXPORT_SYMBOL_GPL(dax_read_unlock);
 int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
 		pgoff_t *pgoff)
 {
-	phys_addr_t phys_off = (get_start_sect(bdev) + sector) * 512;
+	sector_t start_sect = bdev ? get_start_sect(bdev) : 0;
+	phys_addr_t phys_off = (start_sect + sector) * 512;
 
 	if (pgoff)
 		*pgoff = PHYS_PFN(phys_off);
-- 
2.25.4

