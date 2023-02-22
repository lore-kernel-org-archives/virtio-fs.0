Return-Path: <antonkuchin@yandex-team.ru>
Message-ID: <110cd713-b01f-5fce-eb32-4ddb6c42685f@yandex-team.ru>
Date: Wed, 22 Feb 2023 16:21:01 +0200
MIME-Version: 1.0
References: <20230217170038.1273710-1-antonkuchin@yandex-team.ru>
 <20230217170038.1273710-2-antonkuchin@yandex-team.ru>
 <59165bde-bfd4-a073-c618-205be3951e4a@yandex-team.ru>
From: Anton Kuchin <antonkuchin@yandex-team.ru>
In-Reply-To: <59165bde-bfd4-a073-c618-205be3951e4a@yandex-team.ru>
Content-Language: en-US, ru-RU
Content-Type: text/plain; charset=UTF-8; format=flowed
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
To: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Cc: qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>

On 22/02/2023 14:20, Vladimir Sementsov-Ogievskiy wrote:
> On 17.02.23 20:00, Anton Kuchin wrote:
>> Migration of vhost-user-fs device requires transfer of FUSE internal=20
>> state
>> from backend. There is no standard way to do it now so by default=20
>> migration
>> must be blocked. But if this state can be externally transferred by
>> orchestrator give it an option to explicitly allow migration.
>>
>> Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
>> ---
>> =C2=A0 hw/core/qdev-properties-system.c=C2=A0=C2=A0=C2=A0 | 10 +++++++++
>> =C2=A0 hw/virtio/vhost-user-fs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 32 ++++++++++++++++++++++++++++-
>> =C2=A0 include/hw/qdev-properties-system.h |=C2=A0 1 +
>> =C2=A0 include/hw/virtio/vhost-user-fs.h=C2=A0=C2=A0 |=C2=A0 2 ++
>> =C2=A0 qapi/migration.json=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 16 +++++++++++++++
>> =C2=A0 5 files changed, 60 insertions(+), 1 deletion(-)
>>
>> diff --git a/hw/core/qdev-properties-system.c=20
>> b/hw/core/qdev-properties-system.c
>> index d42493f630..d9b1aa2a5d 100644
>> --- a/hw/core/qdev-properties-system.c
>> +++ b/hw/core/qdev-properties-system.c
>> @@ -1143,3 +1143,13 @@ const PropertyInfo qdev_prop_uuid =3D {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .set=C2=A0=C2=A0 =3D set_uuid,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .set_default_value =3D set_default_uuid_a=
uto,
>> =C2=A0 };
>> +
>> +const PropertyInfo qdev_prop_vhost_user_migration_type =3D {
>> +=C2=A0=C2=A0=C2=A0 .name =3D "VhostUserMigrationType",
>> +=C2=A0=C2=A0=C2=A0 .description =3D "none/external",
>> +=C2=A0=C2=A0=C2=A0 .enum_table =3D &VhostUserMigrationType_lookup,
>> +=C2=A0=C2=A0=C2=A0 .get =3D qdev_propinfo_get_enum,
>> +=C2=A0=C2=A0=C2=A0 .set =3D qdev_propinfo_set_enum,
>> +=C2=A0=C2=A0=C2=A0 .set_default_value =3D qdev_propinfo_set_default_val=
ue_enum,
>> +=C2=A0=C2=A0=C2=A0 .realized_set_allowed =3D true,
>> +};
>> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
>> index 83fc20e49e..7deb9df5ec 100644
>> --- a/hw/virtio/vhost-user-fs.c
>> +++ b/hw/virtio/vhost-user-fs.c
>> @@ -298,9 +298,35 @@ static struct vhost_dev=20
>> *vuf_get_vhost(VirtIODevice *vdev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return &fs->vhost_dev;
>> =C2=A0 }
>> =C2=A0 +static int vhost_user_fs_pre_save(void *opaque)
>> +{
>> +=C2=A0=C2=A0=C2=A0 VHostUserFS *fs =3D opaque;
>> +=C2=A0=C2=A0=C2=A0 g_autofree char *path =3D object_get_canonical_path(=
OBJECT(fs));
>> +
>> +=C2=A0=C2=A0=C2=A0 switch (fs->migration_type) {
>> +=C2=A0=C2=A0=C2=A0 case VHOST_USER_MIGRATION_TYPE_NONE:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error_report("Migration is b=
locked by device %s", path);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>> +=C2=A0=C2=A0=C2=A0 case VHOST_USER_MIGRATION_TYPE_EXTERNAL:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>> +=C2=A0=C2=A0=C2=A0 default:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error_report("Migration type=
 '%s' is not supported by device=20
>> %s",
>> + VhostUserMigrationType_str(fs->migration_type), path);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 return -1;
>> +}
>
> Should we also add this as .pre_load, to force user select correct=20
> migration_type on target too?

Why do we need it? Enum forces user to select at least one of the sane=20
option
and I believe this is enough. As this property affects only save and=20
don't know
what we can do at load.

>
>> +
>> =C2=A0 static const VMStateDescription vuf_vmstate =3D {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .name =3D "vhost-user-fs",
>> -=C2=A0=C2=A0=C2=A0 .unmigratable =3D 1,
>> +=C2=A0=C2=A0=C2=A0 .minimum_version_id =3D 0,
>> +=C2=A0=C2=A0=C2=A0 .version_id =3D 0,
>> +=C2=A0=C2=A0=C2=A0 .fields =3D (VMStateField[]) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VMSTATE_VIRTIO_DEVICE,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VMSTATE_END_OF_LIST()
>> +=C2=A0=C2=A0=C2=A0 },
>> +=C2=A0=C2=A0 .pre_save =3D vhost_user_fs_pre_save,
>> =C2=A0 };
>> =C2=A0 =C2=A0 static Property vuf_properties[] =3D {
>> @@ -309,6 +335,10 @@ static Property vuf_properties[] =3D {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DEFINE_PROP_UINT16("num-request-queues", =
VHostUserFS,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 co=
nf.num_request_queues, 1),
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DEFINE_PROP_UINT16("queue-size", VHostUse=
rFS, conf.queue_size,=20
>> 128),
>> +=C2=A0=C2=A0=C2=A0 DEFINE_PROP_UNSIGNED("migration", VHostUserFS, migra=
tion_type,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 VHOST_USER_MIGRATION_TYPE_NONE,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 qdev_prop_vhost_user_migration_type,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 VhostUserMigrationType),
>
> 1. I see, other similar qdev_prop_* use DEFINE_PROP_SIGNED

I don't think this should be signed. Enum values are non-negative so=20
compilers
(at least gcc and clang that I checked) evaluate underlying enum type to=20
be unsigned int.
I don't know why other property types use signed, may be they have=20
reasons or just this
is how they were initially implemented.

> 2. All of them except only qdev_prop_fdc_drive_type, define also a=20
> convenient macro in include/hw/qdev-properties-system.h

This makes sense if property is used in more than one place, in this=20
case I don't see any
benefit from writing more code to handle this specific case. Maybe if=20
property finds its
usage in other devices this can be done.

>
> should we follow these patterns?
>
>

