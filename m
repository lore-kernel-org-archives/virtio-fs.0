Date: Mon, 19 Aug 2019 11:15:37 +0800
From: Eryu Guan <eguan@linux.alibaba.com>
Message-ID: <20190819031537.GK52397@e18g06458.et15sqa>
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

IMHO, this is necessary, it seems that in the case cache=auto/always,
virtiofsd already follows what guest requests, i.e.  virtiofsd only does
direct I/O when guest opens file with O_DIRECT.

If I understand the code correctly, fi->direct_io = 1 is used to force
guest to use direct I/O even if guest opens file without O_DIRECT.

Thanks,
Eryu

>  }
> 
> -- 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

