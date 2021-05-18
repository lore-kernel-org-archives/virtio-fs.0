Date: Tue, 18 May 2021 13:19:18 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YKOwxme52qyg3e5O@work-vm>
References: <20210511213736.281016-1-vgoyal@redhat.com>
	<20210511213736.281016-5-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511213736.281016-5-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 4/7] virtiofsd: get rid of in_sg_left
	variable
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
> in_sg_left seems to be being used primarly for debugging purpose. It is
> keeping track of how many bytes are left in the scatter list we are
> reading into.
> 
> We already have another variable "len" which keeps track how many bytes
> are left to be read. And in_sg_left is greater than or equal to len. We
> have already ensured that in the beginning of function.
> 
>     if (in_len < tosend_len) {
>         fuse_log(FUSE_LOG_ERR, "%s: elem %d too small for data len %zd\n",
>                  __func__, elem->index, tosend_len);
>         ret = E2BIG;
>         goto err;
>     }
> 
> So in_sg_left seems like a redundant variable. It probably was useful for
> debugging when code was being developed. Get rid of it. It helps simplify
> this function.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  tools/virtiofsd/fuse_virtio.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index d56b225800..ccad2b3f8a 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -394,20 +394,16 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
>      /* skip over parts of in_sg that contained the header iov */
>      size_t skip_size = iov_len;
>  
> -    size_t in_sg_left = 0;
>      do {
>          if (skip_size != 0) {
>  	    iov_discard_front(&in_sg_ptr, &in_sg_cpy_count, skip_size);
>          }
>  
> -        int i;
> -        for (i = 0, in_sg_left = 0; i < in_sg_cpy_count; i++) {
> -            in_sg_left += in_sg_ptr[i].iov_len;
> -        }
>          fuse_log(FUSE_LOG_DEBUG,
>                   "%s: after skip skip_size=%zd in_sg_cpy_count=%d "
> -                 "in_sg_left=%zd\n",
> -                 __func__, skip_size, in_sg_cpy_count, in_sg_left);
> +                 "len remaining=%zd\n", __func__, skip_size, in_sg_cpy_count,
> +                 len);
> +
>          ret = preadv(buf->buf[0].fd, in_sg_ptr, in_sg_cpy_count,
>                       buf->buf[0].pos);
>  
> @@ -434,13 +430,12 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
>          }
>          if (!ret) {
>              /* EOF case? */
> -            fuse_log(FUSE_LOG_DEBUG, "%s: !ret in_sg_left=%zd\n", __func__,
> -                     in_sg_left);
> +            fuse_log(FUSE_LOG_DEBUG, "%s: !ret len remaining=%zd\n", __func__,
> +                     len);
>              break;
>          }
> -        in_sg_left -= ret;
>          len -= ret;
> -    } while (in_sg_left);
> +    } while (len);
>  
>      /* Need to fix out->len on EOF */
>      if (len) {
> -- 
> 2.25.4
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

