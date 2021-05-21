Date: Fri, 21 May 2021 12:08:40 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210521120840.4658d42c@bahia.lan>
In-Reply-To: <20210520154654.1791183-6-groug@kaod.org>
References: <20210520154654.1791183-1-groug@kaod.org>
	<20210520154654.1791183-6-groug@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v4 5/5] virtiofs: propagate sync() to file
	server
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, Robert Krawitz <rlk@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Thu, 20 May 2021 17:46:54 +0200
Greg Kurz <groug@kaod.org> wrote:

> Even if POSIX doesn't mandate it, linux users legitimately expect
> sync() to flush all data and metadata to physical storage when it
> is located on the same system. This isn't happening with virtiofs
> though : sync() inside the guest returns right away even though
> data still needs to be flushed from the host page cache.
> 
> This is easily demonstrated by doing the following in the guest:
> 
> $ dd if=/dev/zero of=/mnt/foo bs=1M count=5K ; strace -T -e sync sync
> 5120+0 records in
> 5120+0 records out
> 5368709120 bytes (5.4 GB, 5.0 GiB) copied, 5.22224 s, 1.0 GB/s
> sync()                                  = 0 <0.024068>
> +++ exited with 0 +++
> 
> and start the following in the host when the 'dd' command completes
> in the guest:
> 
> $ strace -T -e fsync /usr/bin/sync virtiofs/foo
> fsync(3)                                = 0 <10.371640>
> +++ exited with 0 +++
> 
> There are no good reasons not to honor the expected behavior of
> sync() actually : it gives an unrealistic impression that virtiofs
> is super fast and that data has safely landed on HW, which isn't
> the case obviously.
> 
> Implement a ->sync_fs() superblock operation that sends a new
> FUSE_SYNCFS request type for this purpose. Provision a 64-bit
> placeholder for possible future extensions. Since the file
> server cannot handle the wait == 0 case, we skip it to avoid a
> gratuitous roundtrip. Note that this is per-superblock : a
> FUSE_SYNCFS is send for the root mount and for each submount.
> 

s/send/sent

Miklos,

Great thanks for the quick feedback on these patches ! :)

Apart from the fact that nothing is sent for submounts as long
as we don't set SB_BORN on them, this patch doesn't really
depends on the previous ones.

If it looks good to you, maybe you can just merge it and
I'll re-post the fixes separately ?

Cheers,

--
Greg

> Like with FUSE_FSYNC and FUSE_FSYNCDIR, lack of support for
> FUSE_SYNCFS in the file server is treated as permanent success.
> This ensures compatibility with older file servers : the client
> will get the current behavior of sync() not being propagated to
> the file server.
> 
> Note that such an operation allows the file server to DoS sync().
> Since a typical FUSE file server is an untrusted piece of software
> running in userspace, this is disabled by default.  Only enable it
> with virtiofs for now since virtiofsd is supposedly trusted by the
> guest kernel.
> 
> Reported-by: Robert Krawitz <rlk@redhat.com>
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>  fs/fuse/fuse_i.h          |  3 +++
>  fs/fuse/inode.c           | 40 +++++++++++++++++++++++++++++++++++++++
>  fs/fuse/virtio_fs.c       |  1 +
>  include/uapi/linux/fuse.h | 10 +++++++++-
>  4 files changed, 53 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index e2f5c8617e0d..01d9283261af 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -761,6 +761,9 @@ struct fuse_conn {
>  	/* Auto-mount submounts announced by the server */
>  	unsigned int auto_submounts:1;
>  
> +	/* Propagate syncfs() to server */
> +	unsigned int sync_fs:1;
> +
>  	/** The number of requests waiting for completion */
>  	atomic_t num_waiting;
>  
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 123b53d1c3c6..96b00253f766 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -506,6 +506,45 @@ static int fuse_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	return err;
>  }
>  
> +static int fuse_sync_fs(struct super_block *sb, int wait)
> +{
> +	struct fuse_mount *fm = get_fuse_mount_super(sb);
> +	struct fuse_conn *fc = fm->fc;
> +	struct fuse_syncfs_in inarg;
> +	FUSE_ARGS(args);
> +	int err;
> +
> +	/*
> +	 * Userspace cannot handle the wait == 0 case. Avoid a
> +	 * gratuitous roundtrip.
> +	 */
> +	if (!wait)
> +		return 0;
> +
> +	/* The filesystem is being unmounted. Nothing to do. */
> +	if (!sb->s_root)
> +		return 0;
> +
> +	if (!fc->sync_fs)
> +		return 0;
> +
> +	memset(&inarg, 0, sizeof(inarg));
> +	args.in_numargs = 1;
> +	args.in_args[0].size = sizeof(inarg);
> +	args.in_args[0].value = &inarg;
> +	args.opcode = FUSE_SYNCFS;
> +	args.nodeid = get_node_id(sb->s_root->d_inode);
> +	args.out_numargs = 0;
> +
> +	err = fuse_simple_request(fm, &args);
> +	if (err == -ENOSYS) {
> +		fc->sync_fs = 0;
> +		err = 0;
> +	}
> +
> +	return err;
> +}
> +
>  enum {
>  	OPT_SOURCE,
>  	OPT_SUBTYPE,
> @@ -909,6 +948,7 @@ static const struct super_operations fuse_super_operations = {
>  	.put_super	= fuse_put_super,
>  	.umount_begin	= fuse_umount_begin,
>  	.statfs		= fuse_statfs,
> +	.sync_fs	= fuse_sync_fs,
>  	.show_options	= fuse_show_options,
>  };
>  
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 8962cd033016..f649a47efb68 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -1455,6 +1455,7 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
>  	fc->release = fuse_free_conn;
>  	fc->delete_stale = true;
>  	fc->auto_submounts = true;
> +	fc->sync_fs = true;
>  
>  	/* Tell FUSE to split requests that exceed the virtqueue's size */
>  	fc->max_pages_limit = min_t(unsigned int, fc->max_pages_limit,
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 271ae90a9bb7..36ed092227fa 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -181,6 +181,9 @@
>   *  - add FUSE_OPEN_KILL_SUIDGID
>   *  - extend fuse_setxattr_in, add FUSE_SETXATTR_EXT
>   *  - add FUSE_SETXATTR_ACL_KILL_SGID
> + *
> + *  7.34
> + *  - add FUSE_SYNCFS
>   */
>  
>  #ifndef _LINUX_FUSE_H
> @@ -216,7 +219,7 @@
>  #define FUSE_KERNEL_VERSION 7
>  
>  /** Minor version number of this interface */
> -#define FUSE_KERNEL_MINOR_VERSION 33
> +#define FUSE_KERNEL_MINOR_VERSION 34
>  
>  /** The node ID of the root inode */
>  #define FUSE_ROOT_ID 1
> @@ -509,6 +512,7 @@ enum fuse_opcode {
>  	FUSE_COPY_FILE_RANGE	= 47,
>  	FUSE_SETUPMAPPING	= 48,
>  	FUSE_REMOVEMAPPING	= 49,
> +	FUSE_SYNCFS		= 50,
>  
>  	/* CUSE specific operations */
>  	CUSE_INIT		= 4096,
> @@ -971,4 +975,8 @@ struct fuse_removemapping_one {
>  #define FUSE_REMOVEMAPPING_MAX_ENTRY   \
>  		(PAGE_SIZE / sizeof(struct fuse_removemapping_one))
>  
> +struct fuse_syncfs_in {
> +	uint64_t	padding;
> +};
> +
>  #endif /* _LINUX_FUSE_H */

