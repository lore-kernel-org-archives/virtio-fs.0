Date: Fri, 6 Sep 2019 11:46:29 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906104629.GM5900@stefanha-x1.localdomain>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<20190905194859.16219-6-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6Mt39TZj+HFMr11E"
Content-Disposition: inline
In-Reply-To: <20190905194859.16219-6-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 05/18] Maintain count of in flight requests
 for VQ_REQUEST queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, mst@redhat.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org


--6Mt39TZj+HFMr11E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2019 at 03:48:46PM -0400, Vivek Goyal wrote:
> As of now we maintain this count only for VQ_HIPRIO. Maintain it for
> VQ_REQUEST as well so that later it can be used to drain VQ_REQUEST
> queue.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/virtio_fs.c | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--6Mt39TZj+HFMr11E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1yOQUACgkQnKSrs4Gr
c8i06Qf/YsXsjq8+oavPjTWaNCzD+gEcjd+8mynWoVujlBAz0pFZFRAmIlq1Jfkx
a0SLeeftv9+xKQOx0U4hGY3m9qOVGA2f6fA+9vTrrJijt3O0QoY5wXN+0n0K0Qae
ewLQnKeKi12oPmQxy2xCjUT8MIW8xS+nx9PE14LN58+SmoyDx/FbWieHqtzAkKDy
ykr8KKp4NHWq/+ybm5n5ht0i++jvbtNk+Do4CXPes4Z0YrK1eH3Jqnlrcsx3TuT/
puv1rBv/9hUQYO/ub4McGshjdSxNlL+BuW0e6LczHlAK2kyFtV0dLbZVJJYdGeC5
mf6GHYgWCJo1e7tdyqx428bbty/Jhw==
=h20v
-----END PGP SIGNATURE-----

--6Mt39TZj+HFMr11E--

