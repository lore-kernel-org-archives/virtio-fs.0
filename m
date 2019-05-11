DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=hyper-sh.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=Ho54N4yfKhCp2ux+PC9+fjQDVrlCoKRCVoIduwP7AY8=;
	b=jeA1HAaWqgUMD5nUXBnRU76Bz/5rkNs84Ez9iO69/1Uapd6tagK/3MX5CsTg7N7FAt
	4tqlx4bgPieuKDyLvd3Z+u9E7Hwu/E+XTVK10FWIksF+kS5gstPj0NZ1J62RsdTT4RGV
	hPIQcyITLbuyMt57pjrTbPgmxxYskbwQolYA7jKhsHVDMe8n6Hp2eh9TAt2K/grvkfyL
	bSdHD2aKNHIigfWEDssQhhMisZjxQ1SOY7D2lHzwitmdEUtZYRsKQfGoYWgpafs8tRjB
	Uc1LRjUO1suset0FREDLulyZ9rOW3RtTLhF4QML/+Cgo7cO7A2zRerYb0sDfXixP+I3B
	nisg==
MIME-Version: 1.0
References: <20190510102957.8705-1-tao.peng@linux.alibaba.com>
	<20190510102957.8705-2-tao.peng@linux.alibaba.com>
	<20190510102957.8705-3-tao.peng@linux.alibaba.com>
	<20190510152338.GA15465@redhat.com>
	<CACGKRzUCEThz_ANhOiTnr1Q73Yff5GL+FBvzYH_vrGghFGj5-w@mail.gmail.com>
	<20190510173145.GC15465@redhat.com>
In-Reply-To: <20190510173145.GC15465@redhat.com>
From: Tao Peng <bergwolf@hyper.sh>
Date: Sat, 11 May 2019 23:24:44 +0800
Message-ID: <CACGKRzUVxLEkh=nhEYZYpExOBwNB2BfiFswj6ngYPrEgjtzgsg@mail.gmail.com>
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

On Sat, May 11, 2019 at 1:31 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Sat, May 11, 2019 at 12:16:23AM +0800, Tao Peng wrote:
> > On Fri, May 10, 2019 at 11:23 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Fri, May 10, 2019 at 06:29:57PM +0800, Peng Tao wrote:
> > > > The obseleted dmap entries can be put back to global free list
> > > > immediately and we don't have to rely on reclaim code to free them.
> > > >
> > > > Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> > > > ---
> > > >  fs/fuse/dir.c    |  5 ++++
> > > >  fs/fuse/file.c   | 69 +++++++++++++++++++++++++++++++++++++++---------
> > > >  fs/fuse/fuse_i.h |  2 ++
> > > >  3 files changed, 63 insertions(+), 13 deletions(-)
> > > >
> > > > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > > > index 3f923fe7841a..233c3ed391f1 100644
> > > > --- a/fs/fuse/dir.c
> > > > +++ b/fs/fuse/dir.c
> > > > @@ -1751,6 +1751,11 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
> > > >               down_write(&fi->i_mmap_sem);
> > > >               truncate_pagecache(inode, outarg.attr.size);
> > > >               invalidate_inode_pages2(inode->i_mapping);
> > > > +             // Free dmap beyond i_size
> > > > +             if (IS_DAX(inode) && oldsize > outarg.attr.size)
> > > > +                     fuse_dax_free_mappings_range(fc, inode,
> > > > +                                                  outarg.attr.size, -1);
> > > > +
> > > >               up_write(&fi->i_mmap_sem);
> > > >       }
> > > >
> > > > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > > > index 51faed351c7c..6d130f2f3a23 100644
> > > > --- a/fs/fuse/file.c
> > > > +++ b/fs/fuse/file.c
> > > > @@ -30,6 +30,8 @@ static long __fuse_file_fallocate(struct file *file, int mode,
> > > >                                       loff_t offset, loff_t length);
> > > >  static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
> > > >                                       struct inode *inode);
> > > > +static void fuse_dax_do_remove_mapping_locked(struct fuse_inode *fi,
> > > > +                                     struct fuse_dax_mapping *dmap);
> > > >
> > > >  static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
> > > >                         int opcode, struct fuse_open_out *outargp)
> > > > @@ -3752,9 +3754,7 @@ int fuse_dax_reclaim_dmap_locked(struct fuse_conn *fc, struct inode *inode,
> > > >               return ret;
> > > >       }
> > > >
> > > > -     /* Remove dax mapping from inode interval tree now */
> > > > -     fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
> > > > -     fi->nr_dmaps--;
> > > > +     fuse_dax_do_remove_mapping_locked(fi, dmap);
> > > >       return 0;
> > > >  }
> > > >
> > > > @@ -3831,6 +3831,58 @@ static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
> > > >       }
> > > >  }
> > > >
> > > > +/* Cleanup dmap entry and add back to free list */
> > > > +static void fuse_dax_do_free_mapping_locked(struct fuse_conn *fc, struct fuse_dax_mapping *dmap)
> > > > +{
> > > > +     pr_debug("fuse: freed memory range start=0x%llx end=0x%llx "
> > > > +             "window_offset=0x%llx length=0x%llx\n", dmap->start,
> > > > +             dmap->end, dmap->window_offset, dmap->length);
> > > > +     spin_lock(&fc->lock);
> > > > +     __dmap_remove_busy_list(fc, dmap);
> > > > +     dmap->inode = NULL;
> > > > +     dmap->start = dmap->end = 0;
> > > > +     __free_dax_mapping(fc, dmap);
> > > > +     spin_unlock(&fc->lock);
> > > > +}
> > > > +
> > > > +/* Remove dax mapping from inode interval tree */
> > > > +static void fuse_dax_do_remove_mapping_locked(struct fuse_inode *fi, struct fuse_dax_mapping *dmap)
> > > > +{
> > > > +     fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
> > > > +     fi->nr_dmaps--;
> > > > +}
> > >
> > > this is just a two line funciton. I think lets open code it and we don't
> > > need a separate function for this.
> > ok.
> >
> > >
> > >
> > > > +
> > > > +/*
> > > > + * Free inode dmap entries whose range falls entirely inside [start, end].
> > > > + * Called with inode->i_rwsem and fuse_inode->i_mmap_sem held.
> > > > + *
> > > > + * No need to send FUSE_REMOVEMAPPING to userspace because the userspace mappings
> > > > + * will be overridden next time dmap is used -- same logic is applied in
> > > > + * fuse_dax_reclaim_first_mapping().
> > >
> > > This is true that sending FUSE_REMOVEMAPPING is not strictly needed. But,
> > > thinking more about it, what if range does not get used soon. Then it
> > > will keep resources unnecessarily busy on host? (fd, file, inode, dentry,
> > > vma etc).
> > >
> > > I think it probably is a good idea to send FUSE_REMOVEMAPPING to daemon
> > > when range is being freed.
> > We are under inode->i_rwsem and i_mmap_sem here. It can be very
> > expensive if we wait for userspace holding locks. How about pushing it
> > to a work queue? Still we at least need to grab the dmap lock but it
> > seems less expensive and doesn't block truncate.
>
> How about freeing multiple ranges in single removemapping call. I think
> that's allowed. We can look into making it async also at some point of
> time, but right now it probably is best to keep code as simple as
> possible. Do typical workloads do truncate at high frequencey?
>
Good point! I'll change to do it. Thanks!

Cheers,
Tao
-- 
bergwolf@hyper.sh

