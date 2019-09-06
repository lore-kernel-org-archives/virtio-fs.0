Date: Fri, 6 Sep 2019 11:33:27 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906103327.GG5900@stefanha-x1.localdomain>
References: <20190905152136.30637-1-stefanha@redhat.com>
	<20190905152136.30637-4-stefanha@redhat.com>
	<20190905171248.GP2700@work-vm>
	<CAMxuvaw_Vyy8Xya9dCP_K9acqZmmUCK7-=GcJJJ_mv7CZiM3wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oXNgvKVxGWJ0RPMJ"
Content-Disposition: inline
In-Reply-To: <CAMxuvaw_Vyy8Xya9dCP_K9acqZmmUCK7-=GcJJJ_mv7CZiM3wQ@mail.gmail.com>
Subject: Re: [Virtio-fs] [RFC 3/3] virtiofsd: add virtiofsctl command-line
	management tool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel <qemu-devel@nongnu.org>


--oXNgvKVxGWJ0RPMJ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 06, 2019 at 12:03:15AM +0400, Marc-Andr=E9 Lureau wrote:
> Hi
>=20
> On Thu, Sep 5, 2019 at 9:13 PM Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
> >
> > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > virtiofsctl can control a running virtiofsd process:
> > >
> > >   usage: ./virtiofsctl COMMAND [args...]
> > >
> > >   Commands:
> > >     get-log-level       - show current log level
> > >     set-log-level LEVEL - set current log level to one of
> > >                           "err", "warning", "info", "debug"
> > >
> > > Make sure it is running in the same DBus session as virtiofsd.  This =
may
> > > require setting the DBUS_SESSION_BUS_ADDRESS environment variable to =
the
> > > same value as used by virtiofsd.
> > >
> > > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > ---
> > >  Makefile                        |  3 ++
> > >  Makefile.objs                   |  1 +
> > >  contrib/virtiofsd/Makefile.objs |  3 ++
> > >  contrib/virtiofsd/virtiofsctl.c | 55 +++++++++++++++++++++++++++++++=
++
> > >  4 files changed, 62 insertions(+)
> > >  create mode 100644 contrib/virtiofsd/virtiofsctl.c
> > >
> > > diff --git a/Makefile b/Makefile
> > > index 6b1af33348..d7ed9e7669 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -419,6 +419,7 @@ dummy :=3D $(call unnest-vars,, \
> > >                  ivshmem-client-obj-y \
> > >                  ivshmem-server-obj-y \
> > >                  virtiofsd-obj-y \
> > > +                virtiofsctl-obj-y \
> > >                  rdmacm-mux-obj-y \
> > >                  libvhost-user-obj-y \
> > >                  vhost-user-scsi-obj-y \
> > > @@ -661,6 +662,8 @@ contrib/virtiofsd/gdbus_generated.c-timestamp: $(=
SRC_PATH)/contrib/virtiofsd/org
> > >
> > >  virtiofsd$(EXESUF): $(virtiofsd-obj-y) libvhost-user.a $(COMMON_LDAD=
DS)
> > >       $(call LINK, $^)
> > > +virtiofsctl$(EXESUF): $(virtiofsctl-obj-y)
> > > +     $(call LINK, $^)
> > >  endif
> > >
> > >  vhost-user-gpu$(EXESUF): $(vhost-user-gpu-obj-y) $(libvhost-user-obj=
-y) libqemuutil.a libqemustub.a
> > > diff --git a/Makefile.objs b/Makefile.objs
> > > index dfdd7d56ea..326a8abb8e 100644
> > > --- a/Makefile.objs
> > > +++ b/Makefile.objs
> > > @@ -126,6 +126,7 @@ rdmacm-mux-obj-y =3D contrib/rdmacm-mux/
> > >  vhost-user-input-obj-y =3D contrib/vhost-user-input/
> > >  vhost-user-gpu-obj-y =3D contrib/vhost-user-gpu/
> > >  virtiofsd-obj-y =3D contrib/virtiofsd/
> > > +virtiofsctl-obj-y =3D contrib/virtiofsd/
> > >
> > >  ####################################################################=
##
> > >  trace-events-subdirs =3D
> > > diff --git a/contrib/virtiofsd/Makefile.objs b/contrib/virtiofsd/Make=
file.objs
> > > index d59ab60f3d..3f944d493e 100644
> > > --- a/contrib/virtiofsd/Makefile.objs
> > > +++ b/contrib/virtiofsd/Makefile.objs
> > > @@ -11,6 +11,9 @@ virtiofsd-obj-y =3D buffer.o \
> > >                    gdbus_generated.o \
> > >                    dbus.o
> > >
> > > +virtiofsctl-obj-y =3D virtiofsctl.o \
> > > +                    gdbus_generated.o
> > > +
> > >  seccomp.o-cflags :=3D $(SECCOMP_CFLAGS)
> > >  seccomp.o-libs :=3D $(SECCOMP_LIBS)
> > >
> > > diff --git a/contrib/virtiofsd/virtiofsctl.c b/contrib/virtiofsd/virt=
iofsctl.c
> > > new file mode 100644
> > > index 0000000000..39bee2b881
> > > --- /dev/null
> > > +++ b/contrib/virtiofsd/virtiofsctl.c
> > > @@ -0,0 +1,55 @@
> > > +#include <stdio.h>
> > > +#include "gdbus_generated.h"
> > > +
> > > +static void get_log_level(Virtiofsd *virtiofsd)
> > > +{
> > > +    const char *value =3D virtiofsd_get_log_level(virtiofsd);
> > > +
> > > +    printf("%s\n", value ? value : "(null)");
> > > +}
> > > +
> > > +static void set_log_level(Virtiofsd *virtiofsd, const char *value)
> > > +{
> > > +    virtiofsd_set_log_level(virtiofsd, value);
> > > +}
> > > +
> > > +static void usage(const char *progname)
> > > +{
> > > +    printf("usage: %s COMMAND [args...]\n", progname);
> > > +    printf("\n");
> > > +    printf("Commands:\n");
> > > +    printf("  get-log-level       - show current log level\n");
> > > +    printf("  set-log-level LEVEL - set current log level to one of\=
n");
> > > +    printf("                        \"err\", \"warning\", \"info\", =
\"debug\"\n");
> > > +    exit(0);
> > > +}
> > > +
> > > +int main(int argc, char **argv)
> > > +{
> > > +    Virtiofsd *virtiofsd;
> > > +    GError *error =3D NULL;
> > > +
> > > +    if (argc < 2) {
> > > +        usage(argv[0]);
> > > +    }
> > > +
> > > +    virtiofsd =3D virtiofsd_proxy_new_for_bus_sync(G_BUS_TYPE_SESSIO=
N,
> > > +            G_DBUS_PROXY_FLAGS_NONE, "org.qemu.virtiofsd",
> > > +            "/org/qemu/virtiofsd", NULL, &error);
> > > +    if (error) {
> > > +        fprintf(stderr, "%s\n", error->message);
> > > +        g_error_free(error);
> > > +        return 1;
> > > +    }
> > > +
> > > +    if (strcmp(argv[0], "get-log-level") =3D=3D 0) {
> >
> > This and the one below works a lot better with argv[1] !
> >
> > (I wonder if a little python script would be better for these type of
> > wrappers).
>=20
> Or just plain gdbus/busctl calls (which already has bash completion
> fwiw), and/or eventually a shell script.

A virtiofsctl program is useful because the sub-commands are easily
discoverable and no DBus knowledge is required.  Writing it in Python 3
would be nice.

Stefan

--oXNgvKVxGWJ0RPMJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1yNfcACgkQnKSrs4Gr
c8j+/wf/UZUY4Smxwfi5sB5fwYNsXIRWHQJGk/yO0x8A6H8jnAb+sfxZpMXHinVn
+Duuj9PSWXZMVfj0IDcMFs0NUOGc4Ltd9xwVRYUIZgvq3eKiD4HV7fOKdS4ZSnxL
EzS/IZt2N5fbsnqL8jvt6R6ipWVP/5D3Ya62Jwa9hoExxT5pdH7aIFOc/lWYJ3Hp
BlzJ92S/310b2JWx+GnKBbnLqICZsZGvONnOdb3C+rgirKF6fXQHsnr6I36XSr2h
2LZLxe0D2uXBCEdMyFerL6B7J37xZiXg3F1c7Ukjnk9uJ0fvG5OmBPt9q0jVvJS8
MtXUd9ytrHS+EhT/znaASt9tA0wjNw==
=KwGy
-----END PGP SIGNATURE-----

--oXNgvKVxGWJ0RPMJ--

