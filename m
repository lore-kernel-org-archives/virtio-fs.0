Date: Fri, 13 Dec 2019 11:02:24 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191213110224.GE1180977@stefanha-x1.localdomain>
References: <OFEFF035BA.8C1142AF-ON002584CE.006405E7-852584CE.0067F3AB@notes.na.collabserv.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="d8Lz2Tf5e5STOWUP"
Content-Disposition: inline
In-Reply-To: <OFEFF035BA.8C1142AF-ON002584CE.006405E7-852584CE.0067F3AB@notes.na.collabserv.com>
Subject: Re: [Virtio-fs] virtio-fs on zLinux (s390x)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Gong Su <gongsu@us.ibm.com>
Cc: virtio-fs@redhat.com, Cornelia Huck <cohuck@redhat.com>


--d8Lz2Tf5e5STOWUP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 12, 2019 at 01:55:25PM -0500, Gong Su wrote:
> Basically, I'm trying to see if I can get virtio-fs to work on zLinux.
> Following the instructions on https://virtio-fs.gitlab.io/howto-qemu.html I
> was able to compile all the pieces but when I tried to run qemu I realized
> that it needs -numa option which isn't supported on s390x yet.

Does s390 support vhost-user?

virtio-fs is implemented as a vhost-user device so this is a
requirement.  Shared memory is a vhost-user requirement and that's where
the -numa command-line option dependency comes from.

Stefan

--d8Lz2Tf5e5STOWUP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3zb78ACgkQnKSrs4Gr
c8g0nggAmvXk0jPn9JcFsHalABGSOnotu1kCrJxIcOTtTtn1IE6HidIT/DpZTXWY
x5bt9RuM1V4RcYA49/61Nc6otUgvEc1p5bJ3qRJhkzOpMc7NmXoYhDa3hqOoHtBt
DwdwpA0GeafPHB/gLgDfY75tsZG16QgJWXw75zZqBjScfXo9OnXD2bNxISJIqw4z
Va8i7Zlv/aZZE4KuwXYy3TUCSOQlREKvcNc2fOhs6ki26s2T1nEz507FjfY71G0T
c0yk6rGBBPC5fpJSAJRAv6je1dR6crg4ACB8/m2YQYIDpNs/YxMm3zpGEDX/lfqd
O5UAW7xTlZ2o1xCmUocbDDH3Eu/7YQ==
=F1WA
-----END PGP SIGNATURE-----

--d8Lz2Tf5e5STOWUP--

