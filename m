Date: Tue, 3 Sep 2019 18:29:30 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190903172930.GT2744@work-vm>
References: <20190827095437.18819-1-stefanha@redhat.com>
	<20190827095437.18819-4-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827095437.18819-4-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 3/4] virtiofsd: install virtiofsd in libexec
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> Build and install virtiofsd on Linux hosts.  This is also how
> vhost-user-gpu is handled.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index a3dfdd6fa8..ef6eca07cc 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -317,6 +317,8 @@ HELPERS-y =
>  HELPERS-$(call land,$(CONFIG_SOFTMMU),$(CONFIG_LINUX)) = qemu-bridge-helper$(EXESUF)
>  
>  ifdef CONFIG_LINUX
> +HELPERS-y += virtiofsd$(EXESUF)
> +
>  ifdef CONFIG_VIRGL
>  ifdef CONFIG_GBM
>  HELPERS-y += vhost-user-gpu$(EXESUF)
> -- 
> 2.21.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

