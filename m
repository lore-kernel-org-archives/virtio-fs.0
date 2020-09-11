Date: Fri, 11 Sep 2020 11:25:27 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200911102527.GD94280@stefanha-x1.localdomain>
References: <20200909184603.263700-1-mreitz@redhat.com>
	<20200909184603.263700-2-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NtwzykIc2mflq5ck"
Content-Disposition: inline
In-Reply-To: <20200909184603.263700-2-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/9] fuse: Add fuse_attr.flags
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


--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 09, 2020 at 08:45:55PM +0200, Max Reitz wrote:
> This field (when present) can provide additional information about
> filesystem entries.
>=20
> Signed-off-by: Max Reitz <mreitz@redhat.com>
> ---
>  include/uapi/linux/fuse.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--NtwzykIc2mflq5ck
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9bUJcACgkQnKSrs4Gr
c8hERggAvc30d/CheSLRSqdhcZI3lq2MVWD17WD8yWml0bsErlhoP+yM1WNi6TA5
p3x62B6pAA+1qwOQqII0qrHygNQgqiSZYuCReVu1KZSPCGGUCsbHh6Hx2pSmYnlG
mgSaezOlb69GMrhs1bESZbPw2/gmxkKVr6skHzyT073bs15NCdXT0J7AC6Ao+f5c
oEVQ84ZD4VohI1FfLuMpOpn59JHTuUv2HRbNbv7ZvNdpRPUJ4ZUTb6HV1j9EZnv0
3q8Q/k8ERs0ivExiqqcG+QF544S/CM/Lpj11TKT9G8+Q1MkHtmboZ1hmjgy9qK3Y
Dyn3yRjfOy48iQlJe6ERV1LXLeWEeQ==
=RcjK
-----END PGP SIGNATURE-----

--NtwzykIc2mflq5ck--

