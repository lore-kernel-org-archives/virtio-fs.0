Date: Fri, 22 Nov 2019 08:00:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20191122130042.GB8636@redhat.com>
References: <20191115205705.2046-1-vgoyal@redhat.com>
	<20191115205705.2046-5-vgoyal@redhat.com>
	<20191121170020.GE445244@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121170020.GE445244@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 4/4] virtiofs: Support blocking posix locks
 (fcntl(F_SETLKW))
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, miklos@szeredi.hu, linux-kernel@vger.kernel.org

On Thu, Nov 21, 2019 at 05:00:20PM +0000, Stefan Hajnoczi wrote:

[..]
> > +static int virtio_fs_handle_notify(struct virtio_fs *vfs,
> > +				   struct virtio_fs_notify *notify)
> > +{
> > +	int ret = 0;
> > +	struct fuse_out_header *oh = &notify->out_hdr;
> > +	struct fuse_notify_lock_out *lo;
> > +
> > +	/*
> > +	 * For notifications, oh.unique is 0 and oh->error contains code
> > +	 * for which notification as arrived.
> > +	 */
> > +	switch(oh->error) {
> > +	case FUSE_NOTIFY_LOCK:
> > +		lo = (struct fuse_notify_lock_out *) &notify->outarg;
> > +		notify_complete_waiting_req(vfs, lo);
> > +		break;
> > +	default:
> > +		printk("virtio-fs: Unexpected notification %d\n", oh->error);
> > +	}
> > +	return ret;
> > +}
> 
> Is this specific to virtio or can be it handled in common code?

This is not specific to virtio_fs. In principle, regular fuse daemon could
implement something similar. Though they might not have to because client
can just block without introducing deadlock possibilities.

Anyway, I will look into moving this code into fuse common.

[..]
> > diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> > index 373cada89815..45f0c4efec8e 100644
> > --- a/include/uapi/linux/fuse.h
> > +++ b/include/uapi/linux/fuse.h
> > @@ -481,6 +481,7 @@ enum fuse_notify_code {
> >  	FUSE_NOTIFY_STORE = 4,
> >  	FUSE_NOTIFY_RETRIEVE = 5,
> >  	FUSE_NOTIFY_DELETE = 6,
> > +	FUSE_NOTIFY_LOCK = 7,
> >  	FUSE_NOTIFY_CODE_MAX,
> >  };
> >  
> > @@ -868,6 +869,12 @@ struct fuse_notify_retrieve_in {
> >  	uint64_t	dummy4;
> >  };
> >  
> > +struct fuse_notify_lock_out {
> > +	uint64_t	id;
> 
> Please call this field "unique" or "lock_unique" so it's clear this
> identifier is the fuse_header_in->unique value of the lock request.

Ok, will do.

Vivek

