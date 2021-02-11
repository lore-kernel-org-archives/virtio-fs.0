Date: Thu, 11 Feb 2021 12:31:29 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210211123129.GJ247031@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-10-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="KjX7LgAomYr70Ka9"
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-10-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 09/24] DAX: virtiofsd Add cache accessor
	functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com, mst@redhat.com


--KjX7LgAomYr70Ka9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 07:02:09PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Add low level functions that the clients can use to map/unmap cache
> areas.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/fuse_lowlevel.h | 21 +++++++++++++++++++++
>  tools/virtiofsd/fuse_virtio.c   | 18 ++++++++++++++++++
>  2 files changed, 39 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--KjX7LgAomYr70Ka9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlI6EACgkQnKSrs4Gr
c8gEEAf/QJ6MsNwhLl8/dAj+EPw94oqY2LEmYM1rfozOHGV9EP0Qr74J3FcFOO1+
nubRH65g+mRTSJWBkaOyOsOjXJjoac2I9mPnopcu2R+VKgaPyWaCrlv2mgI8DWH5
4meEcVYGxSqiplD3gUULSJmSy3bH+sTLh7OTP1VRfkV0eGEKLwi8Zrn/U/Y/Q4sL
/FjiS6HRB3BXgCT3IW+Okvw2pYih2ieIkWlUyYwK9f9nRzFBU3EKRnRg2dMcP3Ja
0NM+h9iERReUJoAHRH5ujurxfkjsy2z3udP/dHrU7MiIuoUn0vqaNQlUu6qqJ5v2
9tATKto3vjRTBzBaWxXQpG2WZunTCA==
=zyGP
-----END PGP SIGNATURE-----

--KjX7LgAomYr70Ka9--

