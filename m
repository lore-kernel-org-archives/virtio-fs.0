Date: Thu, 6 May 2021 16:27:31 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJQK48vo1EucwKmv@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-22-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2+pT4L74SHCe/uvb"
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-22-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 21/26] DAX/unmap virtiofsd: Route
	unmappable reads
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--2+pT4L74SHCe/uvb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 12:00:55PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> When a read with unmappable buffers is found, map it to a slave
> read command.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 37 +++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--2+pT4L74SHCe/uvb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCUCuIACgkQnKSrs4Gr
c8i71wf/a0OogYntbO594T7tHNcLkE9cM9p8i84faW9ptsTYFJzmvIwlqdjsgSKu
O9PQZbWptaORHUjcYAOAXtPNMd/6fK8AmBiDQfAB/EwGIUl4d1Qn/iNc3xT/Hr2j
gU2+FzBgYNxN9xAEMh9GYXQG7LuiyAcm40eWNfpYgSHIffGLp/las/XGNtoqfmjG
CDuR/XuQNXnfZ7SEPlKGX+lxTah7QPms/DTEETEPqDX1vwho5xwpZVk1s9FVJG4N
o5LatVuwpRqCRTG0sssY+F2gD4tQFa+lVPGX2qARYMt4Y0DkMWd/wUi5gvkj5+wo
W9f7kMowGZBLJ1rarf68JeMOHG0/Aw==
=cJto
-----END PGP SIGNATURE-----

--2+pT4L74SHCe/uvb--

