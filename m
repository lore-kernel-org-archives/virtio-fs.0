From: Peng Tao <tao.peng@linux.alibaba.com>
Date: Wed, 29 May 2019 12:30:42 +0800
Message-Id: <20190529043042.36167-1-tao.peng@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH] virtiofs: FUSE_REMOVEMAPPING remove multiple
	entries in one call
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Peng Tao <tao.peng@linux.alibaba.com>, Vivek Goyal <vgoyal@redhat.com>

Enhance FUSE_REMOVEMAPPING wire protocol to remove multiple mappings
in one call. So that fuse_removemapping() does not need to send
one fuse request for each dmap entry.

Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
---
This works with corresponding virtiofsd patch
"[PATCH-v2] virtiofsd: make FUSE_REMOVEMAPPING support multiple entries".

 fs/fuse/file.c            | 195 +++++++++++++++++++++++++++-----------
 include/uapi/linux/fuse.h |   9 +-
 2 files changed, 146 insertions(+), 58 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index d0979dc32f08..a6a34249c598 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -27,6 +27,9 @@ INTERVAL_TREE_DEFINE(struct fuse_dax_mapping, rb, __u64, __subtree_last,
 
 static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
 				struct inode *inode);
+static void __fuse_dax_free_mappings_range(struct fuse_conn *fc,
+				struct inode *inode, loff_t start, loff_t end);
+
 static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 			  int opcode, struct fuse_open_out *outargp)
 {
@@ -319,75 +322,90 @@ static int fuse_setup_one_mapping(struct inode *inode,
 	return 0;
 }
 
-static int fuse_removemapping_one(struct inode *inode,
-					struct fuse_dax_mapping *dmap)
+static int fuse_send_removemapping_request(struct inode *inode,
+		struct fuse_removemapping_in_header *header,
+		struct fuse_removemapping_in *inargp)
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_removemapping_in inarg;
 	FUSE_ARGS(args);
 
-	memset(&inarg, 0, sizeof(inarg));
-	inarg.moffset = dmap->window_offset;
-	inarg.len = dmap->length;
 	args.in.h.opcode = FUSE_REMOVEMAPPING;
 	args.in.h.nodeid = fi->nodeid;
-	args.in.numargs = 1;
-	args.in.args[0].size = sizeof(inarg);
-	args.in.args[0].value = &inarg;
+	args.in.numargs = 2;
+	args.in.args[0].size = sizeof(*header);
+	args.in.args[0].value = header;
+	args.in.args[1].size = header->count * sizeof(*inargp);
+	args.in.args[1].value = inargp;
 	return fuse_simple_request(fc, &args);
 }
 
-/*
- * It is called from evict_inode() and by that time inode is going away. So
- * this function does not take any locks like fi->i_dmap_sem for traversing
- * that fuse inode interval tree. If that lock is taken then lock validator
- * complains of deadlock situation w.r.t fs_reclaim lock.
- */
-void fuse_removemapping(struct inode *inode)
+static int fuse_do_removemappings(struct inode *inode, unsigned num,
+				  struct list_head *to_remove)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_inode *fi = get_fuse_inode(inode);
-	ssize_t err;
+	struct fuse_removemapping_in *inargp, *ptr;
+	struct fuse_removemapping_in_header header;
 	struct fuse_dax_mapping *dmap;
+	int ret, i = 0;
 
-	/* Clear the mappings list */
-	while (true) {
-		WARN_ON(fi->nr_dmaps < 0);
+	if (num <= FUSE_REMOVEMAPPING_MAX_ENTRY) {
+		inargp = kmalloc_array(num, sizeof(*inargp), GFP_NOIO);
+	} else {
+		inargp = kmalloc_array(FUSE_REMOVEMAPPING_MAX_ENTRY,
+					sizeof(*inargp), GFP_NOIO);
+	}
+	if (inargp == NULL)
+		return -ENOMEM;
 
-		dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, 0,
-								-1);
-		if (dmap) {
-			fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
-			fi->nr_dmaps--;
-			dmap_remove_busy_list(fc, dmap);
+	ptr = inargp;
+	list_for_each_entry(dmap, to_remove, list) {
+		ptr->moffset = dmap->window_offset;
+		ptr->len = dmap->length;
+		ptr++;
+		i++;
+		num--;
+		if (i >= FUSE_REMOVEMAPPING_MAX_ENTRY || num == 0) {
+			memset(&header, 0, sizeof(header));
+			header.count = i;
+			ret = fuse_send_removemapping_request(inode, &header, inargp);
+			if (ret)
+				goto out;
+			ptr = inargp;
+			i = 0;
 		}
+	}
 
-		if (!dmap)
-			break;
+out:
+	kfree(inargp);
+	return ret;
+}
 
