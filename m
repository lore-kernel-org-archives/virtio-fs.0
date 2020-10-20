Date: Tue, 20 Oct 2020 10:54:01 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201020095401.GD140014@stefanha-x1.localdomain>
References: <20201014180209.49299-1-dgilbert@redhat.com>
	<20201014180209.49299-4-dgilbert@redhat.com>
	<bd3c072f-dc6c-23a8-cd48-543bafa46363@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ylS2wUBXLOxYXZFQ"
Content-Disposition: inline
In-Reply-To: <bd3c072f-dc6c-23a8-cd48-543bafa46363@gmail.com>
Subject: Re: [Virtio-fs] Puzzle about rootflags,
 restorecon "operation not supported"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Harry G. Coin" <hgcoin@gmail.com>
Cc: virtio-fs@redhat.com


--ylS2wUBXLOxYXZFQ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2020 at 06:57:09PM -0500, Harry G. Coin wrote:
> The 'mainline generic' version of the latest kernel fails to parse
> 'fuse' virtiofs options on root kernel boots.=A0 Not only dax, but all the
> 'fuse' usual ones as well.=A0 (None of
> default_permissions,allow_other,user_id=3D0 etc are accepted).
>=20
> Is that what you expected of the mainline kernel?=A0 I learned of this
> when trying to understand this further problem:
>=20
> SELinux's 'restorecon' and other attempts to change security attributes
> then fails with "operation not supported".
>=20
> I could only get sshd able to accept connections by changing SELinux to
> permissive.=A0 The commands necessary to change the security attributes
> failed with the 'operation not supported' issue.
>=20
> Ideas?

Hi Harry,
FUSE mount options were removed from virtiofs at one point. I think this
is expected. The reason is because the options you listed are the
default for virtiofs and don't need to be specified explicitly.

I have CCed Miklos in case things have changed or I missed something.

Stefan

--ylS2wUBXLOxYXZFQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+Os7kACgkQnKSrs4Gr
c8iMOQf7BfolfITnXeBLwogYzS68qGmdSQvG9OhVjHJC1O/NhYLYXjULwNJa9YKu
bw5a1IRS/myFq6WxF4sgYbEb7DtCcZU0Fzx1XHgWkUaTRb6qkbVLE0xYDEYtvSep
idazEqVm6rFqFZehgXCnXCGngM7ezXvfHYXum83fmna3+Rk0/U7Qt6wMtG0A7Mgl
plSUgea3oPCgX5ZsvzyNxpM8kQkb9nJI0Ed8/Mua/oO1sHCOZL+s/X0opJKymcH2
8fHN9TxndCy2jQ64leza7zPnyP5WoFtJZwM2oDv7yFxDfXIzB/Y0xxpcv1z6Zlko
Mt6mjsFEwSu97hlrXNhA7cgj/mqmtA==
=FIGN
-----END PGP SIGNATURE-----

--ylS2wUBXLOxYXZFQ--

