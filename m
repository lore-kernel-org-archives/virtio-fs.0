Date: Tue, 18 May 2021 13:26:45 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YKOyhfMDmahKOxsj@work-vm>
References: <20210511213736.281016-1-vgoyal@redhat.com>
	<20210511213736.281016-6-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511213736.281016-6-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 5/7] virtiofsd: Simplify skip byte logic
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Vivek Goyal (vgoyal@redhat.com) wrote:
> We need to skip bytes in two cases.
> 
> a. Before we start reading into in_sg, we need to skip iov_len bytes
>    in the beginning which typically will have fuse_out_header.
> 
> b. If preadv() does a short read, then we need to retry preadv() with
>    remainig bytes and skip the bytes preadv() read in short read.
> 
> For case a, there is no reason that skipping logic be inside the while
> loop. Move it outside. And only retain logic "b" inside while loop.
> 
> Also get rid of variable "skip_size". Looks like we can do without it.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Yep, now iov_discard_front makes it easy to skip.


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  tools/virtiofsd/fuse_virtio.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index ccad2b3f8a..434fe401cf 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -392,17 +392,11 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
>      unsigned int in_sg_cpy_count = in_num;
>  
>      /* skip over parts of in_sg that contained the header iov */
> -    size_t skip_size = iov_len;
> +    iov_discard_front(&in_sg_ptr, &in_sg_cpy_count, iov_len);
>  
>      do {
> -        if (skip_size != 0) {
> -	    iov_discard_front(&in_sg_ptr, &in_sg_cpy_count, skip_size);
> -        }
> -
> -        fuse_log(FUSE_LOG_DEBUG,
> -                 "%s: after skip skip_size=%zd in_sg_cpy_count=%d "
> -                 "len remaining=%zd\n", __func__, skip_size, in_sg_cpy_count,
> -                 len);
> +        fuse_log(FUSE_LOG_DEBUG, "%s: in_sg_cpy_count=%d len remaining=%zd\n",
> +                 __func__, in_sg_cpy_count, len);
>  
>          ret = preadv(buf->buf[0].fd, in_sg_ptr, in_sg_cpy_count,
>                       buf->buf[0].pos);
> @@ -421,7 +415,7 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
>          if (ret < len && ret) {
>              fuse_log(FUSE_LOG_DEBUG, "%s: ret < len\n", __func__);
>              /* Skip over this much next time around */
> -            skip_size = ret;
> +            iov_discard_front(&in_sg_ptr, &in_sg_cpy_count, ret);
>              buf->buf[0].pos += ret;
>              len -= ret;
>  
> -- 
> 2.25.4
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

