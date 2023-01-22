Return-Path: <antonkuchin@yandex-team.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
 s=default; 
 t=1674390968; bh=XFyN96LKJabtM7069V7cZ1ZebEmHLVZlY5JxHELQ1sg=;
 h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
 b=fE+en8/bAL6AyGTPlGTMdGoZDkqa3OlXC714yQ+tHyj7pv+HnzXc9Tpas1yzgc1r9
 ih33D08ZWZ7CwCGIIls34OMa0XykNQIp/WKEvdCOFfk+llVUHD2u0hDYUZX810t0ga
 hOvyNkQ4A7HzQ09SgpRvJBWNivradEa+dm45RP3M=
Message-ID: <b7de3adc-cba7-09eb-ea93-f4bfb91bea9e@yandex-team.ru>
Date: Sun, 22 Jan 2023 14:36:04 +0200
MIME-Version: 1.0
References: <20230115170903.3416105-1-antonkuchin@yandex-team.ru>
 <20230119074602-mutt-send-email-mst@kernel.org>
 <f9993404-f8b8-7a23-37f8-530313783466@yandex-team.ru>
 <20230120085534-mutt-send-email-mst@kernel.org>
 <703d527f-de92-090c-6ce1-af0dec7de033@yandex-team.ru>
 <20230122030455-mutt-send-email-mst@kernel.org>
From: Anton Kuchin <antonkuchin@yandex-team.ru>
In-Reply-To: <20230122030455-mutt-send-email-mst@kernel.org>
Content-Language: en-US, ru-RU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
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
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, yc-core@yandex-team.ru

