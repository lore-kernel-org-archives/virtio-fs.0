Date: Mon, 14 Feb 2022 11:12:58 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <Ygo5Ouzpvg0Jdvvo@stefanha-x1.localdomain>
References: <20220210174714.19843-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hzr9mwc4r5yZwhgQ"
Content-Disposition: inline
In-Reply-To: <20220210174714.19843-1-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2] Deprecate C virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, berrange@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--hzr9mwc4r5yZwhgQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 10, 2022 at 05:47:14PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> There's a nice new Rust implementation out there; recommend people
> do new work on that.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  docs/about/deprecated.rst | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

Thanks, applied to my block tree:
https://gitlab.com/stefanha/qemu/commits/block

Stefan

--hzr9mwc4r5yZwhgQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmIKOToACgkQnKSrs4Gr
c8hX5Af/RDI3Rqj6L5eyb+Ks56++lhhcC1yy85mDGrcy6ETmoDhFD74j3ElfYEY5
jc48AY9P9qX+N56RAaAuK9nOreJZBJxYuSsfffs/1IhVPRvY030Fq1i3yG0ZOMMo
5WXVmui8NwZROQ3beLzQYjkxklrGQVnkSGeycjNad8WZVtuzkq8taNBuIDj8r/Wn
UowjkBOEchcMqg8qtoL3Il5cwgl4d9G73Ly2U/uMOdjxAAuagBexa3/tKx8Kftbt
2WFfWuYBh0imPhOfk6gcZmhSBgRfvzogabZ7A0vGdTyM95AoXWNPY8/1mdQvTJbB
9IEbvPQ7J48BTpCRJcr1OvdDSa7Xpg==
=xAso
-----END PGP SIGNATURE-----

--hzr9mwc4r5yZwhgQ--

