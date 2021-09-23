Date: Thu, 23 Sep 2021 15:02:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YUzPUYU8R5LL4mzU@redhat.com>
References: <20210923092526.72341-1-jefflexu@linux.alibaba.com>
	<20210923092526.72341-3-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923092526.72341-3-jefflexu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH v5 2/5] fuse: make DAX mount option a
	tri-state
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: miklos@szeredi.hu, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, linux-fsdevel@vger.kernel.org

On Thu, Sep 23, 2021 at 05:25:23PM +0800, Jeffle Xu wrote:
> We add 'always', 'never', and 'inode' (default). '-o dax' continues to
> operate the same which is equivalent to 'always'. To be consistemt with
> ext4/xfs's tri-state mount option, when neither '-o dax' nor '-o dax='
> option is specified, the default behaviour is equal to 'inode'.

So will "-o dax=inode" be used for per file DAX where dax mode comes
from server?

I think we discussed this. It will be better to leave "-o dax=inode"
alone. It should be used when we are reading dax status from file
attr (like ext4 and xfs). 

And probably create separate option say "-o dax=server" where server
specifies which inode should use dax.

Otherwise it will be very confusing. People familiar with "-o dax=inode"
on ext4/xfs will expect file attr to work and that's not what we
are implementing, IIUC.

Vivek

>

