Date: Tue, 7 Dec 2021 11:00:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <Ya+FIsGgn4wsYG+4@redhat.com>
References: <20211125070530.79602-1-jefflexu@linux.alibaba.com>
	<20211125070530.79602-7-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125070530.79602-7-jefflexu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH v8 6/7] fuse: mark inode DONT_CACHE when per
 inode DAX hint changes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, joseph.qi@linux.alibaba.com, miklos@szeredi.hu

On Thu, Nov 25, 2021 at 03:05:29PM +0800, Jeffle Xu wrote:
> When the per inode DAX hint changes while the file is still *opened*, it
> is quite complicated and maybe fragile to dynamically change the DAX
> state.
> 
> Hence mark the inode and corresponding dentries as DONE_CACHE once the
> per inode DAX hint changes, so that the inode instance will be evicted
> and freed as soon as possible once the file is closed and the last
> reference to the inode is put. And then when the file gets reopened next
> time, the new instantiated inode will reflect the new DAX state.
> 
> In summary, when the per inode DAX hint changes for an *opened* file, the
> DAX state of the file won't be updated until this file is closed and
> reopened later.

Is this true for cache=always mode as well? If inode continues to be
cached in guest cache, I am assuming we will not refresh inode attrs
due to cache=always mode and will not get new DAX state from server.

IOW, changing DAX state of file is combination of two things.

A. Client comes to know about it using GETATTR.
B. Once client knows about updated state, it will take affect when
   existing inode is released and new inode is instantiated.

And step A might take time depending on cache mode as well as when
is GETATTR actually initiated by the client. Its not deterministic
and can't be guaranteed. Right?

Vivek

> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  fs/fuse/dax.c    | 9 +++++++++
>  fs/fuse/fuse_i.h | 1 +
>  fs/fuse/inode.c  | 3 +++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
> index 234c2278420f..b19e7eaed4ef 100644
> --- a/fs/fuse/dax.c
> +++ b/fs/fuse/dax.c
> @@ -1363,6 +1363,15 @@ void fuse_dax_inode_init(struct inode *inode, unsigned int flags)
>  	inode->i_data.a_ops = &fuse_dax_file_aops;
>  }
>  
> +void fuse_dax_dontcache(struct inode *inode, unsigned int flags)
> +{
> +	struct fuse_conn *fc = get_fuse_conn(inode);
> +
> +	if (fuse_is_inode_dax_mode(fc->dax_mode) &&
> +	    (!!IS_DAX(inode) != !!(flags & FUSE_ATTR_DAX)))
> +		d_mark_dontcache(inode);
> +}
> +
>  bool fuse_dax_check_alignment(struct fuse_conn *fc, unsigned int map_alignment)
>  {
>  	if (fc->dax && (map_alignment > FUSE_DAX_SHIFT)) {
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 83970723314a..af19d1d821ea 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -1293,6 +1293,7 @@ void fuse_dax_conn_free(struct fuse_conn *fc);
>  bool fuse_dax_inode_alloc(struct super_block *sb, struct fuse_inode *fi);
>  void fuse_dax_inode_init(struct inode *inode, unsigned int flags);
>  void fuse_dax_inode_cleanup(struct inode *inode);
> +void fuse_dax_dontcache(struct inode *inode, unsigned int flags);
>  bool fuse_dax_check_alignment(struct fuse_conn *fc, unsigned int map_alignment);
>  void fuse_dax_cancel_work(struct fuse_conn *fc);
>  
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index b26612fce6d0..b25d99eb8411 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -301,6 +301,9 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
>  		if (inval)
>  			invalidate_inode_pages2(inode->i_mapping);
>  	}
> +
> +	if (IS_ENABLED(CONFIG_FUSE_DAX))
> +		fuse_dax_dontcache(inode, attr->flags);
>  }
>  
>  static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr)
> -- 
> 2.27.0
> 

