Date: Thu, 30 May 2019 14:50:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190530185005.GB20473@redhat.com>
References: <20190530181141.GA9848@redhat.com>
	<20190530184511.oburnp2p6ea5ye3b@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530184511.oburnp2p6ea5ye3b@US-160370MP2.local>
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
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, Miklos Szeredi <mszeredi@redhat.com>

On Thu, May 30, 2019 at 11:45:11AM -0700, Liu Bo wrote:
> On Thu, May 30, 2019 at 02:11:41PM -0400, Vivek Goyal wrote:
> > Doing posix locks with-in guest kernel are not sufficient if a file/dir
> > is being shared by multiple guests. So we need the notion of daemon doing
> > the locks which are visible to rest of the guests.
> > 
> > Given posix locks are per process, one can not call posix lock API on host,
> > otherwise bunch of basic posix locks properties are broken. For example,
> > If two processes (A and B) in guest open the file and take locks on different
> > sections of file, if one of the processes closes the fd, it will close
> > fd on virtiofsd and all posix locks on file will go away. This means if
> > process A closes the fd, then locks of process B will go away too.
> >
> > Similar other problems exist too.
> > 
> > This patch set tries to emulate posix locks while using open file
> > description locks provided on Linux.
> > 
> > Daemon provides two options (-o posix_lock, -o no_posix_lock) to enable
> > or disable posix locking in daemon. By default it is enabled.
> > 
> > There are few issues though.
> > 
> > - GETLK() returns pid of process holding lock. As we are emulating locks
> >   using OFD, and these locks are not per process and don't return pid
> >   of process, so GETLK() in guest does not reuturn process pid.
> > 
> > - As of now only F_SETLK is supported and not F_SETLKW. We can't block
> >   the thread in virtiofsd for arbitrary long duration as there is only
> >   one thread serving the queue. That means unlock request will not make
> >   it to daemon and F_SETLKW will block infinitely and bring virtio-fs
> >   to a halt. This is a solvable problem though and will require significant
> >   changes in virtiofsd and kernel. Left as a TODO item for now.
> 
> We've also seen this hang with flock()'s sleep mode, I was wondering
> if we could pthread_create a new thread to do the sleeping locking.

One idea I was discussing with david gilbert is, can we have multiple
threds serving same virt queue and that will allow us blocking in same
context as the caller.

This probably also means create a separate virtqueue for sending down
requests which can block for arbitrarily long amount of time, to make
sure deadlock does not happen.

Thanks
Vivek

