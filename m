Date: Tue, 10 Mar 2020 10:53:14 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200310105314.GH140737@stefanha-x1.localdomain>
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-4-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="poemUeGtc2GQvHuH"
Content-Disposition: inline
In-Reply-To: <20200304165845.3081-4-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 03/20] virtio: Add get_shm_region method
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


--poemUeGtc2GQvHuH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 04, 2020 at 11:58:28AM -0500, Vivek Goyal wrote:
> From: Sebastien Boeuf <sebastien.boeuf@intel.com>
>=20
> Virtio defines 'shared memory regions' that provide a continuously
> shared region between the host and guest.
>=20
> Provide a method to find a particular region on a device.
>=20
> Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  include/linux/virtio_config.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--poemUeGtc2GQvHuH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5ncZoACgkQnKSrs4Gr
c8jg6gf/SZPcTN7LLKRqnGxHpVb154voV9YMHZaHBKN3vnrXZ/Ea+UHdkyY5QADv
1HY5kbzIGy9+ACo9dYF7RX+TuinFOlr+r5jN3n7IucAg0tpW4TgOk6zpgA78e9lm
mO+nsBaEiHuhUuon5GUa93qEog7TEWFWJdvcPvVzMqZ2Lgn6GWHiREjWIjET8IUW
toe4/8fig7Co7AvRXossbQVGQy6JO0b77Fe1KkrhIGnFm1CCa40cgb9SQWqgZgx+
H8MqAl8thKLsKsusSCvvypkZnO4WI7I7bfQ8y91OFS6eH+TyOjWeCnE92hTIXNxs
ADjNRLTsQ8amVAZxTD9jyKsF+tsOFA==
=Eh/9
-----END PGP SIGNATURE-----

--poemUeGtc2GQvHuH--

