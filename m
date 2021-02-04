Date: Thu, 4 Feb 2021 09:25:28 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210204092528.0f4b3200@bahia.lan>
In-Reply-To: <20210203170006.GK74271@stefanha-x1.localdomain>
References: <20210203113719.83633-1-stefanha@redhat.com>
	<20210203113719.83633-3-stefanha@redhat.com>
	<20210203152014.443a8b29@bahia.lan>
	<20210203170006.GK74271@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/1E9Ev5psbM7H+GMPlMXCCEO";
	protocol="application/pgp-signature"; micalg=pgp-sha256
Subject: Re: [Virtio-fs] [PATCH v4 2/3] virtiofsd: optionally return inode
 pointer from lo_do_lookup()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, P J P <ppandit@redhat.com>, Laszlo Ersek <lersek@redhat.com>, vgoyal@redhat.com

--Sig_/1E9Ev5psbM7H+GMPlMXCCEO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Feb 2021 17:00:06 +0000
Stefan Hajnoczi <stefanha@redhat.com> wrote:

> On Wed, Feb 03, 2021 at 03:20:14PM +0100, Greg Kurz wrote:
> > On Wed,  3 Feb 2021 11:37:18 +0000
> > Stefan Hajnoczi <stefanha@redhat.com> wrote:
> >=20
> > > lo_do_lookup() finds an existing inode or allocates a new one. It
> > > increments nlookup so that the inode stays alive until the client
> > > releases it.
> > >=20
> > > Existing callers don't need the struct lo_inode so the function doesn=
't
> > > return it. Extend the function to optionally return the inode. The ne=
xt
> > > commit will need it.
> > >=20
> > > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > ---
> > >  tools/virtiofsd/passthrough_ll.c | 29 +++++++++++++++++++++--------
> > >  1 file changed, 21 insertions(+), 8 deletions(-)
> > >=20
> > > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passt=
hrough_ll.c
> > > index e63cbd3fb7..c87a1f3d72 100644
> > > --- a/tools/virtiofsd/passthrough_ll.c
> > > +++ b/tools/virtiofsd/passthrough_ll.c
> > > @@ -831,11 +831,13 @@ static int do_statx(struct lo_data *lo, int dir=
fd, const char *pathname,
> > >  }
> > > =20
> > >  /*
> > > - * Increments nlookup and caller must release refcount using
> > > - * lo_inode_put(&parent).
> > > + * Increments nlookup on the inode on success. unref_inode_lolocked(=
) must be
> > > + * called eventually to decrement nlookup again. If inodep is non-NU=
LL, the
> > > + * inode pointer is stored and the caller must call lo_inode_put().
> > >   */
> > >  static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const cha=
r *name,
> > > -                        struct fuse_entry_param *e)
> > > +                        struct fuse_entry_param *e,
> > > +                        struct lo_inode **inodep)
> > >  {
> > >      int newfd;
> > >      int res;
> > > @@ -845,6 +847,10 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino=
_t parent, const char *name,
> > >      struct lo_inode *inode =3D NULL;
> > >      struct lo_inode *dir =3D lo_inode(req, parent);
> > > =20
> > > +    if (inodep) {
> > > +        *inodep =3D NULL;
> > > +    }
> > > +
> >=20
> > Is this side-effect needed ? If lo_do_lookup() returns an error, it
> > rather seems that the caller shouldn't expect anything to be written
> > here, i.e. the content of *inodep still belongs to the caller and
> > whatever value it previously put in there (as patch 3/3 does) should
> > be preserved IMHO.
> >=20
> > Apart from that LGTM.
>=20
> I like this approach because it prevents accessing uninitialized memory
> in the caller:
>=20
>   struct lo_inode *inode;
>=20
>   if (lo_do_lookup(..., &inodep) !=3D 0) {
>     goto err;
>   }
>   ...
>=20
>   err:
>   lo_inode_put(&inode); <-- uninitialized in the error case!

My point is that it is the caller's business to ensure that inode
doesn't contain garbage if it is to be used irrespective of the
outcome of lo_do_lookup(). This is precisely what patch 3/3 does,
so I don't understand the ultimate purpose of nullifying the
inode pointer _again_ in lo_do_lookup()...

--Sig_/1E9Ev5psbM7H+GMPlMXCCEO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEtIKLr5QxQM7yo0kQcdTV5YIvc9YFAmAbr3gACgkQcdTV5YIv
c9bZkRAAksgKW+l5JBklGUgl5b2gvoL5F0sjX2LDJKtX3lTT+vy9jrE5U2otcqqo
7oyeC3m1+/BkakV3TrphqYrBr4cpA4icDd78brJFu9opXNsy6CwyC3uagzd9huID
Ga6YbeH/MZBR/Acmjf07fR0OucmZulcYbE6+ajVGhbDmuDxpk5u/1TTCoPKse0tv
1WzF4Xhztryc3qYdK3jAS7V7avqYBIBv+fDP7zihYz/4RkWu4Kt1hnC6zUnOxt/v
zEu2B1t1pflTzXADquorPaVVZt5wJL6FyZZ2RLplB1oAw3O9ha8UN3s36gP8cxr7
RAhRQMq47EqyKFnUOCueWAzTLDIsgm2S2MOm7V6ToeivrOMclz8ug37XO+w8UVeK
Cn7uJ5v9sGYGbhVwT6iVo3z8HJViRUTxMZVNDSe9yoRBuXRJs8NoAXE6DJENz9Ww
+CLgwoMc3lNICGK6r75VZd/WxM2uYznYNce99P/6nlgugUWiObsqpnlVKHXAfgNQ
loTaAFQZ9GsgUPAXFhQ6FY0qABLpky9ik/3J35LWYS9Ken/9kl6xqofSwJNQNMGH
BicpOz24IH4XGzJXAqzWovuMh/8zi3BjywiyA6vUVT6UneVUHATKDrh/6w2UXl0c
fhKUzcuJ69uv6yURaJ7nhgkI6v/P08Gk+2Dca0YzL5YCa1irJdA=
=lr6D
-----END PGP SIGNATURE-----

--Sig_/1E9Ev5psbM7H+GMPlMXCCEO--

