Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:52:15 +0100
Message-Id: <20221205095228.1314-39-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 38/51] migration: Use atomic ops properly for
 page accountings
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>, Peter Xu <peterx@redhat.com>

From: Peter Xu <peterx@redhat.com>

To prepare for thread-safety on page accountings, at least below counters
need to be accessed only atomically, they are:

        ram_counters.transferred
        ram_counters.duplicate
        ram_counters.normal
        ram_counters.postcopy_bytes

There are a lot of other counters but they won't be accessed outside
migration thread, then they're still safe to be accessed without atomic
ops.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.h       | 20 ++++++++++++++++++++
 migration/migration.c | 10 +++++-----
 migration/multifd.c   |  4 ++--
 migration/ram.c       | 40 ++++++++++++++++++++++++----------------
 4 files changed, 51 insertions(+), 23 deletions(-)

diff --git a/migration/ram.h b/migration/ram.h
index 038d52f49f..81cbb0947c 100644
--- a/migration/ram.h
+++ b/migration/ram.h
@@ -32,7 +32,27 @@
 #include "qapi/qapi-types-migration.h"
 #include "exec/cpu-common.h"
 #include "io/channel.h"
+#include "qemu/stats64.h"
 
+/*
+ * These are the migration statistic counters that need to be updated using
+ * atomic ops (can be accessed by more than one thread).  Here since we
+ * cannot modify MigrationStats directly to use Stat64 as it was defined in
+ * the QAPI scheme, we define an internal structure to hold them, and we
+ * propagate the real values when QMP queries happen.
+ *
+ * IOW, the corresponding fields within ram_counters on these specific
+ * fields will be always zero and not being used at all; they're just
+ * placeholders to make it QAPI-compatible.
+ */
+typedef struct {
+    Stat64 transferred;
+    Stat64 duplicate;
+    Stat64 normal;
+    Stat64 postcopy_bytes;
+} MigrationAtomicStats;
+
+extern MigrationAtomicStats ram_atomic_counters;
 extern MigrationStats ram_counters;
 extern XBZRLECacheStats xbzrle_counters;
 extern CompressionStats compression_counters;
diff --git a/migration/migration.c b/migration/migration.c
index f485eea5fb..de83c50f51 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -1049,13 +1049,13 @@ static void populate_ram_info(MigrationInfo *info, MigrationState *s)
 
     info->has_ram = true;
     info->ram = g_malloc0(sizeof(*info->ram));
-    info->ram->transferred = ram_counters.transferred;
+    info->ram->transferred = stat64_get(&ram_atomic_counters.transferred);
     info->ram->total = ram_bytes_total();
-    info->ram->duplicate = ram_counters.duplicate;
+    info->ram->duplicate = stat64_get(&ram_atomic_counters.duplicate);
     /* legacy value.  It is not used anymore */
     info->ram->skipped = 0;
-    info->ram->normal = ram_counters.normal;
-    info->ram->normal_bytes = ram_counters.normal * page_size;
+    info->ram->normal = stat64_get(&ram_atomic_counters.normal);
+    info->ram->normal_bytes = info->ram->normal * page_size;
     info->ram->mbps = s->mbps;
     info->ram->dirty_sync_count = ram_counters.dirty_sync_count;
     info->ram->dirty_sync_missed_zero_copy =
@@ -1066,7 +1066,7 @@ static void populate_ram_info(MigrationInfo *info, MigrationState *s)
     info->ram->pages_per_second = s->pages_per_second;
     info->ram->precopy_bytes = ram_counters.precopy_bytes;
     info->ram->downtime_bytes = ram_counters.downtime_bytes;
-    info->ram->postcopy_bytes = ram_counters.postcopy_bytes;
+    info->ram->postcopy_bytes = stat64_get(&ram_atomic_counters.postcopy_bytes);
 
     if (migrate_use_xbzrle()) {
         info->has_xbzrle_cache = true;
diff --git a/migration/multifd.c b/migration/multifd.c
index b8dc559d24..000ca4d4ec 100644
--- a/migration/multifd.c
+++ b/migration/multifd.c
@@ -432,7 +432,7 @@ static int multifd_send_pages(QEMUFile *f)
     transferred = ((uint64_t) pages->num) * p->page_size + p->packet_len;
     qemu_file_acct_rate_limit(f, transferred);
     ram_counters.multifd_bytes += transferred;
-    ram_counters.transferred += transferred;
+    stat64_add(&ram_atomic_counters.transferred, transferred);
     qemu_mutex_unlock(&p->mutex);
     qemu_sem_post(&p->sem);
 
@@ -624,7 +624,7 @@ int multifd_send_sync_main(QEMUFile *f)
         p->pending_job++;
         qemu_file_acct_rate_limit(f, p->packet_len);
         ram_counters.multifd_bytes += p->packet_len;
-        ram_counters.transferred += p->packet_len;
+        stat64_add(&ram_atomic_counters.transferred, p->packet_len);
         qemu_mutex_unlock(&p->mutex);
         qemu_sem_post(&p->sem);
 
diff --git a/migration/ram.c b/migration/ram.c
index 5379164749..f4cd9038f4 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -425,18 +425,25 @@ uint64_t ram_bytes_remaining(void)
                        0;
 }
 
+/*
+ * NOTE: not all stats in ram_counters are used in reality.  See comments
+ * for struct MigrationAtomicStats.  The ultimate result of ram migration
+ * counters will be a merged version with both ram_counters and the atomic
+ * fields in ram_atomic_counters.
+ */
 MigrationStats ram_counters;
