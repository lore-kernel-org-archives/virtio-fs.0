Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:51:43 +0100
Message-Id: <20221205095228.1314-7-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 06/51] hw/display/qxl: Pass requested buffer
 size to qxl_phys2virt()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>

From: Philippe Mathieu-Daudé <philmd@linaro.org>

Currently qxl_phys2virt() doesn't check for buffer overrun.
In order to do so in the next commit, pass the buffer size
as argument.

For QXLCursor in qxl_render_cursor() -> qxl_cursor() we
verify the size of the chunked data ahead, checking we can
access 'sizeof(QXLCursor) + chunk->data_size' bytes.
Since in the SPICE_CURSOR_TYPE_MONO case the cursor is
assumed to fit in one chunk, no change are required.
In SPICE_CURSOR_TYPE_ALPHA the ahead read is handled in
qxl_unpack_chunks().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20221128202741.4945-4-philmd@linaro.org>
---
 hw/display/qxl.h        |  4 +++-
 hw/display/qxl-logger.c | 11 ++++++++---
 hw/display/qxl-render.c | 20 ++++++++++++++++----
 hw/display/qxl.c        | 14 +++++++++-----
 4 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/hw/display/qxl.h b/hw/display/qxl.h
index 78b3a6c9ba..bf03138ab4 100644
--- a/hw/display/qxl.h
+++ b/hw/display/qxl.h
@@ -153,6 +153,7 @@ OBJECT_DECLARE_SIMPLE_TYPE(PCIQXLDevice, PCI_QXL)
  * @qxl: QXL device
  * @phys: physical offset of buffer within the VRAM
  * @group_id: memory slot group
+ * @size: size of the buffer
  *
  * Returns a host pointer to a buffer placed at offset @phys within the
  * active slot @group_id of the PCI VGA RAM memory region associated with
@@ -166,7 +167,8 @@ OBJECT_DECLARE_SIMPLE_TYPE(PCIQXLDevice, PCI_QXL)
  * the incoming ram_addr_t.
  *
  */
-void *qxl_phys2virt(PCIQXLDevice *qxl, QXLPHYSICAL phys, int group_id);
+void *qxl_phys2virt(PCIQXLDevice *qxl, QXLPHYSICAL phys, int group_id,
+                    size_t size);
 void qxl_set_guest_bug(PCIQXLDevice *qxl, const char *msg, ...)
     G_GNUC_PRINTF(2, 3);
 
diff --git a/hw/display/qxl-logger.c b/hw/display/qxl-logger.c
index 1bcf803db6..35c38f6252 100644
--- a/hw/display/qxl-logger.c
+++ b/hw/display/qxl-logger.c
@@ -106,7 +106,7 @@ static int qxl_log_image(PCIQXLDevice *qxl, QXLPHYSICAL addr, int group_id)
     QXLImage *image;
     QXLImageDescriptor *desc;
 
-    image = qxl_phys2virt(qxl, addr, group_id);
+    image = qxl_phys2virt(qxl, addr, group_id, sizeof(QXLImage));
     if (!image) {
         return 1;
     }
@@ -214,7 +214,8 @@ int qxl_log_cmd_cursor(PCIQXLDevice *qxl, QXLCursorCmd *cmd, int group_id)
                 cmd->u.set.position.y,
                 cmd->u.set.visible ? "yes" : "no",
                 cmd->u.set.shape);
-        cursor = qxl_phys2virt(qxl, cmd->u.set.shape, group_id);
+        cursor = qxl_phys2virt(qxl, cmd->u.set.shape, group_id,
+                               sizeof(QXLCursor));
         if (!cursor) {
             return 1;
         }
