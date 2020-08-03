Date: Mon, 3 Aug 2020 10:57:38 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200803095738.GE244853@stefanha-x1.localdomain>
References: <20200727161841.GA54539@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ffoCPvUAPMgSXi6H"
Content-Disposition: inline
In-Reply-To: <20200727161841.GA54539@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Disable remote posix locks by
 default
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org


--ffoCPvUAPMgSXi6H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 27, 2020 at 12:18:41PM -0400, Vivek Goyal wrote:
> Right now we enable remote posix locks by default. That means when guest
> does a posix lock it sends request to server (virtiofsd). But currently
> we only support non-blocking posix lock and return -EOPNOTSUPP for
> blocking version.
>=20
> This means that existing applications which are doing blocking posix
> locks get -EOPNOTSUPP and fail. To avoid this, people have been
> running virtiosd with option "-o no_posix_lock". For new users it
> is still a surprise and trial and error takes them to this option.
>=20
> Given posix lock implementation is not complete in virtiofsd, disable
> it by default. This means that posix locks will work with-in applications
> in a guest but not across guests. Anyway we don't support sharing
> filesystem among different guests yet in virtiofs so this should
> not lead to any kind of surprise or regression and will make life
> little easier for virtiofs users.
>=20
> Reported-by: Aa Aa <jimbothom@yandex.com>
> Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--ffoCPvUAPMgSXi6H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8n35IACgkQnKSrs4Gr
c8i7hQf9FLImnoPnUW5yy+IZ4gOCx8EGfMPCVrflDnB8wrWt5tJI5WfFUlnFbsCP
hLPTvasXJCGkX10pFSv2Lr+FyrJw14XL29yMY7ceQDsmbJSucAowm09D7YQPpppX
8nG4716DA1DKIuSdOY2OYSk6RcDL20JVrvH62lt4ENM/1koG0FRbsKuK5G+DwHRo
AJLZTxO+TXaUy3Tio0VWiKeXxLLYm59Uga4OCXzI8c2tPpweMj5Uj2mOVbISOJnE
4In8BOuH0vf2qg9VIZ2M8TB2a45PSF//viumYK7CMfw/rH9p+2dkl4BtndGyeDHE
f24Gjz4J95Y0cyywUYFom6m544ZYUQ==
=u7/G
-----END PGP SIGNATURE-----

--ffoCPvUAPMgSXi6H--