> 
> thanks,
> -liubo
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  contrib/virtiofsd/passthrough_ll.c |  185 ++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 184 insertions(+), 1 deletion(-)
> > 
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
> > +	GHashTable *posix_locks; /* protected by lo_inode->mutex */
> >  };
> >  
> >  struct lo_cred {
> > @@ -105,6 +113,7 @@ struct lo_data {
> >  	int norace;
> >  	int writeback;
> >  	int flock;
> > +	int posix_lock;
> >  	int xattr;
> >  	const char *source;
> >  	double timeout;
> > @@ -133,6 +142,10 @@ static const struct fuse_opt lo_opts[] =
> >  	  offsetof(struct lo_data, flock), 1 },
> >  	{ "no_flock",
> >  	  offsetof(struct lo_data, flock), 0 },
> > +	{ "posix_lock",
> > +	  offsetof(struct lo_data, posix_lock), 0 },
> > +	{ "no_posix_lock",
> > +	  offsetof(struct lo_data, posix_lock), 0 },
> >  	{ "xattr",
> >  	  offsetof(struct lo_data, xattr), 1 },
> >  	{ "no_xattr",
> > @@ -362,13 +375,24 @@ static void lo_init(void *userdata,
> >  			fprintf(stderr, "lo_init: activating flock locks\n");
> >  		conn->want |= FUSE_CAP_FLOCK_LOCKS;
> >  	}
> > +
> > +	if (conn->capable & FUSE_CAP_POSIX_LOCKS) {
> > +		if (lo->posix_lock) {
> > +			if (lo->debug)
> > +				fprintf(stderr, "lo_init: activating posix locks\n");
> > +			conn->want |= FUSE_CAP_POSIX_LOCKS;
> > +		} else {
> > +			if (lo->debug)
> > +				fprintf(stderr, "lo_init: disabling posix locks\n");
> > +			conn->want &= ~FUSE_CAP_POSIX_LOCKS;
> > +		}
> > +	}
> >  	if ((lo->cache == CACHE_NONE && !lo->readdirplus_set) ||
> >  	    lo->readdirplus_clear) {
> >  		if (lo->debug)
> >  			fprintf(stderr, "lo_init: disabling readdirplus\n");
> >  		conn->want &= ~FUSE_CAP_READDIRPLUS;
> >  	}
> > -
> >  }
> >  
> >  static void lo_getattr(fuse_req_t req, fuse_ino_t ino,
> > @@ -673,6 +697,8 @@ static int lo_do_lookup(fuse_req_t req,
> >  		newfd = -1;
> >  		inode->key.ino = e->attr.st_ino;
> >  		inode->key.dev = e->attr.st_dev;
> > +		pthread_mutex_init(&inode->mutex, NULL);
> > +		inode->posix_locks = g_hash_table_new(g_direct_hash, g_direct_equal);
> >  
> >  		pthread_mutex_lock(&lo->mutex);
> >  		inode->fuse_ino = lo_add_inode_mapping(req, inode);
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
> >  		free(inode);
> > @@ -1379,6 +1409,131 @@ out:
> >  		fuse_reply_create(req, &e, fi);
> >  }
> >  
> > +/* Should be called with inode->mutex held */
> > +static struct lo_inode_plock *lookup_create_plock_ctx(struct lo_data *lo,
> > +				struct lo_inode *inode, uint64_t lock_owner,
> > +				pid_t pid, int *err)
> > +{
> > +	struct lo_inode_plock *plock;
> > +	char procname[64];
> > +	int fd;
> > +
> > +	plock = g_hash_table_lookup(inode->posix_locks,
> > +				    GUINT_TO_POINTER(lock_owner));
> > +
> > +	if (plock)
> > +		return plock;
> > +
> > +	plock = malloc(sizeof(struct lo_inode_plock));
> > +	if (!plock) {
> > +		*err = ENOMEM;
> > +		return NULL;
> > +	}
> > +
> > +	/* Open another instance of file which can be used for ofd locks. */
> > +	sprintf(procname, "%i", inode->fd);
> > +
> > +	/* TODO: What if file is not writable? */
> > +	fd = openat(lo->proc_self_fd, procname, O_RDWR);
> > +	if (fd == -1) {
> > +		*err = -errno;
> > +		free(plock);
> > +		return NULL;
> > +	}
> > +
> > +	plock->lock_owner = lock_owner;
> > +	plock->fd = fd;
> > +	g_hash_table_insert(inode->posix_locks,
> > +			    GUINT_TO_POINTER(plock->lock_owner), plock);
> > +	return plock;
> > +}
> > +
> > +static void lo_getlk(fuse_req_t req, fuse_ino_t ino,
> > +		     struct fuse_file_info *fi, struct flock *lock)
> > +{
> > +	struct lo_data *lo = lo_data(req);
> > +	struct lo_inode *inode;
> > +	struct lo_inode_plock *plock;
> > +	int ret, saverr = 0;
> > +
> > +	if (lo_debug(req))
> > +		fprintf(stderr, "lo_getlk(ino=%" PRIu64 ", flags=%d)"
> > +			       " owner=0x%lx, l_type=%d l_start=0x%lx"
> > +			      " l_len=0x%lx\n", ino, fi->flags, fi->lock_owner,
> > +			      lock->l_type, lock->l_start, lock->l_len);
> > +
> > +	inode = lo_inode(req, ino);
> > +	if (!inode) {
> > +		fuse_reply_err(req, EBADF);
> > +		return;
> > +	}
> > +
> > +	pthread_mutex_lock(&inode->mutex);
> > +	plock = lookup_create_plock_ctx(lo, inode, fi->lock_owner, lock->l_pid,
> > +			&ret);
> > +	if (!plock) {
> > +		pthread_mutex_unlock(&inode->mutex);
> > +		fuse_reply_err(req, ret);
> > +		return;
> > +	}
> > +
> > +	ret = fcntl(plock->fd, F_OFD_GETLK, lock);
> > +	if (ret == -1)
> > +		saverr = errno;
> > +	pthread_mutex_unlock(&inode->mutex);
> > +
> > +	if (saverr)
> > +		fuse_reply_err(req, saverr);
> > +	else
> > +		fuse_reply_lock(req, lock);
> > +}
> > +
> > +static void lo_setlk(fuse_req_t req, fuse_ino_t ino,
> > +		     struct fuse_file_info *fi, struct flock *lock, int sleep)
> > +{
> > +	struct lo_data *lo = lo_data(req);
> > +	struct lo_inode *inode;
> > +	struct lo_inode_plock *plock;
> > +	int ret, saverr = 0;
> > +
> > +	if (lo_debug(req))
> > +		fprintf(stderr, "lo_setlk(ino=%" PRIu64 ", flags=%d)"
> > +			" cmd=%d pid=%d owner=0x%lx sleep=%d l_whence=%d"
> > +		        " l_start=0x%lx l_len=0x%lx\n", ino, fi->flags,
> > +			lock->l_type, lock->l_pid, fi->lock_owner, sleep,
> > +			lock->l_whence, lock->l_start, lock->l_len);
> > +
> > +	if (sleep) {
> > +		fuse_reply_err(req, EOPNOTSUPP);
> > +		return;
> > +	}
> > +
> > +	inode = lo_inode(req, ino);
> > +	if (!inode) {
> > +		fuse_reply_err(req, EBADF);
> > +		return;
> > +	}
> > +
> > +	pthread_mutex_lock(&inode->mutex);
> > +	plock = lookup_create_plock_ctx(lo, inode, fi->lock_owner, lock->l_pid,
> > +			&ret);
> > +
> > +	if (!plock) {
> > +		pthread_mutex_unlock(&inode->mutex);
> > +		fuse_reply_err(req, ret);
> > +		return;
> > +	}
> > +
> > +	/* TODO: Is it alright to modify flock? */
> > +	lock->l_pid = 0;
> > +	ret = fcntl(plock->fd, F_OFD_SETLK, lock);
> > +	if (ret == -1) {
> > +		saverr = errno;
> > +	}
> > +	pthread_mutex_unlock(&inode->mutex);
> > +	fuse_reply_err(req, saverr);
> > +}
> > +
> >  static void lo_fsyncdir(fuse_req_t req, fuse_ino_t ino, int datasync,
> >  			struct fuse_file_info *fi)
> >  {
> > @@ -1476,6 +1631,31 @@ static void lo_flush(fuse_req_t req, fus
> >  {
> >  	int res;
> >  	(void) ino;
> > +	struct lo_inode *inode;
> > +	struct lo_inode_plock *plock;
> > +
> > +	inode = lo_inode(req, ino);
> > +	if (!inode) {
> > +		fuse_reply_err(req, EBADF);
> > +		return;
> > +	}
> > +
> > +	/* An fd is going away. Cleanup associated posix locks */
> > +	pthread_mutex_lock(&inode->mutex);
> > +	plock = g_hash_table_lookup(inode->posix_locks,
> > +				    GUINT_TO_POINTER(fi->lock_owner));
> > +	if (plock) {
> > +		g_hash_table_remove(inode->posix_locks,
> > +				    GUINT_TO_POINTER(fi->lock_owner));
> > +		/*
> > +		 * We had used open() for locks and had only one fd. So
> > +		 * closing this fd should release all OFD locks.
> > +		 */
> > +		close(plock->fd);
> > +		free(plock);
> > +	}
> > +	pthread_mutex_unlock(&inode->mutex);
> > +
> >  	res = close(dup(lo_fi_fd(req, fi)));
> >  	fuse_reply_err(req, res == -1 ? errno : 0);
> >  }
> > @@ -1963,6 +2143,8 @@ static struct fuse_lowlevel_ops lo_oper
> >  	.releasedir	= lo_releasedir,
> >  	.fsyncdir	= lo_fsyncdir,
> >  	.create		= lo_create,
> > +	.getlk		= lo_getlk,
> > +	.setlk		= lo_setlk,
> >  	.open		= lo_open,
> >  	.release	= lo_release,
> >  	.flush		= lo_flush,
> > @@ -2189,6 +2371,7 @@ int main(int argc, char *argv[])
> >  	struct fuse_cmdline_opts opts;
> >  	struct lo_data lo = { .debug = 0,
> >  	                      .writeback = 0,
> > +			      .posix_lock = 1,
> >  	                      .proc_self_fd = -1,
> >  	};
> >  	struct lo_map_elem *root_elem;
> > 
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs

