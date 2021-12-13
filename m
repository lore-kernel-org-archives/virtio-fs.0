Date: Mon, 13 Dec 2021 13:08:26 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YbeMGlULQP53bSlq@redhat.com>
References: <20211125070530.79602-1-jefflexu@linux.alibaba.com>
	<20211125070530.79602-2-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125070530.79602-2-jefflexu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH v8 1/7] fuse: add fuse_should_enable_dax()
	helper
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

On Thu, Nov 25, 2021 at 03:05:24PM +0800, Jeffle Xu wrote:
> This is in prep for following per inode DAX checking.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>

Reviewed-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
> ---
>  fs/fuse/dax.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
> index 5778ebfbce5e..4c48a57632bd 100644
> --- a/fs/fuse/dax.c
> +++ b/fs/fuse/dax.c
> @@ -1329,11 +1329,19 @@ static const struct address_space_operations fuse_dax_file_aops  = {
>  	.invalidatepage	= noop_invalidatepage,
>  };
>  
> -void fuse_dax_inode_init(struct inode *inode)
> +static bool fuse_should_enable_dax(struct inode *inode)
>  {
>  	struct fuse_conn *fc = get_fuse_conn(inode);
>  
>  	if (!fc->dax)
> +		return false;
> +
> +	return true;
> +}
> +
> +void fuse_dax_inode_init(struct inode *inode)
> +{
> +	if (!fuse_should_enable_dax(inode))
>  		return;
>  
>  	inode->i_flags |= S_DAX;
> -- 
> 2.27.0
> 

