Date: Tue, 6 Oct 2020 16:39:33 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201006153933.GA87345@stefanha-x1.localdomain>
References: <20201005174531.GB4302@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20201005174531.GB4302@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Fix false positive warning
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Linux fsdevel mailing list <linux-fsdevel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, CAI Qian <caiqian@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 05, 2020 at 01:45:31PM -0400, Vivek Goyal wrote:
> virtiofs currently maps various buffers in scatter gather list and it loo=
ks
> at number of pages (ap->pages) and assumes that same number of pages will
> be used both for input and output (sg_count_fuse_req()), and calculates
> total number of scatterlist elements accordingly.
>=20
> But looks like this assumption is not valid in all the cases. For example,
> Cai Qian reported that trinity, triggers warning with virtiofs sometimes.
> A closer look revealed that if one calls ioctl(fd, 0x5a004000, buf), it
> will trigger following warning.
>=20
> WARN_ON(out_sgs + in_sgs !=3D total_sgs)
>=20
> In this case, total_sgs =3D 8, out_sgs=3D4, in_sgs=3D3. Number of pages i=
s 2
> (ap->pages), but out_sgs are using both the pages but in_sgs are using
> only one page. (fuse_do_ioctl() sets out_size to one page).
>=20
> So existing WARN_ON() seems to be wrong. Instead of total_sgs, it should
> be max_sgs and make sure out_sgs and in_sgs don't cross max_sgs. This
> will allow input and output pages numbers to be different.
>=20
> Reported-by: Qian Cai <cai@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Link: https://lore.kernel.org/linux-fsdevel/5ea77e9f6cb8c2db43b09fbd4158a=
b2d8c066a0a.camel@redhat.com/
> ---
>  fs/fuse/virtio_fs.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index da3ede268604..3f4f2fa0bb96 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -1110,17 +1110,17 @@ static int virtio_fs_enqueue_req(struct virtio_fs=
_vq *fsvq,
>  	unsigned int argbuf_used =3D 0;
>  	unsigned int out_sgs =3D 0;
>  	unsigned int in_sgs =3D 0;
> -	unsigned int total_sgs;
> +	unsigned int  max_sgs;
>  	unsigned int i;
>  	int ret;
>  	bool notify;
>  	struct fuse_pqueue *fpq;
> =20
>  	/* Does the sglist fit on the stack? */
> -	total_sgs =3D sg_count_fuse_req(req);

sg_count_fuse_req() should be exact. It's risky to treat it as a maximum
unless all cases where in_sgs + out_sgs < total_sgs are understood. Even
then, it's still possible that new bugs introduced to the code will go
undetected due to the weaker WARN_ON() condition.

Do you have the values of the relevant fuse_req and fuse_args_pages
fields so we can understand exactly what happened? I think the issue is
that sg_count_fuse_req() doesn't use the fuse_page_desc size field.

Stefan

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl98j7UACgkQnKSrs4Gr
c8gB6gf/aZ4tHmBLaYFN2d9LhfdfFVtnA4Ey8AZGt4yF1aXTtvgX+PVs7dGnPxQK
E2SPRJuNiFpxRN0VwtOxABWO7GG5osYU4l4Tc0+PIBfcyhQUbjWiFchh3TJ3aa+P
Q55fXTSIhfVWi29hTCSofrfjGKyUoJYZ1FvBTjom38S7Bb+36pMWQ0L7Akvs3uTn
gKJdfriolsjxqMPK5Pu/uX08RTcT9ty1gs3KYi9LtVvZZzlntFCEgqicMODevDst
glPRwjRrtMRFVUpX6Xj56Y8XguFwZXgeVRKwdteF2hzbyelpxgutFwbA7gGqqt+Z
9zhzdLjfpJ6T6jl7m5foLXAjuz9fFQ==
=pEjP
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--

