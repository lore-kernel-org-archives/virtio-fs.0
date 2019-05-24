From: Peng Tao <tao.peng@linux.alibaba.com>
Date: Fri, 24 May 2019 13:33:23 +0800
Message-Id: <20190524053324.115026-2-tao.peng@linux.alibaba.com>
In-Reply-To: <20190524053324.115026-1-tao.peng@linux.alibaba.com>
References: <20190524053324.115026-1-tao.peng@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH-v3 1/2] fuse: remove dmap when truncating inode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Peng Tao <tao.peng@linux.alibaba.com>

The obseleted dmap entries can be put back to global free list
immediately and we don't have to rely on reclaim code to free them.

Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
---
 fs/fuse/dir.c    |  5 +++++
 fs/fuse/file.c   | 55 ++++++++++++++++++++++++++++++++++++++----------
 fs/fuse/fuse_i.h |  2 ++
 3 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 3f923fe7841a..233c3ed391f1 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1751,6 +1751,11 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 		down_write(&fi->i_mmap_sem);
 		truncate_pagecache(inode, outarg.attr.size);
 		invalidate_inode_pages2(inode->i_mapping);
+		// Free dmap beyond i_size
+		if (IS_DAX(inode) && oldsize > outarg.attr.size)
+			fuse_dax_free_mappings_range(fc, inode,
+						     outarg.attr.size, -1);
+
 		up_write(&fi->i_mmap_sem);
 	}
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 51faed351c7c..6c970d19e926 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3752,7 +3752,6 @@ int fuse_dax_reclaim_dmap_locked(struct fuse_conn *fc, struct inode *inode,
 		return ret;
 	}
 
-	/* Remove dax mapping from inode interval tree now */
 	fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
 	fi->nr_dmaps--;
 	return 0;
@@ -3831,6 +3830,49 @@ static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
 	}
 }
 
+/* Cleanup dmap entry and add back to free list */
+static void fuse_dax_do_free_mapping_locked(struct fuse_conn *fc, struct fuse_dax_mapping *dmap)
+{
+	pr_debug("fuse: freed memory range start=0x%llx end=0x%llx "
+		"window_offset=0x%llx length=0x%llx\n", dmap->start,
+		dmap->end, dmap->window_offset, dmap->length);
+	spin_lock(&fc->lock);
+	__dmap_remove_busy_list(fc, dmap);
+	dmap->inode = NULL;
+	dmap->start = dmap->end = 0;
+	__free_dax_mapping(fc, dmap);
+	spin_unlock(&fc->lock);
+}
+
+/*
+ * Free inode dmap entries whose range falls entirely inside [start, end].
+ * Called with inode->i_rwsem and fuse_inode->i_mmap_sem held.
+ */
+void fuse_dax_free_mappings_range(struct fuse_conn *fc, struct inode *inode, loff_t start, loff_t end)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_dax_mapping *dmap;
+
+	WARN_ON(!inode_is_locked(inode));
+	WARN_ON(!rwsem_is_locked(&fi->i_mmap_sem));
+
+	/* interval tree search matches intersecting entries.
+	 * Adjust the range to avoid dropping partial valid entries. */
+	start = ALIGN(start, FUSE_DAX_MEM_RANGE_SZ);
+	end = ALIGN_DOWN(end, FUSE_DAX_MEM_RANGE_SZ);
+
+	pr_debug("fuse: fuse_dax_free_mappings_range start=0x%llx, end=0x%llx\n", start, end);
+	/* Lock ordering follows fuse_dax_free_one_mapping() */
+	down_write(&fi->i_dmap_sem);
+	while ((dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, start, end))) {
+		fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
+		fi->nr_dmaps--;
+		fuse_dax_do_free_mapping_locked(fc, dmap);
+		fuse_removemapping_one(inode, dmap);
+	}
+	up_write(&fi->i_dmap_sem);
+}
+
 int fuse_dax_free_one_mapping_locked(struct fuse_conn *fc, struct inode *inode,
 				u64 dmap_start)
 {
@@ -3852,17 +3894,8 @@ int fuse_dax_free_one_mapping_locked(struct fuse_conn *fc, struct inode *inode,
 	if (ret < 0)
 		return ret;
 
-	/* Cleanup dmap entry and add back to free list */
-	spin_lock(&fc->lock);
-	__dmap_remove_busy_list(fc, dmap);
-	dmap->inode = NULL;
-	dmap->start = dmap->end = 0;
-	__free_dax_mapping(fc, dmap);
-	spin_unlock(&fc->lock);
+	fuse_dax_do_free_mapping_locked(fc, dmap);
 
-	pr_debug("fuse: freed memory range window_offset=0x%llx,"
-				" length=0x%llx\n", dmap->window_offset,
-				dmap->length);
 	return ret;
 }
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 1149281ab1e8..e273f1209f5b 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1189,5 +1189,7 @@ unsigned fuse_len_args(unsigned numargs, struct fuse_arg *args);
 u64 fuse_get_unique(struct fuse_iqueue *fiq);
 void fuse_dax_free_mem_worker(struct work_struct *work);
 void fuse_removemapping(struct inode *inode);
+void fuse_dax_free_mappings_range(struct fuse_conn *fc, struct inode *inode,
+			loff_t start, loff_t end);
 
 #endif /* _FS_FUSE_I_H */
-- 
2.17.1

