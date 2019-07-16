From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 16 Jul 2019 17:00:51 -0400
Message-Id: <20190716210051.11724-7-vgoyal@redhat.com>
In-Reply-To: <20190716210051.11724-1-vgoyal@redhat.com>
References: <20190716210051.11724-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 6/6] fuse: Dax read can now do range reclaim
	inline
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Now we don't take inode lock in range reclaim path. That means read path
which is holding shared inode lock can do inline dax range reclaim. Get
rid of logic where we dropped inode lock and waited for a range to become
free before retrying.

In read path inode lock is held shared. So make sure that dmap reference
count is 1 before we try to do reclaim it inline.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c | 47 +++++++++++++----------------------------------
 1 file changed, 13 insertions(+), 34 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 42b250d23888..6613d66de724 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1959,12 +1959,8 @@ static int fuse_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 		if (pos >= i_size_read(inode))
 			goto iomap_hole;
 
-		/* Can't do reclaim in fault path yet due to lock ordering.
-		 * Read path takes shared inode lock and that's not sufficient
-		 * for inline range reclaim. Caller needs to drop lock, wait
-		 * and retry.
-		 */
-		if (flags & IOMAP_FAULT || !(flags & IOMAP_WRITE)) {
+		/* Can't do reclaim in fault path yet due to lock ordering. */
+		if (flags & IOMAP_FAULT) {
 			alloc_dmap = alloc_dax_mapping(fc);
 			if (!alloc_dmap)
 				return -ENOSPC;
@@ -2050,18 +2046,7 @@ static const struct iomap_ops fuse_iomap_ops = {
 static ssize_t fuse_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
-	struct fuse_conn *fc = get_fuse_conn(inode);
 	ssize_t ret;
-	bool retry = false;
-
-retry:
-	if (retry && !(fc->nr_free_ranges > 0)) {
-		ret = -EINTR;
-		if (wait_event_killable_exclusive(fc->dax_range_waitq,
-						  (fc->nr_free_ranges > 0))) {
-			goto out;
-		}
-	}
 
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		if (!inode_trylock_shared(inode))
@@ -2073,19 +2058,7 @@ static ssize_t fuse_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	ret = dax_iomap_rw(iocb, to, &fuse_iomap_ops);
 	inode_unlock_shared(inode);
 
-	/* If a dax range could not be allocated and it can't be reclaimed
-	 * inline, then drop inode lock and retry. Range reclaim logic
-	 * requires exclusive access to inode lock.
-	 *
-	 * TODO: What if -ENOSPC needs to be returned to user space. Fix it.
-	 */
-	if (ret == -ENOSPC) {
-		retry = true;
-		goto retry;
-	}
 	/* TODO file_accessed(iocb->f_filp) */
-
-out:
 	return ret;
 }
 
@@ -4056,16 +4029,24 @@ static int reclaim_one_dmap_locked(struct fuse_conn *fc, struct inode *inode,
 	return 0;
 }
 
+#define fuse_dax_interval_tree_foreach(dmap, root, start, last)           \
+	for (dmap = fuse_dax_interval_tree_iter_first(root, start, last); \
+	     dmap; dmap = fuse_dax_interval_tree_iter_next(dmap, start, last))
+
 /* First first mapping in the tree and free it. */
 static struct fuse_dax_mapping *
 inode_reclaim_first_dmap_locked(struct fuse_conn *fc, struct inode *inode)
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
-	struct fuse_dax_mapping *dmap;
+	struct fuse_dax_mapping *dmap = NULL;
 	int ret;
 
-	/* Find fuse dax mapping at file offset inode. */
-	dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, 0, -1);
+	fuse_dax_interval_tree_foreach(dmap, &fi->dmap_tree, 0, -1) {
+		if (refcount_read(&dmap->refcnt) > 1)
+			continue;
+		break;
+	}
+
 	if (!dmap)
 		return NULL;
 
@@ -4087,8 +4068,6 @@ inode_reclaim_first_dmap_locked(struct fuse_conn *fc, struct inode *inode)
 /*
  * First first mapping in the tree and free it and return it. Do not add
  * it back to free pool.
- *
- * This is called with inode lock held.
  */
 static struct fuse_dax_mapping *inode_reclaim_first_dmap(struct fuse_conn *fc,
 							 struct inode *inode)
-- 
2.20.1

