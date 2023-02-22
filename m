Return-Path: <antonkuchin@yandex-team.ru>
Message-ID: <954a51f0-dfb8-7688-2197-d93e6b0c5fde@yandex-team.ru>
Date: Wed, 22 Feb 2023 19:15:40 +0200
MIME-Version: 1.0
References: <20230217170038.1273710-1-antonkuchin@yandex-team.ru>
 <20230217170038.1273710-2-antonkuchin@yandex-team.ru>
 <59165bde-bfd4-a073-c618-205be3951e4a@yandex-team.ru>
 <20230222074214-mutt-send-email-mst@kernel.org>
 <22fee9b6-1dc0-792c-13cf-54c9303556ab@yandex-team.ru>
 <8372550f-def7-4336-c597-d22155abf145@yandex-team.ru>
 <20230222112907-mutt-send-email-mst@kernel.org>
From: Anton Kuchin <antonkuchin@yandex-team.ru>
In-Reply-To: <20230222112907-mutt-send-email-mst@kernel.org>
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
To: "Michael S. Tsirkin" <mst@redhat.com>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Cc: qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>

On 22/02/2023 18:43, Michael S. Tsirkin wrote:
> On Wed, Feb 22, 2023 at 06:14:31PM +0300, Vladimir Sementsov-Ogievskiy wr=
ote:
>> On 22.02.23 17:25, Anton Kuchin wrote:
>>>>>> +static int vhost_user_fs_pre_save(void *opaque)
>>>>>> +{
>>>>>> +=C2=A0=C2=A0=C2=A0 VHostUserFS *fs =3D opaque;
>>>>>> +=C2=A0=C2=A0=C2=A0 g_autofree char *path =3D object_get_canonical_p=
ath(OBJECT(fs));
>>>>>> +
>>>>>> +=C2=A0=C2=A0=C2=A0 switch (fs->migration_type) {
>>>>>> +=C2=A0=C2=A0=C2=A0 case VHOST_USER_MIGRATION_TYPE_NONE:
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error_report("Migration =
is blocked by device %s", path);
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>>>> +=C2=A0=C2=A0=C2=A0 case VHOST_USER_MIGRATION_TYPE_EXTERNAL:
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>>>>> +=C2=A0=C2=A0=C2=A0 default:
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error_report("Migration =
type '%s' is not supported by device %s",
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VhostUserMigrationTy=
pe_str(fs->migration_type), path);
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>>> +
>>>>>> +=C2=A0=C2=A0=C2=A0 return -1;
>>>>>> +}
>>>>> Should we also add this as .pre_load, to force user select correct mi=
gration_type on target too?
>>>> In fact, I would claim we only want pre_load.
>>>> When qemu is started on destination we know where it's migrated
>>>> from so this flag can be set.
>>>> When qemu is started on source we generally do not yet know so
>>>> we don't know whether it's safe to set this flag.
>> But destination is a "source" for next migration, so there shouldn't be =
real difference.
> And whether to allow that migration should be decided by destination of
> that migration.

Destination can just refuse to load unsupported state. But this happens
automatically if migration code finds unknown subsection and needs no
explicit check by device .pre_load.

>
>
>> The new property has ".realized_set_allowed =3D true", so, as I understa=
nd it may be changed at any time, so that's not a problem.
>>
>>> This property selects if VM can migrate and if it can what should qemu =
put
>>> to the migration stream. So we select on source what type of migration =
is
>>> allowed for this VM, destination can't check anything at load time.
>> OK, so the new field "migration" regulates only outgoing migration and d=
o nothing for incoming. On incoming migration the migration stream itself d=
efines the type of device migration.
>> Worth mentioning in doc?
>>
>> --=20
>> Best regards,
>> Vladimir

