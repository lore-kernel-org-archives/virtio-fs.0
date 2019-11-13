Date: Wed, 13 Nov 2019 14:40:18 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191113144018.GC554680@stefanha-x1.localdomain>
References: <20191030150719.29048-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UPT3ojh+0CqEDtpF"
Content-Disposition: inline
In-Reply-To: <20191030150719.29048-1-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/3] virtiofs: Small Cleanups for 5.5
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


--UPT3ojh+0CqEDtpF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2019 at 11:07:16AM -0400, Vivek Goyal wrote:
> Hi Miklos,
>=20
> Here are few small cleanups for virtiofs for 5.5. I had received some
> comments from Michael Tsirkin on original virtiofs patches and these
> cleanups are result of these comments.
>=20
> Thanks
> Vivek
>=20
> Vivek Goyal (3):
>   virtiofs: Use a common function to send forget
>   virtiofs: Do not send forget request "struct list_head" element
>   virtiofs: Use completions while waiting for queue to be drained
>=20
>  fs/fuse/virtio_fs.c | 204 ++++++++++++++++++++++----------------------
>  1 file changed, 103 insertions(+), 101 deletions(-)
>=20
> --=20
> 2.20.1
>=20

There are typos in the commit descriptions but the code looks fine:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--UPT3ojh+0CqEDtpF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3MFdIACgkQnKSrs4Gr
c8gz9gf8C1ie4Xi0WRMLEPRPpIjZue0W+WRJNTMJheJ+0d2dyTylZl1EOFrRI9Mz
tlQtH/MUeJ999e1bX14gngArSdq5yrBMmk2OVngHa9CoPJlJ7CAT8R0uJFa0ca1X
6QWdtDLTlcyKJGGl75bFqwT32R/iReCoQuzXRdO0h/tKPykm6NDDFhJJPtDeO4GM
F+4C+1faPh0nMUp7lSGwIAJ4pgKYGc3URDSJpHj8X0mouYDBnoHtVErX6dMnxyw2
jKGthgQDd2Ynx7NYecWmD+qfSMiBa7JUWgFpAreyVxnzONAKKUqAxmVShzdRdNm8
zBAVkR0zFJEJljlOj9jfknJxGlecIg==
=traL
-----END PGP SIGNATURE-----

--UPT3ojh+0CqEDtpF--

