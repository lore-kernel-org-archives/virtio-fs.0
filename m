Date: Mon, 14 Jun 2021 16:41:41 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YMd4teSolAaOdW/j@work-vm>
References: <20210505103702.521457-1-berrange@redhat.com>
	<20210505103702.521457-6-berrange@redhat.com>
	<YMOPYkWmobHrapn6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YMOPYkWmobHrapn6@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 5/7] io: use GDateTime for formatting
 timestamp for websock headers
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
> ping: anyone willing to review this
>=20

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> On Wed, May 05, 2021 at 11:37:00AM +0100, Daniel P. Berrang=E9 wrote:
> > The GDateTime APIs provided by GLib avoid portability pitfalls, such
> > as some platforms where 'struct timeval.tv_sec' field is still 'long'
> > instead of 'time_t'. When combined with automatic cleanup, GDateTime
> > often results in simpler code too.
> >=20
> > Signed-off-by: Daniel P. Berrang=E9 <berrange@redhat.com>
> > ---
> >  io/channel-websock.c | 10 ++--------
> >  1 file changed, 2 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/io/channel-websock.c b/io/channel-websock.c
> > index 03c1f7cb62..70889bb54d 100644
> > --- a/io/channel-websock.c
> > +++ b/io/channel-websock.c
> > @@ -177,15 +177,9 @@ qio_channel_websock_handshake_send_res(QIOChannelW=
ebsock *ioc,
> > =20
> >  static gchar *qio_channel_websock_date_str(void)
> >  {
> > -    struct tm tm;
> > -    time_t now =3D time(NULL);
> > -    char datebuf[128];
> > +    g_autoptr(GDateTime) now =3D g_date_time_new_now_utc();
> > =20
> > -    gmtime_r(&now, &tm);
> > -
> > -    strftime(datebuf, sizeof(datebuf), "%a, %d %b %Y %H:%M:%S GMT", &t=
m);
> > -
> > -    return g_strdup(datebuf);
> > +    return g_date_time_format(now, "%a, %d %b %Y %H:%M:%S GMT");
> >  }
> > =20
> >  static void qio_channel_websock_handshake_send_res_err(QIOChannelWebso=
ck *ioc,
> > --=20
> > 2.31.1
> >=20
>=20
> Regards,
> Daniel
> --=20
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberran=
ge :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.c=
om :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberran=
ge :|
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

