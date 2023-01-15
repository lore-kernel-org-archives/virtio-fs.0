Return-Path: <antonkuchin@yandex-team.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
 s=default; 
 t=1673802564; bh=gYBigg0oZoGfpt5W5DeIaCno9S/czkxTzwzpov2eMTQ=;
 h=Message-Id:Date:Cc:Subject:To:From;
 b=A5Lgc5q07ISAmQwKstUoLUdcwRRgqvuHXxQbg6/hW82UsqFThYwgjnEg7B9fZxHs5
 9JG45l3qTLOBCl7F/bBHCE4pf6PLsvS0R3qR3THAh4BIh/mEUhySxCxolAQ482eVl/
 h+/ohCI+2P45mEATci5l2Dkr/hwo4oqcHPhvtQBo=
From: Anton Kuchin <antonkuchin@yandex-team.ru>
Date: Sun, 15 Jan 2023 19:09:03 +0200
Message-Id: <20230115170903.3416105-1-antonkuchin@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH] vhost-user-fs: add capability to allow migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, yc-core@yandex-team.ru, "Michael S. Tsirkin" <mst@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>

Now any vhost-user-fs device makes VM unmigratable, that also prevents
qemu update without stopping the VM. In most cases that makes sense
because qemu has no way to transfer FUSE session state.

But we can give an option to orchestrator to override this if it can
guarantee that state will be preserved (e.g. it uses migration to
update qemu and dst will run on the same host as src and use the same
socket endpoints).

This patch keeps default behavior that prevents migration with such devices
but adds migration capability 'vhost-user-fs' to explicitly allow migration=
.

Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
---
 hw/virtio/vhost-user-fs.c | 25 ++++++++++++++++++++++++-
 qapi/migration.json       |  7 ++++++-
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index f5049735ac..13d920423e 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -24,6 +24,7 @@
 #include "hw/virtio/vhost-user-fs.h"
 #include "monitor/monitor.h"
 #include "sysemu/sysemu.h"
+#include "migration/migration.h"
=20
 static const int user_feature_bits[] =3D {
     VIRTIO_F_VERSION_1,
@@ -298,9 +299,31 @@ static struct vhost_dev *vuf_get_vhost(VirtIODevice *v=
dev)
     return &fs->vhost_dev;
 }
=20
+static int vhost_user_fs_pre_save(void *opaque)
+{
+    MigrationState *s =3D migrate_get_current();
+
+    if (!s->enabled_capabilities[MIGRATION_CAPABILITY_VHOST_USER_FS]) {
+        error_report("Migration of vhost-user-fs devices requires internal=
 FUSE "
+                     "state of backend to be preserved. If orchestrator ca=
n "
+                     "guarantee this (e.g. dst connects to the same backen=
d "
+                     "instance or backend state is migrated) set 'vhost-us=
er-fs' "
+                     "migration capability to true to enable migration.");
+        return -1;
+    }
+
+    return 0;
+}
+
 static const VMStateDescription vuf_vmstate =3D {
     .name =3D "vhost-user-fs",
-    .unmigratable =3D 1,
+    .minimum_version_id =3D 0,
+    .version_id =3D 0,
+    .fields =3D (VMStateField[]) {
+        VMSTATE_VIRTIO_DEVICE,
+        VMSTATE_END_OF_LIST()
+    },
+   .pre_save =3D vhost_user_fs_pre_save,
 };
=20
 static Property vuf_properties[] =3D {
diff --git a/qapi/migration.json b/qapi/migration.json
index 88ecf86ac8..9a229ea884 100644
--- a/qapi/migration.json
+++ b/qapi/migration.json
@@ -477,6 +477,11 @@
 #                    will be handled faster.  This is a performance featur=
e and
 #                    should not affect the correctness of postcopy migrati=
on.
 #                    (since 7.1)
+# @vhost-user-fs: If enabled, the migration process will allow migration o=
f
+#                 vhost-user-fs devices, this should be enabled only when
+#                 backend can preserve local FUSE state e.g. for qemu upda=
te
+#                 when dst reconects to the same endpoints after migration=
.
+#                 (since 8.0)
 #
 # Features:
 # @unstable: Members @x-colo and @x-ignore-shared are experimental.
@@ -492,7 +497,7 @@
            'dirty-bitmaps', 'postcopy-blocktime', 'late-block-activate',
            { 'name': 'x-ignore-shared', 'features': [ 'unstable' ] },
            'validate-uuid', 'background-snapshot',
-           'zero-copy-send', 'postcopy-preempt'] }
+           'zero-copy-send', 'postcopy-preempt', 'vhost-user-fs'] }
=20
 ##
 # @MigrationCapabilityStatus:
--=20
2.34.1