On 22/01/2023 10:16, Michael S. Tsirkin wrote:
> On Fri, Jan 20, 2023 at 07:37:18PM +0200, Anton Kuchin wrote:
>> On 20/01/2023 15:58, Michael S. Tsirkin wrote:
>>> On Thu, Jan 19, 2023 at 03:45:06PM +0200, Anton Kuchin wrote:
>>>> On 19/01/2023 14:51, Michael S. Tsirkin wrote:
>>>>> On Sun, Jan 15, 2023 at 07:09:03PM +0200, Anton Kuchin wrote:
>>>>>> Now any vhost-user-fs device makes VM unmigratable, that also preven=
ts
>>>>>> qemu update without stopping the VM. In most cases that makes sense
>>>>>> because qemu has no way to transfer FUSE session state.
>>>>>>
>>>>>> But we can give an option to orchestrator to override this if it can
>>>>>> guarantee that state will be preserved (e.g. it uses migration to
>>>>>> update qemu and dst will run on the same host as src and use the sam=
e
>>>>>> socket endpoints).
>>>>>>
>>>>>> This patch keeps default behavior that prevents migration with such =
devices
>>>>>> but adds migration capability 'vhost-user-fs' to explicitly allow mi=
gration.
>>>>>>
>>>>>> Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
>>>>>> ---
>>>>>>     hw/virtio/vhost-user-fs.c | 25 ++++++++++++++++++++++++-
>>>>>>     qapi/migration.json       |  7 ++++++-
>>>>>>     2 files changed, 30 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
>>>>>> index f5049735ac..13d920423e 100644
>>>>>> --- a/hw/virtio/vhost-user-fs.c
>>>>>> +++ b/hw/virtio/vhost-user-fs.c
>>>>>> @@ -24,6 +24,7 @@
>>>>>>     #include "hw/virtio/vhost-user-fs.h"
>>>>>>     #include "monitor/monitor.h"
>>>>>>     #include "sysemu/sysemu.h"
>>>>>> +#include "migration/migration.h"
>>>>>>     static const int user_feature_bits[] =3D {
>>>>>>         VIRTIO_F_VERSION_1,
>>>>>> @@ -298,9 +299,31 @@ static struct vhost_dev *vuf_get_vhost(VirtIODe=
vice *vdev)
>>>>>>         return &fs->vhost_dev;
>>>>>>     }
>>>>>> +static int vhost_user_fs_pre_save(void *opaque)
>>>>>> +{
>>>>>> +    MigrationState *s =3D migrate_get_current();
>>>>>> +
>>>>>> +    if (!s->enabled_capabilities[MIGRATION_CAPABILITY_VHOST_USER_FS=
]) {
>>>>>> +        error_report("Migration of vhost-user-fs devices requires i=
nternal FUSE "
>>>>>> +                     "state of backend to be preserved. If orchestr=
ator can "
>>>>>> +                     "guarantee this (e.g. dst connects to the same=
 backend "
>>>>>> +                     "instance or backend state is migrated) set 'v=
host-user-fs' "
>>>>>> +                     "migration capability to true to enable migrat=
ion.");
>>>>> Isn't it possible that some backends are same and some are not?
>>>>> Shouldn't this be a device property then?
>>>> If some are not the same it is not guaranteed that correct FUSE
>>>> state is present there, so orchestrator shouldn't set the capability
>>>> because this can result in destination devices being broken (they'll
>>>> be fine after the remount in guest, but this is guest visible and is
>>>> not acceptable).
>>>>
>>>> I can imagine smart orchestrator and backend that can transfer
>>>> internal FUSE state, but we are not there yet, and this would be
>>>> their responsibility then to ensure endpoint compatibility between src
>>>> and dst and set the capability (that's why I put "e.g." and "or" in
>>>> the error description).
>>> So instead of relying on the orchestrator how about making it a device
>>> property?
>> We have to rely on the orchestrator here and I can't see how a property
>> can help us with this: same device can be migratable or not depending
>> on if the destination is the same host, what features backend supports,
>> how management software works and other factors of environment that
>> are not accessible from qemu or backend daemon.
>> So in the end we'll end up with orchestrator having to setup flags for
>> each device before each migration based on information only it can
>> have - in my opinion this is worse than just giving the orchestrator
>> a single flag that it can set after calculating the decision for
>> the particular migration that it organizes.
>>
>>>
>>>>>
>>>>>> +        return -1;
>>>>>> +    }
>>>>>> +
>>>>>> +    return 0;
>>>>>> +}
>>>>>> +
>>>>>>     static const VMStateDescription vuf_vmstate =3D {
>>>>>>         .name =3D "vhost-user-fs",
>>>>>> -    .unmigratable =3D 1,
>>>>>> +    .minimum_version_id =3D 0,
>>>>>> +    .version_id =3D 0,
>>>>>> +    .fields =3D (VMStateField[]) {
>>>>>> +        VMSTATE_VIRTIO_DEVICE,
>>>>>> +        VMSTATE_END_OF_LIST()
>>>>>> +    },
>>>>>> +   .pre_save =3D vhost_user_fs_pre_save,
>>>>>>     };
>>>>>>     static Property vuf_properties[] =3D {
>>>>>> diff --git a/qapi/migration.json b/qapi/migration.json
>>>>>> index 88ecf86ac8..9a229ea884 100644
>>>>>> --- a/qapi/migration.json
>>>>>> +++ b/qapi/migration.json
>>>>>> @@ -477,6 +477,11 @@
>>>>>>     #                    will be handled faster.  This is a performa=
nce feature and
>>>>>>     #                    should not affect the correctness of postco=
py migration.
>>>>>>     #                    (since 7.1)
>>>>>> +# @vhost-user-fs: If enabled, the migration process will allow migr=
ation of
>>>>>> +#                 vhost-user-fs devices, this should be enabled onl=
y when
>>>>>> +#                 backend can preserve local FUSE state e.g. for qe=
mu update
>>>>>> +#                 when dst reconects to the same endpoints after mi=
gration.
>>>>>> +#                 (since 8.0)
>>>>>>     #
>>>>>>     # Features:
>>>>>>     # @unstable: Members @x-colo and @x-ignore-shared are experiment=
al.
>>>>>> @@ -492,7 +497,7 @@
>>>>>>                'dirty-bitmaps', 'postcopy-blocktime', 'late-block-ac=
tivate',
>>>>>>                { 'name': 'x-ignore-shared', 'features': [ 'unstable'=
 ] },
>>>>>>                'validate-uuid', 'background-snapshot',
>>>>>> -           'zero-copy-send', 'postcopy-preempt'] }
>>>>>> +           'zero-copy-send', 'postcopy-preempt', 'vhost-user-fs'] }
>>>>> I kind of dislike that it's such a specific flag. Is only vhost-user-=
fs
>>>>> ever going to be affected? Any way to put it in a way that is more ge=
neric?
>>>> Here I agree with you: I would prefer less narrow naming too. But I
>>>> didn't manage to come up with one. Looks like many other vhost-user
>>>> devices could benefit from this so maybe "vhost-user-stateless" or
>>>> something like this would be better.
>>>> I'm not sure that other types of devices could handle reconnect to
>>>> the old endpoint as easy as vhost-user-fs, but anyway the support for
>>>> this flag needs to be implemented for each device individually.
>>>> What do you think? Any ideas would be appreciated.
>>> Let's try to create a better description of when this flag should be
>>> set. Then shorten it up to create the name.
>> This flag should be set when qemu don't need to worry about any
>> external state stored in vhost-user daemons during migration:
>> don't fail migration, just pack generic virtio device states to
>> migration stream and orchestrator guarantees that the rest of the
>> state will be present at the destination to restore full context and
>> continue running.
> Sorry  I still do not get it.  So fundamentally, why do we need this prop=
erty?
> vhost-user-fs is not created by default that we'd then need opt-in to
> the special "migrateable" case.
> That's why I said it might make some sense as a device property as qemu
> tracks whether device is unplugged for us.
>
> But as written, if you are going to teach the orchestrator about
> vhost-user-fs and its special needs, just teach it when to migrate and
> where not to migrate.
>
> Either we describe the special situation to qemu and let qemu
> make an intelligent decision whether to allow migration,
> or we trust the orchestrator. And if it's the latter, then 'migrate'
> already says orchestrator decided to migrate.

The problem I'm trying to solve is that most of vhost-user devices
now block migration in qemu. And this makes sense since qemu can't
extract and transfer backend daemon state. But this prevents us from
updating qemu executable via local migration. So this flag is
intended more as a safety check that says "I know what I'm doing".

I agree that it is not really necessary if we trust the orchestrator
to request migration only when the migration can be performed in a
safe way. But changing the current behavior of vhost-user-fs from
"always blocks migration" to "migrates partial state whenever
orchestrator requests it" seems a little=C2=A0 dangerous and can be
misinterpreted as full support for migration in all cases.

>
>>>>>>     ##
>>>>>>     # @MigrationCapabilityStatus:
>>>>>> --=20
>>>>>> 2.34.1

