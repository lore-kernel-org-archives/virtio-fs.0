Date: Tue, 10 Mar 2020 11:06:55 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200310110655.GJ140737@stefanha-x1.localdomain>
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-6-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="u3bvv0EcKsvvYeex"
Content-Disposition: inline
In-Reply-To: <20200304165845.3081-6-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 05/20] virtio: Implement get_shm_region for
	MMIO transport
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, mst@redhat.com, linux-fsdevel@vger.kernel.org


--u3bvv0EcKsvvYeex
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 04, 2020 at 11:58:30AM -0500, Vivek Goyal wrote:
> From: Sebastien Boeuf <sebastien.boeuf@intel.com>
>=20
> On MMIO a new set of registers is defined for finding SHM
> regions.  Add their definitions and use them to find the region.
>=20
> Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
> ---
>  drivers/virtio/virtio_mmio.c     | 32 ++++++++++++++++++++++++++++++++
>  include/uapi/linux/virtio_mmio.h | 11 +++++++++++
>  2 files changed, 43 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--u3bvv0EcKsvvYeex
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5ndM8ACgkQnKSrs4Gr
c8gfygf/do+109aKXm9VFkU/rXC9UEr+hExsP6Lzua5HVq/12kOWyPb6RjeIZfZ/
xpL0jvNcMM2IS72Be3/GddkueGUiN1E44GmjU2+TrXGAh1VzudsId2PJeJfJRsEH
m0WNtnsEQBdeGy5ojXq05pq5yhcq1A7BafE2Fe+mHTDkbB8J/6YtAUzUCIA7Y3m7
2tm9Ju4ERd2cN1Cb9zDCx9eof+ypmPTqaEBF6MYNRuUVhUHhY52ChiWr213rZ2l/
teAcVQZxULQjwnERMuqN/9yupwr7mfZxA3ippJYhHfiAjHks/dA5cIz0xy9jv9/5
kdzLUFXkRegnZVe+HatFmqKOSWXIoA==
=/ks7
-----END PGP SIGNATURE-----

--u3bvv0EcKsvvYeex--

