From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 16 Jul 2019 17:00:49 -0400
Message-Id: <20190716210051.11724-5-vgoyal@redhat.com>
In-Reply-To: <20190716210051.11724-1-vgoyal@redhat.com>
References: <20190716210051.11724-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/6] fuse: Get rid of inode lock in range
	reclaim path
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

With free fuse dax mapping reducing, read performance is impacted
significantly because reads need to wait for a free fuse dax mapping.

Although reads will trigger reclaim work to try to reclaim fuse dax
mapping, reclaim code can barely make any progress if most of fuse dax
mappings are used by the file we're reading since inode lock is required
by reclaim code.

However, we don't have to take inode lock for reclaiming if dax mapping
has its own reference count, reference counting is to tell reclaim code to
skip those in use dax mappings, such that we can avoid the risk of
accidentally reclaiming a dax mapping that other readers are using.

On the other hand, holding ->i_dmap_sem during reclaim can be used to
prevent the follwing reads to get a dax mapping under reclaim.

Another reason is that reads/writes only use fuse dax mapping within
dax_iomap_rw(), so we can do such a trick, while mmap/faulting is a
different story and we have to take ->i_mmap_sem prior to reclaiming a dax
mapping in order to avoid the race.

This adds reference count for fuse dax mapping and removes the acquisition
of inode lock during reclaim.


RESULTS:

virtiofsd -cache_size=2G

vanilla kernel: IOPS=378
patched kernel: IOPS=4508


*********************************
$ cat fio-rand-read.job
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
fsync=1
group_reporting=1

[file1]
size=5G
# use sync/libaio
ioengine=sync
iodepth=1


Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c   | 52 +++++++++++++++++++++++++++++++++++-------------
 fs/fuse/fuse_i.h |  3 +++
 fs/fuse/inode.c  |  1 +
 3 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index fc40e0f44578..bf9903a858db 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1885,6 +1885,18 @@ static void fuse_fill_iomap(struct inode *inode, loff_t pos, loff_t length,
 		if (flags & IOMAP_FAULT)
 			iomap->length = ALIGN(len, PAGE_SIZE);
 		iomap->type = IOMAP_MAPPED;
+
+		/*
+		 * increace refcnt so that reclaim code knows this dmap is in
+		 * use. This assumes i_dmap_sem mutex is held either
+		 * shared/exclusive.
+		 */
+		refcount_inc(&dmap->refcnt);
+
+		/* iomap->private should be NULL */
+		WARN_ON_ONCE(iomap->private);
+		iomap->private = dmap;
+
 		pr_debug("%s: returns iomap: addr 0x%llx offset 0x%llx"
 				" length 0x%llx\n", __func__, iomap->addr,
 				iomap->offset, iomap->length);
@@ -2014,6 +2026,16 @@ static int fuse_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 			  ssize_t written, unsigned flags,
 			  struct iomap *iomap)
 {
+	struct fuse_dax_mapping *dmap = iomap->private;
+
+	if (dmap) {
+		if (refcount_dec_and_test(&dmap->refcnt)) {
+			/* refcount should not hit 0. This object only goes
+			 * away when fuse connection goes away */
+			WARN_ON_ONCE(1);
+		}
+	}
+
 	/* DAX writes beyond end-of-file aren't handled using iomap, so the
 	 * file size is unchanged and there is nothing to do here.
 	 */
@@ -4009,6 +4031,10 @@ static int reclaim_one_dmap_locked(struct fuse_conn *fc, struct inode *inode,
 	int ret;
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
+	/*
+	 * igrab() was done to make sure inode won't go under us, and this
+	 * further avoids the race with evict().
+	 */
 	ret = dmap_writeback_invalidate(inode, dmap);
 
 	/* TODO: What to do if above fails? For now,
@@ -4113,16 +4139,18 @@ static int lookup_and_reclaim_dmap_locked(struct fuse_conn *fc,
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_dax_mapping *dmap;
 
-	WARN_ON(!inode_is_locked(inode));
-
 	/* Find fuse dax mapping at file offset inode. */
 	dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, dmap_start,
-							dmap_start);
+						 dmap_start);
 
 	/* Range already got cleaned up by somebody else */
 	if (!dmap)
 		return 0;
 
+	/* still in use. */
+	if (refcount_read(&dmap->refcnt) > 1)
+		return 0;
+
 	ret = reclaim_one_dmap_locked(fc, inode, dmap);
 	if (ret < 0)
 		return ret;
@@ -4137,10 +4165,9 @@ static int lookup_and_reclaim_dmap_locked(struct fuse_conn *fc,
 /*
  * Free a range of memory.
  * Locking.
- * 1. Take inode->i_rwsem to prever further read/write.
- * 2. Take fuse_inode->i_mmap_sem to block dax faults.
- * 3. Take fuse_inode->i_dmap_sem to protect interval tree. It might not
- *    be strictly necessary as lock 1 and 2 seem sufficient.
+ * 1. Take fuse_inode->i_mmap_sem to block dax faults.
+ * 2. Take fuse_inode->i_dmap_sem to protect interval tree and also to make
+ *    sure read/write can not reuse a dmap which we might be freeing.
  */
 static int lookup_and_reclaim_dmap(struct fuse_conn *fc, struct inode *inode,
 			    u64 dmap_start)
@@ -4148,18 +4175,11 @@ static int lookup_and_reclaim_dmap(struct fuse_conn *fc, struct inode *inode,
 	int ret;
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
-	/*
-	 * If process is blocked waiting for memory while holding inode
-	 * lock, we will deadlock. So continue to free next range.
-	 */
-	if (!inode_trylock(inode))
-		return -EAGAIN;
 	down_write(&fi->i_mmap_sem);
 	down_write(&fi->i_dmap_sem);
 	ret = lookup_and_reclaim_dmap_locked(fc, inode, dmap_start);
 	up_write(&fi->i_dmap_sem);
 	up_write(&fi->i_mmap_sem);
-	inode_unlock(inode);
 	return ret;
 }
 
@@ -4186,6 +4206,10 @@ static int try_to_free_dmap_chunks(struct fuse_conn *fc,
 
 		list_for_each_entry_safe(pos, temp, &fc->busy_ranges,
 						busy_list) {
+			/* skip this range if it's in use. */
+			if (refcount_read(&pos->refcnt) > 1)
+				continue;
+
 			inode = igrab(pos->inode);
 			/*
 			 * This inode is going away. That will free
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index edcc4a3e119b..e1e58fbdb603 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -134,6 +134,9 @@ struct fuse_dax_mapping {
 
        /** Length of mapping, in bytes */
        loff_t length;
+
+	/* reference count when the mapping is used by dax iomap. */
+	refcount_t refcnt;
 };
 
 /** FUSE inode */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index ffa00caeea01..2d2748e47787 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -666,6 +666,7 @@ static int fuse_dax_mem_range_init(struct fuse_conn *fc,
 		range->window_offset = i * FUSE_DAX_MEM_RANGE_SZ;
 		range->length = FUSE_DAX_MEM_RANGE_SZ;
 		INIT_LIST_HEAD(&range->busy_list);
+		refcount_set(&range->refcnt, 1);
 		list_add_tail(&range->list, &mem_ranges);
 	}
 
-- 
2.20.1

