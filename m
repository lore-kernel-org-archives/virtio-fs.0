Return-Path: <antonkuchin@yandex-team.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
 s=default; 
 t=1676589301; bh=ZV8biU70g1NbEr/BSKodwfmfX8Bxfo90JFBqfI9t96U=;
 h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
 b=b3Yg+L/HdS/8i8XWQFmYp/bIoXPYVuVRx5OBqGO+IHZu/G0t+0O6MLrNLBxdLVQS0
 72/2pM05Eg2rLFHB2FnAGNPStUNevQBfRLqy0ynYobCURuhOcJSXE/93BVmtJsmoVO
 HIkXR8R3+ghLQia24dhbUzdUGdKymuQ3RcCobYLo=
Message-ID: <16c3a6e3-fd48-a32d-9777-738928b4c75a@yandex-team.ru>
Date: Fri, 17 Feb 2023 01:14:57 +0200
MIME-Version: 1.0
References: <20230216140003.1103681-1-antonkuchin@yandex-team.ru>
 <20230216140003.1103681-2-antonkuchin@yandex-team.ru>
 <Y+6bbqsZZ4OPo63M@fedora>
From: Anton Kuchin <antonkuchin@yandex-team.ru>
In-Reply-To: <Y+6bbqsZZ4OPo63M@fedora>
Content-Language: en-US, ru-RU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v2 1/1] vhost-user-fs: add property to allow
 migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Markus Armbruster <armbru@redhat.com>, yc-core@yandex-team.ru, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>, Juan Quintela <quintela@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>

