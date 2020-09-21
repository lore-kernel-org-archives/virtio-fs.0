Date: Mon, 21 Sep 2020 09:39:23 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200921083923.GA71121@stefanha-x1.localdomain>
References: <20200918213436.GA3520@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <20200918213436.GA3520@redhat.com>
Subject: Re: [Virtio-fs] tools/virtiofs: Multi threading seems to hurt
	performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 18, 2020 at 05:34:36PM -0400, Vivek Goyal wrote:
> And here are the comparision results. To me it seems that by default
> we should switch to 1 thread (Till we can figure out how to make
> multi thread performance better even when single process is doing
> I/O in client).

Let's understand the reason before making changes.

Questions:
 * Is "1-thread" --thread-pool-size=3D1?
 * Was DAX enabled?
 * How does cache=3Dnone perform?
 * Does commenting out vu_queue_get_avail_bytes() + fuse_log("%s:
   Queue %d gave evalue: %zx available: in: %u out: %u\n") in
   fv_queue_thread help?
 * How do the kvm_stat vmexit counters compare?
 * How does host mpstat -P ALL compare?
 * How does host perf record -a compare?
 * Does the Rust virtiofsd show the same pattern (it doesn't use glib
   thread pools)?

Stefan

> NAME                    WORKLOAD                Bandwidth       IOPS     =
      =20
> cache-auto              seqread-psync           690(MiB/s)      172k     =
      =20
> cache-auto-1-thread     seqread-psync           729(MiB/s)      182k     =
      =20
>=20
> cache-auto              seqread-psync-multi     2578(MiB/s)     644k     =
      =20
> cache-auto-1-thread     seqread-psync-multi     2597(MiB/s)     649k     =
      =20
>=20
> cache-auto              seqread-mmap            660(MiB/s)      165k     =
      =20
> cache-auto-1-thread     seqread-mmap            672(MiB/s)      168k     =
      =20
>=20
> cache-auto              seqread-mmap-multi      2499(MiB/s)     624k     =
      =20
> cache-auto-1-thread     seqread-mmap-multi      2618(MiB/s)     654k     =
      =20
>=20
> cache-auto              seqread-libaio          286(MiB/s)      71k      =
      =20
> cache-auto-1-thread     seqread-libaio          260(MiB/s)      65k      =
      =20
>=20
> cache-auto              seqread-libaio-multi    1508(MiB/s)     377k     =
      =20
> cache-auto-1-thread     seqread-libaio-multi    986(MiB/s)      246k     =
      =20
>=20
> cache-auto              randread-psync          35(MiB/s)       9191     =
      =20
> cache-auto-1-thread     randread-psync          55(MiB/s)       13k      =
      =20
>=20
> cache-auto              randread-psync-multi    179(MiB/s)      44k      =
      =20
> cache-auto-1-thread     randread-psync-multi    209(MiB/s)      52k      =
      =20
>=20
> cache-auto              randread-mmap           32(MiB/s)       8273     =
      =20
> cache-auto-1-thread     randread-mmap           50(MiB/s)       12k      =
      =20
>=20
> cache-auto              randread-mmap-multi     161(MiB/s)      40k      =
      =20
> cache-auto-1-thread     randread-mmap-multi     185(MiB/s)      46k      =
      =20
>=20
> cache-auto              randread-libaio         268(MiB/s)      67k      =
      =20
> cache-auto-1-thread     randread-libaio         254(MiB/s)      63k      =
      =20
>=20
> cache-auto              randread-libaio-multi   256(MiB/s)      64k      =
      =20
> cache-auto-1-thread     randread-libaio-multi   155(MiB/s)      38k      =
      =20
>=20
> cache-auto              seqwrite-psync          23(MiB/s)       6026     =
      =20
> cache-auto-1-thread     seqwrite-psync          30(MiB/s)       7925     =
      =20
>=20
> cache-auto              seqwrite-psync-multi    100(MiB/s)      25k      =
      =20
> cache-auto-1-thread     seqwrite-psync-multi    154(MiB/s)      38k      =
      =20
>=20
> cache-auto              seqwrite-mmap           343(MiB/s)      85k      =
      =20
> cache-auto-1-thread     seqwrite-mmap           355(MiB/s)      88k      =
      =20
>=20
> cache-auto              seqwrite-mmap-multi     408(MiB/s)      102k     =
      =20
> cache-auto-1-thread     seqwrite-mmap-multi     438(MiB/s)      109k     =
      =20
>=20
> cache-auto              seqwrite-libaio         41(MiB/s)       10k      =
      =20
> cache-auto-1-thread     seqwrite-libaio         65(MiB/s)       16k      =
      =20
>=20
> cache-auto              seqwrite-libaio-multi   137(MiB/s)      34k      =
      =20
> cache-auto-1-thread     seqwrite-libaio-multi   214(MiB/s)      53k      =
      =20
>=20
> cache-auto              randwrite-psync         22(MiB/s)       5801     =
      =20
> cache-auto-1-thread     randwrite-psync         30(MiB/s)       7927     =
      =20
>=20
> cache-auto              randwrite-psync-multi   100(MiB/s)      25k      =
      =20
> cache-auto-1-thread     randwrite-psync-multi   151(MiB/s)      37k      =
      =20
>=20
> cache-auto              randwrite-mmap          31(MiB/s)       7984     =
      =20
> cache-auto-1-thread     randwrite-mmap          55(MiB/s)       13k      =
      =20
>=20
> cache-auto              randwrite-mmap-multi    124(MiB/s)      31k      =
      =20
> cache-auto-1-thread     randwrite-mmap-multi    213(MiB/s)      53k      =
      =20
>=20
> cache-auto              randwrite-libaio        40(MiB/s)       10k      =
      =20
> cache-auto-1-thread     randwrite-libaio        64(MiB/s)       16k      =
      =20
>=20
> cache-auto              randwrite-libaio-multi  139(MiB/s)      34k      =
      =20
> cache-auto-1-thread     randwrite-libaio-multi  212(MiB/s)      53k      =
      =20
>=20
>=20
>=20
>=20
>=20
>=20

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9oZrkACgkQnKSrs4Gr
c8hWWgf/caiEHK3xeTWTOvaSY9b2skEAqR34Apthl9YK89/J3rdzTcqQ3JqqIEQH
mmRbw387/xD6Fabms1CXgj2iASu9ZHby8egxiYC1W0um9cEroHJMncjxRTaFu2PC
4LMJc40jvRgTVNIkIYeQKNJBK0bW2PZsSLAgO1aP5+f5XemfNwQv6Jacew4i4ZP/
q91QjYyZPGcgJXzLHr3JpKymULAlq1HiMfov93mHp6CnoFaOpKdQ8sGth2RnTYsH
mVeXZLNYY/ZGp2r3DXl1Pdzgc1RN9tF7eglJXh3nbPhCGG2GRv7TcZq8oUyzx3jr
MEdIKCt7KH5W3XQnLeTYjqgUpyDDmw==
=xpCg
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--

