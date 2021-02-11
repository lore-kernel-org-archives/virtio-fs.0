Date: Thu, 11 Feb 2021 12:41:45 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210211124145.GN247031@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-14-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tpyx7gKuSYt+mjHM"
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-14-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 13/24] DAX: virtiofsd: Make
	lo_removemapping() work
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com, mst@redhat.com


--tpyx7gKuSYt+mjHM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 07:02:13PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> From: Vivek Goyal <vgoyal@redhat.com>
>=20
> Let guest pass in the offset in dax window a mapping is currently
> mapped at and needs to be removed.
>=20
> Vivek added the initial support to remove single mapping and later Peng
> added patch to support removing multiple mappings in single command.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--tpyx7gKuSYt+mjHM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlJgkACgkQnKSrs4Gr
c8gv6ggAt7o8D5KrYv0lhlbHz0vL+9buvBKhYo5kqvt9vY87FYNbLNBZLdKYslzL
616NXlwAp90xMZXBbNhntOEU8O9nMKfQLgF645ePG1NsvW08OSSw5+1HC0yEkHFc
rE89wTrW/VCrMG1PEinuAjom+BnCRMtaIi83OmKCYP6nU3537CwOgRrm0FFgBsSo
ztR2Lbcm+OIRzPChP4QayWt7gLLXwYdn3qohaPrE02yAC+GzWaPpUgce1gwj0gjj
w8UYHrvjUWnpJEfPR/IJXSFEMuipC9Hgd7jdgs8Z2eSUAqmqxUFIB1Tq9gWJv+sN
Dn5VohT2NcJnApsXqyunCZNt8tWX8w==
=GZqo
-----END PGP SIGNATURE-----

--tpyx7gKuSYt+mjHM--

