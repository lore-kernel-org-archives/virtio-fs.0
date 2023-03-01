Return-Path: <vsementsov@yandex-team.ru>
Message-ID: <e1f45021-071c-b8c4-69bd-85f8c29c669a@yandex-team.ru>
Date: Wed, 1 Mar 2023 17:03:03 +0300
MIME-Version: 1.0
References: <11593688-7ca4-def3-6212-7c26faa4d1c6@yandex-team.ru>
 <20230222121133-mutt-send-email-mst@kernel.org>
 <a477ca70-8aea-6c16-122e-1ded4af11f49@yandex-team.ru>
 <20230222151814-mutt-send-email-mst@kernel.org>
 <20230223023604-mutt-send-email-mst@kernel.org> <Y/fZm12yGIPnwaDX@fedora>
 <20230224034258-mutt-send-email-mst@kernel.org>
 <8611d901-0940-3747-c2cd-9c193c7f24f2@yandex-team.ru>
 <20230228094756-mutt-send-email-mst@kernel.org>
 <f3338868-d43a-a499-5db8-2fb06d244e37@yandex-team.ru>
 <20230228161602-mutt-send-email-mst@kernel.org>
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
In-Reply-To: <20230228161602-mutt-send-email-mst@kernel.org>
Content-Language: en-US
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
To: "Michael S. Tsirkin" <mst@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>

On 01.03.23 00:24, Michael S. Tsirkin wrote:
>> Said that checking on destination would need another flag and the safe
>> way of using this feature would require managing two flags instead of one
>> making it even more fragile. So I'd prefer not to make it more complex.
>>
>> In my opinion the best way to use this property by orchestrator is to
>> leave default unmigratable behavior at start and just before migration when
>> destination is known enumerate all vhost-user-fs devices and set properties
>> according to their backends capability with QMP like you mentioned. This
>> gives us single point of making the decision for each device and avoids
>> guessing future at VM start.
> this means that you need to remember what the values were and then
> any failure on destination requires you to go back and set them
> to original values. 

Why do we need to restore old values?

For me, this new property is a kind of per-device migration capability. Do we care to restore migration capabilities to the values that they had before setting them for failed migration? We don't need it, as we just always set capabilities as we want before each migration. Same thing for this new property: just set it properly before migration and you don't need to care about restoring it after failed migration attempt.

> With possibility of crashes on the orchestrator
> you also need to recall the temporary values in some file ...
> This is huge complexity much worse than two flags.
> 
> Assuming we need two let's see whether just reload on source is good
> enough.
> 

-- 
Best regards,
Vladimir

