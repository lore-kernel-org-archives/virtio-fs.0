From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 15 Oct 2019 13:46:23 -0400
Message-Id: <20191015174626.11593-3-vgoyal@redhat.com>
In-Reply-To: <20191015174626.11593-1-vgoyal@redhat.com>
References: <20191015174626.11593-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/5] virtiofs: No need to check fpq->connected
	state
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com
Cc: miklos@szeredi.hu, virtualization@lists.linux-foundation.org, vgoyal@redhat.com

In virtiofs we keep per queue connected state in virtio_fs_vq->connected
and use that to end request if queue is not connected. And virtiofs does
not even touch fpq->connected state.

We probably need to merge these two at some point of time. For now, simplify
the code a bit and do not worry about checking state of fpq->connected.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 24ac6f8bf3f7..3b7f7409e77b 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -960,13 +960,6 @@ __releases(fiq->lock)
 
 	fpq = &fs->vqs[queue_id].fud->pq;
 	spin_lock(&fpq->lock);
-	if (!fpq->connected) {
-		spin_unlock(&fpq->lock);
-		req->out.h.error = -ENODEV;
-		pr_err("virtio-fs: %s disconnected\n", __func__);
-		fuse_request_end(fc, req);
-		return;
-	}
 	list_add_tail(&req->list, fpq->processing);
 	spin_unlock(&fpq->lock);
 	set_bit(FR_SENT, &req->flags);
-- 
2.20.1

