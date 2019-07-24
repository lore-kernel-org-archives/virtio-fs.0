Date: Wed, 24 Jul 2019 16:29:27 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190724232927.wzjx6rihcqr44vug@US-160370MP2.local>
References: <20190724211024.GA31096@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724211024.GA31096@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: During setup mapping,
 open file O_RDWR only if needed
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Wed, Jul 24, 2019 at 05:10:24PM -0400, Vivek Goyal wrote:
> As of now we always open file O_RDWR (even if writable mappings are not
> required). This leads to copy up of file if file is backed by overlayfs
> and hence nullying advantages of overlayfs.
> 
> So open file O_RDONLY if writable mappings are not required. Open O_RDWR
> if writable mappings are needed.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  contrib/virtiofsd/passthrough_ll.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> Index: qemu/contrib/virtiofsd/passthrough_ll.c
> ===================================================================
> --- qemu.orig/contrib/virtiofsd/passthrough_ll.c	2019-07-24 16:31:07.014871768 -0400
> +++ qemu/contrib/virtiofsd/passthrough_ll.c	2019-07-24 16:32:10.064412722 -0400
> @@ -2197,15 +2197,15 @@ static void lo_setupmapping(fuse_req_t r
>          VhostUserFSSlaveMsg msg = { 0 };
>          uint64_t vhu_flags;
>  	char *buf;
> +	bool writable = flags & FUSE_SETUPMAPPING_FLAG_WRITE;

typo? flags is set to O_WRONLY or 0 in do_lookup, although this may work as same.

thanks,
-liubo
>  
>  	if (lo_debug(req))
>  		fuse_debug("lo_setupmapping(ino=%" PRIu64 ", fi=0x%p)\n", ino,
>  			   (void *)fi);
>  
>          vhu_flags = VHOST_USER_FS_FLAG_MAP_R;
> -        if (flags & O_WRONLY) {
> +	if (writable)
>                  vhu_flags |= VHOST_USER_FS_FLAG_MAP_W;
> -        }
>  
>  	msg.fd_offset[0] = foffset;
>  	msg.len[0] = len;
> @@ -2223,7 +2223,10 @@ static void lo_setupmapping(fuse_req_t r
>  		 * TODO: O_RDWR might not be allowed if file is read only or
>  		 * write only. Fix it.
>  		 */
> -		fd = openat(lo->proc_self_fd, buf, O_RDWR);
> +		if (writable)
> +			fd = openat(lo->proc_self_fd, buf, O_RDWR);
> +		else
> +			fd = openat(lo->proc_self_fd, buf, O_RDONLY);
>  		free(buf);
>  		if (fd == -1)
>  			return (void) fuse_reply_err(req, errno);

