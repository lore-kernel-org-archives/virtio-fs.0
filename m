Date: Wed, 14 Aug 2019 13:36:18 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190814123618.GA23970@stefanha-x1.localdomain>
References: <20190814022751.116741-1-tao.peng@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20190814022751.116741-1-tao.peng@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: simplify setup_remount_slave
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Peng Tao <tao.peng@linux.alibaba.com>
Cc: virtio-fs@redhat.com


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2019 at 10:27:51AM +0800, Peng Tao wrote:
> We can just use MS_REC to propagate MS_SLAVE. This would also allow us
> to close a race window between reading proc mountinfo and calling
> mount(MS_SLAVE) for each entry, vs. others umounting the mount point in
> parallel.
>=20
> Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> ---
>  contrib/virtiofsd/passthrough_ll.c | 53 ++----------------------------
>  1 file changed, 3 insertions(+), 50 deletions(-)

Let's try it!

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1UAEIACgkQnKSrs4Gr
c8hM2wf+MZgi62dyclyWrXJWpwMMPgDD3vYRYoDisO6LWgQbcCN+bokI9Ce658qw
jlUUezLiA5APVhGldaHDWKWh8Pv2ZhD3rt3ejo3gi1eKrFwq2mMRqfy4HLfdxDid
PNNLJcvDCAKHZ8UWNC7iUL3RCgB9UuHqPBfZFeMGpgAzvgfvgXYq73Eg98uppPMB
HuezSHT2tc0LtdvIILJZIUyFvWJZHctwWtgZiUpl4Gqa3/OhBdhqB1Zq9x/sLHSk
/oBGxbK68Z1JpAlWgOAXXYsSitCmtHLm6ar8YP8ALMyLGLB5lYZATy8VvpSR1ii0
o698MrMzc+u+oIEc8B0O/llZiqIEEA==
=2SA+
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--

