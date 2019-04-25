Date: Thu, 25 Apr 2019 15:33:23 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190425143323.GC17806@stefanha-x1.localdomain>
References: <20190416190858.16833-1-bo.liu@linux.alibaba.com>
	<20190416190858.16833-4-bo.liu@linux.alibaba.com>
	<20190417145121.GG2839@work-vm>
	<20190423120919.GG32465@stefanha-x1.localdomain>
	<20190423184915.pkqbggfrbazz4bfd@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UPT3ojh+0CqEDtpF"
Content-Disposition: inline
In-Reply-To: <20190423184915.pkqbggfrbazz4bfd@US-160370MP2.local>
Subject: Re: [Virtio-fs] [PATCH 3/4] virtiofsd: use file-backend memory
 region for virtiofsd's cache area
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com


--UPT3ojh+0CqEDtpF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2019 at 11:49:15AM -0700, Liu Bo wrote:
> On Tue, Apr 23, 2019 at 01:09:19PM +0100, Stefan Hajnoczi wrote:
> > On Wed, Apr 17, 2019 at 03:51:21PM +0100, Dr. David Alan Gilbert wrote:
> > > * Liu Bo (bo.liu@linux.alibaba.com) wrote:
> > > > From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> > > >=20
> > > > When running xfstests test case generic/413, we found such issue:
> > > >     1, create a file in one virtiofsd mount point with dax enabled
> > > >     2, mmap this file, get virtual addr: A
> > > >     3, write(fd, A, len), here fd comes from another file in another
> > > >        virtiofsd mount point without dax enabled, also note here wr=
ite(2)
> > > >        is direct io.
> > > >     4, this direct io will hang forever, because the virtiofsd has =
crashed.
> > > > Here is the stack:
> > > > [  247.166276] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
> > > > [  247.167171] t_mmap_dio      D    0  2335   2102 0x00000000
> > > > [  247.168006] Call Trace:
> > > > [  247.169067]  ? __schedule+0x3d0/0x830
> > > > [  247.170219]  schedule+0x32/0x80
> > > > [  247.171328]  schedule_timeout+0x1e2/0x350
> > > > [  247.172416]  ? fuse_direct_io+0x2e5/0x6b0 [fuse]
> > > > [  247.173516]  wait_for_completion+0x123/0x190
> > > > [  247.174593]  ? wake_up_q+0x70/0x70
> > > > [  247.175640]  fuse_direct_IO+0x265/0x310 [fuse]
> > > > [  247.176724]  generic_file_read_iter+0xaa/0xd20
> > > > [  247.177824]  fuse_file_read_iter+0x81/0x130 [fuse]
> > > > [  247.178938]  ? fuse_simple_request+0x104/0x1b0 [fuse]
> > > > [  247.180041]  ? fuse_fsync_common+0xad/0x240 [fuse]
> > > > [  247.181136]  __vfs_read+0x108/0x190
> > > > [  247.181930]  vfs_read+0x91/0x130
> > > > [  247.182671]  ksys_read+0x52/0xc0
> > > > [  247.183454]  do_syscall_64+0x55/0x170
> > > > [  247.184200]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > >=20
> > > > And virtiofsd crashed because vu_gpa_to_va() can not handle guest p=
hysical
> > > > address correctly. For a memory mapped area in dax mode, indeed the=
 page
> > > > for this area points virtiofsd's cache area, or rather virtio pci d=
evice's
> > > > cache bar. In qemu, currently this cache bar is implemented with an=
 anonymous
> > > > memory and will not pass this cache bar's address info to vhost-use=
r backend,
> > > > so vu_gpa_to_va() will fail.
> > > >=20
> > > > To fix this issue, we create this vhost cache area with a file back=
end
> > > > memory area.
> > >=20
> > > Thanks,
> > >   I know there was another case of the daemon trying to access the
> > > buffer that Stefan and Vivek hit, but fixed by persuading the kernel
> > > not to do it;  Stefan/Vivek: What do you think?
> >=20
> > That case happened with cache=3Dnone and the dax mount option.
> >=20
> > The general problem is when FUSE_READ/FUSE_WRITE is sent and the buffer
> > is outside guest RAM.
> >
>=20
> Can you please elaborate how the buffer is outside guest RAM?
> Is it also via direct IO?

The DAX window is a PCI BAR on the virtio-fs PCI device.  It is not
guest RAM.

vhost-user only shares guest RAM with the vhost-user device backend
process (virtiofsd).  Therefore virtiofsd does not have access to the
contents of the DAX window.

This only happens when the virtio-fs file system is mounted with the
"dax" option.

> > >=20
> > > It worries me a little exposing the area back to the daemon; the guest
> > > can write the BAR and change the mapping, I doubt anything would noti=
ce
> > > that (but also I doubt it happens much).
> >=20
> > If two virtiofsd processes are involved then it's even harder since they
> > do not have up-to-date access the other's DAX window.
> >=20
>=20
> In case of direct IO, kvm is able to make sure that guest's dax
> mapping is sync'd with the underlying host mmap region, isn't it?

See my explanation above.  In theory a virtiofsd could keep track of the
mapping region by performing the same mmap(2) system calls as the QEMU
process based on the FUSE_SETUPMAPPING requests (currently only QEMU
does the mmaps).  What I'm saying here is that it gets even harder when
multiple virtiofsd processes are involved because they do not have
access to each other's DAX windows.

Stefan

--UPT3ojh+0CqEDtpF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJcwcUzAAoJEJykq7OBq3PInUMH/0n5Yac6uMRUu7V3j6xbNhnU
7lDu1zqK4pxly6HGpgmdsX3F67ODdFMtBHEEdkLmSCMwbfhP40weLveHqtQ3Ivh1
jtQwTVMwNIA2en0deNeqXz5Zicot7zr9V9Mglqu4ZHWTvZT1n1LMIkSmQoF5yKCC
59d6vy4Qpcpsrx/b3cCW/NcWdYPeMp97XCt7OqkdkmiKf2/EcQQgDVRFcdOn4piw
3PnYmZysagjSKvSnQdzOehqnnLWrDk2YagM4z2UN58CILKhq+aq7lq2yVcqUOtWp
3qjWrgkiGDgP4TkXr3SBXTJ5UDk5/gG6jHhwnyZh3dgvXLQDzLxjPDCo9nLaFkc=
=eW3l
-----END PGP SIGNATURE-----

--UPT3ojh+0CqEDtpF--

