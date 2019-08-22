Date: Thu, 22 Aug 2019 14:15:11 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190822131511.GI20491@stefanha-x1.localdomain>
References: <20190820183746.GF4233@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="CNK/L7dwKXQ4Ub8J"
Content-Disposition: inline
In-Reply-To: <20190820183746.GF4233@redhat.com>
Subject: Re: [Virtio-fs] [PATCH V2] virtiofsd: Reset O_DIRECT flag during
 file open
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>


--CNK/L7dwKXQ4Ub8J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 20, 2019 at 02:37:46PM -0400, Vivek Goyal wrote:
> If an application wants to do direct IO and opens a file with O_DIRECT
> in guest, that does not necessarily mean that we need to bypass page
> cache on host as well. So reset this flag on host.
>=20
> If somebody needs to bypass page cache on host as well (and it is safe to
> do so), we can add a knob in daemon later to control this behavior.
>=20
> I check virtio-9p and they do reset O_DIRECT flag.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  contrib/virtiofsd/passthrough_ll.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)

virtio-fs should work even if the host file system doesn't support
O_DIRECT:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--CNK/L7dwKXQ4Ub8J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1elV8ACgkQnKSrs4Gr
c8isrwf/efMrVxoP6GsS/K0v/jIDiyGEJ7plq1841lyys3/olbzVR6e8brjPXPkq
nuhJWOforrl0QeN+g0dmCatIZZL/cIja8RM53oh2zb750m2ovgdg54ndd2ZMtmwr
E404K2QUr2ePeJ6vx4C+T4xk+qdkGfKikEizXQOEPHTgLUz+qiGj6ueaYWTLFQpZ
cryp90jcWSCGwZgEfsd1BhDtGn4fWAGWjJDb5XCJVVk4joeJ8u+NQlsHOnXisC3U
GN9Qn6hjVoRDIg0Svrec3CN/ZlMknwBjhF/exHXIMFoowMANQkwpkBy+zLAuhSWn
+g0WdMaROi+q2L96j1T+ouZbw6aH0Q==
=xi9s
-----END PGP SIGNATURE-----

--CNK/L7dwKXQ4Ub8J--

