Date: Tue, 3 Sep 2019 18:17:33 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190903171733.GR2744@work-vm>
References: <20190827095437.18819-1-stefanha@redhat.com>
	<20190827095437.18819-2-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827095437.18819-2-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/4] virtiofsd: make -f (foreground) the
	default
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
> According to vhost-user.rst "Backend program conventions", backend
> programs should run in the foregound by default.  Follow the
> conventions so libvirt and other management tools can control virtiofsd
> in a standard way.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  contrib/virtiofsd/helper.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/contrib/virtiofsd/helper.c b/contrib/virtiofsd/helper.c
> index 4c71452080..8d8bca889b 100644
> --- a/contrib/virtiofsd/helper.c
> +++ b/contrib/virtiofsd/helper.c
> @@ -42,6 +42,7 @@ static const struct fuse_opt fuse_helper_opts[] = {
>  	FUSE_OPT_KEY("-d",		FUSE_OPT_KEY_KEEP),
>  	FUSE_OPT_KEY("debug",		FUSE_OPT_KEY_KEEP),
>  	FUSE_HELPER_OPT("-f",		foreground),
> +	FUSE_HELPER_OPT_VALUE("--daemonize", foreground, 0),
>  	FUSE_HELPER_OPT("-s",		singlethread),
>  	FUSE_HELPER_OPT("fsname=",	nodefault_subtype),
>  	FUSE_OPT_KEY("fsname=",		FUSE_OPT_KEY_KEEP),
> @@ -139,6 +140,7 @@ void fuse_cmdline_help(void)
>  	       "    -d   -o debug              enable debug output (implies -f)\n"
>  	       "    --syslog                   log to syslog (default stderr)\n"
>  	       "    -f                         foreground operation\n"
> +	       "    --daemonize                run in background\n"
>  	       "    -s                         disable multi-threaded operation\n"
>  	       "    -o clone_fd                use separate fuse device fd for each thread\n"
>  	       "                               (may improve performance)\n"
> @@ -171,6 +173,7 @@ int fuse_parse_cmdline(struct fuse_args *args,
>  	memset(opts, 0, sizeof(struct fuse_cmdline_opts));
>  
>  	opts->max_idle_threads = 10;
> +	opts->foreground = 1;
>  
>  	if (fuse_opt_parse(args, opts, fuse_helper_opts,
>  			   fuse_helper_opt_proc) == -1)
> -- 
> 2.21.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

