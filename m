Date: Fri, 26 Jun 2020 11:31:22 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200626103122.GF281902@stefanha-x1.localdomain>
References: <20200625162929.46672-1-dgilbert@redhat.com>
	<20200625162929.46672-2-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dgjlcl3Tl+kb3YDk"
Content-Disposition: inline
In-Reply-To: <20200625162929.46672-2-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/3] virtiofsd: Terminate capability list
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--dgjlcl3Tl+kb3YDk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2020 at 05:29:27PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> capng_updatev is a varargs function that needs a -1 to terminate it,
> but it was missing.
>=20
> In practice what seems to have been happening is that it's added the
> capabilities we asked for, then runs into junk on the stack, so if
> we're unlucky it might be adding some more, but in reality it's
> failing - but after adding the capabilities we asked for.
>=20
> Fixes: a59feb483b8 ("virtiofsd: only retain file system capabilities")
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--dgjlcl3Tl+kb3YDk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl71znoACgkQnKSrs4Gr
c8hFwgf+KpmNHkGjRfZRdBpqgYqmm6P8GwGbZQHUIRJWvgwrKVZy1QG68IYMD34P
o8/LC4nbhjNFD+zHNdiPDZlSY3x32OgmifFJN5wvcJZdL4+UMoqULFusgv2ORZ8j
76qnUsJpFX/VZu3tM8l5S/ABByMvJc0fVRIRwMME3u5M9F3us7vjgBzSTGS3I0b9
hEIO7VTSgaxfxX7dlzli7iNhVxKH9wpIcP3jzT4IpxHnABay8XpG8KJPHmZ8Epy6
pfhKkkXHiHe8ijVH6haSMy43QYqWAAp1p5/WtklfttXqbAxXvIdeWXMckCBgoZ14
VkRbGmuJpZS7/yM1hDtmoQZpv+woLg==
=U6FJ
-----END PGP SIGNATURE-----

--dgjlcl3Tl+kb3YDk--

