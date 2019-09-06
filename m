Date: Fri, 6 Sep 2019 11:29:26 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906102926.GF5900@stefanha-x1.localdomain>
References: <20190905152136.30637-1-stefanha@redhat.com>
	<20190905174021.GR2700@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IvGM3kKqwtniy32b"
Content-Disposition: inline
In-Reply-To: <20190905174021.GR2700@work-vm>
Subject: Re: [Virtio-fs] [RFC 0/3] virtiofsd: get/set log level via DBus
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, qemu-devel@nongnu.org


--IvGM3kKqwtniy32b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2019 at 06:40:21PM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > It is likely that virtiofsd will need to support "management commands" =
for
> > reconfiguring it at runtime.  The first use case was proposed by Eryu G=
uan for
> > getting/setting the current log level.
> >=20
> > I promised to try out DBus as the management interface because it has a=
 rich
> > feature set and is accessible from most programming languages.  It shou=
ld be
> > able to support all the use cases we come up with.
> >=20
> > This patch series is a prototype that implements the get-log-level and
> > set-log-level management commands via DBus.  Use the new virtiofsctl to=
ol to
> > talk to a running virtiofsd process:
> >=20
> >   # dbus-run-session ./virtiofsd ...
> >   ...
> >   Using dbus address unix:abstract=3D/tmp/dbus-H9WBbpjk3O,guid=3D0be16a=
cefb868e6025a8737f5d7124d2
> >   # export DBUS_SESSION_BUS_ADDRESS=3Dunix:abstract=3D/tmp/dbus-H9WBbpj=
k3O,guid=3D0be16acefb868e6025a8737f5d7124d2
> >   # ./virtiofsctl set-log-level err
> >=20
> > Most of the work is done by gdbus-codegen(1).  It generates code for the
> > org.qemu.Virtiofsd.xml interface definition.  Our code can use the simp=
le
> > virtiofsd_get/set_log_level() APIs and it will make corresponding DBus =
calls.
> >=20
> > I'm pretty happy with this approach because the code is straightforward=
=2E  It
> > hasn't even triggered seccomp failures yet :).
>=20
> Yes it's less complex than I'd worried.
> Now, I do think we've got to think about how qemu in general is going to
> use dbus as people were discussing it, because then we have to think
> what the security aspects are - do we need to look at some calls only
> available to some clients etc.

The approach I took in this patch series is to launch a session bus just
for this virtiofsd.  The abstract socket unix(7) namespace used by GDBus
by default does not offer any security.  I think any process on the host
can connect to it, regardless of uid/gid.

A path like unix:path=3D/tmp/foo would allow us to use UNIX Domain Socket
permissions as the main security mechanism.  I'm not enthusiastic about
using SELinux or some kind of DBus-specific policy language if we can
avoid it because it's complex and obscure.

Stefan

--IvGM3kKqwtniy32b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1yNQYACgkQnKSrs4Gr
c8h2KQgAkoXMgZxWjDLU0NS68GhsgBMGLEib8ww18Uj2FzrM1efTLHKC4oFVjLqD
owOI/mR2RL46mIH4on8VpiqqiOxgRN5Kb+Nc0rr16F6ekoXAMYGGqlr7E3vEtBqi
cCt0GTqnZnDK26V57jrGGpUgi/oR1nkplVKsgeXt/RLkE5b/Vi6KVygw1OC9KcKp
fJCCmm1qMNRlOHc9pWpDEQ3fEvMZ91xKavB8A11m2OtfURsm1On+/S/zmgzzrZ8j
0YYnRMYDRcNnYJvE1/BK1XfWy9jaGhRYVSzsElpunT54X6JensTw0XMt583sW50k
EWblPB+T48jW3wcxxhmrknj+ihzCCA==
=vF04
-----END PGP SIGNATURE-----

--IvGM3kKqwtniy32b--

