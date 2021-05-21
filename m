Date: Fri, 21 May 2021 10:28:33 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210521102833.4a7595b7@bahia.lan>
In-Reply-To: <YKdtJCo/06q594pM@miu.piliscsaba.redhat.com>
References: <20210520154654.1791183-1-groug@kaod.org>
	<20210520154654.1791183-3-groug@kaod.org>
	<YKdtJCo/06q594pM@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v4 2/5] fuse: Call vfs_get_tree() for
	submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>

On Fri, 21 May 2021 10:19:48 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Thu, May 20, 2021 at 05:46:51PM +0200, Greg Kurz wrote:
> > We don't set the SB_BORN flag on submounts superblocks. This is wrong
> > as these superblocks are then considered as partially constructed or
> > dying in the rest of the code and can break some assumptions.
> > 
> > One such case is when you have a virtiofs filesystem and you try to
> > mount it again : virtio_fs_get_tree() tries to obtain a superblock
> > with sget_fc(). The matching criteria in virtio_fs_test_super() is
> > the pointer of the underlying virtiofs device, which is shared by
> > the root mount and its submounts. This means that any submount can
> > be picked up instead of the root mount. This is itself a bug :
> > submounts should be ignored in this case. But, most importantly, it
> > then triggers an infinite loop in sget_fc() because it fails to grab
> > the superblock (very easy to reproduce).
> > 
> > The only viable solution is to set SB_BORN at some point. This
> > must be done with vfs_get_tree() because setting SB_BORN requires
> > special care, i.e. a memory barrier for super_cache_count() which
> > can check SB_BORN without taking any lock.
> 
> Looks correct, but...
> 
> as an easily backportable and verifiable bugfix I'd still go with the
> simple two liner:
> 
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -351,6 +351,9 @@ static struct vfsmount *fuse_dentry_automount(struct path *path)
>  	list_add_tail(&fm->fc_entry, &fc->mounts);
>  	up_write(&fc->killsb);
>  
> +	smp_wmb();
> +	sb->s_flags |= SB_BORN;
> +

plus the mandatory comment one must put to justify the
need for a memory barrier.

>  	/* Create the submount */
>  	mnt = vfs_create_mount(fsc);
>  	if (IS_ERR(mnt)) {
> 
> And have this patch be the cleanup.
> 

Fair enough.

> Also we need Fixes: and a Cc: stable@... tags on that one.
> 

Oops, I'll add these in the next round.

> Thanks,
> Miklos

