Date: Thu, 8 Apr 2021 17:20:47 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YG8tXxdyakzkyI0h@stefanha-x1.localdomain>
References: <714BD741-AE3F-4BC5-8DFB-F5C74A8623B1@netapp.com>
	<YFnC9QXo6uP+2zC1@work-vm> <20210323145312.GB483930@redhat.com>
	<YFoCpIh5PCSP6gXB@work-vm>
	<40D27E5F-C65A-4441-BA23-ABA6880DAA71@netapp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="YNYjzn8sg3lyMsUB"
Content-Disposition: inline
In-Reply-To: <40D27E5F-C65A-4441-BA23-ABA6880DAA71@netapp.com>
Subject: Re: [Virtio-fs] Live migration support for virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Ge, Xiongzi" <Xiongzi.Ge@netapp.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>


--YNYjzn8sg3lyMsUB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 07, 2021 at 06:05:29PM +0000, Ge, Xiongzi wrote:
> Thanks Dr Gilbert, Vivek, Stefan, Greg!
> I put together the discussion into this thread and CC qemu-devel@nongnu.o=
rg.=20
>=20
> Problem:
> Current Virtio-FS does not support live migration.  Even when the virtiof=
s directory is not mounted on the guest, VM cannot do live migration. Any s=
uggestions/interest If we want to make this work so we can still have the l=
ive migration feature for other purpose on that VM?=20
>=20
> If we already have a shared file system like Ceph, does this make it diff=
erent?=20

(Marc-Andr=E9: I CCed you regarding D-Bus VMState, see below.)

During the last virtio-fs call on Wednesday we discussed how to allow
live migration when the file system is not mounted. This means live
migration of a mounted file system still wouldn't be supported, but at
least it would be possible to migrate when the file system is not
mounted.

The easiest way to do that is to hot unplug the vhost-user-fs-pci device
so that QEMU can live migrate the VM and then hot plug the
vhost-user-fs-pci device again after migration has completed. This
requires either manually performing the hot plug operations or some
automation to do this around live migration.

A smoother approach would be for QEMU to allow live migration when the
file system is not mounted. Unfortunately it turns out this is actually
rather involved because virtiofsd runs as a separate process from QEMU
and the live migration interface for vhost-user devices is currently
pretty basic
(https://qemu.readthedocs.io/en/latest/interop/dbus-vmstate.html). There
is currently no way for virtiofsd to communicate with QEMU to allow/deny
live migration depending on whether virtiofsd currently has an active
FUSE session (mount). It might be possible to extend the D-Bus VMState
interface and implement support for "migration blockers" as they are
known in QEMU, but I wonder whether it's not better to just work on
full virtio-fs live migration instead. Either task is complex and I
wouldn't recommend it as a first contribution to virtiofsd or QEMU.

Can you make use of the hotplug approach to live migration?

Stefan

--YNYjzn8sg3lyMsUB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBvLV4ACgkQnKSrs4Gr
c8gDdAf+JdmGLPwy1p7SMorFUuvvSotUbcfdHDfwdcda8xdo5BTk33cUdVs21JA9
NhtY88Z4WALFx8Cp7QxlaiXLef6BJ1DVsfX4T2m04Jt5tERqVMf0G9rBQp7ILfRl
akAauid1pHNfk4JTx+V3++dNt/3tXOjnd0Vf7HKcH9LUI0T0IHf0SkpFpaVQNh9/
YX7UV/wG0nZNr0hH05e4XegkhIWfUwQZnGwuSjWJ0hjsFu+bcP8F/7xsZYQKgLqu
4cXpOn7EMB5ERr8wLPtvMjGYsAYpyIrhoV6+GW4XK4ALswxtEA9ObEAMht6DDmq5
37F7xpdCKDH+AZniLKlr8wF9kNdipg==
=52sP
-----END PGP SIGNATURE-----

--YNYjzn8sg3lyMsUB--

