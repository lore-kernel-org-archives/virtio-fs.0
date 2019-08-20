Date: Tue, 20 Aug 2019 11:07:49 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190820100749.GG9855@stefanha-x1.localdomain>
References: <20190812210455.12540-1-msys.mizuma@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UTZ8bGhNySVQ9LYl"
Content-Disposition: inline
In-Reply-To: <20190812210455.12540-1-msys.mizuma@gmail.com>
Subject: Re: [Virtio-fs] [PATCH 0/3] virtio-fs: Add some tracepoints
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>


--UTZ8bGhNySVQ9LYl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2019 at 05:04:52PM -0400, Masayoshi Mizuma wrote:
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>=20
> This patch series introduce some tracepoints. It will be
> useful to debug the I/O request flow.
>=20
> New trace events:
>=20
>   - virtio_fs_request_dispatched
>   - virtio_fs_request_done
>   - virtio_fs_hiprio_request_dispatched
>   - virtio_fs_hiprio_request_done
>=20
> Above trace events is added to the following functions as
> the tracepoints:
>=20
>   - virtio_fs_enqueue_req
>   - virtio_fs_requests_done_work
>   - virtio_fs_hiprio_dispatch_work
>   - virtio_fs_hiprio_done_work
>=20
> Example of the trace record:
>=20
>   cat-1432        [006] .... 37.592694: virtio_fs_request_dispatched:
>       opcode FUSE_READ unique 0x1a nodeid 0x2 in.len 80 flags
>       ISREPLY|WAITING|SENT notify 1
>   kworker/4:1-103 [004] .... 37.592809: virtio_fs_request_done:
>       opcode FUSE_READ unique 0x1a nodeid 0x2 in.len 80 flags
>       ISREPLY|WAITING
>=20
> Changelog:
>  From RFC:
>  - Change the string and the file name from virtiofs to virtio_fs.
>  - Separate the fuse macros to the other file to get useful for
>    generic fuse trace.
>=20
> Masayoshi Mizuma (3):
>   fuse: add some macros for ftrace
>   virtio-fs: add ftrace events
>   virtio-fs: add tracepoints
>=20
>  fs/fuse/virtio_fs.c                |  21 +++++
>  include/trace/events/fuse_common.h |  67 +++++++++++++++
>  include/trace/events/virtio_fs.h   | 131 +++++++++++++++++++++++++++++
>  3 files changed, 219 insertions(+)
>  create mode 100644 include/trace/events/fuse_common.h
>  create mode 100644 include/trace/events/virtio_fs.h
>=20
> --=20
> 2.18.1
>=20

Looks useful, thanks.  I'm concerned about use-after-frees, please see
my other email reply.

--UTZ8bGhNySVQ9LYl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1bxnUACgkQnKSrs4Gr
c8h9DwgAs553sff1t9Xm7cznH03we6xg99xC6sL5ZgebTAieIVlWhB/oXUDdLWQE
mxkDur9/ukPvjXNxut70i0/90xTYdFPf1bDPQxg9jks6eXcvD0c+9AdN/tiRABG9
V0/rGxlyPHRmny388j82r/U9tQrOx6ZLX9nTceln7W+ZvKPVcpgN48oU/wIdBcl4
m5mq+QflGLMEFI1u1TS3Ci41F8L25KJzcgzk5PCCjbrdORNMGF4R8KtZcORPu/Ij
XxW7hEZyO/wyTUh0JW0BlG5owd3mdRwWyiZK5Nv9y3X9Z764ZI+k4rRfECLCMdEP
bmCET8RWcmJArI2bT8QvFi0gEC7moA==
=ekje
-----END PGP SIGNATURE-----

--UTZ8bGhNySVQ9LYl--

