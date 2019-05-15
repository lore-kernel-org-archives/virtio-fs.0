Date: Wed, 15 May 2019 16:10:05 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190515151005.GI29507@stefanha-x1.localdomain>
References: <1557208720-44561-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hABqaeELJqnDDeDE"
Content-Disposition: inline
In-Reply-To: <1557208720-44561-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: do fallocate for setupmapping
 requests with write flag
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com


--hABqaeELJqnDDeDE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 07, 2019 at 01:58:40PM +0800, Liu Bo wrote:
> We'll have to make sure filesystem has allocated space for the dax
> mapping, otherwise, guest writes from virtiofs may hang since write
> page fault is not able to be resolved if host fs is full
> (->page_mkwrite() return -ENOSPC).

The issues I see with fallocate are:

1. Space is now reserved for anything that is mapped with the write bit,
   even pages that are never written.  This defeats sparseness, which is
   often relied on by applications and users to minimize space usage.

2. The setupmapping performance suffers from the fallocate overhead.

I tend to think that KVM's fault handling should be fixed to check
return values so that the infinite loop is avoided.  The root cause is
in kvm.ko, not in virtiofsd, and fallocate is a workaround rather than a
full fix.

Vivek: Do you have code that stops the async pagefault infinite loop in
kvm.ko?

> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>  contrib/virtiofsd/passthrough_ll.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>=20
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passt=
hrough_ll.c
> index f14f471..1ddb68f 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -1897,12 +1897,28 @@ static void lo_setupmapping(fuse_req_t req, fuse_=
ino_t ino, uint64_t foffset,
> =20
>  	}
> =20
> +        if (flags & O_WRONLY) {
> +                /* this may allocate more space than we need. */
> +                ret =3D fallocate(fd, FALLOC_FL_KEEP_SIZE, foffset, len);
> +                if (ret < 0) {
> +                        ret =3D errno;
> +                        fprintf(stderr, "%s: fallocate fail (ino=3D%" PR=
Id64 "fd=3D%d foffset=3D0x%" PRIx64 ")\n",
> +                                __func__, ino, fi ? (int)fi->fh : lo_fd(=
req, ino), foffset);
> +                        goto err;
> +                }
> +
> +                if (lo_debug(req))
> +                        fprintf(stderr, "fallocate (foffset=3D%" PRIx64 =
"moffset=3D%" PRIx64 ")\n",
> +                                foffset, moffset);
> +        }
> +
>          if (fuse_virtio_map(req, &msg, fd)) {
>                  fprintf(stderr, "%s: map over virtio failed (ino=3D%" PR=
Id64 "fd=3D%d moffset=3D0x%" PRIx64 ")\n",
>                          __func__, ino, fi ? (int)fi->fh : lo_fd(req, ino=
), moffset);
>                  ret =3D EINVAL;
>          }
> =20
> +err:
>  	if (!fi)
>  		close(fd);
>  	fuse_reply_err(req, ret);
> --=20
> 1.8.3.1
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

--hABqaeELJqnDDeDE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlzcK80ACgkQnKSrs4Gr
c8jn1ggApepSGeUUH67OPw0lIiMOtj1Tq2CsjA6GKGiD18JisWpwD3gMPefwXwuu
nzh+/hywX1BUEolxnQoECsVEvvqTSjpQnoa6ATEgWDESsAEQc4hinmIvS3yhUU+f
o8aUyd/VHVrQ7FdA3NiGRnSqlD4/nC0dxREur+JKNu6yKUFeOnZPXmVPgJPwyF6/
d4tTmbBC1UqshbgX+/YhrQWGzIpTrurbszgza63OJKgfWDU2VPVJ2Tk4uGhhlKqT
idXWpd5MwTLgJ/IT6bQQj42lVObCRx/vyIOTNZ/T/sxfLO67pmUSGcMzqibKSzpW
BVXt2MVutBhgP4BFAi3MO9R8N+gl7A==
=UF4X
-----END PGP SIGNATURE-----

--hABqaeELJqnDDeDE--

