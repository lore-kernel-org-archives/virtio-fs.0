Date: Fri, 2 Aug 2019 16:06:58 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190802230657.qdg7evgmx7bsuiss@US-160370MP2.local>
References: <1564744343-8087-1-git-send-email-tao.peng@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564744343-8087-1-git-send-email-tao.peng@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: do not always set
	FUSE_FLOCK_LOCKS
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Peng Tao <tao.peng@linux.alibaba.com>
Cc: virtio-fs@redhat.com

On Fri, Aug 02, 2019 at 07:12:23PM +0800, Peng Tao wrote:
> Right now we always enable it regardless of given commandlines.
> Fix it by setting the flag relying on the lo->flock bit.
>

Good catch.

Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

thanks,
-liubo
> Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> ---
>  contrib/virtiofsd/passthrough_ll.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index a81c01d..be75cb8 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -440,10 +440,16 @@ static void lo_init(void *userdata,
>  			fuse_debug("lo_init: activating writeback\n");
>  		conn->want |= FUSE_CAP_WRITEBACK_CACHE;
>  	}
> -	if (lo->flock && conn->capable & FUSE_CAP_FLOCK_LOCKS) {
> -		if (lo->debug)
> -			fuse_debug("lo_init: activating flock locks\n");
> -		conn->want |= FUSE_CAP_FLOCK_LOCKS;
> +	if (conn->capable & FUSE_CAP_FLOCK_LOCKS) {
> +		if (lo->flock) {
> +			if (lo->debug)
> +				fuse_debug("lo_init: activating flock locks\n");
> +			conn->want |= FUSE_CAP_FLOCK_LOCKS;
> +		} else {
> +			if (lo->debug)
> +				fuse_debug("lo_init: disabling flock locks\n");
> +			conn->want &= ~FUSE_CAP_FLOCK_LOCKS;
> +		}
>  	}
>  	/* TODO: shared version support for readdirplus */
>  
> -- 
> 1.8.3.1

