Date: Mon, 4 Oct 2021 14:22:21 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YVsADXfyANPqIEdW@stefanha-x1.localdomain>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-6-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Q5PM/KdjM1ckKFE1"
Content-Disposition: inline
In-Reply-To: <20210930153037.1194279-6-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 05/13] virtiofsd: Add a helper to stop all
	queues
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


--Q5PM/KdjM1ckKFE1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 30, 2021 at 11:30:29AM -0400, Vivek Goyal wrote:
> Use a helper to stop all the queues. Later in the patch series I am
> planning to use this helper at one more place later in the patch series.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--Q5PM/KdjM1ckKFE1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFbAAwACgkQnKSrs4Gr
c8jh/gf+J4GZi71MvpMOjRz2royZlqrVlVTykmdREtsI/04vfklgGNTBuVyDMKZZ
qaVDd9pu+NypAWA9rTANFx8G+EkmwU8ayJWnd6qQQUm6oaMjX24P2Lde1HSveFkL
Ek1qOjSqScJgiAOW8py2yFXW1tD2D/DyUbTkORJbYvnoM7MbZAFMQnT1QTfS3iGN
0cHyOB9Gp4W+EyF8d/ygASTg0SXANX1sHrl1VpEG/5uIGLHI4TyAIezjhr26APof
W5+tnkb07+ejWQldek0dAhzj6Oa7vrzow2Oj8pEOmEA2ajLlYf0GXvsYO3dlNesG
K601IbJn6zmfNY3RCaT4uLkKEFp6kg==
=OIYs
-----END PGP SIGNATURE-----

--Q5PM/KdjM1ckKFE1--

