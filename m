From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Tue, 13 Aug 2019 02:32:05 +0800
Message-Id: <1565634725-89726-2-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1565634725-89726-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1565634725-89726-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH 2/2] virtio-fs: do not removemapping if dmap
	will be used immediately
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

According to how we implement REMOVEMAPPING in daemon, it's unnecessary to
involve a REMOVEMAPPING to reuse a dmap when doing inline reclaim because
dmaps got from inline reclaim get reused for another mapping without being
added back to 'free' dmap pool.

This skips REMOVEMAPPING for inline reclaim only and we don't do
REMOVEMAPPING unless someone has raced in to add a dmap to the range.

With the following two patches applied,
"virtio-fs: do not removemapping if dmap will be used immediately"
"virtio-fs: try hard to do inline reclaim",

fio fio-tmp.job
read: IOPS=8055, BW=31.5MiB/s (32.0MB/s)(3776MiB/120001msec)
clat (usec): min=6, max=1842, avg=113.75, stdev=83.78
clat percentiles (usec):
95.00th=[  202]
99.00th=[  221]

w/o
read: IOPS=4312, BW=16.8MiB/s (17.7MB/s)(2021MiB/120001msec)
clat (usec): min=10, max=3415, avg=220.98, stdev=102.85
clat percentiles (usec):
95.00th=[  359]
99.00th=[  392]

[1]:
virtiofsd -o cache="always"
qemu -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs-1,cache-size=4G

[2]:
cat fio-tmp.job

; fio-rand-read.job for fiotest

[global]
name=fio-rand-read
filename=fio_file
rw=randread
bs=4K
direct=1
numjobs=1
time_based=1
runtime=120
directory=/mnt/test/

[file1]
size=10G
ioengine=psync
iodepth=1

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/fuse/file.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 2ea670a..b5239b1 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1933,7 +1933,11 @@ static int iomap_begin_setup_new_mapping(struct inode *inode, loff_t pos,
 	if (ret < 0) {
 		printk("fuse_setup_one_mapping() failed. err=%d"
 			" pos=0x%llx, writable=%d\n", ret, pos, writable);
+
+		/* liubo: ignore failure if removemapping fails. */
+		dmap_removemapping_one(inode, dmap);
 		dmap_add_to_free_pool(fc, alloc_dmap);
+
 		up_write(&fi->i_dmap_sem);
 		return ret;
 	}
@@ -3996,7 +4000,8 @@ static int dmap_writeback_invalidate(struct inode *inode,
 }
 
 static int reclaim_one_dmap_locked(struct fuse_conn *fc, struct inode *inode,
-				   struct fuse_dax_mapping *dmap)
+				   struct fuse_dax_mapping *dmap,
+				   bool inline_reclaim)
 {
 	int ret;
 	struct fuse_inode *fi = get_fuse_inode(inode);
@@ -4021,6 +4026,13 @@ static int reclaim_one_dmap_locked(struct fuse_conn *fc, struct inode *inode,
 	fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
 	fi->nr_dmaps--;
 
+	/*
+	 * for inline reclaim, it's unnecessary to removing mapping since it'll
+	 * be used by another range immediately.
+	 */
+	if (inline_reclaim)
+		return 0;
+
 	ret = dmap_removemapping_one(inode, dmap);
 	if (ret) {
 		pr_warn("Failed to remove mapping. offset=0x%llx len=0x%llx\n",
@@ -4051,7 +4063,7 @@ static int reclaim_one_dmap_locked(struct fuse_conn *fc, struct inode *inode,
 	if (!dmap)
 		return NULL;
 
-	ret = reclaim_one_dmap_locked(fc, inode, dmap);
+	ret = reclaim_one_dmap_locked(fc, inode, dmap, true);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
@@ -4136,7 +4148,7 @@ int lookup_and_reclaim_dmap_locked(struct fuse_conn *fc, struct inode *inode,
 	if (refcount_read(&dmap->refcnt) > 1)
 		return 0;
 
-	ret = reclaim_one_dmap_locked(fc, inode, dmap);
+	ret = reclaim_one_dmap_locked(fc, inode, dmap, false);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.3.1

