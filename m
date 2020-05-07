References: <20200506153529.239939-1-mreitz@redhat.com>
	<20200506153637.240191-3-mreitz@redhat.com>
	<CAOssrKerr_KvfuXqTNjJ4936SXiN3AZ6rZ6oo8Mv+9bvDrFAWQ@mail.gmail.com>
	<879d4262-fde1-eedb-a114-2a0b8a185125@redhat.com>
	<CAOssrKd99kBf9ccc4xk_ZktO+Sc_+WvP0=wvVOXV7+Jgp8sTZA@mail.gmail.com>
	<5396dbd9-0d6c-556d-d015-cbc034d6471e@redhat.com>
	<CAOssrKfX1ocpXH_rnaAYMJS50L3kKTr1yGvY6=iqvn9TcwdhWg@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <1b5ef937-34ee-3df1-ed78-0b14f4d28f9e@redhat.com>
Date: Thu, 7 May 2020 17:05:40 +0200
MIME-Version: 1.0
In-Reply-To: <CAOssrKfX1ocpXH_rnaAYMJS50L3kKTr1yGvY6=iqvn9TcwdhWg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="sQmMYONdFD658ZeGDWnqYVpCPG60m87Y0"
Subject: Re: [Virtio-fs] [RFC 3/5] fuse: Split fuse_mount off of fuse_conn
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <xanclic@xanclic.moe>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sQmMYONdFD658ZeGDWnqYVpCPG60m87Y0
Content-Type: multipart/mixed; boundary="Q31HEtqTpLpnaEJXeGAFFBcOGdFx9IH68"

--Q31HEtqTpLpnaEJXeGAFFBcOGdFx9IH68
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 07.05.20 16:05, Miklos Szeredi wrote:
> On Thu, May 7, 2020 at 2:08 PM Max Reitz <mreitz@redhat.com> wrote:
>>
>> On 07.05.20 13:24, Miklos Szeredi wrote:
>=20
>>> Even better:  share the bdi between submounts.  This would make a lot=

>>> more sense and remove the need for loops.
>>
>> Hm, isn=E2=80=99t bdi related to the (anonymous) block device =E2=80=9C=
serving=E2=80=9D the
>> super block, and thus the st_dev value?  (Which is necessarily differe=
nt
>> for all fuse_mounts)
>=20
> BDI is normally an object bound to a block device, but a block device
> can have multiple partitions, each having different st_dev values.  So
> yes, a bdi *can* be shared by multiple super blocks, and this very
> much makes sense in the case of fuse submounts sharing a connection.

OK.  Seems like all I=E2=80=99d need to do is let fuse_bdi_init() clone
(bdi_get()) the existing BDI for submounts.  However, the BDI=E2=80=99s n=
ame (in
sysfs) is going to be based on the root mount=E2=80=99s st_dev.  Is that =
a problem?

(Sorry if I=E2=80=99m asking questions whose answer seem obvious to you, =
but I=E2=80=99m
afraid I=E2=80=99m rather new to everything, and it all still overwhelms =
me a bit.)

Max


--Q31HEtqTpLpnaEJXeGAFFBcOGdFx9IH68--

--sQmMYONdFD658ZeGDWnqYVpCPG60m87Y0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl60I8UACgkQ9AfbAGHV
z0AAWwgAktMyd2B/kgWxuJgcy+1zEbVgmgBF6tEREkTiX+2z00XfTkyQFIms5uMa
PoyhpOn2jU+YQwueYT6RKKLbl57REuZNHbGKdQLHJazOdzAOR4ULDL7uUAzx9G0Z
p2a0bitqpSN021/vyxeX/vICpQqM/DQKN7unloW51464kHO4BXfR3a6WxpTMVxLI
ckoQjtcGGeGjXOKSn2PmZYEOlKVhnEM5pnAzOed+xA1JGABl1tr3KHFLHvk05riK
J+0VelZMdDBmF1SPQqIW0uAFu/zEGEqgLzKPq3Hthh/t0Z2U6wp/ctyWvHN8WsaS
plsSG2YACYJgPUgLsfZFuwbig5p20Q==
=vgeV
-----END PGP SIGNATURE-----

--sQmMYONdFD658ZeGDWnqYVpCPG60m87Y0--

