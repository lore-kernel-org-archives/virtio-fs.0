Date: Tue, 27 Aug 2019 15:42:58 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190827144258.GF6901@stefanha-x1.localdomain>
References: <5D4D0D06.1090602@huawei.com>
	<20190821153802.GB9095@stefanha-x1.localdomain>
	<5D633104.6030000@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="TU+u6i6jrDPzmlWF"
Content-Disposition: inline
In-Reply-To: <5D633104.6030000@huawei.com>
Subject: Re: [Virtio-fs] [PATCH][RFC] Support multiqueue mode by setting cpu
 affinity
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com


--TU+u6i6jrDPzmlWF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 26, 2019 at 09:08:20AM +0800, piaojun wrote:
> On 2019/8/21 23:38, Stefan Hajnoczi wrote:
> > On Fri, Aug 09, 2019 at 02:04:54PM +0800, piaojun wrote:
> >> Set cpu affinity for each queue in multiqueue mode to improve the iops
> >> performance.
> >>
> >> >From my test, the iops is increased by adding multiqueues as below,
> >> but it has not achieved my expect yet due to some reason. So I'm
> >> considering if we could drop some locks when operating vq as it is
> >> binded to one vCPU. I'm very glad to have a discuss with other
> >> developers.
> >>
> >> Further more, I modified virtiofsd to support multiqueue which just for
> >> testing.
> >>
> >> Test Environment:
> >> Guest configuration:
> >> 8 vCPU
> >> 8GB RAM
> >> Linux 5.1 (vivek-aug-06-2019)
> >>
> >> Host configuration:
> >> Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz (8 cores x 4 threads)
> >> 32GB RAM
> >> Linux 3.10.0
> >> EXT4 + 4G Ramdisk
> >>
> >> ---
> >> Single-queue:
> >> # fio -direct=3D1 -time_based -iodepth=3D128 -rw=3Drandwrite -ioengine=
=3Dlibaio -bs=3D4k -size=3D1G -numjob=3D8 -runtime=3D30 -group_reporting -n=
ame=3Dfile -filename=3D/mnt/virtiofs/file
> >> file: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dliba=
io, iodepth=3D128
> >> ...
> >> fio-2.13
> >> Starting 8 processes
> >> Jobs: 8 (f=3D8): [w(8)] [100.0% done] [0KB/316.5MB/0KB /s] [0/81.2K/0 =
iops] [eta 00m:00s]
> >> file: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D5808: Fri Aug  9 20:35:=
22 2019
> >>   write: io=3D9499.9MB, bw=3D324251KB/s, iops=3D81062, runt=3D 30001ms=
ec
> >>
> >> Multi-queues:
> >> # fio -direct=3D1 -time_based -iodepth=3D128 -rw=3Drandwrite -ioengine=
=3Dlibaio -bs=3D4k -size=3D1G -numjob=3D8 -runtime=3D30 -group_reporting -n=
ame=3Dfile -filename=3D/mnt/virtiofs/file
> >> file: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dliba=
io, iodepth=3D128
> >> ...
> >> fio-2.13
> >> Starting 8 processes
> >> Jobs: 8 (f=3D8): [w(8)] [100.0% done] [0KB/444.6MB/0KB /s] [0/114K/0 i=
ops] [eta 00m:00s]
> >> file: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D5704: Fri Aug  9 20:38:=
47 2019
> >>   write: io=3D12967MB, bw=3D442582KB/s, iops=3D110645, runt=3D 30001ms=
ec
> >> ---
> >=20
> > How does the same fio command-line perform on the host when bound to 8
> > CPUs?
>=20
> fio has great performance on host side, so the bottleneck should be at vi=
rtiofsd.
>=20
> ---
> Run status group 0 (all jobs):
>   WRITE: bw=3D12.7GiB/s (13.6GB/s), 12.7GiB/s-12.7GiB/s (13.6GB/s-13.6GB/=
s), io=3D381GiB (409GB), run=3D30001-30001msec

Using just one file?

