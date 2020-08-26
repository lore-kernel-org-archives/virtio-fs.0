Date: Wed, 26 Aug 2020 11:51:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200826155142.GA1043442@redhat.com>
References: <20200819221956.845195-1-vgoyal@redhat.com>
	<20200819221956.845195-12-vgoyal@redhat.com>
	<CAJfpegsgHE0MkZLFgE4yrZXO5ThDxCj85-PjizrXPRC2CceT1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsgHE0MkZLFgE4yrZXO5ThDxCj85-PjizrXPRC2CceT1g@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v3 11/18] fuse: implement FUSE_INIT
	map_alignment field
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, linux-kernel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On Wed, Aug 26, 2020 at 04:06:35PM +0200, Miklos Szeredi wrote:
> On Thu, Aug 20, 2020 at 12:21 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > The device communicates FUSE_SETUPMAPPING/FUSE_REMOVMAPPING alignment
> > constraints via the FUST_INIT map_alignment field.  Parse this field and
> > ensure our DAX mappings meet the alignment constraints.
> >
> > We don't actually align anything differently since our mappings are
> > already 2MB aligned.  Just check the value when the connection is
> > established.  If it becomes necessary to honor arbitrary alignments in
> > the future we'll have to adjust how mappings are sized.
> >
> > The upshot of this commit is that we can be confident that mappings will
> > work even when emulating x86 on Power and similar combinations where the
> > host page sizes are different.
> >
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/fuse/fuse_i.h          |  5 ++++-
> >  fs/fuse/inode.c           | 18 ++++++++++++++++--
> >  include/uapi/linux/fuse.h |  4 +++-
> >  3 files changed, 23 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index 478c940b05b4..4a46e35222c7 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -47,7 +47,10 @@
> >  /** Number of dentries for each connection in the control filesystem */
> >  #define FUSE_CTL_NUM_DENTRIES 5
> >
> > -/* Default memory range size, 2MB */
> > +/*
> > + * Default memory range size.  A power of 2 so it agrees with common FUSE_INIT
> > + * map_alignment values 4KB and 64KB.
> > + */
> >  #define FUSE_DAX_SZ    (2*1024*1024)
> >  #define FUSE_DAX_SHIFT (21)
> >  #define FUSE_DAX_PAGES (FUSE_DAX_SZ/PAGE_SIZE)
> > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > index b82eb61d63cc..947abdd776ca 100644
> > --- a/fs/fuse/inode.c
> > +++ b/fs/fuse/inode.c
> > @@ -980,9 +980,10 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_args *args,
> >  {
> >         struct fuse_init_args *ia = container_of(args, typeof(*ia), args);
> >         struct fuse_init_out *arg = &ia->out;
> > +       bool ok = true;
> >
> >         if (error || arg->major != FUSE_KERNEL_VERSION)
> > -               fc->conn_error = 1;
> > +               ok = false;
> >         else {
> >                 unsigned long ra_pages;
> >
> > @@ -1045,6 +1046,13 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_args *args,
> >                                         min_t(unsigned int, FUSE_MAX_MAX_PAGES,
> >                                         max_t(unsigned int, arg->max_pages, 1));
> >                         }
> > +                       if ((arg->flags & FUSE_MAP_ALIGNMENT) &&
> > +                           (FUSE_DAX_SZ % (1ul << arg->map_alignment))) {
> 
> This just obfuscates "arg->map_alignment != FUSE_DAX_SHIFT".
> 
> So the intention was that userspace can ask the kernel for a
> particular alignment, right?

My understanding is that device will specify alignment for
the foffset/moffset fields in fuse_setupmapping_in/fuse_removemapping_one.
And DAX mapping can be any size meeting that alignment contraint.

> 
> In that case kernel can definitely succeed if the requested alignment
> is smaller than the kernel provided one, no? 

Yes. So if map_alignemnt is 64K and DAX mapping size is 2MB, that's just
fine because it meets 4K alignment contraint. Just that we can't use
4K size DAX mapping in that case.

> It would also make
> sense to make this a two way negotiation.  I.e. send the largest
> alignment (FUSE_DAX_SHIFT in this implementation) that the kernel can
> provide in fuse_init_in.   In that case the only error would be if
> userspace ignored the given constraints.

We could make it two way negotiation if it helps. So if we support
multiple mapping sizes in future, say 4K, 64K, 2MB, 1GB. So idea is
to send alignment of largest mapping size to device/user_space (1GB)
in this case? And that will allow device to choose an alignment
which best fits its needs?

But problem here is that sending (log2(1GB)) does not mean we support
all the alignments in that range. For example, if device selects say
256MB as minimum alignment, kernel might not support it.

So there seem to be two ways to handle this.

A.Let device be conservative and always specify the minimum aligment
  it can work with and let guest kernel automatically choose a mapping
  size which meets that min_alignment contraint.

B.Send all the mapping sizes supported by kernel to device and then
  device chooses an alignment as it sees fit. We could probably send
  a 64bit field and set a bit for every size we support as dax mapping.
  If we were to go down this path, I think in that case client should
  respond back with exact mapping size we should use (and not with
  minimum alignment).

I thought intent behind this patch was to implement A.

Stefan/David, this patch came from you folks. What do you think?

> 
> Am I getting not getting something?
> 
> > +                               pr_err("FUSE: map_alignment %u incompatible"
> > +                                      " with dax mem range size %u\n",
> > +                                      arg->map_alignment, FUSE_DAX_SZ);
> > +                               ok = false;
> > +                       }
> >                 } else {
> >                         ra_pages = fc->max_read / PAGE_SIZE;
> >                         fc->no_lock = 1;
> > @@ -1060,6 +1068,11 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_args *args,
> >         }
> >         kfree(ia);
> >
> > +       if (!ok) {
> > +               fc->conn_init = 0;
> > +               fc->conn_error = 1;
> > +       }
> > +
> >         fuse_set_initialized(fc);
> >         wake_up_all(&fc->blocked_waitq);
> >  }
> > @@ -1082,7 +1095,8 @@ void fuse_send_init(struct fuse_conn *fc)
> >                 FUSE_WRITEBACK_CACHE | FUSE_NO_OPEN_SUPPORT |
> >                 FUSE_PARALLEL_DIROPS | FUSE_HANDLE_KILLPRIV | FUSE_POSIX_ACL |
> >                 FUSE_ABORT_ERROR | FUSE_MAX_PAGES | FUSE_CACHE_SYMLINKS |
> > -               FUSE_NO_OPENDIR_SUPPORT | FUSE_EXPLICIT_INVAL_DATA;
> > +               FUSE_NO_OPENDIR_SUPPORT | FUSE_EXPLICIT_INVAL_DATA |
> > +               FUSE_MAP_ALIGNMENT;
> >         ia->args.opcode = FUSE_INIT;
> >         ia->args.in_numargs = 1;
> >         ia->args.in_args[0].size = sizeof(ia->in);
> > diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> > index 373cada89815..5b85819e045f 100644
> > --- a/include/uapi/linux/fuse.h
> > +++ b/include/uapi/linux/fuse.h
> > @@ -313,7 +313,9 @@ struct fuse_file_lock {
> >   * FUSE_CACHE_SYMLINKS: cache READLINK responses
> >   * FUSE_NO_OPENDIR_SUPPORT: kernel supports zero-message opendir
> >   * FUSE_EXPLICIT_INVAL_DATA: only invalidate cached pages on explicit request
> > - * FUSE_MAP_ALIGNMENT: map_alignment field is valid
> > + * FUSE_MAP_ALIGNMENT: init_out.map_alignment contains log2(byte alignment) for
> > + *                    foffset and moffset fields in struct
> > + *                    fuse_setupmapping_out and fuse_removemapping_one.
> 
> fuse_setupmapping_in

Will fix it.

Vivek

