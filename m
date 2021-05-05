Date: Wed, 5 May 2021 15:42:46 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YJKu5jfOeu5ubDXZ@work-vm>
References: <20210505103702.521457-1-berrange@redhat.com>
	<20210505103702.521457-2-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210505103702.521457-2-berrange@redhat.com>
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
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Jiri Pirko <jiri@resnulli.us>, qemu-block@nongnu.org, Juan Quintela <quintela@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org, Laurent Vivier <laurent@vivier.eu>, virtio-fs@redhat.com, Gerd Hoffmann <kraxel@redhat.com>, Max Reitz <mreitz@redhat.com>, Brad Smith <brad@comstyle.com>

* Daniel P. Berrang=E9 (berrange@redhat.com) wrote:
> The GDateTime APIs provided by GLib avoid portability pitfalls, such
> as some platforms where 'struct timeval.tv_sec' field is still 'long'
> instead of 'time_t'. When combined with automatic cleanup, GDateTime
> often results in simpler code too.
>=20
> Signed-off-by: Daniel P. Berrang=E9 <berrange@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  migration/savevm.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
>=20
> diff --git a/migration/savevm.c b/migration/savevm.c
> index 52e2d72e4b..72848b946c 100644
> --- a/migration/savevm.c
> +++ b/migration/savevm.c
> @@ -2775,8 +2775,7 @@ bool save_snapshot(const char *name, bool overwrite=
, const char *vmstate,
>      QEMUFile *f;
>      int saved_vm_running;
>      uint64_t vm_state_size;
> -    qemu_timeval tv;
> -    struct tm tm;
> +    g_autoptr(GDateTime) now =3D g_date_time_new_now_local();
>      AioContext *aio_context;
> =20
>      if (migration_is_blocked(errp)) {
> @@ -2836,9 +2835,8 @@ bool save_snapshot(const char *name, bool overwrite=
, const char *vmstate,
>      memset(sn, 0, sizeof(*sn));
> =20
>      /* fill auxiliary fields */
> -    qemu_gettimeofday(&tv);
> -    sn->date_sec =3D tv.tv_sec;
> -    sn->date_nsec =3D tv.tv_usec * 1000;
> +    sn->date_sec =3D g_date_time_to_unix(now);
> +    sn->date_nsec =3D g_date_time_get_microsecond(now) * 1000;
>      sn->vm_clock_nsec =3D qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL);
>      if (replay_mode !=3D REPLAY_MODE_NONE) {
>          sn->icount =3D replay_get_current_icount();
> @@ -2849,9 +2847,8 @@ bool save_snapshot(const char *name, bool overwrite=
, const char *vmstate,
>      if (name) {
>          pstrcpy(sn->name, sizeof(sn->name), name);
>      } else {
> -        /* cast below needed for OpenBSD where tv_sec is still 'long' */
> -        localtime_r((const time_t *)&tv.tv_sec, &tm);
> -        strftime(sn->name, sizeof(sn->name), "vm-%Y%m%d%H%M%S", &tm);
> +        g_autofree char *autoname =3D g_date_time_format(now,  "vm-%Y%m%=
d%H%M%S");
> +        pstrcpy(sn->name, sizeof(sn->name), autoname);
>      }
> =20
>      /* save the VM state */
> --=20
> 2.31.1
>=20
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

