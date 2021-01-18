Date: Mon, 18 Jan 2021 16:55:41 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210118165541.GD255498@stefanha-x1.localdomain>
References: <rprnspo3-119s-qnoo-2o93-sn40rq40ns@erqung.pbz>
	<20210114133424.GA299876@stefanha-x1.localdomain>
	<qn527287-65qq-227p-2r48-1528r6rr386@erqung.pbz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0IvGJv3f9h+YhkrH"
Content-Disposition: inline
In-Reply-To: <qn527287-65qq-227p-2r48-1528r6rr386@erqung.pbz>
Subject: Re: [Virtio-fs] [RFC] About non-root virtiofsd(1) process
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: P J P <ppandit@redhat.com>
Cc: virtio-fs@redhat.com


--0IvGJv3f9h+YhkrH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 15, 2021 at 12:39:13PM +0530, P J P wrote:
> +-- On Thu, 14 Jan 2021, Stefan Hajnoczi wrote --+
> | On Thu, Jan 14, 2021 at 02:11:28PM +0530, P J P wrote:
> | > Ex. By default offer only read access to guest VM.
> |=20
> | That's not useful. Most users require read-write.
>=20
> * Agreed. I meant let 'rw' access be user's choice than the default for=
=20
>   virtiofsd(1).

I'm not sure I understand. It's the user's choice to run virtiofsd. And
if they are running it then most of the time they want read-write
access.

Requiring extra syntax for read-write doesn't help. Safe defaults work
well for rarely-used features that can really be disabled most of the
time to improve security. This isn't that case.

> | The fundamental issue is that the server must be able to create, access=
, and=20
> | modify files with arbitrary uids/gids.
>=20
> * Why arbitrary uids/gids? Once a directory is shared with a guest, its=
=20
>   uids/gids would stay same, no?

Guest applications may run with different uids/gids. The host has no
control over that.

Imagine booting a guest form a virtio-fs root file system and installing
packages. The guest must be able to control uids/gids for that to work.

There are specific use cases where restrictions are acceptable, but they
have trade-offs (e.g. the file system on the host does not have the same
uid/gids as inside the guest). The current approach supports all guest
applications, whereas other approaches do not. It is possible to add
uid/gid restrictions to tighten security for some use cases (like the
unprivileged virtiofsd that you suggested below with -runas).

> * We also start separate virtiofsd(1) process for each share/guest too. i=
e. =20
>   single virtiofsd(1) daemon is not catering to multiple guests and their
>   respective shared directories, right?

Yes. Each virtio-fs device has a separate virtiofsd process.

> | If you have specific ideas, let's discuss them.
>=20
> * One was to have a command line switch similar to 'qemu -runas <user>'
>=20
>      $ ./virtiofsd -runas test -o source=3D...
>=20
>   If a user wants to run virtiofsd(1) with non-root privileges, it'll be=
=20
>   handy.

Patches for this are welcome. It can't be used for Kata Containers or
other virtiofsd use cases that where uids/gids matter, but it's a good
choice to share an unprivileged user's directory with the guest.

Stefan

--0IvGJv3f9h+YhkrH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAFvY0ACgkQnKSrs4Gr
c8ikJggAnvaR1w82B3+woXhM3vPm/ksMCYOkNExPYyeZ2mRamdjHbtpCG+3Nusst
Dc+7DuF59xoshUNNCDCP2N0K8jeVMTDv/Q+ErrR1LmkGotBqazhcWeQRm34Bg+ZE
LqtXxyHL3D8UQbSi6Ed5zRvKvMDWxn9JUi+StPdsSxQo0YB5peD0aiImfdZjmIrU
025CC7d0ZE+PsPczqy+tfazpMjHpnb8VUQ7/j3TIEPc+cCXDcmSfUBw3zlcjmUjy
CQLrk/lU4MypfViF0UWUMF7ciw/CfaczxIgfn3HihRBWQ3jAwcMC7ZklkZ7PI7LD
2iZwRxri4WXch6kpHr8y9luZnBuB5w==
=tolA
-----END PGP SIGNATURE-----

--0IvGJv3f9h+YhkrH--

