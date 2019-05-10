DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=hyper-sh.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=dX/36N37Z30yYYCKkqRDMPBw10Qe0gIG3gz1UNbAfiE=;
	b=R325s8msu+Gg7Sk69rEnf3rRL4IQzYGlWxjjaF/aAVgevE8TOZeSOk6ghY20ThqoYm
	J2xg3zK2YQC6JW/uUGrZrpuiqJrlt4NWqEJ6uNWtFYrqImwY6bsyfhpFLh9iDY82yHE7
	JP5P201Obfu/QGiFrvAeRdnRYnqH6XfGR8IA/vdaDSD+q0K8xtyIqbdtGyKAnYJcDJ/V
	0eI4klD9aac5E2fEXlP0LdUu9HuAYt0wJ7TrGC4hBeBTj+gM/oKJ1waeKtQRjiUatk2j
	i/1NwUXFZE9IFJz2yqHLESiq4kG14QEUjRZQtWyRnDOUjJH8naM5wYMk6GMcJ56d4Yeh
	XBWQ==
MIME-Version: 1.0
References: <20190510102957.8705-1-tao.peng@linux.alibaba.com>
	<20190510102957.8705-2-tao.peng@linux.alibaba.com>
	<20190510102957.8705-3-tao.peng@linux.alibaba.com>
	<20190510152338.GA15465@redhat.com>
In-Reply-To: <20190510152338.GA15465@redhat.com>
From: Tao Peng <bergwolf@hyper.sh>
Date: Sat, 11 May 2019 00:16:23 +0800
Message-ID: <CACGKRzUCEThz_ANhOiTnr1Q73Yff5GL+FBvzYH_vrGghFGj5-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 2/2] fuse: remove dmap when truncating inode
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

On Fri, May 10, 2019 at 11:23 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, May 10, 2019 at 06:29:57PM +0800, Peng Tao wrote:
> > The obseleted dmap entries can be put back to global free list
> > immediately and we don't have to rely on reclaim code to free them.
> >
> > Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> > ---
> >  fs/fuse/dir.c    |  5 ++++
> >  fs/fuse/file.c   | 69 +++++++++++++++++++++++++++++++++++++++---------
> >  fs/fuse/fuse_i.h |  2 ++
> >  3 files changed, 63 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > index 3f923fe7841a..233c3ed391f1 100644
> > --- a/fs/fuse/dir.c
> > +++ b/fs/fuse/dir.c
> > @@ -1751,6 +1751,11 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
> >               down_write(&fi->i_mmap_sem);
> >               truncate_pagecache(inode, outarg.attr.size);
> >               invalidate_inode_pages2(inode->i_mapping);
> > +             // Free dmap beyond i_size
> > +             if (IS_DAX(inode) && oldsize > outarg.attr.size)
> > +                     fuse_dax_free_mappings_range(fc, inode,
> > +                                                  outarg.attr.size, -1);
> > +
> >               up_write(&fi->i_mmap_sem);
> >       }
> >
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index 51faed351c7c..6d130f2f3a23 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -30,6 +30,8 @@ static long __fuse_file_fallocate(struct file *file, int mode,
> >                                       loff_t offset, loff_t length);
> >  static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
> >                                       struct inode *inode);
> > +static void fuse_dax_do_remove_mapping_locked(struct fuse_inode *fi,
> > +                                     struct fuse_dax_mapping *dmap);
> >
> >  static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
> >                         int opcode, struct fuse_open_out *outargp)
> > @@ -3752,9 +3754,7 @@ int fuse_dax_reclaim_dmap_locked(struct fuse_conn *fc, struct inode *inode,
> >               return ret;
> >       }
> >
> > -     /* Remove dax mapping from inode interval tree now */
> > -     fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
> > -     fi->nr_dmaps--;
> > +     fuse_dax_do_remove_mapping_locked(fi, dmap);
> >       return 0;
> >  }
> >
> > @@ -3831,6 +3831,58 @@ static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
> >       }
> >  }
> >
> > +/* Cleanup dmap entry and add back to free list */
> > +static void fuse_dax_do_free_mapping_locked(struct fuse_conn *fc, struct fuse_dax_mapping *dmap)
> > +{
> > +     pr_debug("fuse: freed memory range start=0x%llx end=0x%llx "
> > +             "window_offset=0x%llx length=0x%llx\n", dmap->start,
> > +             dmap->end, dmap->window_offset, dmap->length);
> > +     spin_lock(&fc->lock);
> > +     __dmap_remove_busy_list(fc, dmap);
> > +     dmap->inode = NULL;
> > +     dmap->start = dmap->end = 0;
> > +     __free_dax_mapping(fc, dmap);
> > +     spin_unlock(&fc->lock);
> > +}
> > +
> > +/* Remove dax mapping from inode interval tree */
> > +static void fuse_dax_do_remove_mapping_locked(struct fuse_inode *fi, struct fuse_dax_mapping *dmap)
> > +{
> > +     fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
> > +     fi->nr_dmaps--;
> > +}
>
> this is just a two line funciton. I think lets open code it and we don't
> need a separate function for this.
ok.

