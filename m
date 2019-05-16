Date: Thu, 16 May 2019 15:26:50 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190516142650.GA28760@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
Subject: [Virtio-fs] virtiofsd security guide available for review
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: kata-dev@lists.katacontainers.io, virtio-fs@redhat.com


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
A security guide for virtiofsd is now under review here:

  https://gitlab.com/virtio-fs/qemu/merge_requests/6/diffs?commit_id=718c71fa44f6b92ac27558c903d27935236b08ef

Comments welcome!  I hope this will be useful to the Kata Containers
community and early adopters of virtio-fs.

We will continue to enhance the sandboxing capabilities in virtiofsd to
protect against guest escapes.

Stefan

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlzdcyoACgkQnKSrs4Gr
c8hO0AgAqtS2gipeYSZ7opkyBhRw6rvvbiIhbY2Jy9qkkafWlNQlOX3rv82dt8NH
MI/xYVknpM5frmuyxgXyzlrA9iWWDv1Bx7UmfgzM05v0PlD5eJIMfvczlw707l16
RNnpLxkalFjOYHJe4fV7DSq3iB5i9+2hxOZyl/e1IVWtNe+87IcEyIygu2skFYv/
32EJ0R+vtAqZ0B/UZNiedTIjq7qEAVu4XeDhLxVXxxy3ebwp7WIddWVTzI0BAG2s
6Yf+TYgJfek6Q9Envojxb/8OJEK1GYlkNNPNBsfQzNIw1ft21VEZpAMooWKvgC6M
zBdpWSdQsfj506KgAtJBDjqZfKKF7g==
=nr+4
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--

