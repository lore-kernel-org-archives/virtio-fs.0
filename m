Return-Path: <stefanha@redhat.com>
Date: Mon, 23 Jan 2023 16:56:34 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <Y88Cknp1XwN8rGHA@fedora>
References: <703d527f-de92-090c-6ce1-af0dec7de033@yandex-team.ru>
 <20230122030455-mutt-send-email-mst@kernel.org>
 <b7de3adc-cba7-09eb-ea93-f4bfb91bea9e@yandex-team.ru>
 <20230122093903-mutt-send-email-mst@kernel.org>
 <70c0f00a-7828-3ccf-c2ea-49aeef8693e9@yandex-team.ru>
 <20230122111618-mutt-send-email-mst@kernel.org>
 <CAJSP0QXnKGrX3WuSJxe7pLctcueW1AkEc_KUsHGucaDq=VJZkg@mail.gmail.com>
 <21b87a0d-99b1-2755-00de-d1201d85a63e@yandex-team.ru>
 <Y87k0wBnHuf5Oktp@fedora>
 <20230123155228-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="Z50+DLanrM9+xm5R"
Content-Disposition: inline
In-Reply-To: <20230123155228-mutt-send-email-mst@kernel.org>
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Anton Kuchin <antonkuchin@yandex-team.ru>, Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Juan Quintela <quintela@redhat.com>, yc-core@yandex-team.ru


--Z50+DLanrM9+xm5R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 23, 2023 at 04:00:50PM -0500, Michael S. Tsirkin wrote:
> On Mon, Jan 23, 2023 at 02:49:39PM -0500, Stefan Hajnoczi wrote:
> > The point of the migration blocker is to prevent breaking running
> > guests. Situations where a migration completes but results in a broken
> > guest are problematic for users (especially when they are not logged in
> > to guests and able to fix them interactively).
>=20
> I thought it's the reverse - we block when we are sure it can't work.
> If we are not sure we should leave policy to orchestrators.
>=20
> You can always get into situations like this with stateful storage (as
> opposed to RO one).  For example, naively scp the backend file then
> start migration. Will seem to work but corrupts the disk (I didn't try,
> for sure with raw but what about qcow2?)

You're right that ultimately QEMU cannot verify that the destination
will 100% work. Who knows if the destination is even a real QEMU or just
a process that throws away the migration stream? :)

> > If a command-line option is set to override the blocker, that's fine.
> > But there needs to be a blocker by default if external knowledge is
> > required to decide whether or not it's safe to migrate.
>=20
> If all the command line says is "I want migration to work" then
> that's more like shifting the blame than helping users.
> They just learn this one weird trick and it seems to work
> until it doesn't.  Then we are like "we told you only to set this
> flag if you are sure" and they are like "well I was sure".

What I'm getting at is that this is a breaking change. Previously the
management tool didn't need to be aware of vhost-user-fs migration
support. QEMU would reject migrations. We cannot start allowing them
because management tools may depend on QEMU's migration blocker.

If management tools need to be aware now then the safe way to introduce
this is via a parameter that new management tools must explicitly pass
to QEMU.

Anton's same host migration case is valid but the majority of users
migrate between hosts and that case is not supported yet. Most of the
time vhost-user-fs migration won't work. Let's not break existing
management tools and vhost-user-fs back-ends.

Stefan

--Z50+DLanrM9+xm5R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmPPApIACgkQnKSrs4Gr
c8ixywf/eRBpkuEQnmrV3XXvPbY0Ms6YXmXTSC8kMtyT7MocFtl09uP0DIvbEcq2
81JbuI9gSPTQKAT9Ybx6CfpwlXdV5iPuSHYSQ+orSpVQwuw7H4Lqy/RWVHfYRzz4
7U5+/BOl8d9xvs8aHZsQdddMr3qtUgrDO8EM5OG7fLAjIOyQPaMs9lmeuHILOZTz
tyvvlm805fD8diK7sskdJsOPVGiqW5du5BMH95T3MTZlLpXepB0rylapEqbfL4Qw
x0z9bAo3OAsJ+hINz8O3JVEy4mgZjZKm+kKy83Uxr3MTwy1MIw+OlTOBmHs4bVKN
5vORO2KVCRZ00foKSavmltOxJD697A==
=pWJc
-----END PGP SIGNATURE-----

--Z50+DLanrM9+xm5R--
