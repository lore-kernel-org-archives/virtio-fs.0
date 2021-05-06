DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=comstyle.com; h=message-id
	:date:mime-version:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding; s=default; bh=ZHUukWhEv
	MmN0PAW4z+5itM7Vos=; b=USGS3VMd0aLLo9VH50n/oVYL6yEKN0oQ+2ZFYon7Y
	E8liHtjCydRuYII4tb9zMWY6tqySbEJ0GNHOeA7PbEIsWWEGWIlgRHciKP0YmjW6
	dA7lNay6ClgfjV/v4vCMYskt/bYJ2wJYxLuNQkzYyF3IuEMnlmpu5SKt5DlPHprL
	jI=
Message-ID: <c962e974-929e-9f96-7b80-93c49d71cf09@comstyle.com>
Date: Wed, 5 May 2021 23:14:42 -0400
MIME-Version: 1.0
References: <20210505103702.521457-1-berrange@redhat.com>
	<20210505103702.521457-2-berrange@redhat.com>
From: Brad Smith <brad@comstyle.com>
In-Reply-To: <20210505103702.521457-2-berrange@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 1/7] migration: use GDateTime for formatting
 timestamp in snapshot names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Jiri Pirko <jiri@resnulli.us>, qemu-block@nongnu.org, Juan Quintela <quintela@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <laurent@vivier.eu>, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com, Gerd Hoffmann <kraxel@redhat.com>

Thank you.

On 5/5/2021 6:36 AM, Daniel P. Berrangé wrote:
> The GDateTime APIs provided by GLib avoid portability pitfalls, such
> as some platforms where 'struct timeval.tv_sec' field is still 'long'
> instead of 'time_t'. When combined with automatic cleanup, GDateTime
> often results in simpler code too.
>
> Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
> ---
>   migration/savevm.c | 13 +++++--------
>   1 file changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/migration/savevm.c b/migration/savevm.c
> index 52e2d72e4b..72848b946c 100644
> --- a/migration/savevm.c
> +++ b/migration/savevm.c
> @@ -2775,8 +2775,7 @@ bool save_snapshot(const char *name, bool overwrite, const char *vmstate,
>       QEMUFile *f;
>       int saved_vm_running;
>       uint64_t vm_state_size;
> -    qemu_timeval tv;
> -    struct tm tm;
> +    g_autoptr(GDateTime) now = g_date_time_new_now_local();
>       AioContext *aio_context;
>   
>       if (migration_is_blocked(errp)) {
> @@ -2836,9 +2835,8 @@ bool save_snapshot(const char *name, bool overwrite, const char *vmstate,
>       memset(sn, 0, sizeof(*sn));
>   
>       /* fill auxiliary fields */
> -    qemu_gettimeofday(&tv);
> -    sn->date_sec = tv.tv_sec;
> -    sn->date_nsec = tv.tv_usec * 1000;
> +    sn->date_sec = g_date_time_to_unix(now);
> +    sn->date_nsec = g_date_time_get_microsecond(now) * 1000;
>       sn->vm_clock_nsec = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL);
>       if (replay_mode != REPLAY_MODE_NONE) {
>           sn->icount = replay_get_current_icount();
> @@ -2849,9 +2847,8 @@ bool save_snapshot(const char *name, bool overwrite, const char *vmstate,
>       if (name) {
>           pstrcpy(sn->name, sizeof(sn->name), name);
>       } else {
> -        /* cast below needed for OpenBSD where tv_sec is still 'long' */
> -        localtime_r((const time_t *)&tv.tv_sec, &tm);
> -        strftime(sn->name, sizeof(sn->name), "vm-%Y%m%d%H%M%S", &tm);
> +        g_autofree char *autoname = g_date_time_format(now,  "vm-%Y%m%d%H%M%S");
> +        pstrcpy(sn->name, sizeof(sn->name), autoname);
>       }
>   
>       /* save the VM state */


