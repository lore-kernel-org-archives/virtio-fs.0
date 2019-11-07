Date: Thu, 7 Nov 2019 10:46:35 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191107104635.GC2816@work-vm>
References: <20191106190602.14522-1-msys.mizuma@gmail.com>
	<20191106190602.14522-2-msys.mizuma@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106190602.14522-2-msys.mizuma@gmail.com>
Subject: Re: [Virtio-fs] [PATCH 1/2] virtiofsd: Add ID to the log with
 FUSE_LOG_DEBUG level
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
> It would be useful for debugging if we can identify the specific thread
> from the log.
> 
> Add ID, which is got by gettid(), to the log with FUSE_LOG_DEBUG level
> so that we can grep the specific thread.
> 
> The log is like as:
> 
>   ]# ./virtiofsd -d -o vhost_user_socket=/tmp/vhostqemu0 -o source=/tmp/share0 -o cache=auto
>   ...
>   [ID: 00000097]    unique: 12696, success, outsize: 120
>   [ID: 00000097] virtio_send_msg: elem 18: with 2 in desc of length 120
>   [ID: 00000003] fv_queue_thread: Got queue event on Queue 1
>   [ID: 00000003] fv_queue_thread: Queue 1 gave evalue: 1 available: in: 65552 out: 80
>   [ID: 00000003] fv_queue_thread: Waiting for Queue 1 event
>   [ID: 00000071] fv_queue_worker: elem 33: with 2 out desc of length 80 bad_in_num=0 bad_out_num=0
>   [ID: 00000071] unique: 12694, opcode: READ (15), nodeid: 2, insize: 80, pid: 2014
>   [ID: 00000071] lo_read(ino=2, size=65536, off=131072)
> 
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Yes, that's OK;


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  contrib/virtiofsd/passthrough_ll.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> index 6ad021d00d..0e85d5ea74 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -2849,11 +2849,17 @@ static void setup_nofile_rlimit(void)
>  }
>  
>  static void log_func(enum fuse_log_level level,
> -		     const char *fmt, va_list ap)
> +		     const char *_fmt, va_list ap)
>  {
> +	char *fmt = (char *)_fmt;
> +
>  	if (current_log_level < level)
>  		return;
>  
> +	if (current_log_level == FUSE_LOG_DEBUG)
> +		fmt = g_strdup_printf("[ID: %08ld] %s",
> +				syscall(__NR_gettid), _fmt);
> +
>  	if (use_syslog) {
>  		int priority = LOG_ERR;
>  		switch (level) {
> @@ -2870,6 +2876,9 @@ static void log_func(enum fuse_log_level level,
>  	} else {
>  		vfprintf(stderr, fmt, ap);
>  	}
> +
> +	if (current_log_level == FUSE_LOG_DEBUG)
> +		g_free(fmt);
>  }
>  
>  static void *ireg_do(void *data)
> -- 
> 2.18.1
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

