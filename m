Date: Wed, 24 Feb 2021 12:25:48 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YDZFzGSkzlNC2xz+@stefanha-x1.localdomain>
References: <20210223225250.23945-1-vgoyal@redhat.com>
	<20210223225250.23945-2-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="LQ1RUayJWBLhbxyk"
Content-Disposition: inline
In-Reply-To: <20210223225250.23945-2-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 1/2] virtiofsd: Add umask to seccom allow
	list
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, miklos@szeredi.hu, qemu-devel@nongnu.org


--LQ1RUayJWBLhbxyk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 23, 2021 at 05:52:49PM -0500, Vivek Goyal wrote:
> Patches in this series  are going to make use of "umask" syscall.
> So allow it.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/passthrough_seccomp.c | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--LQ1RUayJWBLhbxyk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmA2RcwACgkQnKSrs4Gr
c8j5bwf9GOjSn9zhlXu6g9boOZzii6dzYutZpyVLXbqc0XFLZv4nXb0T/eA0ZhlL
B//PSDpkBD/lrk6kQJz9UcIUw2LYvC3GGFVye1Ys80WFcVGate4k/j3H6Se9PPhf
dqkPDKcfP+HkKpzb1pbCUPj1XUGLVh8iTbDWQCZQTbsfMQw+jnLLvaejTUPWAgPK
IE4QLhD8RcZW/b4wso9Q2jGNqZ8KJ1/O3P4LRTstVFF6Tfr3/IuS8hwG4oLfc4SQ
QrsYAUYumdYFXT2lf+nNMa25HHftByZ3xPMwzLL3LzFgu+8qnhI09OexJPiU5ifH
WZInBHD4fbse40hRCCJqfIFTVj/i5A==
=AaQM
-----END PGP SIGNATURE-----

--LQ1RUayJWBLhbxyk--

