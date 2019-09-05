From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  5 Sep 2019 15:48:48 -0400
Message-Id: <20190905194859.16219-8-vgoyal@redhat.com>
In-Reply-To: <20190905194859.16219-1-vgoyal@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 07/18] virtiofs: Stop virtiofs queues when
	device is being removed
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

Stop all the virt queues when device is going away. This will ensure that
no new requests are submitted to virtqueue and and request will end with
error -ENOTCONN.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index f68a25ca9e9d..90e7b2f345e5 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -493,10 +493,24 @@ static int virtio_fs_probe(struct virtio_device *vdev)
 	return ret;
 }
 
+static void virtio_fs_stop_all_queues(struct virtio_fs *fs)
+{
+	struct virtio_fs_vq *fsvq;
+	int i;
+
+	for (i = 0; i < fs->nvqs; i++) {
+		fsvq = &fs->vqs[i];
+		spin_lock(&fsvq->lock);
+		fsvq->connected = false;
+		spin_unlock(&fsvq->lock);
+	}
+}
+
 static void virtio_fs_remove(struct virtio_device *vdev)
 {
 	struct virtio_fs *fs = vdev->priv;
 
+	virtio_fs_stop_all_queues(fs);
 	vdev->config->reset(vdev);
 	virtio_fs_cleanup_vqs(vdev, fs);
 
-- 
2.20.1

