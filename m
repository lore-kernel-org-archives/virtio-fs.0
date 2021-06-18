Date: Fri, 18 Jun 2021 11:21:31 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210618112131.46ce0b2a@bahia.lan>
In-Reply-To: <CAJfpegtpvU6Z6hQ-NKh-shN+Pux7+XzXwNK_Ro8YpfA-3tCOkg@mail.gmail.com>
References: <20210617141518.304659-1-groug@kaod.org>
	<CAJfpegtpvU6Z6hQ-NKh-shN+Pux7+XzXwNK_Ro8YpfA-3tCOkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Don't allow file creation with
	FUSE_OPEN
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>

On Fri, 18 Jun 2021 10:58:33 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Thu, 17 Jun 2021 at 16:15, Greg Kurz <groug@kaod.org> wrote:
> >
> > A well behaved FUSE client uses FUSE_CREATE to create files. It isn't
> > supposed to pass O_CREAT along a FUSE_OPEN request, as documented in
> > the "fuse_lowlevel.h" header :
> >
> >     /**
> >      * Open a file
> >      *
> >      * Open flags are available in fi->flags. The following rules
> >      * apply.
> >      *
> >      *  - Creation (O_CREAT, O_EXCL, O_NOCTTY) flags will be
> >      *    filtered out / handled by the kernel.
> >
> > But if it does anyway, virtiofsd crashes with:
> >
> > *** invalid openat64 call: O_CREAT or O_TMPFILE without mode ***: terminated
> >
> > This is because virtiofsd ends up passing this flag to openat() without
> > passing a mode_t 4th argument which is mandatory with O_CREAT, and glibc
> > aborts.
> >
> > The offending path is:
> >
> > lo_open()
> >     lo_do_open()
> >         lo_inode_open()
> >
> > Other callers of lo_inode_open() only pass O_RDWR and lo_create()
> > passes a valid fd to lo_do_open() which thus doesn't even call
> > lo_inode_open() in this case.
> >
> > Specifying O_CREAT with FUSE_OPEN is a protocol violation. Check this
> > in lo_open() and return an error to the client : EINVAL since this is
> > already what glibc returns with other illegal flag combinations.
> >
> > The FUSE filesystem doesn't currently support O_TMPFILE, but the very
> > same would happen if O_TMPFILE was passed in a FUSE_OPEN request. Check
> > that as well.
> >
> > Signed-off-by: Greg Kurz <groug@kaod.org>
> > ---
> >  tools/virtiofsd/passthrough_ll.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > index 49c21fd85570..14f62133131c 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -2145,6 +2145,12 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
> >          return;
> >      }
> >
> > +    /* File creation is handled by lo_create() */
> > +    if (fi->flags & (O_CREAT | O_TMPFILE)) {
> > +        fuse_reply_err(req, EINVAL);
> > +        return;
> > +    }
> > +
> 
> Okay.  Question comes to mind whether the check should be even more
> strict, possibly allowing just a specific set of flags, and erroring
> out on everything else?
> 

I've focused on O_CREAT and O_TMPFILE because they cause an explicit abort()
in glibc when the code is compiled with -D_FORTIFY_SOURCE=2, but yes,
maybe it could make sense to check more of them.

> AFAICS linux kernel should never pass anything to FUSE_OPEN outside of this set:
> 
> O_RDONLY
> O_WRONLY
> O_RDWR
> O_APPEND
> O_NDELAY
> O_NONBLOCK
> __O_SYNC
> O_DSYNC
> FASYNC
> O_DIRECT
> O_LARGEFILE
> O_NOFOLLOW
> O_NOATIME
> 
> A separate question is whether virtiofsd should also be silently
> ignoring some of the above flags.
> 

Dunno on the top of my head...

BTW, as suggested by Dave, I've submitted a similar patch to upstream
libfuse:

https://github.com/libfuse/libfuse/pull/615

And I got interesting suggestions:
1) do it in core FUSE, i.e. fuse_lowlevel.c, since this isn't specific to
   passthrough_ll AFAICT
2) print out an error
3) exit

1 makes a lot of sense. I guess 2 is fine this cannot be used by a
buggy guest to flood some log file on the host. 3 doesn't seems
to be an acceptable solution, and it wouldn't change much the
outcome compared to what we have now.

So I will go for 1 and 2.

Cheers,

--
Greg

> Thanks,
> Miklos
> 
> 
> 
> >      err = lo_do_open(lo, inode, -1, fi);
> >      lo_inode_put(lo, &inode);
> >      if (err) {
> > --
> > 2.31.1
> >

