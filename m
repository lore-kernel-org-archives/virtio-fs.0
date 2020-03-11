Date: Wed, 11 Mar 2020 08:59:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200311125923.GA83257@redhat.com>
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-21-vgoyal@redhat.com>
	<20200311051641.l6gonmmyb4o5rcrb@rsjd01523.et2sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311051641.l6gonmmyb4o5rcrb@rsjd01523.et2sqa>
Subject: Re: [Virtio-fs] [PATCH 20/20] fuse,
	virtiofs: Add logic to free up a memory range
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, mst@redhat.com, linux-fsdevel@vger.kernel.org

On Wed, Mar 11, 2020 at 01:16:42PM +0800, Liu Bo wrote:

[..]
> > @@ -719,6 +723,7 @@ void fuse_conn_put(struct fuse_conn *fc)
> >  	if (refcount_dec_and_test(&fc->count)) {
> >  		struct fuse_iqueue *fiq = &fc->iq;
> >  
> > +		flush_delayed_work(&fc->dax_free_work);
> 
> Today while debugging another case, I realized that flushing work here
> at the very last fuse_conn_put() is a bit too late, here's my analysis,
> 
>          umount                                                   kthread
> 
> deactivate_locked_super
>   ->virtio_kill_sb                                            try_to_free_dmap_chunks
>     ->generic_shutdown_super                                    ->igrab()
>                                                                 ...
>      ->evict_inodes()  -> check all inodes' count
>      ->fuse_conn_put                                            ->iput
>  ->virtio_fs_free_devs
>    ->fuse_dev_free
>      ->fuse_conn_put // vq1
>    ->fuse_dev_free
>      ->fuse_conn_put // vq2
>        ->flush_delayed_work
> 
> The above can end up with a warning message reported by evict_inodes()
> about stable inodes.

Hi Liu Bo,

Which warning is that? Can you point me to it in code.

> So I think it's necessary to put either
> cancel_delayed_work_sync() or flush_delayed_work() before going to
> generic_shutdown_super().

In general I agree that shutting down memory range freeing worker
earling in unmount/shutdown sequence makes sense. It does not seem
to help to let it run while filesystem is going away. How about following
patch.

---
 fs/fuse/inode.c     |    1 -
 fs/fuse/virtio_fs.c |    5 +++++
 2 files changed, 5 insertions(+), 1 deletion(-)

Index: redhat-linux/fs/fuse/virtio_fs.c
===================================================================
--- redhat-linux.orig/fs/fuse/virtio_fs.c	2020-03-10 14:11:10.970284651 -0400
+++ redhat-linux/fs/fuse/virtio_fs.c	2020-03-11 08:27:08.103330039 -0400
@@ -1295,6 +1295,11 @@ static void virtio_kill_sb(struct super_
 	vfs = fc->iq.priv;
 	fsvq = &vfs->vqs[VQ_HIPRIO];
 
+	/* Stop dax worker. Soon evict_inodes() will be called which will
+	 * free all memory ranges belonging to all inodes.
+	 */
+	flush_delayed_work(&fc->dax_free_work);
+
 	/* Stop forget queue. Soon destroy will be sent */
 	spin_lock(&fsvq->lock);
 	fsvq->connected = false;
Index: redhat-linux/fs/fuse/inode.c
===================================================================
--- redhat-linux.orig/fs/fuse/inode.c	2020-03-10 09:13:35.132565666 -0400
+++ redhat-linux/fs/fuse/inode.c	2020-03-11 08:22:02.685330039 -0400
@@ -723,7 +723,6 @@ void fuse_conn_put(struct fuse_conn *fc)
 	if (refcount_dec_and_test(&fc->count)) {
 		struct fuse_iqueue *fiq = &fc->iq;
 
-		flush_delayed_work(&fc->dax_free_work);
 		if (fc->dax_dev)
 			fuse_free_dax_mem_ranges(&fc->free_ranges);
 		if (fiq->ops->release)

