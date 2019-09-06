Date: Fri, 6 Sep 2019 11:56:58 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906105658.GR5900@stefanha-x1.localdomain>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<20190905194859.16219-11-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Sf3MmCJcUNNLokcm"
Content-Disposition: inline
In-Reply-To: <20190905194859.16219-11-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 10/18] virtiofs: Do not use device managed
 mem for virtio_fs and virtio_fs_vq
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, mst@redhat.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org


--Sf3MmCJcUNNLokcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2019 at 03:48:51PM -0400, Vivek Goyal wrote:
> These data structures should go away when virtio_fs object is going away.
> When deivce is going away, we need to just make sure virtqueues can go
> away and after that none of the code accesses vq and all the requests
> get error.
>=20
> So allocate memory for virtio_fs and virtio_fs_vq normally and free it
> at right time.
>=20
> This patch still frees up memory during device remove time. A later patch
> will make virtio_fs object reference counted and this memory will be
> freed when last reference to object is dropped.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/virtio_fs.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--Sf3MmCJcUNNLokcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1yO3oACgkQnKSrs4Gr
c8gsdQgAw8es95r3jldWITNK2HV3hQUadAUD6wcJTqh47Co/1pn1JWttU9UhsGCs
wlgovlHxIO9oPsjaBc+Vcyczu7QtV+5x4r2lAsxHBH0idZnq6H8T+Om+iM9F3Bhs
hlXTBKrjDt3anxgGHZ/EysPRolxSBPr3W81uqVOATwsS8zKO0liMr6z6brUc12Jx
a9w/zciAljgcusrSgVkQ5C1JwCvMxgGctU1rqzPE1QwPHOT+1/+f7KqJYmTvCYHJ
NfWPrl8z3I68LSE9XkSL6oVU9NDNbey1lzpGIBOpOmZZqucUU67jXy8HO3z2iNB6
UUKV1kzQjkeYn8GGRSqyyJhao8stKw==
=d30F
-----END PGP SIGNATURE-----

--Sf3MmCJcUNNLokcm--

