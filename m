From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 16 Jul 2019 17:00:48 -0400
Message-Id: <20190716210051.11724-4-vgoyal@redhat.com>
In-Reply-To: <20190716210051.11724-1-vgoyal@redhat.com>
References: <20190716210051.11724-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/6] fuse: Do cond_resched() if we can't get
	inode lock
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

cond_resched() might be better as opposed

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6e351fed6d65..fc40e0f44578 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -4167,7 +4167,7 @@ static int try_to_free_dmap_chunks(struct fuse_conn *fc,
 				   unsigned long nr_to_free)
 {
 	struct fuse_dax_mapping *dmap, *pos, *temp;
-	int ret, nr_freed = 0, nr_eagain = 0;
+	int ret, nr_freed = 0;
 	u64 dmap_start = 0, window_offset = 0;
 	struct inode *inode = NULL;
 
@@ -4176,12 +4176,6 @@ static int try_to_free_dmap_chunks(struct fuse_conn *fc,
 		if (nr_freed >= nr_to_free)
 			break;
 
-		if (nr_eagain > 20) {
-			queue_delayed_work(system_long_wq, &fc->dax_free_work,
-						msecs_to_jiffies(10));
-			return 0;
-		}
-
 		dmap = NULL;
 		spin_lock(&fc->lock);
 
@@ -4225,7 +4219,7 @@ static int try_to_free_dmap_chunks(struct fuse_conn *fc,
 
 		/* Could not get inode lock. Try next element */
 		if (ret == -EAGAIN) {
-			nr_eagain++;
+			cond_resched();
 			continue;
 		}
 		nr_freed++;
-- 
2.20.1