On 16/02/2023 23:09, Stefan Hajnoczi wrote:
> On Thu, Feb 16, 2023 at 04:00:03PM +0200, Anton Kuchin wrote:
>> Now any vhost-user-fs device makes VM unmigratable, that also prevents
>> qemu update without stopping the VM. In most cases that makes sense
>> because qemu has no way to transfer FUSE session state.
>>
>> But it is good to have an option for orchestrator to tune this according to
>> backend capabilities and migration configuration.
>>
>> This patch adds device property 'migration' that is 'none' by default
>> to keep old behaviour but can be set to 'external' to explicitly allow
>> migration with minimal virtio device state in migration stream if daemon
>> has some way to sync FUSE state on src and dst without help from qemu.
>>
>> Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
>> ---
>>   hw/core/qdev-properties-system.c    | 10 +++++++++
>>   hw/virtio/vhost-user-fs.c           | 34 ++++++++++++++++++++++++++++-
>>   include/hw/qdev-properties-system.h |  1 +
>>   include/hw/virtio/vhost-user-fs.h   |  1 +
>>   qapi/migration.json                 | 16 ++++++++++++++
>>   5 files changed, 61 insertions(+), 1 deletion(-)
> Looks okay to me. Comments below.
>
>> diff --git a/hw/core/qdev-properties-system.c b/hw/core/qdev-properties-system.c
>> index d42493f630..d9b1aa2a5d 100644
>> --- a/hw/core/qdev-properties-system.c
>> +++ b/hw/core/qdev-properties-system.c
>> @@ -1143,3 +1143,13 @@ const PropertyInfo qdev_prop_uuid = {
>>       .set   = set_uuid,
>>       .set_default_value = set_default_uuid_auto,
>>   };
>> +
>> +const PropertyInfo qdev_prop_vhost_user_migration_type = {
>> +    .name = "VhostUserMigrationType",
>> +    .description = "none/external",
>> +    .enum_table = &VhostUserMigrationType_lookup,
>> +    .get = qdev_propinfo_get_enum,
>> +    .set = qdev_propinfo_set_enum,
>> +    .set_default_value = qdev_propinfo_set_default_value_enum,
>> +    .realized_set_allowed = true,
>> +};
>> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
>> index 83fc20e49e..e2a5b6cfdf 100644
>> --- a/hw/virtio/vhost-user-fs.c
>> +++ b/hw/virtio/vhost-user-fs.c
>> @@ -24,6 +24,7 @@
>>   #include "hw/virtio/vhost-user-fs.h"
>>   #include "monitor/monitor.h"
>>   #include "sysemu/sysemu.h"
>> +#include "qapi/qapi-types-migration.h"
>>   
>>   static const int user_feature_bits[] = {
>>       VIRTIO_F_VERSION_1,
>> @@ -298,9 +299,36 @@ static struct vhost_dev *vuf_get_vhost(VirtIODevice *vdev)
>>       return &fs->vhost_dev;
>>   }
>>   
>> +static int vhost_user_fs_pre_save(void *opaque)
>> +{
>> +    VHostUserFS *fs = (VHostUserFS *)opaque;
>> +    g_autofree char *path = object_get_canonical_path(OBJECT(fs));
>> +
>> +    switch (fs->migration_type) {
>> +    case VHOST_USER_MIGRATION_TYPE_NONE:
>> +        error_report("Migration is blocked by device %s", path);
>> +        break;
>> +    case VHOST_USER_MIGRATION_TYPE_EXTERNAL:
>> +        return 0;
>> +    default:
>> +        error_report("Migration type '%s' is not supported by device %s",
>> +                     VhostUserMigrationType_str(fs->migration_type), path);
>> +        break;
>> +    }
>> +
>> +    return -1;
>> +}
>> +
>>   static const VMStateDescription vuf_vmstate = {
>>       .name = "vhost-user-fs",
>> -    .unmigratable = 1,
>> +    .minimum_version_id = 0,
>> +    .version_id = 0,
>> +    .fields = (VMStateField[]) {
>> +        VMSTATE_VIRTIO_DEVICE,
>> +        VMSTATE_UINT8(migration_type, VHostUserFS),
> Maybe add a comment since Michael asked what the purpose of this field
> is:
>
>    /* For verifying that source/destination migration= properties match */
>    VMSTATE_UINT8(migration_type, VHostUserFS),
>
> Come to think of it...where is the code that checks the vmstate
> migration_type field matches the destination device's migration=
> property?

It's a good idea to have a comment here, thanks.
This field is not really for verifying that source and destination match.
It just describes what data is packed into the stream.
In fact this property could be different and this breaks nothing:
e.g. when we migrate from version that can export only stateless stream
to one that finally supports internal migration.

Said that I start thinking that we don't need it in the stream at all
because extra data can be detected just by presence of additional
subsection.

>
>> +        VMSTATE_END_OF_LIST()
>> +    },
>> +   .pre_save = vhost_user_fs_pre_save,
>>   };
>>   
>>   static Property vuf_properties[] = {
>> @@ -309,6 +337,10 @@ static Property vuf_properties[] = {
>>       DEFINE_PROP_UINT16("num-request-queues", VHostUserFS,
>>                          conf.num_request_queues, 1),
>>       DEFINE_PROP_UINT16("queue-size", VHostUserFS, conf.queue_size, 128),
>> +    DEFINE_PROP_UNSIGNED("migration", VHostUserFS, migration_type,
>> +                         VHOST_USER_MIGRATION_TYPE_NONE,
>> +                         qdev_prop_vhost_user_migration_type,
>> +                         uint8_t),
>>       DEFINE_PROP_END_OF_LIST(),
>>   };
>>   
>> diff --git a/include/hw/qdev-properties-system.h b/include/hw/qdev-properties-system.h
>> index 0ac327ae60..1a67591590 100644
>> --- a/include/hw/qdev-properties-system.h
>> +++ b/include/hw/qdev-properties-system.h
>> @@ -22,6 +22,7 @@ extern const PropertyInfo qdev_prop_audiodev;
>>   extern const PropertyInfo qdev_prop_off_auto_pcibar;
>>   extern const PropertyInfo qdev_prop_pcie_link_speed;
>>   extern const PropertyInfo qdev_prop_pcie_link_width;
>> +extern const PropertyInfo qdev_prop_vhost_user_migration_type;
>>   
>>   #define DEFINE_PROP_PCI_DEVFN(_n, _s, _f, _d)                   \
>>       DEFINE_PROP_SIGNED(_n, _s, _f, _d, qdev_prop_pci_devfn, int32_t)
>> diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
>> index 94c3aaa84e..3ebce77be5 100644
>> --- a/include/hw/virtio/vhost-user-fs.h
>> +++ b/include/hw/virtio/vhost-user-fs.h
>> @@ -40,6 +40,7 @@ struct VHostUserFS {
>>       VirtQueue **req_vqs;
>>       VirtQueue *hiprio_vq;
>>       int32_t bootindex;
>> +    uint8_t migration_type;
>>   
>>       /*< public >*/
>>   };
>> diff --git a/qapi/migration.json b/qapi/migration.json
>> index c84fa10e86..ababd605a2 100644
>> --- a/qapi/migration.json
>> +++ b/qapi/migration.json
>> @@ -2178,3 +2178,19 @@
>>     'data': { 'job-id': 'str',
>>               'tag': 'str',
>>               'devices': ['str'] } }
>> +
>> +##
>> +# @VhostUserMigrationType:
>> +#
>> +# Type of vhost-user device migration.
>> +#
>> +# @none: Migration is not supported, attempts to migrate with this device
>> +#        will be blocked.
>> +#
>> +# @external: Migration stream contains only virtio device state,
>> +#            deamon state should be transfered externally by orchestrator.
> s/deamon/daemon/
> s/transfered/transferred/

Will fix, thanks

>
>> +#
>> +# Since: 8.0
>> +##
>> +{ 'enum': 'VhostUserMigrationType',
>> +  'data': [ 'none', 'external' ] }
>> -- 
>> 2.37.2
>>

