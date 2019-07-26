Date: Fri, 26 Jul 2019 14:26:14 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190726212613.24lionrtvt3kz2g3@US-160370MP2.local>
References: <20190726091103.23503-1-stefanha@redhat.com>
	<20190726091103.23503-3-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726091103.23503-3-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/5] virtiofsd: prevent lo_lookup() NULL
 pointer	dereference
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Fri, Jul 26, 2019 at 10:11:00AM +0100, Stefan Hajnoczi wrote:
> Most lo_do_lookup() have already checked that the parent inode exists.
> lo_lookup() hasn't and can therefore hit a NULL pointer dereference when
> lo_inode(req, parent) returns NULL.
>

Sigh...this one has been fixed by 3 different developers...Me, Pengtao and Stefan.

The following one on the ML did the exactly same thing.
---
Subject: [Virtio-fs] [PATCH] virtiofsd: fix lo_do_lookup panic

It needs to check for invalid parent dir.

Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
---

thanks,
-liubo

> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  contrib/virtiofsd/passthrough_ll.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index 9ae1381618..277a17fc03 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -766,6 +766,10 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
>  	struct lo_data *lo = lo_data(req);
>  	struct lo_inode *inode, *dir = lo_inode(req, parent);
>  
> +	if (!dir) {
> +		return EBADF;
> +	}
> +
>  	memset(e, 0, sizeof(*e));
>  	e->attr_timeout = lo->timeout;
>  	e->entry_timeout = lo->timeout;
> -- 
> 2.21.0
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

