Return-Path: <antonkuchin@yandex-team.ru>
Message-ID: <8611d901-0940-3747-c2cd-9c193c7f24f2@yandex-team.ru>
Date: Tue, 28 Feb 2023 16:30:36 +0200
MIME-Version: 1.0
References: <22fee9b6-1dc0-792c-13cf-54c9303556ab@yandex-team.ru>
 <8372550f-def7-4336-c597-d22155abf145@yandex-team.ru>
 <333c4451-8eef-0603-c3f5-10e38c0eb24e@yandex-team.ru>
 <20230222115106-mutt-send-email-mst@kernel.org>
 <11593688-7ca4-def3-6212-7c26faa4d1c6@yandex-team.ru>
 <20230222121133-mutt-send-email-mst@kernel.org>
 <a477ca70-8aea-6c16-122e-1ded4af11f49@yandex-team.ru>
 <20230222151814-mutt-send-email-mst@kernel.org>
 <20230223023604-mutt-send-email-mst@kernel.org> <Y/fZm12yGIPnwaDX@fedora>
 <20230224034258-mutt-send-email-mst@kernel.org>
From: Anton Kuchin <antonkuchin@yandex-team.ru>
In-Reply-To: <20230224034258-mutt-send-email-mst@kernel.org>
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
To: "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>

