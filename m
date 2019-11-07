Date: Thu, 7 Nov 2019 10:52:27 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191107105227.GD2816@work-vm>
References: <20191106190602.14522-1-msys.mizuma@gmail.com>
	<20191106190602.14522-3-msys.mizuma@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106190602.14522-3-msys.mizuma@gmail.com>
Subject: Re: [Virtio-fs] [PATCH 2/2] virtiofsd: Add timestamp to the log
 with FUSE_LOG_DEBUG level
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
> virtiofsd has some threads, so we see a lot of logs with debug option.
> It would be useful for debugging if we can see the timestamp.
> 
> Add nano second timestamp, which got by get_clock(), to the log with
> FUSE_LOG_DEBUG level if the syslog option isn't set.
> 
> The log is like as:
> 
>   ]# ./virtiofsd -d -o vhost_user_socket=/tmp/vhostqemu0 -o source=/tmp/share0 -o cache=auto
>   ...
>   [5365943125463727] [ID: 00000002] fv_queue_thread: Start for queue 0 kick_fd 9
>   [5365943125568644] [ID: 00000002] fv_queue_thread: Waiting for Queue 0 event
>   [5365943125573561] [ID: 00000002] fv_queue_thread: Got queue event on Queue 0
> 
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  contrib/virtiofsd/passthrough_ll.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index 0e85d5ea74..406f62ab37 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -37,6 +37,8 @@
>  #include "fuse_virtio.h"
>  #include "fuse_lowlevel.h"
>  #include "fuse_log.h"
> +#include "qemu/osdep.h"
> +#include "qemu/timer.h"
>  #include <unistd.h>
>  #include <stdlib.h>
>  #include <stdio.h>
> @@ -2856,9 +2858,14 @@ static void log_func(enum fuse_log_level level,
>  	if (current_log_level < level)
>  		return;
>  
> -	if (current_log_level == FUSE_LOG_DEBUG)
> -		fmt = g_strdup_printf("[ID: %08ld] %s",
> +	if (current_log_level == FUSE_LOG_DEBUG) {
> +		if (!use_syslog)
> +			fmt = g_strdup_printf("[%ld] [ID: %08ld] %s",
> +				get_clock(), syscall(__NR_gettid), _fmt);
> +		else
> +			fmt = g_strdup_printf("[ID: %08ld] %s",
>  				syscall(__NR_gettid), _fmt);
> +	}
>  
>  	if (use_syslog) {
>  		int priority = LOG_ERR;
> -- 
> 2.18.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

