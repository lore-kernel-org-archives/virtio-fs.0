Date: Wed, 31 Jul 2019 11:34:08 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190731103408.GB3203@work-vm>
References: <20190726082131.6739-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726082131.6739-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] init/do_mounts.c: add virtio_fs root fs
 support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> It is useful to mount the root file system via virtio_fs.  During
> testing a monolithic kernel is more convenient than an initramfs but
> we'll need to teach the kernel how to boot directly from virtio_fs.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  init/do_mounts.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index f8c230c77035..b2d9650488d7 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -553,6 +553,16 @@ void __init mount_root(void)
>  			change_floppy("root floppy");
>  	}
>  #endif
> +#ifdef CONFIG_VIRTIO_FS
> +	if (root_fs_names && !strcmp(root_fs_names, "virtio_fs")) {
> +		if (!do_mount_root(root_device_name, "virtio_fs",
> +				   root_mountflags, root_mount_data))
> +			return;
> +
> +		panic("VFS: Unable to mount root fs \"%s\" from virtio_fs",
> +		      root_device_name);
> +	}
> +#endif

I wonder if it's possible to make this more generic; I see that
filesystems have a flag, FS_REQUIRES_DEV - should this
work for most filesystems that don't have that set?

Dave

>  #ifdef CONFIG_BLOCK
>  	{
>  		int err = create_dev("/dev/root", ROOT_DEV);
> -- 
> 2.21.0
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

