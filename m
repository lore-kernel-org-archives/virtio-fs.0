Date: Wed, 22 Jul 2020 17:51:25 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200722165125.GJ2660@work-vm>
References: <20200722130206.224898-1-stefanha@redhat.com>
	<20200722130206.224898-2-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722130206.224898-2-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH for-5.1 1/3] virtiofsd: drop
	CAP_DAC_READ_SEARCH
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, rmohr@redhat.com, qemu-devel@nongnu.org, vromanso@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> virtiofsd does not need CAP_DAC_READ_SEARCH because it already has
> the more powerful CAP_DAC_OVERRIDE. Drop it from the list of
> capabilities.
> 
> This is important because container runtimes may not include
> CAP_DAC_READ_SEARCH by default. This patch allows virtiofsd to reduce
> its capabilities when running inside a Docker container.
> 
> Note that CAP_DAC_READ_SEARCH may be necessary again in the future if
> virtiofsd starts using open_by_handle_at(2).
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Yeh that seems to make sense, and is probably worth having irrespective
of the rest of the series.


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  tools/virtiofsd/passthrough_ll.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 94e0de2d2b..50a164a599 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2596,7 +2596,6 @@ static void setup_capabilities(char *modcaps_in)
>      if (capng_updatev(CAPNG_ADD, CAPNG_PERMITTED | CAPNG_EFFECTIVE,
>              CAP_CHOWN,
>              CAP_DAC_OVERRIDE,
> -            CAP_DAC_READ_SEARCH,
>              CAP_FOWNER,
>              CAP_FSETID,
>              CAP_SETGID,
> -- 
> 2.26.2
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

