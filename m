Date: Tue, 3 Sep 2019 18:26:44 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190903172644.GS2744@work-vm>
References: <20190827095437.18819-1-stefanha@redhat.com>
	<20190827095437.18819-3-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827095437.18819-3-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/4] virtiofsd: add --print-capabilities
	option
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
> Add the --print-capabilities option as per vhost-user.rst "Backend
> programs conventions".  Currently there are no advertised features.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

That looks OK to me, but can someone who understands the json
requirement explain what says whether a 'features' entry is optional?

Dave

> ---
>  docs/interop/vhost-user.json       |  4 +++-
>  contrib/virtiofsd/fuse_lowlevel.h  |  1 +
>  contrib/virtiofsd/helper.c         |  2 ++
>  contrib/virtiofsd/passthrough_ll.c | 12 ++++++++++++
>  4 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/docs/interop/vhost-user.json b/docs/interop/vhost-user.json
> index da6aaf51c8..d4ea1f7ac5 100644
> --- a/docs/interop/vhost-user.json
> +++ b/docs/interop/vhost-user.json
> @@ -31,6 +31,7 @@
>  # @rproc-serial: virtio remoteproc serial link
>  # @scsi: virtio scsi
>  # @vsock: virtio vsock transport
> +# @fs: virtio fs (since 4.2)
>  #
>  # Since: 4.0
>  ##
> @@ -50,7 +51,8 @@
>        'rpmsg',
>        'rproc-serial',
>        'scsi',
> -      'vsock'
> +      'vsock',
> +      'fs'
>    ]
>  }
>  
> diff --git a/contrib/virtiofsd/fuse_lowlevel.h b/contrib/virtiofsd/fuse_lowlevel.h
> index b441d3dfed..e3d8747571 100644
> --- a/contrib/virtiofsd/fuse_lowlevel.h
> +++ b/contrib/virtiofsd/fuse_lowlevel.h
> @@ -1796,6 +1796,7 @@ struct fuse_cmdline_opts {
>  	int nodefault_subtype;
>  	int show_version;
>  	int show_help;
> +	int print_capabilities;
>  	int clone_fd;
>  	int syslog;
>  	int log_level;
> diff --git a/contrib/virtiofsd/helper.c b/contrib/virtiofsd/helper.c
> index 8d8bca889b..84bf1c834d 100644
> --- a/contrib/virtiofsd/helper.c
> +++ b/contrib/virtiofsd/helper.c
> @@ -35,6 +35,7 @@ static const struct fuse_opt fuse_helper_opts[] = {
>  	FUSE_HELPER_OPT("--help",	show_help),
>  	FUSE_HELPER_OPT("-V",		show_version),
>  	FUSE_HELPER_OPT("--version",	show_version),
> +	FUSE_HELPER_OPT("--print-capabilities", print_capabilities),
>  	FUSE_HELPER_OPT("-d",		debug),
>  	FUSE_HELPER_OPT("debug",	debug),
>  	FUSE_HELPER_OPT("-d",		foreground),
> @@ -137,6 +138,7 @@ void fuse_cmdline_help(void)
>  {
>  	printf("    -h   --help                print help\n"
>  	       "    -V   --version             print version\n"
> +	       "    --print-capabilities       print vhost-user.json\n"
>  	       "    -d   -o debug              enable debug output (implies -f)\n"
>  	       "    --syslog                   log to syslog (default stderr)\n"
>  	       "    -f                         foreground operation\n"
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index 0ef01b7e3f..e2e20f22cd 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -2879,6 +2879,14 @@ static void fuse_lo_data_cleanup(struct lo_data *lo)
>          free((char *)lo->source);
>  }
>  
> +/* Print vhost-user.json backend program capabilities */
> +static void print_capabilities(void)
> +{
> +	printf("{\n");
> +	printf("  \"type\": \"fs\"\n");
> +	printf("}\n");
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
> @@ -2931,6 +2939,10 @@ int main(int argc, char *argv[])
>  		fuse_lowlevel_version();
>  		ret = 0;
>  		goto err_out1;
> +	} else if (opts.print_capabilities) {
> +		print_capabilities();
> +		ret = 0;
> +		goto err_out1;
>  	}
>  
>  	if (fuse_opt_parse(&args, &lo, lo_opts, NULL)== -1)
> -- 
> 2.21.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

