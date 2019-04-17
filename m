MIME-Version: 1.0
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
	<20190416180322.65113-7-bo.liu@linux.alibaba.com>
	<20190416193837.GE2222@redhat.com>
In-Reply-To: <20190416193837.GE2222@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Wed, 17 Apr 2019 10:25:53 +0200
Message-ID: <CAOssrKcnCzt9+om9=5pFqGBAeNds7U3FWpXWHLp6KNgHmVZ=Pg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 6/9] virtio-fs: let dax style override
 directIO style when dax+cache=none
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com

On Tue, Apr 16, 2019 at 9:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Apr 17, 2019 at 02:03:19AM +0800, Liu Bo wrote:
> > In case of dax+cache=none, mmap uses dax style prior to directIO style,
> > while read/write don't, but it seems that there is no reason not to do so.
> >
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>
> This is interesting. I was thinking about it today itself. I noticed
> that ext4 and xfs also check for DAX inode first and use dax path
> if dax is enabled.
>
> cache=never sets FOPEN_DIRECT_IO (even if application never asked for
> direct IO). If dax is enabled, for data its equivalent to doing direct
> IO. And for mmap() we are already checking for DAX first. So it makes
> sense to do same thing for read/write path as well.
>
> CCing Miklos as well. He might have some thougts on this. I am curios
> that initially whey did he make this change only for mmap() and not
> for read/write paths.

AFAIR the main reason was that we had performance issues with size
extending writes with dax.

There is also the question of mtime updates and atime updates, which
are handled properly with FOPEN_DIRECT_IO, but not with DAX I/O.

If we solve those issues then I think it makes sense to switch
read/write to using DAX.

Does that answer your question?

Thanks,
Miklos

>
> Thanks
> Vivek
>
> > ---
> >  fs/fuse/file.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index c6090f5..620326e 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -1158,12 +1158,12 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
> >       struct inode *inode = file->f_mapping->host;
> >       struct fuse_conn *fc = get_fuse_conn(inode);
> >
> > -     if (ff->open_flags & FOPEN_DIRECT_IO)
> > -             return fuse_direct_read_iter(iocb, to);
> > -
> >       if (IS_DAX(inode))
> >               return fuse_dax_read_iter(iocb, to);
> >
> > +     if (ff->open_flags & FOPEN_DIRECT_IO)
> > +             return fuse_direct_read_iter(iocb, to);
> > +
> >       /*
> >        * In auto invalidate mode, always update attributes on read.
> >        * Otherwise, only update if we attempt to read past EOF (to ensure
> > @@ -1426,11 +1426,12 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >       ssize_t err;
> >       loff_t endbyte = 0;
> >
> > -     if (ff->open_flags & FOPEN_DIRECT_IO)
> > -             return fuse_direct_write_iter(iocb, from);
> >       if (IS_DAX(inode))
> >               return fuse_dax_write_iter(iocb, from);
> >
> > +     if (ff->open_flags & FOPEN_DIRECT_IO)
> > +             return fuse_direct_write_iter(iocb, from);
> > +
> >       if (get_fuse_conn(inode)->writeback_cache) {
> >               /* Update size (EOF optimization) and mode (SUID clearing) */
> >               err = fuse_update_attributes(mapping->host, file);
> > --
> > 1.8.3.1
> >
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs

