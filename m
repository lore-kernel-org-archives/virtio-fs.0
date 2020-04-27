Date: Mon, 27 Apr 2020 15:38:50 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200427143850.GA1042399@stefanha-x1.localdomain>
References: <20200424062540.23679-1-chirantan@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20200424062540.23679-1-chirantan@chromium.org>
Subject: Re: [Virtio-fs] [PATCH 1/2] fuse: virtiofs: Fix nullptr dereference
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Suleiman Souhlal <suleiman@chromium.org>, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Dylan Reid <dgreid@chromium.org>, Vivek Goyal <vgoyal@redhat.com>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2020 at 03:25:39PM +0900, Chirantan Ekbote wrote:
> virtiofs device implementations are allowed to provide more than one
> request queue.  In this case `fsvq->fud` would not be initialized,
> leading to a nullptr dereference later during driver initialization.
>=20
> Make sure that `fsvq->fud` is initialized for all request queues even if
> the driver doesn't use them.
>=20
> Signed-off-by: Chirantan Ekbote <chirantan@chromium.org>
> ---
>  fs/fuse/virtio_fs.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6m7noACgkQnKSrs4Gr
c8ggGAf/elgVnCuZmIFzajbxqfTtmHhy/O61AV0xEo36kKbsbdFYHsBnOTsXOd/M
d07nBgW4UkQyyf91GJyvOYJC2yPzQvVaCWr/xJ+A0ja1O8LYaA92fgQrM/NPcPLq
q1sV0jFuHl55v5+xtoeJoYDhhLMrAWItR2Wx4D4Oo0WZyjV8ExabbS+phz6DQ4Oj
t86Sgc0n5x76UosfcDZo9OFOTylVh6ceoyqAZsn7t2LbmG8qgyVADCL6KuHdol5M
YJidOq8UNnnrUJ5mRuZ686OLCCWgdv/xynpxZxHgojhZu0S1KkJMqPYE6hnnPMz4
Q/e+0zklnZ4rjnaq6ZFBLlFDuhwUuQ==
=EFET
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--