+MigrationAtomicStats ram_atomic_counters;
 
 void ram_transferred_add(uint64_t bytes)
 {
     if (runstate_is_running()) {
         ram_counters.precopy_bytes += bytes;
     } else if (migration_in_postcopy()) {
-        ram_counters.postcopy_bytes += bytes;
+        stat64_add(&ram_atomic_counters.postcopy_bytes, bytes);
     } else {
         ram_counters.downtime_bytes += bytes;
     }
-    ram_counters.transferred += bytes;
+    stat64_add(&ram_atomic_counters.transferred, bytes);
 }
 
 void dirty_sync_missed_zero_copy(void)
@@ -725,7 +732,7 @@ void mig_throttle_counter_reset(void)
 
     rs->time_last_bitmap_sync = qemu_clock_get_ms(QEMU_CLOCK_REALTIME);
     rs->num_dirty_pages_period = 0;
-    rs->bytes_xfer_prev = ram_counters.transferred;
+    rs->bytes_xfer_prev = stat64_get(&ram_atomic_counters.transferred);
 }
 
 /**
@@ -1085,8 +1092,9 @@ uint64_t ram_pagesize_summary(void)
 
 uint64_t ram_get_total_transferred_pages(void)
 {
-    return  ram_counters.normal + ram_counters.duplicate +
-                compression_counters.pages + xbzrle_counters.pages;
+    return  stat64_get(&ram_atomic_counters.normal) +
+        stat64_get(&ram_atomic_counters.duplicate) +
+        compression_counters.pages + xbzrle_counters.pages;
 }
 
 static void migration_update_rates(RAMState *rs, int64_t end_time)
@@ -1145,8 +1153,8 @@ static void migration_trigger_throttle(RAMState *rs)
 {
     MigrationState *s = migrate_get_current();
     uint64_t threshold = s->parameters.throttle_trigger_threshold;
-
-    uint64_t bytes_xfer_period = ram_counters.transferred - rs->bytes_xfer_prev;
+    uint64_t bytes_xfer_period =
+        stat64_get(&ram_atomic_counters.transferred) - rs->bytes_xfer_prev;
     uint64_t bytes_dirty_period = rs->num_dirty_pages_period * TARGET_PAGE_SIZE;
     uint64_t bytes_dirty_threshold = bytes_xfer_period * threshold / 100;
 
@@ -1209,7 +1217,7 @@ static void migration_bitmap_sync(RAMState *rs)
         /* reset period counters */
         rs->time_last_bitmap_sync = end_time;
         rs->num_dirty_pages_period = 0;
-        rs->bytes_xfer_prev = ram_counters.transferred;
+        rs->bytes_xfer_prev = stat64_get(&ram_atomic_counters.transferred);
     }
     if (migrate_use_events()) {
         qapi_event_send_migration_pass(ram_counters.dirty_sync_count);
@@ -1285,7 +1293,7 @@ static int save_zero_page(RAMState *rs, RAMBlock *block, ram_addr_t offset)
     int len = save_zero_page_to_file(rs, rs->f, block, offset);
 
     if (len) {
-        ram_counters.duplicate++;
+        stat64_add(&ram_atomic_counters.duplicate, 1);
         ram_transferred_add(len);
         return 1;
     }
@@ -1322,9 +1330,9 @@ static bool control_save_page(RAMState *rs, RAMBlock *block, ram_addr_t offset,
     }
 
     if (bytes_xmit > 0) {
-        ram_counters.normal++;
+        stat64_add(&ram_atomic_counters.normal, 1);
     } else if (bytes_xmit == 0) {
-        ram_counters.duplicate++;
+        stat64_add(&ram_atomic_counters.duplicate, 1);
     }
 
     return true;
@@ -1354,7 +1362,7 @@ static int save_normal_page(RAMState *rs, RAMBlock *block, ram_addr_t offset,
         qemu_put_buffer(rs->f, buf, TARGET_PAGE_SIZE);
     }
     ram_transferred_add(TARGET_PAGE_SIZE);
-    ram_counters.normal++;
+    stat64_add(&ram_atomic_counters.normal, 1);
     return 1;
 }
 
@@ -1410,7 +1418,7 @@ static int ram_save_multifd_page(RAMState *rs, RAMBlock *block,
     if (multifd_queue_page(rs->f, block, offset) < 0) {
         return -1;
     }
-    ram_counters.normal++;
+    stat64_add(&ram_atomic_counters.normal, 1);
 
     return 1;
 }
@@ -1448,7 +1456,7 @@ update_compress_thread_counts(const CompressParam *param, int bytes_xmit)
     ram_transferred_add(bytes_xmit);
 
     if (param->zero_page) {
-        ram_counters.duplicate++;
+        stat64_add(&ram_atomic_counters.duplicate, 1);
         return;
     }
 
@@ -2623,9 +2631,9 @@ void acct_update_position(QEMUFile *f, size_t size, bool zero)
     uint64_t pages = size / TARGET_PAGE_SIZE;
 
     if (zero) {
-        ram_counters.duplicate += pages;
+        stat64_add(&ram_atomic_counters.duplicate, pages);
     } else {
-        ram_counters.normal += pages;
+        stat64_add(&ram_atomic_counters.normal, pages);
         ram_transferred_add(size);
         qemu_file_credit_transfer(f, size);
     }
-- 
2.38.1

