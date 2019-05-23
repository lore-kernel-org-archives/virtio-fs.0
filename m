Date: Thu, 23 May 2019 16:52:36 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190523155236.GC2995@work-vm>
References: <1558573595-119159-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558573595-119159-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: fix multiple unmappable writes
 from writev in fuse
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com

* Liu Bo (bo.liu@linux.alibaba.com) wrote:
> Commit (a2c2817 virtiofsd: Parse unmappable elements) assumes that there
> is only one iovec in "out", which is not true if a writev with multiple
> write iovec is done from fuse.
> 
> This fills the gap.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Thanks! I've squashed this down into my 'Parse unmappable elements'

Dave

> ---
>  contrib/virtiofsd/fuse_virtio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
> index 8306ed5..cb46558 100644
> --- a/contrib/virtiofsd/fuse_virtio.c
> +++ b/contrib/virtiofsd/fuse_virtio.c
> @@ -557,7 +557,7 @@ static void *fv_queue_thread(void *opaque)
>                         if (bad_in_num || bad_out_num) {
>                             bool handled_unmappable = false;
>  
> -                           if (out_num > 2 && out_num_readable == 2 && !bad_in_num &&
> +                           if (out_num > 2 && out_num_readable >= 2 && !bad_in_num &&
>                                 out_sg[0].iov_len == sizeof(struct fuse_in_header) &&
>                                 ((struct fuse_in_header *)fbuf.mem)->opcode ==
>                                     FUSE_WRITE &&
> @@ -585,7 +585,7 @@ static void *fv_queue_thread(void *opaque)
>                                 for(; iovindex < out_num; iovindex++, pbufvindex++) {
>                                         pbufv->count++;
>                                         pbufv->buf[pbufvindex].pos = ~0; // Dummy
> -                                       pbufv->buf[pbufvindex].flags = FUSE_BUF_PHYS_ADDR;
> +                                       pbufv->buf[pbufvindex].flags = (iovindex < out_num_readable) ? 0 : FUSE_BUF_PHYS_ADDR;
>                                         pbufv->buf[pbufvindex].mem = out_sg[iovindex].iov_base;
>                                         pbufv->buf[pbufvindex].size = out_sg[iovindex].iov_len;
>                                 }
> -- 
> 1.8.3.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

