Date: Tue, 6 Aug 2019 17:09:03 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190806160903.GI3066@work-vm>
References: <5D48EEAB.7000100@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D48EEAB.7000100@huawei.com>
Subject: Re: [Virtio-fs] [PATCH RFC] virtiofs: improve io bandwidth by
 replacing pwrite with pwritev
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com

* piaojun (piaojun@huawei.com) wrote:
> >From my test, write bandwidth will be improved greatly by replacing
> pwrite with pwritev, and the test result as below:
> 
> ---
> pwrite:
> # fio -direct=1 -time_based -iodepth=64 -rw=randwrite -ioengine=libaio -bs=1M -size=1G -numjob=16 -runtime=30 -group_reporting -name=file -filename=/mnt/virtiofs/file
> file: (g=0): rw=randwrite, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=64
> ...
> fio-2.13
> Starting 16 processes
> Jobs: 16 (f=16): [w(16)] [100.0% done] [0KB/886.0MB/0KB /s] [0/886/0 iops] [eta 00m:00s]
> file: (groupid=0, jobs=16): err= 0: pid=5799: Tue Aug 6 18:48:26 2019
> write: io=26881MB, bw=916988KB/s, iops=895, runt= 30018msec
> 
> pwritev:
> # fio -direct=1 -time_based -iodepth=64 -rw=randwrite -ioengine=libaio -bs=1M -size=1G -numjob=16 -runtime=30 -group_reporting -name=file -filename=/mnt/virtiofs/file
> file: (g=0): rw=randwrite, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=64
> ...
> fio-2.13
> Starting 16 processes
> Jobs: 16 (f=16): [w(16)] [100.0% done] [0KB/1793MB/0KB /s] [0/1793/0 iops] [eta 00m:00s]
> file: (groupid=0, jobs=16): err= 0: pid=6328: Tue Aug 6 18:22:17 2019
> write: io=52775MB, bw=1758.7MB/s, iops=1758, runt= 30009msec

OK, nice improvements.

> ---
> 
> This patch introduces writev and pwritev and clean up *fuse_buf_copy*
> and its related code. I wonder if I'd better split it into two patches
> or other modification. I'm very glad for your suggestions.

It does need splitting; but I think there are some problems; it seems to
ignore most of the flags; in particular FUSE_BUF_PHYS_ADDR - I added
that to handle cases where it was a write() call from one DAX mapped
file to another.  I suspect some of the other flags are relevant as
well.

Dave


