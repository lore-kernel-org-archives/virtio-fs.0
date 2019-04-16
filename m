Date: Tue, 16 Apr 2019 14:09:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190416180908.GB2222@redhat.com>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
	<20190416180322.65113-2-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416180322.65113-2-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH 1/9] virtio-fs: fix multiple tag support
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

On Wed, Apr 17, 2019 at 02:03:14AM +0800, Liu Bo wrote:
> While doing memremap from pci_dev's system bus address to kernel virtual
> address, we assign a wrong value to the %end of pgmap.res, which ends up
> with a wrong resource size in the process of memremap, and that further
> prevent the second virtiofs pci device from being probed successfully.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Thanks. Already included in my internal branch.

Thanks
Vivek

> ---
>  fs/fuse/virtio_fs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index d669512..68fd11b 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -589,7 +589,7 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
>  	pgmap->res = (struct resource){
>  		.name = "virtio-fs dax window",
>  		.start = (phys_addr_t) cache_reg.addr,
> -		.end = (phys_addr_t) cache_reg.addr + cache_reg.len,
> +		.end = (phys_addr_t) cache_reg.addr + cache_reg.len - 1,
>  	};
>  
>  	fs->window_kaddr = devm_memremap_pages(&vdev->dev, pgmap);
> -- 
> 1.8.3.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

