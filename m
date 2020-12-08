Date: Tue, 8 Dec 2020 11:57:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201208165725.GB20722@redhat.com>
References: <20201208055043.31548-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208055043.31548-1-lersek@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: make the debug log timestamp on
 stderr more human-readable
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Laszlo Ersek <lersek@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Tue, Dec 08, 2020 at 06:50:43AM +0100, Laszlo Ersek wrote:
> The current timestamp format doesn't help me visually notice small jumps
> in time ("small" as defined on human scale, such as a few seconds or a few
> ten seconds). Replace it with a local time format where such differences
> stand out.

Switching to a human readable time stamp makes sense. That seems much
more helpful for debugging, IMHO.

Thanks
Vivek

> 
> Before:
> 
> > [13316826770337] [ID: 00000004] unique: 62, opcode: RELEASEDIR (29), nodeid: 1, insize: 64, pid: 1
> > [13316826778175] [ID: 00000004]    unique: 62, success, outsize: 16
> > [13316826781156] [ID: 00000004] virtio_send_msg: elem 0: with 1 in desc of length 16
> > [15138279317927] [ID: 00000001] virtio_loop: Got VU event
> > [15138279504884] [ID: 00000001] fv_queue_set_started: qidx=1 started=0
> > [15138279519034] [ID: 00000003] fv_queue_thread: kill event on queue 1 - quitting
> > [15138280876463] [ID: 00000001] fv_remove_watch: TODO! fd=9
> > [15138280897381] [ID: 00000001] virtio_loop: Waiting for VU event
> > [15138280946834] [ID: 00000001] virtio_loop: Got VU event
> > [15138281175421] [ID: 00000001] virtio_loop: Waiting for VU event
> > [15138281182387] [ID: 00000001] virtio_loop: Got VU event
> > [15138281189474] [ID: 00000001] virtio_loop: Waiting for VU event
> > [15138309321936] [ID: 00000001] virtio_loop: Unexpected poll revents 11
> > [15138309434150] [ID: 00000001] virtio_loop: Exit
> 
> (Notice how you don't (easily) notice the gap in time after
> "virtio_send_msg", and especially the amount of time passed is hard to
> estimate.)
> 
> After:
> 
> > [2020-12-08 06:43:22.58+0100] [ID: 00000004] unique: 51, opcode: RELEASEDIR (29), nodeid: 1, insize: 64, pid: 1
> > [2020-12-08 06:43:22.58+0100] [ID: 00000004]    unique: 51, success, outsize: 16
> > [2020-12-08 06:43:22.58+0100] [ID: 00000004] virtio_send_msg: elem 0: with 1 in desc of length 16
> > [2020-12-08 06:43:29.34+0100] [ID: 00000001] virtio_loop: Got VU event
> > [2020-12-08 06:43:29.34+0100] [ID: 00000001] fv_queue_set_started: qidx=1 started=0
> > [2020-12-08 06:43:29.34+0100] [ID: 00000003] fv_queue_thread: kill event on queue 1 - quitting
> > [2020-12-08 06:43:29.34+0100] [ID: 00000001] fv_remove_watch: TODO! fd=9
> > [2020-12-08 06:43:29.34+0100] [ID: 00000001] virtio_loop: Waiting for VU event
> > [2020-12-08 06:43:29.34+0100] [ID: 00000001] virtio_loop: Got VU event
> > [2020-12-08 06:43:29.34+0100] [ID: 00000001] virtio_loop: Waiting for VU event
> > [2020-12-08 06:43:29.34+0100] [ID: 00000001] virtio_loop: Got VU event
> > [2020-12-08 06:43:29.34+0100] [ID: 00000001] virtio_loop: Waiting for VU event
> > [2020-12-08 06:43:29.37+0100] [ID: 00000001] virtio_loop: Unexpected poll revents 11
> > [2020-12-08 06:43:29.37+0100] [ID: 00000001] virtio_loop: Exit
> 
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Laszlo Ersek <lersek@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 48a109d3f682..06543b20dcbb 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -3311,18 +3311,38 @@ static void setup_nofile_rlimit(unsigned long rlimit_nofile)
>  static void log_func(enum fuse_log_level level, const char *fmt, va_list ap)
>  {
>      g_autofree char *localfmt = NULL;
> +    struct timespec ts;
> +    struct tm tm;
> +    char sec_fmt[sizeof "2020-12-07 18:17:54"];
> +    char zone_fmt[sizeof "+0100"];
>  
>      if (current_log_level < level) {
>          return;
>      }
>  
>      if (current_log_level == FUSE_LOG_DEBUG) {
> -        if (!use_syslog) {
> -            localfmt = g_strdup_printf("[%" PRId64 "] [ID: %08ld] %s",
> -                                       get_clock(), syscall(__NR_gettid), fmt);
> -        } else {
> +        if (use_syslog) {
> +            /* no timestamp needed */
>              localfmt = g_strdup_printf("[ID: %08ld] %s", syscall(__NR_gettid),
>                                         fmt);
> +        } else {
> +            /* try formatting a broken-down timestamp */
> +            if (clock_gettime(CLOCK_REALTIME, &ts) != -1 &&
> +                localtime_r(&ts.tv_sec, &tm) != NULL &&
> +                strftime(sec_fmt, sizeof sec_fmt, "%Y-%m-%d %H:%M:%S",
> +                         &tm) != 0 &&
> +                strftime(zone_fmt, sizeof zone_fmt, "%z", &tm) != 0) {
> +                localfmt = g_strdup_printf("[%s.%02ld%s] [ID: %08ld] %s",
> +                                           sec_fmt,
> +                                           ts.tv_nsec / (10L * 1000 * 1000),
> +                                           zone_fmt, syscall(__NR_gettid),
> +                                           fmt);
> +            } else {
> +                /* fall back to a flat timestamp */
> +                localfmt = g_strdup_printf("[%" PRId64 "] [ID: %08ld] %s",
> +                                           get_clock(), syscall(__NR_gettid),
> +                                           fmt);
> +            }
>          }
>          fmt = localfmt;
>      }
> @@ -3452,6 +3472,9 @@ int main(int argc, char *argv[])
>      struct lo_map_elem *reserve_elem;
>      int ret = -1;
>  
> +    /* Initialize time conversion information for localtime_r(). */
> +    tzset();
> +
>      /* Don't mask creation mode, kernel already did that */
>      umask(0);
>  
> -- 
> 2.19.1.3.g30247aa5d201
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

