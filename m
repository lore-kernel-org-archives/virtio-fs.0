From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed, 17 Apr 2019 02:03:17 +0800
Message-Id: <20190416180322.65113-5-bo.liu@linux.alibaba.com>
In-Reply-To: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/9] virtio-fs: fix use-after-free against
	virtio_fs_vq's fuse_dev info
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

When running xfstests generic/135, we hit below panic:
[  376.386031] Workqueue: events virtio_fs_hiprio_done_work [virtio_fs]
[  376.386086] RIP: 0010:_raw_spin_lock+0xc/0x20
[  376.386132] Code: 00 f0 0f b1 17 75 02 f3 c3 89 c6 e8 6e b6 91 ff 66
90 c3 90 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 31 c0 ba 01 00 00
00 <f0> 0f b1 17 75 02 f3 c3 89 c6 e8 45 b6 91 ff 66 90 c3 66 90 66 66
[  376.386234] RSP: 0018:ffffc900024f7e50 EFLAGS: 00010246
[  376.386273] RAX: 0000000000000000 RBX: ffff888136c08000 RCX:
ffff88813b862520
[  376.386316] RDX: 0000000000000001 RSI: ffff88813b014ab0 RDI:
000000000000000c
[  376.386361] RBP: 000000000000000c R08: 000073746e657665 R09:
8080808080808080
[  376.386404] R10: 0000000000000000 R11: fffffffffffffff8 R12:
ffff88813b866600
[  376.386447] R13: 0000000000000000 R14: ffff888136eee180 R15:
ffff8881374bece8
[  376.386491] FS:  0000000000000000(0000) GS:ffff88813b840000(0000)
knlGS:0000000000000000
[  376.386539] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  376.386577] CR2: 000000000000000c CR3: 000000000200a003 CR4:
00000000000606e0
[  376.386624] Call Trace:
[  376.386693]  virtio_fs_hiprio_done_work+0x32/0xa0 [virtio_fs]
[  376.386745]  process_one_work+0x19e/0x380
[  376.386787]  worker_thread+0x4f/0x3b0
[  376.386821]  ? rescuer_thread+0x350/0x350
[  376.386858]  kthread+0xf6/0x130
[  376.386895]  ? kthread_create_worker_on_cpu+0x70/0x70
[  376.386933]  ret_from_fork+0x1f/0x30

After some investigations, the root cause is FORGET requests in
virtio-fs not being ref counted, then virtio_fs_vq's fuse_dev
info maybe freed in virtio_fs_free_devs(), but we still have
un-finished FORGET requests, see below race:

kernel issue FORGET request      |
                                 |  user issue umount operation
                                 |
                                 |  virtio_kill_sb
                                 |  ==> fuse_kill_sb_anon
                                 |  ====> fuse_sb_destroy
                                 |  ======> fuse_wait_aborted
                                 |         Note: here we won't wait FORGET
                                 |         request
                                 |  ==> virtio_fs_free_devs
                                 |      free fuse_dev info
                                 |
                                 |
FORGET request is issued to host |
                                 |
FORGET request is completed, and |
virtio_fs_hiprio_done_work() will|
be called, then use-after-free   |
against fuse_dev occurs.         |
                                 |

Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/fuse/virtio_fs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 68fd11b..c55f1b1 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -181,6 +181,7 @@ static void virtio_fs_hiprio_done_work(struct work_struct *work)
 	struct virtio_fs_vq *fsvq = container_of(work, struct virtio_fs_vq,
 						 done_work);
 	struct fuse_pqueue *fpq = &fsvq->fud->pq;
+	struct fuse_conn *fc = fsvq->fud->fc;
 	struct virtqueue *vq = fsvq->vq;
 
 	/* Free completed FUSE_FORGET requests */
@@ -191,8 +192,10 @@ static void virtio_fs_hiprio_done_work(struct work_struct *work)
 
 		virtqueue_disable_cb(vq);
 
-		while ((req = virtqueue_get_buf(vq, &len)) != NULL)
+		while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
 			kfree(req);
+			fuse_drop_waiting(fc);
+		}
 	} while (!virtqueue_enable_cb(vq) && likely(!virtqueue_is_broken(vq)));
 	spin_unlock(&fpq->lock);
 }
@@ -208,6 +211,7 @@ static void virtio_fs_hiprio_dispatch_work(struct work_struct *work)
 	struct virtio_fs_vq *fsvq = container_of(work, struct virtio_fs_vq,
 						 dispatch_work.work);
 	struct fuse_pqueue *fpq = &fsvq->fud->pq;
+	struct fuse_conn *fc = fsvq->fud->fc;
 	struct virtqueue *vq = fsvq->vq;
 	struct scatterlist sg;
 	struct scatterlist *sgs[] = {&sg};
@@ -246,6 +250,7 @@ static void virtio_fs_hiprio_dispatch_work(struct work_struct *work)
 			spin_unlock(&fpq->lock);
 			return;
 		}
+		atomic_inc(&fc->num_waiting);
 
 		notify = virtqueue_kick_prepare(vq);
 		spin_unlock(&fpq->lock);
@@ -747,6 +752,7 @@ static int virtio_fs_restore(struct virtio_device *vdev)
 static void virtio_fs_wake_forget_and_unlock(struct fuse_iqueue *fiq)
 __releases(fiq->waitq.lock)
 {
+	struct fuse_conn *fc;
 	struct fuse_forget_link *link;
 	struct virtio_fs_forget *forget;
 	struct fuse_pqueue *fpq;
@@ -813,6 +819,9 @@ static void virtio_fs_wake_forget_and_unlock(struct fuse_iqueue *fiq)
 		goto out;
 	}
 
+	fc = fsvq->fud->fc;
+	atomic_inc(&fc->num_waiting);
+
 	notify = virtqueue_kick_prepare(vq);
 
 	spin_unlock(&fpq->lock);
-- 
1.8.3.1

