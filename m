Date: Tue, 16 Apr 2019 14:07:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190416180756.GA2222@redhat.com>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
	<20190416180322.65113-10-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416180322.65113-10-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH 9/9] fuse: fix deadlock in
 __fuse_file_fallocate()
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

On Wed, Apr 17, 2019 at 02:03:22AM +0800, Liu Bo wrote:
> From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> 
> This bug is obvious, fix it.
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

Thanks. This one I ran into late last week while testing
fallocate(PUNCH_HOLE) and fixed it already in my internal branch.

Vivek
> ---
>  fs/fuse/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 6ab23d7..0236783 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -3623,7 +3623,7 @@ static long __fuse_file_fallocate(struct file *file, int mode,
>  	if (mode & FALLOC_FL_PUNCH_HOLE) {
>  		down_write(&fi->i_mmap_sem);
>  		truncate_pagecache_range(inode, offset, offset + length - 1);
> -		down_write(&fi->i_mmap_sem);
> +		up_write(&fi->i_mmap_sem);
>  	}
>  	fuse_invalidate_attr(inode);
>  
> -- 
> 1.8.3.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

