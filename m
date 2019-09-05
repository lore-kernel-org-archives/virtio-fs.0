From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  5 Sep 2019 15:48:45 -0400
Message-Id: <20190905194859.16219-5-vgoyal@redhat.com>
In-Reply-To: <20190905194859.16219-1-vgoyal@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 04/18] virtiofs: Check connected state for
	VQ_REQUEST queue as well
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

Right now we are checking ->connected state only for VQ_HIPRIO. Now we want
to make use of this method for all queues. So check it for VQ_REQUEST as
well.

This will be helpful if device has been removed and virtqueue is gone. In
that case ->connected will be false and request can't be submitted anymore
and user space will see error -ENOTCONN.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 9d30530e3ca9..c46dd4d284d6 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -755,6 +755,12 @@ static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
 
 	spin_lock(&fsvq->lock);
 
+	if (!fsvq->connected) {
+		spin_unlock(&fsvq->lock);
+		ret = -ENOTCONN;
+		goto out;
+	}
+
 	vq = fsvq->vq;
 	ret = virtqueue_add_sgs(vq, sgs, out_sgs, in_sgs, req, GFP_ATOMIC);
 	if (ret < 0) {
-- 
2.20.1

