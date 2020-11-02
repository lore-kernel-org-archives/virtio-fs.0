Date: Mon, 2 Nov 2020 16:43:43 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201102164343.GB212231@stefanha-x1.localdomain>
References: <20201102150750.34565-1-dgilbert@redhat.com>
	<e1a007ed-7a9f-38cd-4003-144d0e99dd6e@redhat.com>
	<20201102151824.GG138796@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <20201102151824.GG138796@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Seccomp: Add 'send' for syslog
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: virtio-fs@redhat.com, Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>, amulmek1@in.ibm.com, qemu-devel@nongnu.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 02, 2020 at 03:18:24PM +0000, Daniel P. Berrang=E9 wrote:
> On Mon, Nov 02, 2020 at 04:11:44PM +0100, Philippe Mathieu-Daud=E9 wrote:
> > On 11/2/20 4:07 PM, Dr. David Alan Gilbert (git) wrote:
> > > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > >=20
> > > On ppc it looks like syslog ends up using 'send' rather than 'sendto'.
> > >=20
> > > Reference: https://github.com/kata-containers/kata-containers/issues/=
1050
> > >=20
> > > Reported-by: amulmek1@in.ibm.com
> > > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > ---
> > >  tools/virtiofsd/passthrough_seccomp.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >=20
> > > diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/=
passthrough_seccomp.c
> > > index eb9af8265f..672fb72a31 100644
> > > --- a/tools/virtiofsd/passthrough_seccomp.c
> > > +++ b/tools/virtiofsd/passthrough_seccomp.c
> > > @@ -118,6 +118,7 @@ static const int syscall_whitelist[] =3D {
> > > =20
> > >  /* Syscalls used when --syslog is enabled */
> > >  static const int syscall_whitelist_syslog[] =3D {
> >=20
> > Is it worth restricting the syscall to POWER?
>=20
> That would be wrong, as this is needed on multiple arches.
>=20
> There is no real security benefit to restricting it either, as both
> syscalls give you broadly equivalent abilities.

Restricting send to architectures where glibc slightly decreases the
host kernel attack surface. I think it makes sense from a security
perspective. There could be a send(2)-only bug in Linux isn't present in
sendto(2).

But there are other issues with seccomp - are we really sure send(2) is
never called? Since we don't control the entire binary (share libraries
are used, virtiofsd could be linked against another libc, etc) we may
not have enough information to conclude that can be eliminated send(2).

Stefan

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+gNz8ACgkQnKSrs4Gr
c8j72gf/drygV4GANWvaE8KMazNylXTmrnhpTQcjvPERlSMKFfLEsKiO/YhX6uEm
Y3ltnGLb2hgLp8je9MPstvFmveChTCYWxxDwlu+MpK+4V31wQUoTB67oh0dehEI5
C08QDiK7cDjarfObjlQStIoJyR2wXrd0ydoYUuiQhgf6NYTXSdb6pmVQgAHtwFIm
x43nLaXyFNP0B0YL4POt8QOCWnBzThDqCUpqqQsx16fjHFB28U4n+I7KXk1cU0Qg
9KvFKhVZo5WfKOYqtGT4D/O3uFsIhu6UuLa6wbw51Ws3hbjPcenipF3wRO8wSSAk
oL4Ua+Qk4XmOmx3cIURrCSajpuY7Sw==
=xwO6
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--

