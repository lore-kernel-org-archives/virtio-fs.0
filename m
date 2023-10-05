Return-Path: <stefanha@redhat.com>
Date: Thu, 5 Oct 2023 13:08:52 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20231005170852.GB1342722@fedora>
References: <20231004125904.110781-1-hreitz@redhat.com>
 <20231004125904.110781-2-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="g2QTlaeqbOs+6JNr"
Content-Disposition: inline
In-Reply-To: <20231004125904.110781-2-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 1/8] vhost-user.rst: Deprecate
 [GS]ET_STATUS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, German Maglione <gmaglione@redhat.com>, Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>


--g2QTlaeqbOs+6JNr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 04, 2023 at 02:58:57PM +0200, Hanna Czenczek wrote:
> There is no clearly defined purpose for the virtio status byte in
> vhost-user: For resetting, we already have RESET_DEVICE; and for virtio
> feature negotiation, we have [GS]ET_FEATURES.  With the REPLY_ACK
> protocol extension, it is possible for SET_FEATURES to return errors
> (SET_PROTOCOL_FEATURES may be called before SET_FEATURES).
>=20
> As for implementations, SET_STATUS is not widely implemented.  dpdk does
> implement it, but only uses it to signal feature negotiation failure.
> While it does log reset requests (SET_STATUS 0) as such, it effectively
> ignores them, in contrast to RESET_OWNER (which is deprecated, and today
> means the same thing as RESET_DEVICE).
>=20
> While qemu superficially has support for [GS]ET_STATUS, it does not
> forward the guest-set status byte, but instead just makes it up
> internally, and actually completely ignores what the back-end returns,
> only using it as the template for a subsequent SET_STATUS to add single
> bits to it.  Notably, after setting FEATURES_OK, it never reads it back
> to see whether the flag is still set, which is the only way in which
> dpdk uses the status byte.
>=20
> As-is, no front-end or back-end can rely on the other side handling this
> field in a useful manner, and it also provides no practical use over
> other mechanisms the vhost-user protocol has, which are more clearly
> defined.  Deprecate it.
>=20
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  docs/interop/vhost-user.rst | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--g2QTlaeqbOs+6JNr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUe7aQACgkQnKSrs4Gr
c8j32wgAtMdUBKzt8i0RX1vm+5YZjCyIkwymLuqS1sgqzwaa7sFTdEzVUD05tPWQ
SCLw+j/yfDHVX0MrCYkMQLuUK6pW9g+tVKVoX34t1p/qYs3L3pikkMzBZARG7iQV
9jLmQJRf5VmXYwkWxfO6KR+sanlLFKgrRQ3rvFJChDMO2nNpuaS5cKtNZYRmlDVe
NrOSBleWq1Fkph6tLtV62dNsxcxf48Hm1LUCecOH72kE/FqhQVlz2GIYOg8cxyZG
xZ5jRzeKrS3UPjDHXfga5NZM2EY8JbOW1mY1JiPbRKu2mjDk1nPA6xC+fmvWsAlm
Er3LNvDvH24xjt9eAP7xXglToQNdyw==
=aZg/
-----END PGP SIGNATURE-----

--g2QTlaeqbOs+6JNr--
