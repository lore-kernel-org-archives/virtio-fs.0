Date: Tue, 5 Jan 2021 10:42:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210105154241.GB3200@redhat.com>
References: <20210104160013.GG2972@work-vm> <20210104184527.GC63879@redhat.com>
	<20210104185655.GN2972@work-vm>
	<CAJfpegvm0ZYojTeakkXgJ+Q1=k1UFiu=p3VeOST29PXjZGDreA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvm0ZYojTeakkXgJ+Q1=k1UFiu=p3VeOST29PXjZGDreA@mail.gmail.com>
Subject: Re: [Virtio-fs] [fuse-devel] 'FORGET' ordering semantics (vs unlink
	& NFS)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>, virtio-fs-list <virtio-fs@redhat.com>

On Tue, Jan 05, 2021 at 12:24:48PM +0100, Miklos Szeredi wrote:
> On Mon, Jan 4, 2021 at 7:57 PM Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
> >
> > * Vivek Goyal (vgoyal@redhat.com) wrote:
> > > On Mon, Jan 04, 2021 at 04:00:13PM +0000, Dr. David Alan Gilbert wrote:
> > > > Hi,
> > > >   On virtio-fs we're hitting a problem with NFS, where
> > > > unlinking a file in a directory and then rmdir'ing that
> > > > directory fails complaining about the directory not being empty.
> > > >
> > > > The problem here is that if a file has an open fd, NFS doesn't
> > > > actually delete the file on unlink, it just renames it to
> > > > a hidden file (e.g. .nfs*******).  That open file is there because
> > > > the 'FORGET' hasn't completed yet by the time the rmdir is issued.
> > > >
> > > > Question:
> > > >   a) In the FUSE protocol, are requests assumed to complete in order;
> > > > i.e.  unlink, forget, rmdir   is it required that 'forget' completes
> > > > before the rmdir is processed?
> > > >      (In virtiofs we've been processing requests, in parallel, and
> > > > have sent forgets down a separate queue to keep them out of the way).
> > > >
> > > >   b) 'forget' doesn't send a reply - so the kernel can't wait for the
> > > > client to have finished it;  do we need a synchronous forget here?
> > >
> > > Even if we introduce a synchronous forget, will that really fix the
> > > issue. For example, this could also happen if file has been unlinked
> > > but it is still open and directory is being removed.
> > >
> > > fd = open(foo/bar.txt)
> > > unlink foo/bar.txt
> > > rmdir foo
> > > close(fd).
> > >
> > > In this case, final forget should go after fd has been closed. Its
> > > not a forget race.
> > >
> > > I wrote a test case for this and it works on regular file systems.
> > >
> > > https://github.com/rhvgoyal/misc/blob/master/virtiofs-tests/rmdir.c
> > >
> > > I suspect it will fail on nfs because I am assuming that temporary
> > > file will be there till final close(fd) happens. If that's the
> > > case this is a NFS specific issue because its behavior is different
> > > from other file systems.
> >
> > That's true; but that's NFS just being NFS; in our case we're keeping
> > an fd open even though the guest has been smart enough not to; so we're
> > causing the NFS oddity when it wouldn't normally happen.
> 
> Can't think of anything better than a synchronous forget.   Compile
> only tested patch attached.
> 
> Thanks,
> Miklos

> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 78f9f209078c..daa4e669441d 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -373,6 +373,26 @@ static struct vfsmount *fuse_dentry_automount(struct path *path)
>  	return ERR_PTR(err);
>  }
>  
> +static void fuse_dentry_iput(struct dentry *dentry, struct inode *inode)
> +{
> +	if (!__lockref_is_dead(&dentry->d_lockref)) {
> +		/*
> +		 * This is an unlink/rmdir and removing the last ref to the
> +		 * dentry.  Use synchronous FORGET in case filesystem requests
> +		 * it.
> +		 *
> +		 * FIXME: This is racy!  Two or more instances of
> +		 * fuse_dentry_iput() could be running concurrently (unlink of
> +		 * several aliases in different directories).
> +		 */
> +		set_bit(FUSE_I_SYNC_FORGET, &get_fuse_inode(inode)->state);
> +		iput(inode);
> +		clear_bit(FUSE_I_SYNC_FORGET, &get_fuse_inode(inode)->state);

Hi Miklos,

Can above iput() be final reference on inode and free the inode? If yes,
then it is not safe to call clear_bit() after iput()?

Vivek

> +	} else {
> +		iput(inode);
> +	}
> +}
> +
>  const struct dentry_operations fuse_dentry_operations = {
>  	.d_revalidate	= fuse_dentry_revalidate,
>  	.d_delete	= fuse_dentry_delete,
> @@ -381,6 +401,7 @@ const struct dentry_operations fuse_dentry_operations = {
>  	.d_release	= fuse_dentry_release,
>  #endif
>  	.d_automount	= fuse_dentry_automount,
> +	.d_iput		= fuse_dentry_iput,
>  };
>  
>  const struct dentry_operations fuse_root_dentry_operations = {
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 7c4b8cb93f9f..0820b7a63ca7 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -174,6 +174,8 @@ enum {
>  	FUSE_I_SIZE_UNSTABLE,
>  	/* Bad inode */
>  	FUSE_I_BAD,
> +	/* Synchronous forget requested */
> +	FUSE_I_SYNC_FORGET,
>  };
>  
>  struct fuse_conn;
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index b0e18b470e91..a49ff30d1ecc 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -115,6 +115,26 @@ static void fuse_free_inode(struct inode *inode)
>  	kmem_cache_free(fuse_inode_cachep, fi);
>  }
>  
> +static void fuse_sync_forget(struct inode *inode)
> +{
> +	struct fuse_mount *fm = get_fuse_mount(inode);
> +	struct fuse_inode *fi = get_fuse_inode(inode);
> +	struct fuse_forget_in inarg;
> +	FUSE_ARGS(args);
> +
> +	memset(&inarg, 0, sizeof(inarg));
> +	inarg.nlookup = fi->nlookup;
> +	args.opcode = FUSE_SYNC_FORGET;
> +	args.nodeid = fi->nodeid;
> +	args.in_numargs = 1;
> +	args.in_args[0].size = sizeof(inarg);
> +	args.in_args[0].value = &inarg;
> +	args.force = true;
> +
> +	fuse_simple_request(fm, &args);
> +	/* ignore errors */
> +}
> +
>  static void fuse_evict_inode(struct inode *inode)
>  {
>  	struct fuse_inode *fi = get_fuse_inode(inode);
> @@ -127,9 +147,13 @@ static void fuse_evict_inode(struct inode *inode)
>  		if (FUSE_IS_DAX(inode))
>  			fuse_dax_inode_cleanup(inode);
>  		if (fi->nlookup) {
> -			fuse_queue_forget(fc, fi->forget, fi->nodeid,
> -					  fi->nlookup);
> -			fi->forget = NULL;
> +			if (test_bit(FUSE_I_SYNC_FORGET, &fi->state)) {
> +				fuse_sync_forget(inode);
> +			} else {
> +				fuse_queue_forget(fc, fi->forget, fi->nodeid,
> +						  fi->nlookup);
> +				fi->forget = NULL;
> +			}
>  		}
>  	}
>  	if (S_ISREG(inode->i_mode) && !fuse_is_bad(inode)) {
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 98ca64d1beb6..cfcf95cfde76 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -499,6 +499,7 @@ enum fuse_opcode {
>  	FUSE_COPY_FILE_RANGE	= 47,
>  	FUSE_SETUPMAPPING	= 48,
>  	FUSE_REMOVEMAPPING	= 49,
> +	FUSE_SYNC_FORGET	= 50,
>  
>  	/* CUSE specific operations */
>  	CUSE_INIT		= 4096,

