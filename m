Date: Wed, 7 Aug 2019 10:21:42 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190807092142.GB13267@stefanha-x1.localdomain>
References: <5D4A7952.4010707@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D4A7952.4010707@huawei.com>
Subject: Re: [Virtio-fs] [PATCH v2 2/2][RFC] use fuse_buf_writev to replace
 fuse_buf_write for better performance
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

On Wed, Aug 07, 2019 at 03:10:10PM +0800, piaojun wrote:
> fuse_buf_writev() only handles the normal write in which src is buffer
> and dest is fd. Specially if src buffer represents guest physical
> address that can't be mapped by the daemon process, IO must be bounced
> back to the VMM to do it by fuse_buf_copy().
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Suggested-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  contrib/virtiofsd/passthrough_ll.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index cc9c175..c1bbc53 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -2023,7 +2023,10 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
>  		fuse_debug("lo_write_buf(ino=%" PRIu64 ", size=%zd, off=%lu)\n",
>  			   ino, out_buf.buf[0].size, (unsigned long) off);
> 
> -	res = fuse_buf_copy(req, &out_buf, in_buf, 0);
> +	if (!(in_buf->buf[0].flags & FUSE_BUF_PHYS_ADDR))
> +		res = fuse_buf_writev(req, &out_buf, in_buf, out_buf.buf[0].flags);
> +	else
> +		res = fuse_buf_copy(req, &out_buf, in_buf, 0);

Can you move the check inside fuse_buf_copy() and make fuse_buf_writev()
a static function?  This way all fuse_buf_copy() callers automatically
benefit from the improvement (when possible).

By the way, this improvement can be sent upstream to libfuse so that
other FUSE file systems also get improved performance.

Stefan

