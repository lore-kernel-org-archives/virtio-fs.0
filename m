Return-Path: <hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
Date: Mon, 16 Oct 2023 15:42:43 +0200
Message-ID: <20231016134243.68248-8-hreitz@redhat.com>
In-Reply-To: <20231016134243.68248-1-hreitz@redhat.com>
References: <20231016134243.68248-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v5 7/7] vhost-user-fs: Implement internal
 migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Hanna Czenczek <hreitz@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>

A virtio-fs device's VM state consists of:
- the virtio device (vring) state (VMSTATE_VIRTIO_DEVICE)
- the back-end's (virtiofsd's) internal state

We get/set the latter via the new vhost operations to transfer migratory
state.  It is its own dedicated subsection, so that for external
migration, it can be disabled.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
---
 hw/virtio/vhost-user-fs.c | 101 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 49d699ffc2..eb91723855 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -298,9 +298,108 @@ static struct vhost_dev *vuf_get_vhost(VirtIODevice *vdev)
     return &fs->vhost_dev;
 }
 
+/**
+ * Fetch the internal state from virtiofsd and save it to `f`.
+ */
+static int vuf_save_state(QEMUFile *f, void *pv, size_t size,
+                          const VMStateField *field, JSONWriter *vmdesc)
+{
+    VirtIODevice *vdev = pv;
+    VHostUserFS *fs = VHOST_USER_FS(vdev);
+    Error *local_error = NULL;
+    int ret;
+
+    ret = vhost_save_backend_state(&fs->vhost_dev, f, &local_error);
+    if (ret < 0) {
+        error_reportf_err(local_error,
+                          "Error saving back-end state of %s device %s "
+                          "(tag: \"%s\"): ",
+                          vdev->name, vdev->parent_obj.canonical_path,
+                          fs->conf.tag ?: "<none>");
+        return ret;
+    }
+
+    return 0;
+}
+
+/**
+ * Load virtiofsd's internal state from `f` and send it over to virtiofsd.
+ */
+static int vuf_load_state(QEMUFile *f, void *pv, size_t size,
+                          const VMStateField *field)
+{
+    VirtIODevice *vdev = pv;
+    VHostUserFS *fs = VHOST_USER_FS(vdev);
+    Error *local_error = NULL;
+    int ret;
+
+    ret = vhost_load_backend_state(&fs->vhost_dev, f, &local_error);
+    if (ret < 0) {
+        error_reportf_err(local_error,
+                          "Error loading back-end state of %s device %s "
+                          "(tag: \"%s\"): ",
+                          vdev->name, vdev->parent_obj.canonical_path,
+                          fs->conf.tag ?: "<none>");
+        return ret;
+    }
+
+    return 0;
+}
+
+static bool vuf_is_internal_migration(void *opaque)
+{
+    /* TODO: Return false when an external migration is requested */
+    return true;
+}
+
+static int vuf_check_migration_support(void *opaque)
+{
+    VirtIODevice *vdev = opaque;
+    VHostUserFS *fs = VHOST_USER_FS(vdev);
+
+    if (!vhost_supports_device_state(&fs->vhost_dev)) {
+        error_report("Back-end of %s device %s (tag: \"%s\") does not support "
+                     "migration through qemu",
+                     vdev->name, vdev->parent_obj.canonical_path,
+                     fs->conf.tag ?: "<none>");
+        return -ENOTSUP;
+    }
+
+    return 0;
+}
+
+static const VMStateDescription vuf_backend_vmstate;
+
 static const VMStateDescription vuf_vmstate = {
     .name = "vhost-user-fs",
-    .unmigratable = 1,
+    .version_id = 0,
+    .fields = (VMStateField[]) {
+        VMSTATE_VIRTIO_DEVICE,
+        VMSTATE_END_OF_LIST()
+    },
+    .subsections = (const VMStateDescription * []) {
+        &vuf_backend_vmstate,
+        NULL,
+    }
+};
+
+static const VMStateDescription vuf_backend_vmstate = {
+    .name = "vhost-user-fs-backend",
+    .version_id = 0,
+    .needed = vuf_is_internal_migration,
+    .pre_load = vuf_check_migration_support,
+    .pre_save = vuf_check_migration_support,
+    .fields = (VMStateField[]) {
+        {
+            .name = "back-end",
+            .info = &(const VMStateInfo) {
+                .name = "virtio-fs back-end state",
+                .get = vuf_load_state,
+                .put = vuf_save_state,
+            },
+        },
+        VMSTATE_END_OF_LIST()
+    },
 };
 
 static Property vuf_properties[] = {
-- 
2.41.0

