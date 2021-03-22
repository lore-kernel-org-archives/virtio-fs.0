Date: Mon, 22 Mar 2021 16:48:17 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YFjKUcuMTf44oGMk@work-vm>
References: <20210318154157.1357224-1-ckuehl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318154157.1357224-1-ckuehl@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] MAINTAINERS: add virtio-fs mailing list
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Connor Kuehl <ckuehl@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* Connor Kuehl (ckuehl@redhat.com) wrote:
> General discussion and patch reviews take place on this list for both
> virtiofsd (tools/virtiofsd/*) and the guest kernel module.
> 
> Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 25fc49d1dc..8921bc2119 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1917,6 +1917,7 @@ F: tools/virtiofsd/*
>  F: hw/virtio/vhost-user-fs*
>  F: include/hw/virtio/vhost-user-fs.h
>  F: docs/tools/virtiofsd.rst
> +L: virtio-fs@redhat.com

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

>  
>  virtio-input
>  M: Gerd Hoffmann <kraxel@redhat.com>
> -- 
> 2.30.2
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

