Return-Path: <antonkuchin@yandex-team.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
 s=default; 
 t=1679079762; bh=atoonpkq3IJ2La7naowo9a/0fBLKS7sTrPxqbv5SS+c=;
 h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
 b=QPLhrhstKkHRk5XMBJ8FLJtvlxX/VxPUFHwcTDShN+pToPHRB7d9d8kvFioVYDw7P
 u1aEsg1IFKTpKT2RJ2wTwKBUuL9aBX3GVonKEPYY42xzdhTT4Vjq8KdfZD1MXNv3hh
 V9+xeTb0n7koEkvqhbBX98V9lZ3wVXr4bVX+nSg0=
Message-ID: <66485897-4b7c-ec86-93ad-9ce62ce57606@yandex-team.ru>
Date: Fri, 17 Mar 2023 21:02:38 +0200
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
 <20230301102757-mutt-send-email-mst@kernel.org>
From: Anton Kuchin <antonkuchin@yandex-team.ru>
In-Reply-To: <20230301102757-mutt-send-email-mst@kernel.org>
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>

On 01/03/2023 17:33, Michael S. Tsirkin wrote:
> On Tue, Feb 28, 2023 at 07:59:54PM +0200, Anton Kuchin wrote:
>> We can't rely here entirely on
>> destination to block this because if VM is migrated to file and then
>> can't be loaded by destination there is no way to fallback and resume
>> the source so we need to have some kind of blocker on source by default.
> So I commented about a fallback. IMO it's just orchestrator being silly:
> don't kill source qemu until you have made sure destination loaded the
> file, or re-load it, and all will be well.

I agree that it is always better to keep source alive until destination
is loaded and ready to take-off. But in some cases resources are limited
or strictly partitioned so we can't keep two VMs alive at the same time
so the bast option is to check all we need on the source to make sure
destination will run.
Off the top of my head host-size VM would need entire additional host to
migrate properly and lots of memory streaming that can cause huge downtime,
but if memory is in shmem local migration to update qemu can take as much
as just saving device state to file and running new qemu to load devices,
take-over memory and continue running guest.

>
> But a bigger issue that this highlights is simply that if migrating to
> file you have no idea at all where will the file be loaded.  Maybe some
> orchestrators know but I don't see how we can be sure all of them know.
> The only time where we know whether the file is loaded on the same host
> where it was saved is when we actually load it.
>

Yes. Migration to file requires orchestrator to be well aware of what
it is doing because file always contains only part of the state. This
is hard but sometimes there are no other good options.

