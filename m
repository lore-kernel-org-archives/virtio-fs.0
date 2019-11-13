Date: Wed, 13 Nov 2019 14:30:09 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191113143009.GA554680@stefanha-x1.localdomain>
References: <20191030150719.29048-1-vgoyal@redhat.com>
	<20191030150719.29048-3-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20191030150719.29048-3-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/3] virtiofs: Do not send forget request
 "struct list_head" element
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 30, 2019 at 11:07:18AM -0400, Vivek Goyal wrote:
> We are sending whole of virtio_fs_foreget struct to the other end over

s/foreget/forget/

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3ME3EACgkQnKSrs4Gr
c8hq0Af/Y6T9m3AkYVL7WhS7dEeOaSsP/EYzLga/CaHn7C6d180GQxMyYGpCcf0D
UQwdoH+qnfkDEwUOrF2VkJGMkpHERcoKAJhq9o5sUZgHtLx01mCt4T5nQYbCpbar
DtLxySRfhqeya6Zf2kkRtpz28Th4PHK7k2qT/v3bKxIxM6PiSv3gDO0TFbdRAflr
gRlpFE59+jlOv8zFbGpgVqklwqNEYYG3BO0NM+yYgpsxUXm68rFktSceJTCRLZsQ
RJW6hIqEsBh8o4ewE2WIafyqHNKU1TWJLDlwWQrDmv9+jokNzB1LTKOac1AqlwH6
6+Q7/AHk8zVeY6A6O1ApBtgabXPA6w==
=OR0s
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--

