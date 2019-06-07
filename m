Date: Fri, 7 Jun 2019 14:21:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190607182129.GB23125@redhat.com>
References: <20190530181141.GA9848@redhat.com> <20190607151517.GH2631@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607151517.GH2631@work-vm>
Subject: Re: [Virtio-fs] [RFC PATCH] virtiofsd: Provide support for posix
	locks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, Miklos Szeredi <mszeredi@redhat.com>

On Fri, Jun 07, 2019 at 04:15:18PM +0100, Dr. David Alan Gilbert wrote:
[..]
> > Index: qemu/contrib/virtiofsd/passthrough_ll.c
> > ===================================================================
> > --- qemu.orig/contrib/virtiofsd/passthrough_ll.c	2019-04-25 10:49:14.103386416 -0400
> > +++ qemu/contrib/virtiofsd/passthrough_ll.c	2019-05-30 14:02:55.598483536 -0400
> > @@ -58,6 +58,12 @@
> >  #include <gmodule.h>
> >  #include "seccomp.h"
> >  
> > +/* Keep track of inode posix locks for each owner. */
> > +struct lo_inode_plock {
> > +	uint64_t	lock_owner;
> > +	int	fd;	/* fd for OFD locks */
> > +};
> > +
> >  struct lo_map_elem {
> >  	union {
> >  		struct lo_inode *inode;
> > @@ -86,6 +92,8 @@ struct lo_inode {
> >  	struct lo_key key;
> >  	uint64_t refcount; /* protected by lo->mutex */
> >  	fuse_ino_t fuse_ino;
> > +	pthread_mutex_t mutex;
> 
> If this mutex is purely for posix_locks then there's probably a better
> name.

Hi Dave,

As of now it is only for posix locks. But it could be used for locking
other inode specific data structures as well. That's why I left it with
a generic name. But if it bothers you, I can open to change the name
to something else.

[..]
> > @@ -1038,6 +1064,10 @@ static void unref_inode(struct lo_data *
> >  	if (!inode->refcount) {
> >  		lo_map_remove(&lo->ino_map, inode->fuse_ino);
> >                  g_hash_table_remove(lo->inodes, &inode->key);
> > +		if (g_hash_table_size(inode->posix_locks)) {
> > +			warn("Hash table is not empty\n");
> > +		}
> > +		g_hash_table_destroy(inode->posix_locks);
> >  		pthread_mutex_unlock(&lo->mutex);
> >  		close(inode->fd);
> 
> pthread_mutex_destroy(&inode->mutex) ?

So is it necessary to call this? Is it about that if same inode is
allocated next time and if we call pthread_mutex_init(), it might
have issues?

IOW, trying to understand why one should call pthread_mutex_destroy()
before freeing inode.

Vivek

