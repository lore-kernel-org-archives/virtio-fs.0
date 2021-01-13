Date: Wed, 13 Jan 2021 10:36:29 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210113103629.GF250553@stefanha-x1.localdomain>
References: <20210112131603.12686-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="7cm2iqirTL37Ot+N"
Content-Disposition: inline
In-Reply-To: <20210112131603.12686-1-lersek@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2] vhost-user-fs: add the "bootindex"
	property
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Laszlo Ersek <lersek@redhat.com>
Cc: virtio-fs@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>, qemu devel list <qemu-devel@nongnu.org>


--7cm2iqirTL37Ot+N
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 12, 2021 at 02:16:03PM +0100, Laszlo Ersek wrote:
> virtio-fs qualifies as a bootable device minimally under OVMF, but
> currently the necessary "bootindex" property is missing. Add the property.
>=20
> Expose the property only in the PCI device, for now. There is no boot
> support for virtiofs on s390x (ccw) for the time being [1] [2], so leave
> the CCW device unchanged. Add the property to the base device still,
> because adding the alias to the CCW device later will be easier this way
> [3].
>=20
> [1] https://lists.gnu.org/archive/html/qemu-devel/2021-01/msg01745.html
> [2] https://lists.gnu.org/archive/html/qemu-devel/2021-01/msg01870.html
> [3] https://lists.gnu.org/archive/html/qemu-devel/2021-01/msg01751.html
>=20
> Example OpenFirmware device path for the "vhost-user-fs-pci" device in the
> "bootorder" fw_cfg file:
>=20
>   /pci@i0cf8/pci-bridge@1,6/pci1af4,105a@0/filesystem@0
>=20
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: J=E1n Tomko <jtomko@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: virtio-fs@redhat.com
> Signed-off-by: Laszlo Ersek <lersek@redhat.com>
> Acked-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>=20
> Notes:
>     v2:
>     - drop "hw/s390x/vhost-user-fs-ccw.c" hunk [Christian, Cornelia]
>    =20
>     - document the same in the commit message
>    =20
>     - remove fw_cfg kernel boot reference from the commit message (somewh=
at
>       similar use case, but a comparison or even a hint doesn't necessari=
ly
>       belong in the commit message)
>    =20
>     - pick up Dave's ACK
>=20
>  include/hw/virtio/vhost-user-fs.h |  1 +
>  hw/virtio/vhost-user-fs-pci.c     |  2 ++
>  hw/virtio/vhost-user-fs.c         | 10 ++++++++++
>  3 files changed, 13 insertions(+)

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

--7cm2iqirTL37Ot+N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/+zS0ACgkQnKSrs4Gr
c8gS9wf/TRog/kNVH/gkx/ciVGAZlq+1sMNKxVZI9R4Kv0HL3y6WZxkdTtZGZgwO
RErK34NA2jYHZllUGjqlxeByruJBrg9/yuM8FEeMy8rPHstHy8kflbC4L9nYRiJE
aF7G4nD7VsbkIoPtKV91qV38bZYoS6BWMd2DwVn4JBO+bkKsek3AQ2ZR5vlohoTB
IMRcpV3hqJvEySVJKZc1O28yKGPamfWcTS1/UPPi7kALWXCesLd8eCYU6h6Td3qE
ZS/yoX2TurpuLK62+jKsTOQBigXSuWtgiY9BUMLJtAk7BRyMwOTZNGdi9wDP/PQx
YxkHwsGykJ3MQ5GkX+7nUMqZ3SDOMg==
=EAQQ
-----END PGP SIGNATURE-----

--7cm2iqirTL37Ot+N--

