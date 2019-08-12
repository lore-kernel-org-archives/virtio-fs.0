From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Tue, 13 Aug 2019 02:58:55 +0800
Message-Id: <1565636335-120345-2-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1565636335-120345-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1565636335-120345-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH 2/2] Virtio-fs: align down start offset when
	reclaim dmap range
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Given a share directory is mounted on host like,
---
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/loop1       1998672 1982288         0 100% /home/b.liu/1_source/2_github/virtio-fs-all/qemu/share_dir2
---

Here is the reproducer,
---

umount /mnt/test/
mount -t virtio_fs btest /mnt/test/ -otag=myfs-2,rootmode=040000,user_id=0,group_id=0,dax

rm -f /mnt/test/*
fallocate -l 1500M /mnt/test/dummy

truncate -s 10G /mnt/test/foobar
xfs_io -c "pwrite 0 2G" /mnt/test/foobar
truncate -s 4k /mnt/test/foobar

fallocate -l 2G /mnt/test/foo1

truncate -s 10G /mnt/test/foobar
xfs_io -c "pwrite 0 2M" /mnt/test/foobar
---

File 'foobar' is truncated down from 10G to 4k but the dmap [0, 2M] is
still in fi->dmap_tree.  Now that all space has been allocated for file
'dummy' and 'foo1', the very last write to file 'foobar' will hang since
the underlying page_mkwrite encounters -ENOSPC error.

This fixes the problem by aligning down the start offset in
inode_reclaim_dmap_range().

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/fuse/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4f2d908..0033ace 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -414,7 +414,7 @@ static void inode_reclaim_dmap_range(struct fuse_conn *fc, struct inode *inode,
 	 * Interval tree search matches intersecting entries. Adjust the range
 	 * to avoid dropping partial valid entries.
 	 */
-	start = ALIGN(start, FUSE_DAX_MEM_RANGE_SZ);
+	start = ALIGN_DOWN(start, FUSE_DAX_MEM_RANGE_SZ);
 	end = ALIGN_DOWN(end, FUSE_DAX_MEM_RANGE_SZ);
 
 	down_write(&fi->i_dmap_sem);
-- 
1.8.3.1

