Date: Thu, 6 May 2021 17:00:31 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YJQSnyAIkww0ApJM@work-vm>
References: <20210505103702.521457-1-berrange@redhat.com>
	<20210505103702.521457-8-berrange@redhat.com>
	<YJKw/qcsSBvgB1hG@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YJKw/qcsSBvgB1hG@work-vm>
Subject: Re: [Virtio-fs] [PATCH 7/7] virtiofsd: use GDateTime for formatting
 timestamp for debug messages
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

* Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
> * Daniel P. Berrang=E9 (berrange@redhat.com) wrote:
> > The GDateTime APIs provided by GLib avoid portability pitfalls, such
> > as some platforms where 'struct timeval.tv_sec' field is still 'long'
> > instead of 'time_t'. When combined with automatic cleanup, GDateTime
> > often results in simpler code too.
> >=20
> > Signed-off-by: Daniel P. Berrang=E9 <berrange@redhat.com>
>=20
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

Queued this 7/7 via virtiofsd

> > ---
> >  tools/virtiofsd/passthrough_ll.c | 25 ++++---------------------
> >  1 file changed, 4 insertions(+), 21 deletions(-)
> >=20
> > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthr=
ough_ll.c
> > index 1553d2ef45..cdd224918c 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -3558,10 +3558,6 @@ static void setup_nofile_rlimit(unsigned long rl=
imit_nofile)
> >  static void log_func(enum fuse_log_level level, const char *fmt, va_li=
st ap)
> >  {
> >      g_autofree char *localfmt =3D NULL;
> > -    struct timespec ts;
> > -    struct tm tm;
> > -    char sec_fmt[sizeof "2020-12-07 18:17:54"];
> > -    char zone_fmt[sizeof "+0100"];
> > =20
> >      if (current_log_level < level) {
> >          return;
> > @@ -3573,23 +3569,10 @@ static void log_func(enum fuse_log_level level,=
 const char *fmt, va_list ap)
> >              localfmt =3D g_strdup_printf("[ID: %08ld] %s", syscall(__N=
R_gettid),
> >                                         fmt);
> >          } else {
> > -            /* try formatting a broken-down timestamp */
> > -            if (clock_gettime(CLOCK_REALTIME, &ts) !=3D -1 &&
> > -                localtime_r(&ts.tv_sec, &tm) !=3D NULL &&
> > -                strftime(sec_fmt, sizeof sec_fmt, "%Y-%m-%d %H:%M:%S",
> > -                         &tm) !=3D 0 &&
> > -                strftime(zone_fmt, sizeof zone_fmt, "%z", &tm) !=3D 0)=
 {
> > -                localfmt =3D g_strdup_printf("[%s.%02ld%s] [ID: %08ld]=
 %s",
> > -                                           sec_fmt,
> > -                                           ts.tv_nsec / (10L * 1000 * =
1000),
> > -                                           zone_fmt, syscall(__NR_gett=
id),
> > -                                           fmt);
> > -            } else {
> > -                /* fall back to a flat timestamp */
> > -                localfmt =3D g_strdup_printf("[%" PRId64 "] [ID: %08ld=
] %s",
> > -                                           get_clock(), syscall(__NR_g=
ettid),
> > -                                           fmt);
> > -            }
> > +            g_autoptr(GDateTime) now =3D g_date_time_new_now_local();
> > +            g_autofree char *nowstr =3D g_date_time_format(now, "%Y-%m=
-%d %H:%M:%S.%f%z");
> > +            localfmt =3D g_strdup_printf("[%s] [ID: %08ld] %s",
> > +                                       nowstr, syscall(__NR_gettid), f=
mt);
> >          }
> >          fmt =3D localfmt;
> >      }
> > --=20
> > 2.31.1
> >=20
> --=20
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>=20
>=20
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

