Date: Fri, 18 Jun 2021 10:10:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210618141031.GC1234055@redhat.com>
References: <20210617153649.1886693-1-hch@lst.de>
	<20210617153649.1886693-3-hch@lst.de>
	<20210617162610.GC1142820@redhat.com>
	<20210618132038.GA13406@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618132038.GA13406@lst.de>
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
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, Dominique Martinet <asmadeus@codewreck.org>, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org

On Fri, Jun 18, 2021 at 03:20:38PM +0200, Christoph Hellwig wrote:
> On Thu, Jun 17, 2021 at 12:26:10PM -0400, Vivek Goyal wrote:
> > Not sure what FS_BINARY_MOUNTDATA is why fs should not have that set. nfs
> > seems to set it too. So that means they can't use try_mount_nodev().
> 
> We can't really pass actual binary mountdata using the string separation
> scheme used by the rootfstype= option.  But given that NFS only uses
> binary mountdata for legacy reasons and people get what they ask for
> using the option I think we can drop the check.
> 
> > In case of success err == 0, but we still panic(). We will need to
> > check for success as well.
> 
> Indeed.
> 
> > root_fs_names can be NULL and it crashes with NULL pointer dereference.
> 
> True.
> 
> What do you think of this version?

[ Cc Dominique Martinet ]

Hi Christoph,

This one works well for me. Just one minor nit. root_device_name, can
be NULL as well if user passes following.

"rootfstype=virtiofs rw".

And currently mount_nodev_root() is assuming root_device_name is not NULL
and we crash with null pointer dereference.

May be something like this.

        if (ROOT_DEV == 0 && root_device_name && root_fs_names) {
                if (mount_nodev_root() == 0)
                        return;
        }

Strangely people are using "rootfstype=virtiofs rw" to mount virtiofs
as rootfs. They give their filesystem a tag named "/dev/root". And
currently it works and they can mount virtiofs as rootfs.

With above change, current hackish way will also continue to work and
not break existing setups.

Thanks
Vivek

> 
> ---
> From 141caa79a619b5f5d100eeb8e94ecf8b3b1c9af7 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Fri, 18 Jun 2021 15:10:39 +0200
> Subject: init: allow mounting arbitrary non-blockdevice filesystems as root
> 
> Currently the only non-blockdevice filesystems that can be used as the
> initial root filesystem are NFS and CIFS, which use the magic
> "root=/dev/nfs" and "root=/dev/cifs" syntax that requires the root
> device file system details to come from filesystem specific kernel
> command line options.
> 
> Add a little bit of new code that allows to just pass arbitrary
> string mount options to any non-blockdevice filesystems so that it can
> be mounted as the root file system.
> 
> For example a virtiofs root file system can be mounted using the
> following syntax:
> 
> "root=myfs rootfstype=virtiofs rw"
> 
> Based on an earlier patch from Vivek Goyal <vgoyal@redhat.com>.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  init/do_mounts.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index ec32de3ad52b..66c47193e9ee 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -534,6 +534,45 @@ static int __init mount_cifs_root(void)
>  }
>  #endif
>  
> +static bool __init fs_is_nodev(char *fstype)
> +{
> +	struct file_system_type *fs = get_fs_type(fstype);
> +	bool ret = false;
> +
> +	if (fs) {
> +		ret = !(fs->fs_flags & FS_REQUIRES_DEV);
> +		put_filesystem(fs);
> +	}
> +
> +	return ret;
> +}
> +
> +static int __init mount_nodev_root(void)
> +{
> +	char *fs_names, *fstype;
> +	int err = -EINVAL;
> +
> +	fs_names = (void *)__get_free_page(GFP_KERNEL);
> +	if (!fs_names)
> +		return -EINVAL;
> +	split_fs_names(fs_names, root_fs_names);
> +
> +	for (fstype = fs_names; *fstype; fstype += strlen(fstype) + 1) {
> +		if (!fs_is_nodev(fstype))
> +			continue;
> +		err = do_mount_root(root_device_name, fstype, root_mountflags,
> +				    root_mount_data);
> +		if (!err)
> +			break;
> +		if (err != -EACCES && err != -EINVAL)
> +			panic("VFS: Unable to mount root \"%s\" (%s), err=%d\n",
> +			      root_device_name, fstype, err);
> +	}
> +
> +	free_page((unsigned long)fs_names);
> +	return err;
> +}
> +
>  void __init mount_root(void)
>  {
>  #ifdef CONFIG_ROOT_NFS
> @@ -550,6 +589,10 @@ void __init mount_root(void)
>  		return;
>  	}
>  #endif
> +	if (ROOT_DEV == 0 && root_fs_names) {
> +		if (mount_nodev_root() == 0)
> +			return;
> +	}
>  #ifdef CONFIG_BLOCK
>  	{
>  		int err = create_dev("/dev/root", ROOT_DEV);
> -- 
> 2.30.2
> 

