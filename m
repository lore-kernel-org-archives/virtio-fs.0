Date: Tue, 4 May 2021 16:12:36 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJFkZA4O+KT4nunq@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-3-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="+gHic+xH234Qie+K"
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-3-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 02/26] virtiofsd: Don't assume header
	layout
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


--+gHic+xH234Qie+K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 12:00:36PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> virtiofsd incorrectly assumed a fixed set of header layout in the virt
> queue; assuming that the fuse and write headers were conveniently
> separated from the data;  the spec doesn't allow us to take that
> convenience, so fix it up to deal with it the hard way.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 94 +++++++++++++++++++++++++++--------
>  1 file changed, 73 insertions(+), 21 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--+gHic+xH234Qie+K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCRZGMACgkQnKSrs4Gr
c8gANggAk+5DPo3kDQ9APbrx5HDtEJmdmbvgOH/NNIN6XRhmKOMpz0XOk+K/6+y7
sdJPPsRatzXtl5PfxE5i4/bblNlcvFAD6hKU2ZGuJvMD73s66oQ2Vs+zr83K7cr4
W209oPi2tZb7h8LUNy5CAi5JUtj1h62ey0oVBCZ/KSC80zH9G3iHU8v07jkILvdN
hspYfdZHE61iNZwOUeucxoeEaoLuAWRoElb41YZ1zoXK0o/sW0GYZfKofoBGAn60
6mJGrKQPWVkSMT+3KWHwo3bqleq/cS3ds6wCP8CPR0TrNeVWHhjX7pj3CJjq3oh9
oLFIdjhyN0Hb5X9+AY/xrMVdnx02yw==
=HQRB
-----END PGP SIGNATURE-----

--+gHic+xH234Qie+K--

