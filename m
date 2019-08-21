From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed, 21 Aug 2019 14:10:38 +0800
Message-Id: <1566367838-47809-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH] virtiofs: fix return value of
	iomap_begin_upgrade_mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Set ret = 0 if everything runs fine.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/fuse/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index eb7543a..d3c5e45 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1985,6 +1985,7 @@ static int iomap_begin_upgrade_mapping(struct inode *inode, loff_t pos,
 
 out_fill_iomap:
 	fuse_fill_iomap(inode, pos, length, iomap, dmap, flags);
+	ret = 0;
 out_err:
 	up_write(&fi->i_dmap_sem);
 	return ret;
-- 
1.8.3.1

