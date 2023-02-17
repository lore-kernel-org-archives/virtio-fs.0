Return-Path: <antonkuchin@yandex-team.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
 s=default; 
 t=1676653259; bh=ElC44zDuXKHsXhZI+PshUzHKnTsHBHxKXXZurHdcMeg=;
 h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
 b=cVQOCsMN9xu2ne/YnXgcAWm31e4lGq7v2S4bcOGp6E8VzIqx5tfRJkxikNb5fCy6z
 761tfj73ybSHrhfkjLIQm/ZZkdbivz5Srn+6g2c61sn3rEQTKPJ2XsghY34miH08gA
 N+uqTEEoaFxPn/yE06bLFMbtIhCxkeGVK+WYOvYE=
From: Anton Kuchin <antonkuchin@yandex-team.ru>
Date: Fri, 17 Feb 2023 19:00:38 +0200
Message-Id: <20230217170038.1273710-2-antonkuchin@yandex-team.ru>
In-Reply-To: <20230217170038.1273710-1-antonkuchin@yandex-team.ru>
References: <20230217170038.1273710-1-antonkuchin@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v3 1/1] vhost-user-fs: add migration type
 property
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>

Migration of vhost-user-fs device requires transfer of FUSE internal state
from backend. There is no standard way to do it now so by default migration
must be blocked. But if this state can be externally transferred by
orchestrator give it an option to explicitly allow migration.

Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
---
 hw/core/qdev-properties-system.c    | 10 +++++++++
 hw/virtio/vhost-user-fs.c           | 32 ++++++++++++++++++++++++++++-
 include/hw/qdev-properties-system.h |  1 +
 include/hw/virtio/vhost-user-fs.h   |  2 ++
 qapi/migration.json                 | 16 +++++++++++++++
 5 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/hw/core/qdev-properties-system.c b/hw/core/qdev-properties-sys=
tem.c
index d42493f630..d9b1aa2a5d 100644
--- a/hw/core/qdev-properties-system.c
+++ b/hw/core/qdev-properties-system.c
@@ -1143,3 +1143,13 @@ const PropertyInfo qdev_prop_uuid =3D {
     .set   =3D set_uuid,
     .set_default_value =3D set_default_uuid_auto,
 };
+
+const PropertyInfo qdev_prop_vhost_user_migration_type =3D {
+    .name =3D "VhostUserMigrationType",
+    .description =3D "none/external",
+    .enum_table =3D &VhostUserMigrationType_lookup,
+    .get =3D qdev_propinfo_get_enum,
+    .set =3D qdev_propinfo_set_enum,
+    .set_default_value =3D qdev_propinfo_set_default_value_enum,
+    .realized_set_allowed =3D true,
+};
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 83fc20e49e..7deb9df5ec 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -298,9 +298,35 @@ static struct vhost_dev *vuf_get_vhost(VirtIODevice *v=
dev)
     return &fs->vhost_dev;
 }
=20
+static int vhost_user_fs_pre_save(void *opaque)
+{
+    VHostUserFS *fs =3D opaque;
+    g_autofree char *path =3D object_get_canonical_path(OBJECT(fs));
+
+    switch (fs->migration_type) {
+    case VHOST_USER_MIGRATION_TYPE_NONE:
+        error_report("Migration is blocked by device %s", path);
+        break;
+    case VHOST_USER_MIGRATION_TYPE_EXTERNAL:
+        return 0;
+    default:
+        error_report("Migration type '%s' is not supported by device %s",
+                     VhostUserMigrationType_str(fs->migration_type), path)=
;
+        break;
+    }
+
+    return -1;
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
@@ -309,6 +335,10 @@ static Property vuf_properties[] =3D {
     DEFINE_PROP_UINT16("num-request-queues", VHostUserFS,
                        conf.num_request_queues, 1),
     DEFINE_PROP_UINT16("queue-size", VHostUserFS, conf.queue_size, 128),
+    DEFINE_PROP_UNSIGNED("migration", VHostUserFS, migration_type,
+                         VHOST_USER_MIGRATION_TYPE_NONE,
+                         qdev_prop_vhost_user_migration_type,
+                         VhostUserMigrationType),
     DEFINE_PROP_END_OF_LIST(),
 };
=20
diff --git a/include/hw/qdev-properties-system.h b/include/hw/qdev-properti=
es-system.h
index 0ac327ae60..1a67591590 100644
--- a/include/hw/qdev-properties-system.h
+++ b/include/hw/qdev-properties-system.h
@@ -22,6 +22,7 @@ extern const PropertyInfo qdev_prop_audiodev;
 extern const PropertyInfo qdev_prop_off_auto_pcibar;
 extern const PropertyInfo qdev_prop_pcie_link_speed;
 extern const PropertyInfo qdev_prop_pcie_link_width;
+extern const PropertyInfo qdev_prop_vhost_user_migration_type;
=20
 #define DEFINE_PROP_PCI_DEVFN(_n, _s, _f, _d)                   \
     DEFINE_PROP_SIGNED(_n, _s, _f, _d, qdev_prop_pci_devfn, int32_t)
diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-us=
er-fs.h
index 94c3aaa84e..821b2a121c 100644
--- a/include/hw/virtio/vhost-user-fs.h
+++ b/include/hw/virtio/vhost-user-fs.h
@@ -19,6 +19,7 @@
 #include "hw/virtio/vhost-user.h"
 #include "chardev/char-fe.h"
 #include "qom/object.h"
+#include "qapi/qapi-types-migration.h"
=20
 #define TYPE_VHOST_USER_FS "vhost-user-fs-device"
 OBJECT_DECLARE_SIMPLE_TYPE(VHostUserFS, VHOST_USER_FS)
@@ -40,6 +41,7 @@ struct VHostUserFS {
     VirtQueue **req_vqs;
     VirtQueue *hiprio_vq;
     int32_t bootindex;
+    VhostUserMigrationType migration_type;
=20
     /*< public >*/
 };
diff --git a/qapi/migration.json b/qapi/migration.json
index c84fa10e86..78feb20ffc 100644
--- a/qapi/migration.json
+++ b/qapi/migration.json
@@ -2178,3 +2178,19 @@
   'data': { 'job-id': 'str',
             'tag': 'str',
             'devices': ['str'] } }
+
+##
+# @VhostUserMigrationType:
+#
+# Type of vhost-user device migration.
+#
+# @none: Migration is not supported, attempts to migrate with this device
+#        will be blocked.
+#
+# @external: Migration stream contains only virtio device state,
+#            daemon state should be transferred externally by orchestrator=
.
+#
+# Since: 8.0
+##
+{ 'enum': 'VhostUserMigrationType',
+  'data': [ 'none', 'external' ] }
--=20
2.37.2

