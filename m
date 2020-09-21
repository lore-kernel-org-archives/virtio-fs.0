References: <20200909184603.263700-1-mreitz@redhat.com>
	<CAJfpegt92oj88FbGxphce80AWtU51Qgm87KuZqYD9kfpSVq2tA@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <03022cbc-fe80-5ded-522e-ae9ef33703bd@redhat.com>
Date: Mon, 21 Sep 2020 15:35:04 +0200
MIME-Version: 1.0
In-Reply-To: <CAJfpegt92oj88FbGxphce80AWtU51Qgm87KuZqYD9kfpSVq2tA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="aoq1jxa0jzF7mNWmZu5C7ynnyga1KFTNd"
Subject: Re: [Virtio-fs] [fuse-devel] [PATCH 0/9] fuse: Mirror virtio-fs
	submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, fuse-devel <fuse-devel@lists.sourceforge.net>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aoq1jxa0jzF7mNWmZu5C7ynnyga1KFTNd
Content-Type: multipart/mixed; boundary="Mh3fpPLCsNTzpWJzU7kokoIBprPo9ZLZD"

--Mh3fpPLCsNTzpWJzU7kokoIBprPo9ZLZD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 18.09.20 17:25, Miklos Szeredi wrote:
> Pushed an updated version to fuse.git#submounts.
>=20
> Also attached incremental patch (against rebase of
> virtiofs-submounts-v2 on fuse.git#for-next).
>=20
> Changes:
>=20
>  1) rebased on top of DAX patches
>  2) fixed CUSE
>  3) added locking for fc->mounts list
>  4) dissociate lifetime of fc from lifetime of root mount
>  5) do not hash mountpoint inodes
>  6) add FUSE_SUBMOUNTS init flag (replaces FUSE_ATTR_FLAGS but
> slightly different usage)
>  7) various cleanups

Wow.  Thanks!  I=E2=80=99ll take a closer look once I can.

> Note, the effect of 5 can only be observed if the same directory is
> bind mounted into multiple places:
>=20
> HOST:
> cd /mnt
> mkdir 1 2
> mount --bind /dev/shm 1
> mount --bind /dev/shm 2
>=20
> GUEST:
> mount -t virtiofs mnt /mnt
> cd /mnt/1
> ls ../2
> /bin/pwd
>=20
> If the mountpoint is hashed, then the "ls ../2" will basically result
> in /mnt/1 inode being moved to /mnt/2, which is not what we want.  I
> don't think there's any negative side effect of the mountpoint being
> unhashed, but this is a bit subtle.
>=20
>=20
> On the server side, keying on just st_ino/st_dev is a really crude way
> of mapping out mounts.  Take this example:
>=20
> HOST:
> cd /mnt
> mkdir 1
> mount --bind /dev/shm 1
> cd 1
> mkdir 2
> mount --bind /mnt 2
> ls /mnt/1/2/1
>=20
> GUEST:
> mount -t virtiofs mnt /mnt
> ls /mnt/1/2/1
> 2
> ls /mnt/1/2/1/2/1/2/1/
> 2
>=20
> So what we really need is keying on mount ID as well.

Yes, I=E2=80=99ve noticed this, too.  I just didn=E2=80=99t care to fix i=
t here, because
it=E2=80=99s a pre-existing issue (I believe), and it isn=E2=80=99t relat=
ed to the
submount-automount implementation =E2=80=93 it=E2=80=99s just a bug in vi=
rtiofsd, basically.

> Attaching an incremental patch to do that.  Needs v5.8 kernel on host
> to actually make a difference, but commit fa2fcf4f1df1 ("statx: add
> mount ID") is trivial to backport to any kernel that has statx.
>=20
> Please review and test.

Will do.

> If there are no major issues, this should be
> good to go for v5.10.

Great :)

Max


--Mh3fpPLCsNTzpWJzU7kokoIBprPo9ZLZD--

--aoq1jxa0jzF7mNWmZu5C7ynnyga1KFTNd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl9orAgACgkQ9AfbAGHV
z0CBkQf+J/8+pXR3d4t2al2hr/Wvk5aURfRDegUMn2OK1RNgdhnKAXJVLW6AFcSs
6m5KvkGYD8qi1NBAdhX0fDfqUqen3FiFYD3C975J2fbVIhtxHPB3cJsKz3ucCgCQ
JUZ4263OW0YcL8Wd+hszMbHZsqmcdwmEbTSql/mIHo/S3CQJ2+Gdcay/6inV+24Q
GDtreo+GaaUPFh/2USAaIeGJljsL3nARFjlWAqqxis2ZmxCPSwVaRlt2x7ar2zoF
/Obh7b9TK13dESLQfRtQuvrOqpup/QcsmT4EwzLOuO6uEDJHhalMP5Fx8AooI6Uw
YI3TpZWByBKlTfBF2RYN1ATxJcfXdQ==
=1yfX
-----END PGP SIGNATURE-----

--aoq1jxa0jzF7mNWmZu5C7ynnyga1KFTNd--

