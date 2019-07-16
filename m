From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 16 Jul 2019 17:00:50 -0400
Message-Id: <20190716210051.11724-6-vgoyal@redhat.com>
In-Reply-To: <20190716210051.11724-1-vgoyal@redhat.com>
References: <20190716210051.11724-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 5/6] fuse: Get rid of -EAGAIN logic in dmap free
	worker thread
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Now we are not doing inode trylock anymore. That means we will not get
-EAGAIN at high frequency. So get rid of this logic. Its not needed anymore.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index bf9903a858db..42b250d23888 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -4235,17 +4235,11 @@ static int try_to_free_dmap_chunks(struct fuse_conn *fc,
 
 		ret = lookup_and_reclaim_dmap(fc, inode, dmap_start);
 		iput(inode);
-		if (ret && ret != -EAGAIN) {
+		if (ret) {
 			printk("%s(window_offset=0x%llx) failed. err=%d\n",
 				__func__, window_offset, ret);
 			return ret;
 		}
-
-		/* Could not get inode lock. Try next element */
-		if (ret == -EAGAIN) {
-			cond_resched();
-			continue;
-		}
 		nr_freed++;
 	}
 	return 0;
-- 
2.20.1

