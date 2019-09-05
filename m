From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  5 Sep 2019 15:48:51 -0400
Message-Id: <20190905194859.16219-11-vgoyal@redhat.com>
In-Reply-To: <20190905194859.16219-1-vgoyal@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 10/18] virtiofs: Do not use device managed mem
	for virtio_fs and virtio_fs_vq
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

These data structures should go away when virtio_fs object is going away.
When deivce is going away, we need to just make sure virtqueues can go
away and after that none of the code accesses vq and all the requests
get error.

So allocate memory for virtio_fs and virtio_fs_vq normally and free it
at right time.

This patch still frees up memory during device remove time. A later patch
will make virtio_fs object reference counted and this memory will be
freed when last reference to object is dropped.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index f2936daca39c..1ea0f889e804 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -446,7 +446,7 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 	vq_callback_t **callbacks;
 	const char **names;
 	unsigned int i;
-	int ret;
+	int ret = 0;
 
 	virtio_cread(vdev, struct virtio_fs_config, num_queues,
 		     &fs->num_queues);
@@ -454,9 +454,7 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 		return -EINVAL;
 
 	fs->nvqs = 1 + fs->num_queues;
-
-	fs->vqs = devm_kcalloc(&vdev->dev, fs->nvqs,
-				sizeof(fs->vqs[VQ_HIPRIO]), GFP_KERNEL);
+	fs->vqs = kcalloc(fs->nvqs, sizeof(fs->vqs[VQ_HIPRIO]), GFP_KERNEL);
 	if (!fs->vqs)
 		return -ENOMEM;
 
@@ -504,6 +502,8 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 	kfree(names);
 	kfree(callbacks);
 	kfree(vqs);
+	if (ret)
+		kfree(fs->vqs);
 	return ret;
 }
 
@@ -519,7 +519,7 @@ static int virtio_fs_probe(struct virtio_device *vdev)
 	struct virtio_fs *fs;
 	int ret;
 
-	fs = devm_kzalloc(&vdev->dev, sizeof(*fs), GFP_KERNEL);
+	fs = kzalloc(sizeof(*fs), GFP_KERNEL);
 	if (!fs)
 		return -ENOMEM;
 	vdev->priv = fs;
@@ -552,6 +552,7 @@ static int virtio_fs_probe(struct virtio_device *vdev)
 
 out:
 	vdev->priv = NULL;
+	kfree(fs);
 	return ret;
 }
 
@@ -582,6 +583,8 @@ static void virtio_fs_remove(struct virtio_device *vdev)
 	mutex_unlock(&virtio_fs_mutex);
 
 	vdev->priv = NULL;
+	kfree(fs->vqs);
+	kfree(fs);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.20.1

