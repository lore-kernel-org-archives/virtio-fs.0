Date: Fri, 21 Feb 2020 08:54:14 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200221085414.GA1343391@stefanha-x1.localdomain>
References: <20200221065515.4476-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20200221065515.4476-1-yangx.jy@cn.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Remove fuse.h and struct
 fuse_module
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2020 at 02:55:15PM +0800, Xiao Yang wrote:
> All code in fuse.h and struct fuse_module are not used by virtiofsd
> so removing them is safe.
>=20
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> ---
>  tools/virtiofsd/fuse.h   | 1229 --------------------------------------
>  tools/virtiofsd/fuse_i.h |   16 -
>  2 files changed, 1245 deletions(-)
>  delete mode 100644 tools/virtiofsd/fuse.h

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5PmrYACgkQnKSrs4Gr
c8hjUggAkDZGxDRsI4z+OF1ZBao/rNDi8RxJE7Kh4+S/4yL0I4ZzhK/0c3L87dOY
ywQ8hnA9ryuzt0Rhh0MaxOUm6seiV8WgBSy6ZwEjqKSP/cSgLqZzi0CiORs4UdGh
7e4pqb8gyPWzLC1Kem7X2/b/xeYw3bb0AjCNqTgyuMAScamY0BOsaNMVA0zahnq3
LJ0171CBZ0yTVmZOn8QnffqZQJQzOMxNFyLtd9ZvA6udj0xJfGvfr3sEENFmrpNB
d7HlEomOz4Rqey+JMCAQUvo5WNSveXiR70LhyqI4oyJpf/SJW07z4R8wqcqAgIQD
xwfVhncf6QTLAAvqEbkdeXSdjbC6MQ==
=WXyA
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--

