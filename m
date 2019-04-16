Date: Tue, 16 Apr 2019 15:57:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190416195746.GG2222@redhat.com>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
	<20190416180322.65113-9-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416180322.65113-9-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH 8/9] virtio-fs: honor RLIMIT_FSIZE in
 fuse_file_fallocate
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com

On Wed, Apr 17, 2019 at 02:03:21AM +0800, Liu Bo wrote:
> generic/228 reported this failure that fuse fallocate does not honor what
> 'ulimit -f' has set.
> 
> This adds the necessary inode_newsize_ok() check.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

This sounds like a generic fallocate() fixed needed in fuse as well? If
that's the case, it will be better to send it to Miklos directly and cc
fuse mailing list.

Vivek

> ---
>  fs/fuse/file.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 712fd97..6ab23d7 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -3589,6 +3589,13 @@ static long __fuse_file_fallocate(struct file *file, int mode,
>  		fuse_sync_writes(inode);
>  	}
>  
> +	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> +	    offset + length > i_size_read(inode)) {
> +		err = inode_newsize_ok(inode, offset + length);
> +		if (err)
> +			return err;
> +	}
> +
>  	if (!(mode & FALLOC_FL_KEEP_SIZE))
>  		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
>  
> -- 
> 1.8.3.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

