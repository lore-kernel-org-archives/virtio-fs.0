Date: Thu, 25 Jul 2019 16:48:22 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190725154822.GJ2656@work-vm>
References: <20190724211024.GA31096@redhat.com>
	<20190724232927.wzjx6rihcqr44vug@US-160370MP2.local>
	<20190725132743.GH2656@work-vm> <20190725152119.GA15543@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725152119.GA15543@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: During setup mapping,
 open file O_RDWR only if needed
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

* Vivek Goyal (vgoyal@redhat.com) wrote:
> On Thu, Jul 25, 2019 at 02:27:43PM +0100, Dr. David Alan Gilbert wrote:
> > * Liu Bo (bo.liu@linux.alibaba.com) wrote:
> > > On Wed, Jul 24, 2019 at 05:10:24PM -0400, Vivek Goyal wrote:
> > > > As of now we always open file O_RDWR (even if writable mappings are not
> > > > required). This leads to copy up of file if file is backed by overlayfs
> > > > and hence nullying advantages of overlayfs.
> > > > 
> > > > So open file O_RDONLY if writable mappings are not required. Open O_RDWR
> > > > if writable mappings are needed.
> > > > 
> > > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > > ---
> > > >  contrib/virtiofsd/passthrough_ll.c |    9 ++++++---
> > > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > > > 
> > > > Index: qemu/contrib/virtiofsd/passthrough_ll.c
> > > > ===================================================================
> > > > --- qemu.orig/contrib/virtiofsd/passthrough_ll.c	2019-07-24 16:31:07.014871768 -0400
> > > > +++ qemu/contrib/virtiofsd/passthrough_ll.c	2019-07-24 16:32:10.064412722 -0400
> > > > @@ -2197,15 +2197,15 @@ static void lo_setupmapping(fuse_req_t r
> > > >          VhostUserFSSlaveMsg msg = { 0 };
> > > >          uint64_t vhu_flags;
> > > >  	char *buf;
> > > > +	bool writable = flags & FUSE_SETUPMAPPING_FLAG_WRITE;
> > > 
> > > typo? flags is set to O_WRONLY or 0 in do_lookup, although this may work as same.
> > 
> > Right; that should be O_WRONLY;  
> > do_setupmapping does:
> > 
> >         genflags = 0;
> >         genflags |= (arg->flags & FUSE_SETUPMAPPING_FLAG_WRITE) ? O_WRONLY : 0;
> > 
> > to convert from the fuse definition on the wire to the O_ notation
> > before calling the filesstem code.
> 
> So I have two questions.
> 
> - O_WRONLY does not sound like correct mapping. FUSE_SETUPMAPPING_FLAG_WRITE
>   only says that write behavior is required. It does not say *write only*.

True, we should make it end up as O_RDONLY or O_RDWR.

> - Is it must that we need to translate fuse message specific flag
>   to O_* notation. How about let filesystem code parse it?

I think all of the decoding of wire protocol is done in fuse_lowlevel,
it tries not to pass protocol down.

Dave

> Thanks
> Vivek
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

