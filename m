Return-Path: <dgilbert@redhat.com>
Date: Wed, 24 Aug 2022 12:05:38 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YwYGAuPjexuazlC2@work-vm>
References: <20220818184618.2205172-1-yokada.996@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20220818184618.2205172-1-yokada.996@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: use g_date_time_get_microsecond
 to get subsecond
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Yusuke Okada <yokada.996@gmail.com>, berrange@redhat.com, marcandre.lureau@redhat.com
Cc: qemu-devel@nongnu.org, Yusuke Okada <okada.yusuke@jp.fujitsu.com>, Stefan Hajnoczi <stefanha@redhat.com>, "open list:virtiofs" <virtio-fs@redhat.com>

* Yusuke Okada (yokada.996@gmail.com) wrote:
> From: Yusuke Okada <okada.yusuke@jp.fujitsu.com>
> 
> The "%f" specifier in g_date_time_format() is only available in glib
> 2.65.2 or later. If combined with older glib, the function returns null
> and the timestamp displayed as "(null)".

Well spotted; thanks for the patch.
I notice there's also a use in rocker and qga (Copying Dan and
Marc-Andre in who added them)

> For backward compatibility, g_date_time_get_microsecond should be used
> to retrieve subsecond.
> 
> In this patch the g_date_time_format() leaves subsecond field as "%06d"
> and let next snprintf to format with g_date_time_get_microsecond.
> 
> Signed-off-by: Yusuke Okada <okada.yusuke@jp.fujitsu.com>


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  tools/virtiofsd/passthrough_ll.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 371a7bead6..20f0f41f99 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -4185,6 +4185,7 @@ static void setup_nofile_rlimit(unsigned long rlimit_nofile)
>  static void log_func(enum fuse_log_level level, const char *fmt, va_list ap)
>  {
>      g_autofree char *localfmt = NULL;
> +    char buf[64];
>  
>      if (current_log_level < level) {
>          return;
> @@ -4197,9 +4198,11 @@ static void log_func(enum fuse_log_level level, const char *fmt, va_list ap)
>                                         fmt);
>          } else {
>              g_autoptr(GDateTime) now = g_date_time_new_now_utc();
> -            g_autofree char *nowstr = g_date_time_format(now, "%Y-%m-%d %H:%M:%S.%f%z");
> +            g_autofree char *nowstr = g_date_time_format(now,
> +                                       "%Y-%m-%d %H:%M:%S.%%06d%z");
> +            snprintf(buf, 64, nowstr, g_date_time_get_microsecond(now));
>              localfmt = g_strdup_printf("[%s] [ID: %08ld] %s",
> -                                       nowstr, syscall(__NR_gettid), fmt);
> +                                       buf, syscall(__NR_gettid), fmt);
>          }
>          fmt = localfmt;
>      }
> -- 
> 2.31.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

