Date: Wed, 21 Aug 2019 14:17:00 +0800
From: Eryu Guan <eguan@linux.alibaba.com>
Message-ID: <20190821061700.GR52397@e18g06458.et15sqa>
References: <1566367838-47809-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566367838-47809-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofs: fix return value of
 iomap_begin_upgrade_mapping
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

On Wed, Aug 21, 2019 at 02:10:38PM +0800, Liu Bo wrote:
> Set ret = 0 if everything runs fine.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

FYI, this fixes generic/344 failure.

> ---
>  fs/fuse/file.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index eb7543a..d3c5e45 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1985,6 +1985,7 @@ static int iomap_begin_upgrade_mapping(struct inode *inode, loff_t pos,
>  
>  out_fill_iomap:
>  	fuse_fill_iomap(inode, pos, length, iomap, dmap, flags);
> +	ret = 0;

I'd prefer setting ret in the if (dmap->writable) case, which seems more
clear to me. i.e.

	if (dmap->writable) {
		ret = 0;
		goto out_fill_iomap;
	}

Anyway,

Reviewed-by: Eryu Guan <eguan@linux.alibaba.com>

Thanks!
Eryu

>  out_err:
>  	up_write(&fi->i_dmap_sem);
>  	return ret;
> -- 
> 1.8.3.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

