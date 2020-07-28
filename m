Date: Tue, 28 Jul 2020 14:49:36 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200728134936.GA21660@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <CAFKS8hWbckrE_cyJCf0pgFresD-JQk66wo-6uJA=Gu2MhReHVw@mail.gmail.com>
Subject: Re: [Virtio-fs] virtio-fs performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: jwsu1986@gmail.com
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, qemu-discuss@nongnu.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> I'm trying and testing the virtio-fs feature in QEMU v5.0.0.
> My host and guest OS are both ubuntu 18.04 with kernel 5.4, and the
> underlying storage is one single SSD.
>=20
> The configuations are:
> (1) virtiofsd
> ./virtiofsd -o=20
> source=3D/mnt/ssd/virtiofs,cache=3Dauto,flock,posix_lock,writeback,xattr
> --thread-pool-size=3D1 --socket-path=3D/tmp/vhostqemu
>=20
> (2) qemu
> qemu-system-x86_64 \
> -enable-kvm \
> -name ubuntu \
> -cpu Westmere \
> -m 4096 \
> -global kvm-apic.vapic=3Dfalse \
> -netdev tap,id=3Dhn0,vhost=3Doff,br=3Dbr0,helper=3D/usr/local/libexec/qem=
u-bridge-helper
> \
> -device e1000,id=3De0,netdev=3Dhn0 \
> -blockdev '{"node-name": "disk0", "driver": "qcow2",
> "refcount-cache-size": 1638400, "l2-cache-size": 6553600, "file": {
> "driver": "file", "filename": "'${imagefolder}\/ubuntu.qcow2'"}}' \
> -device virtio-blk,drive=3Ddisk0,id=3Ddisk0 \
> -chardev socket,id=3Dch0,path=3D/tmp/vhostqemu \
> -device vhost-user-fs-pci,chardev=3Dch0,tag=3Dmyfs \
> -object memory-backend-memfd,id=3Dmem,size=3D4G,share=3Don \
> -numa node,memdev=3Dmem \
> -qmp stdio \
> -vnc :0
>=20
> (3) guest
> mount -t virtiofs myfs /mnt/virtiofs
>=20
> I tried to change virtiofsd's --thread-pool-size value and test the
> storage performance by fio.
> Before each read/write/randread/randwrite test, the pagecaches of
> guest and host are dropped.
>=20
> ```
> RW=3D"read" # or write/randread/randwrite
> fio --name=3Dtest --rw=3D$RW --bs=3D4k --numjobs=3D1 --ioengine=3Dlibaio
> --runtime=3D60 --direct=3D0 --iodepth=3D64 --size=3D10g
> --filename=3D/mnt/virtiofs/testfile
> done
> ```
>=20
> --thread-pool-size=3D64 (default)
>     seq read: 305 MB/s
>     seq write: 118 MB/s
>     rand 4KB read: 2222 IOPS
>     rand 4KB write: 21100 IOPS
>=20
> --thread-pool-size=3D1
>     seq read: 387 MB/s
>     seq write: 160 MB/s
>     rand 4KB read: 2622 IOPS
>     rand 4KB write: 30400 IOPS
>=20
> The results show the performance using default-pool-size (64) is
> poorer than using single thread.
> Is it due to the lock contention of the multiple threads?
> When can virtio-fs get better performance using multiple threads?
>=20
>=20
> I also tested the performance that guest accesses host's files via
> NFSv4/CIFS network filesystem.
> The "seq read" and "randread" performance of virtio-fs are also worse
> than the NFSv4 and CIFS.
>=20
> NFSv4:
>   seq write: 244 MB/s
>   rand 4K read: 4086 IOPS
>=20
> I cannot figure out why the perf of NFSv4/CIFS with the network stack
> is better than virtio-fs.
> Is it expected? Or, do I have an incorrect configuration?

No, I remember benchmarking the thread pool and did not see such a big
difference.

Please use direct=3D1 so that each I/O results in a virtio-fs request.
Otherwise the I/O pattern is not directly controlled by the benchmark
but by the page cache (readahead, etc).

Using numactl(8) or taskset(1) to launch virtiofsd allows you to control
NUMA and CPU scheduling properties. For example, you could force all 64
threads to run on the same host CPU using taskset to see if that helps
this I/O bound workload.

fio can collect detailed statistics on queue depths and a latency
histogram. It would be interesting to compare the --thread-pool-size=3D64
and --thread-pool-size=3D1 numbers.

Comparing the "perf record -e kvm:kvm_exit" counts between the two might
also be interesting.

Stefan

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8gLPAACgkQnKSrs4Gr
c8gjegf8Df/59da0oKXZgqtOYrjLMp/b4LKjG7pvRgSill4J8rxGVW2ABdp7cquh
mc7nOiMU3NwOnh6bn9PkQ1v590QI9KcSGeaGy8T4Z+MbEx4BqkNuZ+dHNsid7KuK
QbSQxxPrT16sktgjQnFIT+G3JF3jvkoaQvS1n3zB7IV7SzOZyDvycgERRLzVVdYh
fy9hWFLf6dTRUeraxFG/cHX1KUmFnbEpPFQqKVYx7f4RZ5KIzgnV0zCvudTNOhup
aJ57dETC5CukcklT3Nn5mnLRRircE99n8bWjL7/2X2jv8aAl89wcL5klixdZNU8G
CLL2XAY/06/ZyyE9xPyQbNfBHJWAaw==
=Zc/F
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--