> By the time this patch is applied, 'inode' mode is actually equal to
> 'always' mode, before the per-file DAX flag is introduced in the
> following patch.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  fs/fuse/dax.c       |  9 +++++++--
>  fs/fuse/fuse_i.h    | 14 ++++++++++++--
>  fs/fuse/inode.c     | 10 +++++++---
>  fs/fuse/virtio_fs.c | 16 ++++++++++++++--
>  4 files changed, 40 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
> index 28db96ea23e2..e87ddded38c7 100644
> --- a/fs/fuse/dax.c
> +++ b/fs/fuse/dax.c
> @@ -1282,11 +1282,14 @@ static int fuse_dax_mem_range_init(struct fuse_conn_dax *fcd)
>  	return ret;
>  }
>  
> -int fuse_dax_conn_alloc(struct fuse_conn *fc, struct dax_device *dax_dev)
> +int fuse_dax_conn_alloc(struct fuse_conn *fc, enum fuse_dax_mode dax_mode,
> +			struct dax_device *dax_dev)
>  {
>  	struct fuse_conn_dax *fcd;
>  	int err;
>  
> +	fc->dax_mode = dax_mode;
> +
>  	if (!dax_dev)
>  		return 0;
>  
> @@ -1333,8 +1336,10 @@ static const struct address_space_operations fuse_dax_file_aops  = {
>  static bool fuse_should_enable_dax(struct inode *inode)
>  {
>  	struct fuse_conn *fc = get_fuse_conn(inode);
> +	unsigned int dax_mode = fc->dax_mode;
>  
> -	if (!fc->dax)
> +	/* If 'dax=always/inode', fc->dax couldn't be NULL */
> +	if (dax_mode == FUSE_DAX_NEVER)
>  		return false;
>  
>  	return true;
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 319596df5dc6..5abf9749923f 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -480,6 +480,12 @@ struct fuse_dev {
>  	struct list_head entry;
>  };
>  
> +enum fuse_dax_mode {
> +	FUSE_DAX_INODE,
> +	FUSE_DAX_ALWAYS,
> +	FUSE_DAX_NEVER,
> +};
> +
>  struct fuse_fs_context {
>  	int fd;
>  	struct file *file;
> @@ -497,7 +503,7 @@ struct fuse_fs_context {
>  	bool no_control:1;
>  	bool no_force_umount:1;
>  	bool legacy_opts_show:1;
> -	bool dax:1;
> +	enum fuse_dax_mode dax_mode;
>  	unsigned int max_read;
>  	unsigned int blksize;
>  	const char *subtype;
> @@ -802,6 +808,9 @@ struct fuse_conn {
>  	struct list_head devices;
>  
>  #ifdef CONFIG_FUSE_DAX
> +	/* dax mode: FUSE_DAX_* (always, never or per-file) */
> +	enum fuse_dax_mode dax_mode;
> +
>  	/* Dax specific conn data, non-NULL if DAX is enabled */
>  	struct fuse_conn_dax *dax;
>  #endif
> @@ -1255,7 +1264,8 @@ ssize_t fuse_dax_read_iter(struct kiocb *iocb, struct iov_iter *to);
>  ssize_t fuse_dax_write_iter(struct kiocb *iocb, struct iov_iter *from);
>  int fuse_dax_mmap(struct file *file, struct vm_area_struct *vma);
>  int fuse_dax_break_layouts(struct inode *inode, u64 dmap_start, u64 dmap_end);
> -int fuse_dax_conn_alloc(struct fuse_conn *fc, struct dax_device *dax_dev);
> +int fuse_dax_conn_alloc(struct fuse_conn *fc, enum fuse_dax_mode mode,
> +			struct dax_device *dax_dev);
>  void fuse_dax_conn_free(struct fuse_conn *fc);
>  bool fuse_dax_inode_alloc(struct super_block *sb, struct fuse_inode *fi);
>  void fuse_dax_inode_init(struct inode *inode);
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 36cd03114b6d..b4b41683e97e 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -742,8 +742,12 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
>  			seq_printf(m, ",blksize=%lu", sb->s_blocksize);
>  	}
>  #ifdef CONFIG_FUSE_DAX
> -	if (fc->dax)
> -		seq_puts(m, ",dax");
> +	if (fc->dax_mode == FUSE_DAX_ALWAYS)
> +		seq_puts(m, ",dax=always");
> +	else if (fc->dax_mode == FUSE_DAX_NEVER)
> +		seq_puts(m, ",dax=never");
> +	else if (fc->dax_mode == FUSE_DAX_INODE)
> +		seq_puts(m, ",dax=inode");
>  #endif
>  
>  	return 0;
> @@ -1493,7 +1497,7 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
>  	sb->s_subtype = ctx->subtype;
>  	ctx->subtype = NULL;
>  	if (IS_ENABLED(CONFIG_FUSE_DAX)) {
> -		err = fuse_dax_conn_alloc(fc, ctx->dax_dev);
> +		err = fuse_dax_conn_alloc(fc, ctx->dax_mode, ctx->dax_dev);
>  		if (err)
>  			goto err;
>  	}
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 0ad89c6629d7..58cfbaeb4a7d 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -88,12 +88,21 @@ struct virtio_fs_req_work {
>  static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
>  				 struct fuse_req *req, bool in_flight);
>  
> +static const struct constant_table dax_param_enums[] = {
> +	{"inode",	FUSE_DAX_INODE },
> +	{"always",	FUSE_DAX_ALWAYS },
> +	{"never",	FUSE_DAX_NEVER },
> +	{}
> +};
> +
>  enum {
>  	OPT_DAX,
> +	OPT_DAX_ENUM,
>  };
>  
>  static const struct fs_parameter_spec virtio_fs_parameters[] = {
>  	fsparam_flag("dax", OPT_DAX),
> +	fsparam_enum("dax", OPT_DAX_ENUM, dax_param_enums),
>  	{}
>  };
>  
> @@ -110,7 +119,10 @@ static int virtio_fs_parse_param(struct fs_context *fsc,
>  
>  	switch (opt) {
>  	case OPT_DAX:
> -		ctx->dax = 1;
> +		ctx->dax_mode = FUSE_DAX_ALWAYS;
> +		break;
> +	case OPT_DAX_ENUM:
> +		ctx->dax_mode = result.uint_32;
>  		break;
>  	default:
>  		return -EINVAL;
> @@ -1326,7 +1338,7 @@ static int virtio_fs_fill_super(struct super_block *sb, struct fs_context *fsc)
>  
>  	/* virtiofs allocates and installs its own fuse devices */
>  	ctx->fudptr = NULL;
> -	if (ctx->dax) {
> +	if (ctx->dax_mode != FUSE_DAX_NEVER) {
>  		if (!fs->dax_dev) {
>  			err = -EINVAL;
>  			pr_err("virtio-fs: dax can't be enabled as filesystem"
> -- 
> 2.27.0
> 

