Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:52:25 +0100
Message-Id: <20221205095228.1314-49-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 48/51] migration: No save_live_pending()
 method uses the QEMUFile parameter
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>

So remove it everywhere.

Signed-off-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 include/migration/register.h   | 6 ++----
 migration/savevm.h             | 2 +-
 hw/s390x/s390-stattrib.c       | 2 +-
 hw/vfio/migration.c            | 6 ++----
 migration/block-dirty-bitmap.c | 5 ++---
 migration/block.c              | 2 +-
 migration/migration.c          | 3 +--
 migration/ram.c                | 2 +-
 migration/savevm.c             | 5 ++---
 9 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/include/migration/register.h b/include/migration/register.h
index 1950fee6a8..5b5424ed8f 100644
--- a/include/migration/register.h
+++ b/include/migration/register.h
@@ -46,10 +46,8 @@ typedef struct SaveVMHandlers {
 
     /* This runs outside the iothread lock!  */
     int (*save_setup)(QEMUFile *f, void *opaque);
-    void (*save_live_pending)(QEMUFile *f, void *opaque,
-                              uint64_t threshold_size,
-                              uint64_t *rest_precopy,
-                              uint64_t *rest_postcopy);
+    void (*save_live_pending)(void *opaque,  uint64_t threshold_size,
+                              uint64_t *rest_precopy, uint64_t *rest_postcopy);
     /* Note for save_live_pending:
      * - res_precopy is for data which must be migrated in precopy
      *     phase or in stopped state, in other words - before target
diff --git a/migration/savevm.h b/migration/savevm.h
index 9bd55c336c..98fae6f9b3 100644
--- a/migration/savevm.h
+++ b/migration/savevm.h
@@ -40,7 +40,7 @@ void qemu_savevm_state_cleanup(void);
 void qemu_savevm_state_complete_postcopy(QEMUFile *f);
 int qemu_savevm_state_complete_precopy(QEMUFile *f, bool iterable_only,
                                        bool inactivate_disks);
-void qemu_savevm_state_pending(QEMUFile *f, uint64_t max_size,
+void qemu_savevm_state_pending(uint64_t max_size,
                                uint64_t *res_precopy, uint64_t *res_postcopy);
 void qemu_savevm_send_ping(QEMUFile *f, uint32_t value);
 void qemu_savevm_send_open_return_path(QEMUFile *f);
diff --git a/hw/s390x/s390-stattrib.c b/hw/s390x/s390-stattrib.c
index ee60b53da4..9b74eeadf3 100644
--- a/hw/s390x/s390-stattrib.c
+++ b/hw/s390x/s390-stattrib.c
@@ -182,7 +182,7 @@ static int cmma_save_setup(QEMUFile *f, void *opaque)
     return 0;
 }
 
-static void cmma_save_pending(QEMUFile *f, void *opaque, uint64_t max_size,
+static void cmma_save_pending(void *opaque, uint64_t max_size,
                               uint64_t *res_precopy, uint64_t *res_postcopy)
 {
     S390StAttribState *sas = S390_STATTRIB(opaque);
diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
index d03681678d..8ae1bd31a8 100644
--- a/hw/vfio/migration.c
+++ b/hw/vfio/migration.c
@@ -456,10 +456,8 @@ static void vfio_save_cleanup(void *opaque)
     trace_vfio_save_cleanup(vbasedev->name);
 }
 
-static void vfio_save_pending(QEMUFile *f, void *opaque,
-                              uint64_t threshold_size,
-                              uint64_t *res_precopy,
-                              uint64_t *res_postcopy)
+static void vfio_save_pending(void *opaque,  uint64_t threshold_size,
+                              uint64_t *res_precopy, uint64_t *res_postcopy)
 {
     VFIODevice *vbasedev = opaque;
     VFIOMigration *migration = vbasedev->migration;
diff --git a/migration/block-dirty-bitmap.c b/migration/block-dirty-bitmap.c
index dfea546330..a445bdc3c3 100644
--- a/migration/block-dirty-bitmap.c
+++ b/migration/block-dirty-bitmap.c
@@ -761,9 +761,8 @@ static int dirty_bitmap_save_complete(QEMUFile *f, void *opaque)
     return 0;
 }
 
-static void dirty_bitmap_save_pending(QEMUFile *f, void *opaque,
-                                      uint64_t max_size,
-                                      uint64_t *res_precopy,
+static void dirty_bitmap_save_pending(void *opaque, uint64_t max_size,
+                                      uint64_t *res_precopy, 
                                       uint64_t *res_postcopy)
 {
     DBMSaveState *s = &((DBMState *)opaque)->save;
diff --git a/migration/block.c b/migration/block.c
index 593754c38c..39ce4003c6 100644
--- a/migration/block.c
+++ b/migration/block.c
@@ -862,7 +862,7 @@ static int block_save_complete(QEMUFile *f, void *opaque)
     return 0;
 }
 
-static void block_save_pending(QEMUFile *f, void *opaque, uint64_t max_size,
+static void block_save_pending(void *opaque, uint64_t max_size,
                                uint64_t *res_precopy,
                                uint64_t *res_postcopy)
 {
diff --git a/migration/migration.c b/migration/migration.c
index 6b8a6dd74e..a75a281635 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -3759,8 +3759,7 @@ static MigIterateState migration_iteration_run(MigrationState *s)
     uint64_t pending_size, pend_pre, pend_post;
     bool in_postcopy = s->state == MIGRATION_STATUS_POSTCOPY_ACTIVE;
 
-    qemu_savevm_state_pending(s->to_dst_file, s->threshold_size, &pend_pre,
-                              &pend_post);
+    qemu_savevm_state_pending(s->threshold_size, &pend_pre, &pend_post);
     pending_size = pend_pre + pend_post;
 
     trace_migrate_pending(pending_size, s->threshold_size, pend_pre, pend_post);
diff --git a/migration/ram.c b/migration/ram.c
index 640839dcee..63cb6544e5 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -3392,7 +3392,7 @@ static int ram_save_complete(QEMUFile *f, void *opaque)
     return 0;
 }
 
-static void ram_save_pending(QEMUFile *f, void *opaque, uint64_t max_size,
+static void ram_save_pending(void *opaque, uint64_t max_size,
                              uint64_t *res_precopy, uint64_t *res_postcopy)
 {
     RAMState **temp = opaque;
diff --git a/migration/savevm.c b/migration/savevm.c
index 4d02887f25..9ddcbba4e3 100644
--- a/migration/savevm.c
+++ b/migration/savevm.c
@@ -1471,8 +1471,7 @@ flush:
  * the result is split into the amount for units that can and
  * for units that can't do postcopy.
  */
-void qemu_savevm_state_pending(QEMUFile *f, uint64_t threshold_size,
-                               uint64_t *res_precopy,
+void qemu_savevm_state_pending(uint64_t threshold_size, uint64_t *res_precopy,
                                uint64_t *res_postcopy)
 {
     SaveStateEntry *se;
@@ -1489,7 +1488,7 @@ void qemu_savevm_state_pending(QEMUFile *f, uint64_t threshold_size,
                 continue;
             }
         }
-        se->ops->save_live_pending(f, se->opaque, threshold_size,
+        se->ops->save_live_pending(se->opaque, threshold_size,
                                    res_precopy, res_postcopy);
     }
 }
-- 
2.38.1

