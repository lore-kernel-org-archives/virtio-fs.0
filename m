DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=hyper-sh.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=to2+/Y/uULZMeJYfSkfMQs2qlMvvOKatxjW94DccHWs=;
	b=eR5O+TC3cLR3A8ISm+8UmWE/faxxTdbBM/FqRvzWqa0UMeUd/3YP7tEniCtMfb1jal
	8ePbWzbj8w1twX4/8vU1YEgMs7vCDPHs9nYPUvQdZXgkQwKYhVrduJAoglf1FqNzz8jO
	rYU8aSDOhWur/Tcs+K1Z/Us3So9nT5L8lUyp5SttBkD4W5oghYoGSRlD3eI/+WHqbVth
	Ocw6GcVE68eLojaO+RYEkSyWBVk3UoHUObUxsUqhsfD3k2xsOFJ/lkSypXLuZRu/+4Te
	YV7m9ZJG9xstu5KLOFXj42+ERkYBKkObrH/EwgRksDe4YGIf1gMgoy19Izrncy9ERB6y
	KBVQ==
MIME-Version: 1.0
References: <20190603024651.47305-1-tao.peng@linux.alibaba.com>
	<20190604212831.GC18863@redhat.com>
In-Reply-To: <20190604212831.GC18863@redhat.com>
From: Peng Tao <bergwolf@hyper.sh>
Date: Wed, 5 Jun 2019 10:34:45 +0800
Message-ID: <CACGKRzX0sHRPAwbKjjSC8zd=OK1ZSRnzjoug0Z7ghFW9FbxrWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH-v2] virtiofs: FUSE_REMOVEMAPPING remove
 multiple entries in one call
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

On Wed, Jun 5, 2019 at 5:28 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Mon, Jun 03, 2019 at 10:46:51AM +0800, Peng Tao wrote:
>
> [..]
> > +static void __fuse_dax_free_mappings_range(struct fuse_conn *fc,
> > +                             struct inode *inode, loff_t start, loff_t end)
> > +{
> > +     struct fuse_inode *fi = get_fuse_inode(inode);
> > +     struct fuse_dax_mapping *dmap, *n;
> > +     int err, num = 0;
> > +     LIST_HEAD(to_remove);
> > +
> > +     pr_debug("fuse: __fuse_dax_free_mappings_range "
> > +              "start=0x%llx, end=0x%llx\n", start, end);
> > +     /* interval tree search matches intersecting entries.
> > +      * Adjust the range to avoid dropping partial valid entries. */
> > +     start = ALIGN(start, FUSE_DAX_MEM_RANGE_SZ);
> > +     end = ALIGN_DOWN(end, FUSE_DAX_MEM_RANGE_SZ);
> > +
> > +     while ((dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, start, end))) {
> > +             fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
> > +             num++;
> > +             list_add(&dmap->list, &to_remove);
>
> Hmm..... So normally dmap->list is used for putting an element in free list.
> Given this element is on busy list, it must not be on free list hence you
> are reusing dmap->list to put it temporarily on to_remove list.
Yes, when a dmap is in use, it must not be on the free list and thus
dmap->list is not used by anyone, so we can reuse it to link to the
to_remove list.

>
>
> > +     }
> > +
> > +     /* Nothing to remove */
> > +     if (list_empty(&to_remove))
> > +             return;
> > +
> > +     WARN_ON(fi->nr_dmaps < num);
> > +     fi->nr_dmaps -= num;
> > +     /*
> > +      * During umount/shutdown, fuse connection is dropped first
> > +      * and later evict_inode() is called later. That means any
> > +      * removemapping messages are going to fail. Send messages
> > +      * only if connection is up. Otherwise fuse daemon is
> > +      * responsible for cleaning up any leftover references and
> > +      * mappings.
> > +      */
> > +     if (fc->connected) {
> > +             err = fuse_do_removemappings(inode, num, &to_remove);
> > +             if (err) {
> > +                     pr_warn("Failed to removemappings. start=0x%llx"
> > +                             " end=0x%llx\n", start, end);
> > +             }
> > +     }
> > +     spin_lock(&fc->lock);
> > +     list_for_each_entry_safe(dmap, n, &to_remove, list) {
> > +             fuse_dax_do_free_mapping_locked(fc, dmap);
>
> What removes dmap from to_remove list. I think it gets added to free
> list and that overrides it? So an element is already part of to_remove
> list and then we are calling list_add_tail(&dmap->list, &fc->free_ranges)
> on it without removing it. That sounds wrong.
Good catch! I need list_del() here to keep to_remove list sane. Will fix it.

Thanks,
Tao
-- 
Into something rich and strange.

