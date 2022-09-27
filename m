Return-Path: <stefanha@redhat.com>
Date: Tue, 27 Sep 2022 16:14:20 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YzNZnPiUqySu6sGh@fedora>
References: <4362261a-c762-4666-84e2-03c9daa6c4d9@www.fastmail.com>
 <YzMmu3xfOtQwuFUx@redhat.com> <YzMrYAJQeSP2hDSs@redhat.com>
 <CAJh=p+5rQDBJJC8VNGL10KYgDeq-Hg5WK7avONCti03eJGH+ow@mail.gmail.com>
 <798fe353-9537-44fe-a76a-819e8c93abb5@www.fastmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="fE1aOEgntkr1nLH8"
Content-Disposition: inline
In-Reply-To: <798fe353-9537-44fe-a76a-819e8c93abb5@www.fastmail.com>
Subject: Re: [Virtio-fs] virtiofsd: Any reason why there's not an "openat2"
 sandbox mode?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Colin Walters <walters@verbum.org>
Cc: German Maglione <gmaglione@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org


--fE1aOEgntkr1nLH8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 27, 2022 at 01:51:41PM -0400, Colin Walters wrote:
>=20
>=20
> On Tue, Sep 27, 2022, at 1:27 PM, German Maglione wrote:
> >
> >> > Now all the development has moved to rust virtiofsd.
>=20
> Oh, awesome!!  The code there looks great.
>=20
> > I could work on this for the next major version and see if anything bre=
aks.
> > But I prefer to add this as a compilation feature, instead of a command=
 line
> > option that we will then have to maintain for a while.
>=20
> Hmm, what would be the issue with having the code there by default?  I th=
ink rather than any new command line option, we automatically use `openat2+=
RESOLVE_IN_ROOT` if the process is run as a nonzero uid.
>=20
> > Also, I don't see it as a sandbox feature, as Stefan mentioned, a compr=
omised
> > process can call openat2() without RESOLVE_IN_ROOT.=20
>=20
> I'm a bit skeptical honestly about how secure the existing namespace code=
 is against a compromised virtiofsd process.  The primary worry is guest fi=
lesystem traversals, right?  openat2+RESOLVE_IN_ROOT addresses that.  Plus =
being in Rust makes this dramatically safer.
>=20
> > I did some test with
> > Landlock to lock virtiofsd inside the shared directory, but IIRC it req=
uires a
> > kernel 5.13
>=20
> But yes, landlock and other things make sense, I just don't see these thi=
ngs as strongly linked.  IOW we shouldn't in my opinion block unprivileged =
virtiofsd on more sandboxing than openat2 already gives us.

I think openat2(RESOLVE_IN_ROOT) support should be added unless there is
another unprivileged mechanism that is stronger.

The security implications need to be covered in the user documentation
so people can decide whether using this mode is appropriate.

We should continue to explain the difference between a voluntary
mechanism like openat2(RESOLVE_IN_ROOT) and a mandatory mechanism like
mount namespaces with pivot_root(2). Rust programs are not immune to
arbitrary code execution, but it's less likely than with a C program.

Stefan

--fE1aOEgntkr1nLH8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmMzWZwACgkQnKSrs4Gr
c8hsNggAq2b4EiLGdaw/6VKEnOUsLflmhehlNssdGVaRQHdceOt4vB/4XqF39eb6
ER462uf7KqydVjM8/DVxK5VQY9/p64W1CsSQkx1C4+S1QCwx3R/pbrT3k9UfTjKP
yFe0+pRDjx9wTwLm/rXPwv8vtkQd0ikKYTrLXgHOlX2gEtj55kFlfAgJIFy3vk8n
P8P1QikfAhZYOXhuRJBJP7MofCJAJnpkQfn4CnFFpCpogyQwyWWgiRDfl7QfCDdV
/VwDvBFD7aJ2fEBz5yGhe281D0LtZeGaMeKDeg/visXZu8FZbviLdHy7s7c70Wex
VvJQDuGJ0NOGbxbwlu4g1gipRZaAXA==
=uTzR
-----END PGP SIGNATURE-----

--fE1aOEgntkr1nLH8--
