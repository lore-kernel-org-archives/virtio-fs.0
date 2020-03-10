Date: Tue, 10 Mar 2020 16:33:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200310203321.GF38440@redhat.com>
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-13-vgoyal@redhat.com>
	<CAJfpeguY8gDYVp_q3-W6JNA24zCry+SfWmEW2zuHLQLhmyUB3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguY8gDYVp_q3-W6JNA24zCry+SfWmEW2zuHLQLhmyUB3Q@mail.gmail.com>
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
Cc: linux-nvdimm@lists.01.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On Tue, Mar 10, 2020 at 08:49:49PM +0100, Miklos Szeredi wrote:
> On Wed, Mar 4, 2020 at 5:59 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Introduce two new fuse commands to setup/remove memory mappings. This
> > will be used to setup/tear down file mapping in dax window.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> > ---
> >  include/uapi/linux/fuse.h | 37 +++++++++++++++++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> >
> > diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> > index 5b85819e045f..62633555d547 100644
> > --- a/include/uapi/linux/fuse.h
> > +++ b/include/uapi/linux/fuse.h
> > @@ -894,4 +894,41 @@ struct fuse_copy_file_range_in {
> >         uint64_t        flags;
> >  };
> >
> > +#define FUSE_SETUPMAPPING_ENTRIES 8
> > +#define FUSE_SETUPMAPPING_FLAG_WRITE (1ull << 0)
> > +struct fuse_setupmapping_in {
> > +       /* An already open handle */
> > +       uint64_t        fh;
> > +       /* Offset into the file to start the mapping */
> > +       uint64_t        foffset;
> > +       /* Length of mapping required */
> > +       uint64_t        len;
> > +       /* Flags, FUSE_SETUPMAPPING_FLAG_* */
> > +       uint64_t        flags;
> > +       /* Offset in Memory Window */
> > +       uint64_t        moffset;
> > +};
> > +
> > +struct fuse_setupmapping_out {
> > +       /* Offsets into the cache of mappings */
> > +       uint64_t        coffset[FUSE_SETUPMAPPING_ENTRIES];
> > +        /* Lengths of each mapping */
> > +        uint64_t       len[FUSE_SETUPMAPPING_ENTRIES];
> > +};
> 
> fuse_setupmapping_out together with FUSE_SETUPMAPPING_ENTRIES seem to be unused.

This looks like leftover from the old code. I will get rid of it. Thanks.

Vivek

