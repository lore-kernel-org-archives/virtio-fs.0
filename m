Date: Tue, 6 Aug 2019 09:27:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190806132757.GA11513@redhat.com>
References: <5D43F688.8000607@huawei.com>
 <20190802105352.GF2899@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802105352.GF2899@work-vm>
Subject: Re: [Virtio-fs] [PATCH v2] virtiofsd: fix compile error if
 'F_OFD_GETLK' not defined
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, eblake@redhat.com, qemu-devel@nongnu.org

On Fri, Aug 02, 2019 at 11:53:52AM +0100, Dr. David Alan Gilbert wrote:
> * piaojun (piaojun@huawei.com) wrote:
> > Use F_GETLK for fcntl when F_OFD_GETLK not defined, such as kernel 3.10.
> > 
> > Signed-off-by: Jun Piao <piaojun@huawei.com>
> 
> 
> > ---
> > v2:
> > - Use F_OFD_SETLK to replace F_OFD_GETLK in #ifdef.
> > 
> > ---
> >  contrib/virtiofsd/passthrough_ll.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> > index a81c01d..c69f2f3 100644
> > --- a/contrib/virtiofsd/passthrough_ll.c
> > +++ b/contrib/virtiofsd/passthrough_ll.c
> > @@ -1780,7 +1780,11 @@ static void lo_getlk(fuse_req_t req, fuse_ino_t ino,
> >  		goto out;
> >  	}
> > 
> > +#ifdef F_OFD_GETLK
> >  	ret = fcntl(plock->fd, F_OFD_GETLK, lock);
> > +#else
> > +	ret = fcntl(plock->fd, F_GETLK, lock);
> > +#endif
> >  	if (ret == -1)
> >  		saverr = errno;
> > 
> > @@ -1831,7 +1835,11 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t ino,
> > 
> >  	/* TODO: Is it alright to modify flock? */
> >  	lock->l_pid = 0;
> > +#ifdef F_OFD_SETLK
> >  	ret = fcntl(plock->fd, F_OFD_SETLK, lock);
> > +#else
> > +	ret = fcntl(plock->fd, F_GETLK, lock);
>                                ^^^^^^^
> 
> Typo! You've got GETLK rather than SETLK.
> 
> But, a bigger question - does this actually work!
> The manpage says:
>    'If a process closes any file descriptor referring to a file, then
>    all of the process's locks on that file are released, regardless of the
>    file descriptor(s) on which the locks were obtained.'
> 
> the fd we're using here came from lookup_create_plock_ctx which did
> a new openat to get this fd; so we've already got multiple fd's
> referring to this file; and thus I worry we're going to close
> one of them and lose all our locks on it.

Right, we can't use F_GETLK/F_SETLK here. We are emulating posix locks
using open file description locks (OFD locks).

So having OFD locks will probably be one of the requirements on host.

Also we need to look into fuse support of OFD locks in general. It
might require little work to enable it.

Thanks
Vivek