On 24/02/2023 10:47, Michael S. Tsirkin wrote:
> On Thu, Feb 23, 2023 at 04:24:43PM -0500, Stefan Hajnoczi wrote:
>> On Thu, Feb 23, 2023 at 02:36:33AM -0500, Michael S. Tsirkin wrote:
>>> On Wed, Feb 22, 2023 at 03:21:42PM -0500, Michael S. Tsirkin wrote:
>>>> On Wed, Feb 22, 2023 at 08:25:19PM +0200, Anton Kuchin wrote:
>>>>> On 22/02/2023 19:12, Michael S. Tsirkin wrote:
>>>>>> On Wed, Feb 22, 2023 at 07:05:47PM +0200, Anton Kuchin wrote:
>>>>>>> On 22/02/2023 18:51, Michael S. Tsirkin wrote:
>>>>>>>> On Wed, Feb 22, 2023 at 06:49:10PM +0200, Anton Kuchin wrote:
>>>>>>>>> On 22/02/2023 17:14, Vladimir Sementsov-Ogievskiy wrote:
>>>>>>>>>> On 22.02.23 17:25, Anton Kuchin wrote:
>>>>>>>>>>>>>> +static int vhost_user_fs_pre_save(void *opaque)
>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 VHostUserFS *fs =3D opaque;
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 g_autofree char *path =3D object_get_can=
onical_path(OBJECT(fs));
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 switch (fs->migration_type) {
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 case VHOST_USER_MIGRATION_TYPE_NONE:
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error_report("Mi=
gration is blocked by device %s", path);
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 case VHOST_USER_MIGRATION_TYPE_EXTERNAL:
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 default:
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error_report("Mi=
gration type '%s' is not
>>>>>>>>>>>>>> supported by device %s",
>>>>>>>>>>>>>> + VhostUserMigrationType_str(fs->migration_type), path);
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 return -1;
>>>>>>>>>>>>>> +}
>>>>>>>>>>>>> Should we also add this as .pre_load, to force user select
>>>>>>>>>>>>> correct migration_type on target too?
>>>>>>>>>>>> In fact, I would claim we only want pre_load.
>>>>>>>>>>>> When qemu is started on destination we know where it's migrate=
d
>>>>>>>>>>>> from so this flag can be set.
>>>>>>>>>>>> When qemu is started on source we generally do not yet know so
>>>>>>>>>>>> we don't know whether it's safe to set this flag.
>>>>>>>>>> But destination is a "source" for next migration, so there shoul=
dn't be
>>>>>>>>>> real difference.
>>>>>>>>>> The new property has ".realized_set_allowed =3D true", so, as I =
understand
>>>>>>>>>> it may be changed at any time, so that's not a problem.
>>>>>>>>> Yes, exactly. So destination's property sets not how it will hand=
le this
>>>>>>>>> incoming
>>>>>>>>> migration but the future outgoing one.
>>>>>>>> How do you know where you are going to migrate though?
>>>>>>>> I think you don't.
>>>>>>>> Setting it on source is better since we know where we
>>>>>>>> are migrating from.
>>>>>>> Yes, I don't know where I'm going to migrate to. This is why proper=
ty
>>>>>>> affects only how source saves state on outgoing migration.
>>>>>> Um. I don't get the logic.
>>>>> For this feature to work we need orchestrator to manage the migration=
. And
>>>>> we
>>>>> generally assume that it is responsibility of orchestrator to ensure
>>>>> matching
>>>>> properties on source and destination.
>>>>> As orchestrator manages both sides of migration it can set option (an=
d we
>>>>> can
>>>>> check it) on either source or destination. Now it's not important whi=
ch side
>>>>> we
>>>>> select, because now the option is essentially binary allow/deny (but =
IMHO it
>>>>> is much better to refuse source to migrate than find later that state=
 can't
>>>>> be
>>>>> loaded by destination, in case of file migration this becomes especia=
lly
>>>>> painful).
>>>>>
>>>>> But there are plans to add internal migration option (extract FUSE st=
ate
>>>>> from
>>>>> backend and transfer it in QEMU migration stream), and that's where
>>>>> setting/checking
>>>>> on source becomes important because it will rely on this property to =
decide
>>>>> if
>>>>> extra state form backend needs to be put in the migration stream subs=
ection.
>>>>
>>>> If we do internal migration that will be a different property
>>>> which has to match on source *and* destination.
>>>>
>>>>
>>>>> If you are concerned about orchestrator breaking assumption of matchi=
ng
>>>>> properties
>>>>> on source and destination this is not really supported AFAIK but I do=
n't
>>>>> think we
>>>>> need to punish it for this, maybe it has its reasons: I can imagine s=
cenario
>>>>> where orchestrator could want to migrate from source with
>>>>> 'migration=3Dexternal'
>>>>> to destination with 'migration=3Dnone' to ensure that destination can=
't be
>>>>> migrated further.
>>>> No. I am concerned about a simple practical matter:
>>>> - I decide to restart qemu on the same host - so I need to enable
>>>>    migration
>>>> - Later I decide to migrate qemu to another host - this should be
>>>>    blocked
>>>>
>>>>
>>>> Property on source does not satisfy both at the same time.
>>>> Property on destination does.
>>>
>>> Stefan what's your take on this? Should we move this from
>>> save to load hook?
>> This property can be changed on the source at runtime via qom-set, so
>> you don't need to predict the future. The device can be started from an
>> incoming migration with "external" and then set to "stateful" migration
>> to migrate to another host later on.
> And then you are supposed to change it back if migration fails?
> External tool failures have to be handled ...
> How likely is all this fragile dance not to have bugs?
>
> And all of this effort for what? Just to make the case of a buggy
> management tool fail a bit faster - is it really worth it?
>
> Compare to setting it on destination where you can set it
> on command line or through qom and forget about it.
> No?

I really don't understand why and what do you want to check on
destination. This option is supposed to control outgoing migration
only, just to be compatible and extensible for future migration
implementations.
It doesn't affectin any way the ability to load migration stream on
destination.
Destination can decide if the stream can be loaded based only on the
information present in the migration stream and not on the device
properties.

So qemu with this patch can load any stream generated by qemu with
this patch because there is only one supported mode "external" and
I don't see why we shouldn't allow this.

And when "internal" mode is added newer qemu will support loading
both full and partial types of streams depending on what data is
present in the stream (and this is controlled by orchestrator that
is setting option on source side).
Future "internal" option is not planned to deprecate "external"
but they both will be valid and coexist simultaneously allowing
management to pick one or the other.

So having faster fail on source if something is misconfigured is
just a good side-effect we get for free, but not the real purpose.

There can be some benefit in creating all devices with "migration=3Dnone"
by default and enabling required type of migration just before it
is about to happen if orchestrator wants to be protected from
wrong migrations. This may be a little too much but if orchestrator
wants it can force such type of double-check and avoid guessing future
migration type when there will be more than one type supported.

>
>> Anton, can you share the virtiofsd patches so we have a full picture of
>> how "external" migration works? I'd like to understand the workflow and
>> also how it can be extended when "stateful" migration is added.
>>
>>>>
>>>>>>
>>>>>>>>>>> This property selects if VM can migrate and if it can what shou=
ld
>>>>>>>>>>> qemu put
>>>>>>>>>>> to the migration stream. So we select on source what type of
>>>>>>>>>>> migration is
>>>>>>>>>>> allowed for this VM, destination can't check anything at load t=
ime.
>>>>>>>>>> OK, so the new field "migration" regulates only outgoing migrati=
on and
>>>>>>>>>> do nothing for incoming. On incoming migration the migration str=
eam
>>>>>>>>>> itself defines the type of device migration.
>>>>>>>>>> Worth mentioning in doc?
>>>>>>>>> Good point. I don't think this deserves a respin but if I have to=
 send v4
>>>>>>>>> I'll include
>>>>>>>>> clarification in it.
>

