Date: Thu, 1 Aug 2019 15:20:16 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190801142016.GI2773@work-vm>
References: <5D3F8F04.3030404@huawei.com>
	<4ec43f2f-1d72-5fe1-3b93-2c75ee6f87b4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ec43f2f-1d72-5fe1-3b93-2c75ee6f87b4@redhat.com>
Subject: Re: [Virtio-fs] [Qemu-devel] [PATCH] virtiofsd: fix compile error
 if 'F_OFD_GETLK' not defined
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eric Blake <eblake@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Eric Blake (eblake@redhat.com) wrote:
> On 7/29/19 7:27 PM, piaojun wrote:
> > Use F_GETLK for fcntl when F_OFD_GETLK not defined.
> 
> Which system are you hitting this problem on?
> 
> The problem with F_GETLK is that it is NOT as safe as F_OFD_GETLK.
> 
> We already have fcntl_op_getlk and qemu_probe_lock_ops() in util/osdep.c
> to not only determine which form to use, but also to emit a warning to
> the end user if we had to fall back to the unsafe F_GETLK. Why is your
> code not reusing that logic?
> 
> > 
> > Signed-off-by: Jun Piao <piaojun@huawei.com>
> > ---
> >  contrib/virtiofsd/passthrough_ll.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> > index 9ae1381..757785b 100644
> > --- a/contrib/virtiofsd/passthrough_ll.c
> > +++ b/contrib/virtiofsd/passthrough_ll.c
> > @@ -1619,7 +1619,11 @@ static void lo_getlk(fuse_req_t req, fuse_ino_t ino,
> >  		return;
> >  	}
> > 
> > +#ifdef F_OFD_GETLK
> >  	ret = fcntl(plock->fd, F_OFD_GETLK, lock);
> > +#else
> > +	ret = fcntl(plock->fd, F_GETLK, lock);
> > +#endif
> 
> Hmm. Since this is in contrib, you are trying to compile something that
> is independent of util/osdep.c (at least, I assume that's the case, as
> contrib/virtiofsd/ is not even part of qemu.git master yet - in which
> case, why is this not being squashed in to the patch introducing that
> file, rather than sent standalone).  On the other hand, that raises the
> question - who is trying to use virtiofsd on a kernel that is too old to
> provid F_OFD_GETLK?  Isn't the whole point of virtiofsd to be speeding
> up modern usage, at which point an old kernel is just gumming up the
> works?  It seems like you are better off letting compilation fail on a
> system that is too old to support decent F_OFD_GETLK, rather than
> silently falling back to something that is unsafe.

It is, but I guess the answer here is someone wanted to build on RHEL7.

Dave

> 
> -- 
> Eric Blake, Principal Software Engineer
> Red Hat, Inc.           +1-919-301-3226
> Virtualization:  qemu.org | libvirt.org
> 




> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

