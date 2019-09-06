Date: Fri, 6 Sep 2019 09:51:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190906135131.GE22083@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<20190905194859.16219-17-vgoyal@redhat.com>
	<20190906120534.GX5900@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906120534.GX5900@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 16/18] virtiofs: Use virtio_fs_mutex for
 races w.r.t ->remove and mount path
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: miklos@szeredi.hu, mst@redhat.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org

On Fri, Sep 06, 2019 at 01:05:34PM +0100, Stefan Hajnoczi wrote:
> On Thu, Sep 05, 2019 at 03:48:57PM -0400, Vivek Goyal wrote:
> > It is possible that a mount is in progress and device is being removed at
> > the same time. Use virtio_fs_mutex to avoid races.
> > 
> > This also takes care of bunch of races and removes some TODO items.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/fuse/virtio_fs.c | 32 ++++++++++++++++++++++----------
> >  1 file changed, 22 insertions(+), 10 deletions(-)
> 
> Let's move to a per-device mutex in the future.  That way a single
> device that fails to drain/complete requests will not hang all other
> virtio-fs instances.  This is fine for now.

Good point. For now I updated the patch so that it applies cleanly
after previous two patches changed.

Subject: virtiofs: Use virtio_fs_mutex for races w.r.t ->remove and mount path

It is possible that a mount is in progress and device is being removed at
the same time. Use virtio_fs_mutex to avoid races. 

This also takes care of bunch of races and removes some TODO items.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

Index: rhvgoyal-linux-fuse/fs/fuse/virtio_fs.c
===================================================================
--- rhvgoyal-linux-fuse.orig/fs/fuse/virtio_fs.c	2019-09-06 09:40:53.309245246 -0400
+++ rhvgoyal-linux-fuse/fs/fuse/virtio_fs.c	2019-09-06 09:43:25.335245246 -0400
@@ -13,7 +13,9 @@
 #include <linux/highmem.h>
 #include "fuse_i.h"
 
-/* List of virtio-fs device instances and a lock for the list */
+/* List of virtio-fs device instances and a lock for the list. Also provides
+ * mutual exclusion in device removal and mounting path
+ */
 static DEFINE_MUTEX(virtio_fs_mutex);
 static LIST_HEAD(virtio_fs_instances);
 
@@ -72,17 +74,19 @@ static void release_virtio_fs_obj(struct
 	kfree(vfs);
 }
 
+/* Make sure virtiofs_mutex is held */
 static void virtio_fs_put(struct virtio_fs *fs)
 {
-	mutex_lock(&virtio_fs_mutex);
 	kref_put(&fs->refcount, release_virtio_fs_obj);
-	mutex_unlock(&virtio_fs_mutex);
 }
 
 static void virtio_fs_fiq_release(struct fuse_iqueue *fiq)
 {
 	struct virtio_fs *vfs = fiq->priv;
+
+	mutex_lock(&virtio_fs_mutex);
 	virtio_fs_put(vfs);
+	mutex_unlock(&virtio_fs_mutex);
 }
 
 static void virtio_fs_drain_queue(struct virtio_fs_vq *fsvq)
@@ -596,9 +600,8 @@ static void virtio_fs_remove(struct virt
 	struct virtio_fs *fs = vdev->priv;
 
 	mutex_lock(&virtio_fs_mutex);
+	/* This device is going away. No one should get new reference */
 	list_del_init(&fs->list);
-	mutex_unlock(&virtio_fs_mutex);
-
 	virtio_fs_stop_all_queues(fs);
 	virtio_fs_drain_all_queues(fs);
 	vdev->config->reset(vdev);
@@ -607,6 +610,7 @@ static void virtio_fs_remove(struct virt
 	vdev->priv = NULL;
 	/* Put device reference on virtio_fs object */
 	virtio_fs_put(fs);
+	mutex_unlock(&virtio_fs_mutex);
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -978,10 +982,15 @@ static int virtio_fs_fill_super(struct s
 		.no_force_umount = true,
 	};
 
-	/* TODO lock */
-	if (fs->vqs[VQ_REQUEST].fud) {
-		pr_err("virtio-fs: device already in use\n");
-		err = -EBUSY;
+	mutex_lock(&virtio_fs_mutex);
+
+	/* After holding mutex, make sure virtiofs device is still there.
+	 * Though we are holding a refernce to it, drive ->remove might
+	 * still have cleaned up virtual queues. In that case bail out.
+	 */
+	err = -EINVAL;
+	if (list_empty(&fs->list)) {
+		pr_info("virtio-fs: tag <%s> not found\n", fs->tag);
 		goto err;
 	}
 
@@ -1007,7 +1016,6 @@ static int virtio_fs_fill_super(struct s
 
 	fc = fs->vqs[VQ_REQUEST].fud->fc;
 
-	/* TODO take fuse_mutex around this loop? */
 	for (i = 0; i < fs->nvqs; i++) {
 		struct virtio_fs_vq *fsvq = &fs->vqs[i];
 
@@ -1020,6 +1028,7 @@ static int virtio_fs_fill_super(struct s
 	/* Previous unmount will stop all queues. Start these again */
 	virtio_fs_start_all_queues(fs);
 	fuse_send_init(fc, init_req);
+	mutex_unlock(&virtio_fs_mutex);
 	return 0;
 
 err_free_init_req:
@@ -1027,6 +1036,7 @@ err_free_init_req:
 err_free_fuse_devs:
 	virtio_fs_free_devs(fs);
 err:
+	mutex_unlock(&virtio_fs_mutex);
 	return err;
 }
 
@@ -1100,7 +1110,9 @@ static int virtio_fs_get_tree(struct fs_
 
 	fc = kzalloc(sizeof(struct fuse_conn), GFP_KERNEL);
 	if (!fc) {
+		mutex_lock(&virtio_fs_mutex);
 		virtio_fs_put(fs);
+		mutex_unlock(&virtio_fs_mutex);
 		return -ENOMEM;
 	}
 

