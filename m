Date: Thu, 6 May 2021 20:07:39 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YJQ+ex2DUPYo1GV5@work-vm>
References: <20210506184304.321645-1-vgoyal@redhat.com>
	<20210506184304.321645-2-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506184304.321645-2-vgoyal@redhat.com>
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 1/2] virtiofs,
 dax: Fix smatch warning about loss of info during shift
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, miklos@szeredi.hu

* Vivek Goyal (vgoyal@redhat.com) wrote:
> Dan reported a smatch warning during potentential loss of info during
> left shift if this code is compiled on 32bit systems.
> 
> New smatch warnings:
> fs/fuse/dax.c:113 fuse_setup_one_mapping() warn: should 'start_idx << 21' be a
> +64 bit type?
> 
> I ran smatch and found two more instances of similar warning. This patch
> fixes all such instances.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/dax.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
> index ff99ab2a3c43..f06fdad3f7b1 100644
> --- a/fs/fuse/dax.c
> +++ b/fs/fuse/dax.c
> @@ -186,7 +186,7 @@ static int fuse_setup_one_mapping(struct inode *inode, unsigned long start_idx,
>  	struct fuse_conn_dax *fcd = fm->fc->dax;
>  	struct fuse_inode *fi = get_fuse_inode(inode);
>  	struct fuse_setupmapping_in inarg;
> -	loff_t offset = start_idx << FUSE_DAX_SHIFT;
> +	loff_t offset = (loff_t)start_idx << FUSE_DAX_SHIFT;

I've not followed the others back, but isn't it easier to change
the start_idx parameter to be a loff_t, since the places it's called
from are poth loff_t pos?

Dave

>  	FUSE_ARGS(args);
>  	ssize_t err;
>  
> @@ -872,7 +872,7 @@ static int dmap_writeback_invalidate(struct inode *inode,
>  				     struct fuse_dax_mapping *dmap)
>  {
>  	int ret;
> -	loff_t start_pos = dmap->itn.start << FUSE_DAX_SHIFT;
> +	loff_t start_pos = (loff_t)dmap->itn.start << FUSE_DAX_SHIFT;
>  	loff_t end_pos = (start_pos + FUSE_DAX_SZ - 1);
>  
>  	ret = filemap_fdatawrite_range(inode->i_mapping, start_pos, end_pos);
> @@ -966,7 +966,7 @@ inode_inline_reclaim_one_dmap(struct fuse_conn_dax *fcd, struct inode *inode,
>  	dmap = inode_lookup_first_dmap(inode);
>  	if (dmap) {
>  		start_idx = dmap->itn.start;
> -		dmap_start = start_idx << FUSE_DAX_SHIFT;
> +		dmap_start = (u64)start_idx << FUSE_DAX_SHIFT;
>  		dmap_end = dmap_start + FUSE_DAX_SZ - 1;
>  	}
>  	up_read(&fi->dax->sem);
> @@ -1118,7 +1118,7 @@ static int lookup_and_reclaim_dmap(struct fuse_conn_dax *fcd,
>  {
>  	int ret;
>  	struct fuse_inode *fi = get_fuse_inode(inode);
> -	loff_t dmap_start = start_idx << FUSE_DAX_SHIFT;
> +	loff_t dmap_start = (loff_t)start_idx << FUSE_DAX_SHIFT;
>  	loff_t dmap_end = (dmap_start + FUSE_DAX_SZ) - 1;
>  
>  	down_write(&fi->i_mmap_sem);
> -- 
> 2.25.4
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

