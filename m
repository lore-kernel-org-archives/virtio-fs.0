Date: Wed, 31 Jul 2019 16:04:43 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190731150443.GC7363@stefanha-x1.localdomain>
References: <20190730215000.15660-1-msys.mizuma@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Content-Disposition: inline
In-Reply-To: <20190730215000.15660-1-msys.mizuma@gmail.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Add gettimeofday to the seccomp
 whitelist
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2019 at 05:50:00PM -0400, Masayoshi Mizuma wrote:
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>=20
> When I run fsstress on the virtio filesystem, virtiofsd sometimes
> exits abnormally because it receives SIGSYS.
>=20
> >From strace:
>   195852 15:07:47.799331 read(8, "\1\0\0\0\0\0\0\0", 8) =3D 8 <0.000011>
>   195852 15:07:47.799379 gettimeofday( <unfinished ...>
>   195852 15:07:53.354340 <... gettimeofday resumed> <unfinished ...>) =3D=
 ?
>   195852 15:07:53.400243 +++ killed by SIGSYS (core dumped) +++
>=20
> That is because virtiofsd calls gettimeofday() system call but
> the system call isn't in the seccomp whitelist.
>=20
> virtiofsd doesn't call gettimeofday() directly. glib library
> function may call g_get_current_time() and g_get_current_time()
> calls the system call.
>=20
> Add gettimeofday() to the seccomp whitelist.
>=20
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> ---
>  contrib/virtiofsd/seccomp.c | 1 +
>  1 file changed, 1 insertion(+)

Have you checked that your guest is using the vdso gettimeofday()
implementation?  gettimeofday() is implemented in userspace without a
syscall using vdso to improve performance.  If your guest isn't using it
then performance will be worse.  (There is a fallback code path in the
vdso that invokes the syscall but I'm not sure it is taken in normal
cases.)

The patch is fine though:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1BrgsACgkQnKSrs4Gr
c8iU3AgAmRUbiQAK41hT3sZ8lzwZgZcNISfw6bzvmKs5vRdLeOLwpoimA888Oyqs
YmSZzs7zuOq/7/MLL27gNGBDnPOdyIzQSgFhjG1wXY6b1vGHC1fyNiJaHTPra0fS
BozoUNWT0YpNM0SsKZSMHn0wFrUdKUHtYSp7w9tjJkXNppGqBmLg/NN8nOChAP8W
6+njwtvOJ0C0GGsif4AX5FJISfcLjqwfTxiyp/GVDs+lbLpHyP91x5Dst2COLNrP
YfYWKlCCq5Vv98lyHmQqE5+7E2L0r9Bc+/2YWGrOClU2pmyq9VGkFrtncbkiArH0
nzWTgDUDB5SxFqoohntEz93ykjajeA==
=w5q0
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--

