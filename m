Date: Fri, 11 Jun 2021 17:29:22 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <YMOPYkWmobHrapn6@redhat.com>
References: <20210505103702.521457-1-berrange@redhat.com>
	<20210505103702.521457-6-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210505103702.521457-6-berrange@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 5/7] io: use GDateTime for formatting
 timestamp for websock headers
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Jiri Pirko <jiri@resnulli.us>, qemu-block@nongnu.org, Juan Quintela <quintela@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <laurent@vivier.eu>, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com, Gerd Hoffmann <kraxel@redhat.com>, Brad Smith <brad@comstyle.com>

ping: anyone willing to review this

On Wed, May 05, 2021 at 11:37:00AM +0100, Daniel P. Berrangé wrote:
> The GDateTime APIs provided by GLib avoid portability pitfalls, such
> as some platforms where 'struct timeval.tv_sec' field is still 'long'
> instead of 'time_t'. When combined with automatic cleanup, GDateTime
> often results in simpler code too.
> 
> Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
> ---
>  io/channel-websock.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/io/channel-websock.c b/io/channel-websock.c
> index 03c1f7cb62..70889bb54d 100644
> --- a/io/channel-websock.c
> +++ b/io/channel-websock.c
> @@ -177,15 +177,9 @@ qio_channel_websock_handshake_send_res(QIOChannelWebsock *ioc,
>  
>  static gchar *qio_channel_websock_date_str(void)
>  {
> -    struct tm tm;
> -    time_t now = time(NULL);
> -    char datebuf[128];
> +    g_autoptr(GDateTime) now = g_date_time_new_now_utc();
>  
> -    gmtime_r(&now, &tm);
> -
> -    strftime(datebuf, sizeof(datebuf), "%a, %d %b %Y %H:%M:%S GMT", &tm);
> -
> -    return g_strdup(datebuf);
> +    return g_date_time_format(now, "%a, %d %b %Y %H:%M:%S GMT");
>  }
>  
>  static void qio_channel_websock_handshake_send_res_err(QIOChannelWebsock *ioc,
> -- 
> 2.31.1
> 

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

