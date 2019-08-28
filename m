Date: Wed, 28 Aug 2019 12:39:09 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190828113909.GJ5573@stefanha-x1.localdomain>
References: <5D4D0D06.1090602@huawei.com>
	<20190821153802.GB9095@stefanha-x1.localdomain>
	<5D633104.6030000@huawei.com>
	<20190827144258.GF6901@stefanha-x1.localdomain>
	<5D66279D.5000507@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ONvqYzh+7ST5RsLk"
Content-Disposition: inline
In-Reply-To: <5D66279D.5000507@huawei.com>
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


--ONvqYzh+7ST5RsLk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2019 at 03:05:01PM +0800, piaojun wrote:
>=20
>=20
> On 2019/8/27 22:42, Stefan Hajnoczi wrote:
> > On Mon, Aug 26, 2019 at 09:08:20AM +0800, piaojun wrote:
> >> On 2019/8/21 23:38, Stefan Hajnoczi wrote:
> >>> On Fri, Aug 09, 2019 at 02:04:54PM +0800, piaojun wrote:
> >>>> Set cpu affinity for each queue in multiqueue mode to improve the io=
ps
> >>>> performance.
> >>>>
> >>>> >From my test, the iops is increased by adding multiqueues as below,
> >>>> but it has not achieved my expect yet due to some reason. So I'm
> >>>> considering if we could drop some locks when operating vq as it is
> >>>> binded to one vCPU. I'm very glad to have a discuss with other
> >>>> developers.
> >>>>
> >>>> Further more, I modified virtiofsd to support multiqueue which just =
for
> >>>> testing.
> >>>>
> >>>> Test Environment:
> >>>> Guest configuration:
> >>>> 8 vCPU
> >>>> 8GB RAM
> >>>> Linux 5.1 (vivek-aug-06-2019)
> >>>>
> >>>> Host configuration:
> >>>> Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz (8 cores x 4 threads)
> >>>> 32GB RAM
> >>>> Linux 3.10.0
> >>>> EXT4 + 4G Ramdisk
> >>>>
> >>>> ---
> >>>> Single-queue:
> >>>> # fio -direct=3D1 -time_based -iodepth=3D128 -rw=3Drandwrite -ioengi=
ne=3Dlibaio -bs=3D4k -size=3D1G -numjob=3D8 -runtime=3D30 -group_reporting =
-name=3Dfile -filename=3D/mnt/virtiofs/file
> >>>> file: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dli=
baio, iodepth=3D128
> >>>> ...
> >>>> fio-2.13
> >>>> Starting 8 processes
> >>>> Jobs: 8 (f=3D8): [w(8)] [100.0% done] [0KB/316.5MB/0KB /s] [0/81.2K/=
0 iops] [eta 00m:00s]
> >>>> file: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D5808: Fri Aug  9 20:3=
5:22 2019
> >>>>   write: io=3D9499.9MB, bw=3D324251KB/s, iops=3D81062, runt=3D 30001=
msec
> >>>>
> >>>> Multi-queues:
> >>>> # fio -direct=3D1 -time_based -iodepth=3D128 -rw=3Drandwrite -ioengi=
ne=3Dlibaio -bs=3D4k -size=3D1G -numjob=3D8 -runtime=3D30 -group_reporting =
-name=3Dfile -filename=3D/mnt/virtiofs/file
> >>>> file: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dli=
baio, iodepth=3D128
> >>>> ...
> >>>> fio-2.13
> >>>> Starting 8 processes
> >>>> Jobs: 8 (f=3D8): [w(8)] [100.0% done] [0KB/444.6MB/0KB /s] [0/114K/0=
 iops] [eta 00m:00s]
> >>>> file: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D5704: Fri Aug  9 20:3=
8:47 2019
> >>>>   write: io=3D12967MB, bw=3D442582KB/s, iops=3D110645, runt=3D 30001=
msec
> >>>> ---
> >>>
> >>> How does the same fio command-line perform on the host when bound to 8
> >>> CPUs?
> >>
> >> fio has great performance on host side, so the bottleneck should be at=
 virtiofsd.
