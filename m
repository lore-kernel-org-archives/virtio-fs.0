Date: Tue, 4 Aug 2020 11:36:03 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200804103603.GC1284284@stefanha-x1.localdomain>
References: <20200730194736.173994-1-vgoyal@redhat.com>
	<20200730194736.173994-5-vgoyal@redhat.com>
	<20200803095459.GD244853@stefanha-x1.localdomain>
	<20200803135715.GA233053@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vEao7xgI/oilGqZ+"
Content-Disposition: inline
In-Reply-To: <20200803135715.GA233053@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 4/5] virtiofsd: Open lo->source while
 setting up root in sandbox=NONE mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: berrange@redhat.com, vromanso@redhat.com, qemu-devel@nongnu.org, virtio-fs@redhat.com


--vEao7xgI/oilGqZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 03, 2020 at 09:57:15AM -0400, Vivek Goyal wrote:
> On Mon, Aug 03, 2020 at 10:54:59AM +0100, Stefan Hajnoczi wrote:
> > On Thu, Jul 30, 2020 at 03:47:35PM -0400, Vivek Goyal wrote:
> > > In sandbox=3DNONE mode, lo->source points to the directory which is b=
eing
> > > exported. We have not done any chroot()/pivot_root(). So open lo->sou=
rce.
> > >=20
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > >  tools/virtiofsd/passthrough_ll.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passt=
hrough_ll.c
> > > index 76ef891105..a6fa816b6c 100644
> > > --- a/tools/virtiofsd/passthrough_ll.c
> > > +++ b/tools/virtiofsd/passthrough_ll.c
> > > @@ -3209,7 +3209,10 @@ static void setup_root(struct lo_data *lo, str=
uct lo_inode *root)
> > >      int fd, res;
> > >      struct stat stat;
> > > =20
> > > -    fd =3D open("/", O_PATH);
> > > +    if (lo->sandbox =3D=3D SANDBOX_NONE)
> > > +        fd =3D open(lo->source, O_PATH);
> > > +    else
> > > +        fd =3D open("/", O_PATH);
> >=20
> > Up until now virtiofsd has been able to assume that path traversal has
> > the shared directory as "/".
> >=20
> > Now this is no longer true and it is necessary to audit all syscalls
> > that take path arguments. They must ensure that:
> > 1. Path components are safe (no ".." or "/" allowed)
> > 2. Symlinks are not followed.
>=20
> This code does not change the path client is passing in and we are
> already doing the checks on passed in paths/names. So existing checks
> should work even for this case, isn't it?
>=20
> lo_lookup() {
>     if (strchr(name, '/')) {
>         fuse_reply_err(req, EINVAL);
>         return;
>     }
> }
>=20
> lo_do_lookup() {
>     /* Do not allow escaping root directory */
>     if (dir =3D=3D &lo->root && strcmp(name, "..") =3D=3D 0) {
>         name =3D ".";
>     }
> }

Yes, hopefully paths are already checked and syscalls do not follow
symlinks. However, we wouldn't have noticed if either of those were
missing since the pivot_root(2) ensured that path traversal stays within
the shared directory.

Now that a layer of protection has been removed it's necessary to check
again whether everything is really alright.

>=20
> >=20
> > Did you audit all syscalls made by passthrough_ll.c?
> >=20
> > virtiofsd still needs to restrict the client to the shared directory for
> > two reasons:
> > 1. The guest may not be trusted. An unprivileged sandbox=3Dnone mount c=
an
> >    be used with a malicious guest.
> > 2. If accidental escapes are possible then the guest could accidentally
> >    corrupt or delete files outside the shared directory.
>=20
> Even if escape is possible, its no different than a malicious user
> application running. Given sandbox=3Dnone can be used in case of
> unpriviliged mode, that means user app can only affect files owned by
> that user.

Users may run untrusted guests. Those guests should not gain access to
the user's files outside the shared directory.

> If doing chroot/pivot_root is must, then we need additional capabilities.

I think it's not a must, but just an extra layer of security. What I
don't know 100% is whether virtiofsd accidentally relies on that extra
layer of security today since it never ran without it :).

Stefan

--vEao7xgI/oilGqZ+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8pOhMACgkQnKSrs4Gr
c8guwAf/VzWCrF8gU2TyirNenM6hAUUNehn9r0oFneTOWyiN+lGMUgznl1dZSLjE
7xOa968yo88CpK9ukzZTsa6qV28SWatInBGTa4jere1ju4gX9hvUpj8w+h9/Y0gq
gBlymLvn8ABGd4AcjCNsZPoNLsERJ35UUkMNyxPiLAiAEx93ujJvtkA1dq15DAUj
dZUEYyS0A1szZMH5HkDFOifcSQJjQ2LY3sqbBVYw8WhyYoCKVPS+v97LVzitXmCS
NksNIE5EDrSgmxfa43wZ57pCqtlZi2qsBrd+Gm35i4wzFU0pFEc6kcQpYXDJMOiO
b0qSr3S/KkcM478tnHbEMory1P3lMg==
=bD9h
-----END PGP SIGNATURE-----

--vEao7xgI/oilGqZ+--

