References: <20200506153529.239939-1-mreitz@redhat.com>
	<20200506153637.240191-3-mreitz@redhat.com>
	<CAOssrKerr_KvfuXqTNjJ4936SXiN3AZ6rZ6oo8Mv+9bvDrFAWQ@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <879d4262-fde1-eedb-a114-2a0b8a185125@redhat.com>
Date: Thu, 7 May 2020 13:16:10 +0200
MIME-Version: 1.0
In-Reply-To: <CAOssrKerr_KvfuXqTNjJ4936SXiN3AZ6rZ6oo8Mv+9bvDrFAWQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="TgGOS8MwPbHIeu5nIVaY3MH30DTK7Y8yY"
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
--TgGOS8MwPbHIeu5nIVaY3MH30DTK7Y8yY
Content-Type: multipart/mixed; boundary="n4oleeaH6wCcO2IbLUcf3Gh7Cxdn1w3gp"

--n4oleeaH6wCcO2IbLUcf3Gh7Cxdn1w3gp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 07.05.20 11:56, Miklos Szeredi wrote:
> On Wed, May 6, 2020 at 5:37 PM Max Reitz <mreitz@redhat.com> wrote:
>>
>> From: Max Reitz <xanclic@xanclic.moe>

Oops.

>> We want to allow submounts for the same fuse_conn, but with different
>> superblocks so that each of the submounts has its own device ID.  To d=
o
>> so, we need to split all mount-specific information off of fuse_conn
>> into a new fuse_mount structure, so that multiple mounts can share a
>> single fuse_conn.
>=20
> I have the following high level comments:
>=20
> Control filesystem: each fuse_mount gets a new entry, but they are all
> aliases.   I think we should just stick with just one entry for the
> connection (and perhaps a symlink for each additional mount, but this
> is of secondary importance).

I have to admit that I didn=E2=80=99t spend much thought on any of this, =
but
just went with what worked.  Since one of the functions in control.c
require the super block, I went with fuse_mount.

I suppose for fuse_ctl_add_conn() (for @name), we can simply use the
first fuse_mount=E2=80=99s device ID.

> BDI:  we need to call set_bdi_congested/clear_bdi_congested for *all*
> mounts of a connection.

OK, then one entry per fuse_conn will work.

But do we need to do the same in fuse_request_end() and
fuse_request_queue_background()?

>                          Might make sense to look into getting rid of
> bdi congestion handling completely, but this is not something I have a
> good insight into right now.
>=20
> Notification: please create a fuse_ilookup() that takes fc and returns
> (sb, inode) pair and call this instead ilookup5().   This way the loop
> is moved to the place where it's actually necessary.

Hm, sounds a bit cumbersome for the fuse_notify_* functions that don=E2=80=
=99t
directly call ilookup5().  But they always have a callee that does, so I
suppose I=E2=80=99ll just have to move that up to the caller.  That shoul=
d work
then.

Thanks!

Max


--n4oleeaH6wCcO2IbLUcf3Gh7Cxdn1w3gp--

--TgGOS8MwPbHIeu5nIVaY3MH30DTK7Y8yY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl6z7fsACgkQ9AfbAGHV
z0C3fwgAvtEQRpdIj0aULzdRKkVfUm32vedw5aKFn7GYYMybFflmD63JYZZa5aF/
hvr5tEQR8gLRQ1v5LocSSVCTqCyCCH41UEWfZePqoH9ztyftyZiD3k8dkL9q/f2S
GrpFNh+W7/iQd5ZmpckecUA98q9RcVbl4lm+jTnpz5cvzfLIHCkn80I4xgR4SHBA
CfJYltJW5nCann1AS3pXkGheHsQtgOkiWdMf6JidJqhwLnt5b++FRjmAPQUUh3Rz
/KUojIg8uVtJAlkCO14yjEW/xKvGGKyuTwuX15aZIdNSKsKsIU1s/QfR2zKsiD3G
/KxhfzH6so90w++L2ahr5QpcW9aN/Q==
=ChQ1
-----END PGP SIGNATURE-----

--TgGOS8MwPbHIeu5nIVaY3MH30DTK7Y8yY--

