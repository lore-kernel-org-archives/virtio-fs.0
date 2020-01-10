Date: Fri, 10 Jan 2020 17:38:48 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200110173848.GM3901@work-vm>
References: <20191218200833.10368-1-msys.mizuma@gmail.com>
	<20191218200833.10368-2-msys.mizuma@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218200833.10368-2-msys.mizuma@gmail.com>
Subject: Re: [Virtio-fs] [PATCH 1/3] virtiofsd: add some options to the help
 message
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

* Masayoshi Mizuma (msys.mizuma@gmail.com) wrote:
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> 
> Add following options to the help message:
> - cache
> - flock|no_flock
> - norace
> - posix_lock|no_posix_lock
> - readdirplus|no_readdirplus
> - timeout
> - writeback|no_writeback
> - xattr|no_xattr
> 
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

Thanks, I've split this up, so where the option was added by one of our
own patches, that patch now includes the update to this function.
Which leaves just flock, timeout, writeback, and xattr in this patch.

> ---
>  tools/virtiofsd/helper.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
> index bcb8c05063..339d806e7c 100644
> --- a/tools/virtiofsd/helper.c
> +++ b/tools/virtiofsd/helper.c
> @@ -147,15 +147,35 @@ void fuse_cmdline_help(void)
>             "    -f                         foreground operation\n"
>             "    --daemonize                run in background\n"
>             "    -s                         disable multi-threaded operation\n"
> +           "    -o cache=<mode>            cache mode. could be one of \"auto, "
> +           "always, none\"\n"
> +           "                               default: auto\n"
>             "    -o clone_fd                use separate fuse device fd for "
>             "each thread\n"
>             "                               (may improve performance)\n"
> +           "    -o flock|no_flock          enable/disable flock\n"
> +           "                               default: no_flock\n"
> +           "    -o log_level=<level>       log level, default to \"info\"\n"
> +           "                               level could be one of \"debug, "
> +           "info, warn, err\"\n"
>             "    -o max_idle_threads        the maximum number of idle worker "
>             "threads\n"
>             "                               allowed (default: 10)\n"
> -           "    -o log_level=<level>       log level, default to \"info\"\n"
> -           "                               level could be one of \"debug, "
> -           "info, warn, err\"\n");
> +           "    -o norace                  disable racy fallback\n"
> +           "                               default: false\n"
> +           "    -o posix_lock|no_posix_lock\n"
> +           "                               enable/disable remote posix lock\n"
> +           "                               default: posix_lock\n"
> +           "    -o readdirplus|no_readdirplus\n"
> +           "                               enable/disable readirplus\n"
> +           "                               default: readdirplus\n"
> +           "    -o timeout=<number>        I/O timeout (second)\n"
> +           "                               default: depends on cache= option.\n"
> +           "    -o writeback|no_writeback  enable/disable writeback cache\n"
> +           "                               default: no_writeback\n"
> +           "    -o xattr|no_xattr          enable/disable xattr\n"
> +           "                               default: no_xattr\n"
> +           );
>  }
>  
>  static int fuse_helper_opt_proc(void *data, const char *arg, int key,
> -- 
> 2.18.1
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

