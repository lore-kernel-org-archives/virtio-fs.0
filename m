Date: Fri, 11 Sep 2020 11:25:33 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200911102533.GE94280@stefanha-x1.localdomain>
References: <20200909184603.263700-1-mreitz@redhat.com>
	<20200909184603.263700-4-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="84ND8YJRMFlzkrP4"
Content-Disposition: inline
In-Reply-To: <20200909184603.263700-4-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 3/9] fuse: Add FUSE_ATTR_FLAGS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, fuse-devel@lists.sourceforge.net


--84ND8YJRMFlzkrP4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 09, 2020 at 08:45:57PM +0200, Max Reitz wrote:
> The client sets this flag when it expects fuse_attr.flags (instead of
> just padding).  The server sets it when it will provide a proper value
> for it.
>=20
> Signed-off-by: Max Reitz <mreitz@redhat.com>
> ---
>  include/uapi/linux/fuse.h | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--84ND8YJRMFlzkrP4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9bUJwACgkQnKSrs4Gr
c8iMqQgAlFvgomKecbqOyHeB4ItFyg8ju3/ws7/ESzS3j+x7P4IPjFa0aUL3qVgE
XSHOGEYr0SzOKScXwqQGh+wh1f2ExMBTLl41TMSr9+xHfCpXzFJMPOIVWcJmvDKD
ITb0CfJH6ajfegzTsfJ+vypl2LIwed1e1ISAvfQqipILAc3JVJdKy3fQtDB9OMxi
QQdXxFtWTxC4q85Ujp9KsNYFklNLvcpKbFbttMSG0anHaDwjR61KuHgb5Ukkxk2l
EGkdF2VG5jxkXqQA2OOAQ6vZYbur2n7shA+AMdKujpqyp5GpJaMTYXHJkUQMGvDL
65rKrDJWpMBIIQgYlVLTTXkvDiTRiA==
=DisU
-----END PGP SIGNATURE-----

--84ND8YJRMFlzkrP4--

