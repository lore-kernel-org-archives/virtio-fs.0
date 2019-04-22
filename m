Date: Mon, 22 Apr 2019 14:14:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190422181436.GC7852@redhat.com>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
	<20190416180322.65113-7-bo.liu@linux.alibaba.com>
	<20190416193837.GE2222@redhat.com>
	<CAOssrKcnCzt9+om9=5pFqGBAeNds7U3FWpXWHLp6KNgHmVZ=Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKcnCzt9+om9=5pFqGBAeNds7U3FWpXWHLp6KNgHmVZ=Pg@mail.gmail.com>
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
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs@redhat.com

On Wed, Apr 17, 2019 at 10:25:53AM +0200, Miklos Szeredi wrote:
> On Tue, Apr 16, 2019 at 9:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Wed, Apr 17, 2019 at 02:03:19AM +0800, Liu Bo wrote:
> > > In case of dax+cache=none, mmap uses dax style prior to directIO style,
> > > while read/write don't, but it seems that there is no reason not to do so.
> > >
> > > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > > Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> >
> > This is interesting. I was thinking about it today itself. I noticed
> > that ext4 and xfs also check for DAX inode first and use dax path
> > if dax is enabled.
> >
> > cache=never sets FOPEN_DIRECT_IO (even if application never asked for
> > direct IO). If dax is enabled, for data its equivalent to doing direct
> > IO. And for mmap() we are already checking for DAX first. So it makes
> > sense to do same thing for read/write path as well.
> >
> > CCing Miklos as well. He might have some thougts on this. I am curios
> > that initially whey did he make this change only for mmap() and not
> > for read/write paths.
> 
> AFAIR the main reason was that we had performance issues with size
> extending writes with dax.

Hi Miklos,

How about falling back to sending fuse WRITE message to fuse daemon
in case of extending writes (and not use DAX). That will solve the issue
of write and i_size modification not being atomic also will improve
performance of file extending writes. 

I wrote following hack patch and this seems to work.

Thanks
Vivek


Subject: fuse, dax: Do not use dax for file extnding writes

Right not we use dax for file extending writes and use fallocate() first
to make sure file on host is extended so that later write through mmap()
will not result in SIGBUS.

This approach has two problems. First of all write and i_size are not atomic.
And that means if guest crashes after fallocate(), it can expose trailing
zeros in file and give the apperance as if user data was lost. Secondly,
calling falloate() for every extending write is very slow.  Apart from
communication overhead, fallocate() on host is much slower than calling
write on host.

So do not use dax for file extending writes, instead just send WRITE message
to daemon (like we do for direct I/O path) and this should solve botht the
above problems.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c |   67 ++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 50 insertions(+), 17 deletions(-)

Index: rhvgoyal-linux-fuse/fs/fuse/file.c
===================================================================
--- rhvgoyal-linux-fuse.orig/fs/fuse/file.c	2019-04-18 16:08:19.048407845 -0400
+++ rhvgoyal-linux-fuse/fs/fuse/file.c	2019-04-22 13:22:20.939679793 -0400
@@ -1809,6 +1809,13 @@ static int fuse_iomap_begin(struct inode
 	pr_debug("fuse_iomap_begin() called. pos=0x%llx length=0x%llx\n",
 			pos, length);
 
+	/*
+	 * Writes beyond end of file are not handled using dax path. Instead
+	 * a fuse write message is sent to daemon
+	 */
+	if (flags & IOMAP_WRITE && pos >= i_size_read(inode))
+		return -EIO;
+
 	iomap->offset = pos;
 	iomap->flags = 0;
 	iomap->bdev = NULL;
@@ -1929,11 +1936,34 @@ static ssize_t fuse_dax_read_iter(struct
 	return ret;
 }
 
-static ssize_t fuse_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
+static bool file_extending_write(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	return (iov_iter_rw(from) == WRITE &&
+	    	((iocb->ki_pos) >= i_size_read(inode)));
+}
+
+static ssize_t fuse_dax_direct_write(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
+	struct fuse_io_priv io = FUSE_IO_PRIV_SYNC(iocb);
 	ssize_t ret;
 
+	ret = fuse_direct_io(&io, from, &iocb->ki_pos, FUSE_DIO_WRITE);
+	if (ret < 0)
+		return ret;
+
+	fuse_invalidate_attr(inode);
+	fuse_write_update_size(inode, iocb->ki_pos);
+	return ret;
+}
+
+static ssize_t fuse_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	ssize_t ret, count;
+
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		if (!inode_trylock(inode))
 			return -EAGAIN;
@@ -1950,26 +1980,29 @@ static ssize_t fuse_dax_write_iter(struc
 		goto out;
 	/* TODO file_update_time() but we don't want metadata I/O */
 
-	/* TODO handle growing the file */
-	/* Grow file here if need be. iomap_begin() does not have access
-	 * to file pointer
-	 */
-	if (iov_iter_rw(from) == WRITE &&
-	    ((iocb->ki_pos + iov_iter_count(from)) > i_size_read(inode))) {
-		ret = __fuse_file_fallocate(iocb->ki_filp, 0, iocb->ki_pos,
-						iov_iter_count(from));
-		if (ret < 0) {
-			printk("fallocate(offset=0x%llx length=0x%zx)"
-			" failed. err=%zd\n", iocb->ki_pos,
-			iov_iter_count(from), ret);
-			goto out;
-		}
-		pr_debug("fallocate(offset=0x%llx length=0x%zx)"
-		" succeed. ret=%zd\n", iocb->ki_pos, iov_iter_count(from), ret);
+	/* Do not use dax for file extending writes as its an mmap and
+	 * trying to write beyong end of existing page will generate
+	 * SIGBUS.
+	 */
+	if (file_extending_write(iocb, from)) {
+		ret = fuse_dax_direct_write(iocb, from);
+		goto out;
 	}
 
 	ret = dax_iomap_rw(iocb, from, &fuse_iomap_ops);
+	if (ret < 0)
+		goto out;
 
+	/*
+	 * If part of the write was file extending, fuse dax path will not
+	 * take care of that. Do direct write instead.
+	 */
+	if (iov_iter_count(from) && file_extending_write(iocb, from)) {
+		count = fuse_dax_direct_write(iocb, from);
+		if (count < 0)
+			goto out;
+		ret += count;
+	}
 out:
 	inode_unlock(inode);
 

