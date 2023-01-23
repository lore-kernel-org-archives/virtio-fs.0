Return-Path: <stefanha@redhat.com>
Date: Mon, 23 Jan 2023 14:49:39 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <Y87k0wBnHuf5Oktp@fedora>
References: <f9993404-f8b8-7a23-37f8-530313783466@yandex-team.ru>
 <20230120085534-mutt-send-email-mst@kernel.org>
 <703d527f-de92-090c-6ce1-af0dec7de033@yandex-team.ru>
 <20230122030455-mutt-send-email-mst@kernel.org>
 <b7de3adc-cba7-09eb-ea93-f4bfb91bea9e@yandex-team.ru>
 <20230122093903-mutt-send-email-mst@kernel.org>
 <70c0f00a-7828-3ccf-c2ea-49aeef8693e9@yandex-team.ru>
 <20230122111618-mutt-send-email-mst@kernel.org>
 <CAJSP0QXnKGrX3WuSJxe7pLctcueW1AkEc_KUsHGucaDq=VJZkg@mail.gmail.com>
 <21b87a0d-99b1-2755-00de-d1201d85a63e@yandex-team.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="2T541naaH7nRO+Kw"
Content-Disposition: inline
In-Reply-To: <21b87a0d-99b1-2755-00de-d1201d85a63e@yandex-team.ru>
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
Cc: Stefan Hajnoczi <stefanha@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Juan Quintela <quintela@redhat.com>, yc-core@yandex-team.ru


--2T541naaH7nRO+Kw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 23, 2023 at 05:52:17PM +0200, Anton Kuchin wrote:
>=20
> On 23/01/2023 16:09, Stefan Hajnoczi wrote:
> > On Sun, 22 Jan 2023 at 11:18, Michael S. Tsirkin <mst@redhat.com> wrote:
> > > On Sun, Jan 22, 2023 at 06:09:40PM +0200, Anton Kuchin wrote:
> > > > On 22/01/2023 16:46, Michael S. Tsirkin wrote:
> > > > > On Sun, Jan 22, 2023 at 02:36:04PM +0200, Anton Kuchin wrote:
> > > > > > > > This flag should be set when qemu don't need to worry about=
 any
> > > > > > > > external state stored in vhost-user daemons during migratio=
n:
> > > > > > > > don't fail migration, just pack generic virtio device state=
s to
> > > > > > > > migration stream and orchestrator guarantees that the rest =
of the
> > > > > > > > state will be present at the destination to restore full co=
ntext and
> > > > > > > > continue running.
> > > > > > > Sorry  I still do not get it.  So fundamentally, why do we ne=
ed this property?
> > > > > > > vhost-user-fs is not created by default that we'd then need o=
pt-in to
> > > > > > > the special "migrateable" case.
> > > > > > > That's why I said it might make some sense as a device proper=
ty as qemu
> > > > > > > tracks whether device is unplugged for us.
> > > > > > >=20
> > > > > > > But as written, if you are going to teach the orchestrator ab=
out
> > > > > > > vhost-user-fs and its special needs, just teach it when to mi=
grate and
> > > > > > > where not to migrate.
> > > > > > >=20
> > > > > > > Either we describe the special situation to qemu and let qemu
> > > > > > > make an intelligent decision whether to allow migration,
> > > > > > > or we trust the orchestrator. And if it's the latter, then 'm=
igrate'
> > > > > > > already says orchestrator decided to migrate.
> > > > > > The problem I'm trying to solve is that most of vhost-user devi=
ces
> > > > > > now block migration in qemu. And this makes sense since qemu ca=
n't
> > > > > > extract and transfer backend daemon state. But this prevents us=
 from