@@ -236,6 +237,7 @@ int qxl_log_command(PCIQXLDevice *qxl, const char *ring, QXLCommandExt *ext)
 {
     bool compat = ext->flags & QXL_COMMAND_FLAG_COMPAT;
     void *data;
+    size_t datasz;
     int ret;
 
     if (!qxl->cmdlog) {
@@ -249,15 +251,18 @@ int qxl_log_command(PCIQXLDevice *qxl, const char *ring, QXLCommandExt *ext)
 
     switch (ext->cmd.type) {
     case QXL_CMD_DRAW:
+        datasz = compat ? sizeof(QXLCompatDrawable) : sizeof(QXLDrawable);
         break;
     case QXL_CMD_SURFACE:
+        datasz = sizeof(QXLSurfaceCmd);
         break;
     case QXL_CMD_CURSOR:
+        datasz = sizeof(QXLCursorCmd);
         break;
     default:
         goto out;
     }
-    data = qxl_phys2virt(qxl, ext->cmd.data, ext->group_id);
+    data = qxl_phys2virt(qxl, ext->cmd.data, ext->group_id, datasz);
     if (!data) {
         return 1;
     }
diff --git a/hw/display/qxl-render.c b/hw/display/qxl-render.c
index ca217004bf..fcfd40c3ac 100644
--- a/hw/display/qxl-render.c
+++ b/hw/display/qxl-render.c
@@ -107,7 +107,9 @@ static void qxl_render_update_area_unlocked(PCIQXLDevice *qxl)
         qxl->guest_primary.resized = 0;
         qxl->guest_primary.data = qxl_phys2virt(qxl,
                                                 qxl->guest_primary.surface.mem,
-                                                MEMSLOT_GROUP_GUEST);
+                                                MEMSLOT_GROUP_GUEST,
+                                                qxl->guest_primary.abs_stride
+                                                * height);
         if (!qxl->guest_primary.data) {
             goto end;
         }
@@ -228,7 +230,8 @@ static void qxl_unpack_chunks(void *dest, size_t size, PCIQXLDevice *qxl,
         if (offset == size) {
             return;
         }
-        chunk = qxl_phys2virt(qxl, chunk->next_chunk, group_id);
+        chunk = qxl_phys2virt(qxl, chunk->next_chunk, group_id,
+                              sizeof(QXLDataChunk) + chunk->data_size);
         if (!chunk) {
             return;
         }
@@ -295,7 +298,8 @@ fail:
 /* called from spice server thread context only */
 int qxl_render_cursor(PCIQXLDevice *qxl, QXLCommandExt *ext)
 {
-    QXLCursorCmd *cmd = qxl_phys2virt(qxl, ext->cmd.data, ext->group_id);
+    QXLCursorCmd *cmd = qxl_phys2virt(qxl, ext->cmd.data, ext->group_id,
+                                      sizeof(QXLCursorCmd));
     QXLCursor *cursor;
     QEMUCursor *c;
 
@@ -314,7 +318,15 @@ int qxl_render_cursor(PCIQXLDevice *qxl, QXLCommandExt *ext)
     }
     switch (cmd->type) {
     case QXL_CURSOR_SET:
-        cursor = qxl_phys2virt(qxl, cmd->u.set.shape, ext->group_id);
+        /* First read the QXLCursor to get QXLDataChunk::data_size ... */
+        cursor = qxl_phys2virt(qxl, cmd->u.set.shape, ext->group_id,
+                               sizeof(QXLCursor));
+        if (!cursor) {
+            return 1;
+        }
+        /* Then read including the chunked data following QXLCursor. */
+        cursor = qxl_phys2virt(qxl, cmd->u.set.shape, ext->group_id,
+                               sizeof(QXLCursor) + cursor->chunk.data_size);
         if (!cursor) {
             return 1;
         }
diff --git a/hw/display/qxl.c b/hw/display/qxl.c
index 5b10f697f1..231d733250 100644
--- a/hw/display/qxl.c
+++ b/hw/display/qxl.c
@@ -274,7 +274,8 @@ static void qxl_spice_monitors_config_async(PCIQXLDevice *qxl, int replay)
                                           QXL_IO_MONITORS_CONFIG_ASYNC));
     }
 
-    cfg = qxl_phys2virt(qxl, qxl->guest_monitors_config, MEMSLOT_GROUP_GUEST);
+    cfg = qxl_phys2virt(qxl, qxl->guest_monitors_config, MEMSLOT_GROUP_GUEST,
+                        sizeof(QXLMonitorsConfig));
     if (cfg != NULL && cfg->count == 1) {
         qxl->guest_primary.resized = 1;
         qxl->guest_head0_width  = cfg->heads[0].width;
@@ -459,7 +460,8 @@ static int qxl_track_command(PCIQXLDevice *qxl, struct QXLCommandExt *ext)
     switch (le32_to_cpu(ext->cmd.type)) {
     case QXL_CMD_SURFACE:
     {
-        QXLSurfaceCmd *cmd = qxl_phys2virt(qxl, ext->cmd.data, ext->group_id);
+        QXLSurfaceCmd *cmd = qxl_phys2virt(qxl, ext->cmd.data, ext->group_id,
+                                           sizeof(QXLSurfaceCmd));
 
         if (!cmd) {
             return 1;
@@ -494,7 +496,8 @@ static int qxl_track_command(PCIQXLDevice *qxl, struct QXLCommandExt *ext)
     }
     case QXL_CMD_CURSOR:
     {
-        QXLCursorCmd *cmd = qxl_phys2virt(qxl, ext->cmd.data, ext->group_id);
+        QXLCursorCmd *cmd = qxl_phys2virt(qxl, ext->cmd.data, ext->group_id,
+                                          sizeof(QXLCursorCmd));
 
         if (!cmd) {
             return 1;
@@ -1456,7 +1459,8 @@ static bool qxl_get_check_slot_offset(PCIQXLDevice *qxl, QXLPHYSICAL pqxl,
 }
 
 /* can be also called from spice server thread context */
-void *qxl_phys2virt(PCIQXLDevice *qxl, QXLPHYSICAL pqxl, int group_id)
+void *qxl_phys2virt(PCIQXLDevice *qxl, QXLPHYSICAL pqxl, int group_id,
+                    size_t size)
 {
     uint64_t offset;
     uint32_t slot;
@@ -1964,7 +1968,7 @@ static void qxl_dirty_surfaces(PCIQXLDevice *qxl)
         }
 
         cmd = qxl_phys2virt(qxl, qxl->guest_surfaces.cmds[i],
-                            MEMSLOT_GROUP_GUEST);
+                            MEMSLOT_GROUP_GUEST, sizeof(QXLSurfaceCmd));
         assert(cmd);
         assert(cmd->type == QXL_SURFACE_CMD_CREATE);
         qxl_dirty_one_surface(qxl, cmd->u.surface_create.data,
-- 
2.38.1

