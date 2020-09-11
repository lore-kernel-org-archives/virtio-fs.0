Date: Fri, 11 Sep 2020 11:26:42 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200911102642.GG94280@stefanha-x1.localdomain>
References: <20200909184603.263700-1-mreitz@redhat.com>
	<20200909184603.263700-6-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/Zw+/jwnNHcBRYYu"
Content-Disposition: inline
In-Reply-To: <20200909184603.263700-6-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 5/9] fuse: Store fuse_conn in fuse_req
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


--/Zw+/jwnNHcBRYYu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 09, 2020 at 08:45:59PM +0200, Max Reitz wrote:
> Every fuse_req belongs to a fuse_conn.  Right now, we always know which
> fuse_conn that is based on the respective device, but we want to allow
> multiple (sub)mounts per single connection, and then the corresponding
> filesystem is not going to be so trivial to obtain.
>=20
> Storing a pointer to the associated fuse_conn in every fuse_req will
> allow us to trivially find any request's superblock (and thus
> filesystem) even then.
>=20
> Signed-off-by: Max Reitz <mreitz@redhat.com>
> ---
>  fs/fuse/fuse_i.h |  3 +++
>  fs/fuse/dev.c    | 13 +++++++------
>  2 files changed, 10 insertions(+), 6 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--/Zw+/jwnNHcBRYYu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9bUOIACgkQnKSrs4Gr
c8gMgAf9Ez0h55iwBjD75JZ445t3LamcdB84L+imY8zqRSkbssECl/LC+CQ+UFCL
To8ZV4PjkcdUGlK0LfOcXQCjp1J1Mrfkkv6nVo5z2PZ/LW1eKr203dh0pvr3N0Uu
ynbdl5tLN9YPTBTQ52MjTSXvzHJ1Vxn7CScvfiOwZcPHuTxuP/0sSXd1DKsblyLa
2hQljmPkt3g8ePrXTC+MdPQG0WWjOGOWC+pq86Qu9jXAd7pHAC4uKbcB+5M8YeOB
yWlED7HoxqASdQ5Arinudd2C3e2ui/cnaBDQEG3bEEeAKw6FclLV6K6uTxo4AByV
DKIm2DIT97zYWjmAU/DUrf1RsWXevg==
=9qCN
-----END PGP SIGNATURE-----

--/Zw+/jwnNHcBRYYu--

