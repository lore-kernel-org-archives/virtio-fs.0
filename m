Date: Wed, 11 Mar 2020 10:41:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200311144124.GB83257@redhat.com>
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-13-vgoyal@redhat.com>
	<CAJfpeguY8gDYVp_q3-W6JNA24zCry+SfWmEW2zuHLQLhmyUB3Q@mail.gmail.com>
	<20200310203321.GF38440@redhat.com>
	<CAOQ4uxh2WdLdbcMp+qvQCX2hiBx+hLO1z5wkZtc-7GCuDdsthw@mail.gmail.com>
	<CAJfpeguwqEsPLtph73AG7bhm1Dp4ahyJtyW=Ud7L-OFwyEmwWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguwqEsPLtph73AG7bhm1Dp4ahyJtyW=Ud7L-OFwyEmwWg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 12/20] fuse: Introduce
	setupmapping/removemapping commands
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Amir Goldstein <amir73il@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Mar 11, 2020 at 03:19:18PM +0100, Miklos Szeredi wrote:
> On Wed, Mar 11, 2020 at 8:03 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Mar 10, 2020 at 10:34 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Tue, Mar 10, 2020 at 08:49:49PM +0100, Miklos Szeredi wrote:
> > > > On Wed, Mar 4, 2020 at 5:59 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > >
> > > > > Introduce two new fuse commands to setup/remove memory mappings. This
> > > > > will be used to setup/tear down file mapping in dax window.
> > > > >
> > > > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > > > Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> > > > > ---
> > > > >  include/uapi/linux/fuse.h | 37 +++++++++++++++++++++++++++++++++++++
> > > > >  1 file changed, 37 insertions(+)
> > > > >
> > > > > diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> > > > > index 5b85819e045f..62633555d547 100644
> > > > > --- a/include/uapi/linux/fuse.h
> > > > > +++ b/include/uapi/linux/fuse.h
> > > > > @@ -894,4 +894,41 @@ struct fuse_copy_file_range_in {
> > > > >         uint64_t        flags;
> > > > >  };
> > > > >
> > > > > +#define FUSE_SETUPMAPPING_ENTRIES 8
> > > > > +#define FUSE_SETUPMAPPING_FLAG_WRITE (1ull << 0)
> > > > > +struct fuse_setupmapping_in {
> > > > > +       /* An already open handle */
> > > > > +       uint64_t        fh;
> > > > > +       /* Offset into the file to start the mapping */
> > > > > +       uint64_t        foffset;
> > > > > +       /* Length of mapping required */
> > > > > +       uint64_t        len;
> > > > > +       /* Flags, FUSE_SETUPMAPPING_FLAG_* */
> > > > > +       uint64_t        flags;
> > > > > +       /* Offset in Memory Window */
> > > > > +       uint64_t        moffset;
> > > > > +};
> > > > > +
> > > > > +struct fuse_setupmapping_out {
> > > > > +       /* Offsets into the cache of mappings */
> > > > > +       uint64_t        coffset[FUSE_SETUPMAPPING_ENTRIES];
> > > > > +        /* Lengths of each mapping */
> > > > > +        uint64_t       len[FUSE_SETUPMAPPING_ENTRIES];
> > > > > +};
> > > >
> > > > fuse_setupmapping_out together with FUSE_SETUPMAPPING_ENTRIES seem to be unused.
> > >
> > > This looks like leftover from the old code. I will get rid of it. Thanks.
> > >
> >
> > Hmm. I wonder if we should keep some out args for future extensions.
> > Maybe return the mapped size even though it is all or nothing at this
> > point?
> >
> > I have interest in a similar FUSE mapping functionality that was prototyped
> > by Miklos and published here:
> > https://lore.kernel.org/linux-fsdevel/CAJfpegtjEoE7H8tayLaQHG9fRSBiVuaspnmPr2oQiOZXVB1+7g@mail.gmail.com/
> >
> > In this prototype, a FUSE_MAP command is used by the server to map a
> > range of file to the kernel for io. The command in args are quite similar to
> > those in fuse_setupmapping_in, but since the server is on the same host,
> > the mapping response is {mapfd, offset, size}.
> 
> Right.  So the difference is in which entity allocates the mapping.
> IOW whether the {fd, offset, size} is input or output in the protocol.
> 
> I don't remember the reasons for going with the mapping being
> allocated by the client, not the other way round.   Vivek?

I think one of the main reasons is memory reclaim. Once all ranges in 
a cache range are allocated, we need to free a memory range which can be
reused. And client has all the logic to free up that range so that it can
be remapped and reused for a different file/offset. Server will not know
any of this. So I will think that for virtiofs, server might not be
able to decide where to map a section of file and it has to be told
explicitly by the client.

> 
> If the allocation were to be by the server, we could share the request
> type and possibly some code between the two, although the I/O
> mechanism would still be different.
> 

So input parameters of both FUSE_SETUPMAPPING and FUSE_MAP seem
similar (except the moffset field).  Given output of FUSE_MAP reqeust
is very different, I would think it will be easier to have it as a
separate command.

Or can it be some sort of optional output args which can differentiate
between two types of requests. 

/me personally finds it simpler to have separate command instead of
overloading FUSE_SETUPMAPPING. But its your call. :-) 

Vivek

