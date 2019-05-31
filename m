From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 31 May 2019 14:57:08 -0400
Message-Id: <20190531185709.10267-3-vgoyal@redhat.com>
In-Reply-To: <20190531185709.10267-1-vgoyal@redhat.com>
References: <20190531185709.10267-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/3] Do not dispatch forget requests once queue
	is disconnected
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, tao.peng@linux.alibaba.com
Cc: vgoyal@redhat.com

Keep track of virtiofs queue status and once queue is disconnected do
not dispatch any more forget reuqests. Queue is disconnected once unmount
request comes in.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index cbda7ebd5bf9..737e92cdc5ed 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -31,6 +31,7 @@ struct virtio_fs_vq {
 	struct list_head queued_reqs;
 	struct delayed_work dispatch_work;
 	struct fuse_dev *fud;
+	bool connected;
 	char name[24];
 } ____cacheline_aligned_in_smp;
 
@@ -215,6 +216,12 @@ static void virtio_fs_hiprio_dispatch_work(struct work_struct *work)
 		}
 
 		list_del(&forget->list);
+		if (!fsvq->connected) {
+			spin_unlock(&fsvq->lock);
+			kfree(forget);
+			continue;
+		}
+
 		sg_init_one(&sg, forget, sizeof(*forget));
 
 		/* Enqueue the request */
@@ -425,9 +432,10 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 	if (ret < 0)
 		goto out;
 
-	for (i = 0; i < fs->nvqs; i++)
+	for (i = 0; i < fs->nvqs; i++) {
 		fs->vqs[i].vq = vqs[i];
-
+		fs->vqs[i].connected = true;
+	}
 out:
 	kfree(names);
 	kfree(callbacks);
@@ -1071,11 +1079,16 @@ static int virtio_fs_fill_super(struct super_block *sb, void *data,
 static void virtio_kill_sb(struct super_block *sb)
 {
 	struct fuse_conn *fc = get_fuse_conn_super(sb);
+	struct virtio_fs *vfs = fc->iq.priv;
+	struct virtio_fs_vq *fsvq = &vfs->vqs[VQ_HIPRIO];
+
+	/* Stop forget queue. Soon destroy will be sent */
+	spin_lock(&fsvq->lock);
+	fsvq->connected = false;
+	spin_unlock(&fsvq->lock);
+
 	fuse_kill_sb_anon(sb);
-	if (fc) {
-		struct virtio_fs *vfs = fc->iq.priv;
-		virtio_fs_free_devs(vfs);
-	}
+	virtio_fs_free_devs(vfs);
 }
 
 static struct dentry *virtio_fs_mount(struct file_system_type *fs_type,
-- 
2.20.1

