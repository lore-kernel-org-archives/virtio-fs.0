Date: Thu, 6 Jun 2019 10:33:37 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190606093337.GG2788@work-vm>
References: <1559695356-75503-1-git-send-email-bo.liu@linux.alibaba.com>
	<1559695356-75503-5-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559695356-75503-5-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH 4/5] virtiofsd: fix error handling in main()
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
> Neither fuse_parse_cmdline() nor fuse_opt_parse() goes to the right place
> to do cleanup.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  contrib/virtiofsd/passthrough_ll.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index e7e19dc..649991e 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -2243,7 +2243,8 @@ int main(int argc, char *argv[])
>  	lo_map_init(&lo.fd_map);
>  
>  	if (fuse_parse_cmdline(&args, &opts) != 0)
> -		return 1;
> +		goto err_out1;
> +
>  	if (opts.show_help) {
>  		printf("usage: %s [options]\n\n", argv[0]);
>  		fuse_cmdline_help();
> @@ -2258,7 +2259,7 @@ int main(int argc, char *argv[])
>  	}
>  
>  	if (fuse_opt_parse(&args, &lo, lo_opts, NULL)== -1)
> -		return 1;
> +		goto err_out1;
>  
>  	lo.debug = opts.debug;
>  	if (lo.source) {
> -- 
> 1.8.3.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

