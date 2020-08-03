Date: Mon, 3 Aug 2020 10:54:59 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200803095459.GD244853@stefanha-x1.localdomain>
References: <20200730194736.173994-1-vgoyal@redhat.com>
	<20200730194736.173994-5-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="wULyF7TL5taEdwHz"
Content-Disposition: inline
In-Reply-To: <20200730194736.173994-5-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 4/5] virtiofsd: Open lo->source while
 setting up root in sandbox=NONE mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: berrange@redhat.com, vromanso@redhat.com, qemu-devel@nongnu.org, virtio-fs@redhat.com


--wULyF7TL5taEdwHz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2020 at 03:47:35PM -0400, Vivek Goyal wrote:
> In sandbox=3DNONE mode, lo->source points to the directory which is being
> exported. We have not done any chroot()/pivot_root(). So open lo->source.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrou=
gh_ll.c
> index 76ef891105..a6fa816b6c 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -3209,7 +3209,10 @@ static void setup_root(struct lo_data *lo, struct =
lo_inode *root)
>      int fd, res;
>      struct stat stat;
> =20
> -    fd =3D open("/", O_PATH);
> +    if (lo->sandbox =3D=3D SANDBOX_NONE)
> +        fd =3D open(lo->source, O_PATH);
> +    else
> +        fd =3D open("/", O_PATH);

Up until now virtiofsd has been able to assume that path traversal has
the shared directory as "/".

Now this is no longer true and it is necessary to audit all syscalls
that take path arguments. They must ensure that:
1. Path components are safe (no ".." or "/" allowed)
2. Symlinks are not followed.

Did you audit all syscalls made by passthrough_ll.c?

virtiofsd still needs to restrict the client to the shared directory for
two reasons:
1. The guest may not be trusted. An unprivileged sandbox=3Dnone mount can
   be used with a malicious guest.
2. If accidental escapes are possible then the guest could accidentally
   corrupt or delete files outside the shared directory.

Stefan

--wULyF7TL5taEdwHz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8n3vMACgkQnKSrs4Gr
c8iRsQf/UkXbGSctdsfbjvgX4yRKdTIBNS14iuO8+BHThEoDKAGmSxDKQkCt1dVJ
F1lsVMXyFLviyh3xKJ4uZYBDukIV7uuL/ETA/UotpaSKD+BTDCFn7kMNt9O6H9lW
Ix/MtNt0u9Qv+VGCUwXSS6gEwmyYCgMaikePcqYsU1ncOS/woIi5Wc/MkCg+3Add
8jXtI8E3fOpMOZEKZENaJS1T98mUTawbxl6QVWqOvtrlA/Hj7ePp9YY0YaF/37A1
GcaseSd3p8q3WkpHyPcPn8hRd6IXmqv1pcadi3YIm43YTIKld8UaRO7r/n5OxzMV
Of3JGvz4zKfUOZoBODPJzzrxC8QZAg==
=ecCi
-----END PGP SIGNATURE-----

--wULyF7TL5taEdwHz--

