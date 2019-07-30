References: <5D3F8F04.3030404@huawei.com>
From: Eric Blake <eblake@redhat.com>
Message-ID: <4ec43f2f-1d72-5fe1-3b93-2c75ee6f87b4@redhat.com>
Date: Tue, 30 Jul 2019 08:28:57 -0500
MIME-Version: 1.0
In-Reply-To: <5D3F8F04.3030404@huawei.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="G4wL2rF1o6vpwhEDCMPunA4sSWwLrOu2n"
Subject: Re: [Virtio-fs] [Qemu-devel] [PATCH] virtiofsd: fix compile error
 if 'F_OFD_GETLK' not defined
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>, virtio-fs@redhat.com, qemu-devel@nongnu.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--G4wL2rF1o6vpwhEDCMPunA4sSWwLrOu2n
Content-Type: multipart/mixed; boundary="jySfH6if46EYLNKEEZbVY2a8IdMEQcgDX";
	protected-headers="v1"
From: Eric Blake <eblake@redhat.com>
To: piaojun <piaojun@huawei.com>, virtio-fs@redhat.com, qemu-devel@nongnu.org
Message-ID: <4ec43f2f-1d72-5fe1-3b93-2c75ee6f87b4@redhat.com>
Subject: Re: [Qemu-devel] [PATCH] virtiofsd: fix compile error if
	'F_OFD_GETLK' not defined
References: <5D3F8F04.3030404@huawei.com>
In-Reply-To: <5D3F8F04.3030404@huawei.com>

--jySfH6if46EYLNKEEZbVY2a8IdMEQcgDX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/29/19 7:27 PM, piaojun wrote:
> Use F_GETLK for fcntl when F_OFD_GETLK not defined.

Which system are you hitting this problem on?

The problem with F_GETLK is that it is NOT as safe as F_OFD_GETLK.

We already have fcntl_op_getlk and qemu_probe_lock_ops() in util/osdep.c
to not only determine which form to use, but also to emit a warning to
the end user if we had to fall back to the unsafe F_GETLK. Why is your
code not reusing that logic?

>=20
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> ---
>  contrib/virtiofsd/passthrough_ll.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/pas=
sthrough_ll.c
> index 9ae1381..757785b 100644
> --- a/contrib/virtiofsd/passthrough_ll.c
> +++ b/contrib/virtiofsd/passthrough_ll.c
> @@ -1619,7 +1619,11 @@ static void lo_getlk(fuse_req_t req, fuse_ino_t =
ino,
>  		return;
>  	}
>=20
> +#ifdef F_OFD_GETLK
>  	ret =3D fcntl(plock->fd, F_OFD_GETLK, lock);
> +#else
> +	ret =3D fcntl(plock->fd, F_GETLK, lock);
> +#endif

Hmm. Since this is in contrib, you are trying to compile something that
is independent of util/osdep.c (at least, I assume that's the case, as
contrib/virtiofsd/ is not even part of qemu.git master yet - in which
case, why is this not being squashed in to the patch introducing that
file, rather than sent standalone).  On the other hand, that raises the
question - who is trying to use virtiofsd on a kernel that is too old to
provid F_OFD_GETLK?  Isn't the whole point of virtiofsd to be speeding
up modern usage, at which point an old kernel is just gumming up the
works?  It seems like you are better off letting compilation fail on a
system that is too old to support decent F_OFD_GETLK, rather than
silently falling back to something that is unsafe.

--=20
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org


--jySfH6if46EYLNKEEZbVY2a8IdMEQcgDX--

--G4wL2rF1o6vpwhEDCMPunA4sSWwLrOu2n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEccLMIrHEYCkn0vOqp6FrSiUnQ2oFAl1ARhkACgkQp6FrSiUn
Q2rs9wgAqMSwVxi/vv9H+ERxszJDYt/TV+N1VBrB9Od43A61XiwxFy5gyTzp3yvn
1rUnz522LlXars9vD1wVsQYhbGgKn//UlAsJtpSZ4nwDZ+sJy2M2yHjvokveM1nM
nVmwszfYjwBsyH57a1OcKgO7POi7etJuInCBrFIjg9ZLVlqSTiXDV97MM31LB9Vr
Z6fjdHH12Za1BBhQh2yNpQmH0kzhhnXlOAyb2d1WSOMwk3bvF1QTFQNOIqiatIpL
da9FOzwBH+tqTyixNCDPuQMJ0OMExQQlItJJn/Q7C9CajY3P9MBnxx8EsCz6n74e
sjw8pQBZm1QV3OXbSKLsfp39I7GmGQ==
=m/4i
-----END PGP SIGNATURE-----

--G4wL2rF1o6vpwhEDCMPunA4sSWwLrOu2n--

