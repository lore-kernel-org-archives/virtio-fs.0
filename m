Date: Tue, 16 Nov 2021 11:13:17 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YZOSTYBUde8hz2OW@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<2186445.RDNOEBgitd@silver>
	<YZJKeNOxcm3ZxHj6@stefanha-x1.localdomain>
	<2888852.ZcFpDoVWxJ@silver>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nTmdJO8CHBrmpor9"
Content-Disposition: inline
In-Reply-To: <2888852.ZcFpDoVWxJ@silver>
Subject: Re: [Virtio-fs] [PATCH v2 0/3] virtio: increase VIRTQUEUE_MAX_SIZE
	to 32k
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christian Schoenebeck <qemu_oss@crudebyte.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Amit Shah <amit@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, Raphael Norwitz <raphael.norwitz@nutanix.com>


--nTmdJO8CHBrmpor9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 15, 2021 at 03:32:46PM +0100, Christian Schoenebeck wrote:
> I would appreciate if you'd let me know whether I should suggest the disc=
ussed=20
> two virtio capabilities as official virtio ones, or whether I should dire=
ctly=20
> go for 9p device specific ones instead.

Please propose changes for increasing the maximum descriptor chain
length in the common virtqueue section of the spec.

Stefan

--nTmdJO8CHBrmpor9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmGTkk0ACgkQnKSrs4Gr
c8g8dwf+NKjImrISNDFd0MQBdcOG6HbhAqP0j+Hs0u+aeU0LOf8nAvW1ZapOaenF
xFlKRSsVnQh8OfXiCyQpnnXm+L9vaCiMVE/BJ2aqBtvgqsnWh7LJIzTXvCl7E+37
daJ+NnYnSL19Z7CYIgp5Jj5SLDNMuc5YeV9MizvkQjrqugRQUtgwNNH4JpKksW4V
a1q+u66jcX3J+t+VEeluJ2DpqEX7EYg7oJoOuVq2rsGZ4qCHNwUc8J+fOH6tcWKT
fOHWj4EV4MPXuutJ62aH5wM0ppnIePOBaYfnBeebL359/5G/ZAOqw7rAfsqIp3Q0
tSpSm29hftrbWKH7bDTIFHX4BQMDcw==
=JRXa
-----END PGP SIGNATURE-----

--nTmdJO8CHBrmpor9--

