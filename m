Date: Thu, 6 May 2021 16:37:43 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJQNR2aTvyE5pWqk@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="lqhZRkdxYdMqldv1"
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-1-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 00/26] virtiofs dax patches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--lqhZRkdxYdMqldv1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 12:00:34PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
>   This series adds support for acceleration of virtiofs via DAX
> mapping, using features added in the 5.11 Linux kernel.
>=20
>   DAX originally existed in the kernel for mapping real storage
> devices directly into memory, so that reads/writes turn into
> reads/writes directly mapped into the storage device.
>=20
>   virtiofs's DAX support is similar; a PCI BAR is exposed on the
> virtiofs device corresponding to a DAX 'cache' of a user defined size.
> The guest daemon then requests files to be mapped into that cache;
> when that happens the virtiofsd sends filedescriptors and commands back
> to the QEMU that mmap's those files directly into the memory slot
> exposed to kvm.  The guest can then directly read/write to the files
> exposed by virtiofs by reading/writing into the BAR.
>=20
>   A typical invocation would be:
>      -device vhost-user-fs-pci,queue-size=3D1024,chardev=3Dchar0,tag=3Dmy=
fs,cache-size=3D4G
>=20
> and then the guest must mount with -o dax
>=20
>   Note that the cache doesn't really take VM up on the host, because
> everything placed there is just an mmap of a file, so you can afford
> to use quite a large cache size.
>=20
>   Unlike a real DAX device, the cache is a finite size that's
> potentially smaller than the underlying filesystem (especially when
> mapping granuality is taken into account).  Mapping, unmapping and
> remapping must take place to juggle files into the cache if it's too
> small.  Some workloads benefit more than others.
>=20
> Gotchas:
>   a) If something else on the host truncates an mmap'd file,
> kvm gets rather upset;  for this reason it's advised that DAX is
> currently only suitable for use on non-shared filesystems.
>=20
> (This series, with a couple of other patches, is at:
> https://gitlab.com/virtio-fs/qemu/-/tree/dgilbert-dax-2021-04-28 )

Overall this looks close but I don't think the FSETID support should be
added to QEMU. Please see my comment on the final patch.

Stefan

--lqhZRkdxYdMqldv1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCUDUcACgkQnKSrs4Gr
c8j9jwf+JxfBvM1p05OJ2XVmZKvl3iREksfk277QH1LHCLzurox+5YovRH9TAQ+F
ZJNQH23RrTYnJIGX2bxU5eG+xeOVY3LCn42gGg/uQPGTiqdK+fGm6CNwAHKGAogE
42pBqdOO9xxDCQxf3XbH1Uf5RHgGpj/M7kN9pnvna47WuKvTZypORRNCqYQyg0PA
Tzkrs636SFu6bpj0Sp+EWOBv3a94eEnFsHMmYqjxkkeprppK6V7oQ7eYRlXhpqJx
RvTQpfUCKtqmZGYNIxpxUqj6fZ0docDCxERkAEC0CJ9zcZsy2/FFvlDQA3x22Kby
6yiwtkPhSlXkKgq30szKNZjrJBx8KQ==
=aKdo
-----END PGP SIGNATURE-----

--lqhZRkdxYdMqldv1--

