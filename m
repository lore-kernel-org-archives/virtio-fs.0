Return-Path: <mst@redhat.com>
Date: Wed, 22 Feb 2023 11:51:52 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230222115106-mutt-send-email-mst@kernel.org>
References: <20230217170038.1273710-1-antonkuchin@yandex-team.ru>
 <20230217170038.1273710-2-antonkuchin@yandex-team.ru>
 <59165bde-bfd4-a073-c618-205be3951e4a@yandex-team.ru>
 <20230222074214-mutt-send-email-mst@kernel.org>
 <22fee9b6-1dc0-792c-13cf-54c9303556ab@yandex-team.ru>
 <8372550f-def7-4336-c597-d22155abf145@yandex-team.ru>
 <333c4451-8eef-0603-c3f5-10e38c0eb24e@yandex-team.ru>
MIME-Version: 1.0
In-Reply-To: <333c4451-8eef-0603-c3f5-10e38c0eb24e@yandex-team.ru>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
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
Cc: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>

On Wed, Feb 22, 2023 at 06:49:10PM +0200, Anton Kuchin wrote:
> On 22/02/2023 17:14, Vladimir Sementsov-Ogievskiy wrote:
> > On 22.02.23 17:25, Anton Kuchin wrote:
> > > > > > +static int vhost_user_fs_pre_save(void *opaque)
> > > > > > +{
> > > > > > +=A0=A0=A0 VHostUserFS *fs =3D opaque;
> > > > > > +=A0=A0=A0 g_autofree char *path =3D object_get_canonical_path(=
OBJECT(fs));
> > > > > > +
> > > > > > +=A0=A0=A0 switch (fs->migration_type) {
> > > > > > +=A0=A0=A0 case VHOST_USER_MIGRATION_TYPE_NONE:
> > > > > > +=A0=A0=A0=A0=A0=A0=A0 error_report("Migration is blocked by de=
vice %s", path);
> > > > > > +=A0=A0=A0=A0=A0=A0=A0 break;
> > > > > > +=A0=A0=A0 case VHOST_USER_MIGRATION_TYPE_EXTERNAL:
> > > > > > +=A0=A0=A0=A0=A0=A0=A0 return 0;
> > > > > > +=A0=A0=A0 default:
> > > > > > +=A0=A0=A0=A0=A0=A0=A0 error_report("Migration type '%s' is not
> > > > > > supported by device %s",
> > > > > > + VhostUserMigrationType_str(fs->migration_type), path);
> > > > > > +=A0=A0=A0=A0=A0=A0=A0 break;
> > > > > > +=A0=A0=A0 }
> > > > > > +
> > > > > > +=A0=A0=A0 return -1;
> > > > > > +}
> > > > > Should we also add this as .pre_load, to force user select
> > > > > correct migration_type on target too?
> > > > In fact, I would claim we only want pre_load.
> > > > When qemu is started on destination we know where it's migrated
> > > > from so this flag can be set.
> > > > When qemu is started on source we generally do not yet know so
> > > > we don't know whether it's safe to set this flag.
> >=20
> > But destination is a "source" for next migration, so there shouldn't be
> > real difference.
> > The new property has ".realized_set_allowed =3D true", so, as I underst=
and
> > it may be changed at any time, so that's not a problem.
>=20
> Yes, exactly. So destination's property sets not how it will handle this
> incoming
> migration but the future outgoing one.


How do you know where you are going to migrate though?
I think you don't.
Setting it on source is better since we know where we
are migrating from.

> >=20
> > >=20
> > > This property selects if VM can migrate and if it can what should
> > > qemu put
> > > to the migration stream. So we select on source what type of
> > > migration is
> > > allowed for this VM, destination can't check anything at load time.
> >=20
> > OK, so the new field "migration" regulates only outgoing migration and
> > do nothing for incoming. On incoming migration the migration stream
> > itself defines the type of device migration.
> > Worth mentioning in doc?
>=20
> Good point. I don't think this deserves a respin but if I have to send v4
> I'll include
> clarification in it.

