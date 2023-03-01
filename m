Return-Path: <antonkuchin@yandex-team.ru>
Message-ID: <39577b2c-71ec-5e83-d796-2c4fe3d1fc10@yandex-team.ru>
Date: Wed, 1 Mar 2023 17:40:09 +0200
MIME-Version: 1.0
References: <a477ca70-8aea-6c16-122e-1ded4af11f49@yandex-team.ru>
 <20230222151814-mutt-send-email-mst@kernel.org>
 <20230223023604-mutt-send-email-mst@kernel.org> <Y/fZm12yGIPnwaDX@fedora>
 <20230224034258-mutt-send-email-mst@kernel.org>
 <8611d901-0940-3747-c2cd-9c193c7f24f2@yandex-team.ru>
 <20230228094756-mutt-send-email-mst@kernel.org>
 <f3338868-d43a-a499-5db8-2fb06d244e37@yandex-team.ru>
 <20230228161602-mutt-send-email-mst@kernel.org>
 <e1f45021-071c-b8c4-69bd-85f8c29c669a@yandex-team.ru>
 <20230301094424-mutt-send-email-mst@kernel.org>
From: Anton Kuchin <antonkuchin@yandex-team.ru>
In-Reply-To: <20230301094424-mutt-send-email-mst@kernel.org>
Content-Language: en-US, ru-RU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
Cc: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>


On 01/03/2023 16:46, Michael S. Tsirkin wrote:
> On Wed, Mar 01, 2023 at 05:03:03PM +0300, Vladimir Sementsov-Ogievskiy wrote:
>> On 01.03.23 00:24, Michael S. Tsirkin wrote:
>>>> Said that checking on destination would need another flag and the safe
>>>> way of using this feature would require managing two flags instead of one
>>>> making it even more fragile. So I'd prefer not to make it more complex.
>>>>
>>>> In my opinion the best way to use this property by orchestrator is to
>>>> leave default unmigratable behavior at start and just before migration when
>>>> destination is known enumerate all vhost-user-fs devices and set properties
>>>> according to their backends capability with QMP like you mentioned. This
>>>> gives us single point of making the decision for each device and avoids
>>>> guessing future at VM start.
>>> this means that you need to remember what the values were and then
>>> any failure on destination requires you to go back and set them
>>> to original values.
>> Why do we need to restore old values?
> To get back to where you were before you were starting migration.
>
>> For me, this new property is a kind of per-device migration
>> capability. Do we care to restore migration capabilities to the values
>> that they had before setting them for failed migration? We don't need
>> it, as we just always set capabilities as we want before each
>> migration. Same thing for this new property: just set it properly
>> before migration and you don't need to care about restoring it after
>> failed migration attempt.
> If you really trust your management then we can just remove the
> migration blocker and be done with it. All this song and dance
> with changing properties is to catch errors. If one has to
> carefully play with QOM to achieve the desired result then
> IMHO we failed in this.

To be honest I would prefer just removing blocker because if orchestrator
doesn't know what it is doing it has lots of different ways to break
things and we can't do anything about it.
Just like vhost-user-scsi always allows migration since the day it was
introduced without additional checks and relies on the orchestrator.
But migration was blocked for vhost-user-fs when it was initially merged
and it is bad to change this contract now.

This property here is not only to block migration by default and catch
errors but really to select migration type. External migration can be
sometimes preferred even after internal is implemented because it requires
less calls to backend to extract internal state, less code to execute in
order to save and restore daemon state.
And this also will allow compatibility with old VMs that support only
external migration to move to internal migration without reboot someday
when it is implemented.

So catching errors in not the only purpose of this property, but it 
definitely
allows us to catch some obvious ones.

>
>>> With possibility of crashes on the orchestrator
>>> you also need to recall the temporary values in some file ...
>>> This is huge complexity much worse than two flags.
>>>
>>> Assuming we need two let's see whether just reload on source is good
>>> enough.
>>>
>> -- 
>> Best regards,
>> Vladimir

