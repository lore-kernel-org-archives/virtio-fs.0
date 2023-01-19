Return-Path: <mst@redhat.com>
Date: Thu, 19 Jan 2023 07:51:37 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230119074602-mutt-send-email-mst@kernel.org>
References: <20230115170903.3416105-1-antonkuchin@yandex-team.ru>
MIME-Version: 1.0
In-Reply-To: <20230115170903.3416105-1-antonkuchin@yandex-team.ru>
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

On Sun, Jan 15, 2023 at 07:09:03PM +0200, Anton Kuchin wrote:
> Now any vhost-user-fs device makes VM unmigratable, that also prevents
> qemu update without stopping the VM. In most cases that makes sense
> because qemu has no way to transfer FUSE session state.
> 
> But we can give an option to orchestrator to override this if it can
> guarantee that state will be preserved (e.g. it uses migration to
> update qemu and dst will run on the same host as src and use the same
> socket endpoints).
> 
> This patch keeps default behavior that prevents migration with such devices
> but adds migration capability 'vhost-user-fs' to explicitly allow migration.
> 
> Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
> ---
>  hw/virtio/vhost-user-fs.c | 25 ++++++++++++++++++++++++-
>  qapi/migration.json       |  7 ++++++-
>  2 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index f5049735ac..13d920423e 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -24,6 +24,7 @@
>  #include "hw/virtio/vhost-user-fs.h"
>  #include "monitor/monitor.h"
>  #include "sysemu/sysemu.h"
> +#include "migration/migration.h"
>  
>  static const int user_feature_bits[] = {
>      VIRTIO_F_VERSION_1,
> @@ -298,9 +299,31 @@ static struct vhost_dev *vuf_get_vhost(VirtIODevice *vdev)
>      return &fs->vhost_dev;
>  }
>  
> +static int vhost_user_fs_pre_save(void *opaque)
> +{
> +    MigrationState *s = migrate_get_current();
> +
> +    if (!s->enabled_capabilities[MIGRATION_CAPABILITY_VHOST_USER_FS]) {
> +        error_report("Migration of vhost-user-fs devices requires internal FUSE "
> +                     "state of backend to be preserved. If orchestrator can "
> +                     "guarantee this (e.g. dst connects to the same backend "
> +                     "instance or backend state is migrated) set 'vhost-user-fs' "
> +                     "migration capability to true to enable migration.");

Isn't it possible that some backends are same and some are not?
Shouldn't this be a device property then?



> +        return -1;
> +    }
> +
> +    return 0;
> +}
> +
>  static const VMStateDescription vuf_vmstate = {
>      .name = "vhost-user-fs",
> -    .unmigratable = 1,
> +    .minimum_version_id = 0,
> +    .version_id = 0,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_VIRTIO_DEVICE,
> +        VMSTATE_END_OF_LIST()
> +    },
> +   .pre_save = vhost_user_fs_pre_save,
>  };
>  
>  static Property vuf_properties[] = {
> diff --git a/qapi/migration.json b/qapi/migration.json
> index 88ecf86ac8..9a229ea884 100644
> --- a/qapi/migration.json
> +++ b/qapi/migration.json
> @@ -477,6 +477,11 @@
>  #                    will be handled faster.  This is a performance feature and
>  #                    should not affect the correctness of postcopy migration.
>  #                    (since 7.1)
> +# @vhost-user-fs: If enabled, the migration process will allow migration of
> +#                 vhost-user-fs devices, this should be enabled only when
> +#                 backend can preserve local FUSE state e.g. for qemu update
> +#                 when dst reconects to the same endpoints after migration.
> +#                 (since 8.0)
>  #
>  # Features:
>  # @unstable: Members @x-colo and @x-ignore-shared are experimental.
> @@ -492,7 +497,7 @@
>             'dirty-bitmaps', 'postcopy-blocktime', 'late-block-activate',
>             { 'name': 'x-ignore-shared', 'features': [ 'unstable' ] },
>             'validate-uuid', 'background-snapshot',
> -           'zero-copy-send', 'postcopy-preempt'] }
> +           'zero-copy-send', 'postcopy-preempt', 'vhost-user-fs'] }

I kind of dislike that it's such a specific flag. Is only vhost-user-fs
ever going to be affected? Any way to put it in a way that is more generic?


>  ##
>  # @MigrationCapabilityStatus:
> -- 
> 2.34.1

