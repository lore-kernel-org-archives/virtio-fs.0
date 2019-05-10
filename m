Date: Fri, 10 May 2019 11:24:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190510152427.GB15465@redhat.com>
References: <20190510102957.8705-1-tao.peng@linux.alibaba.com>
	<20190510102957.8705-2-tao.peng@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510102957.8705-2-tao.peng@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH 1/2] fuse: remove unnecessary
	allocated_ranges
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Peng Tao <tao.peng@linux.alibaba.com>
Cc: virtio-fs@redhat.com

On Fri, May 10, 2019 at 06:29:56PM +0800, Peng Tao wrote:
> It is always nr_ranges.

This looks like a good cleanup. Will squash it with existing patches.

Vivek

> 
> Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> ---
>  fs/fuse/inode.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index dd16c7f6a561..cb56572c4b26 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -640,7 +640,7 @@ static int fuse_dax_mem_range_init(struct fuse_conn *fc,
>  	phys_addr_t phys_addr;
>  	int ret = 0, id;
>  	size_t dax_size = -1;
> -	unsigned long allocated_ranges = 0, i;
> +	unsigned long i;
>  
>  	id = dax_read_lock();
>  	nr_pages = dax_direct_access(dax_dev, 0, PHYS_PFN(dax_size), &kaddr,
> @@ -670,12 +670,11 @@ static int fuse_dax_mem_range_init(struct fuse_conn *fc,
>  		range->length = FUSE_DAX_MEM_RANGE_SZ;
>  		list_add_tail(&range->list, &mem_ranges);
>  		INIT_LIST_HEAD(&range->busy_list);
> -		allocated_ranges++;
>  	}
>  
>  	list_replace_init(&mem_ranges, &fc->free_ranges);
> -	fc->nr_free_ranges = allocated_ranges;
> -	fc->nr_ranges = allocated_ranges;
> +	fc->nr_free_ranges = nr_ranges;
> +	fc->nr_ranges = nr_ranges;
>  	return 0;
>  out_err:
>  	/* Free All allocated elements */
> -- 
> 2.17.1
> 

