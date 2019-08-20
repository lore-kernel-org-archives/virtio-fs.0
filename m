Date: Tue, 20 Aug 2019 11:31:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190820153144.GB4233@redhat.com>
References: <5D53D882.5090803@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D53D882.5090803@huawei.com>
Subject: Re: [Virtio-fs] [PATCH][RFC] viriofsd: do not fall back to buffer
 io when cache=auto
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com

On Wed, Aug 14, 2019 at 05:46:42PM +0800, piaojun wrote:
> Direct io flags will be tured off even if cache=auto, which seems a
> little bit strange. It's better to keep the open flags set by user. If
> I missed the discussion about this issue, please let me know, thanks.

fi->direct_io and fi->keep_cache are controlling hints for guest kernel.
So for cache=none, we want to enforce direct I/O in guest hence we set
fi->direct_io (FOPEN_DIRECT_IO) in reply to guest.

For cache=always, we want to cache data and metadata hence we don't
set fi->direct_io. Also, we don't want to invalidate current cache
contents of file in guest hence we set fi->keep_cache (FOPEN_KEEP_CACHE)

For cache=auto, want guest kernel to cache data and metadata hence we
don't set fi->direct_io. We want guest kernel to invalidate data on 
next open hence we don't set fi->keep_cache. 

If guest is doing direct IO on file and fi->flags has O_DIRECT set, that
should not do anything to fi->direct_io. That's a hint for guest kernel
enforced by virtiofsd.

I am not sure what problem you are trying to solve with this patch.

Thanks
Vivek

> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> ---
>  contrib/virtiofsd/passthrough_ll.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index 321bbb2..a080f0d 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -1687,6 +1687,8 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>  		fi->direct_io = 1;
>  	else if (lo->cache == CACHE_ALWAYS)
>  		fi->keep_cache = 1;
> +	else
> +		fi->direct_io = !!(fi->flags & O_DIRECT);
> 
>  out:
>  	lo_inode_put(lo, &parent_inode);
> @@ -1899,6 +1901,8 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>  		fi->direct_io = 1;
>  	else if (lo->cache == CACHE_ALWAYS)
>  		fi->keep_cache = 1;
> +	else
> +		fi->direct_io = !!(fi->flags & O_DIRECT);
>  	fuse_reply_open(req, fi);
>  }
> 
> -- 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

