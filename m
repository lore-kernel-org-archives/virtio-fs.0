Date: Wed, 5 Aug 2020 12:52:29 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200805115229.GF361702@stefanha-x1.localdomain>
References: <CAFKS8hWbckrE_cyJCf0pgFresD-JQk66wo-6uJA=Gu2MhReHVw@mail.gmail.com>
	<20200728134936.GA21660@stefanha-x1.localdomain>
	<CAFKS8hVwajyBFrVSURs1bS0F+ig8PSUAi1+YPUpe6=KYH8TjmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SnV5plBeK2Ge1I9g"
Content-Disposition: inline
In-Reply-To: <CAFKS8hVwajyBFrVSURs1bS0F+ig8PSUAi1+YPUpe6=KYH8TjmA@mail.gmail.com>
Subject: Re: [Virtio-fs] virtio-fs performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Derek Su <jwsu1986@gmail.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, qemu-discuss@nongnu.org


--SnV5plBeK2Ge1I9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 04, 2020 at 03:37:26PM +0800, Derek Su wrote:
> Set the cache=3Dnone in virtiofsd and direct=3D1 in fio,
> here are the results and kvm-exit count in 5 seconds.
>=20
> --thread-pool-size=3D64 (default)
>     seq read: 307 MB/s (kvm-exit count=3D1076463)
>     seq write: 430 MB/s (kvm-exit count=3D1302493)
>     rand 4KB read: 65.2k IOPS (kvm-exit count=3D1322899)
>     rand 4KB write: 97.2k IOPS (kvm-exit count=3D1568618)
>=20
> --thread-pool-size=3D1
>     seq read: 303 MB/s (kvm-exit count=3D1034614)
>     seq write: 358 MB/s. (kvm-exit count=3D1537735)
>     rand 4KB read: 7995 IOPS (kvm-exit count=3D438348)
>     rand 4KB write: 97.7k IOPS (kvm-exit count=3D1907585)
>=20
> The thread-pool-size=3D64 improves the rand 4KB read performance largely,
> but doesn't increases the kvm-exit count too much.
>=20
> In addition, the fio avg. clat of rand 4K write are 960us for
> thread-pool-size=3D64 and 7700us for thread-pool-size=3D1.

These numbers make sense to me. The thread pool is generally faster.

Note that virtiofsd opens files without O_DIRECT, even if with the
cache=3Dnone option. This explains why rand 4KB write reaches 97.7K but
rand 4KB read only does 7885 IOPS (random reads result in page cache
misses on the host).

I don't have a good explanation of why the thread pool was slower with
direct=3D0 though :(. One way to investigate that is by checking whether
the I/O pattern submitted by the guest is comparable between
--thread-pool-size=3D64 and --thread-pool-size=3D1. You could try to observe
this by tracing virtiofsd preadv()/pwritev() system calls.

If you find that --thread-pool-size=3D64 made more I/O requests and with
smaller block sizes, then it's probably a timing issue where the guest
page cache responds differently because the virtiofsd thread pool
completes requests at a different rate. Maybe it affects how the guest
page cache is populated and a slower virtiofsd leads to more efficient
page cache activity in the guest (-> fewer and bigger FUSE read/write
requests)?

Stefan

--SnV5plBeK2Ge1I9g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8qnX0ACgkQnKSrs4Gr
c8hVrAf9FfJqBahHMhq7wxLOV5zfxam1rcnDhEpaDL68RpdXZ9jXO4RPOB7+nP3T
a3dhz/0sz7V4ribDPUgU/iTXg6Zn4j9MNwV/dN8rfVRy/J0DPqqViI7yXOu6ICz2
vzhKtoRHSksAjWjqgYI+DKBGGKXjdMjoq1VqyOucVA18qgVJTBquKr0e6YdoZ5SX
+JtteOmyOcp2AXUIyBswTqWfBthlDonnTl53oKWyGydV4NxWVB7jdaL0F1K5/XYU
TfMBT1udLN1ceudRRLbqA34pjpJ0cz+McLoM9AkSKUihaKEaIg8YA4cjFTXwhg69
VSFCHrpjJx7ctOroURO1s5adWLQxng==
=gfxr
-----END PGP SIGNATURE-----

--SnV5plBeK2Ge1I9g--

