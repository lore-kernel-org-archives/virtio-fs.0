Return-Path: <stefanha@redhat.com>
Date: Wed, 25 Jan 2023 14:46:00 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <Y9GG+EXX03TAvWDS@fedora>
References: <20230115170903.3416105-1-antonkuchin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="ygiLBLz14JAm0xgO"
Content-Disposition: inline
In-Reply-To: <20230115170903.3416105-1-antonkuchin@yandex-team.ru>
Subject: Re: [Virtio-fs] [PATCH] vhost-user-fs: add capability to allow
 migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Anton Kuchin <antonkuchin@yandex-team.ru>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Juan Quintela <quintela@redhat.com>, yc-core@yandex-team.ru, "Michael S. Tsirkin" <mst@redhat.com>


--ygiLBLz14JAm0xgO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 15, 2023 at 07:09:03PM +0200, Anton Kuchin wrote:
> Now any vhost-user-fs device makes VM unmigratable, that also prevents
> qemu update without stopping the VM. In most cases that makes sense
> because qemu has no way to transfer FUSE session state.
>=20
> But we can give an option to orchestrator to override this if it can
> guarantee that state will be preserved (e.g. it uses migration to
> update qemu and dst will run on the same host as src and use the same
> socket endpoints).
>=20
> This patch keeps default behavior that prevents migration with such devic=
es
> but adds migration capability 'vhost-user-fs' to explicitly allow migrati=
on.
>=20
> Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
> ---
>  hw/virtio/vhost-user-fs.c | 25 ++++++++++++++++++++++++-
>  qapi/migration.json       |  7 ++++++-
>  2 files changed, 30 insertions(+), 2 deletions(-)

Hi Anton,
Sorry for holding up your work with the discussions that we had. I still
feel it's important to agree on command-line and/or vhost-user protocol
changes that will be able to support non-migratable, stateless
migration/reconnect, and stateful migration vhost-user-fs back-ends. All
three will exist.

As a next step, could you share your code that implements the QEMU side
of stateless migration?

I think that will make it clearer whether a command-line option
(migration capability or per-device) is sufficient or whether the
vhost-user protocol needs to be extended.

If the vhost-user protocol is extended then maybe no user-visible
changes are necessary. QEMU will know if the vhost-user-fs backend
supports migration and which type of migration. It can block migration
in cases where it's not possible.

Thanks,
Stefan

--ygiLBLz14JAm0xgO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmPRhvgACgkQnKSrs4Gr
c8izOgf/byjN54t5uv1VugMSLblTq6dHpjGJDpdmjIb7QjBk/VTe57XFhBOp4VEg
mlDNTVHBc4lU0NHize5dueoW8wUMKT+gQq8Tb6O5VabHZA1NJVQ2TOrlwWt4Q6bn
eS3IAIRB+4JoFPlYzJMa9MhkEjbnlJ6yYpVvuo8tNfTOMCHdirDiBWx/P43F0X2W
6TNkpr56+NixIO5E0wfnKPfkiS083h9PqVYFy7WH6debjBM+IRyBSaRSaLpgJRHt
a8D4rjb+XFxW71qFFMK3XWa/8sy2MfLCW2oPC1Zc137ItjqxaxRwqiZKsrU79GLi
WuQcgk2e7RYTUbLRfJXdbrH27j0N8g==
=VwlJ
-----END PGP SIGNATURE-----

--ygiLBLz14JAm0xgO--
