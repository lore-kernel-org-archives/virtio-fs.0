DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=hyper-sh.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=nEOrKSMif5Rhx+f8eiguakTvzrBEYAuSlBOFu+kRyro=;
	b=LOwXUCqy+XAGGwixL0hMHvMGgyx7pWlTVnqdxRRDbu0BoMmJ8om0CAV4f06JJaPH7G
	Zy+JLBx3tLW8mON+/FqoMNKYUF/OfF/qMdI3QDZkkpdh9+vZJhmNDwnIdEyhKOv0cv0W
	DM6CA/tyQzEmfXWgOHgfButrunBks/VjrS9+cgckKDQyCvM/EG0npnI5GSLKGk/3A0f4
	mqhtMQwlmjmgeRg4JaXLhDKRX8mNjBmrgBSmGY09j1vA8Sw0EXQn5b/z0cwfQxjBhmfV
	x75vHXrJZIldCNJzVdqQUXY1K+8YZL0Y+MoEfDxotd3hoNQHF2NmhFxOFgAaj2JxmZ1r
	qpUw==
MIME-Version: 1.0
References: <20190524053324.115026-1-tao.peng@linux.alibaba.com>
	<20190524053324.115026-3-tao.peng@linux.alibaba.com>
	<20190528213813.GD6446@redhat.com>
In-Reply-To: <20190528213813.GD6446@redhat.com>
From: Tao Peng <bergwolf@hyper.sh>
Date: Wed, 29 May 2019 10:09:15 +0800
Message-ID: <CACGKRzX7f0YZTz8s4HKvdwNW4vc=ji=nWSnaAFYXXaSCNCxu4Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH-v3 2/2] virtiofs: FUSE_REMOVEMAPPING support
 multiple removing multiple entries
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, Peng Tao <tao.peng@linux.alibaba.com>

On Wed, May 29, 2019 at 5:38 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, May 24, 2019 at 01:33:24PM +0800, Peng Tao wrote:
> > Change FUSE_REMOVEMAPPING wire protocol so that we can remove
> > multiple mappings in one call.
> >
> > Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
>
> Hi Tao,
>
> How about posting a patch for enabling multiple entries in
> fuse_removemapping in one patch.
>
> Lets first merge that patch in kernel and virtiofsd. And post patches
> to remove mappings on truncate later? That's an optimization and
> can wait a bit.
Sure, no problem!

