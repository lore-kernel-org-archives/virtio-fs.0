Return-Path: <antonkuchin@yandex-team.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
 s=default; 
 t=1676590769; bh=Ukek2IoB8J/nU9SDWGKhYXdAO6rouX+BAnO/UEeZVsk=;
 h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
 b=X/sMEcENePMGRFSg+TfHjBq/34pMVudA3y9WnO29EO/wghxgHSNaQHqD7gb1untNm
 QwKXr8g5lBcA+EMKdWy7xdh1lOtKciGkX559C5MOYzAxySw9j2lb6yANHtq90Xt1OG
 1THWYtbZd/jVBMnlcPsJuW5UjvEtAJaIJmGFUsF8=
Message-ID: <abdafcdc-4a52-0658-4c9e-cee7e33ebbdb@yandex-team.ru>
Date: Fri, 17 Feb 2023 01:39:25 +0200
MIME-Version: 1.0
References: <20230216140003.1103681-1-antonkuchin@yandex-team.ru>
 <20230216140003.1103681-2-antonkuchin@yandex-team.ru>
 <87v8k1itoy.fsf@secure.mitica>
 <20230216110952-mutt-send-email-mst@kernel.org>
 <20230216111134-mutt-send-email-mst@kernel.org>
 <87zg9dfulz.fsf@secure.mitica>
From: Anton Kuchin <antonkuchin@yandex-team.ru>
In-Reply-To: <87zg9dfulz.fsf@secure.mitica>
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
To: quintela@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>
Cc: qemu-devel@nongnu.org, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, yc-core@yandex-team.ru, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>

/* resend with fixed to: and cc: */

On 16/02/2023 18:22, Juan Quintela wrote:
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
>> On Thu, Feb 16, 2023 at 11:11:22AM -0500, Michael S. Tsirkin wrote:
>>> On Thu, Feb 16, 2023 at 03:14:05PM +0100, Juan Quintela wrote:
>>>> Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
>>>>> Now any vhost-user-fs device makes VM unmigratable, that also prevents
>>>>> qemu update without stopping the VM. In most cases that makes sense
>>>>> because qemu has no way to transfer FUSE session state.
>>>>>
>>>>> But it is good to have an option for orchestrator to tune this according to
>>>>> backend capabilities and migration configuration.
>>>>>
>>>>> This patch adds device property 'migration' that is 'none' by default
>>>>> to keep old behaviour but can be set to 'external' to explicitly allow
>>>>> migration with minimal virtio device state in migration stream if daemon
>>>>> has some way to sync FUSE state on src and dst without help from qemu.
>>>>>
>>>>> Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
>>>> Reviewed-by: Juan Quintela <quintela@redhat.com>
>>>>
>>>> The migration bits are correct.
>>>>
>>>> And I can think a better way to explain that one device is migrated
>>>> externally.

I'm bad at wording but I'll try to improve this one.
Suggestions will be really appreciated.

>>>>
>>>> If you have to respin:
>>>>
>>>>> +static int vhost_user_fs_pre_save(void *opaque)
>>>>> +{
>>>>> +    VHostUserFS *fs = (VHostUserFS *)opaque;
>>>> This hack is useless.

I will. Will get rid of that, thanks.

>>> meaning the cast? yes.
>>>
>>>> I know that there are still lots of code that still have it.
>>>>
>>>>
>>>> Now remember that I have no clue about vhost-user-fs.
>>>>
>>>> But this looks fishy
>>>>>   static const VMStateDescription vuf_vmstate = {
>>>>>       .name = "vhost-user-fs",
>>>>> -    .unmigratable = 1,
>>>>> +    .minimum_version_id = 0,
>>>>> +    .version_id = 0,
>>>>> +    .fields = (VMStateField[]) {
>>>>> +        VMSTATE_VIRTIO_DEVICE,
>>>>> +        VMSTATE_UINT8(migration_type, VHostUserFS),
>>>>> +        VMSTATE_END_OF_LIST()
>> In fact why do we want to migrate this property?
>> We generally don't, we only migrate state.
> See previous discussion.
> In a nutshell, we are going to have internal migration in the future
> (not done yet).
>
> Later, Juan.

I think Michael is right. We don't need it at destination to know
what data is in the stream because subsections will tell us all we
need to know.

>
>>>>> +    },
>>>>> +   .pre_save = vhost_user_fs_pre_save,
>>>>>   };
>>>>>   
>>>>>   static Property vuf_properties[] = {
>>>>> @@ -309,6 +337,10 @@ static Property vuf_properties[] = {
>>>>>       DEFINE_PROP_UINT16("num-request-queues", VHostUserFS,
>>>>>                          conf.num_request_queues, 1),
>>>>>       DEFINE_PROP_UINT16("queue-size", VHostUserFS, conf.queue_size, 128),
>>>>> +    DEFINE_PROP_UNSIGNED("migration", VHostUserFS, migration_type,
>>>>> +                         VHOST_USER_MIGRATION_TYPE_NONE,
>>>>> +                         qdev_prop_vhost_user_migration_type,
>>>>> +                         uint8_t),
>>>>>       DEFINE_PROP_END_OF_LIST(),
>>>> We have four properties here (5 with the new migration one), and you
>>>> only migrate one.
>>>>
>>>> This looks fishy, but I don't know if it makes sense.
>>>> If they _have_ to be configured the same on source and destination, I
>>>> would transfer them and check in post_load that the values are correct.
>>>>
>>>> Later, Juan.
>>> Weird suggestion.  We generally don't do this kind of check - that
>>> would be open-coding each property. It's management's job to make
>>> sure things are consistent.
>>>
>>> -- 
>>> MST
>

