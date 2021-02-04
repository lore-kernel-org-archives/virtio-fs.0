Date: Thu, 4 Feb 2021 09:37:20 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210204093720.GA344659@stefanha-x1.localdomain>
References: <20210203182434.93870-1-groug@kaod.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <20210203182434.93870-1-groug@kaod.org>
Subject: Re: [Virtio-fs] [PATCH v2] virtiofsd: vu_dispatch locking should
	never fail
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 03, 2021 at 07:24:34PM +0100, Greg Kurz wrote:
> pthread_rwlock_rdlock() and pthread_rwlock_wrlock() can fail if a
> deadlock condition is detected or the current thread already owns
> the lock. They can also fail, like pthread_rwlock_unlock(), if the
> mutex wasn't properly initialized. None of these are ever expected
> to happen with fv_VuDev::vu_dispatch_rwlock.
>=20
> Some users already check the return value and assert, some others
> don't. Introduce rdlock/wrlock/unlock wrappers that just do the
> former and use them everywhere for improved consistency and
> robustness.
>=20
> This is just cleanup. It doesn't fix any actual issue.
>=20
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>=20
> v2: - open-code helpers instead of defining them with a macro (Vivek, Ste=
fan)
>     - fixed rd/wr typo in fv_queue_thread() (Stefan)
>     - make it clear in the changelog this is just cleanup (Stefan)
>=20
>  tools/virtiofsd/fuse_virtio.c | 49 +++++++++++++++++++++++++----------
>  1 file changed, 35 insertions(+), 14 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAbwFAACgkQnKSrs4Gr
c8gbjAf9GblB8eefDQi5Z4Mw1lenpQ0Ymi0VLwcAAfpMn5X3wNFDIe6lb49XsGHO
XQSql+SWtVSwDtmS8b7WAX164atl3z647Ga/OJ+6Q7Ptj+fmNjrFe2qUXiNQlNnz
uczXb4KVljuV/0Kal3YAVUkMDSFxWfUnU3swaL9GkTK+AIWv3+1XjcZBZlzGR1sw
5fdbEa1a2xqAJoncnKXs3OPqDmjkdXHbXMtLWmV1jPJCEAHShk6Xk8iKasC0izdT
dYJkL3a2Sec7eOcgwIjdY3iZ6DaOavDqU1ONZoeIRb0sObAnQ9GQGp6P8HrX8BcQ
pRn5XV/SbgY9GXtvqRgxAJpE/4Pakw==
=Uj6s
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--

