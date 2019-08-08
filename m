Date: Thu, 8 Aug 2019 10:38:25 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190808093825.GB31963@stefanha-x1.localdomain>
References: <5D4BBDB7.2000005@huawei.com>
 <5D4BBDFF.6060106@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <5D4BBDFF.6060106@huawei.com>
Subject: Re: [Virtio-fs] [PATCH v3 1/2] virtiofsd: add definition of
	fuse_buf_writev()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 08, 2019 at 02:15:27PM +0800, piaojun wrote:
> @@ -71,6 +72,42 @@ static ssize_t fuse_buf_write(const struct fuse_buf *d=
st, size_t dst_off,
>  	return copied;
>  }
>=20
> +ssize_t fuse_buf_writev(fuse_req_t req,
> +			     struct fuse_bufvec *out_buf,
> +			     struct fuse_bufvec *in_buf,
> +			     enum fuse_buf_copy_flags flags)

FUSE_BUF_FD_SEEK is defined in enum fuse_buf_flags, not enum
fuse_buf_copy_flags.  This argument can be removed and the check below
can be changed from:

  if (flags & FUSE_BUF_FD_SEEK)

to

  if (out_buf->buf[0].flags & FUSE_BUF_FD_SEEK)

> +{
> +	ssize_t res, i, buf_index, iovcnt;
> +	struct iovec * iov;
> +	int fd =3D out_buf->buf[0].fd;
> +	off_t pos =3D out_buf->buf[0].pos;

A struct fuse_bufvec may have multiple elements but this function
assumes it only has 1.  Please use struct fuse_buf *out_buf instead.
This way it's clear that only 1 fuse_buf will be written.

> +
> +	if (in_buf->count > 2)
> +		iovcnt =3D in_buf->count - 1;
> +	else
> +		iovcnt =3D 1;
> +
> +	iov =3D calloc(iovcnt, sizeof(struct iovec));
> +	if (!iov)
> +		return -ENOMEM;
> +
> +	for (i =3D 0, buf_index =3D 1; i < iovcnt; i++, buf_index++) {
> +		iov[i].iov_base =3D in_buf->buf[buf_index].mem;
> +		iov[i].iov_len =3D in_buf->buf[buf_index].size;
> +	}

Why is in_buf->buf[0] is skipped?

> +
> +	if (flags & FUSE_BUF_FD_SEEK)
> +		res =3D pwritev(fd, iov, iovcnt, pos);

Please move off_t pos =3D out_buf->buf[0].pos into this if statement body
to avoid a possible uninitialized memory access when !(flags &
FUSE_BUF_FD_SEEK).  This makes valgrind and other tools happy.

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1L7ZEACgkQnKSrs4Gr
c8hVvgf/fXuUGT3u/ByY8oAfx6FeUvQtiXPXXXc8Gy+67TITKpEqREHOh3ZuQCzk
oeu2U3rYAM0M62iC9znyssHdqUmJ2yeCZXO2urromi+tzg+qXnYIcku9lM8iXfao
NlwPIjkNwBwphwSXdWSnvlbjVe4OY2OryxujMGdZhHsDVlM51A6ykb+H3QEBKgDH
yl46x9BRcC8UzoWLN407gWzQ/BqpM6SNUX3/GM+EwYwl6Ajsj+CMReE0BHXGyOm3
4uPUgfbe/bdPd3b+fHVuW/2jPIZWv6/Nh7JOBXq+Cu4HaS5tpWozyR0HoAaW3xuo
O/3sbghUg+MuMBTjMc7v2iP3l6kiHw==
=SGkJ
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--