> > > > > > updating qemu executable via local migration. So this flag is
> > > > > > intended more as a safety check that says "I know what I'm doin=
g".
> > > > > >=20
> > > > > > I agree that it is not really necessary if we trust the orchest=
rator
> > > > > > to request migration only when the migration can be performed i=
n a
> > > > > > safe way. But changing the current behavior of vhost-user-fs fr=
om
> > > > > > "always blocks migration" to "migrates partial state whenever
> > > > > > orchestrator requests it" seems a little  dangerous and can be
> > > > > > misinterpreted as full support for migration in all cases.
> > > > > It's not really different from block is it? orchestrator has to a=
rrange
> > > > > for backend migration. I think we just assumed there's no use-cas=
e where
> > > > > this is practical for vhost-user-fs so we blocked it.
> > > > > But in any case it's orchestrator's responsibility.
> > > > Yes, you are right. So do you think we should just drop the blocker
> > > > without adding a new flag?
> > > I'd be inclined to. I am curious what do dgilbert and stefanha think =
though.
> > If the migration blocker is removed, what happens when a user attempts
> > to migrate with a management tool and/or vhost-user-fs server
> > implementation that don't support migration?
>=20
> There will be no matching fuse-session in destination endpoint so all
> requests to this fs will fail until it is remounted from guest to
> send new FUSE_INIT message that does session setup.

The point of the migration blocker is to prevent breaking running
guests. Situations where a migration completes but results in a broken
guest are problematic for users (especially when they are not logged in
to guests and able to fix them interactively).

If a command-line option is set to override the blocker, that's fine.
But there needs to be a blocker by default if external knowledge is
required to decide whether or not it's safe to migrate.

> >=20
> > Anton: Can you explain how stateless migration will work on the
> > vhost-user-fs back-end side? Is it reusing vhost-user reconnect
> > functionality or introducing a new mode for stateless migration? I
> > guess the vhost-user-fs back-end implementation is required to
> > implement VHOST_F_LOG_ALL so dirty memory can be tracked and drain all
> > in-flight requests when vrings are stopped?
>=20
> It reuses existing vhost-user reconnect code to resubmit inflight
> requests.
> Sure, backend needs to support this feature - presence of required
> features is checked by generic vhost and vhost-user code during init
> and if something is missing migration blocker is assigned to the
> device (not a static one in vmstate that I remove in this patch, but
> other per-device kind of blocker).

This is not enough detail. Please post the QEMU patches before we commit
to a user-visible vhost-user-fs command-line parameter.

I think what you're trying is a new approach that can be made to work.
However, both vhost-user and migration are fragile and you have not
explained how it will work. I don't have confidence in merging this
incrementally because I'm afraid of committing to user-visible or
vhost-user protocol behavior that turns out to be broken just a little
while later.

The kind of detail I was hoping to hear was, for example, how
vhost_user_blk_device_realize() blocks and tries to reconnect 3 times.
Does this approach work for stateless migration? The destination QEMU is
launched before the source QEMU disconnects from the vhost-user UNIX
domain socket, so I guess the destination QEMU cannot connect in the
current version of vhost-user reconnect as implemented by QEMU's
vhost-user-blk device. Have you come up with a new handover protocol?

Stefan

--2T541naaH7nRO+Kw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmPO5NIACgkQnKSrs4Gr
c8hsKQf5AZO1/SZQ9qT/dACjViSYwF+ZB+zFCHHigghzdPjVEGDZL3rqIHZBoDCB
UcKmRB1PRLLWNNs2pzr02spEl9pY7e0y0dXZBcWxBhrj6J4zzMt8WvfGjuKNNRlf
z/lhaZA4pwtJpt/zF0zhTM22R0BhF8mix7D4kUXZoCaIQerd94VLfbiQu8SKQzcq
b2sptH3iDeAgOH+PiltIdM1S2DZGDTl/aYxkJK6xEC9RkFcnPFK/xdPQMpUtgzGO
NzuGi9D0AtJ3ayV62qZ+gwenC6bLHs2CiBOXHaNlOMHxjqMRGuy8/xQ3p8Bd9xHA
Cv4TIuOAZJGN1i+JJmaiPtK39j4BDg==
=Rmvd
-----END PGP SIGNATURE-----

--2T541naaH7nRO+Kw--
