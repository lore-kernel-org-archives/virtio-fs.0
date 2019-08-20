Date: Tue, 20 Aug 2019 10:13:31 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190820091331.GD9855@stefanha-x1.localdomain>
References: <484b6fd5-fa26-ce94-a18f-63c8c41692ee@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BI5RvnYi6R4T2M87"
Content-Disposition: inline
In-Reply-To: <484b6fd5-fa26-ce94-a18f-63c8c41692ee@huawei.com>
Subject: Re: [Virtio-fs] A performance problem for buffer write
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: wangyan <wangyan122@huawei.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "Fangyi (C)" <eric.fangyi@huawei.com>


--BI5RvnYi6R4T2M87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 08, 2019 at 07:25:25PM +0800, wangyan wrote:
> Hi all,
> 	I meet a performance problem when I test buffer write.
> =09
> 	Test environment:
> 		Guest Kernel:
> 			https://github.com/rhvgoyal/linux/tree/virtio-fs-dev-5.1
> 		Host Qemu:
> 			https://gitlab.com/virtio-fs/qemu/tree/virtio-fs-dev
>=20
> 	I format a ramdisk to be a ext4 filesystem, and mount it for a shared
> folder.
> 	In the qemu build directory, run:
> 		./virtiofsd -o vhost_user_socket=3D/tmp/vhostqemu -o source=3D/mnt/9psh=
are/ -o
> cache=3Dalways -o writeback
> 	and
> 		./x86_64-softmmu/qemu-system-x86_64 -M pc -cpu host --enable-kvm -smp 2=
 -m
> 8G,maxmem=3D8G -object
> memory-backend-file,id=3Dmem,size=3D8G,mem-path=3D/dev/hugepages,share=3D=
on -numa
> node,memdev=3Dmem -drive
> if=3Dnone,id=3Droot,format=3Dqcow2,file=3D/mnt/sdb/mirrors/os.qcow2 -devi=
ce
> virtio-scsi -device scsi-disk,drive=3Droot,bootindex=3D1 -object iothread=
,id=3Dio
> -device virtio-scsi-pci,iothread=3Dio -net nic,model=3Dvirtio -net
> tap,ifname=3Dtap0,script=3D/etc/qemu-ifup,downscript=3Dno -vnc 0.0.0.0:0 =
-chardev
> socket,id=3Dchar0,path=3D/tmp/vhostqemu -device
> vhost-user-fs-pci,queue-size=3D1024,chardev=3Dchar0,tag=3Dmyfs,cache-size=
=3D2G
>=20
> 	Test Result:
> 		1. the bandwidth of buffer write is just 691894KB/s, it is very bad. The
> test model:
> 			fio -filename=3D/mnt/virtiofs/test -rw=3Dwrite -bs=3D1M -size=3D1G -io=
depth=3D1
> -ioengine=3Dpsync -numjobs=3D1 -group_reporting -name=3D1M -time_based -r=
untime=3D30
> 			1M: (g=3D0): rw=3Dwrite, bs=3D1M-1M/1M-1M/1M-1M, ioengine=3Dpsync, iod=
epth=3D1
> 			fio-2.13
> 			Starting 1 process
> 			4K: Laying out IO file(s) (1 file(s) / 1024MB)
> 			Jobs: 1 (f=3D1): [W(1)] [100.0% done] [0KB/695.2MB/0KB /s] [0/695/0 io=
ps]
> [eta 00m:00s]
> 			4K: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D5580: Thu Aug  8 18:29:20=
 2019
> 			  write: io=3D20271MB, bw=3D691894KB/s, iops=3D675, runt=3D 30001msec
> 				clat (usec): min=3D359, max=3D12348, avg=3D1423.88, stdev=3D1587.96
> 				 lat (usec): min=3D407, max=3D12399, avg=3D1475.98, stdev=3D1588.17
>=20
>=20
> 		2. the avg lat is 6.64usec, it is very high. The test model:
> 			fio -filename=3D/mnt/virtiofs/test -rw=3Dwrite -bs=3D4K -size=3D1G -io=
depth=3D1
> -ioengine=3Dpsync -numjobs=3D1 -group_reporting -name=3D4K -time_based -r=
untime=3D30
> 			4K: (g=3D0): rw=3Dwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dpsync, iod=
epth=3D1
> 			fio-2.13
> 			Starting 1 process
> 			Jobs: 1 (f=3D1): [W(1)] [100.0% done] [0KB/478.9MB/0KB /s] [0/123K/0 i=
ops]
> [eta 00m:00s]
> 			4K: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D5685: Thu Aug  8 18:35:51=
 2019
> 			  write: io=3D13302MB, bw=3D454013KB/s, iops=3D113503, runt=3D 30001ms=
ec
> 				clat (usec): min=3D2, max=3D7196, avg=3D 6.03, stdev=3D75.27
> 				lat (usec): min=3D3, max=3D7196, avg=3D 6.64, stdev=3D75.27
>=20
> 	I found that the judgement statement 'if (!TestSetPageDirty(page))' alwa=
ys
> true in function '__set_page_dirty_nobuffers', it will waste much time to
> mark inode dirty, no one page is dirty when write it the second time.
> 	The buffer write stack:
> 		fuse_file_write_iter
> 			->fuse_cache_write_iter
> 				->generic_file_write_iter
> 					->__generic_file_write_iter
> 						->generic_perform_write
> 							->fuse_write_end
> 								->set_page_dirty
> 									->__set_page_dirty_nobuffers
> =09
> 	The reason for 'if (!TestSetPageDirty(page))' always true may be the
> pdflush process will call the function fuse_writepages, and it will clean
> the page's dirty sign in write_cache_pages, and call fuse_writepages_send=
 to
> flush all pages to the disk of the host. So when the page is write the
> second time, it always not dirty.
> =09
> 	I want to know is there any problems in this write-back procedure.

Hi,
It's likely that few people have tried the FUSE writeback feature with
virtio-fs so far.

Have you found out any more information since sending this email?

Stefan

--BI5RvnYi6R4T2M87
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1bubsACgkQnKSrs4Gr
c8gFwwf/e5ukrPDIEs1Za79Rt7NaHDWwMZwQ5acfz3ecIHCqOJkPacPMipPFBJyQ
J+RVJsLJHAbvf+k8vvhJwtLfPKCZgzOWKgG/u+rR+1mv099hBm3rjieP6pF/W9dr
QzaGdGKdT5kV4eGZZBeEVTvOKxQrqqGv7S6gmvgNtYSN/9i/wsfI68R5kFB2K+mh
oOsK2n5tyWLIsACuULaIW+3xMbag5kv6g/YXC9zq5kf7XQf/Id6MAKsEG2nBFrC1
Ko3HgpMt53hLY5cQZ+dTn7UvzQ3/tHos71C8EMEB6quNvQWEnDpJUwFxD1GxC4fu
TRtUbYL/m8l7rbNqHI1zaC6a4sm97Q==
=Yqsj
-----END PGP SIGNATURE-----

--BI5RvnYi6R4T2M87--

