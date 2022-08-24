Return-Path: <stefanha@redhat.com>
Date: Wed, 24 Aug 2022 13:41:29 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YwZiyXqPTlSadOOR@fedora>
References: <20220818184618.2205172-1-yokada.996@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="LRng2wZE5VDJdb4c"
Content-Disposition: inline
In-Reply-To: <20220818184618.2205172-1-yokada.996@gmail.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: use g_date_time_get_microsecond
 to get subsecond
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Yusuke Okada <yokada.996@gmail.com>
Cc: qemu-devel@nongnu.org, Yusuke Okada <okada.yusuke@jp.fujitsu.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "open list:virtiofs" <virtio-fs@redhat.com>


--LRng2wZE5VDJdb4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 18, 2022 at 02:46:19PM -0400, Yusuke Okada wrote:
> From: Yusuke Okada <okada.yusuke@jp.fujitsu.com>
>=20
> The "%f" specifier in g_date_time_format() is only available in glib
> 2.65.2 or later. If combined with older glib, the function returns null
> and the timestamp displayed as "(null)".
>=20
> For backward compatibility, g_date_time_get_microsecond should be used
> to retrieve subsecond.
>=20
> In this patch the g_date_time_format() leaves subsecond field as "%06d"
> and let next snprintf to format with g_date_time_get_microsecond.
>=20
> Signed-off-by: Yusuke Okada <okada.yusuke@jp.fujitsu.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Thanks, applied to my block tree for QEMU 7.2:
https://gitlab.com/stefanha/qemu/commits/block

Stefan

--LRng2wZE5VDJdb4c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmMGYskACgkQnKSrs4Gr
c8hJSAf/cLxeZMni5nzjFmanveCyoRWXfEpLodpRJH9glUWDwg0tHliZAYXg2Cdn
tvdcaRd5KsYgoKcZujZIY54aNQ9LN+o08jQwNJpLNqIJ+ZfXCcbz7/ufExN+Bfc5
tmFNDzyi/wk2brHGanuQltWzP/xDzCHlZiHetjiaVBJOLAqiN1E4DXz8wn3EJlKi
iEudKuWK/wZXIPDuD8iOT22us2D5jmd5hkIppcfAPXUxRJWRm5MZ6RGloZXzOOhv
Zq6nCrm5v70YB5YpJujbxGiQHXcQ2m1XfFUgtsEay+Wso4Lw880wl46QyUYASsMy
1NhD4KX2t91PrS1Uf3J5HwdMGnruqQ==
=yQms
-----END PGP SIGNATURE-----

--LRng2wZE5VDJdb4c--
