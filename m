Date: Fri, 11 Sep 2020 11:24:59 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200911102459.GC94280@stefanha-x1.localdomain>
References: <20200909184603.263700-1-mreitz@redhat.com>
	<20200909184603.263700-3-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
Content-Disposition: inline
In-Reply-To: <20200909184603.263700-3-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/9] fuse: Add FUSE_ATTR_SUBMOUNT
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, fuse-devel@lists.sourceforge.net


--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 09, 2020 at 08:45:56PM +0200, Max Reitz wrote:
> This is a flag for fuse_attr.flags that indicates that the given entry
> resides on a different filesystem than the parent, and as such should
> have a different st_dev.
>=20
> Signed-off-by: Max Reitz <mreitz@redhat.com>
> ---
>  include/uapi/linux/fuse.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index de94c11cfc3b..c034cdf8f5f4 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -417,6 +417,13 @@ struct fuse_file_lock {
>   */
>  #define FUSE_FSYNC_FDATASYNC	(1 << 0)
> =20
> +/**
> + * fuse_attr flags
> + *
> + * FUSE_ATTR_SUBMOUNT: File/directory is a submount point
> + */
> +#define FUSE_ATTR_SUBMOUNT      (1 << 0)

If you respin, please add a little more detail here. How should clients
act when this flag is detected (which FUSE messages should they send to
deal with submounts)?

Stefan

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9bUHsACgkQnKSrs4Gr
c8gBEgf/Z3qGasBYElC+o/qnMxwrsI7PFQNQDGdxig7rONkYZtlYKbNWoXuQNMMZ
w1oxpKBoTgFVQ6s/YJDcLqfvtz5qJTMr8b9ttm6M+yvbF+l59GHDwKR4YsDTaRKQ
tqqWfk0tWcqx/D9WWnf+5Zk0ZjiIsU8P5aOJbXvuGbEMEHJcN6CKaVaFz2+sKwKM
eM8pWlmm23Ori1Mb+rExRtCxlMEsyARjajPNAtbapaTchrqz5tnBH1KO6/VKz/mX
jBd/zmJSjYb8+rhnJOn9Fyha7eS11f84Iqz92aiDHY7Om/8ddBAlALi3vossOZRt
8WWxOVYW91YRawuKYJZoXEN1CZBPYw==
=YeRu
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--

