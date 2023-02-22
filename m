Return-Path: <vsementsov@yandex-team.ru>
Message-ID: <a830d527-c19b-da89-65d9-a6986a4b47aa@yandex-team.ru>
Date: Wed, 22 Feb 2023 18:15:13 +0300
MIME-Version: 1.0
References: <20230217170038.1273710-1-antonkuchin@yandex-team.ru>
 <20230217170038.1273710-2-antonkuchin@yandex-team.ru>
 <59165bde-bfd4-a073-c618-205be3951e4a@yandex-team.ru>
 <110cd713-b01f-5fce-eb32-4ddb6c42685f@yandex-team.ru>
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
In-Reply-To: <110cd713-b01f-5fce-eb32-4ddb6c42685f@yandex-team.ru>
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
To: Anton Kuchin <antonkuchin@yandex-team.ru>
Cc: qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>

On 22.02.23 17:21, Anton Kuchin wrote:
>>>
>>
>> 1. I see, other similar qdev_prop_* use DEFINE_PROP_SIGNED
> 
> I don't think this should be signed. Enum values are non-negative so compilers
> (at least gcc and clang that I checked) evaluate underlying enum type to be unsigned int.
> I don't know why other property types use signed, may be they have reasons or just this
> is how they were initially implemented.
> 
>> 2. All of them except only qdev_prop_fdc_drive_type, define also a convenient macro in include/hw/qdev-properties-system.h
> 
> This makes sense if property is used in more than one place, in this case I don't see any
> benefit from writing more code to handle this specific case. Maybe if property finds its
> usage in other devices this can be done.

Reasonable, thanks!

-- 
Best regards,
Vladimir

