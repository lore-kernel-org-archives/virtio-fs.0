Return-Path: <hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
Date: Mon, 13 Mar 2023 18:48:33 +0100
Message-Id: <20230313174833.28790-3-hreitz@redhat.com>
In-Reply-To: <20230313174833.28790-1-hreitz@redhat.com>
References: <20230313174833.28790-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC 2/2] vhost-user-fs: Implement stateful migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Hanna Czenczek <hreitz@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Dr . David Alan Gilbert" <dgilbert@redhat.com>, Juan Quintela <quintela@redhat.com>

A virtio-fs device's VM state consists of:
- the virtio device (vring) state (VMSTATE_VIRTIO_DEVICE)
- the back-end's (virtiofsd's) internal state

We get/set the latter via the new vhost-user operations FS_SET_STATE_FD,
FS_GET_STATE, and FS_SET_STATE.

Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
---
 hw/virtio/vhost-user-fs.c | 171 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 170 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 83fc20e49e..df1fb02acc 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -20,8 +20,10 @@
 #include "hw/virtio/virtio-bus.h"
 #include "hw/virtio/virtio-access.h"
 #include "qemu/error-report.h"
+#include "qemu/memfd.h"
 #include "hw/virtio/vhost.h"
 #include "hw/virtio/vhost-user-fs.h"
+#include "migration/qemu-file-types.h"
 #include "monitor/monitor.h"
 #include "sysemu/sysemu.h"
 
@@ -298,9 +300,176 @@ static struct vhost_dev *vuf_get_vhost(VirtIODevice *vdev)
     return &fs->vhost_dev;
 }
 
+/**
+ * Fetch the internal state from the back-end (virtiofsd) and save it
+ * to `f`.
+ */
+static int vuf_save_state(QEMUFile *f, void *pv, size_t size,
+                          const VMStateField *field, JSONWriter *vmdesc)
+{
+    VirtIODevice *vdev = pv;
+    VHostUserFS *fs = VHOST_USER_FS(vdev);
+    int memfd = -1;
+    /* Size of the shared memory through which to transfer the state */
+    const size_t chunk_size = 4 * 1024 * 1024;
+    size_t state_offset;
+    ssize_t remaining;
+    void *shm_buf;
+    Error *local_err = NULL;
+    int ret, ret2;
+
+    /* Set up shared memory through which to receive the state from virtiofsd */
+    shm_buf = qemu_memfd_alloc("vhost-fs-state", chunk_size,
+                               F_SEAL_SEAL | F_SEAL_SHRINK | F_SEAL_GROW,
+                               &memfd, &local_err);
+    if (!shm_buf) {
+        error_report_err(local_err);
+        ret = -ENOMEM;
+        goto early_fail;
+    }
+
+    /* Share the SHM area with virtiofsd */
+    ret = vhost_fs_set_state_fd(&fs->vhost_dev, memfd, chunk_size);
+    if (ret < 0) {
+        goto early_fail;
+    }
+
+    /* Receive the virtiofsd state in chunks, and write them to `f` */
+    state_offset = 0;
+    do {
+        size_t this_chunk_size;
+
+        remaining = vhost_fs_get_state(&fs->vhost_dev, state_offset,
+                                       chunk_size);
+        if (remaining < 0) {
+            ret = remaining;
+            goto fail;
+        }
+
+        /* Prefix the whole state by its total length */
+        if (state_offset == 0) {
+            qemu_put_be64(f, remaining);
+        }
+
+        this_chunk_size = MIN(remaining, chunk_size);
+        qemu_put_buffer(f, shm_buf, this_chunk_size);
+        state_offset += this_chunk_size;
+    } while (remaining >= chunk_size);
+
+    ret = 0;
+fail:
+    /* Have virtiofsd close the shared memory */
+    ret2 = vhost_fs_set_state_fd(&fs->vhost_dev, -1, 0);
+    if (ret2 < 0) {
+        error_report("Failed to remove state FD from the vhost-user-fs back "
+                     "end: %s", strerror(-ret));
+        if (ret == 0) {
+            ret = ret2;
+        }
+    }
+
+early_fail:
+    if (shm_buf) {
+        qemu_memfd_free(shm_buf, chunk_size, memfd);
+    }
+
+    return ret;
+}
+
+/**
+ * Load the back-end's (virtiofsd's) internal state from `f` and send
+ * it over to that back-end.
+ */
+static int vuf_load_state(QEMUFile *f, void *pv, size_t size,
+                          const VMStateField *field)
+{
+    VirtIODevice *vdev = pv;
+    VHostUserFS *fs = VHOST_USER_FS(vdev);
+    int memfd = -1;
+    /* Size of the shared memory through which to transfer the state */
+    const size_t chunk_size = 4 * 1024 * 1024;
+    size_t state_offset;
+    uint64_t remaining;
+    void *shm_buf;
+    Error *local_err = NULL;
+    int ret, ret2;
+
+    /* The state is prefixed by its total length, read that first */
+    remaining = qemu_get_be64(f);
+
+    /* Set up shared memory through which to send the state to virtiofsd */
+    shm_buf = qemu_memfd_alloc("vhost-fs-state", chunk_size,
+                               F_SEAL_SEAL | F_SEAL_SHRINK | F_SEAL_GROW,
+                               &memfd, &local_err);
+    if (!shm_buf) {
+        error_report_err(local_err);
+        ret = -ENOMEM;
+        goto early_fail;
+    }
+
+    /* Share the SHM area with virtiofsd */
+    ret = vhost_fs_set_state_fd(&fs->vhost_dev, memfd, chunk_size);
+    if (ret < 0) {
+        goto early_fail;
+    }
+
+    /*
+     * Read the virtiofsd state in chunks from `f`, and send them over
+     * to virtiofsd
+     */
+    state_offset = 0;
+    do {
+        size_t this_chunk_size = MIN(remaining, chunk_size);
+
+        if (qemu_get_buffer(f, shm_buf, this_chunk_size) < this_chunk_size) {
+            ret = -EINVAL;
+            goto fail;
+        }
+
+        ret = vhost_fs_set_state(&fs->vhost_dev, state_offset, this_chunk_size);
+        if (ret < 0) {
+            goto fail;
+        }
+
+        state_offset += this_chunk_size;
+        remaining -= this_chunk_size;
+    } while (remaining > 0);
+
+    ret = 0;
+fail:
+    ret2 = vhost_fs_set_state_fd(&fs->vhost_dev, -1, 0);
+    if (ret2 < 0) {
+        error_report("Failed to remove state FD from the vhost-user-fs back "
+                     "end -- perhaps it failed to deserialize/apply the state: "
+                     "%s", strerror(-ret2));
+        if (ret == 0) {
+            ret = ret2;
+        }
+    }
+
+early_fail:
+    if (shm_buf) {
+        qemu_memfd_free(shm_buf, chunk_size, memfd);
+    }
+
+    return ret;
+}
+
 static const VMStateDescription vuf_vmstate = {
     .name = "vhost-user-fs",
-    .unmigratable = 1,
+    .version_id = 1,
+    .fields = (VMStateField[]) {
+        VMSTATE_VIRTIO_DEVICE,
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
2.39.1

