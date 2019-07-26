From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 26 Jul 2019 11:49:47 -0400
Message-Id: <20190726154948.28540-3-vgoyal@redhat.com>
In-Reply-To: <20190726154948.28540-1-vgoyal@redhat.com>
References: <20190726154948.28540-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/3] fuse: Move new mapping setup code in a
	function
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Move new mapping setup code in a separate function. More code will come
in fuse_iomap_begin() and its becoming too big.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c | 116 +++++++++++++++++++++++++++----------------------
 1 file changed, 64 insertions(+), 52 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 93f8e62e2b5b..a2c19e4a28b5 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1882,6 +1882,67 @@ static void fuse_fill_iomap(struct inode *inode, loff_t pos, loff_t length,
 	}
 }
 
+static int iomap_begin_setup_new_mapping(struct inode *inode, loff_t pos,
+					 loff_t length, unsigned flags,
+					 struct iomap *iomap)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_dax_mapping *dmap, *alloc_dmap = NULL;
+	int ret;
+
+	/* Can't do reclaim in fault path yet due to lock ordering.
+	 * Read path takes shared inode lock and that's not sufficient
+	 * for inline range reclaim. Caller needs to drop lock, wait
+	 * and retry.
+	 */
+	if (flags & IOMAP_FAULT || !(flags & IOMAP_WRITE)) {
+		alloc_dmap = alloc_dax_mapping(fc);
+		if (!alloc_dmap)
+			return -ENOSPC;
+	} else {
+		alloc_dmap = alloc_dax_mapping_reclaim(fc, inode);
+		if (IS_ERR(alloc_dmap))
+			return PTR_ERR(alloc_dmap);
+	}
+
+	/* If we are here, we should have memory allocated */
+	if (WARN_ON(!alloc_dmap))
+		return -EBUSY;
+
+	/*
+	 * Drop read lock and take write lock so that only one
+	 * caller can try to setup mapping and other waits
+	 */
+	down_write(&fi->i_dmap_sem);
+	/*
+	 * We dropped lock. Check again if somebody else setup
+	 * mapping already.
+	 */
+	dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, pos,
+						pos);
+	if (dmap) {
+		fuse_fill_iomap(inode, pos, length, iomap, dmap, flags);
+		dmap_add_to_free_pool(fc, alloc_dmap);
+		up_write(&fi->i_dmap_sem);
+		return 0;
+	}
+
+	/* Setup one mapping */
+	ret = fuse_setup_one_mapping(inode,
+		ALIGN_DOWN(pos, FUSE_DAX_MEM_RANGE_SZ), alloc_dmap);
+	if (ret < 0) {
+		printk("fuse_setup_one_mapping() failed. err=%d"
+			" pos=0x%llx\n", ret, pos);
+		dmap_add_to_free_pool(fc, alloc_dmap);
+		up_write(&fi->i_dmap_sem);
+		return ret;
+	}
+	fuse_fill_iomap(inode, pos, length, iomap, alloc_dmap, flags);
+	up_write(&fi->i_dmap_sem);
+	return 0;
+}
+
 /* This is just for DAX and the mapping is ephemeral, do not use it for other
  * purposes since there is no block device with a permanent mapping.
  */
@@ -1890,8 +1951,7 @@ static int fuse_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_dax_mapping *dmap, *alloc_dmap = NULL;
-	int ret;
+	struct fuse_dax_mapping *dmap;
 
 	/* We don't support FIEMAP */
 	BUG_ON(flags & IOMAP_REPORT);
@@ -1932,56 +1992,8 @@ static int fuse_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 		if (pos >= i_size_read(inode))
 			goto iomap_hole;
 
-		/* Can't do reclaim in fault path yet due to lock ordering.
-		 * Read path takes shared inode lock and that's not sufficient
-		 * for inline range reclaim. Caller needs to drop lock, wait
-		 * and retry.
-		 */
-		if (flags & IOMAP_FAULT || !(flags & IOMAP_WRITE)) {
-			alloc_dmap = alloc_dax_mapping(fc);
-			if (!alloc_dmap)
-				return -ENOSPC;
-		} else {
-			alloc_dmap = alloc_dax_mapping_reclaim(fc, inode);
-			if (IS_ERR(alloc_dmap))
-				return PTR_ERR(alloc_dmap);
-		}
-
-		/* If we are here, we should have memory allocated */
-		if (WARN_ON(!alloc_dmap))
-			return -EBUSY;
-
-		/*
-		 * Drop read lock and take write lock so that only one
-		 * caller can try to setup mapping and other waits
-		 */
-		down_write(&fi->i_dmap_sem);
-		/*
-		 * We dropped lock. Check again if somebody else setup
-		 * mapping already.
-		 */
-		dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, pos,
-							pos);
-		if (dmap) {
-			fuse_fill_iomap(inode, pos, length, iomap, dmap, flags);
-			dmap_add_to_free_pool(fc, alloc_dmap);
-			up_write(&fi->i_dmap_sem);
-			return 0;
-		}
-
-		/* Setup one mapping */
-		ret = fuse_setup_one_mapping(inode,
-			ALIGN_DOWN(pos, FUSE_DAX_MEM_RANGE_SZ), alloc_dmap);
-		if (ret < 0) {
-			printk("fuse_setup_one_mapping() failed. err=%d"
-				" pos=0x%llx\n", ret, pos);
-			dmap_add_to_free_pool(fc, alloc_dmap);
-			up_write(&fi->i_dmap_sem);
-			return ret;
-		}
-		fuse_fill_iomap(inode, pos, length, iomap, alloc_dmap, flags);
-		up_write(&fi->i_dmap_sem);
-		return 0;
+		return iomap_begin_setup_new_mapping(inode, pos, length, flags,
+						    iomap);
 	}
 
 	/*
-- 
2.17.2

