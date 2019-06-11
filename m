Date: Tue, 11 Jun 2019 11:06:05 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190611180604.i6dkkhtafdr2zlax@US-160370MP2.local>
References: <bff1bd0e0d829acacba4a10e072e4a8ccdf972b4.1560260621.git.renzhen@linux.alibaba.com>
	<20190611173833.GH2777@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611173833.GH2777@work-vm>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: fix incorrect error handling in
 lo_do_lookup
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

On Tue, Jun 11, 2019 at 06:38:33PM +0100, Dr. David Alan Gilbert wrote:
> * Eric Ren (renzhen@linux.alibaba.com) wrote:
> > Signed-off-by: Eric Ren <renzhen@linux.alibaba.com>
> > ---
> >  contrib/virtiofsd/passthrough_ll.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> > index 574e209d95..78716c8aca 100644
> > --- a/contrib/virtiofsd/passthrough_ll.c
> > +++ b/contrib/virtiofsd/passthrough_ll.c
> > @@ -670,7 +670,6 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> >  		close(newfd);
> >  		newfd = -1;
> >  	} else {
> > -		saverr = ENOMEM;
> >  		inode = calloc(1, sizeof(struct lo_inode));
> >  		if (!inode)
> >  			goto out_err;
> 
> Can you explain why you remove that?   How does it
> get a sensible errno in this case?
>

Are you suggesting that calloc() doesn't set errno on failure?

the manual reads that

"The UNIX 98 standard requires malloc(), calloc(), and realloc() to
set errno to ENOMEM upon failure. Glibc assumes that this is done (and
the glibc versions of these routines do this); if you use a private
malloc implementation that does not set errno, then certain library
routines may fail without having a reason in errno."



> > @@ -691,7 +690,9 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> >  	res = fstatat(inode->fd, "", &e->attr,
> >  		      AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
> >  	if (res == -1) {
> > +		saverr = errno;
> >  		unref_inode(lo, inode, 1);
> > +		errno = saverr;
> 
> That one I agree with.
>

Well...can we instead set errno in place to avoid any surprise in the future?

thanks,
-liubo

> 
> >  		goto out_err;
> >  	}
> >  
> > -- 
> > 2.17.2 (Apple Git-113)
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

