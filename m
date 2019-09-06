Date: Fri, 6 Sep 2019 09:35:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190906133555.GC22083@redhat.com>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<20190905194859.16219-15-vgoyal@redhat.com>
	<20190906120009.GV5900@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906120009.GV5900@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 14/18] virtiofs: Add a fuse_iqueue operation
 to put() reference
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

On Fri, Sep 06, 2019 at 01:00:09PM +0100, Stefan Hajnoczi wrote:
> On Thu, Sep 05, 2019 at 03:48:55PM -0400, Vivek Goyal wrote:
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index 85e2dcad68c1..04e2c000d63f 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -479,6 +479,11 @@ struct fuse_iqueue_ops {
> >  	 */
> >  	void (*wake_pending_and_unlock)(struct fuse_iqueue *fiq)
> >  		__releases(fiq->waitq.lock);
> > +
> > +	/**
> > +	 * Put a reference on fiq_priv.
> 
> I'm a bit confused about fiq->priv's role in this.  The callback takes
> struct fuse_iqueue *fiq as the argument, not void *priv, so it could
> theoretically do more than just release priv.
> 
> I think one of the following would be clearer:
> 
>  /**
>   * Drop a reference to fiq->priv.
>   */
>  void (*put_priv)(void *priv);
> 
> Or:
> 
>  /**
>   * Clean up when fuse_iqueue is destroyed.
>   */
>  void (*release)(struct fuse_iqueue *fiq);
> 
> In the second case fuse_conn_put() shouldn't check fiq->priv.

Hi Stefan,

I like using ->release() method sounds better. Here is the updated patch.
This also changes the next patch, so will post that as well.

Thanks
Vivek

Subject: virtiofs: Add a fuse_iqueue operation to put() reference

Soon I will make virtio_fs object reference counted, where reference will
be taken by device as well as by fuse_conn (fuse_conn->fuse_iqueue->fiq_priv).

When fuse_connection is going away, it should put its reference on virtio_fs
object.

So add a fuse_iqueue method which can be used to call into virtio_fs to
put the reference on the object (fiq_priv).

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/fuse_i.h |    5 +++++
 fs/fuse/inode.c  |    4 ++++
 2 files changed, 9 insertions(+)

Index: rhvgoyal-linux-fuse/fs/fuse/fuse_i.h
===================================================================
--- rhvgoyal-linux-fuse.orig/fs/fuse/fuse_i.h	2019-09-06 08:46:41.846086544 -0400
+++ rhvgoyal-linux-fuse/fs/fuse/fuse_i.h	2019-09-06 09:24:32.752245246 -0400
@@ -479,6 +479,11 @@ struct fuse_iqueue_ops {
 	 */
 	void (*wake_pending_and_unlock)(struct fuse_iqueue *fiq)
 		__releases(fiq->waitq.lock);
+
+	/**
+	 * Cleanup up when fuse_iqueue is destroyed
+	 */
+	void (*release)(struct fuse_iqueue *fiq);
 };
 
 /** /dev/fuse input queue operations */
Index: rhvgoyal-linux-fuse/fs/fuse/inode.c
===================================================================
--- rhvgoyal-linux-fuse.orig/fs/fuse/inode.c	2019-09-06 08:46:41.847086544 -0400
+++ rhvgoyal-linux-fuse/fs/fuse/inode.c	2019-09-06 09:24:32.754245246 -0400
@@ -631,8 +631,12 @@ EXPORT_SYMBOL_GPL(fuse_conn_init);
 void fuse_conn_put(struct fuse_conn *fc)
 {
 	if (refcount_dec_and_test(&fc->count)) {
+		struct fuse_iqueue *fiq = &fc->iq;
+
 		if (fc->destroy_req)
 			fuse_request_free(fc->destroy_req);
+		if (fiq->ops->release)
+			fiq->ops->release(fiq);
 		put_pid_ns(fc->pid_ns);
 		put_user_ns(fc->user_ns);
 		fc->release(fc);


