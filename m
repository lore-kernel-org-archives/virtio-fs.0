From: piaojun <piaojun@huawei.com>
Message-ID: <5D53919A.4@huawei.com>
Date: Wed, 14 Aug 2019 12:44:10 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] [PATCH] virtio: clean up unused 'char *bar_name'
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Clean up 'char *bar_name' to avoid compile warning.

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 drivers/virtio/virtio_pci_modern.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 1cdedd9..52f1794 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -519,7 +519,6 @@ static bool vp_get_shm_region(struct virtio_device *vdev,
 	u64 offset, len;
 	phys_addr_t phys_addr;
 	size_t bar_len;
-	char *bar_name;
 	int ret;

 	if (!virtio_pci_find_shm_cap(pci_dev, id, &bar, &offset, &len)) {
-- 

