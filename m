Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=XUB6cR9JBrNPmRFfOsT/1zkSyprTCJ6W0DOlOHGFNMo=;
 b=PQa7T23OUB8NsIBTOFuSCu8kACGj6TDADh0kpBEKeu6gCnaXcs421Hn1Sj3Zgaq9rN
 +hrMjZ7xPHiVZAhMP0so4TEuO/I0JHUrqZMM0IhOLeJ27ZYJoYpHiecIxZ1AfXURRRBp
 LiXoHnGCufjwOaudZzEdGjlAz29cdPMIpAcsvdCtwnttfBA5QociM8+V+tRZKPib4JCJ
 3HRFcmIXnEpS++PTjGPFwzyA5vH3sP4mGd8jm3XdzczXBZgV0US9fqoqK4QVTzLjJcXh
 kamLDMfBTCpa2kdkG4IStJQVh54v28Xij05n1dt+IJbpX5D39/EWtXEqwLwewmkF3VDj
 Z2gg==
MIME-Version: 1.0
References: <20230115170903.3416105-1-antonkuchin@yandex-team.ru>
 <CAJSP0QVKUKgkBMw1PiN8-L8Ykhq=gfvNTTs4sf1tuzoqHu+GXw@mail.gmail.com>
 <0d57cc40-693b-b36c-a135-fdac60dd00ec@yandex-team.ru>
 <CAJSP0QUXB0kgsCSsmi8dpnJFYho2cR_2Liep=pGmp6WzDZ_7pw@mail.gmail.com>
 <d6bf0b9a-a167-817d-2c17-c2e472961155@yandex-team.ru>
In-Reply-To: <d6bf0b9a-a167-817d-2c17-c2e472961155@yandex-team.ru>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Thu, 19 Jan 2023 11:02:42 -0500
Message-ID: <CAJSP0QXXe6KgLN2PJvi-5GqcELhUKJPB2pUARL2ktO9TQYAq=g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
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
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, yc-core@yandex-team.ru, "Michael S. Tsirkin" <mst@redhat.com>

On Thu, 19 Jan 2023 at 10:29, Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
>
> On 19/01/2023 16:30, Stefan Hajnoczi wrote:
> > On Thu, 19 Jan 2023 at 07:43, Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
> >> On 18/01/2023 17:52, Stefan Hajnoczi wrote:
> >>> On Sun, 15 Jan 2023 at 12:21, Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
> >>>> Now any vhost-user-fs device makes VM unmigratable, that also prevents
> >>>> qemu update without stopping the VM. In most cases that makes sense
> >>>> because qemu has no way to transfer FUSE session state.
> >>>>
> >>>> But we can give an option to orchestrator to override this if it can
> >>>> guarantee that state will be preserved (e.g. it uses migration to
> >>>> update qemu and dst will run on the same host as src and use the same
> >>>> socket endpoints).
> >>>>
> >>>> This patch keeps default behavior that prevents migration with such devices
> >>>> but adds migration capability 'vhost-user-fs' to explicitly allow migration.
> >>>>
> >>>> Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
> >>>> ---
> >>>>    hw/virtio/vhost-user-fs.c | 25 ++++++++++++++++++++++++-
> >>>>    qapi/migration.json       |  7 ++++++-
> >>>>    2 files changed, 30 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> >>>> index f5049735ac..13d920423e 100644
> >>>> --- a/hw/virtio/vhost-user-fs.c
> >>>> +++ b/hw/virtio/vhost-user-fs.c
> >>>> @@ -24,6 +24,7 @@
> >>>>    #include "hw/virtio/vhost-user-fs.h"
> >>>>    #include "monitor/monitor.h"
> >>>>    #include "sysemu/sysemu.h"
> >>>> +#include "migration/migration.h"
> >>>>
> >>>>    static const int user_feature_bits[] = {
> >>>>        VIRTIO_F_VERSION_1,
> >>>> @@ -298,9 +299,31 @@ static struct vhost_dev *vuf_get_vhost(VirtIODevice *vdev)
> >>>>        return &fs->vhost_dev;
> >>>>    }
> >>>>
> >>>> +static int vhost_user_fs_pre_save(void *opaque)
> >>>> +{
> >>>> +    MigrationState *s = migrate_get_current();
> >>>> +
> >>>> +    if (!s->enabled_capabilities[MIGRATION_CAPABILITY_VHOST_USER_FS]) {
> >>>> +        error_report("Migration of vhost-user-fs devices requires internal FUSE "
> >>>> +                     "state of backend to be preserved. If orchestrator can "
> >>>> +                     "guarantee this (e.g. dst connects to the same backend "
> >>>> +                     "instance or backend state is migrated) set 'vhost-user-fs' "
> >>>> +                     "migration capability to true to enable migration.");
> >>>> +        return -1;
> >>>> +    }
> >>>> +
> >>>> +    return 0;
> >>>> +}
> >>>> +
> >>>>    static const VMStateDescription vuf_vmstate = {
> >>>>        .name = "vhost-user-fs",
> >>>> -    .unmigratable = 1,
> >>>> +    .minimum_version_id = 0,
> >>>> +    .version_id = 0,
> >>>> +    .fields = (VMStateField[]) {
> >>>> +        VMSTATE_VIRTIO_DEVICE,
> >>>> +        VMSTATE_END_OF_LIST()
> >>>> +    },
> >>>> +   .pre_save = vhost_user_fs_pre_save,
> >>>>    };
> >>> Will it be possible to extend this vmstate when virtiofsd adds support
> >>> for stateful migration without breaking migration compatibility?
> >>>
> >>> If not, then I think a marker field should be added to the vmstate:
> >>> 0 - stateless/reconnect migration (the approach you're adding in this patch)
> >>> 1 - stateful migration (future virtiofsd feature)
> >>>
> >>> When the field is 0 there are no further vmstate fields and we trust
> >>> that the destination vhost-user-fs server already has the necessary
> >>> state.
> >>>
> >>> When the field is 1 there are additional vmstate fields that contain
> >>> the virtiofsd state.
> >>>
> >>> The goal is for QEMU to support 3 migration modes, depending on the
> >>> vhost-user-fs server:
> >>> 1. No migration support.
> >>> 2. Stateless migration.
> >>> 3. Stateful migration.
> >> Sure. These vmstate fields are very generic and mandatory for any
> >> virtio device. If in future more state can be transfer in migration
> >> stream the vmstate can be extended with additional fields. This can
> >> be done with new subsections and/or bumping version_id.
> > My concern is that the vmstate introduced in this patch may be
> > unusable when stateful migration is added. So additional compatibility
> > code will need to be introduced to make your stateless migration
> > continue working with extended vmstate.
> >
> > By adding a marker field in this patch it should be possible to
> > continue using the same vmstate for stateless migration without adding
> > extra compatibility code in the future.
> I understand, but this fields in vmstate just packs generic virtio
> device state that is accessible by qemu. All additional data could be
> added later by extra fields. I believe we couldn't pull off any type
> of virtio device migration without transferring virtqueues so more
> sophisticated types of migration would require adding more data and
> not modification to this part of vmstate.

What I'm saying is that your patch could define the vmstate such that
it that contains a field to differentiate between stateless and
stateful migration. That way QEMU versions that only support stateless
migration (this patch) will be able to migrate to future QEMU versions
that support both stateless and stateful without compatibility issues.

I'm not sure if my suggestion to add a marker field to vuf_vmstate is
the best way to do this, but have you thought of how to handle the
future addition of stateful migration to the vmstate without breaking
stateless vmstates? Maybe David Gilbert has a suggestion for how to do
this cleanly.

Stefan

