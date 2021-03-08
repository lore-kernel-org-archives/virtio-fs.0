Date: Mon, 8 Mar 2021 15:15:44 +0100
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20210308141544.3ioxhrcu6uhiwukj@mhamilton>
References: <34a26a91-c73d-18cb-95ad-9b2c6192091c@redhat.com>
	<20210308090650.i5ow6pq23asygrod@mhamilton>
	<b2b29e3c-f87b-03fd-a465-2ac6d1084a82@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="thcu6gozsh6ud5zn"
Content-Disposition: inline
In-Reply-To: <b2b29e3c-f87b-03fd-a465-2ac6d1084a82@redhat.com>
Subject: Re: [Virtio-fs] Securing file handles
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>


--thcu6gozsh6ud5zn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 08, 2021 at 11:52:58AM +0100, Max Reitz wrote:
> On 08.03.21 10:06, Sergio Lopez wrote:
> > On Fri, Mar 05, 2021 at 05:22:56PM +0100, Max Reitz wrote:
> > > =3D=3D Summary =3D=3D
> > >=20
> > > So, my current position is:
> > >=20
> > > - Bind mounts don=E2=80=99t help with restricting file handles to the=
 exported
> > >    directory.
> > >=20
> > > - A MAC is not very elegant, and we might encounter problems where a
> > >    file may be moved outside of the shared directory, but remains
> > >    accessible (because moving a file doesn=E2=80=99t change its handl=
e).
> > >    (If we consider that a problem.  NFS evidently doesn=E2=80=99t, be=
cause
> > >    without subtree_check, it has absolutely no protection against
> > >    arbitrary file handles being opened (on the FS where the export
> > >    resides), so valid file handles always remain valid.)
> > >=20
> > > - A solution such as NFS=E2=80=99s subtree_check (i.e., storing the f=
ile=E2=80=99s
> > >    parent=E2=80=99s handle in addition to the file=E2=80=99s handle i=
tself, then
> > >    verifying that the file does still reside in that directory when t=
he
> > >    handle is opened, and then going up the tree to see whether we can
> > >    trace it back to the shared directory) is interesting and can perh=
aps
> > >    be considered elegant, but it requires iterating the directory the
> > >    file resides in when it is opened, and it will result in file hand=
les
> > >    being invalidated whenever a file is moved (outside of its directo=
ry).
> > >    Perhaps also other issues.  In any case, there are reasons why NFS=
 has
> > >    basically deprecated this.
> > >=20
> > > Opinions? :)
> >=20
> > While the MAC option doesn't look too bad to me, I can't help but feel
> > that we're working around a kernel (mis)feature, which is something
> > that's risky and tends to backfire.
>=20
> Which misfeature do you mean exactly?  That you can open arbitrary files =
by
> specifying the right magic number (i.e. its handle)?
>=20
> That in itself is nothing we=E2=80=99re really working around, but rather=
 something
> that we actively want to pass through to the guest.

But I think those file handles should be constrained to some context
other than the backing file system. In any case, I see Miklos has
highlighted the same issue with more detail in his response, so let's
follow up this conversation there to avoid dispersion.

Sergio.

--thcu6gozsh6ud5zn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmBGMY8ACgkQ9GknjS8M
AjX88A//eAD4YaYJ9iFU+e/ugRCBvA6t/CepzQZqGpwJxxy+Kv3Zh++mZZ0tUYJo
wK9fAYieljSYr7Cw1SxwkQNmSkSZ9q/wzXBiTcEbQPLvLBFXWoD+ipKLT4HqViWO
54u4OTHrMSBbghkmxLs1WOA/46kxEgJqPFulgvUPF4IxSfMyIAzba2/a1okyJLdS
2IDcM0BkkylvbJbBsZsrRzwb+kUvzfcFXmgMkMuMI8/hhnYgm6LczxTF8Tlpcb1o
guBTg072XGcYZ2eQXJDQHl0UQHcZ7w6BSzhCXlzVEa0inV+9O3oNMC20tvfzig0I
DOYGBDQB99+B9nku0Eiz3hpuPhIfaNg7NQ2DXuMTPEQtGnq4362ZPD1MCIzb9i9X
kwVyWAsUcz8wWd3aG3ofI4bjXP0JVmyttY5NS9OqBr8Vu77pwpQcUdZtkNHav8jW
oND+gGis5o1Ue5Q8wHmPH2owYuJ+v9DDJ7AUIY/np14v9mfih9VWyxt0aKCt7lTS
9I9JDjo8E+YAL6A8i0L/oFz9DRTPg5zyBjPfKIrIugj0JitdzTNr82YpGuvJck7B
i1DQPKQAYtJj8TxvyH/4wjElgec/53AA3O07ZX5Ss/7AcOXZgEqCzCrsW8bd1P3+
Q9X6YhRS1T6nb1LuOJQ6zVXulcFZSja8SygJ6jl6sZ9OhZWp/bs=
=lRme
-----END PGP SIGNATURE-----

--thcu6gozsh6ud5zn--

