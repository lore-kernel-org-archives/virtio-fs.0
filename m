Return-Path: <mst@redhat.com>
Date: Wed, 22 Feb 2023 07:43:43 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230222074214-mutt-send-email-mst@kernel.org>
References: <20230217170038.1273710-1-antonkuchin@yandex-team.ru>
 <20230217170038.1273710-2-antonkuchin@yandex-team.ru>
 <59165bde-bfd4-a073-c618-205be3951e4a@yandex-team.ru>
MIME-Version: 1.0
In-Reply-To: <59165bde-bfd4-a073-c618-205be3951e4a@yandex-team.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
To: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Cc: Anton Kuchin <antonkuchin@yandex-team.ru>, qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>

On Wed, Feb 22, 2023 at 03:20:00PM +0300, Vladimir Sementsov-Ogievskiy wrote:
> On 17.02.23 20:00, Anton Kuchin wrote:
> > Migration of vhost-user-fs device requires transfer of FUSE internal state
> > from backend. There is no standard way to do it now so by default migration
> > must be blocked. But if this state can be externally transferred by
> > orchestrator give it an option to explicitly allow migration.
> > 
> > Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
> > ---
> >   hw/core/qdev-properties-system.c    | 10 +++++++++
> >   hw/virtio/vhost-user-fs.c           | 32 ++++++++++++++++++++++++++++-
> >   include/hw/qdev-properties-system.h |  1 +
> >   include/hw/virtio/vhost-user-fs.h   |  2 ++
> >   qapi/migration.json                 | 16 +++++++++++++++
> >   5 files changed, 60 insertions(+), 1 deletion(-)
> > 
> > diff --git a/hw/core/qdev-properties-system.c b/hw/core/qdev-properties-system.c
> > index d42493f630..d9b1aa2a5d 100644
> > --- a/hw/core/qdev-properties-system.c
> > +++ b/hw/core/qdev-properties-system.c
> > @@ -1143,3 +1143,13 @@ const PropertyInfo qdev_prop_uuid = {
> >       .set   = set_uuid,
> >       .set_default_value = set_default_uuid_auto,
> >   };
> > +
> > +const PropertyInfo qdev_prop_vhost_user_migration_type = {
> > +    .name = "VhostUserMigrationType",
> > +    .description = "none/external",
> > +    .enum_table = &VhostUserMigrationType_lookup,
> > +    .get = qdev_propinfo_get_enum,
> > +    .set = qdev_propinfo_set_enum,
> > +    .set_default_value = qdev_propinfo_set_default_value_enum,
> > +    .realized_set_allowed = true,
> > +};
> > diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> > index 83fc20e49e..7deb9df5ec 100644
> > --- a/hw/virtio/vhost-user-fs.c
> > +++ b/hw/virtio/vhost-user-fs.c
> > @@ -298,9 +298,35 @@ static struct vhost_dev *vuf_get_vhost(VirtIODevice *vdev)
> >       return &fs->vhost_dev;
> >   }
> > +static int vhost_user_fs_pre_save(void *opaque)
> > +{
> > +    VHostUserFS *fs = opaque;
> > +    g_autofree char *path = object_get_canonical_path(OBJECT(fs));
> > +
> > +    switch (fs->migration_type) {
> > +    case VHOST_USER_MIGRATION_TYPE_NONE:
> > +        error_report("Migration is blocked by device %s", path);
> > +        break;
> > +    case VHOST_USER_MIGRATION_TYPE_EXTERNAL:
> > +        return 0;
> > +    default:
> > +        error_report("Migration type '%s' is not supported by device %s",
> > +                     VhostUserMigrationType_str(fs->migration_type), path);
> > +        break;
> > +    }
> > +
> > +    return -1;
> > +}
> 
> Should we also add this as .pre_load, to force user select correct migration_type on target too?

In fact, I would claim we only want pre_load.
When qemu is started on destination we know where it's migrated
from so this flag can be set.
When qemu is started on source we generally do not yet know so
we don't know whether it's safe to set this flag.


> > +
> >   static const VMStateDescription vuf_vmstate = {
> >       .name = "vhost-user-fs",
> > -    .unmigratable = 1,
> > +    .minimum_version_id = 0,
> > +    .version_id = 0,
> > +    .fields = (VMStateField[]) {
> > +        VMSTATE_VIRTIO_DEVICE,
> > +        VMSTATE_END_OF_LIST()
> > +    },
> > +   .pre_save = vhost_user_fs_pre_save,
> >   };
> >   static Property vuf_properties[] = {
> > @@ -309,6 +335,10 @@ static Property vuf_properties[] = {
> >       DEFINE_PROP_UINT16("num-request-queues", VHostUserFS,
> >                          conf.num_request_queues, 1),
> >       DEFINE_PROP_UINT16("queue-size", VHostUserFS, conf.queue_size, 128),
> > +    DEFINE_PROP_UNSIGNED("migration", VHostUserFS, migration_type,
> > +                         VHOST_USER_MIGRATION_TYPE_NONE,
> > +                         qdev_prop_vhost_user_migration_type,
> > +                         VhostUserMigrationType),
> 
> 1. I see, other similar qdev_prop_* use DEFINE_PROP_SIGNED
> 2. All of them except only qdev_prop_fdc_drive_type, define also a convenient macro in include/hw/qdev-properties-system.h
> 
> should we follow these patterns?
> 
> 
> -- 
> Best regards,
> Vladimir

