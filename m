Date: Thu, 15 Jul 2021 11:04:31 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YPAIL1FJk6mzGXBQ@stefanha-x1.localdomain>
References: <20210714202321.59729-1-vgoyal@redhat.com>
	<20210714202321.59729-3-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="13TCeV9ER/8KiSw9"
Content-Disposition: inline
In-Reply-To: <20210714202321.59729-3-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 2/3] init: allow mounting arbitrary
 non-blockdevice filesystems as root
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, hch@lst.de


--13TCeV9ER/8KiSw9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 14, 2021 at 04:23:20PM -0400, Vivek Goyal wrote:
> From: Christoph Hellwig <hch@lst.de>
>=20
> Currently the only non-blockdevice filesystems that can be used as the
> initial root filesystem are NFS and CIFS, which use the magic
> "root=3D/dev/nfs" and "root=3D/dev/cifs" syntax that requires the root
> device file system details to come from filesystem specific kernel
> command line options.
>=20
> Add a little bit of new code that allows to just pass arbitrary
> string mount options to any non-blockdevice filesystems so that it can
> be mounted as the root file system.
>=20
> For example a virtiofs root file system can be mounted using the
> following syntax:
>=20
> "root=3Dmyfs rootfstype=3Dvirtiofs rw"
>=20
> Based on an earlier patch from Vivek Goyal <vgoyal@redhat.com>.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  init/do_mounts.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--13TCeV9ER/8KiSw9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDwCC8ACgkQnKSrs4Gr
c8i4zwgAjAKuIsfOkllAfSxyhcwSXl4730G0xBWSUD/0ctkSnsi441CQf5bOsgVP
4bHyY1VbVzAIaVdBswhnn5fCWvJQrO0QR7objrJ5yeHUHb/jseX4/uIf9f5R6jyf
QZ8EdCZAqalfe51gdGH5CPckI63SCnXGCfo1LblWJvbyO+FJxO6NuzrRksfxm7MR
R3DpOIuSK1utF4FrfWUFor2sld6ivCyKKTTiKSpw6WY4I1NkWLEnMbxrji0aw6sp
huB/FMna/momhYzjxxs6HPHUA7iYZ01uw/b56BPohPnHgh1Ae4Oaci+PevzJg3tN
6p2KY9wjmBInwecZDEpeYJnOokMhsw==
=OvOE
-----END PGP SIGNATURE-----

--13TCeV9ER/8KiSw9--

