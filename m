References: <20200909184603.263700-1-mreitz@redhat.com>
	<CAJfpegt92oj88FbGxphce80AWtU51Qgm87KuZqYD9kfpSVq2tA@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <e87d7603-100b-173a-07c6-3ef4c2400e94@redhat.com>
Date: Wed, 23 Sep 2020 17:45:12 +0200
MIME-Version: 1.0
In-Reply-To: <CAJfpegt92oj88FbGxphce80AWtU51Qgm87KuZqYD9kfpSVq2tA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="D3yaQC4PhGCiMfbllP3mpMHbnPyxXz5u0"
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
--D3yaQC4PhGCiMfbllP3mpMHbnPyxXz5u0
Content-Type: multipart/mixed; boundary="7i5goZqX2gCn7QACs9juBqVvX7VfQZpW5"

--7i5goZqX2gCn7QACs9juBqVvX7VfQZpW5
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
>=20
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
>=20
> Attaching an incremental patch to do that.  Needs v5.8 kernel on host
> to actually make a difference, but commit fa2fcf4f1df1 ("statx: add
> mount ID") is trivial to backport to any kernel that has statx.
>=20
> Please review and test.  If there are no major issues, this should be
> good to go for v5.10.

As for the virtiofsd patch, I wonder about:

> #if 0 && defined(HAVE_STATX) && STATX_MNT_ID

Shouldn=E2=80=99t the 0 not be there?  And should STATX_MNT_ID be wrapped=
 in
defined()?

Furthermore I wonder why you have removed the parent_dev logic.  With
your patch, FUSE_ATTR_SUBMOUNT can be announced only by those functions
that invoke lo_do_lookup().  Is it OK to do so only there, and not every
time a fuse_attr is returned (be it as part of fuse_entry_out, as by
lo_link(), or directly by lo_getattr())?

(Also, the virtiofsd series will need a bit of an update with
FUSE_SUBMOUNTS replacing FUSE_ATTR_FLAGS.)

Max


--7i5goZqX2gCn7QACs9juBqVvX7VfQZpW5--

--D3yaQC4PhGCiMfbllP3mpMHbnPyxXz5u0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl9rbYgACgkQ9AfbAGHV
z0D1WQgAlkwOII8t10BtHTCH5AevYVUXZqTqDLjdbARK3D8kES1fS49EOtJpRYZe
apUsmi8c2OjEhDMtrdePYDmcfbKfY4dFveopV5o4FeVwuHb1avF47vlu6et6CY52
zNczYzGuoolJCI2+KU8MfEGGekv+GodIeDYXSsV21iAmUAbczrcpXNv9LH31k0uR
RlBR9QC8wc9UMu84Btu5O27biNbmt33eOT26VhDLHgVljgbfllHyCYaKrLCJA45Q
9N5KmMoBOi10J2enFmAlcHKRv9GFh3WXhEO1dBafBxvqXap81O6UOKfljUTWPoTy
VLowkFXgKyOhQfSHL8jwahQCuGboXA==
=bNdc
-----END PGP SIGNATURE-----

--D3yaQC4PhGCiMfbllP3mpMHbnPyxXz5u0--

