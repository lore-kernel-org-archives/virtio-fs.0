Date: Tue, 13 Apr 2021 09:47:14 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YHVakoU5hY0wif2n@stefanha-x1.localdomain>
References: <20210408195534.647895-1-antonkuchin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5X0H9MV3cTES+qvK"
Content-Disposition: inline
In-Reply-To: <20210408195534.647895-1-antonkuchin@yandex-team.ru>
Subject: Re: [Virtio-fs] [PATCH] vhost-user-fs: fix features handling
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Anton Kuchin <antonkuchin@yandex-team.ru>
Cc: virtio-fs@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org


--5X0H9MV3cTES+qvK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 08, 2021 at 10:55:34PM +0300, Anton Kuchin wrote:
> Make virtio-fs take into account server capabilities.
>=20
> Just returning requested features assumes they all of then are implemented
> by server and results in setting unsupported configuration if some of them
> are absent.
>=20
> Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
> ---
>  hw/virtio/vhost-user-fs.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
>=20
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index ac4fc34b36..6cf983ba0e 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -24,6 +24,14 @@
>  #include "monitor/monitor.h"
>  #include "sysemu/sysemu.h"
> =20
> +static const int user_feature_bits[] =3D {
> +    VIRTIO_F_VERSION_1,
> +    VIRTIO_RING_F_INDIRECT_DESC,
> +    VIRTIO_RING_F_EVENT_IDX,
> +    VIRTIO_F_NOTIFY_ON_EMPTY,
> +    VHOST_INVALID_FEATURE_BIT
> +};

Please add:

VIRTIO_F_RING_PACKED
VIRTIO_F_IOMMU_PLATFORM

QEMU's virtiofsd does not enable either of these for now, but it's worth
allowing the vhost-user device backend to participate in negotiation so
that this can change in the future (or alternative virtiofsd
implementations can support these features).

--5X0H9MV3cTES+qvK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmB1WpIACgkQnKSrs4Gr
c8i4Fgf+L+wCMhwPZ/BAkAceeQiKNByNCVMiTDWHiKe3BRsixlZVhtRmYdhxIoB2
3r7xK109cPr7/QSR++09l22mk2230tbUX0SYLhyAXKNrnNBI1QzBPp8PvFM5eMDU
KV8wnmdxNF5W0YILEri8KRXUIFlhescDkMQbnrjW/TDPChpzpCMf40o3BqJUiIK3
LFph7obLX15vR2mP5Zx6abU/aPTFZx9V9J9NwHP9EJyl89T0sSycWafmiySJQvDI
/Q52irxuvG5VuFcFiLzta79s4f/kaGqDu0kJq4/r4VnTA4LSjXvedEyz9oMeaOQK
VeDPlqkWMLyksah6xtObAREpfRMb2A==
=Qq8o
-----END PGP SIGNATURE-----

--5X0H9MV3cTES+qvK--

