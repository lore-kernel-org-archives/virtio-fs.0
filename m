From: Peng Tao <tao.peng@linux.alibaba.com>
Date: Fri, 10 May 2019 18:29:57 +0800
Message-Id: <20190510102957.8705-3-tao.peng@linux.alibaba.com>
In-Reply-To: <20190510102957.8705-2-tao.peng@linux.alibaba.com>
References: <20190510102957.8705-1-tao.peng@linux.alibaba.com>
	<20190510102957.8705-2-tao.peng@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH 2/2] fuse: remove dmap when truncating inode
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
 fs/fuse/dir.c    |  5 ++++
 fs/fuse/file.c   | 69 +++++++++++++++++++++++++++++++++++++++---------
 fs/fuse/fuse_i.h |  2 ++
 3 files changed, 63 insertions(+), 13 deletions(-)

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
index 51faed351c7c..6d130f2f3a23 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -30,6 +30,8 @@ static long __fuse_file_fallocate(struct file *file, int mode,
 					loff_t offset, loff_t length);
 static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
 					struct inode *inode);
+static void fuse_dax_do_remove_mapping_locked(struct fuse_inode *fi,
+					struct fuse_dax_mapping *dmap);
 
 static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 			  int opcode, struct fuse_open_out *outargp)
@@ -3752,9 +3754,7 @@ int fuse_dax_reclaim_dmap_locked(struct fuse_conn *fc, struct inode *inode,
 		return ret;
 	}
 
-	/* Remove dax mapping from inode interval tree now */
-	fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
-	fi->nr_dmaps--;
+	fuse_dax_do_remove_mapping_locked(fi, dmap);
 	return 0;
 }
 
@@ -3831,6 +3831,58 @@ static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
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
+/* Remove dax mapping from inode interval tree */
+static void fuse_dax_do_remove_mapping_locked(struct fuse_inode *fi, struct fuse_dax_mapping *dmap)
+{
+	fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
+	fi->nr_dmaps--;
+}
+
+/*
+ * Free inode dmap entries whose range falls entirely inside [start, end].
+ * Called with inode->i_rwsem and fuse_inode->i_mmap_sem held.
+ *
+ * No need to send FUSE_REMOVEMAPPING to userspace because the userspace mappings
+ * will be overridden next time dmap is used -- same logic is applied in
+ * fuse_dax_reclaim_first_mapping().
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
+		fuse_dax_do_remove_mapping_locked(fi, dmap);
+		fuse_dax_do_free_mapping_locked(fc, dmap);
+	}
+	up_write(&fi->i_dmap_sem);
+}
+
 int fuse_dax_free_one_mapping_locked(struct fuse_conn *fc, struct inode *inode,
 				u64 dmap_start)
 {
@@ -3852,17 +3904,8 @@ int fuse_dax_free_one_mapping_locked(struct fuse_conn *fc, struct inode *inode,
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

