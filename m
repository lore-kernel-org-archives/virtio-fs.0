Return-Path: <antonkuchin@yandex-team.ru>
Message-ID: <f3338868-d43a-a499-5db8-2fb06d244e37@yandex-team.ru>
Date: Tue, 28 Feb 2023 19:59:54 +0200
MIME-Version: 1.0
References: <333c4451-8eef-0603-c3f5-10e38c0eb24e@yandex-team.ru>
 <20230222115106-mutt-send-email-mst@kernel.org>
 <11593688-7ca4-def3-6212-7c26faa4d1c6@yandex-team.ru>
 <20230222121133-mutt-send-email-mst@kernel.org>
 <a477ca70-8aea-6c16-122e-1ded4af11f49@yandex-team.ru>
 <20230222151814-mutt-send-email-mst@kernel.org>
 <20230223023604-mutt-send-email-mst@kernel.org> <Y/fZm12yGIPnwaDX@fedora>
 <20230224034258-mutt-send-email-mst@kernel.org>
 <8611d901-0940-3747-c2cd-9c193c7f24f2@yandex-team.ru>
 <20230228094756-mutt-send-email-mst@kernel.org>
From: Anton Kuchin <antonkuchin@yandex-team.ru>
In-Reply-To: <20230228094756-mutt-send-email-mst@kernel.org>
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

On 28/02/2023 16:57, Michael S. Tsirkin wrote:
> On Tue, Feb 28, 2023 at 04:30:36PM +0200, Anton Kuchin wrote:
>> I really don't understand why and what do you want to check on
>> destination.
> Yes I understand your patch controls source. Let me try to rephrase
> why I think it's better on destination.
> Here's my understanding
> - With vhost-user-fs state lives inside an external daemon.
> A- If after load you connect to the same daemon you can get migration mostly
>    for free.
> B- If you connect to a different daemon then that daemon will need
>    to pass information from original one.
>
> Is this a fair summary?
>
> Current solution is to set flag on the source meaning "I have an
> orchestration tool that will make sure that either A or B is correct".
>
> However both A and B can only be known when destination is known.
> Especially as long as what we are really trying to do is just allow qemu
> restarts, Checking the flag on load will thus achive it in a cleaner
> way, in that orchestration tool can reasonably keep the flag
> clear normally and only set it if restarting qemu locally.
>
>
> By comparison, with your approach orchestration tool will have
> to either always set the flag (risky since then we lose the
> extra check that we coded) or keep it clear and set before migration
> (complex).
>
> I hope I explained what and why I want to check.
>
> I am far from a vhost-user-fs expert so maybe I am wrong but
> I wanted to make sure I got the point across even if other
> disagree.
>

Thank you for the explanation. Now I understand your concerns.

You are right about this mechanism being a bit risky if orchestrator is
not using it properly or clunky if it is used in a safest possible way.
That's why first attempt of this feature was with migration capability
to let orchestrator choose behavior right at the moment of migration.
But it has its own problems.

We can't move this check only to destination because one of main goals
was to prevent orchestrators that are unaware of vhost-user-fs specifics
from accidentally migrating such VMs. We can't rely here entirely on
destination to block this because if VM is migrated to file and then
can't be loaded by destination there is no way to fallback and resume
the source so we need to have some kind of blocker on source by default.

Said that checking on destination would need another flag and the safe
way of using this feature would require managing two flags instead of one
making it even more fragile. So I'd prefer not to make it more complex.

In my opinion the best way to use this property by orchestrator is to
leave default unmigratable behavior at start and just before migration when
destination is known enumerate all vhost-user-fs devices and set properties
according to their backends capability with QMP like you mentioned. This
gives us single point of making the decision for each device and avoids
guessing future at VM start.
But allowing setup via command-line is valid too because some backends may
always be capable of external migration independent of hosts and don't need
the manipulations with QMP before migration at all.

