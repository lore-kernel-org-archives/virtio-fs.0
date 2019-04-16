Date: Tue, 16 Apr 2019 15:38:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190416193837.GE2222@redhat.com>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
	<20190416180322.65113-7-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416180322.65113-7-bo.liu@linux.alibaba.com>
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
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, Miklos Szeredi <mszeredi@redhat.com>

On Wed, Apr 17, 2019 at 02:03:19AM +0800, Liu Bo wrote:
> In case of dax+cache=none, mmap uses dax style prior to directIO style,
> while read/write don't, but it seems that there is no reason not to do so.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

This is interesting. I was thinking about it today itself. I noticed
that ext4 and xfs also check for DAX inode first and use dax path
if dax is enabled.

cache=never sets FOPEN_DIRECT_IO (even if application never asked for
direct IO). If dax is enabled, for data its equivalent to doing direct
IO. And for mmap() we are already checking for DAX first. So it makes
sense to do same thing for read/write path as well.

CCing Miklos as well. He might have some thougts on this. I am curios
that initially whey did he make this change only for mmap() and not
for read/write paths.

Thanks
Vivek

> ---
>  fs/fuse/file.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index c6090f5..620326e 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1158,12 +1158,12 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  	struct inode *inode = file->f_mapping->host;
>  	struct fuse_conn *fc = get_fuse_conn(inode);
>  
> -	if (ff->open_flags & FOPEN_DIRECT_IO)
> -		return fuse_direct_read_iter(iocb, to);
> -
>  	if (IS_DAX(inode))
>  		return fuse_dax_read_iter(iocb, to);
>  
> +	if (ff->open_flags & FOPEN_DIRECT_IO)
> +		return fuse_direct_read_iter(iocb, to);
> +
>  	/*
>  	 * In auto invalidate mode, always update attributes on read.
>  	 * Otherwise, only update if we attempt to read past EOF (to ensure
> @@ -1426,11 +1426,12 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	ssize_t err;
>  	loff_t endbyte = 0;
>  
> -	if (ff->open_flags & FOPEN_DIRECT_IO)
> -		return fuse_direct_write_iter(iocb, from);
>  	if (IS_DAX(inode))
>  		return fuse_dax_write_iter(iocb, from);
>  
> +	if (ff->open_flags & FOPEN_DIRECT_IO)
> +		return fuse_direct_write_iter(iocb, from);
> +
>  	if (get_fuse_conn(inode)->writeback_cache) {
>  		/* Update size (EOF optimization) and mode (SUID clearing) */
>  		err = fuse_update_attributes(mapping->host, file);
> -- 
> 1.8.3.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

