Date: Fri, 9 Aug 2019 09:14:58 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190809081458.GA25286@stefanha-x1.localdomain>
References: <5D4BBDB7.2000005@huawei.com> <5D4BBDFF.6060106@huawei.com>
	<20190808093825.GB31963@stefanha-x1.localdomain>
	<99a1f006-8e5c-0c1c-2cc5-9579ccf0495d@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <99a1f006-8e5c-0c1c-2cc5-9579ccf0495d@huawei.com>
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


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 08, 2019 at 10:28:26PM +0800, piaojun wrote:
> On 2019/8/8 17:38, Stefan Hajnoczi wrote:
> > On Thu, Aug 08, 2019 at 02:15:27PM +0800, piaojun wrote:
> >> +{
> >> +	ssize_t res, i, buf_index, iovcnt;
> >> +	struct iovec * iov;
> >> +	int fd =3D out_buf->buf[0].fd;
> >> +	off_t pos =3D out_buf->buf[0].pos;
> >=20
> > A struct fuse_bufvec may have multiple elements but this function
> > assumes it only has 1.  Please use struct fuse_buf *out_buf instead.
> > This way it's clear that only 1 fuse_buf will be written.
>=20
> Do you mean that assign *out_buf with &out_buf->buf[0] in
> fuse_buf_writev() and then operate out_buf in the following process?

Since this function assumes that out_buf is only a single struct
fuse_buf, please change the argument to struct fuse_buf instead of
struct fuse_bufvec.  This way it's clear what the function expects.

> >=20
> >> +
> >> +	if (in_buf->count > 2)
> >> +		iovcnt =3D in_buf->count - 1;
> >> +	else
> >> +		iovcnt =3D 1;
> >> +
> >> +	iov =3D calloc(iovcnt, sizeof(struct iovec));
> >> +	if (!iov)
> >> +		return -ENOMEM;
> >> +
> >> +	for (i =3D 0, buf_index =3D 1; i < iovcnt; i++, buf_index++) {
> >> +		iov[i].iov_base =3D in_buf->buf[buf_index].mem;
> >> +		iov[i].iov_len =3D in_buf->buf[buf_index].size;
> >> +	}
> >=20
> > Why is in_buf->buf[0] is skipped?
>=20
> This part of code seems a little complex and in_buf->buf[0].count just
> tricks me. Maybe I need handle two situations:
> 1. Iterate from in_buf->buf[0].mem when in_buf->buf[0].count is 1;
> 2. buf[0].size is set 0 in do_write_buf() when in_buf->buf[0].count > 1,
> and it's better to skip it. Perhaps it's also ok to iterate from buf[0],
> as writev skip the iov with zero len. This looks like a hack.

I would perform writev() with all of in_buf's buffers, even if some of
them have 0 length.  That way this function does not make any
assumptions about in_buf's layout.

The only requirement is that in_buf buffers are all memory buffers (not
file descriptors).

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1NK4EACgkQnKSrs4Gr
c8hh3Af+IgMyb/Tu9/EyF2VSSKZff0DxwYbVVX3Pdbi7DKXqZ/b37mwD9lL95cA6
8MGi0gtp8WS/StYx8AqUSRBH6w70gMyj+YI2/YDFQ5lQM4bwbFQQLAJGYZLVvdG0
cH0CP8hj77j44JKXAxRdWa7NLfwYSrokerMgnGBvSultLwjzznBq6xPfLwex69PW
i3TMhyCnrqY/wQM+wjioKiriAkWJTmZwpqWCxbnxCNRzA7Oh+9tcCxYatXWPT2ZC
89z4TfLGscX/FzlG51CRkiERIThO8D68VSph65nZwM2egZfHq7n2IPUZA9LinwJQ
2EtfJIiGLfyf5gFcXC3i4xlXUhq7Gg==
=o1Nl
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--