> >>
> >> ---
> >> Run status group 0 (all jobs):
> >>   WRITE: bw=3D12.7GiB/s (13.6GB/s), 12.7GiB/s-12.7GiB/s (13.6GB/s-13.6=
GB/s), io=3D381GiB (409GB), run=3D30001-30001msec
> >=20
> > Using just one file?
>=20
> Also 8 files.

Great, this makes me a little happier :).  I was worried that the host
could achieve very high throughput on just a single file while the guest
cannot.

> I run the fio testcases again, and find out the bottleneck is not the
> serialization in guest kernel:
>=20
> ---
> 8 Files:
> Jobs: 8 (f=3D8): [W(8)] [100.0% done] [0KB/1559MB/0KB /s] [0/1558/0 iops]=
 [eta 00m:00s]
> file1: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D6540: Wed Aug 28 22:49:51=
 2019
>   write: io=3D46367MB, bw=3D1545.3MB/s, iops=3D1545, runt=3D 30006msec
>=20
> Single File:
> Jobs: 8 (f=3D8): [W(8)] [100.0% done] [0KB/1567MB/0KB /s] [0/1566/0 iops]=
 [eta 00m:00s]
> file1: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D6569: Wed Aug 28 22:50:33=
 2019
>   write: io=3D47315MB, bw=3D1576.9MB/s, iops=3D1576, runt=3D 30006msec

Also good news.

> >> Multi-Queues(8):
> >> Jobs: 8 (f=3D8): [W(8)] [100.0% done] [0KB/4064MB/0KB /s] [0/4064/0 io=
ps] [eta 00m:00s]
> >> file1: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D5785: Mon Aug 26 16:26=
:46 2019
> >>   write: io=3D115421MB, bw=3D3847.2MB/s, iops=3D3847, runt=3D 30002msec
> >>
> >> I write a draft patch for virtiofsd, but the sandbox make it hard to
> >> set affinity for each vq, as _SC_NPROCESSORS_ONLN always equals 1. So I
> >> just delete the related code for testing. Maybe we could create a
> >> thread pool before setup_sandbox() or some effective way. I'm glad to
> >> help finding out the solution.
> >=20
> > Doing the setup before entering the sandbox sounds like a good idea.
> > That way the sandbox does not need to whitelist the required syscalls.
> >=20
> > Will you add an option similar to:
> >=20
> >   --request-queues N
> >   --request-queue-cpu-affinity N=3DCPU_A[,CPU_B][-CPU_C]
> >=20
> > ?
>=20
> I'm writing the multi-queue code for virtiofsd according to your
> suggestion, but the final shape may look a bit different.

Excellent, I look forward to your patches.

Stefan

--ONvqYzh+7ST5RsLk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1mZ90ACgkQnKSrs4Gr
c8hTMQgAjUNu3SlSpvdshHxYNVd38YGZl6y4nwguNpYkxnuZySSlE6tYibrPY6PQ
yZVYuht3ipR994TIyhoqubIzjwgegNLNA0Pgzo+Dq0D71qwzKgMdiUzqDuH65ylB
+P7pl+xGRLugDGpWnCAMLqn2iZ+i0iQA1QJn8S/TAHh05uVlilSyRPTOmNpe+ofm
meHXxXZI8+cQQhI4ClLaKkGtiKhiDxh1GqvU15k9ydD7HFiKEfeKUGJPCwOqtdua
0AQ79VzcP567QOxbwcE8KgQweDIIHvpY0xPE1V1WiAtVvX0cIkl7MN16I+GHEsKr
eX4Y7lIdnlgb2xKwPgbQHt18yFABcQ==
=/hgR
-----END PGP SIGNATURE-----

--ONvqYzh+7ST5RsLk--