> Thanks,
> Jun
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> ---
>  contrib/virtiofsd/buffer.c         | 310 ++++---------------------------------
>  contrib/virtiofsd/fuse_common.h    |  15 +-
>  contrib/virtiofsd/passthrough_ll.c |   2 +-
>  contrib/virtiofsd/seccomp.c        |   2 +
>  4 files changed, 37 insertions(+), 292 deletions(-)
> 
> diff --git a/contrib/virtiofsd/buffer.c b/contrib/virtiofsd/buffer.c
> index 655be137..78f8d3e 100644
> --- a/contrib/virtiofsd/buffer.c
> +++ b/contrib/virtiofsd/buffer.c
> @@ -15,6 +15,7 @@
>  #include <unistd.h>
>  #include <errno.h>
>  #include <assert.h>
> +#include <stdlib.h>
> 
>  size_t fuse_buf_size(const struct fuse_bufvec *bufv)
>  {
> @@ -31,299 +32,40 @@ size_t fuse_buf_size(const struct fuse_bufvec *bufv)
>  	return size;
>  }
> 
> -static size_t min_size(size_t s1, size_t s2)
> +ssize_t fuse_buf_writev(fuse_req_t req,
> +		struct fuse_bufvec *out_buf,
> +		struct fuse_bufvec *in_buf,
> +		enum fuse_buf_copy_flags flags)
>  {
> -	return s1 < s2 ? s1 : s2;
> -}
> -
> -static ssize_t fuse_buf_write(const struct fuse_buf *dst, size_t dst_off,
> -			      const struct fuse_buf *src, size_t src_off,
> -			      size_t len)
> -{
> -	ssize_t res = 0;
> -	size_t copied = 0;
> -
> -        assert(!(src->flags & FUSE_BUF_PHYS_ADDR));
> -	while (len) {
> -		if (dst->flags & FUSE_BUF_FD_SEEK) {
> -			res = pwrite(dst->fd, src->mem + src_off, len,
> -				     dst->pos + dst_off);
> -		} else {
> -			res = write(dst->fd, src->mem + src_off, len);
> -		}
> -		if (res == -1) {
> -			if (!copied)
> -				return -errno;
> -			break;
> -		}
> -		if (res == 0)
> -			break;
> -
> -		copied += res;
> -		if (!(dst->flags & FUSE_BUF_FD_RETRY))
> -			break;
> -
> -		src_off += res;
> -		dst_off += res;
> -		len -= res;
> -	}
> -
> -	return copied;
> -}
> -
> -static ssize_t fuse_buf_read(const struct fuse_buf *dst, size_t dst_off,
> -			     const struct fuse_buf *src, size_t src_off,
> -			     size_t len)
> -{
> -	ssize_t res = 0;
> -	size_t copied = 0;
> -
> -	while (len) {
> -		if (src->flags & FUSE_BUF_FD_SEEK) {
> -			res = pread(src->fd, dst->mem + dst_off, len,
> -				     src->pos + src_off);
> -		} else {
> -			res = read(src->fd, dst->mem + dst_off, len);
> -		}
> -		if (res == -1) {
> -			if (!copied)
> -				return -errno;
> -			break;
> -		}
> -		if (res == 0)
> -			break;
> -
> -		copied += res;
> -		if (!(src->flags & FUSE_BUF_FD_RETRY))
> -			break;
> -
> -		dst_off += res;
> -		src_off += res;
> -		len -= res;
> -	}
> -
> -	return copied;
> -}
> -
> -static ssize_t fuse_buf_fd_to_fd(const struct fuse_buf *dst, size_t dst_off,
> -				 const struct fuse_buf *src, size_t src_off,
> -				 size_t len)
> -{
> -	char buf[4096];
> -	struct fuse_buf tmp = {
> -		.size = sizeof(buf),
> -		.flags = 0,
> -	};
> -	ssize_t res;
> -	size_t copied = 0;
> -
> -	tmp.mem = buf;
> -
> -	while (len) {
> -		size_t this_len = min_size(tmp.size, len);
> -		size_t read_len;
> -
> -		res = fuse_buf_read(&tmp, 0, src, src_off, this_len);
> -		if (res < 0) {
> -			if (!copied)
> -				return res;
> -			break;
> -		}
> -		if (res == 0)
> -			break;
> -
> -		read_len = res;
> -		res = fuse_buf_write(dst, dst_off, &tmp, 0, read_len);
> -		if (res < 0) {
> -			if (!copied)
> -				return res;
> -			break;
> -		}
> -		if (res == 0)
> -			break;
> -
> -		copied += res;
> -
> -		if (res < this_len)
> -			break;
> -
> -		dst_off += res;
> -		src_off += res;
> -		len -= res;
> -	}
> -
> -	return copied;
> -}
> -
> -#ifdef HAVE_SPLICE
> -static ssize_t fuse_buf_splice(const struct fuse_buf *dst, size_t dst_off,
> -			       const struct fuse_buf *src, size_t src_off,
> -			       size_t len, enum fuse_buf_copy_flags flags)
> -{
> -	int splice_flags = 0;
> -	off_t *srcpos = NULL;
> -	off_t *dstpos = NULL;
> -	off_t srcpos_val;
> -	off_t dstpos_val;
> -	ssize_t res;
> -	size_t copied = 0;
> -
> -	if (flags & FUSE_BUF_SPLICE_MOVE)
> -		splice_flags |= SPLICE_F_MOVE;
> -	if (flags & FUSE_BUF_SPLICE_NONBLOCK)
> -		splice_flags |= SPLICE_F_NONBLOCK;
> -
> -	if (src->flags & FUSE_BUF_FD_SEEK) {
> -		srcpos_val = src->pos + src_off;
> -		srcpos = &srcpos_val;
> -	}
> -	if (dst->flags & FUSE_BUF_FD_SEEK) {
> -		dstpos_val = dst->pos + dst_off;
> -		dstpos = &dstpos_val;
> -	}
> -
> -	while (len) {
> -		res = splice(src->fd, srcpos, dst->fd, dstpos, len,
> -			     splice_flags);
> -		if (res == -1) {
> -			if (copied)
> -				break;
> -
> -			if (errno != EINVAL || (flags & FUSE_BUF_FORCE_SPLICE))
> -				return -errno;
> -
> -			/* Maybe splice is not supported for this combination */
> -			return fuse_buf_fd_to_fd(dst, dst_off, src, src_off,
> -						 len);
> -		}
> -		if (res == 0)
> -			break;
> -
> -		copied += res;
> -		if (!(src->flags & FUSE_BUF_FD_RETRY) &&
> -		    !(dst->flags & FUSE_BUF_FD_RETRY)) {
> -			break;
> -		}
> -
> -		len -= res;
> -	}
> -
> -	return copied;
> -}
> -#else
> -static ssize_t fuse_buf_splice(const struct fuse_buf *dst, size_t dst_off,
> -			       const struct fuse_buf *src, size_t src_off,
> -			       size_t len, enum fuse_buf_copy_flags flags)
> -{
> -	(void) flags;
> -
> -	return fuse_buf_fd_to_fd(dst, dst_off, src, src_off, len);
> -}
> -#endif
> -
> -
> -static ssize_t fuse_buf_copy_one(fuse_req_t req,
> -                                 const struct fuse_buf *dst, size_t dst_off,
> -				 const struct fuse_buf *src, size_t src_off,
> -				 size_t len, enum fuse_buf_copy_flags flags)
> -{
> -	int src_is_fd = src->flags & FUSE_BUF_IS_FD;
> -	int dst_is_fd = dst->flags & FUSE_BUF_IS_FD;
> -	int src_is_phys = src->flags & FUSE_BUF_PHYS_ADDR;
> -	int dst_is_phys = src->flags & FUSE_BUF_PHYS_ADDR;
> -
> -	if (src_is_phys && !src_is_fd && dst_is_fd) {
> -		return fuse_virtio_write(req, dst, dst_off, src, src_off, len);
> -	}
> -
> -	assert(!src_is_phys && !dst_is_phys);
> -	if (!src_is_fd && !dst_is_fd) {
> -		void *dstmem = dst->mem + dst_off;
> -		void *srcmem = src->mem + src_off;
> +	ssize_t res, i, buf_index, iovcnt;
> +	struct iovec * iov;
> +	int fd = out_buf->buf[0].fd;
> +	off_t pos = out_buf->buf[0].pos;
> 
> -		if (dstmem != srcmem) {
> -			if (dstmem + len <= srcmem || srcmem + len <= dstmem)
> -				memcpy(dstmem, srcmem, len);
> -			else
> -				memmove(dstmem, srcmem, len);
> -		}
> -
> -		return len;
> -	} else if (!src_is_fd) {
> -		return fuse_buf_write(dst, dst_off, src, src_off, len);
> -	} else if (!dst_is_fd) {
> -		return fuse_buf_read(dst, dst_off, src, src_off, len);
> -	} else if (flags & FUSE_BUF_NO_SPLICE) {
> -		return fuse_buf_fd_to_fd(dst, dst_off, src, src_off, len);
> -	} else {
> -		return fuse_buf_splice(dst, dst_off, src, src_off, len, flags);
> -	}
> -}
> -
> -static const struct fuse_buf *fuse_bufvec_current(struct fuse_bufvec *bufv)
> -{
> -	if (bufv->idx < bufv->count)
> -		return &bufv->buf[bufv->idx];
> +	if (in_buf->count > 2)
> +		iovcnt = in_buf->count - 1;
>  	else
> -		return NULL;
> -}
> +		iovcnt = 1;
> 
> -static int fuse_bufvec_advance(struct fuse_bufvec *bufv, size_t len)
> -{
> -	const struct fuse_buf *buf = fuse_bufvec_current(bufv);
> +	iov = malloc(iovcnt * sizeof(struct iovec));
> +	if (!iov)
> +		return -ENOMEM;
> 
> -	bufv->off += len;
> -	assert(bufv->off <= buf->size);
> -	if (bufv->off == buf->size) {
> -		assert(bufv->idx < bufv->count);
> -		bufv->idx++;
> -		if (bufv->idx == bufv->count)
> -			return 0;
> -		bufv->off = 0;
> +	for (i = 0, buf_index = 1; i < iovcnt; i++, buf_index++) {
> +		iov[i].iov_base = in_buf->buf[buf_index].mem;
> +		iov[i].iov_len = in_buf->buf[buf_index].size;
>  	}
> -	return 1;
> -}
> 
> -ssize_t fuse_buf_copy(fuse_req_t req, struct fuse_bufvec *dstv, struct fuse_bufvec *srcv,
> -		      enum fuse_buf_copy_flags flags)
> -{
> -	size_t copied = 0;
> -
> -	if (dstv == srcv)
> -		return fuse_buf_size(dstv);
> -
> -	for (;;) {
> -		const struct fuse_buf *src = fuse_bufvec_current(srcv);
> -		const struct fuse_buf *dst = fuse_bufvec_current(dstv);
> -		size_t src_len;
> -		size_t dst_len;
> -		size_t len;
> -		ssize_t res;
> -
> -		if (src == NULL || dst == NULL)
> -			break;
> -
> -		src_len = src->size - srcv->off;
> -		dst_len = dst->size - dstv->off;
> -		len = min_size(src_len, dst_len);
> -
> -		res = fuse_buf_copy_one(req, dst, dstv->off, src, srcv->off, len, flags);
> -		if (res < 0) {
> -			if (!copied)
> -				return res;
> -			break;
> -		}
> -		copied += res;
> -
> -		if (!fuse_bufvec_advance(srcv, res) ||
> -		    !fuse_bufvec_advance(dstv, res))
> -			break;
> +	if (flags & FUSE_BUF_FD_SEEK)
> +		res = pwritev(fd, iov, iovcnt, pos);
> +	else
> +		res = writev(fd, iov, iovcnt);
> 
> -		if (res < len)
> -			break;
> -	}
> +	if (res == -1 || res == 0)
> +		res = -errno;
> 
> -	return copied;
> +	free(iov);
> +	return res;
>  }
> 
>  void *fuse_mbuf_iter_advance(struct fuse_mbuf_iter *iter, size_t len)
> diff --git a/contrib/virtiofsd/fuse_common.h b/contrib/virtiofsd/fuse_common.h
> index 001e6d6..c715e52 100644
> --- a/contrib/virtiofsd/fuse_common.h
> +++ b/contrib/virtiofsd/fuse_common.h
> @@ -717,17 +717,18 @@ struct fuse_bufvec {
>  size_t fuse_buf_size(const struct fuse_bufvec *bufv);
> 
>  /**
> - * Copy data from one buffer vector to another
> + * Write data from one buffer vector to another
>   *
>   * @param req The request this copy is part of
> - * @param dst destination buffer vector
> - * @param src source buffer vector
> + * @param out_buf destination buffer vector
> + * @param in_buf source buffer vector
>   * @param flags flags controlling the copy
> - * @return actual number of bytes copied or -errno on error
> + * @return actual number of bytes written or -errno on error
>   */
> -ssize_t fuse_buf_copy(fuse_req_t req,
> -                      struct fuse_bufvec *dst, struct fuse_bufvec *src,
> -		      enum fuse_buf_copy_flags flags);
> +ssize_t fuse_buf_writev(fuse_req_t req,
> +			struct fuse_bufvec *out_buf,
> +			struct fuse_bufvec *in_buf,
> +			enum fuse_buf_copy_flags flags);
> 
>  /**
>   * Memory buffer iterator
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index cc9c175..3082683 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -2023,7 +2023,7 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
>  		fuse_debug("lo_write_buf(ino=%" PRIu64 ", size=%zd, off=%lu)\n",
>  			   ino, out_buf.buf[0].size, (unsigned long) off);
> 
> -	res = fuse_buf_copy(req, &out_buf, in_buf, 0);
> +	res = fuse_buf_writev(req, &out_buf, in_buf, out_buf.buf[0].flags);
>  	if(res < 0) {
>  		fuse_reply_err(req, -res);
>  	} else {
> diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
> index 5f1c873..4bba30b 100644
> --- a/contrib/virtiofsd/seccomp.c
> +++ b/contrib/virtiofsd/seccomp.c
> @@ -60,6 +60,7 @@ static const int syscall_whitelist[] = {
>  	SCMP_SYS(ppoll),
>  	SCMP_SYS(prctl), /* TODO restrict to just PR_SET_NAME? */
>  	SCMP_SYS(preadv),
> +	SCMP_SYS(pwritev),
>  	SCMP_SYS(pwrite64),
>  	SCMP_SYS(read),
>  	SCMP_SYS(readlinkat),
> @@ -78,6 +79,7 @@ static const int syscall_whitelist[] = {
>  	SCMP_SYS(unlinkat),
>  	SCMP_SYS(utimensat),
>  	SCMP_SYS(write),
> +	SCMP_SYS(writev),
>  };
> 
>  /* Syscalls used when --syslog is enabled */
> -- 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

