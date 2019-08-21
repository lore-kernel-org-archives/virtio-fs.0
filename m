From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 21 Aug 2019 13:57:16 -0400
Message-Id: <20190821175720.25901-16-vgoyal@redhat.com>
In-Reply-To: <20190821175720.25901-1-vgoyal@redhat.com>
References: <20190821175720.25901-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 15/19] fuse: Maintain a list of busy elements
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: virtio-fs@redhat.com, vgoyal@redhat.com, miklos@szeredi.hu

This list will be used selecting fuse_dax_mapping to free when number of
free mappings drops below a threshold.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c   | 22 ++++++++++++++++++++++
 fs/fuse/fuse_i.h |  8 ++++++++
 fs/fuse/inode.c  |  4 ++++
 3 files changed, 34 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 7b70b5ea7f94..8c1777fb61f7 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -200,6 +200,23 @@ static struct fuse_dax_mapping *alloc_dax_mapping(struct fuse_conn *fc)
 	return dmap;
 }
 
+/* This assumes fc->lock is held */
+static void __dmap_remove_busy_list(struct fuse_conn *fc,
+				    struct fuse_dax_mapping *dmap)
+{
+	list_del_init(&dmap->busy_list);
+	WARN_ON(fc->nr_busy_ranges == 0);
+	fc->nr_busy_ranges--;
+}
+
+static void dmap_remove_busy_list(struct fuse_conn *fc,
+				  struct fuse_dax_mapping *dmap)
+{
+	spin_lock(&fc->lock);
+	__dmap_remove_busy_list(fc, dmap);
+	spin_unlock(&fc->lock);
+}
+
 /* This assumes fc->lock is held */
 static void __dmap_add_to_free_pool(struct fuse_conn *fc,
 				struct fuse_dax_mapping *dmap)
@@ -265,6 +282,10 @@ static int fuse_setup_one_mapping(struct inode *inode, loff_t offset,
 		/* Protected by fi->i_dmap_sem */
 		fuse_dax_interval_tree_insert(dmap, &fi->dmap_tree);
 		fi->nr_dmaps++;
+		spin_lock(&fc->lock);
+		list_add_tail(&dmap->busy_list, &fc->busy_ranges);
+		fc->nr_busy_ranges++;
+		spin_unlock(&fc->lock);
 	}
 	return 0;
 }
@@ -334,6 +355,7 @@ static void dmap_reinit_add_to_free_pool(struct fuse_conn *fc,
 	pr_debug("fuse: freeing memory range start=0x%llx end=0x%llx "
 		 "window_offset=0x%llx length=0x%llx\n", dmap->start,
 		 dmap->end, dmap->window_offset, dmap->length);
+	__dmap_remove_busy_list(fc, dmap);
 	dmap->start = dmap->end = 0;
 	__dmap_add_to_free_pool(fc, dmap);
 }
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 125bb7123651..070a5c2b6498 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -119,6 +119,10 @@ struct fuse_dax_mapping {
 	/** End Position in file */
 	__u64 end;
 	__u64 __subtree_last;
+
+	/* Will connect in fc->busy_ranges to keep track busy memory */
+	struct list_head busy_list;
+
 	/** Position in DAX window */
 	u64 window_offset;
 
@@ -887,6 +891,10 @@ struct fuse_conn {
 	/** DAX device, non-NULL if DAX is supported */
 	struct dax_device *dax_dev;
 
+	/* List of memory ranges which are busy */
+	unsigned long nr_busy_ranges;
+	struct list_head busy_ranges;
+
 	/*
 	 * DAX Window Free Ranges. TODO: This might not be best place to store
 	 * this free list
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 52135b4616d2..b80e76a307f3 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -614,6 +614,8 @@ static void fuse_free_dax_mem_ranges(struct list_head *mem_list)
 	/* Free All allocated elements */
 	list_for_each_entry_safe(range, temp, mem_list, list) {
 		list_del(&range->list);
+		if (!list_empty(&range->busy_list))
+			list_del(&range->busy_list);
 		kfree(range);
 	}
 }
@@ -658,6 +660,7 @@ static int fuse_dax_mem_range_init(struct fuse_conn *fc,
 		 */
 		range->window_offset = i * FUSE_DAX_MEM_RANGE_SZ;
 		range->length = FUSE_DAX_MEM_RANGE_SZ;
+		INIT_LIST_HEAD(&range->busy_list);
 		list_add_tail(&range->list, &mem_ranges);
 	}
 
@@ -708,6 +711,7 @@ void fuse_conn_init(struct fuse_conn *fc, struct user_namespace *user_ns,
 	fc->user_ns = get_user_ns(user_ns);
 	fc->max_pages = FUSE_DEFAULT_MAX_PAGES_PER_REQ;
 	INIT_LIST_HEAD(&fc->free_ranges);
+	INIT_LIST_HEAD(&fc->busy_ranges);
 }
 EXPORT_SYMBOL_GPL(fuse_conn_init);
 
-- 
2.20.1

