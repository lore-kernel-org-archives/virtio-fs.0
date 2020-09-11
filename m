Date: Fri, 11 Sep 2020 11:28:14 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200911102814.GH94280@stefanha-x1.localdomain>
References: <20200909184603.263700-1-mreitz@redhat.com>
	<20200909184603.263700-7-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BXr400anF0jyguTS"
Content-Disposition: inline
In-Reply-To: <20200909184603.263700-7-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 6/9] fuse: Drop fuse_conn parameter where
	possible
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


--BXr400anF0jyguTS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 09, 2020 at 08:46:00PM +0200, Max Reitz wrote:
> With the last commit, all functions that handle some existing fuse_req
> no longer need to be given the associated fuse_conn, because they can
> get it from the fuse_req object.
>=20
> Signed-off-by: Max Reitz <mreitz@redhat.com>
> ---
>  fs/fuse/fuse_i.h    |  2 +-
>  fs/fuse/dev.c       | 70 +++++++++++++++++++++++++--------------------
>  fs/fuse/virtio_fs.c |  8 ++----
>  3 files changed, 43 insertions(+), 37 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--BXr400anF0jyguTS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9bUT4ACgkQnKSrs4Gr
c8jzcQf/SY2AhnFNwrtV8nji70703wHgzjWZ9b1tgyT3AR7CDy2WZwgOFHp5P0tD
D3TQxwP8pQv6CywYQ/j5z+B0GxNzjpii4vr+5zASi8s7Y/opox1JTjDb5gpYMpRY
2SJm7ak+r3eNCpGXqxvgqca3ikinq+xjNvJYK14f/aXCT4WGoKEFj3+Y5WVcIQCP
MMJz5RePqbNPCbX0FI76bCJyHIAnk87v9EcL8+HiYRpsVUavXtpH+9REqPvPtEsz
N1SzHkzCH1oMb5d8vgeYt7sz+/lY/UAm5jyCcf8LK+7SnmIEb1w3X9cg0PRzGdgL
QMwB/0woGbmuzPFJJp0cnwSobwPszg==
=vZAc
-----END PGP SIGNATURE-----

--BXr400anF0jyguTS--

