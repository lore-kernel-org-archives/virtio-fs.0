Return-Path: <stefanha@redhat.com>
Date: Tue, 21 Feb 2023 15:45:38 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <Y/UtctcE2Zz6fN/m@fedora>
References: <20230217170038.1273710-1-antonkuchin@yandex-team.ru>
 <20230217170038.1273710-2-antonkuchin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="1cajONYwFAWKaZxB"
Content-Disposition: inline
In-Reply-To: <20230217170038.1273710-2-antonkuchin@yandex-team.ru>
Subject: Re: [Virtio-fs] [PATCH v3 1/1] vhost-user-fs: add migration type
 property
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Anton Kuchin <antonkuchin@yandex-team.ru>
Cc: qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>


--1cajONYwFAWKaZxB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 17, 2023 at 07:00:38PM +0200, Anton Kuchin wrote:
> Migration of vhost-user-fs device requires transfer of FUSE internal state
> from backend. There is no standard way to do it now so by default migrati=
on
> must be blocked. But if this state can be externally transferred by
> orchestrator give it an option to explicitly allow migration.
>=20
> Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
> ---
>  hw/core/qdev-properties-system.c    | 10 +++++++++
>  hw/virtio/vhost-user-fs.c           | 32 ++++++++++++++++++++++++++++-
>  include/hw/qdev-properties-system.h |  1 +
>  include/hw/virtio/vhost-user-fs.h   |  2 ++
>  qapi/migration.json                 | 16 +++++++++++++++
>  5 files changed, 60 insertions(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--1cajONYwFAWKaZxB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmP1LXIACgkQnKSrs4Gr
c8ivrwgAt5GdQxjyi0fVLBoBkgHZheMzo79D9gVii15uTadRD01uNa0S5w6gjfEk
IgYeiEXydei/COYYX7HjUcd3jRezxIfVPQALNp5aqnylOnBar1+a/Bc7GzpsIJM0
0KrJco5zRmKV8fP7Yvd++QJkilhqKNsrJqaJ3cbAbVkdC/lBnJfHqtzwdb2zMKsH
xtS7KX+l3FBt8SHwdMAodKVr6u3UnjltP+K0os0agHu8kt8DRW4blHl1UlIBNU4F
XaaD0iOBBdH6Zak4rD7ZLC5IfOa0AXkVP2KdCRR6yS+OoKNes+kcleV/Nc2W2FlC
x1jF0TWf6AwMw4VtBZwCbtJX3VCNGQ==
=ZmWd
-----END PGP SIGNATURE-----

--1cajONYwFAWKaZxB--
