References: <20200506153529.239939-1-mreitz@redhat.com>
	<20200506153637.240191-3-mreitz@redhat.com>
	<CAOssrKerr_KvfuXqTNjJ4936SXiN3AZ6rZ6oo8Mv+9bvDrFAWQ@mail.gmail.com>
	<879d4262-fde1-eedb-a114-2a0b8a185125@redhat.com>
	<CAOssrKd99kBf9ccc4xk_ZktO+Sc_+WvP0=wvVOXV7+Jgp8sTZA@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <5396dbd9-0d6c-556d-d015-cbc034d6471e@redhat.com>
Date: Thu, 7 May 2020 14:07:54 +0200
MIME-Version: 1.0
In-Reply-To: <CAOssrKd99kBf9ccc4xk_ZktO+Sc_+WvP0=wvVOXV7+Jgp8sTZA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="OzYbD2evWji0xZ6fu8lEgjy64eOJk87IF"
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
--OzYbD2evWji0xZ6fu8lEgjy64eOJk87IF
Content-Type: multipart/mixed; boundary="lsP9at5XPicDlECujQRDzIZ0xWZOOuT9F"

--lsP9at5XPicDlECujQRDzIZ0xWZOOuT9F
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 07.05.20 13:24, Miklos Szeredi wrote:
> On Thu, May 7, 2020 at 1:16 PM Max Reitz <mreitz@redhat.com> wrote:
>>
>> On 07.05.20 11:56, Miklos Szeredi wrote:
>>> On Wed, May 6, 2020 at 5:37 PM Max Reitz <mreitz@redhat.com> wrote:
>>>>
>>>> From: Max Reitz <xanclic@xanclic.moe>
>>
>> Oops.
>>
>>>> We want to allow submounts for the same fuse_conn, but with differen=
t
>>>> superblocks so that each of the submounts has its own device ID.  To=
 do
>>>> so, we need to split all mount-specific information off of fuse_conn=

>>>> into a new fuse_mount structure, so that multiple mounts can share a=

>>>> single fuse_conn.
>>>
>>> I have the following high level comments:
>>>
>>> Control filesystem: each fuse_mount gets a new entry, but they are al=
l
>>> aliases.   I think we should just stick with just one entry for the
>>> connection (and perhaps a symlink for each additional mount, but this=

>>> is of secondary importance).
>>
>> I have to admit that I didn=E2=80=99t spend much thought on any of thi=
s, but
>> just went with what worked.  Since one of the functions in control.c
>> require the super block, I went with fuse_mount.
>>
>> I suppose for fuse_ctl_add_conn() (for @name), we can simply use the
>> first fuse_mount=E2=80=99s device ID.
>=20
> Yes.
>=20
>>
>>> BDI:  we need to call set_bdi_congested/clear_bdi_congested for *all*=

>>> mounts of a connection.
>>
>> OK, then one entry per fuse_conn will work.
>>
>> But do we need to do the same in fuse_request_end() and
>> fuse_request_queue_background()?
>=20
> Definitely.  Otherwise one bdi could have its congestion state set,
> and the other one cleared.  Not good.
>=20
> Even better:  share the bdi between submounts.  This would make a lot
> more sense and remove the need for loops.

Hm, isn=E2=80=99t bdi related to the (anonymous) block device =E2=80=9Cse=
rving=E2=80=9D the
super block, and thus the st_dev value?  (Which is necessarily different
for all fuse_mounts)

>>>                          Might make sense to look into getting rid of=

>>> bdi congestion handling completely, but this is not something I have =
a
>>> good insight into right now.
>>>
>>> Notification: please create a fuse_ilookup() that takes fc and return=
s
>>> (sb, inode) pair and call this instead ilookup5().   This way the loo=
p
>>> is moved to the place where it's actually necessary.
>>
>> Hm, sounds a bit cumbersome for the fuse_notify_* functions that don=E2=
=80=99t
>> directly call ilookup5().  But they always have a callee that does, so=
 I
>> suppose I=E2=80=99ll just have to move that up to the caller.  That sh=
ould work
>> then.
>=20
> I'd rather say: move the fc down to the callee.  The kill_sb mutex can
> remain in fuse_conn, so callers shouldn't need an sb.

OK.

Max


--lsP9at5XPicDlECujQRDzIZ0xWZOOuT9F--

--OzYbD2evWji0xZ6fu8lEgjy64eOJk87IF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl6z+hoACgkQ9AfbAGHV
z0Dfvwf/TGG3HrLox4jxCKPis+tIlryVPmTfC6vDW/+AUv837Sf0ey9biYNJm01a
OvgTscNX9+ur/Z5qjnm6i2rRl97gxf6IcRqHaibhbDaJegUk3RATvBzAovy5im/M
PKvKHgMy//dHR1B1vK6OdLSrVvsUs2HuCUHY4a9KNPAwH9U1kzi34s5y55vloAdR
MCI/O21vRF4vQ2sK952ntQjV5mFudxSpo7pBcZgIWMlpbNLQzRkMp4EuLr6G7Ji9
gKkweHfs8Z/0IZTqyuAeHSOzljgXqAhn98Ljf3K/sKv4Rtgt73PcGSRsLudqhC+7
yOQhT3ZGCnzWSzSzBuReM+ptsN46vQ==
=mbcb
-----END PGP SIGNATURE-----

--OzYbD2evWji0xZ6fu8lEgjy64eOJk87IF--

