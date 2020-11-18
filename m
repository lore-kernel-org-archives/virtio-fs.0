Date: Wed, 18 Nov 2020 08:48:03 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201118084803.GA182763@stefanha-x1.localdomain>
References: <20201117194131.GA96587@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <20201117194131.GA96587@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3] virtiofsd: Use --thread-pool-size=0 to
 mean no thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, jose.carlos.venegas.munoz@intel.com, qemu-devel@nongnu.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2020 at 02:41:31PM -0500, Vivek Goyal wrote:
> This is V3 of the patch. A minor change since V2 is to reverse the list
> before executing requests. We are prepending elements to the list and that
> means when we start processing requests, we are processing these in
> the reverse order. Though we don't guarantee any ordering but it does
> not hurt to process requests in same order as received as much as
> possible.
>=20
> Right now we create a thread pool and main thread hands over the request
> to thread in thread pool to process. Number of threads in thread pool
> can be managed by option --thread-pool-size.
>=20
> In tests we have noted that many of the workloads are getting better
> performance if we don't use a thread pool at all and process all
> the requests in the context of a thread receiving the request.
>=20
> Hence give user an option to be able to run virtiofsd without using
> a thread pool.
>=20
> To implement this, I have used existing option --thread-pool-size. This
> option defines how many maximum threads can be in the thread pool.
> Thread pool size zero freezes thead pool. I can't see why will one
> start virtiofsd with a frozen thread pool (hence frozen file system).
> So I am redefining --thread-pool-size=3D0 to mean, don't use a thread poo=
l.
> Instead process the request in the context of thread receiving request
> from the queue.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 37 ++++++++++++++++++++++++++---------
>  1 file changed, 28 insertions(+), 9 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+038MACgkQnKSrs4Gr
c8hXUAgAkj0Nt9AV1TD3uyF86ErMcdzhVgmisE8gOBeOO+/AxWgulIZKasUQ+wvT
Vvn1uLcwO7wFGI+Np0UafiweWjnc257DrBOCs5IYM3m2X+ddJGxXCIKNed3Z7JJr
JTPQc8l0hLwiIgGtDOsj0OKPlw8ywRkU7IU3U4nQ4voWYR5I03OJcVGpnmMGlmfy
ogd/JD1qjY/umChUChpNvD5AdXUcpe4JA87Bmk2/atVeXYwHoQvplICIAf3egNPP
6LHKoCBKx66YepRrpgDVD2zWJf7B94ogF0w5lQGcELfguKk9ZIC9DmRRlFkVDSuX
+0BUILQJWdFIUcarTU64vqoSv/8RjQ==
=3F15
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--