>
>
> > +
> > +/*
> > + * Free inode dmap entries whose range falls entirely inside [start, end].
> > + * Called with inode->i_rwsem and fuse_inode->i_mmap_sem held.
> > + *
> > + * No need to send FUSE_REMOVEMAPPING to userspace because the userspace mappings
> > + * will be overridden next time dmap is used -- same logic is applied in
> > + * fuse_dax_reclaim_first_mapping().
>
> This is true that sending FUSE_REMOVEMAPPING is not strictly needed. But,
> thinking more about it, what if range does not get used soon. Then it
> will keep resources unnecessarily busy on host? (fd, file, inode, dentry,
> vma etc).
>
> I think it probably is a good idea to send FUSE_REMOVEMAPPING to daemon
> when range is being freed.
We are under inode->i_rwsem and i_mmap_sem here. It can be very
expensive if we wait for userspace holding locks. How about pushing it
to a work queue? Still we at least need to grab the dmap lock but it
seems less expensive and doesn't block truncate.

Cheers,
Tao

> Only case where we are reclaiming a range
> and reusing immediately, we can skip sending FUSE_REMOVEMAPPING.
>
> This will especially be more meaniningful if dax window is large and
> has potential to create lots of mappings.
>
>
> Thanks
> Vivek
>
> > + */
> > +void fuse_dax_free_mappings_range(struct fuse_conn *fc, struct inode *inode, loff_t start, loff_t end)
> > +{
> > +     struct fuse_inode *fi = get_fuse_inode(inode);
> > +     struct fuse_dax_mapping *dmap;
> > +
> > +     WARN_ON(!inode_is_locked(inode));
> > +     WARN_ON(!rwsem_is_locked(&fi->i_mmap_sem));
> > +
> > +     /* interval tree search matches intersecting entries.
> > +      * Adjust the range to avoid dropping partial valid entries. */
> > +     start = ALIGN(start, FUSE_DAX_MEM_RANGE_SZ);
> > +     end = ALIGN_DOWN(end, FUSE_DAX_MEM_RANGE_SZ);
> > +
> > +     pr_debug("fuse: fuse_dax_free_mappings_range start=0x%llx, end=0x%llx\n", start, end);
> > +     /* Lock ordering follows fuse_dax_free_one_mapping() */
> > +     down_write(&fi->i_dmap_sem);
> > +     while ((dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, start, end))) {
> > +             fuse_dax_do_remove_mapping_locked(fi, dmap);
> > +             fuse_dax_do_free_mapping_locked(fc, dmap);
> > +     }
> > +     up_write(&fi->i_dmap_sem);
> > +}
> > +
> >  int fuse_dax_free_one_mapping_locked(struct fuse_conn *fc, struct inode *inode,
> >                               u64 dmap_start)
> >  {
> > @@ -3852,17 +3904,8 @@ int fuse_dax_free_one_mapping_locked(struct fuse_conn *fc, struct inode *inode,
> >       if (ret < 0)
> >               return ret;
> >
> > -     /* Cleanup dmap entry and add back to free list */
> > -     spin_lock(&fc->lock);
> > -     __dmap_remove_busy_list(fc, dmap);
> > -     dmap->inode = NULL;
> > -     dmap->start = dmap->end = 0;
> > -     __free_dax_mapping(fc, dmap);
> > -     spin_unlock(&fc->lock);
> > +     fuse_dax_do_free_mapping_locked(fc, dmap);
> >
> > -     pr_debug("fuse: freed memory range window_offset=0x%llx,"
> > -                             " length=0x%llx\n", dmap->window_offset,
> > -                             dmap->length);
> >       return ret;
> >  }
> >
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index 1149281ab1e8..e273f1209f5b 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -1189,5 +1189,7 @@ unsigned fuse_len_args(unsigned numargs, struct fuse_arg *args);
> >  u64 fuse_get_unique(struct fuse_iqueue *fiq);
> >  void fuse_dax_free_mem_worker(struct work_struct *work);
> >  void fuse_removemapping(struct inode *inode);
> > +void fuse_dax_free_mappings_range(struct fuse_conn *fc, struct inode *inode,
> > +                     loff_t start, loff_t end);
> >
> >  #endif /* _FS_FUSE_I_H */
> > --
> > 2.17.1
> >
>
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs



-- 
bergwolf@hyper.sh

