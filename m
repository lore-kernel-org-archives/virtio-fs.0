References: <20210525150230.157586-1-groug@kaod.org>
	<20210525150230.157586-3-groug@kaod.org>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <58c70352-2df5-0cb9-9ca6-bb4bf2edd1c2@redhat.com>
Date: Thu, 27 May 2021 12:08:36 +0200
MIME-Version: 1.0
In-Reply-To: <20210525150230.157586-3-groug@kaod.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 2/4] fuse: Fix infinite loop in sget_fc()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>, Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On 25.05.21 17:02, Greg Kurz wrote:
> We don't set the SB_BORN flag on submounts. This is wrong as these
> superblocks are then considered as partially constructed or dying
> in the rest of the code and can break some assumptions.
> 
> One such case is when you have a virtiofs filesystem with submounts
> and you try to mount it again : virtio_fs_get_tree() tries to obtain
> a superblock with sget_fc(). The logic in sget_fc() is to loop until
> it has either found an existing matching superblock with SB_BORN set
> or to create a brand new one. It is assumed that a superblock without
> SB_BORN is transient and should go away. Forgetting to set SB_BORN on
> submounts hence causes sget_fc() to retry forever.
> 
> Setting SB_BORN requires special care, i.e. a write barrier for
> super_cache_count() which can check SB_BORN without taking any lock.
> We should call vfs_get_tree() to deal with that but this requires
> to have a proper ->get_tree() implementation for submounts, which
> is a bigger piece of work. Go for a simple bug fix in the meatime.
> 
> Fixes: bf109c64040f ("fuse: implement crossmounts")
> Cc: mreitz@redhat.com
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>   fs/fuse/dir.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 01559061cbfb..3b0482738741 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -346,6 +346,16 @@ static struct vfsmount *fuse_dentry_automount(struct path *path)
>   		goto out_put_sb;
>   	}
>   
> +	/*
> +	 * FIXME: setting SB_BORN requires a write barrier for
> +	 *        super_cache_count(). We should actually come
> +	 *        up with a proper ->get_tree() implementation
> +	 *        for submounts and call vfs_get_tree() to take
> +	 *        care of the write barrier.
> +	 */
> +	smp_wmb();
> +	sb->s_flags |= SB_BORN;
> +

I’m not sure whether we should have the order be exactly the same as in 
vfs_get_tree(), i.e. whether this should be put after fsc->root has been 
set.  Or maybe even after fm has been added to fc->mounts, because that 
too was part of the fuse_get_tree_submount() function of your “fuse: 
Call vfs_get_tree() for submounts” patch.

 From a quick look at SB_BORN users, it doesn’t seem to make a 
difference to me, though, so:

Reviewed-by: Max Reitz <mreitz@redhat.com>

>   	sb->s_flags |= SB_ACTIVE;
>   	fsc->root = dget(sb->s_root);
>   	/* We are done configuring the superblock, so unlock it */
> 

