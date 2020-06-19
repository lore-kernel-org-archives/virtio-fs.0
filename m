Date: Fri, 19 Jun 2020 16:25:43 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200619152543.GF2424182@stefanha-x1.localdomain>
References: <CALfysxrU1WNcWhzRUXboMSjZLsOz_J=BC1y_heye8juk+L-fSA@mail.gmail.com>
	<20200609125040.GG92564@stefanha-x1.localdomain>
	<CALfysxpKT0C1Eu8whTr-i4YdUp93sNBPSdriH-L68Qx03HE_jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Zs/RYxT/hKAHzkfQ"
Content-Disposition: inline
In-Reply-To: <CALfysxpKT0C1Eu8whTr-i4YdUp93sNBPSdriH-L68Qx03HE_jQ@mail.gmail.com>
Subject: Re: [Virtio-fs] How to setup virtiofs for file sharing between host
 and VM
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Boris Ebwanga <bbebwanga@gmail.com>
Cc: virtio-fs@redhat.com


--Zs/RYxT/hKAHzkfQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 11, 2020 at 06:04:58PM +0100, Boris Ebwanga wrote:
> Hello!
> I was able to modify the XML domain without errors.
>=20
> Now, the guest failed to start. It shows this error message:
> erreur :internal error: process exited while connecting to monitor:
> 2020-06-11T16:53:58.809703Z qemu-system-x86_64: -chardev
> socket,id=3Dchar0,path=3D/home/deharteloos/tmp/vhost-fs.sock: Failed to c=
onnect
> socket /home/deharteloos/tmp/vhost-fs.sock: Permission denied
>=20
> I don't know how to solve this problem.

Have you checked the UNIX permissions for all components in the
/home/deharteloos/tmp/vhost-fs.sock path? It should work if directories
have execute permission and the UNIX domain socket has read permission
for "other users" (the chmod syntax for that is o+x on directories and
o+r on the socket).

It may also help to temporarily disable SELinux.

Libvirt sets all this up securely and automatically, so if you get a
chance to use libvirt 6.2 then you won't need to worry about it.

Stefan

--Zs/RYxT/hKAHzkfQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7s2PcACgkQnKSrs4Gr
c8h/ywf/f3+Cg7oOvXwOowZi3X/hQGNZET0+Rpx17x7E0ORJi4KmpFqiD9mFuRHe
MjFLj05rmHRKkO1neDXoiaimN7SdHsSLYFtJopz2dvSbNjhLTtBzesGiOFdrFbYN
cIMMbAObmuYFNih0NDvq8ZIjNq2Z/rjVbJPht6Fbsz9UPa/LJnIeL3d1MWJY1rxs
l2KfOiAgf/9GgMywJPx1e79Q5QFeFm0VUwxe5dUqFAWQxyY/rXbSikyRSmcxAQOD
l1QNcZjhQtIigCAcswqnUpIZoj/bc9O6DGIRXQft0xBhCZ1mmUQkabUHh7IYXynr
v/xgsN7VxJiNyfNJ7piqref++YTccg==
=KiXX
-----END PGP SIGNATURE-----

--Zs/RYxT/hKAHzkfQ--

