From: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Date: Tue, 18 Jun 2019 20:25:07 +0000
Message-ID: <a755e6bed4962076909d037399e82fb8207c5581.camel@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <19AB983235770C4EA3377B2A184CC9C9@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtio-fs: Allow shared memory region to be
	empty
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

>From 908b1c5660b919266379d68940815a5dea9ca6f4 Mon Sep 17 00:00:00 2001
From: Sebastien Boeuf <sebastien.boeuf@intel.com>
Date: Mon, 17 Jun 2019 11:11:10 -0700
Subject: [PATCH] virtio-fs: Allow shared memory region to be empty

In case the device declares an empty cache region to the driver, the
whole DAX setup should be simply skipped and the shared memory region
should never be used.

Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
---
 fs/fuse/virtio_fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 3f3c018571ee..88531324fe40 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -540,8 +540,8 @@ static int virtio_fs_setup_dax(struct virtio_device
*vdev, struct virtio_fs *fs)
 					   &cache_reg,
 					   (u8)VIRTIO_FS_SHMCAP_ID_CACH
E);
 	if (!have_cache) {
-		dev_err(&vdev->dev, "%s: No cache capability\n",
__func__);
-		return -ENXIO;
+		dev_notice(&vdev->dev, "%s: No cache capability\n",
__func__);
+		return 0;
 	} else {
 		dev_notice(&vdev->dev, "Cache len: 0x%llx @ 0x%llx\n",
 			   cache_reg.len, cache_reg.addr);
-- 
2.17.1

