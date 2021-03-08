Date: Mon, 8 Mar 2021 16:14:04 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YEZNTFOT2noej13i@stefanha-x1.localdomain>
References: <20210304174536.54446-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oUmqqy8k+NY1XmB9"
Content-Disposition: inline
In-Reply-To: <20210304174536.54446-1-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Don't assume header layout
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, vgoyal@redhat.com


--oUmqqy8k+NY1XmB9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 04, 2021 at 05:45:36PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> virtiofsd incorrectly assumed a fixed set of header layout in the virt
> queue; assuming that the fuse and write headers were conveniently
> separated from the data;  the spec doesn't allow us to take that
> convenience, so fix it up to deal with it the hard way.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 84 ++++++++++++++++++++++++++---------
>  1 file changed, 63 insertions(+), 21 deletions(-)
>=20
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index 523ee64fb7..55e2e057ec 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -129,18 +129,55 @@ static void fv_panic(VuDev *dev, const char *err)
>   * Copy from an iovec into a fuse_buf (memory only)
>   * Caller must ensure there is space
>   */
> -static void copy_from_iov(struct fuse_buf *buf, size_t out_num,
> -                          const struct iovec *out_sg)
> +static size_t copy_from_iov(struct fuse_buf *buf, size_t out_num,
> +                            const struct iovec *out_sg,
> +                            size_t max)
>  {
>      void *dest =3D buf->mem;
> +    size_t copied =3D 0;
> =20
> -    while (out_num) {
> +    while (out_num && max) {
>          size_t onelen =3D out_sg->iov_len;
> +        onelen =3D MIN(onelen, max);
>          memcpy(dest, out_sg->iov_base, onelen);
>          dest +=3D onelen;
> +        copied +=3D onelen;
>          out_sg++;
>          out_num--;
> +        max -=3D onelen;
>      }
> +
> +    return copied;
> +}
> +
> +/*
> + * Skip 'skip' bytes in the iov; 'sg_1stindex' is set as
> + * the index for the 1st iovec to read data from, and
> + * 'sg_1stskip' is the number of bytes to skip in that entry.
> + *
> + * Returns True if there are at least 'skip' bytes in the iovec
> + *
> + */
> +static bool skip_iov(const struct iovec *sg, size_t sg_size,
> +                     size_t skip,
> +                     size_t *sg_1stindex, size_t *sg_1stskip)
> +{
> +    size_t vec;
> +
> +    for (vec =3D 0; vec < sg_size; vec++) {
> +        if (sg[vec].iov_len > skip) {
> +            *sg_1stskip =3D skip;
> +            *sg_1stindex =3D vec;
> +
> +            return true;
> +        }
> +
> +        skip -=3D sg[vec].iov_len;
> +    }
> +
> +    *sg_1stindex =3D vec;
> +    *sg_1stskip =3D 0;
> +    return skip =3D=3D 0;
>  }

This comment does not match the code: "Returns True if there are at
least 'skip' bytes in the iovec". When skip =3D=3D iov_length(sg, sg_size)
the function returns false.

> =20
>  /*
> @@ -505,14 +542,14 @@ static void fv_queue_worker(gpointer data, gpointer=
 user_data)
>                   elem->index);
>          assert(0); /* TODO */
>      }
> -    /* Copy just the first element and look at it */
> -    copy_from_iov(&fbuf, 1, out_sg);
> +    /* Copy just the fuse_in_header and look at it */
> +    copy_from_iov(&fbuf, out_num, out_sg,
> +                  sizeof(struct fuse_in_header));
> =20
>      pbufv =3D NULL; /* Compiler thinks an unitialised path */
> -    if (out_num > 2 &&
> -        out_sg[0].iov_len =3D=3D sizeof(struct fuse_in_header) &&
> -        ((struct fuse_in_header *)fbuf.mem)->opcode =3D=3D FUSE_WRITE &&
> -        out_sg[1].iov_len =3D=3D sizeof(struct fuse_write_in)) {
> +    if (((struct fuse_in_header *)fbuf.mem)->opcode =3D=3D FUSE_WRITE &&
> +        out_len >=3D (sizeof(struct fuse_in_header) +
> +                    sizeof(struct fuse_write_in))) {
>          /*
>           * For a write we don't actually need to copy the
>           * data, we can just do it straight out of guest memory
> @@ -521,15 +558,13 @@ static void fv_queue_worker(gpointer data, gpointer=
 user_data)
>           */
>          fuse_log(FUSE_LOG_DEBUG, "%s: Write special case\n", __func__);
> =20
> -        /* copy the fuse_write_in header afte rthe fuse_in_header */
> -        fbuf.mem +=3D out_sg->iov_len;
> -        copy_from_iov(&fbuf, 1, out_sg + 1);
> -        fbuf.mem -=3D out_sg->iov_len;
> -        fbuf.size =3D out_sg[0].iov_len + out_sg[1].iov_len;
> +        fbuf.size =3D copy_from_iov(&fbuf, out_num, out_sg,
> +                                  sizeof(struct fuse_in_header) +
> +                                  sizeof(struct fuse_write_in));
> =20
>          /* Allocate the bufv, with space for the rest of the iov */
>          pbufv =3D malloc(sizeof(struct fuse_bufvec) +
> -                       sizeof(struct fuse_buf) * (out_num - 2));
> +                       sizeof(struct fuse_buf) * out_num);
>          if (!pbufv) {
>              fuse_log(FUSE_LOG_ERR, "%s: pbufv malloc failed\n",
>                      __func__);
> @@ -540,24 +575,31 @@ static void fv_queue_worker(gpointer data, gpointer=
 user_data)
>          pbufv->count =3D 1;
>          pbufv->buf[0] =3D fbuf;
> =20
> -        size_t iovindex, pbufvindex;
> -        iovindex =3D 2; /* 2 headers, separate iovs */
> +        size_t iovindex, pbufvindex, skip;
>          pbufvindex =3D 1; /* 2 headers, 1 fusebuf */
> =20
> +        skip_iov(out_sg, out_num,
> +                 sizeof(struct fuse_in_header) +
> +                 sizeof(struct fuse_write_in),
> +                 &iovindex, &skip);
> +
>          for (; iovindex < out_num; iovindex++, pbufvindex++) {

What happens when iov_length(out_sg, out_num) =3D=3D sizeof(struct
fuse_in_header) + sizeof(struct fuse_write_in)? I think it will add a
bogus pbufv element.

>              pbufv->count++;
>              pbufv->buf[pbufvindex].pos =3D ~0; /* Dummy */
>              pbufv->buf[pbufvindex].flags =3D 0;
>              pbufv->buf[pbufvindex].mem =3D out_sg[iovindex].iov_base;
>              pbufv->buf[pbufvindex].size =3D out_sg[iovindex].iov_len;
> +
> +            if (skip) {
> +                pbufv->buf[pbufvindex].mem +=3D skip;
> +                pbufv->buf[pbufvindex].size -=3D skip;
> +                skip =3D 0;
> +            }
>          }
>      } else {
>          /* Normal (non fast write) path */
> =20
> -        /* Copy the rest of the buffer */
> -        fbuf.mem +=3D out_sg->iov_len;
> -        copy_from_iov(&fbuf, out_num - 1, out_sg + 1);
> -        fbuf.mem -=3D out_sg->iov_len;
> +        copy_from_iov(&fbuf, out_num, out_sg, se->bufsize);
>          fbuf.size =3D out_len;
> =20
>          /* TODO! Endianness of header */
> --=20
> 2.29.2
>=20

--oUmqqy8k+NY1XmB9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBGTUwACgkQnKSrs4Gr
c8gmcwgAujxy/paw228S6TVDLQ7MQyNUhIxN/pOzIPt1v71myOkiPAygyc3q8FAK
jEPGCgLA6mrXAwH537CqaHM1KTOv7R+e7mYPODvXWRZs5AuPexfyXZYUSLTDkI80
C9o6+gbMMez+ZCAaAREW1nKv/h6p/xpcWBA3egUwuGFQO7Oi0P/9RDqLYLu4cXLB
b//CgeUfoOGoMMVwa0eeWh2wPJzBBffFrYA5xt1sacEoy5G6b1yE1h+Vk9aJuKsz
7kZ+QvbRm6WMH5jBfmT9mnFBZ8kda+abDsnj6+XudZ4zKxNolWdrYq9J99jtx9M9
Oo7/eFuDuflpRFCeJjm6zt/zJdbo4Q==
=CTxl
-----END PGP SIGNATURE-----

--oUmqqy8k+NY1XmB9--

