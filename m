Return-Path: <stefanha@redhat.com>
Date: Thu, 23 Feb 2023 16:24:43 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <Y/fZm12yGIPnwaDX@fedora>
References: <20230222074214-mutt-send-email-mst@kernel.org>
 <22fee9b6-1dc0-792c-13cf-54c9303556ab@yandex-team.ru>
 <8372550f-def7-4336-c597-d22155abf145@yandex-team.ru>
 <333c4451-8eef-0603-c3f5-10e38c0eb24e@yandex-team.ru>
 <20230222115106-mutt-send-email-mst@kernel.org>
 <11593688-7ca4-def3-6212-7c26faa4d1c6@yandex-team.ru>
 <20230222121133-mutt-send-email-mst@kernel.org>
 <a477ca70-8aea-6c16-122e-1ded4af11f49@yandex-team.ru>
 <20230222151814-mutt-send-email-mst@kernel.org>
 <20230223023604-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="bsCgJ8yyfwQXpwOk"
Content-Disposition: inline
In-Reply-To: <20230223023604-mutt-send-email-mst@kernel.org>
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Anton Kuchin <antonkuchin@yandex-team.ru>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>


--bsCgJ8yyfwQXpwOk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023 at 02:36:33AM -0500, Michael S. Tsirkin wrote:
> On Wed, Feb 22, 2023 at 03:21:42PM -0500, Michael S. Tsirkin wrote:
> > On Wed, Feb 22, 2023 at 08:25:19PM +0200, Anton Kuchin wrote:
> > > On 22/02/2023 19:12, Michael S. Tsirkin wrote:
> > > > On Wed, Feb 22, 2023 at 07:05:47PM +0200, Anton Kuchin wrote:
> > > > > On 22/02/2023 18:51, Michael S. Tsirkin wrote:
> > > > > > On Wed, Feb 22, 2023 at 06:49:10PM +0200, Anton Kuchin wrote:
> > > > > > > On 22/02/2023 17:14, Vladimir Sementsov-Ogievskiy wrote:
> > > > > > > > On 22.02.23 17:25, Anton Kuchin wrote:
> > > > > > > > > > > > +static int vhost_user_fs_pre_save(void *opaque)
> > > > > > > > > > > > +{
> > > > > > > > > > > > +=A0=A0=A0 VHostUserFS *fs =3D opaque;
> > > > > > > > > > > > +=A0=A0=A0 g_autofree char *path =3D object_get_can=
onical_path(OBJECT(fs));
> > > > > > > > > > > > +
> > > > > > > > > > > > +=A0=A0=A0 switch (fs->migration_type) {
> > > > > > > > > > > > +=A0=A0=A0 case VHOST_USER_MIGRATION_TYPE_NONE:
> > > > > > > > > > > > +=A0=A0=A0=A0=A0=A0=A0 error_report("Migration is b=
locked by device %s", path);
> > > > > > > > > > > > +=A0=A0=A0=A0=A0=A0=A0 break;
> > > > > > > > > > > > +=A0=A0=A0 case VHOST_USER_MIGRATION_TYPE_EXTERNAL:
> > > > > > > > > > > > +=A0=A0=A0=A0=A0=A0=A0 return 0;
> > > > > > > > > > > > +=A0=A0=A0 default:
> > > > > > > > > > > > +=A0=A0=A0=A0=A0=A0=A0 error_report("Migration type=
 '%s' is not
> > > > > > > > > > > > supported by device %s",
> > > > > > > > > > > > + VhostUserMigrationType_str(fs->migration_type), p=
ath);
> > > > > > > > > > > > +=A0=A0=A0=A0=A0=A0=A0 break;
> > > > > > > > > > > > +=A0=A0=A0 }
> > > > > > > > > > > > +
> > > > > > > > > > > > +=A0=A0=A0 return -1;
> > > > > > > > > > > > +}
> > > > > > > > > > > Should we also add this as .pre_load, to force user s=
elect
> > > > > > > > > > > correct migration_type on target too?
> > > > > > > > > > In fact, I would claim we only want pre_load.
> > > > > > > > > > When qemu is started on destination we know where it's =
migrated
> > > > > > > > > > from so this flag can be set.
> > > > > > > > > > When qemu is started on source we generally do not yet =
know so
> > > > > > > > > > we don't know whether it's safe to set this flag.
> > > > > > > > But destination is a "source" for next migration, so there =
shouldn't be
> > > > > > > > real difference.
> > > > > > > > The new property has ".realized_set_allowed =3D true", so, =
as I understand
> > > > > > > > it may be changed at any time, so that's not a problem.
> > > > > > > Yes, exactly. So destination's property sets not how it will =
handle this
> > > > > > > incoming
> > > > > > > migration but the future outgoing one.
> > > > > > How do you know where you are going to migrate though?
> > > > > > I think you don't.
> > > > > > Setting it on source is better since we know where we
> > > > > > are migrating from.
> > > > > Yes, I don't know where I'm going to migrate to. This is why prop=
erty
> > > > > affects only how source saves state on outgoing migration.
> > > > Um. I don't get the logic.
> > >=20
> > > For this feature to work we need orchestrator to manage the migration=
=2E And
> > > we
> > > generally assume that it is responsibility of orchestrator to ensure
> > > matching
> > > properties on source and destination.
> > > As orchestrator manages both sides of migration it can set option (an=
d we
> > > can
> > > check it) on either source or destination. Now it's not important whi=
ch side
> > > we
> > > select, because now the option is essentially binary allow/deny (but =
IMHO it
> > > is much better to refuse source to migrate than find later that state=
 can't
> > > be
> > > loaded by destination, in case of file migration this becomes especia=
lly
> > > painful).
> > >=20
> > > But there are plans to add internal migration option (extract FUSE st=
ate
> > > from
> > > backend and transfer it in QEMU migration stream), and that's where
> > > setting/checking
> > > on source becomes important because it will rely on this property to =
decide
> > > if
> > > extra state form backend needs to be put in the migration stream subs=
ection.
> >=20
> >=20
> > If we do internal migration that will be a different property
> > which has to match on source *and* destination.
> >=20
> >=20
> > > If you are concerned about orchestrator breaking assumption of matchi=
ng
> > > properties
> > > on source and destination this is not really supported AFAIK but I do=
n't
> > > think we
> > > need to punish it for this, maybe it has its reasons: I can imagine s=
cenario
> > > where orchestrator could want to migrate from source with
> > > 'migration=3Dexternal'
> > > to destination with 'migration=3Dnone' to ensure that destination can=
't be
> > > migrated further.
> >=20
> > No. I am concerned about a simple practical matter:
> > - I decide to restart qemu on the same host - so I need to enable
> >   migration
> > - Later I decide to migrate qemu to another host - this should be
> >   blocked
> >=20
> >=20
> > Property on source does not satisfy both at the same time.
> > Property on destination does.
>=20
>=20
> Stefan what's your take on this? Should we move this from
> save to load hook?

This property can be changed on the source at runtime via qom-set, so
you don't need to predict the future. The device can be started from an
incoming migration with "external" and then set to "stateful" migration
to migrate to another host later on.

Anton, can you share the virtiofsd patches so we have a full picture of
how "external" migration works? I'd like to understand the workflow and
also how it can be extended when "stateful" migration is added.

>=20
> >=20
> >=20
> > > >=20
> > > >=20
> > > > > > > > > This property selects if VM can migrate and if it can wha=
t should
> > > > > > > > > qemu put
> > > > > > > > > to the migration stream. So we select on source what type=
 of
> > > > > > > > > migration is
> > > > > > > > > allowed for this VM, destination can't check anything at =
load time.
> > > > > > > > OK, so the new field "migration" regulates only outgoing mi=
gration and
> > > > > > > > do nothing for incoming. On incoming migration the migratio=
n stream
> > > > > > > > itself defines the type of device migration.
> > > > > > > > Worth mentioning in doc?
> > > > > > > Good point. I don't think this deserves a respin but if I hav=
e to send v4
> > > > > > > I'll include
> > > > > > > clarification in it.
>=20

--bsCgJ8yyfwQXpwOk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmP32ZsACgkQnKSrs4Gr
c8in6wgAxDVBxIkXV0Cq6wNN1wIs59q6JYF+IaNRU3d674eshKPYJeSXrRlYpwDs
48sO39zfdd2RdLPK03p8TUrx5VFpZt/r6ZWI6kI7fNViHu1EXkQ0OwNRgXhB0Ufk
g7+BIyt/4GFLFIRP3X87eI0HkTVL0ZmyGNAlOQGcBvoRUHYdHN3L9k9dmiUrshM2
zD+AwFGkmW0Qjv3lfbUc1vQqpYrmVmkqWDSlBKaGzGg7BkOXgzA9rjIgW8BiSz6/
NNt79gQqY/HOk8schQvwLi2+LUNh/ToXCtqX1Gw9Z1w9ZECTEIyzDxttWzjOEeB9
r4CKtYruaxyuXCKCMT40XTZh+RMYgA==
=A0Jf
-----END PGP SIGNATURE-----

--bsCgJ8yyfwQXpwOk--
