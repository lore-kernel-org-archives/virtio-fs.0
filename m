From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 16 Jul 2019 17:00:47 -0400
Message-Id: <20190716210051.11724-3-vgoyal@redhat.com>
In-Reply-To: <20190716210051.11724-1-vgoyal@redhat.com>
References: <20190716210051.11724-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/6] fuse: Requeue work if number of free ranges
	is not above threshold
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

If number of free ranges is not above threshold, requeue work (from
worker context itself). This will make sure worker continues to run
till we hit threshold.

Otherwise, we could be below threshold and still worker exits until
and some memory allocation kicks the worker again.

As a side affect, it also solves one race where where with nr_dmaps=1,
it is possible that worker starts but exits as there are no busy ranges,
and soon after busy range count goes up (dmap has been taken off free
list already). In that case, worker never runs again, sleepers continue
to sleep and caller who added dmap to busy list has exited. Busy range
remains in busy list of the inode and application hangs.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 310fb22b31bd..6e351fed6d65 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -179,9 +179,30 @@ static void fuse_link_write_file(struct file *file)
 	spin_unlock(&fi->lock);
 }
 
-static struct fuse_dax_mapping *alloc_dax_mapping(struct fuse_conn *fc)
+static void
+__kick_dmap_free_worker(struct fuse_conn *fc, unsigned long delay_ms)
 {
 	unsigned long free_threshold;
+
+	/* If number of free ranges are below threshold, start reclaim */
+	free_threshold = max((fc->nr_ranges * FUSE_DAX_RECLAIM_THRESHOLD)/100,
+				(unsigned long)1);
+	if (fc->nr_free_ranges < free_threshold) {
+		pr_debug("fuse: Kicking dax memory reclaim worker. nr_free_ranges=0x%ld nr_total_ranges=%ld\n", fc->nr_free_ranges, fc->nr_ranges);
+		queue_delayed_work(system_long_wq, &fc->dax_free_work,
+				   msecs_to_jiffies(delay_ms));
+	}
+}
+
+static void kick_dmap_free_worker(struct fuse_conn *fc, unsigned long delay_ms)
+{
+	spin_lock(&fc->lock);
+	__kick_dmap_free_worker(fc, delay_ms);
+	spin_unlock(&fc->lock);
+}
+
+static struct fuse_dax_mapping *alloc_dax_mapping(struct fuse_conn *fc)
+{
 	struct fuse_dax_mapping *dmap = NULL;
 
 	spin_lock(&fc->lock);
@@ -202,13 +223,7 @@ static struct fuse_dax_mapping *alloc_dax_mapping(struct fuse_conn *fc)
 	spin_unlock(&fc->lock);
 
 out_kick:
-	/* If number of free ranges are below threshold, start reclaim */
-	free_threshold = max((fc->nr_ranges * FUSE_DAX_RECLAIM_THRESHOLD)/100,
-				(unsigned long)1);
-	if (fc->nr_free_ranges < free_threshold) {
-		pr_debug("fuse: Kicking dax memory reclaim worker. nr_free_ranges=0x%ld nr_total_ranges=%ld\n", fc->nr_free_ranges, fc->nr_ranges);
-		queue_delayed_work(system_long_wq, &fc->dax_free_work, 0);
-	}
+	kick_dmap_free_worker(fc, 0);
 	return dmap;
 }
 
@@ -4170,6 +4185,11 @@ static int try_to_free_dmap_chunks(struct fuse_conn *fc,
 		dmap = NULL;
 		spin_lock(&fc->lock);
 
+		if (!fc->nr_busy_ranges) {
+			spin_unlock(&fc->lock);
+			return 0;
+		}
+
 		list_for_each_entry_safe(pos, temp, &fc->busy_ranges,
 						busy_list) {
 			inode = igrab(pos->inode);
@@ -4228,4 +4248,7 @@ void fuse_dax_free_mem_worker(struct work_struct *work)
 		pr_debug("fuse: try_to_free_dmap_chunks() failed with err=%d\n",
 			 ret);
 	}
+
+	/* If number of free ranges are still below threhold, requeue */
+	kick_dmap_free_worker(fc, 1);
 }
-- 
2.20.1

