Date: Tue, 14 Sep 2021 15:32:09 +0200
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20210914133106.jfbulec3pd23cfvv@mhamilton>
References: <20210914123214.181885-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6mcs2kfyiq275vhm"
Content-Disposition: inline
In-Reply-To: <20210914123214.181885-1-thuth@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] tools/virtiofsd: Add fstatfs64 syscall to
 the seccomp allowlist
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Thomas Huth <thuth@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, qemu-s390x@nongnu.org, Vivek Goyal <vgoyal@redhat.com>


--6mcs2kfyiq275vhm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 14, 2021 at 02:32:14PM +0200, Thomas Huth wrote:
> The virtiofsd currently crashes on s390x when doing something like
> this in the guest:
>=20
>  mkdir -p /mnt/myfs
>  mount -t virtiofs myfs /mnt/myfs
>  touch /mnt/myfs/foo.txt
>  stat -f /mnt/myfs/foo.txt
>=20
> The problem is that the fstatfs64 syscall is called in this case
> from the virtiofsd. We have to put it on the seccomp allowlist to
> avoid that the daemon gets killed in this case.
>=20
> Buglink: https://bugzilla.redhat.com/show_bug.cgi?id=3D2001728
> Suggested-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  tools/virtiofsd/passthrough_seccomp.c | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Sergio Lopez <slp@redhat.com>

> diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/pass=
through_seccomp.c
> index f49ed94b5e..a3ce9f898d 100644
> --- a/tools/virtiofsd/passthrough_seccomp.c
> +++ b/tools/virtiofsd/passthrough_seccomp.c
> @@ -51,6 +51,7 @@ static const int syscall_allowlist[] =3D {
>      SCMP_SYS(fsetxattr),
>      SCMP_SYS(fstat),
>      SCMP_SYS(fstatfs),
> +    SCMP_SYS(fstatfs64),
>      SCMP_SYS(fsync),
>      SCMP_SYS(ftruncate),
>      SCMP_SYS(futex),
> --=20
> 2.27.0
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
>=20

--6mcs2kfyiq275vhm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmFApFgACgkQ9GknjS8M
AjXT6g//cEMLHGOs3/OAieTxXi8mdIl8rDfO8mS4f+VrhnXDpiIgwtejQXDFyXdt
iUEsMmm6DNq43gNhLVo52mSxaAfDjipaoO/2tc6ANF/K8QulvQnoabI2+lPS0ilt
KmcVhzDSSoIxv8xyIKIHbcKiEgX2ZtsI9DIg1sHInZwkNp2CKv71Qe6xIIaSDgkr
BbZ+aeqMf7jZqulNxob/uvchg11K2Aq8gwS6PEQsaCGsf/cQX3xNgaf8gPIblr7X
SZnNxu/oCQlOwdxNDNN2HagEqeGfl10XzN05m4QasizcwpC9Xbsr8jOKwmfxkTT5
cQAidjTfBCZChpkLLyqG7Bv2MVPTTpRylEpQIe2wT9vDNK8aHh7qOEk5rwxQO0/P
cnUk4MBR0zfe9k/4jQZcVTzsPClKhqlZJh7kzB/m31Mo8Iun4Pf1HfXXBoXMmVXX
DbBn+uau3ZyNfMWFIapCZbLS2ZReHuILt1fNomsGmhCBmb/+5NawUYNaubGYZVBw
2UZCsdlPr74C+jxUZOgfwgxNVEhIQqiTZsFVvmE/j0F//uTM41k4d5GVq154Yviy
+Sm8POceEHDh6AEfdedUg2H3CV8hcxlTQfSxijguOs+AP4q0lB4vORRu1GI0D919
TDSvcNIJYRHw8VjGClIygE/6ubEzE4Ven9+ADfQMC+asaNHs/gI=
=OFEB
-----END PGP SIGNATURE-----

--6mcs2kfyiq275vhm--