Cheers,
Tao
>
> Thanks
> Vivek
>
> > ---
> >  fs/fuse/file.c            | 85 +++++++++++++++++++++++++++++++++------
> >  include/uapi/linux/fuse.h |  9 ++++-
> >  2 files changed, 81 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index 6c970d19e926..03c81baa8989 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -320,25 +320,80 @@ static int fuse_setup_one_mapping(struct inode *inode,
> >       return 0;
> >  }
> >
> > -static int fuse_removemapping_one(struct inode *inode,
> > -                                     struct fuse_dax_mapping *dmap)
> > +static int fuse_send_removemapping_request(struct inode *inode,
> > +             struct fuse_removemapping_in_header *header,
> > +             struct fuse_removemapping_in *inargp)
> >  {
> >       struct fuse_inode *fi = get_fuse_inode(inode);
> >       struct fuse_conn *fc = get_fuse_conn(inode);
> > -     struct fuse_removemapping_in inarg;
> >       FUSE_ARGS(args);
> >
> > -     memset(&inarg, 0, sizeof(inarg));
> > -     inarg.moffset = dmap->window_offset;
> > -     inarg.len = dmap->length;
> >       args.in.h.opcode = FUSE_REMOVEMAPPING;
> >       args.in.h.nodeid = fi->nodeid;
> > -     args.in.numargs = 1;
> > -     args.in.args[0].size = sizeof(inarg);
> > -     args.in.args[0].value = &inarg;
> > +     args.in.numargs = 2;
> > +     args.in.args[0].size = sizeof(*header);
> > +     args.in.args[0].value = header;
> > +     args.in.args[1].size = header->count * sizeof(*inargp);
> > +     args.in.args[1].value = inargp;
> >       return fuse_simple_request(fc, &args);
> >  }
> >
> > +static int fuse_removemappings(struct inode *inode, unsigned num,
> > +                             struct list_head *to_remove)
> > +{
> > +     struct fuse_removemapping_in *inargp, *ptr;
> > +     struct fuse_removemapping_in_header header;
> > +     struct fuse_dax_mapping *dmap;
> > +     int ret, i = 0;
> > +
> > +     if (num <= FUSE_REMOVEMAPPING_MAX_ENTRY) {
> > +             inargp = kmalloc_array(num, sizeof(*inargp), GFP_NOIO);
> > +     } else {
> > +             inargp = kmalloc_array(FUSE_REMOVEMAPPING_MAX_ENTRY,
> > +                                     sizeof(*inargp), GFP_NOIO);
> > +     }
> > +     if (inargp == NULL)
> > +             return -ENOMEM;
> > +
> > +     ptr = inargp;
> > +     list_for_each_entry(dmap, to_remove, list) {
> > +             ptr->moffset = dmap->window_offset;
> > +             ptr->len = dmap->length;
> > +             ptr++;
> > +             i++;
> > +             num--;
> > +             if (i >= FUSE_REMOVEMAPPING_MAX_ENTRY || num == 0) {
> > +                     memset(&header, 0, sizeof(header));
> > +                     header.count = i;
> > +                     ret = fuse_send_removemapping_request(inode, &header, inargp);
> > +                     if (ret)
> > +                             goto out;
> > +                     ptr = inargp;
> > +                     i = 0;
> > +             }
> > +     }
> > +
> > +out:
> > +     kfree(inargp);
> > +     return ret;
> > +}
> > +
> > +static int fuse_removemapping_one(struct inode *inode,
> > +                                     struct fuse_dax_mapping *dmap)
> > +{
> > +     struct fuse_removemapping_in inarg;
> > +     struct fuse_removemapping_in_header header;
> > +
> > +     memset(&header, 0, sizeof(header));
> > +     /* TODO: fill in header.fh when available */
> > +     header.count = 1;
> > +     memset(&inarg, 0, sizeof(inarg));
> > +     inarg.moffset = dmap->window_offset;
> > +     inarg.len = dmap->length;
> > +
> > +     return fuse_send_removemapping_request(inode, &header, &inarg);
> > +}
> > +
> >  /*
> >   * It is called from evict_inode() and by that time inode is going away. So
> >   * this function does not take any locks like fi->i_dmap_sem for traversing
> > @@ -3851,7 +3906,9 @@ static void fuse_dax_do_free_mapping_locked(struct fuse_conn *fc, struct fuse_da
> >  void fuse_dax_free_mappings_range(struct fuse_conn *fc, struct inode *inode, loff_t start, loff_t end)
> >  {
> >       struct fuse_inode *fi = get_fuse_inode(inode);
> > -     struct fuse_dax_mapping *dmap;
> > +     struct fuse_dax_mapping *dmap, *n;
> > +     int num = 0;
> > +     LIST_HEAD(to_remove);
> >
> >       WARN_ON(!inode_is_locked(inode));
> >       WARN_ON(!rwsem_is_locked(&fi->i_mmap_sem));
> > @@ -3866,9 +3923,13 @@ void fuse_dax_free_mappings_range(struct fuse_conn *fc, struct inode *inode, lof
> >       down_write(&fi->i_dmap_sem);
> >       while ((dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, start, end))) {
> >               fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
> > -             fi->nr_dmaps--;
> > +             num++;
> > +             list_add(&dmap->list, &to_remove);
> > +     }
> > +     fi->nr_dmaps -= num;
> > +     fuse_removemappings(inode, num, &to_remove);
> > +     list_for_each_entry_safe(dmap, n, &to_remove, list) {
> >               fuse_dax_do_free_mapping_locked(fc, dmap);
> > -             fuse_removemapping_one(inode, dmap);
> >       }
> >       up_write(&fi->i_dmap_sem);
> >  }
> > diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> > index dbc5013ad747..69ddedca4177 100644
> > --- a/include/uapi/linux/fuse.h
> > +++ b/include/uapi/linux/fuse.h
> > @@ -817,13 +817,20 @@ struct fuse_setupmapping_out {
> >          uint64_t     len[FUSE_SETUPMAPPING_ENTRIES];
> >  };
> >
> > -struct fuse_removemapping_in {
> > +struct fuse_removemapping_in_header {
> >          /* An already open handle */
> >          uint64_t     fh;
> > +     /* number of fuse_removemapping_in follows */
> > +     uint32_t        count;
> > +};
> > +
> > +struct fuse_removemapping_in {
> >       /* Offset into the dax window start the unmapping */
> >       uint64_t        moffset;
> >          /* Length of mapping required */
> >          uint64_t     len;
> >  };
> > +#define FUSE_REMOVEMAPPING_MAX_ENTRY \
> > +             (PAGE_SIZE / sizeof(struct fuse_removemapping_in))
> >
> >  #endif /* _LINUX_FUSE_H */
> > --
> > 2.17.1
> >
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs
>
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs



-- 
bergwolf@hyper.sh

