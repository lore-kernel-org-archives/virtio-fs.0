Date: Thu, 15 Aug 2019 15:50:38 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190815145038.GI10996@stefanha-x1.localdomain>
References: <5D4CC344.7030706@huawei.com> <5D4CC400.9040606@huawei.com>
	<20190814125235.GC23970@stefanha-x1.localdomain>
	<5D54B155.90101@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BghK6+krpKHjj+jk"
Content-Disposition: inline
In-Reply-To: <5D54B155.90101@huawei.com>
Subject: Re: [Virtio-fs] [PATCH v4 2/2] virtiofsd: use fuse_buf_writev to
 replace fuse_buf_write for better performance
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


--BghK6+krpKHjj+jk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2019 at 09:11:49AM +0800, piaojun wrote:
> Hi Stefan,
>=20
> On 2019/8/14 20:52, Stefan Hajnoczi wrote:
> > On Fri, Aug 09, 2019 at 08:53:20AM +0800, piaojun wrote:
> >> diff --git a/contrib/virtiofsd/buffer.c b/contrib/virtiofsd/buffer.c
> >> index cec762f..d127c45 100644
> >> --- a/contrib/virtiofsd/buffer.c
> >> +++ b/contrib/virtiofsd/buffer.c
> >> @@ -318,11 +318,22 @@ static int fuse_bufvec_advance(struct fuse_bufve=
c *bufv, size_t len)
> >>  ssize_t fuse_buf_copy(fuse_req_t req, struct fuse_bufvec *dstv, struc=
t fuse_bufvec *srcv,
> >>  		      enum fuse_buf_copy_flags flags)
> >>  {
> >> +	size_t i;
> >>  	size_t copied =3D 0;
> >>
> >>  	if (dstv =3D=3D srcv)
> >>  		return fuse_buf_size(dstv);
> >>
> >> +	/* use writev to improve bandwidth when all the
> >> +	 * src buffers already mapped by the daemon
> >> +	 * process */
> >=20
> > Some more checks to make this generic:
> >=20
> >> +	for (i =3D 0; i < srcv->count; i++) {
> >> +		if (srcv->buf[i].flags & FUSE_BUF_PHYS_ADDR)
> >> +			break;
> >=20
> >                 if (srcv->buf[i].flags & FUSE_BUF_IS_FD)
> > 		        break;
> >=20
> >> +	}
> >> +	if (i =3D=3D srcv->count)
> >=20
> > Please verify the preconditions for the destination buffer too:
> >=20
> >   && dstv->count =3D=3D 1 && dstv->idx =3D=3D 0 && dstv->off =3D=3D 0 &&
> >   (dstv->buf[0].flags & FUSE_BUF_IS_FD)
>=20
> Thanks for your comments, and I prefer adding checker just for
> FUSE_BUF_IS_FD as fuse_buf_writev() does not care much about the other
> parts. And I personally think so many preconditions will make
> fuse_buf_writev() so specific.

I think these preconditions are necessary.  This function won't do the
right thing if dstv has multiple elements or has been previously
modified (idx/off).

Can you explain why these cases will never happen or why the code is
correct under these cases?

Stefan

--BghK6+krpKHjj+jk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1VcT4ACgkQnKSrs4Gr
c8ifbAf+MA4q/mzMpRXpj6ZmQTpJNzSUaX3LNLTNH3NRbRonZ7M8sI+cNLPBbkCi
2X5lTSN068PmXj5/wtjXeTOauDmokcpracUg+VXKdDzyWoAkxYKx02NLF75RVMt6
k+oujyqcpJcrJpBXDM0UJCq310cQDM5JkTNtEf4jFpR+6YZ2rUgVOXwvFWGZx+3K
o0cPksB3LCkl7+4/seWeN3YtQCUsLF+qN0T5EohCfWL3eZSM/3Ub85KlmvyaW2Ka
r/cV4rk0zy1JloBqI4EMOOTrjFhoaWsmIdUpQYCAltg930Je/gFlccOTWeefQmee
6Xl1ahf7rNBfX2E6/8NWbOY94yYWmw==
=edGF
-----END PGP SIGNATURE-----

--BghK6+krpKHjj+jk--

