Date: Mon, 15 Feb 2021 15:57:11 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210215155711.GA95852@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-24-dgilbert@redhat.com>
	<20210211143542.GT247031@stefanha-x1.localdomain>
	<20210211144031.GB5014@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <20210211144031.GB5014@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 23/24] vhost-user-fs: Implement drop
 CAP_FSETID functionality
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com, qemu-devel@nongnu.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 11, 2021 at 09:40:31AM -0500, Vivek Goyal wrote:
> On Thu, Feb 11, 2021 at 02:35:42PM +0000, Stefan Hajnoczi wrote:
> > On Tue, Feb 09, 2021 at 07:02:23PM +0000, Dr. David Alan Gilbert (git) =
wrote:
> > > From: Vivek Goyal <vgoyal@redhat.com>
> > >=20
> > > As part of slave_io message, slave can ask to do I/O on an fd. Additi=
onally
> > > slave can ask for dropping CAP_FSETID (if master has it) before doing=
 I/O.
> > > Implement functionality to drop CAP_FSETID and gain it back after the
> > > operation.
> > >=20
> > > This also creates a dependency on libcap-ng.
> >=20
> > Is this patch only for the case where QEMU is running as root?
> >=20
>=20
> Yes, it primarily is for the case where qemu is running as root, or
> somebody managed to launch it non-root but with still having capability
> CAP_FSETID.

Running QEMU as root is not encouraged because the security model is
designed around the principle of least privilege (only give QEMU access
to resources that belong to the guest).

What happens in the case where QEMU is not root? Does that mean QEMU
will drop suid/guid bits even if the FUSE client wanted them to be
preserved?

Stefan

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAqmdcACgkQnKSrs4Gr
c8iYPQf+ItykL4kTL3tGtciggQvbGHX/AMImfY87LtKrT9teSO+cRq7s70fnwhqj
3EExD7CtMYVO1q0CrJgfN7ICd2melPLkD5FHc2oAm4KW1Zb4/B1KoB8A+j3SJLsO
6zfqx5JMCVaHheEUxqoiMfsgwyH1H8rhBjQjr4/XQ3vNZJ+OsWiYFsENqi3HcH6S
tF83XT4iXzsyXXJ4N/59bSQWtJHnWQ/9o6tD513aMwJiU5d9HxYqjp4avBXKs5zy
mk2vRkr7gi8maknAOIfzcNggQAhsHNIfW1FPvzUbBdr5Y+MMohVNCUNX+9BLsq/O
zV2WMshVc4YPGk9SqGPOETlKsEsQhQ==
=GsZz
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--

