Date: Thu, 6 Jun 2019 09:56:30 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190606165629.37tcrdw6x4kslyyx@US-160370MP2.local>
References: <1559695356-75503-1-git-send-email-bo.liu@linux.alibaba.com>
	<1559695356-75503-2-git-send-email-bo.liu@linux.alibaba.com>
	<20190606090429.GC2788@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606090429.GC2788@work-vm>
Subject: Re: [Virtio-fs] [PATCH 1/5] virtiofsd: cleanup allocated resource
 in se
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

On Thu, Jun 06, 2019 at 10:04:30AM +0100, Dr. David Alan Gilbert wrote:
> * Liu Bo (bo.liu@linux.alibaba.com) wrote:
> > This cleans up unfreed resources in se on quiting, including
> > se->virtio_dev, se->vu_socket_path, se->vu_socketfd.
> > 
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > ---
> >  contrib/virtiofsd/fuse_lowlevel.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> > index 0fc2880..de700ad 100644
> > --- a/contrib/virtiofsd/fuse_lowlevel.c
> > +++ b/contrib/virtiofsd/fuse_lowlevel.c
> > @@ -2557,6 +2557,12 @@ void fuse_session_destroy(struct fuse_session *se)
> >  	free(se->cuse_data);
> >  	if (se->fd != -1)
> >  		close(se->fd);
> > +
> > +        free(se->virtio_dev);
> > +        se->virtio_dev = NULL;
> 
> We don't touch virtio_dev or vu_socketfd anywhere else in fuse_lowlevel.c -
> so we should probably do this cleanup in fuse_virtio.c, and then have
> something like:
> 
>    if (se->vu_socket_path) {
>      virtio_session_close(se);
>      free(se->vu_socket_path);
>      se->vu_socket_path = NULL;
>    }
>

I see, will fix it.  Thanks for the comments.

thanks,
-liubo

> 
> > +        free(se->vu_socket_path);
> > +        close(se->vu_socketfd);
> > +
> >  	free(se);
> >  }
> >  
> > -- 
> > 1.8.3.1
> > 
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

