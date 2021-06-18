Date: Fri, 18 Jun 2021 10:20:57 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210618102057.21e901fa@bahia.lan>
In-Reply-To: <20210618014007.GA1219970@redhat.com>
References: <20210617141518.304659-1-groug@kaod.org>
	<20210618014007.GA1219970@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, qemu-devel@nongnu.org

On Thu, 17 Jun 2021 21:40:07 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Thu, Jun 17, 2021 at 04:15:18PM +0200, Greg Kurz wrote:
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
> 

This is also the consequence of virtiofsd being compiled with
-D_FORTIFY_SOURCE=2. Without that, no abort but arbitrary data
is passed as mode_t argument to the openat() syscall instead.

> So did you hit this error with current fuse client. If yes, that means
> client needs fixing as well?
> 

I've patched the client to cause this:

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -28,6 +28,7 @@ static int fuse_send_open(struct fuse_mount *fm, u64 nodeid,
 
        memset(&inarg, 0, sizeof(inarg));
        inarg.flags = open_flags & ~(O_CREAT | O_EXCL | O_NOCTTY);
+       if (opcode == FUSE_OPEN) inarg.flags |= O_TMPFILE;
        if (!fm->fc->atomic_o_trunc)
                inarg.flags &= ~O_TRUNC;


> Or you are doing this fix based on comment in fuse_lowlevel.h.
> 
> I am wondering why this protocl restriction is there that open()
> path should not be able to honor O_CREAT.
> 

It isn't a protocol restriction IMHO. The distinction between file
creation and file opening has always been there since the start.
Older versions of the protocol would send FUSE_MKNOD to create a
file and then send FUSE_OPEN to open it. Because this was racy,
FUSE_CREATE was introduced at some point to do both operations
atomically.

Question is : what would be the semantics of O_CREAT in FUSE_OPEN ?

> Vivek
> 
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
> >      err = lo_do_open(lo, inode, -1, fi);
> >      lo_inode_put(lo, &inode);
> >      if (err) {
> > -- 
> > 2.31.1
> > 
> 

