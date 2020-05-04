DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to;
	bh=701IHL97AJLPqzxksKXgI0+OQ6FtCyzXsDsf0H0loI8=;
	b=Cow85AhkcasGHTczjWACpOPclFJcDoNPs3/nH0v6c3/4+WBKYKU2NmphuCH86XsH9E
	MloASgdSQzHNIOGUGwXAf0p4rKTNVw/lU5Zs5X/MMsaiYdx7INwYWtZm4CWfOBLiy5Ld
	YbaN5nCPxzzI000A8i0WBWPsDEeeE+oHF90YAj6IcztbzynsmUeLgXBA+0aDLiJDn/kk
	OWzvIRMZWn4yTFvGK8MgXb5adVizS5q8TYOb8gO23R72mAqG/z9TDqvlZ5QaG6Y7sGYN
	qTLVcfvFPKE4X6bOGjzZbr/4hnm31oRz05nKf7pVQ1Zi6FOjQm/LV0lA0iRTHtMFTuFp
	Y92g==
Date: Mon, 4 May 2020 14:49:35 +0100
From: Stefan Hajnoczi <stefanha@gmail.com>
Message-ID: <20200504134935.GI354891@stefanha-x1.localdomain>
References: <348d4774-bd5f-4832-bd7e-a21491fdac8d@www.fastmail.com>
MIME-Version: 1.0
In-Reply-To: <348d4774-bd5f-4832-bd7e-a21491fdac8d@www.fastmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/8E7gjuj425jZz9t"
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Use clone() and not unshare(),
 support non-root
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Colin Walters <walters@verbum.org>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

--/8E7gjuj425jZz9t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 01, 2020 at 02:25:48PM -0400, Colin Walters wrote:
> I'd like to make use of virtiofs as part of our tooling in
> https://github.com/coreos/coreos-assembler
> Most of the code runs as non-root today; qemu also runs as non-root.
> We use 9p right now.
>=20
> virtiofsd's builtin sandboxing effectively assumes it runs as
> root.
>=20
> First, change the code to use `clone()` and not `unshare()+fork()`.
>=20
> Next, automatically use `CLONE_NEWUSER` if we're running as non root.
>=20
> This is similar logic to that in https://github.com/containers/bubblewrap
> (Which...BTW, it could make sense for virtiofs to depend on bubblewrap
>  and re-exec itself rather than re-implementing the containerization
>  itself)

Great, thanks for posting this! The topic of how and when to do the
sandboxing, as well as whether to require root, has come up several
times.

Please update the man page to explain the behavior that users should
expect when running as non-root:
1. What happens to uid/gid of files from the perspective of a user
   outside the sandbox?
2. Are there any limitations (certain operations that don't work)?

Thanks,
Stefan

>=20
> Signed-off-by: Colin Walters <walters@verbum.org>
> ---
>  tools/virtiofsd/passthrough_ll.c | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
>=20
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrou=
gh_ll.c
> index 4c35c95b25..468617f6d6 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2530,6 +2530,21 @@ static void print_capabilities(void)
>      printf("}\n");
>  }
> =20
> +/* Copied from bubblewrap */
> +static int
> +raw_clone(unsigned long flags, void *child_stack)
> +{
> +#if defined(__s390__) || defined(__CRIS__)
> +  /*
> +   * On s390 and cris the order of the first and second arguments
> +   * of the raw clone() system call is reversed.
> +   */
> +    return (int) syscall(__NR_clone, child_stack, flags);
> +#else
> +    return (int) syscall(__NR_clone, flags, child_stack);
> +#endif
> +}
> +
>  /*
>   * Move to a new mount, net, and pid namespaces to isolate this process.
>   */
> @@ -2547,14 +2562,15 @@ static void setup_namespaces(struct lo_data *lo, =
struct fuse_session *se)
>       * an empty network namespace to prevent TCP/IP and other network
>       * activity in case this process is compromised.
>       */
> -    if (unshare(CLONE_NEWPID | CLONE_NEWNS | CLONE_NEWNET) !=3D 0) {
> -        fuse_log(FUSE_LOG_ERR, "unshare(CLONE_NEWPID | CLONE_NEWNS): %m\=
n");
> -        exit(1);
> +    int clone_flags =3D SIGCHLD | CLONE_NEWPID | CLONE_NEWNS | CLONE_NEW=
NET;
> +    /* If we're non root, we need a new user namespace */
> +    if (getuid() !=3D 0) {
> +        clone_flags |=3D CLONE_NEWUSER;
>      }
> =20
> -    child =3D fork();
> +    child =3D raw_clone(clone_flags, NULL);
>      if (child < 0) {
> -        fuse_log(FUSE_LOG_ERR, "fork() failed: %m\n");
> +        fuse_log(FUSE_LOG_ERR, "clone() failed: %m\n");
>          exit(1);
>      }
>      if (child > 0) {
> --=20
> 2.24.1
>=20
>=20

--/8E7gjuj425jZz9t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6wHW4ACgkQnKSrs4Gr
c8jEKwf/Tc5syIJkh/dNa9X4ofgIChixMbtjdgeAlTVDZwUY2ZHGpCTW9K/s6a8a
0nvYZXWw/u/E0/RA18udges0FShOEqbku/k/5RoT8GMV+FEOGIENIvlm2Un9PsYV
wxjRQed/npg2DWZl3yKMKrdAbGMwee5RazGZnjxID3RUTpMi6HIAJMfUw1PkwJN7
Ebs70rsKFeN+mOojCsy6K5x/yGoizEwEnUYbhqDq0Yl/K4Da2SXY6cd2rsyYR7IU
0LniOMTpb4gX5BuZGvqN2yb24eQa7wvkvM9vPxC3KjmoVOfljkRvZkG15IwYN0qa
5z4y8zzcKwYdwgVXy2XzIVrIuKftRw==
=eoEn
-----END PGP SIGNATURE-----

--/8E7gjuj425jZz9t--

