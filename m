Date: Wed, 19 Jun 2019 16:22:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190619202200.GA7406@redhat.com>
References: <a755e6bed4962076909d037399e82fb8207c5581.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a755e6bed4962076909d037399e82fb8207c5581.camel@intel.com>
Subject: Re: [Virtio-fs] [PATCH] virtio-fs: Allow shared memory region to be
 empty
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

On Tue, Jun 18, 2019 at 08:25:07PM +0000, Boeuf, Sebastien wrote:
> >From 908b1c5660b919266379d68940815a5dea9ca6f4 Mon Sep 17 00:00:00 2001
> From: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Date: Mon, 17 Jun 2019 11:11:10 -0700
> Subject: [PATCH] virtio-fs: Allow shared memory region to be empty
> 
> In case the device declares an empty cache region to the driver, the
> whole DAX setup should be simply skipped and the shared memory region
> should never be used.
> 
> Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>

Hi Sebastien,

Thanks for the patch. I am currently trying to integrate shared version
patches and with those patches we probably can't reutrun immediately.
We still will have to probe for shared version table. (I think it
can be made to work even without dax).

So I will keep this in mind and integrate this patch in some form once
I am done taking care of shared version patches.

Vivek

> ---
>  fs/fuse/virtio_fs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 3f3c018571ee..88531324fe40 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -540,8 +540,8 @@ static int virtio_fs_setup_dax(struct virtio_device
> *vdev, struct virtio_fs *fs)
>  					   &cache_reg,
>  					   (u8)VIRTIO_FS_SHMCAP_ID_CACH
> E);
>  	if (!have_cache) {
> -		dev_err(&vdev->dev, "%s: No cache capability\n",
> __func__);
> -		return -ENXIO;
> +		dev_notice(&vdev->dev, "%s: No cache capability\n",
> __func__);
> +		return 0;
>  	} else {
>  		dev_notice(&vdev->dev, "Cache len: 0x%llx @ 0x%llx\n",
>  			   cache_reg.len, cache_reg.addr);
> -- 
> 2.17.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

