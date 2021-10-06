Date: Wed, 6 Oct 2021 11:26:28 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YV151ENHPk4x4bDf@stefanha-x1.localdomain>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-11-vgoyal@redhat.com>
	<YVsVp4rPILhz+/Eh@stefanha-x1.localdomain>
	<YVyw/wCkjn1JBtDJ@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pClmepGuOd5g+OUL"
Content-Disposition: inline
In-Reply-To: <YVyw/wCkjn1JBtDJ@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 10/13] virtiofsd: Custom threadpool for
 remote blocking posix locks requests
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, qemu-devel@nongnu.org, virtio-fs@redhat.com


--pClmepGuOd5g+OUL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 05, 2021 at 04:09:35PM -0400, Vivek Goyal wrote:
> On Mon, Oct 04, 2021 at 03:54:31PM +0100, Stefan Hajnoczi wrote:
> > On Thu, Sep 30, 2021 at 11:30:34AM -0400, Vivek Goyal wrote:
> > > Add a new custom threadpool using posix threads that specifically
> > > service locking requests.
> > >=20
> > > In the case of a fcntl(SETLKW) request, if the guest is waiting
> > > for a lock or locks and issues a hard-reboot through SYSRQ then virti=
ofsd
> > > unblocks the blocked threads by sending a signal to them and waking
> > > them up.
> > >=20
> > > The current threadpool (GThreadPool) is not adequate to service the
> > > locking requests that result in a thread blocking. That is because
> > > GLib does not provide an API to cancel the request while it is
> > > serviced by a thread. In addition, a user might be running virtiofsd
> > > without a threadpool (--thread-pool-size=3D0), thus a locking request
> > > that blocks, will block the main virtqueue thread that services reque=
sts
> > > from servicing any other requests.
> > >=20
> > > The only exception occurs when the lock is of type F_UNLCK. In this c=
ase
> > > the request is serviced by the main virtqueue thread or a GThreadPool
> > > thread to avoid a deadlock, when all the threads in the custom thread=
pool
> > > are blocked.
> > >=20
> > > Then virtiofsd proceeds to cleanup the state of the threads, release
> > > them back to the system and re-initialize.
> >=20
> > Is there another way to cancel SETLKW without resorting to a new thread
> > pool? Since this only matters when shutting down or restarting, can we
> > close all plock->fd file descriptors to kick the GThreadPool workers out
> > of fnctl()?
>=20
> Ok, I tested this. If a thread is blocked on OFD lock and another
> thread closes associated "fd", it does not unblock the thread
> which is blocked on lock. So closing OFD can't be used for unblocking
> a thread.
>=20
> Even if it could be, it can't be a replacement for a thread pool
> in general as we can't block main thread otherwise it can deadlock.
> But we could have used another glib thread pool (instead of a
> custom thread pool which can handle signals to unblock threads).
>=20
> If you are curious, here is my test program.
>=20
> https://github.com/rhvgoyal/misc/blob/master/virtiofs-tests/ofd-lock.c
>=20
> Comments in there explain how to use it. It can block on an OFD
> lock and one can send SIGUSR1 which will close fd.

Thanks for investigating this! Too bad that the semantics of SETLKW are
not usable:

I ran two instances on my system so that the second instance blocks in
SETLKW and found the same thing. fcntl(fd, F_OFD_SETLKW, &flock) return
success even though the other thread already closed the fd while the
main thread was blocked in fcntl().

Here is where it gets weird: lslocks(1) shows the OFD locks that are
acquired (process 1) and waiting (process 2). When process 1 terminates,
process 2 makes progress but lslocks(1) shows there are no OFD locks.

This suggests that when fcntl(2) returns success in process 2, the OFD
lock is immediately released by the kernel since the fd was already
closed beforehand. Process 2 would have no way of releasing the lock
since it already closed its fd. So the 0 return value does not really
mean success - there is no acquired OFD lock when fcntl(2) returns!

The problem is that doesn't return early with -EBADFD or similar when
fcntl(2) is blocked, so we cannot use close(fd) to interrupt it :(.

Stefan

--pClmepGuOd5g+OUL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFdedQACgkQnKSrs4Gr
c8gtmQgAnibAp62CvB1Blwam1wX9sfvLzAaPAtBFP6AMx4cbtjs2FxZAJC78uDzG
gOZKirtMtxkFb62ONNq60fTIgnIRXB6Zv9wSURgrp1pBAW2j6xochUMy/p3Ykiz4
Yz6HTsrQ47HqemmEnXNm6aF5pOrxCdW8Xco6v0o5BaeOOJEpa0zIzypAZsKWwwDn
3FD9QaPIEDctccA2FOAjQ1+yFsADBeadiRdGstEJq0HaitMwGrd6W3OG7eN/Wd2K
wgqkiyA2p7jb5xz9LcTDPKrkUAMsQr1lae0J/Wc66qnA0tqMHA5soKluYXBQyn/e
skYAXfp9LSD7h4qfevfl6EaZp17vow==
=kpxh
-----END PGP SIGNATURE-----

--pClmepGuOd5g+OUL--

