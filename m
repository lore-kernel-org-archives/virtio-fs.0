Date: Fri, 26 Apr 2019 10:05:24 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190426090524.GB1249@stefanha-x1.localdomain>
References: <20190416190858.16833-1-bo.liu@linux.alibaba.com>
	<20190416190858.16833-4-bo.liu@linux.alibaba.com>
	<20190417145121.GG2839@work-vm>
	<20190423120919.GG32465@stefanha-x1.localdomain>
	<20190423184915.pkqbggfrbazz4bfd@US-160370MP2.local>
	<20190425143323.GC17806@stefanha-x1.localdomain>
	<20190425212158.GA32135@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <20190425212158.GA32135@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2019 at 05:21:58PM -0400, Vivek Goyal wrote:
> On Thu, Apr 25, 2019 at 03:33:23PM +0100, Stefan Hajnoczi wrote:
> > On Tue, Apr 23, 2019 at 11:49:15AM -0700, Liu Bo wrote:
> > > On Tue, Apr 23, 2019 at 01:09:19PM +0100, Stefan Hajnoczi wrote:
> > > > On Wed, Apr 17, 2019 at 03:51:21PM +0100, Dr. David Alan Gilbert wr=
ote:
> > > > > * Liu Bo (bo.liu@linux.alibaba.com) wrote:
> > > > > > From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> > > > > >=20
> > > > > > When running xfstests test case generic/413, we found such issu=
e:
> > > > > >     1, create a file in one virtiofsd mount point with dax enab=
led
> > > > > >     2, mmap this file, get virtual addr: A
> > > > > >     3, write(fd, A, len), here fd comes from another file in an=
other
> > > > > >        virtiofsd mount point without dax enabled, also note her=
e write(2)
> > > > > >        is direct io.
> > > > > >     4, this direct io will hang forever, because the virtiofsd =
has crashed.
> > > > > > Here is the stack:
> > > > > > [  247.166276] "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s" disables this message.
> > > > > > [  247.167171] t_mmap_dio      D    0  2335   2102 0x00000000
> > > > > > [  247.168006] Call Trace:
> > > > > > [  247.169067]  ? __schedule+0x3d0/0x830
> > > > > > [  247.170219]  schedule+0x32/0x80
> > > > > > [  247.171328]  schedule_timeout+0x1e2/0x350
> > > > > > [  247.172416]  ? fuse_direct_io+0x2e5/0x6b0 [fuse]
> > > > > > [  247.173516]  wait_for_completion+0x123/0x190
> > > > > > [  247.174593]  ? wake_up_q+0x70/0x70
> > > > > > [  247.175640]  fuse_direct_IO+0x265/0x310 [fuse]
> > > > > > [  247.176724]  generic_file_read_iter+0xaa/0xd20
> > > > > > [  247.177824]  fuse_file_read_iter+0x81/0x130 [fuse]
> > > > > > [  247.178938]  ? fuse_simple_request+0x104/0x1b0 [fuse]
> > > > > > [  247.180041]  ? fuse_fsync_common+0xad/0x240 [fuse]
> > > > > > [  247.181136]  __vfs_read+0x108/0x190
> > > > > > [  247.181930]  vfs_read+0x91/0x130
> > > > > > [  247.182671]  ksys_read+0x52/0xc0
> > > > > > [  247.183454]  do_syscall_64+0x55/0x170
> > > > > > [  247.184200]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > > >=20
> > > > > > And virtiofsd crashed because vu_gpa_to_va() can not handle gue=
st physical
> > > > > > address correctly. For a memory mapped area in dax mode, indeed=
 the page
> > > > > > for this area points virtiofsd's cache area, or rather virtio p=
ci device's
> > > > > > cache bar. In qemu, currently this cache bar is implemented wit=
h an anonymous
> > > > > > memory and will not pass this cache bar's address info to vhost=
-user backend,
> > > > > > so vu_gpa_to_va() will fail.
> > > > > >=20
> > > > > > To fix this issue, we create this vhost cache area with a file =
backend
> > > > > > memory area.
> > > > >=20
> > > > > Thanks,
> > > > >   I know there was another case of the daemon trying to access the
> > > > > buffer that Stefan and Vivek hit, but fixed by persuading the ker=
nel
> > > > > not to do it;  Stefan/Vivek: What do you think?
> > > >=20
> > > > That case happened with cache=3Dnone and the dax mount option.
> > > >=20
> > > > The general problem is when FUSE_READ/FUSE_WRITE is sent and the bu=
ffer
> > > > is outside guest RAM.
>=20
> Stefan,
>=20
> Can this be emulated by sending a request to qemu? If virtiofsd can detect
> that source/destination of READ/WRITE is not guest RAM, can it forward
> message to qemu to do this operation (which has access to all the DAX
> windows)?
>=20
> This probably will mean introducing new messages like
> setupmapping/removemapping messages between virtiofsd/qemu. =20

Yes, interesting idea!

When virtiofsd is unable to map the virtqueue iovecs due to addresses
outside guest RAM, it could forward READ/WRITE requests to QEMU along
with the file descriptor.  It would be slow but fixes the problem.

Implementing this is a little tricky because the libvhost-user code
probably fails before fuse_lowlevel.c is able to parse the FUSE request
header.  It will require reworking libvhost-user and fuse_virtio.c code,
I think.

Stefan

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJcwsnUAAoJEJykq7OBq3PIy5UH/0Uj2mMnYf8vwpUR8Gc0u613
f2dbsQbiRxaHgh6q1JtAqY8V97ImOeqNCHpGdJ/2rgdNKQVvAubux86TeLQ6H2Fm
QvndX7ty8unv5mYAjAiOzmbDJFyoIdj9oN7t56vaLjwMF+3lLDgiLf64zzpFwD65
HyCXAjgRZ4E1Luq7YYOVYNHI02SNxsPswKF9DGAZH0e0P89pRG2QErUsAQzZPaUk
FZxcVuBH1Dt545q7HpyA/Pwg7uie5897iUPp1yxtBjNhDQmtAWBm5lOq1WHHFpNS
ZOVpBngqPj4rui2XRHQg8QXrXzMVLF43+uFQflbjBj/UkipUn4Agyr8sozo/GDg=
=B7YB
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--

