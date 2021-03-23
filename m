Date: Tue, 23 Mar 2021 13:33:17 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YFnuHV/Swn96Py4W@stefanha-x1.localdomain>
References: <714BD741-AE3F-4BC5-8DFB-F5C74A8623B1@netapp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GIZz4J+lcAlTdrrD"
Content-Disposition: inline
In-Reply-To: <714BD741-AE3F-4BC5-8DFB-F5C74A8623B1@netapp.com>
Subject: Re: [Virtio-fs] Live migration support for virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Ge, Xiongzi" <Xiongzi.Ge@netapp.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, mreitz@redhat.com


--GIZz4J+lcAlTdrrD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 23, 2021 at 01:35:58AM +0000, Ge, Xiongzi wrote:
> It seems that virtio-fs does not support live migration. Once a vm is con=
figured with virtio-fs, live migration cannot be performed even it is not m=
ounted on the guest. Is there any progress for this? If the shared director=
y is from a distributed file system like Ceph, would it be easier than the =
general case to be implemented?=20

The virtio-fs device holds a bunch of state, like the ino_map, dirp_map,
and the fd_map in the virtiofsd C implementation. That is the FUSE
session state that needs to be migrated in order to resume seamlessly
(without unmounting and mounting again).

If the backend is a distributed file system then it my have APIs that
make migration easier. If it's possible to re-attach to open files from
another host then that is perfect. But on the flipside if there are no
APIs for doing that then it might be impossible to reliably live
migration because some state cannot be transferred between hosts.

Max Reitz is laying the foundation for live migration by working on
open_by_handle_at(2) support. This will probably be needed in order to
transfer open files from one host to another.

It should be possible to enable live migration when the filesystem is
not mounted. That might be a good first step to enabling live migration.

Stefan

--GIZz4J+lcAlTdrrD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBZ7h0ACgkQnKSrs4Gr
c8hDKAgAsLAVRXqOQzK7BdxBjfPGYpU+2F+86ii/T4HW1cafjVqE0YMH4tBQNK7Y
N/h5cdIkAEQpc9eyQt1iTgcm0VC93xB4jkK2E8kYM1rOaR67rUt0fbBumhAFYukF
vOjtpzHD9FpICjNDhosXrPEKmW8HuCDrSAhCsPfCN9qwq16x6OaV18yjbxKeXErC
xhJjTvdSUtCLZalJKwV7MIhZy13ZcLvu27P+tNG61P2poZFHOnb0WNNY8FJuiwjQ
mjyZU4RnIcsOEfgS8oaSXgZ3EIIcz+VliQjmwHELH82naW4qNRyjSBQ7Y/ShBUjn
JerjrYvlqnwzQosaGtEnpEBLZmQBwg==
=mlHo
-----END PGP SIGNATURE-----

--GIZz4J+lcAlTdrrD--

