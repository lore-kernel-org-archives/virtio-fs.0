Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
In-Reply-To: <CAJSP0QUANuLkOjkLsB4LqKdi5_sJj+y6zK5vgcNmYZ5BLQ73rQ@mail.gmail.com>
 (Stefan Hajnoczi's message of "Tue, 24 Jan 2023 07:48:12 -0500")
References: <20230120085534-mutt-send-email-mst@kernel.org>
 <703d527f-de92-090c-6ce1-af0dec7de033@yandex-team.ru>
 <20230122030455-mutt-send-email-mst@kernel.org>
 <b7de3adc-cba7-09eb-ea93-f4bfb91bea9e@yandex-team.ru>
 <20230122093903-mutt-send-email-mst@kernel.org>
 <70c0f00a-7828-3ccf-c2ea-49aeef8693e9@yandex-team.ru>
 <20230122111618-mutt-send-email-mst@kernel.org>
 <Y87Ri4r6SiETdCrt@work-vm> <Y87lv8fXrYpxkK/3@fedora>
 <CAJSP0QV5wfXxhvjjFnLLUCvmSxiHxTPXh4qQJwHhnKdBu3EOQQ@mail.gmail.com>
 <Y8+p8HFG8NxYlfoo@work-vm>
 <CAJSP0QUANuLkOjkLsB4LqKdi5_sJj+y6zK5vgcNmYZ5BLQ73rQ@mail.gmail.com>
Reply-To: quintela@redhat.com
Date: Wed, 01 Feb 2023 15:37:10 +0100
Message-ID: <87cz6te9k9.fsf@secure.mitica>
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
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, qemu-devel <qemu-devel@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, yc-core@yandex-team.ru

Stefan Hajnoczi <stefanha@gmail.com> wrote:
> On Tue, Jan 24, 2023, 04:50 Dr. David Alan Gilbert <dgilbert@redhat.com>
> wrote:

[...]

>> > I checked how bad the situation is. libvhost-user currently enables
>> > LOG_ALL by default. :(
>> >
>> > So I don't think the front-end can use LOG_ALL alone to determine
>> > whether or not migration is supported by the back-end.
>> >
>> > There are several existing back-ends based on libvhost-user that have
>> > no concept of reconnection or migration but report the LOG_ALL feature
>> > bit.
>>
>> Ouch, yes that's messy.
>>
>> Going back to the original question; I don't think a command line flag
>> will work though, because even for a given VM there's the possibility
>> of some (local) migrations working but other (remote) migrations not
>> working; so you don't know at the point you start the VM whether
>> your migrations are going to work.
>>
>
> The user or management tool should know which types of migration a
> vhost-user-fs backend supports. That can be passed in as a per-device
> parameter.
>
> Then a migration parameter can be used to distinguish between same host and
> remote host migration? QEMU already distinguishes between pre-copy and
> post-copy migration, so this can be thought of as yet another type of
> migration.

I was going to suggest this (my previous answer was after reading only
the other part of the comments).

What we have here is that this device has "three" states:
- You can't migrate it to other host (now and the default behaviour)
- You can migrate some of the backends if you are migrating in the same
  host (note, we don't know directly that we are migrating inside the
  same host, so I would agree to add _that_ migration capability, that
  is related to migration, and it makes sense for migration code and
  devices to know that is happening)
- In the future, perhaps, you can migrate "always" some vhost-use-fs,
  that would be a property on my opinion.

Later, Juan.

