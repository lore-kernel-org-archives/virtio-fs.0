DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=2YdUdeUKZfBFzMR1jBM9RNC90FnM3wxYhfPH5nEI0FQ=;
	b=LX9ib2ZyUcSD/ZaFz+8eAUshfQOAn/4woZAxZhLaESc5RNlCL/7SNuGmtjHlB8Ra8a
	LYkHAy0oqhLyoAHQ/kFNQirR9PaGmx5S2gMPptsrRfGHJFRy0XPIcFTJMwD7Ebf4zMkp
	+ICtUsKogy/NDpufwRoIImN521zHSHcy6j20E=
MIME-Version: 1.0
References: <20210520154654.1791183-1-groug@kaod.org>
	<20210520154654.1791183-6-groug@kaod.org>
	<CAOQ4uxh69ii5Yk-DgFAq+TrrvJ6xCv9s8sKLfo3aBCSWjJvp9Q@mail.gmail.com>
	<YRqEPjzHg9IlifBo@redhat.com>
	<YSpUgzG8rM5LeFDy@miu.piliscsaba.redhat.com>
	<YS0O2MlR2G2LJH/0@redhat.com>
In-Reply-To: <YS0O2MlR2G2LJH/0@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 30 Aug 2021 19:36:17 +0200
Message-ID: <CAJfpeguyBU3r+rUa9NvvNjaBwUno9O5PszAoriABStf5Fm3xfg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v4 5/5] virtiofs: propagate sync() to file
	server
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <mreitz@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtualization@lists.linux-foundation.org, Robert Krawitz <rlk@redhat.com>

On Mon, 30 Aug 2021 at 19:01, Vivek Goyal <vgoyal@redhat.com> wrote:

> >  static struct fuse_writepage_args *fuse_find_writeback(struct fuse_inode *fi,
> > @@ -1608,6 +1609,9 @@ static void fuse_writepage_free(struct fuse_writepage_args *wpa)
> >       struct fuse_args_pages *ap = &wpa->ia.ap;
> >       int i;
> >
> > +     if (wpa->bucket && atomic_dec_and_test(&wpa->bucket->num_writepages))
>
> Hi Miklos,
>
> Wondering why this wpa->bucket check is there. Isn't every wpa is associated
> bucket.  So when do we run into situation when wpa->bucket = NULL.

In case fc->sync_fs is false.

> > @@ -1871,6 +1875,19 @@ static struct fuse_writepage_args *fuse_writepage_args_alloc(void)
> >
> >  }
> >
> > +static void fuse_writepage_add_to_bucket(struct fuse_conn *fc,
> > +                                      struct fuse_writepage_args *wpa)
> > +{
> > +     if (!fc->sync_fs)
> > +             return;
> > +
> > +     rcu_read_lock();
> > +     do {
> > +             wpa->bucket = rcu_dereference(fc->curr_bucket);
> > +     } while (unlikely(!atomic_inc_not_zero(&wpa->bucket->num_writepages)));
>
> So this loop is there because fuse_sync_fs() might be replacing
> fc->curr_bucket. And we are fetching this pointer under rcu. So it is
> possible that fuse_fs_sync() dropped its reference and that led to
> ->num_writepages 0 and we don't want to use this bucket.
>
> What if fuse_sync_fs() dropped its reference but still there is another
> wpa in progress and hence ->num_writepages is not zero. We still don't
> want to use this bucket for new wpa, right?

It's an unlikely race in which case the the write will go into the old
bucket, and will be waited for, but that definitely should not be a
problem.

> > @@ -528,6 +542,31 @@ static int fuse_sync_fs(struct super_block *sb, int wait)
> >       if (!fc->sync_fs)
> >               return 0;
> >
> > +     new_bucket = fuse_sync_bucket_alloc();
> > +     spin_lock(&fc->lock);
> > +     bucket = fc->curr_bucket;
> > +     if (atomic_read(&bucket->num_writepages) != 0) {
> > +             /* One more for count completion of old bucket */
> > +             atomic_inc(&new_bucket->num_writepages);
> > +             rcu_assign_pointer(fc->curr_bucket, new_bucket);
> > +             /* Drop initially added active count */
> > +             atomic_dec(&bucket->num_writepages);
> > +             spin_unlock(&fc->lock);
> > +
> > +             wait_event(bucket->waitq, atomic_read(&bucket->num_writepages) == 0);
> > +             /*
> > +              * Drop count on new bucket, possibly resulting in a completion
> > +              * if more than one syncfs is going on
> > +              */
> > +             if (atomic_dec_and_test(&new_bucket->num_writepages))
> > +                     wake_up(&new_bucket->waitq);
> > +             kfree_rcu(bucket, rcu);
> > +     } else {
> > +             spin_unlock(&fc->lock);
> > +             /* Free unused */
> > +             kfree(new_bucket);
> When can we run into the situation when fc->curr_bucket is num_writepages
> == 0. When install a bucket it has count 1. And only time it can go to
> 0 is when we have dropped the initial reference. And initial reference
> can be dropped only after removing bucket from fc->curr_bucket.
>
> IOW, we don't drop initial reference on a bucket if it is in
> fc->curr_bucket. And that mean anything installed fc->curr_bucket should
> not ever have a reference count of 0. What am I missing.

You are correct.  I fixed it by warning on zero count and checking for
count != 1.

I have other fixes as well, will send v2.

Thanks,
Miklos

