Date: Mon, 4 Oct 2021 14:19:46 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YVr/clKO1o2RoG+Z@stefanha-x1.localdomain>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-5-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gTen1rWalgkNewo3"
Content-Disposition: inline
In-Reply-To: <20210930153037.1194279-5-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 04/13] virtiofsd: Add a helper to send
 element on virtqueue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, qemu-devel@nongnu.org, virtio-fs@redhat.com


--gTen1rWalgkNewo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 30, 2021 at 11:30:28AM -0400, Vivek Goyal wrote:
> We have open coded logic to take locks and push element on virtqueue at
> three places. Add a helper and use it everywhere. Code is easier to read =
and
> less number of lines of code.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 45 ++++++++++++++---------------------
>  1 file changed, 18 insertions(+), 27 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--gTen1rWalgkNewo3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFa/3IACgkQnKSrs4Gr
c8jC+wf+M3shDcBqsHiVzj5WsHTy+j1h/LcYjrzASnkPgCv0EzMxVffPelDUk/YR
KGT8QvuPOmVVtu7+wWwlPPwPuKTb13dz8Yxk/cdGM/+bH7V0CAE9Nelj3tnrIwQm
7qQwe8Rps36cD8Zb4CQBvjs86nJBjUJ1Ygdva1Wz/X3xvNGGTSaIYf8yfxYtg4qR
7WQjROE36ipTZJx8tRplrNnoUTHHIq2tWbnYH0L+3b7X9DtJ+KVsiMmp5M/p68Mr
6M+qz8K9+qVPFBF9GHvrkM4KJKBSJXqpme8UBw8N20+kXPdDTQFFAFiDStpKdZVg
kkIOpOjxri9y4etRx2Fp8ttksuyOaQ==
=IHXg
-----END PGP SIGNATURE-----

--gTen1rWalgkNewo3--

