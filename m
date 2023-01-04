Return-Path: <dgilbert@redhat.com>
Date: Wed, 4 Jan 2023 19:46:56 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <Y7XXsHEqgTG9Ani6@work-vm>
References: <20221219130205.687815-1-berrange@redhat.com>
 <20221219130205.687815-4-berrange@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20221219130205.687815-4-berrange@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH 3/6] tools/virtiofsd: add G_GNUC_PRINTF for
 logging functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org, Laurent Vivier <lvivier@redhat.com>, Markus Armbruster <armbru@redhat.com>, Daniel Henrique Barboza <danielhb413@gmail.com>, virtio-fs@redhat.com, Michael Roth <michael.roth@amd.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, qemu-block@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org, Paul Durrant <paul@xen.org>, Anthony Perard <anthony.perard@citrix.com>, David Gibson <david@gibson.dropbear.id.au>, =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>, John Snow <jsnow@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefano Stabellini <sstabellini@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>, Greg Kurz <groug@kaod.org>, Thomas Huth <thuth@redhat.com>

* Daniel P. Berrang=E9 (berrange@redhat.com) wrote:
> Signed-off-by: Daniel P. Berrang=E9 <berrange@redhat.com>

Yes, although I'm a little surprised this hasn't thrown up any warnings.


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  tools/virtiofsd/fuse_log.c       | 1 +
>  tools/virtiofsd/fuse_log.h       | 6 ++++--
>  tools/virtiofsd/passthrough_ll.c | 1 +
>  3 files changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/tools/virtiofsd/fuse_log.c b/tools/virtiofsd/fuse_log.c
> index 745d88cd2a..2de3f48ee7 100644
> --- a/tools/virtiofsd/fuse_log.c
> +++ b/tools/virtiofsd/fuse_log.c
> @@ -12,6 +12,7 @@
>  #include "fuse_log.h"
> =20
> =20
> +G_GNUC_PRINTF(2, 0)
>  static void default_log_func(__attribute__((unused)) enum fuse_log_level=
 level,
>                               const char *fmt, va_list ap)
>  {
> diff --git a/tools/virtiofsd/fuse_log.h b/tools/virtiofsd/fuse_log.h
> index 8d7091bd4d..e5c2967ab9 100644
> --- a/tools/virtiofsd/fuse_log.h
> +++ b/tools/virtiofsd/fuse_log.h
> @@ -45,7 +45,8 @@ enum fuse_log_level {
>   * @param ap format string arguments
>   */
>  typedef void (*fuse_log_func_t)(enum fuse_log_level level, const char *f=
mt,
> -                                va_list ap);
> +                                va_list ap)
> +    G_GNUC_PRINTF(2, 0);
> =20
>  /**
>   * Install a custom log handler function.
> @@ -68,6 +69,7 @@ void fuse_set_log_func(fuse_log_func_t func);
>   * @param level severity level (FUSE_LOG_ERR, FUSE_LOG_DEBUG, etc)
>   * @param fmt sprintf-style format string including newline
>   */
> -void fuse_log(enum fuse_log_level level, const char *fmt, ...);
> +void fuse_log(enum fuse_log_level level, const char *fmt, ...)
> +    G_GNUC_PRINTF(2, 3);
> =20
>  #endif /* FUSE_LOG_H_ */
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrou=
gh_ll.c
> index 20f0f41f99..40ea2ed27f 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -4182,6 +4182,7 @@ static void setup_nofile_rlimit(unsigned long rlimi=
t_nofile)
>      }
>  }
> =20
> +G_GNUC_PRINTF(2, 0)
>  static void log_func(enum fuse_log_level level, const char *fmt, va_list=
 ap)
>  {
>      g_autofree char *localfmt =3D NULL;
> --=20
> 2.38.1
>=20
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