-		/*
-		 * During umount/shutdown, fuse connection is dropped first
-		 * and later evict_inode() is called later. That means any
-		 * removemapping messages are going to fail. Send messages
-		 * only if connection is up. Otherwise fuse daemon is
-		 * responsible for cleaning up any leftover references and
-		 * mappings.
-		 */
-		if (fc->connected) {
-			err = fuse_removemapping_one(inode, dmap);
-			if (err) {
-				pr_warn("Failed to removemapping. offset=0x%llx"
-					" len=0x%llx\n", dmap->window_offset,
-					dmap->length);
-			}
-		}
+static int fuse_removemapping_one(struct inode *inode,
+					struct fuse_dax_mapping *dmap)
+{
+	struct fuse_removemapping_in inarg;
+	struct fuse_removemapping_in_header header;
 
-		dmap->inode = NULL;
+	memset(&header, 0, sizeof(header));
+	/* TODO: fill in header.fh when available */
+	header.count = 1;
+	memset(&inarg, 0, sizeof(inarg));
+	inarg.moffset = dmap->window_offset;
+	inarg.len = dmap->length;
 
-		/* Add it back to free ranges list */
-		free_dax_mapping(fc, dmap);
-	}
+	return fuse_send_removemapping_request(inode, &header, &inarg);
+}
+
+/*
+ * It is called from evict_inode() and by that time inode is going away. So
+ * this function does not take any locks like fi->i_dmap_sem for traversing
+ * that fuse inode interval tree. If that lock is taken then lock validator
+ * complains of deadlock situation w.r.t fs_reclaim lock.
+ */
+void fuse_removemapping(struct inode *inode)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	__fuse_dax_free_mappings_range(fc, inode, 0, -1);
 }
 
 void fuse_finish_open(struct inode *inode, struct file *file)
@@ -3980,6 +3998,75 @@ static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
 	}
 }
 
+/* Cleanup dmap entry and add back to free list */
+static void fuse_dax_do_free_mapping_locked(struct fuse_conn *fc, struct fuse_dax_mapping *dmap)
+{
+	pr_debug("fuse: freed memory range start=0x%llx end=0x%llx "
+		"window_offset=0x%llx length=0x%llx\n", dmap->start,
+		dmap->end, dmap->window_offset, dmap->length);
+	__dmap_remove_busy_list(fc, dmap);
+	dmap->inode = NULL;
+	dmap->start = dmap->end = 0;
+	__free_dax_mapping(fc, dmap);
+}
+
+/*
+ * Free inode dmap entries whose range falls entirely inside [start, end].
+ * Does not take any locks. Caller must take care of any lock requirements.
+ * Lock ordering follows fuse_dax_free_one_mapping().
+ * inode->i_rwsem, fuse_inode->i_mmap_sem and fuse_inode->i_dmap_sem must be
+ * held unless it is called from evict_inode() where no one else is accessing
+ * the inode.
+ */
+static void __fuse_dax_free_mappings_range(struct fuse_conn *fc,
+				struct inode *inode, loff_t start, loff_t end)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_dax_mapping *dmap, *n;
+	int err, num = 0;
+	LIST_HEAD(to_remove);
+
+	pr_debug("fuse: __fuse_dax_free_mappings_range "
+		 "start=0x%llx, end=0x%llx\n", start, end);
+	/* interval tree search matches intersecting entries.
+	 * Adjust the range to avoid dropping partial valid entries. */
+	start = ALIGN(start, FUSE_DAX_MEM_RANGE_SZ);
+	end = ALIGN_DOWN(end, FUSE_DAX_MEM_RANGE_SZ);
+
+	while ((dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, start, end))) {
+		fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
+		num++;
+		list_add(&dmap->list, &to_remove);
+	}
+
+	/* Nothing to remove */
+	if (list_empty(&to_remove))
+		return;
+
+	WARN_ON(fi->nr_dmaps < num);
+	fi->nr_dmaps -= num;
+	/*
+	 * During umount/shutdown, fuse connection is dropped first
+	 * and later evict_inode() is called later. That means any
+	 * removemapping messages are going to fail. Send messages
+	 * only if connection is up. Otherwise fuse daemon is
+	 * responsible for cleaning up any leftover references and
+	 * mappings.
+	 */
+	if (fc->connected) {
+		err = fuse_do_removemappings(inode, num, &to_remove);
+		if (err) {
+			pr_warn("Failed to removemappings. start=0x%llx"
+				" end=0x%llx\n", start, end);
+		}
+	}
+	spin_lock(&fc->lock);
+	list_for_each_entry_safe(dmap, n, &to_remove, list) {
+		fuse_dax_do_free_mapping_locked(fc, dmap);
+	}
+	spin_unlock(&fc->lock);
+}
+
 int fuse_dax_free_one_mapping_locked(struct fuse_conn *fc, struct inode *inode,
 				u64 dmap_start)
 {
@@ -4003,15 +4090,9 @@ int fuse_dax_free_one_mapping_locked(struct fuse_conn *fc, struct inode *inode,
 
 	/* Cleanup dmap entry and add back to free list */
 	spin_lock(&fc->lock);
-	__dmap_remove_busy_list(fc, dmap);
-	dmap->inode = NULL;
-	dmap->start = dmap->end = 0;
-	__free_dax_mapping(fc, dmap);
+	fuse_dax_do_free_mapping_locked(fc, dmap);
 	spin_unlock(&fc->lock);
 
-	pr_debug("fuse: freed memory range window_offset=0x%llx,"
-				" length=0x%llx\n", dmap->window_offset,
-				dmap->length);
 	return ret;
 }
 
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 5042e227e8a8..0dccfff50f91 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -847,13 +847,20 @@ struct fuse_setupmapping_out {
         uint64_t	len[FUSE_SETUPMAPPING_ENTRIES];
 };
 
-struct fuse_removemapping_in {
+struct fuse_removemapping_in_header {
         /* An already open handle */
         uint64_t	fh;
+	/* number of fuse_removemapping_in follows */
+	uint32_t	count;
+};
+
+struct fuse_removemapping_in {
 	/* Offset into the dax window start the unmapping */
 	uint64_t        moffset;
         /* Length of mapping required */
         uint64_t	len;
 };
+#define FUSE_REMOVEMAPPING_MAX_ENTRY	\
+		(PAGE_SIZE / sizeof(struct fuse_removemapping_in))
 
 #endif /* _LINUX_FUSE_H */
-- 
2.17.1

