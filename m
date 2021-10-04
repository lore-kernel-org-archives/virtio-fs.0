Date: Mon, 4 Oct 2021 10:01:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YVsJNDJxsy1NAhHE@redhat.com>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-3-vgoyal@redhat.com>
	<YVr+oqwYRx11MBug@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVr+oqwYRx11MBug@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 02/13] virtiofsd: fuse.h header file changes
 for lock notification
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: miklos@szeredi.hu, qemu-devel@nongnu.org, virtio-fs@redhat.com

On Mon, Oct 04, 2021 at 02:16:18PM +0100, Stefan Hajnoczi wrote:
> On Thu, Sep 30, 2021 at 11:30:26AM -0400, Vivek Goyal wrote:
> > This change comes from fuse.h kernel header file udpate. Hence keeping
> > it in a separate patch.
> 
> QEMU syncs include/standard-headers/linux/ from linux.git. Please
> indicate the status of this fuse.h change:
> - Is it already in a Linux release?
> - Or is it already in linux.git?
> - Or is it awaiting review from the kernel FUSE maintainer?

This is awaiting review from kernel FUSE maintainer.

I have posted kernel patches here.

https://lore.kernel.org/linux-fsdevel/20210930143850.1188628-1-vgoyal@redhat.com/

Vivek

> 
> We need to wait for the kernel change to get into linux.git before
> merging this patch in QEMU. This ensures that QEMU uses actual released
> kernel interfaces that are guaranteed to be stable.
> 
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  include/standard-headers/linux/fuse.h | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/standard-headers/linux/fuse.h b/include/standard-headers/linux/fuse.h
> > index cce105bfba..0b6218d569 100644
> > --- a/include/standard-headers/linux/fuse.h
> > +++ b/include/standard-headers/linux/fuse.h
> > @@ -181,6 +181,8 @@
> >   *  - add FUSE_OPEN_KILL_SUIDGID
> >   *  - extend fuse_setxattr_in, add FUSE_SETXATTR_EXT
> >   *  - add FUSE_SETXATTR_ACL_KILL_SGID
> > + *  7.35
> > + *  - add FUSE_NOTIFY_LOCK
> >   */
> >  
> >  #ifndef _LINUX_FUSE_H
> > @@ -212,7 +214,7 @@
> >  #define FUSE_KERNEL_VERSION 7
> >  
> >  /** Minor version number of this interface */
> > -#define FUSE_KERNEL_MINOR_VERSION 33
> > +#define FUSE_KERNEL_MINOR_VERSION 35
> >  
> >  /** The node ID of the root inode */
> >  #define FUSE_ROOT_ID 1
> > @@ -521,6 +523,7 @@ enum fuse_notify_code {
> >  	FUSE_NOTIFY_STORE = 4,
> >  	FUSE_NOTIFY_RETRIEVE = 5,
> >  	FUSE_NOTIFY_DELETE = 6,
> > +	FUSE_NOTIFY_LOCK = 7,
> >  	FUSE_NOTIFY_CODE_MAX,
> >  };
> >  
> > @@ -912,6 +915,12 @@ struct fuse_notify_retrieve_in {
> >  	uint64_t	dummy4;
> >  };
> >  
> > +struct fuse_notify_lock_out {
> > +	uint64_t	unique;
> > +	int32_t		error;
> > +	int32_t		padding;
> > +};
> > +
> >  /* Device ioctls: */
> >  #define FUSE_DEV_IOC_MAGIC		229
> >  #define FUSE_DEV_IOC_CLONE		_IOR(FUSE_DEV_IOC_MAGIC, 0, uint32_t)
> > -- 
> > 2.31.1
> > 