> >=20
> > What about the virtiofsd changes?  Did you implement host CPU affinity
> > for the virtqueue processing threads and their workqueues?
> >=20
> > I wonder if numbers are better if you use 8 files instead of 1 file.
> >=20
> I implement host CPU affinity and re-design the testcase with 8 files,
> the result looks better:
>=20
> ---
> [global]
> runtime=3D30
> time_based
> group_reporting
> direct=3D1
> bs=3D1M
> size=3D1G
> ioengine=3Dlibaio
> rw=3Dwrite
> numjobs=3D8
> iodepth=3D128
> thread=3D1
>=20
> [file1]
> filename=3D/mnt/virtiofs/file1
> numjobs=3D1
> [file2]
> filename=3D/mnt/virtiofs/file2
> numjobs=3D1
> [file3]
> filename=3D/mnt/virtiofs/file3
> numjobs=3D1
> [file4]
> filename=3D/mnt/virtiofs/file4
> numjobs=3D1
> [file5]
> filename=3D/mnt/virtiofs/file5
> numjobs=3D1
> [file6]
> filename=3D/mnt/virtiofs/file6
> numjobs=3D1
> [file7]
> filename=3D/mnt/virtiofs/file7
> numjobs=3D1
> [file8]
> filename=3D/mnt/virtiofs/file8
> numjobs=3D1
>=20
> Single-Queue:
> Jobs: 8 (f=3D8): [W(8)] [100.0% done] [0KB/1594MB/0KB /s] [0/1594/0 iops]=
 [eta 00m:00s]
> file1: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D6379: Mon Aug 26 16:24:10=
 2019
>   write: io=3D46676MB, bw=3D1555.6MB/s, iops=3D1555, runt=3D 30007msec

The result improves greatly when using separate files.  I wonder what
the bottleneck is, maybe serialization in the guest kernel?

>=20
> Multi-Queues(8):
> Jobs: 8 (f=3D8): [W(8)] [100.0% done] [0KB/4064MB/0KB /s] [0/4064/0 iops]=
 [eta 00m:00s]
> file1: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D5785: Mon Aug 26 16:26:46=
 2019
>   write: io=3D115421MB, bw=3D3847.2MB/s, iops=3D3847, runt=3D 30002msec
>=20
> I write a draft patch for virtiofsd, but the sandbox make it hard to
> set affinity for each vq, as _SC_NPROCESSORS_ONLN always equals 1. So I
> just delete the related code for testing. Maybe we could create a
> thread pool before setup_sandbox() or some effective way. I'm glad to
> help finding out the solution.

Doing the setup before entering the sandbox sounds like a good idea.
That way the sandbox does not need to whitelist the required syscalls.

Will you add an option similar to:

  --request-queues N
  --request-queue-cpu-affinity N=3DCPU_A[,CPU_B][-CPU_C]

?

For example, with 2 request queues where queue#1 is bound to CPUs 0-4
and queue#2 is bound to CPUs 2, 6, and 8:

  --request-queues 2
  --request-queue-cpu-affinity 1=3D0-4
  --request-queue-cpu-affinity 2=3D5,6,8

Stefan

--TU+u6i6jrDPzmlWF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1lQXIACgkQnKSrs4Gr
c8jKGwgAhtTr35yZXKqkOkQ4rUWyQ4ZnPvTNPeeEL4COf+MnxJQEssoZQ1JVqaCr
ZecCjUJOEBRIT5jZx3KnYT0FwJ22L7kcOAbEwtBPJqBJnu0FIex9cujFItXIDLwP
i19rA33us5D7tdlO71rdRrB8i0Br7cPZWRDLusJmwffgEIm5vwiAU0vhPNwzdZqr
YF56CtQ8CBwY/JsdHqcb19Z0SPSFkph2vm8oqetb+dYISNfxlBMLMqTZkW/g3wlr
vRAzKZ92O4n4lZwnDEpF0XxkQVy9rYwPZ7FVhdgQKV50vdU0QKltWbwTYqx2B3Ga
fpmZI24Q8XK2rnDYHYAAIM9SB/7Uig==
=he1v
-----END PGP SIGNATURE-----

--TU+u6i6jrDPzmlWF--

