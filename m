Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:51:44 +0100
Message-Id: <20221205095228.1314-8-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 07/51] hw/display/qxl: Avoid buffer overrun
 in qxl_phys2virt (CVE-2022-4144)
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

Have qxl_get_check_slot_offset() return false if the requested
buffer size does not fit within the slot memory region.

Similarly qxl_phys2virt() now returns NULL in such case, and
qxl_dirty_one_surface() aborts.

This avoids buffer overrun in the host pointer returned by
memory_region_get_ram_ptr().

Fixes: CVE-2022-4144 (out-of-bounds read)
Reported-by: Wenxu Yin (@awxylitol)
Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1336
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20221128202741.4945-5-philmd@linaro.org>
---
 hw/display/qxl.h |  2 +-
 hw/display/qxl.c | 27 +++++++++++++++++++++++----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/hw/display/qxl.h b/hw/display/qxl.h
index bf03138ab4..7894bd5134 100644
--- a/hw/display/qxl.h
+++ b/hw/display/qxl.h
@@ -157,7 +157,7 @@ OBJECT_DECLARE_SIMPLE_TYPE(PCIQXLDevice, PCI_QXL)
  *
  * Returns a host pointer to a buffer placed at offset @phys within the
  * active slot @group_id of the PCI VGA RAM memory region associated with
- * the @qxl device. If the slot is inactive, or the offset is out
+ * the @qxl device. If the slot is inactive, or the offset + size are out
  * of the memory region, returns NULL.
  *
  * Use with care; by the time this function returns, the returned pointer is
diff --git a/hw/display/qxl.c b/hw/display/qxl.c
index 231d733250..0b21626aad 100644
--- a/hw/display/qxl.c
+++ b/hw/display/qxl.c
@@ -1424,11 +1424,13 @@ static void qxl_reset_surfaces(PCIQXLDevice *d)
 
 /* can be also called from spice server thread context */
 static bool qxl_get_check_slot_offset(PCIQXLDevice *qxl, QXLPHYSICAL pqxl,
-                                      uint32_t *s, uint64_t *o)
+                                      uint32_t *s, uint64_t *o,
+                                      size_t size_requested)
 {
     uint64_t phys   = le64_to_cpu(pqxl);
     uint32_t slot   = (phys >> (64 -  8)) & 0xff;
     uint64_t offset = phys & 0xffffffffffff;
+    uint64_t size_available;
 
     if (slot >= NUM_MEMSLOTS) {
         qxl_set_guest_bug(qxl, "slot too large %d >= %d", slot,
@@ -1452,6 +1454,23 @@ static bool qxl_get_check_slot_offset(PCIQXLDevice *qxl, QXLPHYSICAL pqxl,
                           slot, offset, qxl->guest_slots[slot].size);
         return false;
     }
+    size_available = memory_region_size(qxl->guest_slots[slot].mr);
+    if (qxl->guest_slots[slot].offset + offset >= size_available) {
+        qxl_set_guest_bug(qxl,
+                          "slot %d offset %"PRIu64" > region size %"PRIu64"\n",
+                          slot, qxl->guest_slots[slot].offset + offset,
+                          size_available);
+        return false;
+    }
+    size_available -= qxl->guest_slots[slot].offset + offset;
+    if (size_requested > size_available) {
+        qxl_set_guest_bug(qxl,
+                          "slot %d offset %"PRIu64" size %zu: "
+                          "overrun by %"PRIu64" bytes\n",
+                          slot, offset, size_requested,
+                          size_requested - size_available);
+        return false;
+    }
 
     *s = slot;
     *o = offset;
@@ -1471,7 +1490,7 @@ void *qxl_phys2virt(PCIQXLDevice *qxl, QXLPHYSICAL pqxl, int group_id,
         offset = le64_to_cpu(pqxl) & 0xffffffffffff;
         return (void *)(intptr_t)offset;
     case MEMSLOT_GROUP_GUEST:
-        if (!qxl_get_check_slot_offset(qxl, pqxl, &slot, &offset)) {
+        if (!qxl_get_check_slot_offset(qxl, pqxl, &slot, &offset, size)) {
             return NULL;
         }
         ptr = memory_region_get_ram_ptr(qxl->guest_slots[slot].mr);
@@ -1937,9 +1956,9 @@ static void qxl_dirty_one_surface(PCIQXLDevice *qxl, QXLPHYSICAL pqxl,
     uint32_t slot;
     bool rc;
 
-    rc = qxl_get_check_slot_offset(qxl, pqxl, &slot, &offset);
-    assert(rc == true);
     size = (uint64_t)height * abs(stride);
+    rc = qxl_get_check_slot_offset(qxl, pqxl, &slot, &offset, size);
+    assert(rc == true);
     trace_qxl_surfaces_dirty(qxl->id, offset, size);
     qxl_set_dirty(qxl->guest_slots[slot].mr,
                   qxl->guest_slots[slot].offset + offset,
-- 
2.38.1

