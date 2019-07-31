Date: Wed, 31 Jul 2019 14:01:21 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190731130121.GB22809@stefanha-x1.localdomain>
References: <1558577194-61841-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="z6Eq5LdranGa6ru8"
Content-Disposition: inline
In-Reply-To: <1558577194-61841-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: handle NULL dir in lo_do_lookup
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com


--z6Eq5LdranGa6ru8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 23, 2019 at 10:06:34AM +0800, Liu Bo wrote:
> Reported by fstests/generic/467.
>=20
> open_by_handle_at() called from fuse inside guest can carry fuse mount
> point to daemon but lo_do_lookup() doesn't know its inode info because
> it's out of fuse's scope, thus lo_inode(req, parent) ends up with
> returning a NULL dir and breaks virtiofsd immediately.
>=20
> Note that it'd break applications that uses open_by_handle_at.
>=20
> It seems to me that nothing could be done to support open_by_handle_at in
> this case.
>=20
> This simply tells fuse a ENOENT error so that open_by_handle_at() in guest
> can get a ESTALE.
>=20
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>  contrib/virtiofsd/passthrough_ll.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--z6Eq5LdranGa6ru8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1BkSEACgkQnKSrs4Gr
c8gIrAf/SuEP+iwEe+MJ4WycHzMES9T/Eb/xhmxe9j41HYsZJjlQo4FWyObr1Y24
/XZAv3LQskdc0grrdyghIWpE9nFyh7jvQyziaowJUaSfAphF/RIIppP31oV+W2UA
jKLxlgjYXbIO1Dp7cw16WveA6f6CgAAK6acgwFSuHxjtT8tQ7CivMzOAwLP9i1bm
zasN5FQyNIv8NbuD7vMwOy97kkEevMkFyhV3eMlwUNjGMWK05Ul063Mnj7Hb+QWA
CWgVkSgDwtaxj4E3W95Aw1ZCeFWaoRcEp70fMznZcsISItjZG8iUiLoI00gDqT79
k/CVFyb1DWmhf/m4mzdG1q1MrmMEhw==
=u1yW
-----END PGP SIGNATURE-----

--z6Eq5LdranGa6ru8--

