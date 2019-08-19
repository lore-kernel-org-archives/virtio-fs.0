Date: Mon, 19 Aug 2019 11:08:44 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190819100844.GC28081@stefanha-x1.localdomain>
References: <5D4CC344.7030706@huawei.com> <5D4CC400.9040606@huawei.com>
	<20190814125235.GC23970@stefanha-x1.localdomain>
	<5D54B155.90101@huawei.com>
	<20190815145038.GI10996@stefanha-x1.localdomain>
	<5D55FD7B.3080909@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="f0KYrhQ4vYSV2aJu"
Content-Disposition: inline
In-Reply-To: <5D55FD7B.3080909@huawei.com>
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


--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2019 at 08:48:59AM +0800, piaojun wrote:
> On 2019/8/15 22:50, Stefan Hajnoczi wrote:
> > On Thu, Aug 15, 2019 at 09:11:49AM +0800, piaojun wrote:
> >> Hi Stefan,
> >>
> >> On 2019/8/14 20:52, Stefan Hajnoczi wrote:
> >>> On Fri, Aug 09, 2019 at 08:53:20AM +0800, piaojun wrote:
> >>>> diff --git a/contrib/virtiofsd/buffer.c b/contrib/virtiofsd/buffer.c
> >>>> index cec762f..d127c45 100644
> >>>> --- a/contrib/virtiofsd/buffer.c
> >>>> +++ b/contrib/virtiofsd/buffer.c
> >>>> @@ -318,11 +318,22 @@ static int fuse_bufvec_advance(struct fuse_buf=
vec *bufv, size_t len)
> >>>>  ssize_t fuse_buf_copy(fuse_req_t req, struct fuse_bufvec *dstv, str=
uct fuse_bufvec *srcv,
> >>>>  		      enum fuse_buf_copy_flags flags)
> >>>>  {
> >>>> +	size_t i;
> >>>>  	size_t copied =3D 0;
> >>>>
> >>>>  	if (dstv =3D=3D srcv)
> >>>>  		return fuse_buf_size(dstv);
> >>>>
> >>>> +	/* use writev to improve bandwidth when all the
> >>>> +	 * src buffers already mapped by the daemon
> >>>> +	 * process */
> >>>
> >>> Some more checks to make this generic:
> >>>
> >>>> +	for (i =3D 0; i < srcv->count; i++) {
> >>>> +		if (srcv->buf[i].flags & FUSE_BUF_PHYS_ADDR)
> >>>> +			break;
> >>>
> >>>                 if (srcv->buf[i].flags & FUSE_BUF_IS_FD)
> >>> 		        break;
> >>>
> >>>> +	}
> >>>> +	if (i =3D=3D srcv->count)
> >>>
> >>> Please verify the preconditions for the destination buffer too:
> >>>
> >>>   && dstv->count =3D=3D 1 && dstv->idx =3D=3D 0 && dstv->off =3D=3D 0=
 &&
> >>>   (dstv->buf[0].flags & FUSE_BUF_IS_FD)
> >>
> >> Thanks for your comments, and I prefer adding checker just for
> >> FUSE_BUF_IS_FD as fuse_buf_writev() does not care much about the other
> >> parts. And I personally think so many preconditions will make
> >> fuse_buf_writev() so specific.
> >=20
> > I think these preconditions are necessary.  This function won't do the
> > right thing if dstv has multiple elements or has been previously
> > modified (idx/off).
> >=20
> > Can you explain why these cases will never happen or why the code is
> > correct under these cases?
> >=20
> > Stefan
> >=20
>=20
> We have already reached an agreement with the src buf and need discuss
> with the dst buf. So I spent some time looking into libfuse code, and
> found your suggestion really make sense. My previous thought was that
> idx/off only works when dst is buf. So I will make these preconditions
> more generic like this:
>=20
> In fuse_buf_copy():
> if (i =3D=3D srcv->count) {
> dstv->buf[0].pos +=3D dstv->off; // add dst offset even if it's always 0
> fuse_buf_writev(req, &dstv->buf[0], srcv);
> }

The caller doesn't expect dstv->buf[0].pos to change, so it is safer to
use a local variable for the file position inside fuse_buf_writev()
instead of doing this in fuse_buf_copy().

Hope this makes sense,
Stefan

--f0KYrhQ4vYSV2aJu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1adSwACgkQnKSrs4Gr
c8jgXAgAmwv+1hWn5Oh7ARMZ9fNfCIyNDNF/s6r/t6lSBoUPqV9n+fKRCNdttxw3
Yon+2WKMixZwhnq+IJoQ/4YRBG5Fl6Va7YJ1ezdCxzh+XAqyIM+mrIlL8wADKFOV
+oBdGDaIFTK/ymkYPh4yLFcs8KgwpdDr3ARLMMC4FOduQH9YOALKyZPec+cMIDEO
FB5Ua2wl52HvkLAtvSHdNn30SUBHBUzdqRb8crbs+dg5yNzFtLE4rnUpv5JMoF7G
u2eybUnfDTp25oFA/hGmvXyCgP+KV0UHLnx+3cMdjyvuc7gi4j/PEBDQTfQeu0pY
GitcEKx3aKD1jPoZASqImfpwnXyKKA==
=n0qu
-----END PGP SIGNATURE-----

--f0KYrhQ4vYSV2aJu--

