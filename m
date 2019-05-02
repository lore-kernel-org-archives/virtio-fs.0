Date: Thu, 2 May 2019 05:46:50 -0600
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190502114650.GB6100@stefanha-x1.localdomain>
References: <20190416190858.16833-1-bo.liu@linux.alibaba.com>
	<20190416190858.16833-4-bo.liu@linux.alibaba.com>
	<20190417145121.GG2839@work-vm>
	<20190423120919.GG32465@stefanha-x1.localdomain>
	<20190423184915.pkqbggfrbazz4bfd@US-160370MP2.local>
	<20190425143323.GC17806@stefanha-x1.localdomain>
	<20190425212158.GA32135@redhat.com>
	<20190426090524.GB1249@stefanha-x1.localdomain>
	<20190501185916.GD2873@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <20190501185916.GD2873@work-vm>
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
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 01, 2019 at 07:59:17PM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > On Thu, Apr 25, 2019 at 05:21:58PM -0400, Vivek Goyal wrote:
> > > On Thu, Apr 25, 2019 at 03:33:23PM +0100, Stefan Hajnoczi wrote:
> > > > On Tue, Apr 23, 2019 at 11:49:15AM -0700, Liu Bo wrote:
> > > > > On Tue, Apr 23, 2019 at 01:09:19PM +0100, Stefan Hajnoczi wrote:
> > > > > > On Wed, Apr 17, 2019 at 03:51:21PM +0100, Dr. David Alan Gilber=
t wrote:
> > > > > > > * Liu Bo (bo.liu@linux.alibaba.com) wrote:
> > > > > > > > From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> > > > > > > >=20
> > > > > > > > When running xfstests test case generic/413, we found such =
issue:
> > > > > > > >     1, create a file in one virtiofsd mount point with dax =
enabled
> > > > > > > >     2, mmap this file, get virtual addr: A
> > > > > > > >     3, write(fd, A, len), here fd comes from another file i=
n another
> > > > > > > >        virtiofsd mount point without dax enabled, also note=
 here write(2)
> > > > > > > >        is direct io.
> > > > > > > >     4, this direct io will hang forever, because the virtio=
fsd has crashed.
> > > > > > > > Here is the stack:
> > > > > > > > [  247.166276] "echo 0 > /proc/sys/kernel/hung_task_timeout=
_secs" disables this message.
> > > > > > > > [  247.167171] t_mmap_dio      D    0  2335   2102 0x000000=
00
> > > > > > > > [  247.168006] Call Trace:
> > > > > > > > [  247.169067]  ? __schedule+0x3d0/0x830
> > > > > > > > [  247.170219]  schedule+0x32/0x80
> > > > > > > > [  247.171328]  schedule_timeout+0x1e2/0x350
> > > > > > > > [  247.172416]  ? fuse_direct_io+0x2e5/0x6b0 [fuse]
> > > > > > > > [  247.173516]  wait_for_completion+0x123/0x190
> > > > > > > > [  247.174593]  ? wake_up_q+0x70/0x70
> > > > > > > > [  247.175640]  fuse_direct_IO+0x265/0x310 [fuse]
> > > > > > > > [  247.176724]  generic_file_read_iter+0xaa/0xd20
> > > > > > > > [  247.177824]  fuse_file_read_iter+0x81/0x130 [fuse]
> > > > > > > > [  247.178938]  ? fuse_simple_request+0x104/0x1b0 [fuse]
> > > > > > > > [  247.180041]  ? fuse_fsync_common+0xad/0x240 [fuse]
> > > > > > > > [  247.181136]  __vfs_read+0x108/0x190
> > > > > > > > [  247.181930]  vfs_read+0x91/0x130
> > > > > > > > [  247.182671]  ksys_read+0x52/0xc0
> > > > > > > > [  247.183454]  do_syscall_64+0x55/0x170
> > > > > > > > [  247.184200]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > > > > >=20
> > > > > > > > And virtiofsd crashed because vu_gpa_to_va() can not handle=
 guest physical
> > > > > > > > address correctly. For a memory mapped area in dax mode, in=
deed the page
> > > > > > > > for this area points virtiofsd's cache area, or rather virt=
io pci device's
> > > > > > > > cache bar. In qemu, currently this cache bar is implemented=
 with an anonymous
> > > > > > > > memory and will not pass this cache bar's address info to v=
host-user backend,
> > > > > > > > so vu_gpa_to_va() will fail.
> > > > > > > >=20
> > > > > > > > To fix this issue, we create this vhost cache area with a f=
ile backend
> > > > > > > > memory area.
> > > > > > >=20
> > > > > > > Thanks,
> > > > > > >   I know there was another case of the daemon trying to acces=
s the
> > > > > > > buffer that Stefan and Vivek hit, but fixed by persuading the=
 kernel
> > > > > > > not to do it;  Stefan/Vivek: What do you think?
> > > > > >=20
> > > > > > That case happened with cache=3Dnone and the dax mount option.
> > > > > >=20
> > > > > > The general problem is when FUSE_READ/FUSE_WRITE is sent and th=
e buffer
> > > > > > is outside guest RAM.
> > >=20
> > > Stefan,
> > >=20
> > > Can this be emulated by sending a request to qemu? If virtiofsd can d=
etect
> > > that source/destination of READ/WRITE is not guest RAM, can it forward
> > > message to qemu to do this operation (which has access to all the DAX
> > > windows)?
> > >=20
> > > This probably will mean introducing new messages like
> > > setupmapping/removemapping messages between virtiofsd/qemu. =20
> >=20
> > Yes, interesting idea!
> >=20
> > When virtiofsd is unable to map the virtqueue iovecs due to addresses
> > outside guest RAM, it could forward READ/WRITE requests to QEMU along
> > with the file descriptor.  It would be slow but fixes the problem.
> >=20
> > Implementing this is a little tricky because the libvhost-user code
> > probably fails before fuse_lowlevel.c is able to parse the FUSE request
> > header.  It will require reworking libvhost-user and fuse_virtio.c code,
> > I think.
>=20
> Yes, this doesn't look too bad; I need to tweak
>    vu_queue_pop->vu_queue_map_desc->virtqueue_map_desc
> to give back a list of unmappable parts of the iovec
> (assuming that the first few elements of the iovec are
> mappable then the rest aren't and not allowing weird mixes).
>=20
> One thing that worries me a bit is that if we do a read() or write()
> in the qemu code, it might block on the mmap'd backing file.

Even a memcpy (no read()/write()) could block if the page is not
resident :(.  We have to expect that this operation could block.

Stefan

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlzK2JAACgkQnKSrs4Gr
c8iUewgAvhngcgOaAYmVrSkMiR/gIhOpyXBncTU6jeJ88mPrRuYOpPTfGiG1PBRm
3kC7Ouq1oo/+oUHwl1FSMNVhO6Jqjj9bkKs1U3kSyQ87BzyDMW1Yr5GxRbEooqgM
Mhv2wDNW22o3Auu6rXPzGsh9Tvvw+SLDfstAIsg+3+OWEd71/68O1XElUy+ISrRM
+mTqr+YCes2Xafiyg0X40Bnj1O5vcRVcxz0LvQ1OncWl3I1ckFAa7X/hX54jxSg+
RQVS97QNIA3jEP7nWPZPpJarSdwHpeO53WGxolKKzhccID8UHhNFGZVTrZEcMR5f
UBU+qNtonFD0midKQHP3rHay4s1Fkg==
=QTkE
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--

