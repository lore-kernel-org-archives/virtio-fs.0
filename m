Date: Thu, 18 Apr 2019 13:25:27 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190418122526.GE2984@work-vm>
References: <20190416190858.16833-1-bo.liu@linux.alibaba.com>
	<20190416190858.16833-2-bo.liu@linux.alibaba.com>
	<20190417172621.GJ2839@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417172621.GJ2839@work-vm>
Subject: Re: [Virtio-fs] [PATCH 1/4] virtiofsd: send reply correctly on read
 failure
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>, eguan@linux.alibaba.com
Cc: virtio-fs@redhat.com

* Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
> * Liu Bo (bo.liu@linux.alibaba.com) wrote:
> > From: Eryu Guan <eguan@linux.alibaba.com>
> > 
> > Currently when a lo_read() operation fails, we don't send the failure
> > back to fuse client, and read(2) operation from guest kernel would hang
> > on waiting for the reply.
> > 
> > This is easily triggered by a direct read with non-aligned length.
> > 
> > Fix it by detecting preadv(2) error in virtio_send_data_iov(), and
> > teaching fuse_reply_data() to reply error on error case.
> 
> Thank you for spotting this.
> 
> > Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
> > Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
> > ---
> >  contrib/virtiofsd/fuse_lowlevel.c |  4 ++--
> >  contrib/virtiofsd/fuse_virtio.c   | 12 +++++++++---
> >  2 files changed, 11 insertions(+), 5 deletions(-)
> > 
> > diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> > index 111c6e1..aeb5fe2 100644
> > --- a/contrib/virtiofsd/fuse_lowlevel.c
> > +++ b/contrib/virtiofsd/fuse_lowlevel.c
> > @@ -524,11 +524,11 @@ int fuse_reply_data(fuse_req_t req, struct fuse_bufvec *bufv,
> >  	out.error = 0;
> >  
> >  	res = fuse_send_data_iov(req->se, req->ch, iov, 1, bufv, flags);
> > -	if (res <= 0) {
> > +	if (res >= 0) {
> 
> I need to go and ask the upstream fuse list about this; it's not clear
> to me what fuse_send_data_iov is supposed to return;  let me clarify
> that and get back to you.

Miklos replied to me on the upstream fuse list:
https://sourceforge.net/p/fuse/mailman/fuse-devel/thread/CAOssrKdVViWewmh3nrfKkq6eaWNJ629AR7w90KG3XT2hV9_D1w%40mail.gmail.com/#msg36642807

so this comparison is actually already correct because a negative value
means that something is wrong with the fuse connection (or in our case
virtio) so we can't send an error reply anyway.

> Dave
> 
> >  		fuse_free_req(req);
> >  		return res;
> >  	} else {
> > -		return fuse_reply_err(req, res);
> > +		return fuse_reply_err(req, -res);
> >  	}
> >  }
> >  
> > diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
> > index ca988aa..0b5736d 100644
> > --- a/contrib/virtiofsd/fuse_virtio.c
> > +++ b/contrib/virtiofsd/fuse_virtio.c
> > @@ -333,8 +333,13 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
> >                  ret = preadv(buf->buf[0].fd, in_sg_ptr, in_sg_cpy_count, buf->buf[0].pos);
> >  
> >                  if (se->debug)
> > -                        fprintf(stderr, "%s: preadv_res=%d len=%zd\n",
> > -                                __func__, ret, len);
> > +                        fprintf(stderr, "%s: preadv_res=%d(%s) len=%zd\n",
> > +                                __func__, ret, strerror(errno), len);
> > +                if (ret == -1) {
> > +                        ret = -errno;

So this will need to be      ret = errno    to give a postive error
response to mean that the error was on the file side on the fuse side.
(There's also another case below that where I set ret = EIO where it
should be EIO I think)

> > +                        free(in_sg_cpy);
> > +                        goto err;
> > +                }
> >                  if (ret < len && ret) {
> >                          if (se->debug)
> >                                  fprintf(stderr, "%s: ret < len\n", __func__);
> > @@ -379,7 +384,8 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
> >          vu_queue_notify(&se->virtio_dev->dev, q);
> >  
> >  err:
> > -        ch->qi->reply_sent = true;
> > +        if (!ret)
> > +                ch->qi->reply_sent = true;

Yes, I think that's OK.

Dave

> >  
> >          return ret;
> >  }
> > -- 
> > 1.8.3.1
> > 
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

