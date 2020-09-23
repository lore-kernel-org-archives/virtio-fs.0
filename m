References: <20200909184603.263700-1-mreitz@redhat.com>
	<CAJfpegt92oj88FbGxphce80AWtU51Qgm87KuZqYD9kfpSVq2tA@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <e640c06b-2918-5b90-e792-24e38e55e7e7@redhat.com>
Date: Wed, 23 Sep 2020 17:20:28 +0200
MIME-Version: 1.0
In-Reply-To: <CAJfpegt92oj88FbGxphce80AWtU51Qgm87KuZqYD9kfpSVq2tA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="h4aY4OHth12nA2N2yieMOG5oEiBnplTD9"
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
--h4aY4OHth12nA2N2yieMOG5oEiBnplTD9
Content-Type: multipart/mixed; boundary="wV07ROAVvwym7kwH9AFLSUYsgd8pNzX0O"

--wV07ROAVvwym7kwH9AFLSUYsgd8pNzX0O
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

[...]

> Please review and test.  If there are no major issues, this should be
> good to go for v5.10.

submounts-update.patch looks good to me.  Thanks again!
(I have to admit I found it quite hard to review because it=E2=80=99s the=
 7
changes noted above rolled into a single diff, so it took me quite a whil=
e.)

The only thing I noticed was that fuse_init_node() shouldn=E2=80=99t decl=
are @fc
any longer.  (I also don=E2=80=99t quite understand why in fuse_i.h some =
/** are
replaced by /*, but that isn=E2=80=99t really relevant.)

(I=E2=80=99ll look at virtiofsd-use-mount-id.patch tomorrow.)

Max


--wV07ROAVvwym7kwH9AFLSUYsgd8pNzX0O--

--h4aY4OHth12nA2N2yieMOG5oEiBnplTD9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl9rZ7wACgkQ9AfbAGHV
z0D5dwgAmDrrG/wbTixEPEVzsnbLvKipRM2ZRRRYIfJQdTMAu3HB8xqZUsKQoswt
b9JsD+k8CUKx0SPzbiHTL4BqzLCa4sV1+HtESphVh2uK1ZZEQJvOJOjT2DYzaf+e
Dujgv5P2rlimPPLrZmD8TrOR68jsUl54VzG7o4tOgHlE9zUHqlHV19TAR4CLCsrq
5c04FEZWHM9AbgKh8DB4n2ljwJgK86GoDLzTVnYr4WSvZRWnVO692dbZpL+2JtPk
myPrtiiyVm3I4M0I/yZ8LTDQC02kzs8boiFzrKOxBCVdB7EhJ5C93mu3og7FKI3+
MoqejpijL0cYVBVAN9LwO7RsdUKmwg==
=G5CA
-----END PGP SIGNATURE-----

--h4aY4OHth12nA2N2yieMOG5oEiBnplTD9--

