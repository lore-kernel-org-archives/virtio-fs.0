Date: Thu, 8 Aug 2019 10:10:52 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190808091052.GB2852@work-vm>
References: <20190807211057.GF18557@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807211057.GF18557@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Change FUSE_MAP_ALIGNMENT bit
 position for 5.3 kernel
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

* Vivek Goyal (vgoyal@redhat.com) wrote:
> Due to rebase to 5.3-rc kernel, change bit position of FUSE_MAP_ALIGNMENT.

Thanks,
yes this matches the position I sent upstream last week:
https://lore.kernel.org/linux-fsdevel/20190802171521.21807-4-dgilbert@redhat.com/

I've squashed it into 'virtiofsd: add map_alignment to fuse_kernel.h'

Dave

> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  contrib/virtiofsd/fuse_kernel.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: qemu/contrib/virtiofsd/fuse_kernel.h
> ===================================================================
> --- qemu.orig/contrib/virtiofsd/fuse_kernel.h	2019-08-05 16:32:14.358564755 -0400
> +++ qemu/contrib/virtiofsd/fuse_kernel.h	2019-08-07 16:31:27.882640763 -0400
> @@ -292,7 +292,7 @@ struct fuse_file_lock {
>  #define FUSE_MAX_PAGES		(1 << 22)
>  #define FUSE_CACHE_SYMLINKS	(1 << 23)
>  #define FUSE_NO_OPENDIR_SUPPORT (1 << 24)
> -#define FUSE_MAP_ALIGNMENT      (1 << 25)
> +#define FUSE_MAP_ALIGNMENT      (1 << 26)
>  
>  /**
>   * CUSE INIT request/reply flags
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

