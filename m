From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Sep 2021 10:38:43 -0400
Message-Id: <20210930143850.1188628-2-vgoyal@redhat.com>
In-Reply-To: <20210930143850.1188628-1-vgoyal@redhat.com>
References: <20210930143850.1188628-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/8] virtiofs: Disable interrupt requests
	properly
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com
Cc: vgoyal@redhat.com

virtiofs does not support dealing with fuse INTERRUPT requests at all.
But still we set can clear FR_SENT bit which is needed only if INTERRUPT
requests are being handled.

Also, given current code it is possible that virtiofs server is handling
a request and in guest a signal comes, it will wake up process and
queue existing request to fiq->interrupts and never remove it.

request_wait_answer()
{
	if (!fc->no_interupt) {
                if (test_bit(FR_SENT, &req->flags))
                        queue_interrupt(req);
	}
}

Given virtiofs does not support interrupt requests at this point of
time, disable it (Set fc->no_interrupt = 1). This should make sure
requests can't be queued on fiq->interrupts.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 0ad89c6629d7..b9256b8f277f 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -545,7 +545,6 @@ static void copy_args_from_argbuf(struct fuse_args *args, struct fuse_req *req)
 static void virtio_fs_request_complete(struct fuse_req *req,
 				       struct virtio_fs_vq *fsvq)
 {
-	struct fuse_pqueue *fpq = &fsvq->fud->pq;
 	struct fuse_args *args;
 	struct fuse_args_pages *ap;
 	unsigned int len, i, thislen;
@@ -574,10 +573,6 @@ static void virtio_fs_request_complete(struct fuse_req *req,
 		}
 	}
 
-	spin_lock(&fpq->lock);
-	clear_bit(FR_SENT, &req->flags);
-	spin_unlock(&fpq->lock);
-
 	fuse_request_end(req);
 	spin_lock(&fsvq->lock);
 	dec_in_flight_req(fsvq);
@@ -1196,9 +1191,6 @@ static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
 	spin_lock(&fpq->lock);
 	list_add_tail(&req->list, fpq->processing);
 	spin_unlock(&fpq->lock);
-	set_bit(FR_SENT, &req->flags);
-	/* matches barrier in request_wait_answer() */
-	smp_mb__after_atomic();
 
 	if (!in_flight)
 		inc_in_flight_req(fsvq);
@@ -1448,6 +1440,7 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 	fc->delete_stale = true;
 	fc->auto_submounts = true;
 	fc->sync_fs = true;
+	fc->no_interrupt = true;
 
 	/* Tell FUSE to split requests that exceed the virtqueue's size */
 	fc->max_pages_limit = min_t(unsigned int, fc->max_pages_limit,
-- 
2.31.1

