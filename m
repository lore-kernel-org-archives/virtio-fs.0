Date: Thu, 8 Aug 2019 09:32:26 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190808083226.GB31476@stefanha-x1.localdomain>
References: <20190807212610.GG18557@redhat.com>
	<1E91073893EF8F498411079ED374F912460D57A6@ORSMSX115.amr.corp.intel.com>
	<1E91073893EF8F498411079ED374F912460D57F0@ORSMSX115.amr.corp.intel.com>
	<20190808002305.GB24807@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Content-Disposition: inline
In-Reply-To: <20190808002305.GB24807@redhat.com>
Subject: Re: [Virtio-fs] Rebased kernel patches to 5.3-rc kernel
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, "Boeuf,
	Sebastien" <sebastien.boeuf@intel.com>


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 07, 2019 at 08:23:05PM -0400, Vivek Goyal wrote:
> On Wed, Aug 07, 2019 at 11:23:35PM +0000, Boeuf, Sebastien wrote:
> > Hi Vivek, I just tried the new kernel and I run into issues with my VMM.
> > When I try to mount from inside the guest with the following command:
> > # mount -t virtio_fs /dev/null mount_dir/ -o tag=3Dmyfs,rootmode=3D0400=
00,user_id=3D0,group_id=3D0,dax
> >=20
> > I realized the mount command changed into this:
> > mount -t virtio_fs myfs mount_dir/ -o rootmode=3D040000,user_id=3D0,gro=
up_id=3D0,dax
>=20
> Hi Sebastien,
>=20
> Adding virtio-fs list back. I think its a good idea to keep conversation
> on list, just in case others face similar issues.
>=20
> >=20
> > It'd be nice to update it from the official documentation.
>=20
> Yes it will be nice to update doc.
>=20
> Stefan, can you please take care of updating docs. We will have to mention
> for 4.19 kernel syntax is different and for latest kernel syntax is
> different.

Yes, I'll publish updated instructions.

Stefan

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1L3hoACgkQnKSrs4Gr
c8iRGgf8Dqy/9kg7IZ9mOlyMK73Ao85dlIpWstg56AXI6fWIH81RJl7MZy+jiZMq
iSM7kiRp2m5B5926iOVcd9d4bpNsr9x8/w4HvT7H1Rkm+O6i4KpY+54HvZChC6MS
WgHqgvvnS/UkXME8coSPepwNB+Eo6902r43jlQrKN4dee/IDPJUhx3u5VXpjTPtS
4XDzco3bsf4jqgff8ORHPLgZssS22vkXPnlAJ47z+5weikP/2LYpRqKXBCvg4TgD
PWOoArr+BnwJN+jI1ptRjldWZIUdRBEeAevOr8xVYs4QmQGiBd0uDWljArQyhEEs
De9Un9VgVctEjRMbtH1SWXCecYwdRw==
=MIq0
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--

