Date: Wed, 22 May 2019 12:38:33 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190522113832.GD2666@work-vm>
References: <20190513144144.21646-1-tao.peng@linux.alibaba.com>
	<20190522112655.GB2666@work-vm>
	<CAOssrKchxy0EU=6Gb2uDj3MeCYrLMkmsBE8p6hMAQ=TG9-JmpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKchxy0EU=6Gb2uDj3MeCYrLMkmsBE8p6hMAQ=TG9-JmpQ@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: make FUSE_REMOVEMAPPING support
 multiple entries
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs@redhat.com, Peng Tao <tao.peng@linux.alibaba.com>, Vivek Goyal <vgoyal@redhat.com>

* Miklos Szeredi (mszeredi@redhat.com) wrote:
> On Wed, May 22, 2019 at 1:27 PM Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
> >
> > * Peng Tao (tao.peng@linux.alibaba.com) wrote:
> > > The fuse wire protocol is changed so that we can unmap multiple
> > > mappings in a single call.
> > >
> > > Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> >
> > Hi,
> >   Thanks for the patch and apologies for not responding sooner
> >
> > > ---
> > >  contrib/virtiofsd/fuse_kernel.h    |  9 +++++++--
> > >  contrib/virtiofsd/fuse_lowlevel.c  | 21 ++++++++++++++------
> > >  contrib/virtiofsd/fuse_lowlevel.h  |  5 +++--
> > >  contrib/virtiofsd/passthrough_ll.c | 31 ++++++++++++++++++++----------
> > >  4 files changed, 46 insertions(+), 20 deletions(-)
> > >
> > > diff --git a/contrib/virtiofsd/fuse_kernel.h b/contrib/virtiofsd/fuse_kernel.h
> > > index ce46046a4f..093cacff02 100644
> > > --- a/contrib/virtiofsd/fuse_kernel.h
> > > +++ b/contrib/virtiofsd/fuse_kernel.h
> > > @@ -830,9 +830,14 @@ struct fuse_setupmapping_out {
> > >          uint64_t        len[FUSE_SETUPMAPPING_ENTRIES];
> > >  };
> > >
> > > -struct fuse_removemapping_in {
> > > +struct fuse_removemapping_in_header {
> > >          /* An already open handle */
> > > -     uint64_t        fh;
> > > +        uint64_t        fh;
> > > +        /* number of fuse_removemapping_in follows */
> > > +        unsigned        num;
> >
> > I think all fields in fuse structures are fixed length - e.g. uint32_t
> > or uint64_t.
> >
> > > +};
> > > +
> > > +struct fuse_removemapping_in {
> > >          /* Offset into the dax to start the unmapping */
> > >          uint64_t        moffset;
> > >          /* Length of mapping required */
> >
> > Miklos: Does this make sense for a fuse structure? It's that header
> > followed by 'num' of fuse_removemapping_in.
> 
> There's one example of that already: fuse_batch_forget_in followed by
> 'count' number of fuse_forget_one.

OK, it would be great to follow the same naming pattern for this.

Dave

> Thanks,
> Miklos
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

