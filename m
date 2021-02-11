Date: Thu, 11 Feb 2021 10:05:16 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210211100516.GC247031@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-3-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="RIYY1s2vRbPFwWeW"
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-3-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 02/24] DAX: libvhost-user: Route slave
	message payload
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com, mst@redhat.com


--RIYY1s2vRbPFwWeW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 07:02:02PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Route the uint64 payload from message replies on the slave back up
> through vu_process_message_reply and to the callers.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  subprojects/libvhost-user/libvhost-user.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--RIYY1s2vRbPFwWeW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlAVwACgkQnKSrs4Gr
c8huKAf9HKzk9xXP/UcXfbQAV1aNDTTJVbYZHXfGUnGzQyIwFjntanmaZ4tiavQR
Q8ppS9nZLiYcQosKG0NECS0Nx57iai4hfj3YjHPedLT0mt6AcHcZs05JVgPt9rVA
PnYwJ9uJtjoi1WcaVc0P362/G30HPistjhl3Q7ee15glpiCYbcz83g8lcAbzqVyR
UIDE5XlUKMozpWC/HVXxPpr0wXS2dzQDPhwGBy9xWy7XSylwqLsn9tRUpXIHgAXH
a9ZadkwUhnWx87Rhq4njmXjRKRWR3wFhQeMC2xvw/gkC5mbkhVhQDBIwq2UO2voG
psFi/k6EiRU2WrliLC0CPh+6bIu7vQ==
=egj8
-----END PGP SIGNATURE-----

--RIYY1s2vRbPFwWeW--

