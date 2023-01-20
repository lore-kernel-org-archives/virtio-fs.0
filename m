Return-Path: <mst@redhat.com>
Date: Fri, 20 Jan 2023 08:58:59 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230120085534-mutt-send-email-mst@kernel.org>
References: <20230115170903.3416105-1-antonkuchin@yandex-team.ru>
 <20230119074602-mutt-send-email-mst@kernel.org>
 <f9993404-f8b8-7a23-37f8-530313783466@yandex-team.ru>
MIME-Version: 1.0
In-Reply-To: <f9993404-f8b8-7a23-37f8-530313783466@yandex-team.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, yc-core@yandex-team.ru

On Thu, Jan 19, 2023 at 03:45:06PM +0200, Anton Kuchin wrote:
> On 19/01/2023 14:51, Michael S. Tsirkin wrote:
> > On Sun, Jan 15, 2023 at 07:09:03PM +0200, Anton Kuchin wrote:
> > > Now any vhost-user-fs device makes VM unmigratable, that also prevents
> > > qemu update without stopping the VM. In most cases that makes sense
> > > because qemu has no way to transfer FUSE session state.
> > > 
> > > But we can give an option to orchestrator to override this if it can
> > > guarantee that state will be preserved (e.g. it uses migration to
> > > update qemu and dst will run on the same host as src and use the same
> > > socket endpoints).
> > > 
> > > This patch keeps default behavior that prevents migration with such devices
> > > but adds migration capability 'vhost-user-fs' to explicitly allow migration.
> > > 
> > > Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
> > > ---
> > >   hw/virtio/vhost-user-fs.c | 25 ++++++++++++++++++++++++-
> > >   qapi/migration.json       |  7 ++++++-
> > >   2 files changed, 30 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> > > index f5049735ac..13d920423e 100644
> > > --- a/hw/virtio/vhost-user-fs.c
> > > +++ b/hw/virtio/vhost-user-fs.c
> > > @@ -24,6 +24,7 @@
> > >   #include "hw/virtio/vhost-user-fs.h"
> > >   #include "monitor/monitor.h"
> > >   #include "sysemu/sysemu.h"
> > > +#include "migration/migration.h"
> > >   static const int user_feature_bits[] = {
> > >       VIRTIO_F_VERSION_1,
> > > @@ -298,9 +299,31 @@ static struct vhost_dev *vuf_get_vhost(VirtIODevice *vdev)
> > >       return &fs->vhost_dev;
> > >   }
> > > +static int vhost_user_fs_pre_save(void *opaque)
> > > +{
> > > +    MigrationState *s = migrate_get_current();
> > > +
> > > +    if (!s->enabled_capabilities[MIGRATION_CAPABILITY_VHOST_USER_FS]) {
> > > +        error_report("Migration of vhost-user-fs devices requires internal FUSE "
> > > +                     "state of backend to be preserved. If orchestrator can "
> > > +                     "guarantee this (e.g. dst connects to the same backend "
> > > +                     "instance or backend state is migrated) set 'vhost-user-fs' "
> > > +                     "migration capability to true to enable migration.");
> > Isn't it possible that some backends are same and some are not?
> > Shouldn't this be a device property then?
> If some are not the same it is not guaranteed that correct FUSE
> state is present there, so orchestrator shouldn't set the capability
> because this can result in destination devices being broken (they'll
> be fine after the remount in guest, but this is guest visible and is
> not acceptable).
> 
> I can imagine smart orchestrator and backend that can transfer
> internal FUSE state, but we are not there yet, and this would be
> their responsibility then to ensure endpoint compatibility between src
> and dst and set the capability (that's why I put "e.g." and "or" in
> the error description).

So instead of relying on the orchestrator how about making it a device
property?


> > 
> > 
> > 
> > > +        return -1;
> > > +    }
> > > +
> > > +    return 0;
> > > +}
> > > +
> > >   static const VMStateDescription vuf_vmstate = {
> > >       .name = "vhost-user-fs",
> > > -    .unmigratable = 1,
> > > +    .minimum_version_id = 0,
> > > +    .version_id = 0,
> > > +    .fields = (VMStateField[]) {
> > > +        VMSTATE_VIRTIO_DEVICE,
> > > +        VMSTATE_END_OF_LIST()
> > > +    },
> > > +   .pre_save = vhost_user_fs_pre_save,
> > >   };
> > >   static Property vuf_properties[] = {
> > > diff --git a/qapi/migration.json b/qapi/migration.json
> > > index 88ecf86ac8..9a229ea884 100644
> > > --- a/qapi/migration.json
> > > +++ b/qapi/migration.json
> > > @@ -477,6 +477,11 @@
> > >   #                    will be handled faster.  This is a performance feature and
> > >   #                    should not affect the correctness of postcopy migration.
> > >   #                    (since 7.1)
> > > +# @vhost-user-fs: If enabled, the migration process will allow migration of
> > > +#                 vhost-user-fs devices, this should be enabled only when
> > > +#                 backend can preserve local FUSE state e.g. for qemu update
> > > +#                 when dst reconects to the same endpoints after migration.
> > > +#                 (since 8.0)
> > >   #
> > >   # Features:
> > >   # @unstable: Members @x-colo and @x-ignore-shared are experimental.
> > > @@ -492,7 +497,7 @@
> > >              'dirty-bitmaps', 'postcopy-blocktime', 'late-block-activate',
> > >              { 'name': 'x-ignore-shared', 'features': [ 'unstable' ] },
> > >              'validate-uuid', 'background-snapshot',
> > > -           'zero-copy-send', 'postcopy-preempt'] }
> > > +           'zero-copy-send', 'postcopy-preempt', 'vhost-user-fs'] }
> > I kind of dislike that it's such a specific flag. Is only vhost-user-fs
> > ever going to be affected? Any way to put it in a way that is more generic?
> Here I agree with you: I would prefer less narrow naming too. But I
> didn't manage to come up with one. Looks like many other vhost-user
> devices could benefit from this so maybe "vhost-user-stateless" or
> something like this would be better.
> I'm not sure that other types of devices could handle reconnect to
> the old endpoint as easy as vhost-user-fs, but anyway the support for
> this flag needs to be implemented for each device individually.
> What do you think? Any ideas would be appreciated.

Let's try to create a better description of when this flag should be
set. Then shorten it up to create the name.

> > 
> > 
> > >   ##
> > >   # @MigrationCapabilityStatus:
> > > -- 
> > > 2.34.1

