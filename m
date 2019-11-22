Date: Fri, 22 Nov 2019 10:07:13 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191122100713.GB464656@stefanha-x1.localdomain>
References: <20191115205543.1816-1-vgoyal@redhat.com>
	<20191115205543.1816-2-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <20191115205543.1816-2-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/4] virtiofsd: Release file locks using
	F_UNLCK
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, miklos@szeredi.hu, qemu-devel@nongnu.org


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2019 at 03:55:40PM -0500, Vivek Goyal wrote:
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passt=
hrough_ll.c
> index bc214df0c7..028e7da273 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -936,6 +936,14 @@ static void put_shared(struct lo_data *lo, struct lo=
_inode *inode)
>  	}
>  }
> =20
> +static void release_plock(gpointer data)

The name posix_locks_value_destroy() would be clearer because it matches
g_hash_table_new_full() terminology and the function cannot be confused
with a lock acquire/release operation.

This patch conflicts with the cleanups that are currently being made to
virtiofsd:
https://github.com/stefanha/qemu/commit/1e493175feca58a81a2d0cbdac93b92e542=
5d850#diff-ca2dea995d1e6cdb95c8a47c7cca51ceR773

Stefan

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3Xs1EACgkQnKSrs4Gr
c8jESgf3bZc3dPzFuIExzraXonKWmv9lpbHO635oRtv46DMrNro6Wb0HCXKgcOqE
AHSyfGUR/+l+wEXpIC0zBvtYYlv/5zyKqLgGrqQqd9BGLbpZt/Wkm4jm2KUKnuQT
9bsrzcWtxeqGXTHB3lcYHM6pY/+luYL9b2W5VmEi26Qflr8dZvlLNFMcL+lH8MPy
barXW/5O4y0575UmaegFcQ04knNblHvkmRTxNNkG1fW5hTT9n72AyyJNzP8mnpdO
1LZWrBrJur/6xTy4OxWPDYyAzJNLT8ReYPGouPk9mkLLIqs5+NnVSX4s3ZJGLbVU
W5Y4ON+7KulyCr6/J/NFJ7BqVkNn
=U24S
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--

