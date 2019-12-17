Date: Tue, 17 Dec 2019 19:22:31 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191217192231.GB1335010@stefanha-x1.localdomain>
References: <20191210145119.329731-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <20191210145119.329731-1-farosas@linux.ibm.com>
Subject: Re: [Virtio-fs] [PATCH 0/5] virtio-fs-ci: Add support for ppc64le
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Fabiano Rosas <farosas@linux.ibm.com>
Cc: virtio-fs@redhat.com


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2019 at 11:51:14AM -0300, Fabiano Rosas wrote:
> This series adds support for building a ppc64le qemu, kernel and rootfs
> in a ppc64le machine in both Fedora (untested) and Ubuntu.
>=20
> For QEMU:
> - change the QEMU target name based on the architecture;
> - alter configure options because ppc depends on fdt and the no-tcg
>   build is currently broken.
>=20
> For linux:
> - change the kernel image name (ppc does not build bzImage);
> - build the kernel config dynamically by adding the virtio-fs options
>   and turning modules to =3Dy.
>=20
> For rootfs:
> - add a more recent config.guess to blogbench otherwise it doesn't
>   build on ppc.
>=20
> For run-test:
> - change qemu binary name based on architecture;
> - change the serial console name (ppc uses hvc0);
> - change the kernel image name to match what was built (vmlinux).
>=20
>=20
> Fabiano Rosas (5):
>   build-qemu: Add support for ppc64le
>   Add virtio-fs kernel config snippet
>   build-linux: Add support for ppc64le
>   build-rootfs: Download latest config.guess for blogbench
>   run-test: Add support for ppc64le
>=20
>  build-linux.sh                                | 26 ++++++++++++++++---
>  build-qemu.sh                                 | 25 +++++++++++++++---
>  build-rootfs.sh                               |  2 +-
>  configs/virtio-fs                             |  8 ++++++
>  ...-virtio-fs =3D> x86_64-monolithic-virtio-fs} |  0
>  run-test.sh                                   | 23 ++++++++++++----
>  6 files changed, 71 insertions(+), 13 deletions(-)
>  create mode 100644 configs/virtio-fs
>  rename configs/{config-monolithic-virtio-fs =3D> x86_64-monolithic-virti=
o-fs} (100%)
>=20
> --=20
> 2.23.0
>=20

Thanks, applied!

Stefan

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl35KvcACgkQnKSrs4Gr
c8hikAf/TJ80L5KHkAVKblLtoQPptytpPQoPIaMhZgFkxuaqEeo10/zYt7JFx5Vk
sUQYbRNUpHDW9Y2UQKXaym3YdH//gHFrWeIc3NPVstrRtePvJJsokMdbMBBtcHgU
RSqt09sUioH0NX12nM7N+M48ZVb7Q4zXTtAfiHsIW147f6nWL7aTKmwa+Z1jICta
wsbJCJ1BiokjORpTWAokbPPzTPmaM7DIwiXM5ksM/OptLldatZfM7LLbj0Q51FQp
QsMKvWMBMsnu+FldnLJw/EDFvpJlZ5HULKrWFXi2ONrnuf7TrQpDgn76eq7oM/LH
OHwRnJpzcO5w743qBRUyO9+eM2f1Nw==
=pH4J
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--

