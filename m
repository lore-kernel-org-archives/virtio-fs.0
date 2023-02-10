Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
In-Reply-To: <626f6e7c-07e4-4aa7-3cce-b96d9fd96d33@yandex-team.ru> (Anton
 Kuchin's message of "Fri, 10 Feb 2023 16:09:23 +0200")
References: <20230115170903.3416105-1-antonkuchin@yandex-team.ru>
 <CAJSP0QVKUKgkBMw1PiN8-L8Ykhq=gfvNTTs4sf1tuzoqHu+GXw@mail.gmail.com>
 <0d57cc40-693b-b36c-a135-fdac60dd00ec@yandex-team.ru>
 <CAJSP0QUXB0kgsCSsmi8dpnJFYho2cR_2Liep=pGmp6WzDZ_7pw@mail.gmail.com>
 <d6bf0b9a-a167-817d-2c17-c2e472961155@yandex-team.ru>
 <CAJSP0QXXe6KgLN2PJvi-5GqcELhUKJPB2pUARL2ktO9TQYAq=g@mail.gmail.com>
 <2fb6efb4-9155-99ad-3acd-c274783436ed@yandex-team.ru>
 <87h6w5ea1m.fsf@secure.mitica>
 <ed9832ec-eaf0-68a4-b7c1-9f1691ab149e@yandex-team.ru>
 <874js4v151.fsf@secure.mitica>
 <626f6e7c-07e4-4aa7-3cce-b96d9fd96d33@yandex-team.ru>
Reply-To: quintela@redhat.com
Date: Fri, 10 Feb 2023 17:08:16 +0100
Message-ID: <87mt5ly03z.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
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
Cc: Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, yc-core@yandex-team.ru, "Michael
 S. Tsirkin" <mst@redhat.com>

Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
> On 02/02/2023 11:59, Juan Quintela wrote:
>> Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
>>> On 01/02/2023 16:26, Juan Quintela wrote:
>>>> Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
>>>>> On 19/01/2023 18:02, Stefan Hajnoczi wrote:
>>>>>> On Thu, 19 Jan 2023 at 10:29, Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
>>>>>>> On 19/01/2023 16:30, Stefan Hajnoczi wrote:
>>>>>>>> On Thu, 19 Jan 2023 at 07:43, Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
>>>>>>>>> On 18/01/2023 17:52, Stefan Hajnoczi wrote:
>>>>>>>>>> On Sun, 15 Jan 2023 at 12:21, Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
>>>> Once told that, I think that you are making your live harder in the
>>>> future when you add the other migratable devices.
>>>>
>>>> static const VMStateDescription vuf_vmstate = {
>>>>       .name = "vhost-user-fs",
>>>>       .minimum_version_id = 0,
>>>>       .version_id = 0,
>>>>       .fields = (VMStateField[]) {
>>>>           VMSTATE_INT8(migration_type, struct VHostUserFS),
>>>>           VMSTATE_VIRTIO_DEVICE,
>>>>           VMSTATE_END_OF_LIST()
>>>>       },
>>>>       .pre_save = vhost_user_fs_pre_save,
>>>>       .subsections = (const VMStateDescription*[]) {
>>>>           &vmstate_vhost_user_fs_internal_sub,
>>>>           NULL
>>>>       }
>>>> };
>>>>
>>>> And you are done.
>>>>
>>>> I will propose to use a property to set migration_type, but I didn't
>>>> want to write the code right now.
>
> I have a little problem with implementation here and need an advice:
>
> Can we make this property adjustable at runtime after device was realized?
> There is a statement in qemu wiki [1] that makes me think this is possible
> but I couldn't find any code for it or example in other devices.
>> "Properties are, by default, locked while the device is
>   realized. Exceptions
>> can be made by the devices themselves in order to implement a way
>   for a user
>> to interact with a device while it is realized."
>
> Or is your idea just to set this property once at construction and keep it
> constant for device lifetime?
>
> [1] https://wiki.qemu.org/Features/QOM

I have no clue here.  Markus?  Stefan?

>>>>
>>>> I think that this proposal will make Stephan happy, and it is just
>>>> adding and extra uint8_t that is helpul to implement everything.
>>> That is exactly the approach I'm trying to implement it right now. Single
>>> flag can be convenient for orchestrator but makes it too hard to account in
>>> all cases for all devices on qemu side without breaking future
>>> compatibility.
>>> So I'm rewriting it with properties.
>> Nice.  That would be my proposal.  Just a bit complicated for a proof of concetp.
>>
>>> BTW do you think each vhost-user device should have its own enum of
>>> migration
>>> types or maybe we could make them common for all device types?
>> I will put it for vhost-user, because as far as I know nobody else is
>> asking for this functionality.
>
> I mean do we need it for all vhost-user devices or only for vhost-user-fs
> that I'm implementing now?

I will put it only for vhost-user-fs, except if there is a central place
that is used for all vhost-user and its easy to put there.

But I don't know enough about vhost-user to know if there is any common
struct to put this.

>> The most similar device that I can think of right now is vfio devices.
>> But they are implemeting callbacks to save hardware device state, and
>> they go device by device, i.e. there is nothing general there.
>>
>> Later, Juan.
>>

Later, Juan.

