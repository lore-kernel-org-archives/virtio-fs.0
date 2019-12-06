Date: Fri, 6 Dec 2019 15:55:38 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191206155538.GH2878@work-vm>
References: <20191204190836.31324-1-vgoyal@redhat.com>
	<20191204190836.31324-2-vgoyal@redhat.com>
	<20191204194250.GN3325@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204194250.GN3325@work-vm>
Subject: Re: [Virtio-fs] [PATCH v2 1/5] virtiofsd: Get rid of unused fields
 in fv_QueueInfo
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, mszeredi@redhat.com, qemu-devel@nongnu.org

* Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > There are some unused fields in "struct fv_QueueInfo". Get rid of these fields.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  contrib/virtiofsd/fuse_virtio.c | 6 ------
> >  1 file changed, 6 deletions(-)
> > 
> > diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
> > index 31c8542b6c..2a9cd60a01 100644
> > --- a/contrib/virtiofsd/fuse_virtio.c
> > +++ b/contrib/virtiofsd/fuse_virtio.c
> > @@ -50,12 +50,6 @@ struct fv_QueueInfo {
> >      int qidx;
> >      int kick_fd;
> >      int kill_fd; /* For killing the thread */
> > -
> > -    /* The element for the command currently being processed */
> > -    VuVirtqElement *qe;
> > -    /* If any of the qe vec elements (towards vmm) are unmappable */
> > -    unsigned int elem_bad_in;
> > -    bool reply_sent;
> 
> Yep, those last two got moved into FVRequest as part of the thread pool
> stuff.
> 
> 
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

I've merged that 1/5 into my world.

> >  };
> >  
> >  /* A FUSE request */
> > -- 
> > 2.20.1
> > 
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

