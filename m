Date: Tue, 28 Apr 2020 15:59:40 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200428145940.GC107541@stefanha-x1.localdomain>
References: <20200427180354.GD146096@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
Content-Disposition: inline
In-Reply-To: <20200427180354.GD146096@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] fuse,
 virtiofs: Do not alloc/install fuse device in
 fuse_fill_super_common()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>


--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2020 at 02:03:54PM -0400, Vivek Goyal wrote:
> As of now fuse_fill_super_common() allocates and installs one fuse device.
> Filesystems like virtiofs can have more than one filesystem queues and
> can have one fuse device per queue. Given, fuse_fill_super_common() only
> handles one device, virtiofs allocates and installes fuse devices for
> all queues except one.
>=20
> This makes logic little twisted and hard to understand. It probably
> is better to not do any device allocation/installation in
> fuse_fill_super_common() and let caller take care of it instead.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/fuse_i.h    |  3 ---
>  fs/fuse/inode.c     | 19 ++++++++++++-------
>  fs/fuse/virtio_fs.c |  9 +--------
>  3 files changed, 13 insertions(+), 18 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6oRNwACgkQnKSrs4Gr
c8jeIgf/UuU/ixsyG5uelRBuxqqN9HbXJ6wwScvS222NvMKxWlFHWR8FgP28UGrV
ltKC2lNF3C+Yab5WrZ7au+a4hZEab5iYMVaAvT5Gxt5LK0XYnjK7xQrk+LsAcPWZ
bK/gZV+aaJZ7OtcgFLZDOC4hEs2sEenDS2bfE8zofC8vEItDzWp4FKtB9nCAtWRj
qn+m5kSFNXr4xz6ygbPJXaV3RdOw8CQh6UqRubtoL3aFzgCfIBIMDrmKCWpLt5Sz
FmjTUF1kYfL6lY5WFXiLAhTnV09gBav5S9GMdFmDQ7CFihc3/eAelITbS7YWc+tS
qlqHeaSsjvPgz1NhB+3jE9cUwYvw/A==
=8lPr
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--

