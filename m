Date: Tue, 11 Jun 2019 15:30:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190611193041.GB28835@redhat.com>
References: <20190610192206.GD29869@redhat.com>
	<20190611190846.ofc6cbn3gvfeant7@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611190846.ofc6cbn3gvfeant7@US-160370MP2.local>
Subject: Re: [Virtio-fs] [PATCH V3] virtiofsd: Support remote posix locks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Tue, Jun 11, 2019 at 12:08:47PM -0700, Liu Bo wrote:

[..]
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
> > +	pthread_mutex_lock(&inode->plock_mutex);
> > +	plock = lookup_create_plock_ctx(lo, inode, fi->lock_owner, lock->l_pid,
> > +			&ret);
> > +	if (!plock) {
> > +		pthread_mutex_unlock(&inode->plock_mutex);
> > +		fuse_reply_err(req, ret);
> > +		return;
> > +	}
> > +
> > +	ret = fcntl(plock->fd, F_OFD_GETLK, lock);
> 
> lock->l_pid is set to the host's process holding this lock, right?  if
> so, would it confuse guest's processes?

man fcntl says following.

F_GETLK (struct flock *)
...
...

If the conflicting  lock  is  a traditional (process-associated) record
lock, then the l_pid field is set to  the  PID  of  the  process
holding  that  lock.   If  the  conflicting lock is an open file
description lock, then l_pid  is  set  to  -1.   Note  that  the
returned  information may already be out of date by the time the
caller inspects it.

daemon does not do posix locks. It might have put OFD or BSD lock. In that
case I think -1 will be returned. If some other process has put POSIX
lock on same file  (a process operating on shared dir exported to guest),
I think in that case pid of that process will be returned. 

I agree that it does not make much sense to return pid of a process
outside the guest. 

For now, I am inclined to leave it as it is and if this becomes an issue,
its a simple fix anyway.

[..]
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
> > +	pthread_mutex_lock(&inode->plock_mutex);
> > +	plock = lookup_create_plock_ctx(lo, inode, fi->lock_owner, lock->l_pid,
> > +			&ret);
> > +
> > +	if (!plock) {
> > +		pthread_mutex_unlock(&inode->plock_mutex);
> > +		fuse_reply_err(req, ret);
> > +		return;
> > +	}
> > +
> > +	/* TODO: Is it alright to modify flock? */
> 
> Guess we have to set it to 0, otherwise, fcntl would return EINVAL.

Why do you think fcntl() will return EINVAL. I am not seeing that in my
testing.

I put this comment to figure out if I need to allocate another flock
structure and copy arguments from the one passed to me. Or I can reuse
the one passed to me, overwrite l_pid and continue.

Thanks
Vivek

