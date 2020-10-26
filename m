Date: Mon, 26 Oct 2020 15:53:31 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201026155331.GD52035@stefanha-x1.localdomain>
References: <20201023165812.36028-1-dgilbert@redhat.com>
	<20201023165812.36028-3-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/unnNtmY43mpUSKx"
Content-Disposition: inline
In-Reply-To: <20201023165812.36028-3-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 2/5] tools/virtiofsd: xattr name
 mappings: Map client xattr names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: dinechin@redhat.com, virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--/unnNtmY43mpUSKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2020 at 05:58:09PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Map xattr names originating at the client; from get/set/remove xattr.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 101 ++++++++++++++++++++++++++++++-
>  1 file changed, 98 insertions(+), 3 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--/unnNtmY43mpUSKx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+W8PsACgkQnKSrs4Gr
c8gG1wf+NLwQSl/ljSoEDi/UFH8LTDnuaqR1DKJzBqqscU6JcB9e+VC/cllFvGbV
NGV9dwUz3+xmwSsuYGGebo1cn9tWIIqlaBLmpleu+FPKHmyUVHIo0+CqiRrFUO4X
aEbGQmCIQ80zQXch3x4iZyyH93U2eWQUdIkpttgoAgCxTgqGZbwTSempo8W5oxZo
dV4Yxa1yeqmTdIdfyH1w6b/te9epxb3cwjc5uAAMGW+COasQ246qk0I61WD44LaD
ItsE3dBVvW08pHlA4QhSvSicKNaKZRRnMCnDDJM/h37al/lHUm1bWj+dcIJl9Vue
7U2dKjy7ZXXa9Wz8+zzsg/+efiKX5w==
=Fgeh
-----END PGP SIGNATURE-----

--/unnNtmY43mpUSKx--

