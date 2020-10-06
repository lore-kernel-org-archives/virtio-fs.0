Date: Tue, 6 Oct 2020 10:04:27 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201006090427.GA41482@stefanha-x1.localdomain>
References: <5ea77e9f6cb8c2db43b09fbd4158ab2d8c066a0a.camel@redhat.com>
	<a2810c3a656115fab85fc173186f3e2c02a98182.camel@redhat.com>
	<20201004143119.GA58616@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <20201004143119.GA58616@redhat.com>
Subject: Re: [Virtio-fs] virtiofs: WARN_ON(out_sgs + in_sgs != total_sgs)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Qian Cai <cai@redhat.com>, linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 04, 2020 at 10:31:19AM -0400, Vivek Goyal wrote:
> On Fri, Oct 02, 2020 at 10:44:37PM -0400, Qian Cai wrote:
> > On Fri, 2020-10-02 at 12:28 -0400, Qian Cai wrote:
> > > Running some fuzzing on virtiofs from a non-privileged user could tri=
gger a
> > > warning in virtio_fs_enqueue_req():
> > >=20
> > > WARN_ON(out_sgs + in_sgs !=3D total_sgs);
> >=20
> > Okay, I can reproduce this after running for a few hours:
> >=20
> > out_sgs =3D 3, in_sgs =3D 2, total_sgs =3D 6
>=20
> Thanks. I can also reproduce it simply by calling.
>=20
> ioctl(fd, 0x5a004000, buf);
>=20
> I think following WARN_ON() is not correct.
>=20
> WARN_ON(out_sgs + in_sgs !=3D total_sgs)
>=20
> toal_sgs should actually be max sgs. It looks at ap->num_pages and
> counts one sg for each page. And it assumes that same number of
> pages will be used both for input and output.
>=20
> But there are no such guarantees. With above ioctl() call, I noticed
> we are using 2 pages for input (out_sgs) and one page for output (in_sgs).
>=20
> So out_sgs=3D4, in_sgs=3D3 and total_sgs=3D8 and warning triggers.
>=20
> I think total sgs is actually max number of sgs and warning
> should probably be.
>=20
> WARN_ON(out_sgs + in_sgs >  total_sgs)
>=20
> Stefan, WDYT?

It should be possible to calculate total_sgs precisely (not a maximum).
Treating it as a maximum could hide bugs.

Maybe sg_count_fuse_req() should count in_args/out_args[numargs -
1].size pages instead of adding ap->num_pages.

Do you have the details of struct fuse_req and struct fuse_args_pages
fields for the ioctl in question?

Thanks,
Stefan

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl98MxsACgkQnKSrs4Gr
c8gfnwf+MqC6BshRLBrYU+tLmXR6WJwbG8X0i6P2g42yuD/GJ4WOYHVPw2oEdnc/
OwEMYJ9LWwFiYmhT5DeapDx9XmVJVMlPeQ6GjkRilgo53OGu3IMi3T3JIOHKN4ZZ
nCwWqrE1CA4bVx7sX6HUKOqGwLhOIs1DrAen/sNjEtbKi2Bum1OTpo5uWDQuGEIn
BwYfQmuuSL/lBpz2Um+le97b8YskkC01oJAMONlNtQZqhYyZKl67Xbqq219Mnyzv
O0uePL5gPQr1pNOknKXmgOsZUSHn5XamPiNz2LbHFVGRswIUM0BCNFVTnfOeRi7r
Zm0jNqFLkavBPraEY08HjFnbBTwLDQ==
=Ol2A
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--

