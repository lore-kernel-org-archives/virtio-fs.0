From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 21 Aug 2019 13:37:36 -0400
Message-Id: <20190821173742.24574-8-vgoyal@redhat.com>
In-Reply-To: <20190821173742.24574-1-vgoyal@redhat.com>
References: <20190821173742.24574-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 07/13] Export fuse_dequeue_forget() function
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

File systems like virtio-fs need to do not have to play directly with
forget list data structures. There is a helper function use that instead.

Rename dequeue_forget() to fuse_dequeue_forget() and export it so that
stacked filesystems can use it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/dev.c    | 9 +++++----
 fs/fuse/fuse_i.h | 3 +++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 6215bc7d4255..2bbfc1f77875 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1185,7 +1185,7 @@ __releases(fiq->waitq.lock)
 	return err ? err : reqsize;
 }
 
-static struct fuse_forget_link *dequeue_forget(struct fuse_iqueue *fiq,
+struct fuse_forget_link *fuse_dequeue_forget(struct fuse_iqueue *fiq,
 					       unsigned max,
 					       unsigned *countp)
 {
@@ -1206,6 +1206,7 @@ static struct fuse_forget_link *dequeue_forget(struct fuse_iqueue *fiq,
 
 	return head;
 }
+EXPORT_SYMBOL(fuse_dequeue_forget);
 
 static int fuse_read_single_forget(struct fuse_iqueue *fiq,
 				   struct fuse_copy_state *cs,
@@ -1213,7 +1214,7 @@ static int fuse_read_single_forget(struct fuse_iqueue *fiq,
 __releases(fiq->waitq.lock)
 {
 	int err;
-	struct fuse_forget_link *forget = dequeue_forget(fiq, 1, NULL);
+	struct fuse_forget_link *forget = fuse_dequeue_forget(fiq, 1, NULL);
 	struct fuse_forget_in arg = {
 		.nlookup = forget->forget_one.nlookup,
 	};
@@ -1261,7 +1262,7 @@ __releases(fiq->waitq.lock)
 	}
 
 	max_forgets = (nbytes - ih.len) / sizeof(struct fuse_forget_one);
-	head = dequeue_forget(fiq, max_forgets, &count);
+	head = fuse_dequeue_forget(fiq, max_forgets, &count);
 	spin_unlock(&fiq->waitq.lock);
 
 	arg.count = count;
@@ -2231,7 +2232,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
 			clear_bit(FR_PENDING, &req->flags);
 		list_splice_tail_init(&fiq->pending, &to_end);
 		while (forget_pending(fiq))
-			kfree(dequeue_forget(fiq, 1, NULL));
+			kfree(fuse_dequeue_forget(fiq, 1, NULL));
 		wake_up_all_locked(&fiq->waitq);
 		spin_unlock(&fiq->waitq.lock);
 		kill_fasync(&fiq->fasync, SIGIO, POLL_IN);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 7da756e2859e..d4b27f048d81 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -820,6 +820,9 @@ void fuse_queue_forget(struct fuse_conn *fc, struct fuse_forget_link *forget,
 
 struct fuse_forget_link *fuse_alloc_forget(void);
 
+struct fuse_forget_link *fuse_dequeue_forget(struct fuse_iqueue *fiq,
+					     unsigned max, unsigned *countp);
+
 /* Used by READDIRPLUS */
 void fuse_force_forget(struct file *file, u64 nodeid);
 
-- 
2.20.1

