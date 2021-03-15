Date: Mon, 15 Mar 2021 10:36:29 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YE84rZ8+yPoUnsg4@stefanha-x1.localdomain>
References: <20210312092212.782255-1-groug@kaod.org>
	<20210312092212.782255-4-groug@kaod.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="kOK2rZth78M287TT"
Content-Disposition: inline
In-Reply-To: <20210312092212.782255-4-groug@kaod.org>
Subject: Re: [Virtio-fs] [PATCH v2 3/7] vhost-user: Factor out duplicated
 slave_fd teardown code
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>


--kOK2rZth78M287TT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 12, 2021 at 10:22:08AM +0100, Greg Kurz wrote:
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>  hw/virtio/vhost-user.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--kOK2rZth78M287TT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBPOK0ACgkQnKSrs4Gr
c8hrtwf/ZN0rNmTMSiDUaauaRULuVilDbIBSF2g0HkJePjoWNgGANcWCUMRieTl0
cPnKlFTgQFhRIc18WrYoiI5SmknKJQ2k6cqJ4UdlvVreOL8E4xPBkhl/bQCW1z1W
vihtd1eTcMbYrbzZqQcnij6++3cH7nIYF6/QLHGFp5urufFNUcEwfYDMoAtZIdns
z6VU4nED01h9+5mH1dvngb0lZV5q8dA1f2iNOR5gl53Uf2sdmfcSJFQMqvnlCddn
J+sr57y8fS89UJZGpsrhh+83WNE8z+wewdPBkrrRpPoPxEdg5Bafn+VoUfsADL3q
Kw3uSV2SEHvybaAn5hKjAF1C5DYUNQ==
=LHtR
-----END PGP SIGNATURE-----

--kOK2rZth78M287TT--

