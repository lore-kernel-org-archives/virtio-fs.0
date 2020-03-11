DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=8hb6iJ/Efn6V2wxOcA+ehqPLCrGm2i7aFEcinNiAwTg=;
	b=rd8rhWCgH//f6swHt00TfU44oSyrPrCf9zNhKCp43xO5/c/lia8gyyB94BWGxKw6yV
	QOm0DqL9P4U5T2uB6Inj7XI/UlbsEfDNG3do1rbezI/44mNdmxVEQCDVkll8kGrYaAts
	AnQLHHVMbGjbmGMLgv1f/s/a2ayaX6Up7a8Mk/4/8kxlP++P1jSBtRfGYdv1fszrCbxB
	J4YKst/ZXrjqvQcelfdiL548nQVPzdxVY02bdopH9Vz+v97xEl+GHknDNi4r2tcrPYJy
	YXna9QlT8wDB2bvqb0c0qdd8LBkPPhhTwJblfNdloF3Yaj4tR2lznGCBm/Z0Trm4sqID
	A62Q==
MIME-Version: 1.0
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-13-vgoyal@redhat.com>
	<CAJfpeguY8gDYVp_q3-W6JNA24zCry+SfWmEW2zuHLQLhmyUB3Q@mail.gmail.com>
	<20200310203321.GF38440@redhat.com>
In-Reply-To: <20200310203321.GF38440@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Mar 2020 09:03:42 +0200
Message-ID: <CAOQ4uxh2WdLdbcMp+qvQCX2hiBx+hLO1z5wkZtc-7GCuDdsthw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Mar 10, 2020 at 10:34 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Mar 10, 2020 at 08:49:49PM +0100, Miklos Szeredi wrote:
> > On Wed, Mar 4, 2020 at 5:59 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > Introduce two new fuse commands to setup/remove memory mappings. This
> > > will be used to setup/tear down file mapping in dax window.
> > >
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> > > ---
> > >  include/uapi/linux/fuse.h | 37 +++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 37 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> > > index 5b85819e045f..62633555d547 100644
> > > --- a/include/uapi/linux/fuse.h
> > > +++ b/include/uapi/linux/fuse.h
> > > @@ -894,4 +894,41 @@ struct fuse_copy_file_range_in {
> > >         uint64_t        flags;
> > >  };
> > >
> > > +#define FUSE_SETUPMAPPING_ENTRIES 8
> > > +#define FUSE_SETUPMAPPING_FLAG_WRITE (1ull << 0)
> > > +struct fuse_setupmapping_in {
> > > +       /* An already open handle */
> > > +       uint64_t        fh;
> > > +       /* Offset into the file to start the mapping */
> > > +       uint64_t        foffset;
> > > +       /* Length of mapping required */
> > > +       uint64_t        len;
> > > +       /* Flags, FUSE_SETUPMAPPING_FLAG_* */
> > > +       uint64_t        flags;
> > > +       /* Offset in Memory Window */
> > > +       uint64_t        moffset;
> > > +};
> > > +
> > > +struct fuse_setupmapping_out {
> > > +       /* Offsets into the cache of mappings */
> > > +       uint64_t        coffset[FUSE_SETUPMAPPING_ENTRIES];
> > > +        /* Lengths of each mapping */
> > > +        uint64_t       len[FUSE_SETUPMAPPING_ENTRIES];
> > > +};
> >
> > fuse_setupmapping_out together with FUSE_SETUPMAPPING_ENTRIES seem to be unused.
>
> This looks like leftover from the old code. I will get rid of it. Thanks.
>

Hmm. I wonder if we should keep some out args for future extensions.
Maybe return the mapped size even though it is all or nothing at this
point?

I have interest in a similar FUSE mapping functionality that was prototyped
by Miklos and published here:
https://lore.kernel.org/linux-fsdevel/CAJfpegtjEoE7H8tayLaQHG9fRSBiVuaspnmPr2oQiOZXVB1+7g@mail.gmail.com/

In this prototype, a FUSE_MAP command is used by the server to map a
range of file to the kernel for io. The command in args are quite similar to
those in fuse_setupmapping_in, but since the server is on the same host,
the mapping response is {mapfd, offset, size}.

I wonder, if we decide to go forward with this prototype (and I may well decide
to drive this forward), should the new command be overloading
FUSE_SETUPMAPPING, by using new flags or should it be a new
command? In either case, I think it would be best to try and make a decision
now in order to avoid ambiguity with protocol command/flag names later on.

If we decide that those are completely different beasts and it is agreed that
the future command will be named, for example, FUSE_SETUPIOMAP
with different arguments and that this naming will not create confusion and
ambiguity with FUSE_SETUPMAPPING, then there is no actionable item at
this time.

But it is possible that there is something to gain from using the same
command(?) and same book keeping mechanism for both types of
mappings. Even server on same host could decide that it wants
to map some file regions via mmap and some via iomap.
In that case, perhaps we should make the FUSE_SETUPMAPPING
response args expressive enough to be able to express an iomap
mapping in the future and perhaps dax code should explicitly request
for FUSE_SETUPMAPPING_FLAG_DAX mapping type?

Thoughts?

Amir.


