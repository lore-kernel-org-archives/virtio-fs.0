Date: Fri, 22 Nov 2019 14:18:37 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191122141837.GD2785@work-vm>
References: <20191122113130.481113-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122113130.481113-1-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: fix libfuse information leaks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> Some FUSE message replies contain padding fields that are not
> initialized by libfuse.  This is fine in traditional FUSE applications
> because the kernel is trusted.  virtiofsd does not trust the guest and
> must not expose uninitialized memory.
> 
> Use C struct initializers to automatically zero out memory.  Not all of
> these code changes are strictly necessary but they will prevent future
> information leaks if the structs are extended.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

Thanks, merged.

Dave

> ---
>  contrib/virtiofsd/fuse_lowlevel.c | 150 +++++++++++++++---------------
>  1 file changed, 76 insertions(+), 74 deletions(-)
> 
> diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> index 7fa8861f5d..8a4234630d 100644
> --- a/contrib/virtiofsd/fuse_lowlevel.c
> +++ b/contrib/virtiofsd/fuse_lowlevel.c
> @@ -45,21 +45,23 @@ static __attribute__((constructor)) void fuse_ll_init_pagesize(void)
>  
>  static void convert_stat(const struct stat *stbuf, struct fuse_attr *attr)
>  {
> -	attr->ino	= stbuf->st_ino;
> -	attr->mode	= stbuf->st_mode;
> -	attr->nlink	= stbuf->st_nlink;
> -	attr->uid	= stbuf->st_uid;
> -	attr->gid	= stbuf->st_gid;
> -	attr->rdev	= stbuf->st_rdev;
> -	attr->size	= stbuf->st_size;
> -	attr->blksize	= stbuf->st_blksize;
> -	attr->blocks	= stbuf->st_blocks;
> -	attr->atime	= stbuf->st_atime;
> -	attr->mtime	= stbuf->st_mtime;
> -	attr->ctime	= stbuf->st_ctime;
> -	attr->atimensec = ST_ATIM_NSEC(stbuf);
> -	attr->mtimensec = ST_MTIM_NSEC(stbuf);
> -	attr->ctimensec = ST_CTIM_NSEC(stbuf);
> +	*attr = (struct fuse_attr) {
> +		.ino		= stbuf->st_ino,
> +		.mode		= stbuf->st_mode,
> +		.nlink		= stbuf->st_nlink,
> +		.uid		= stbuf->st_uid,
> +		.gid		= stbuf->st_gid,
> +		.rdev		= stbuf->st_rdev,
> +		.size		= stbuf->st_size,
> +		.blksize	= stbuf->st_blksize,
> +		.blocks		= stbuf->st_blocks,
> +		.atime		= stbuf->st_atime,
> +		.mtime		= stbuf->st_mtime,
> +		.ctime		= stbuf->st_ctime,
> +		.atimensec	= ST_ATIM_NSEC(stbuf),
> +		.mtimensec	= ST_MTIM_NSEC(stbuf),
> +		.ctimensec	= ST_CTIM_NSEC(stbuf),
> +	};
>  }
>  
>  static void convert_attr(const struct fuse_setattr_in *attr, struct stat *stbuf)
> @@ -181,16 +183,16 @@ static int fuse_send_msg(struct fuse_session *se, struct fuse_chan *ch,
>  int fuse_send_reply_iov_nofree(fuse_req_t req, int error, struct iovec *iov,
>  			       int count)
>  {
> -	struct fuse_out_header out;
> +	struct fuse_out_header out = {
> +		.unique = req->unique,
> +		.error = error,
> +	};
>  
>  	if (error <= -1000 || error > 0) {
>  		fuse_log(FUSE_LOG_ERR, "fuse: bad error value: %i\n",	error);
>  		error = -ERANGE;
>  	}
>  
> -	out.unique = req->unique;
> -	out.error = error;
> -
>  	iov[0].iov_base = &out;
>  	iov[0].iov_len = sizeof(struct fuse_out_header);
>  
> @@ -271,14 +273,16 @@ size_t fuse_add_direntry(fuse_req_t req, char *buf, size_t bufsize,
>  static void convert_statfs(const struct statvfs *stbuf,
>  			   struct fuse_kstatfs *kstatfs)
>  {
> -	kstatfs->bsize	 = stbuf->f_bsize;
> -	kstatfs->frsize	 = stbuf->f_frsize;
> -	kstatfs->blocks	 = stbuf->f_blocks;
> -	kstatfs->bfree	 = stbuf->f_bfree;
> -	kstatfs->bavail	 = stbuf->f_bavail;
> -	kstatfs->files	 = stbuf->f_files;
> -	kstatfs->ffree	 = stbuf->f_ffree;
> -	kstatfs->namelen = stbuf->f_namemax;
> +	*kstatfs = (struct fuse_kstatfs) {
> +		.bsize	 = stbuf->f_bsize,
> +		.frsize	 = stbuf->f_frsize,
> +		.blocks	 = stbuf->f_blocks,
> +		.bfree	 = stbuf->f_bfree,
> +		.bavail	 = stbuf->f_bavail,
> +		.files	 = stbuf->f_files,
> +		.ffree	 = stbuf->f_ffree,
> +		.namelen = stbuf->f_namemax,
> +	};
>  }
>  
>  static int send_reply_ok(fuse_req_t req, const void *arg, size_t argsize)
> @@ -320,12 +324,14 @@ static unsigned int calc_timeout_nsec(double t)
>  static void fill_entry(struct fuse_entry_out *arg,
>  		       const struct fuse_entry_param *e)
>  {
> -	arg->nodeid = e->ino;
> -	arg->generation = e->generation;
> -	arg->entry_valid = calc_timeout_sec(e->entry_timeout);
> -	arg->entry_valid_nsec = calc_timeout_nsec(e->entry_timeout);
> -	arg->attr_valid = calc_timeout_sec(e->attr_timeout);
> -	arg->attr_valid_nsec = calc_timeout_nsec(e->attr_timeout);
> +	*arg = (struct fuse_entry_out) {
> +		.nodeid = e->ino,
> +		.generation = e->generation,
> +		.entry_valid = calc_timeout_sec(e->entry_timeout),
> +		.entry_valid_nsec = calc_timeout_nsec(e->entry_timeout),
> +		.attr_valid = calc_timeout_sec(e->attr_timeout),
> +		.attr_valid_nsec = calc_timeout_nsec(e->attr_timeout),
> +	};
>  	convert_stat(&e->attr, &arg->attr);
>  }
>  
> @@ -351,10 +357,12 @@ size_t fuse_add_direntry_plus(fuse_req_t req, char *buf, size_t bufsize,
>  	fill_entry(&dp->entry_out, e);
>  
>  	struct fuse_dirent *dirent = &dp->dirent;
> -	dirent->ino = e->attr.st_ino;
> -	dirent->off = off;
> -	dirent->namelen = namelen;
> -	dirent->type = (e->attr.st_mode & S_IFMT) >> 12;
> +	*dirent = (struct fuse_dirent) {
> +		.ino = e->attr.st_ino,
> +		.off = off,
> +		.namelen = namelen,
> +		.type = (e->attr.st_mode & S_IFMT) >> 12,
> +	};
>  	memcpy(dirent->name, name, namelen);
>  	memset(dirent->name + namelen, 0, entlen_padded - entlen);
>  
> @@ -504,15 +512,14 @@ int fuse_reply_data(fuse_req_t req, struct fuse_bufvec *bufv,
>  		    enum fuse_buf_copy_flags flags)
>  {
>  	struct iovec iov[2];
> -	struct fuse_out_header out;
> +	struct fuse_out_header out = {
> +		.unique = req->unique,
> +	};
>  	int res;
>  
>  	iov[0].iov_base = &out;
>  	iov[0].iov_len = sizeof(struct fuse_out_header);
>  
> -	out.unique = req->unique;
> -	out.error = 0;
> -
>  	res = fuse_send_data_iov(req->se, req->ch, iov, 1, bufv, flags);
>  	if (res <= 0) {
>  		fuse_free_req(req);
> @@ -2203,13 +2210,13 @@ static void do_destroy(fuse_req_t req, fuse_ino_t nodeid,
>  static int send_notify_iov(struct fuse_session *se, int notify_code,
>  			   struct iovec *iov, int count)
>  {
> -	struct fuse_out_header out;
> +	struct fuse_out_header out = {
> +		.error = notify_code,
> +	};
>  
>  	if (!se->got_init)
>  		return -ENOTCONN;
>  
> -	out.unique = 0;
> -	out.error = notify_code;
>  	iov[0].iov_base = &out;
>  	iov[0].iov_len = sizeof(struct fuse_out_header);
>  
> @@ -2219,11 +2226,11 @@ static int send_notify_iov(struct fuse_session *se, int notify_code,
>  int fuse_lowlevel_notify_poll(struct fuse_pollhandle *ph)
>  {
>  	if (ph != NULL) {
> -		struct fuse_notify_poll_wakeup_out outarg;
> +		struct fuse_notify_poll_wakeup_out outarg = {
> +			.kh = ph->kh,
> +		};
>  		struct iovec iov[2];
>  
> -		outarg.kh = ph->kh;
> -
>  		iov[1].iov_base = &outarg;
>  		iov[1].iov_len = sizeof(outarg);
>  
> @@ -2236,7 +2243,11 @@ int fuse_lowlevel_notify_poll(struct fuse_pollhandle *ph)
>  int fuse_lowlevel_notify_inval_inode(struct fuse_session *se, fuse_ino_t ino,
>  				     off_t off, off_t len)
>  {
> -	struct fuse_notify_inval_inode_out outarg;
> +	struct fuse_notify_inval_inode_out outarg = {
> +		.ino = ino,
> +		.off = off,
> +		.len = len,
> +	};
>  	struct iovec iov[2];
>  
>  	if (!se)
> @@ -2244,10 +2255,6 @@ int fuse_lowlevel_notify_inval_inode(struct fuse_session *se, fuse_ino_t ino,
>  
>  	if (se->conn.proto_major < 6 || se->conn.proto_minor < 12)
>  		return -ENOSYS;
> -	
> -	outarg.ino = ino;
> -	outarg.off = off;
> -	outarg.len = len;
>  
>  	iov[1].iov_base = &outarg;
>  	iov[1].iov_len = sizeof(outarg);
> @@ -2258,7 +2265,10 @@ int fuse_lowlevel_notify_inval_inode(struct fuse_session *se, fuse_ino_t ino,
>  int fuse_lowlevel_notify_inval_entry(struct fuse_session *se, fuse_ino_t parent,
>  				     const char *name, size_t namelen)
>  {
> -	struct fuse_notify_inval_entry_out outarg;
> +	struct fuse_notify_inval_entry_out outarg = {
> +		.parent = parent,
> +		.namelen = namelen,
> +	};
>  	struct iovec iov[3];
>  
>  	if (!se)
> @@ -2267,10 +2277,6 @@ int fuse_lowlevel_notify_inval_entry(struct fuse_session *se, fuse_ino_t parent,
>  	if (se->conn.proto_major < 6 || se->conn.proto_minor < 12)
>  		return -ENOSYS;
>  
> -	outarg.parent = parent;
> -	outarg.namelen = namelen;
> -	outarg.padding = 0;
> -
>  	iov[1].iov_base = &outarg;
>  	iov[1].iov_len = sizeof(outarg);
>  	iov[2].iov_base = (void *)name;
> @@ -2283,7 +2289,11 @@ int fuse_lowlevel_notify_delete(struct fuse_session *se,
>  				fuse_ino_t parent, fuse_ino_t child,
>  				const char *name, size_t namelen)
>  {
> -	struct fuse_notify_delete_out outarg;
> +	struct fuse_notify_delete_out outarg = {
> +		.parent = parent,
> +		.child = child,
> +		.namelen = namelen,
> +	};
>  	struct iovec iov[3];
>  
>  	if (!se)
> @@ -2292,11 +2302,6 @@ int fuse_lowlevel_notify_delete(struct fuse_session *se,
>  	if (se->conn.proto_major < 6 || se->conn.proto_minor < 18)
>  		return -ENOSYS;
>  
> -	outarg.parent = parent;
> -	outarg.child = child;
> -	outarg.namelen = namelen;
> -	outarg.padding = 0;
> -
>  	iov[1].iov_base = &outarg;
>  	iov[1].iov_len = sizeof(outarg);
>  	iov[2].iov_base = (void *)name;
> @@ -2309,10 +2314,15 @@ int fuse_lowlevel_notify_store(struct fuse_session *se, fuse_ino_t ino,
>  			       off_t offset, struct fuse_bufvec *bufv,
>  			       enum fuse_buf_copy_flags flags)
>  {
> -	struct fuse_out_header out;
> -	struct fuse_notify_store_out outarg;
> +	struct fuse_out_header out = {
> +		.error = FUSE_NOTIFY_STORE,
> +	};
> +	struct fuse_notify_store_out outarg = {
> +		.nodeid = ino,
> +		.offset = offset,
> +		.size = fuse_buf_size(bufv),
> +	};
>  	struct iovec iov[3];
> -	size_t size = fuse_buf_size(bufv);
>  	int res;
>  
>  	if (!se)
> @@ -2321,14 +2331,6 @@ int fuse_lowlevel_notify_store(struct fuse_session *se, fuse_ino_t ino,
>  	if (se->conn.proto_major < 6 || se->conn.proto_minor < 15)
>  		return -ENOSYS;
>  
> -	out.unique = 0;
> -	out.error = FUSE_NOTIFY_STORE;
> -
> -	outarg.nodeid = ino;
> -	outarg.offset = offset;
> -	outarg.size = size;
> -	outarg.padding = 0;
> -
>  	iov[0].iov_base = &out;
>  	iov[0].iov_len = sizeof(out);
>  	iov[1].iov_base = &outarg;
> -- 
> 2.23.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

