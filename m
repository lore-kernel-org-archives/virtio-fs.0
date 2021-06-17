Date: Thu, 17 Jun 2021 09:30:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210617133052.GA1142820@redhat.com>
References: <20210614174454.903555-1-vgoyal@redhat.com>
	<YMsgaPS90iKIqSvi@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMsgaPS90iKIqSvi@infradead.org>
Subject: Re: [Virtio-fs] [PATCH v2 0/2] Add support to boot virtiofs and
	9pfs as rootfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, miklos@szeredi.hu, richard.weinberger@gmail.com, asmadeus@codewreck.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net

On Thu, Jun 17, 2021 at 11:14:00AM +0100, Christoph Hellwig wrote:
> Why not something like the version below that should work for all nodev
> file systems?

Hi Christoph,

Thanks for this patch. It definitely looks much better. I had a fear
of breaking something if I were to go through this path of using
FS_REQUIRES_DEV.

This patch works for me with "root=myfs rootfstype=virtiofs rw". Have
few thoughts inline.
> 
> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index 74aede860de7..3c5676603fef 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -530,6 +530,39 @@ static int __init mount_cifs_root(void)
>  }
>  #endif
>  
> +static int __init mount_nodev_root(void)
> +{
> +	struct file_system_type *fs = get_fs_type(root_fs_names);

get_fs_type() assumes root_fs_names is not null. So if I pass
"root=myfs rw", it crashes with null pointer dereference.


> +	char *fs_names, *p;
> +	int err = -ENODEV;
> +
> +	if (!fs)
> +		goto out;
> +	if (fs->fs_flags & FS_REQUIRES_DEV)
> +		goto out_put_filesystem;
> +
> +	fs_names = (void *)__get_free_page(GFP_KERNEL);
> +	if (!fs_names)
> +		goto out_put_filesystem;
> +	get_fs_names(fs_names);

I am wondering what use case we are trying to address by calling
get_fs_names() and trying do_mount_root() on all filesystems
returned by get_fs_names(). I am assuming following use cases
you have in mind.

A. User passes a single filesystem in rootfstype.
   
   root=myfs rootfstype=virtiofs rw

B. User passes multiple filesystems in rootfstype and kernel tries all
   of them one after the other

   root=myfs, rootfstype=9p,virtiofs rw

C. User does not pass a filesystem type at all. And kernel will get a
   list of in-built filesystems and will try these one after the other.

   root=myfs rw

If that's the thought, will it make sense to call get_fs_names() first
and then inside the for loop call get_fs_type() and try mounting
only if FS_REQUIRES_DEV is not set, otherwise skip and move onto th
next filesystem in the list (fs_names).

Thanks
Vivek

> +
> +	for (p = fs_names; *p; p += strlen(p) + 1) {
> +		err = do_mount_root(root_device_name, p, root_mountflags,
> +					root_mount_data);
> +		if (!err)
> +			break;
> +		if (err != -EACCES && err != -EINVAL)
> +			panic("VFS: Unable to mount root \"%s\" (%s), err=%d\n",
> +				      root_device_name, p, err);
> +	}
> +
> +	free_page((unsigned long)fs_names);
> +out_put_filesystem:
> +	put_filesystem(fs);
> +out:
> +	return err;
> +}
> +
>  void __init mount_root(void)
>  {
>  #ifdef CONFIG_ROOT_NFS
> @@ -546,6 +579,8 @@ void __init mount_root(void)
>  		return;
>  	}
>  #endif
> +	if (ROOT_DEV == 0 && mount_nodev_root() == 0)
> +		return;
>  #ifdef CONFIG_BLOCK
>  	{
>  		int err = create_dev("/dev/root", ROOT_DEV);
> 

