Date: Tue, 5 Oct 2021 13:22:58 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YVxDouMEj3aqTNf3@stefanha-x1.localdomain>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-14-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gvHFzYKtcbZ26Q1s"
Content-Disposition: inline
In-Reply-To: <20210930153037.1194279-14-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 13/13] virtiofsd,
 seccomp: Add clock_nanosleep() to allow list
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, qemu-devel@nongnu.org, virtio-fs@redhat.com


--gvHFzYKtcbZ26Q1s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 30, 2021 at 11:30:37AM -0400, Vivek Goyal wrote:
> g_usleep() calls nanosleep() and that now seems to call clock_nanosleep()
> syscall. Now these patches are making use of g_usleep(). So add
> clock_nanosleep() to list of allowed syscalls.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/passthrough_seccomp.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/pass=
through_seccomp.c
> index cd24b40b78..03080806c0 100644
> --- a/tools/virtiofsd/passthrough_seccomp.c
> +++ b/tools/virtiofsd/passthrough_seccomp.c
> @@ -117,6 +117,7 @@ static const int syscall_allowlist[] =3D {
>      SCMP_SYS(writev),
>      SCMP_SYS(umask),
>      SCMP_SYS(nanosleep),
> +    SCMP_SYS(clock_nanosleep),

This patch can be dropped once sleep has been replaced by a condvar.

--gvHFzYKtcbZ26Q1s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFcQ6IACgkQnKSrs4Gr
c8hAWggAtWAYKqdiNQnnzwGMGMCtbpq78P2T9Y1X0YRwNqi6RQW2LLTne8DrCS3m
sssAGkK1c19CYa8tyaDBolKFNtUEPY2aIUW8mikXrPj72CrNH4dy9fFhdXFoLb/a
/nMYQ57E8mvzVfNgOaZjhmr7IPQoU+CFP3kMaL0o+J/PrRqrWcYj7alx29ASnV3B
0mkjZJGYqPJeEWpchfQDHK94H3p9qNVA2FpZ8ZPzjc9ofXo1ijGno6QNxEodqnYc
RA3xdCz/8wLfhLPf20yCunBuhRe//CqBb921d8ZTCLv2G6jf9NLUB9mMy/lshtDx
89wMw2pIffXtGeklEYxJ2c/YXiNkYA==
=ocDr
-----END PGP SIGNATURE-----

--gvHFzYKtcbZ26Q1s--

