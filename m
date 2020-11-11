Date: Wed, 11 Nov 2020 19:59:01 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201111195901.GQ3232@work-vm>
References: <3477d902-ace9-1aa1-531a-9d20d6e93a05@huawei.com>
	<29fc87c2-b87c-4c34-40d4-75381f228849@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29fc87c2-b87c-4c34-40d4-75381f228849@huawei.com>
Subject: Re: [Virtio-fs] [PATCH 1/3] tools/virtiofsd/buffer.c: check whether
 buf is NULL in fuse_bufvec_advance func
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Haotian Li <lihaotian9@huawei.com>
Cc: virtio-fs@redhat.com, linfeilong@huawei.com, qemu-devel@nongnu.org

* Haotian Li (lihaotian9@huawei.com) wrote:
> In fuse_bufvec_advance func, calling fuse_bufvec_current func
> may return NULL, so we should check whether buf is NULL before
> using it.
> 
> Signed-off-by: Haotian Li <lihaotian9@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> ---
>  tools/virtiofsd/buffer.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/virtiofsd/buffer.c b/tools/virtiofsd/buffer.c
> index 27c1377f22..bdc608c221 100644
> --- a/tools/virtiofsd/buffer.c
> +++ b/tools/virtiofsd/buffer.c
> @@ -246,6 +246,10 @@ static int fuse_bufvec_advance(struct fuse_bufvec *bufv, size_t len)
>  {
>      const struct fuse_buf *buf = fuse_bufvec_current(bufv);
> 
> +    if (!buf) {
> +        return 0;
> +    }
> +

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

>      bufv->off += len;
>      assert(bufv->off <= buf->size);
>      if (bufv->off == buf->size) {
> -- 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

