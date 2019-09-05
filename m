From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  5 Sep 2019 15:48:43 -0400
Message-Id: <20190905194859.16219-3-vgoyal@redhat.com>
In-Reply-To: <20190905194859.16219-1-vgoyal@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 02/18] virtiofs: Check whether hiprio queue is
	connected at submission time
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

For hiprio queue (forget requests), we are keeping a state in queue whether
queue is connected or not. If queue is not connected, do not try to submit
request and return error instead.

As of now, we are checking for this state only in path where worker tries
to submit forget after first attempt failed. Check this state even in
the path when request is being submitted first time.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index a708ccb65662..e9497b565dd8 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -577,9 +577,16 @@ __releases(fiq->waitq.lock)
 	sg_init_one(&sg, forget, sizeof(*forget));
 
 	/* Enqueue the request */
+	spin_lock(&fsvq->lock);
+
+	if (!fsvq->connected) {
+		kfree(forget);
+		spin_unlock(&fsvq->lock);
+		goto out;
+	}
+
 	vq = fsvq->vq;
 	dev_dbg(&vq->vdev->dev, "%s\n", __func__);
-	spin_lock(&fsvq->lock);
 
 	ret = virtqueue_add_sgs(vq, sgs, 1, 0, forget, GFP_ATOMIC);
 	if (ret < 0) {
-- 
2.20.1

