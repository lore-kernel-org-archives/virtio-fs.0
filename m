From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  5 Sep 2019 15:48:54 -0400
Message-Id: <20190905194859.16219-14-vgoyal@redhat.com>
In-Reply-To: <20190905194859.16219-1-vgoyal@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 13/18] virtiofs: Do not access virtqueue in
	request submission path
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

In request submission path it is possible that virtqueue is already gone
due to driver->remove(). So do not access it in dev_dbg(). Use pr_debug()
instead.

If virtuqueue is gone, this will result in NULL pointer deference.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 40259368a6bd..01bbf2c0e144 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -888,10 +888,10 @@ __releases(fiq->waitq.lock)
 	fs = fiq->priv;
 	fc = fs->vqs[queue_id].fud->fc;
 
-	dev_dbg(&fs->vqs[queue_id].vq->vdev->dev,
-		"%s: opcode %u unique %#llx nodeid %#llx in.len %u out.len %u\n",
-		__func__, req->in.h.opcode, req->in.h.unique, req->in.h.nodeid,
-		req->in.h.len, fuse_len_args(req->out.numargs, req->out.args));
+	pr_debug("%s: opcode %u unique %#llx nodeid %#llx in.len %u out.len %u"
+		 "\n", __func__, req->in.h.opcode, req->in.h.unique,
+		 req->in.h.nodeid, req->in.h.len,
+		 fuse_len_args(req->out.numargs, req->out.args));
 
 	fpq = &fs->vqs[queue_id].fud->pq;
 	spin_lock(&fpq->lock);
-- 
2.20.1

