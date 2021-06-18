Date: Fri, 18 Jun 2021 19:03:27 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YMzf72yCJqnDTYYo@stefanha-x1.localdomain>
References: <20210617153649.1886693-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BJ2t6DUwu2C54aee"
Content-Disposition: inline
In-Reply-To: <20210617153649.1886693-1-hch@lst.de>
Subject: Re: [Virtio-fs] support booting of arbitrary non-blockdevice file
 systems
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org


--BJ2t6DUwu2C54aee
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 17, 2021 at 05:36:47PM +0200, Christoph Hellwig wrote:
> this series adds support to boot off arbitrary non-blockdevice root file
> systems, based off an earlier patch from Vivek.

Cool, thanks for working on generic syntax for mounting non-blockdevice
file systems. Looks good modulo the comments Vivek had.

Stefan

--BJ2t6DUwu2C54aee
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDM3+8ACgkQnKSrs4Gr
c8iYRQf7BnTsXpltlcUc1ZB0ZEVw8116KM4IDmMLTrZI2+DB6dQUUDoVFGhDQ8Js
8H+kO2B6gCyRK1kem+d6JF0B9YkWkGmot4c0LljqJs55aAmRRFNFqga3fuGu7/h8
amS/Hm+QKgmCLIj+U/+nLkUqbxI/vSdmGMLOVgHC05Qw6m/3IRlJlXKjss2jOIzP
NhaVbWL1WIaDjpgLFFZunGqNQ0jLN7o3SRUhtiJPwZ/9xXJcGem9X7/cFZQ12/Nd
qP1ATC/vjVnwIZoHFjgn4O0wk3bv8zUMBLZqnnT9PYC5IbAW9oX8LWEine+T58X0
yQNil38SKTfuWw2ZIRdiX2W7CfuZ3w==
=zBxt
-----END PGP SIGNATURE-----

--BJ2t6DUwu2C54aee--

