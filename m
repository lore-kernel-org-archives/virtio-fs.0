Date: Fri, 16 Aug 2019 16:52:23 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190816155223.GE2769@work-vm>
References: <5D56248A.5040000@huawei.com>
 <5D56261D.30902@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D56261D.30902@huawei.com>
Subject: Re: [Virtio-fs] [PATCH v6 2/2] virtiofsd: use fuse_buf_writev to
 replace fuse_buf_write for better performance
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

* piaojun (piaojun@huawei.com) wrote:
> fuse_buf_writev() only handles the normal write in which src is buffer
> and dest is fd. Specially if src buffer represents guest physical
> address that can't be mapped by the daemon process, IO must be bounced
> back to the VMM to do it by fuse_buf_copy().
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Suggested-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  contrib/virtiofsd/buffer.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/contrib/virtiofsd/buffer.c b/contrib/virtiofsd/buffer.c
> index 0ed284f..072b5dc 100644
> --- a/contrib/virtiofsd/buffer.c
> +++ b/contrib/virtiofsd/buffer.c
> @@ -322,11 +322,26 @@ static int fuse_bufvec_advance(struct fuse_bufvec *bufv, size_t len)
>  ssize_t fuse_buf_copy(fuse_req_t req, struct fuse_bufvec *dstv, struct fuse_bufvec *srcv,
>  		      enum fuse_buf_copy_flags flags)
>  {
> -	size_t copied = 0;
> +	size_t copied = 0, i;
> 
>  	if (dstv == srcv)
>  		return fuse_buf_size(dstv);
> 
> +	/* use writev to improve bandwidth when all the
> +	 * src buffers already mapped by the daemon
> +	 * process */
> +	for (i = 0; i < srcv->count; i++) {
> +		if ((srcv->buf[i].flags & FUSE_BUF_PHYS_ADDR) ||
> +		    (srcv->buf[i].flags & FUSE_BUF_IS_FD))
> +			break;
> +	}
> +	if ((i == srcv->count) && (dstv->count == 1) &&
> +	    (dstv->idx == 0) &&
> +	    (dstv->buf[0].flags & FUSE_BUF_IS_FD)) {
> +		dstv->buf[0].pos += dstv->off;
> +		return fuse_buf_writev(req, &dstv->buf[0], srcv);
> +	}
> +

OK, thanks, I think that's actually a strong enough check, so I'll merge
these now.


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

>  	for (;;) {
>  		const struct fuse_buf *src = fuse_bufvec_current(srcv);
>  		const struct fuse_buf *dst = fuse_bufvec_current(dstv);
> -- 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

