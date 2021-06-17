Date: Thu, 17 Jun 2021 12:26:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210617162610.GC1142820@redhat.com>
References: <20210617153649.1886693-1-hch@lst.de>
	<20210617153649.1886693-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617153649.1886693-3-hch@lst.de>
Subject: Re: [Virtio-fs] [PATCH 2/2] init: allow mounting arbitrary
 non-blockdevice filesystems as root
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org

On Thu, Jun 17, 2021 at 05:36:49PM +0200, Christoph Hellwig wrote:

[..]
> +static int __init try_mount_nodev(char *fstype)
> +{
> +	struct file_system_type *fs = get_fs_type(fstype);
> +	int err = -EINVAL;
> +
> +	if (!fs)
> +		return -EINVAL;
> +	if (!(fs->fs_flags & (FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA)))

Not sure what FS_BINARY_MOUNTDATA is why fs should not have that set. nfs
seems to set it too. So that means they can't use try_mount_nodev().

> +		err = do_mount_root(root_device_name, fstype, root_mountflags,
> +					root_mount_data);
> +	put_filesystem(fs);
> +
> +	if (err != -EACCES && err != -EINVAL)

In case of success err == 0, but we still panic(). We will need to
check for success as well.
	if (err && err != -EACCES && err != -EINVAL)

> +		panic("VFS: Unable to mount root \"%s\" (%s), err=%d\n",
> +			      root_device_name, fstype, err);
> +	return err;
> +}
> +
> +static int __init mount_nodev_root(void)
> +{
> +	char *fs_names, *p;
> +	int err = -EINVAL;
> +
> +	fs_names = (void *)__get_free_page(GFP_KERNEL);
> +	if (!fs_names)
> +		return -EINVAL;
> +	split_fs_names(fs_names, root_fs_names);

root_fs_names can be NULL and it crashes with NULL pointer dereference.

Vivek

> +
> +	for (p = fs_names; *p; p += strlen(p) + 1) {
> +		err = try_mount_nodev(p);
> +		if (!err)
> +			break;
> +	}
> +
> +	free_page((unsigned long)fs_names);
> +	return err;
> +}
> +
>  void __init mount_root(void)
>  {
>  #ifdef CONFIG_ROOT_NFS
> @@ -550,6 +588,8 @@ void __init mount_root(void)
>  		return;
>  	}
>  #endif
> +	if (ROOT_DEV == 0 && mount_nodev_root() == 0)
> +		return;
>  #ifdef CONFIG_BLOCK
>  	{
>  		int err = create_dev("/dev/root", ROOT_DEV);
> -- 
> 2.30.2
> 

