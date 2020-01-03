Date: Fri, 3 Jan 2020 15:23:50 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200103152350.GG277936@stefanha-x1.localdomain>
References: <20200102035312.18507-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uc35eWnScqDcQrv5"
Content-Disposition: inline
In-Reply-To: <20200102035312.18507-1-yangx.jy@cn.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd/passthrough_ll: Pass errno to
 fuse_reply_err()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc: virtio-fs@redhat.com


--uc35eWnScqDcQrv5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 02, 2020 at 11:53:12AM +0800, Xiao Yang wrote:
> lo_copy_file_range() passes -errno to fuse_reply_err() and then fuse_repl=
y_err()
> changes it to errno again, so that subsequent fuse_send_reply_iov_nofree(=
) catches
> the wrong errno.(i.e. reports "fuse: bad error value: ...").
>=20
> Make fuse_send_reply_iov_nofree() accept the correct -errno by passing er=
rno
> directly in lo_copy_file_range().
>=20
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--uc35eWnScqDcQrv5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl4PXIYACgkQnKSrs4Gr
c8gt0wf/bpLV4PvzuNn48XH+60PPMDyRwaXcdNE2hRdsOGmvyO0DbT0sZqtWazlH
jvGfEAH2e4sCkBq1x9z6K89OczzjBFA+cTlsO+qHQCSGQCyQqZZO0IFNYzHvsDb/
Z3dg1VBODjfbDQgWJu8JcAun4+h30CiCEmW9Ii7jzHH5HYcwTUeFRbKPEqJRVfGr
5L8ROiYa4UFEgDNdvFt/sy8rj7rj3RyVxnMXuvYz1O35tuBXyMrwjc89hEZ4cZ2Z
aYXoxRQyXhYo/zcOgDDVtP4gXhzYw2uTzuX8e1gJ62DbCTVQppe7mtrGoIvuyCIL
5xnnxxTyi0wbTYWQ8k+AhASglgRDPQ==
=Ujog
-----END PGP SIGNATURE-----

--uc35eWnScqDcQrv5--

