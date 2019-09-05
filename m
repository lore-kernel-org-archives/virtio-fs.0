From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  5 Sep 2019 15:48:52 -0400
Message-Id: <20190905194859.16219-12-vgoyal@redhat.com>
In-Reply-To: <20190905194859.16219-1-vgoyal@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 11/18] virtiofs: stop and drain queues after
	sending DESTROY
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, miklos@szeredi.hu
Cc: mst@redhat.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, vgoyal@redhat.com

During virtio_kill_sb() we first stop forget queue and drain it and then
call fuse_kill_sb_anon(). This will result in sending DESTROY request to
fuse server. Once finished, stop all the queues and drain one more time
just to be sure and then free up the devices.

Given drain queues will call flush_work() on various workers, remove this
logic from virtio_free_devs().

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 1ea0f889e804..a76bd5a04521 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -180,9 +180,6 @@ static void virtio_fs_free_devs(struct virtio_fs *fs)
 		if (!fsvq->fud)
 			continue;
 
-		flush_work(&fsvq->done_work);
-		flush_delayed_work(&fsvq->dispatch_work);
-
 		/* TODO need to quiesce/end_requests/decrement dev_count */
 		fuse_dev_free(fsvq->fud);
 		fsvq->fud = NULL;
@@ -994,6 +991,8 @@ static int virtio_fs_fill_super(struct super_block *sb)
 		atomic_inc(&fc->dev_count);
 	}
 
+	/* Previous unmount will stop all queues. Start these again */
+	virtio_fs_start_all_queues(fs);
 	fuse_send_init(fc, init_req);
 	return 0;
 
@@ -1026,6 +1025,12 @@ static void virtio_kill_sb(struct super_block *sb)
 	virtio_fs_drain_all_queues(vfs);
 
 	fuse_kill_sb_anon(sb);
+
+	/* fuse_kill_sb_anon() must have sent destroy. Stop all queues
+	 * and drain one more time and free fuse devices.
+	 */
+	virtio_fs_stop_all_queues(vfs);
+	virtio_fs_drain_all_queues(vfs);
 	virtio_fs_free_devs(vfs);
 }
 
-- 
2.20.1

