Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:52:14 +0100
Message-Id: <20221205095228.1314-38-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 37/51] migration: Yield bitmap_mutex properly
 when sending/sleeping
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

Don't take the bitmap mutex when sending pages, or when being throttled by
migration_rate_limit() (which is a bit tricky to call it here in ram code,
but seems still helpful).

It prepares for the possibility of concurrently sending pages in >1 threads
using the function ram_save_host_page() because all threads may need the
bitmap_mutex to operate on bitmaps, so that either sendmsg() or any kind of
qemu_sem_wait() blocking for one thread will not block the other from
progressing.

Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index 6e3dc845c5..5379164749 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -2452,9 +2452,14 @@ static void postcopy_preempt_reset_channel(RAMState *rs)
  * a host page in which case the remainder of the hostpage is sent.
  * Only dirty target pages are sent. Note that the host page size may
  * be a huge page for this block.
+ *
  * The saving stops at the boundary of the used_length of the block
  * if the RAMBlock isn't a multiple of the host page size.
  *
+ * The caller must be with ram_state.bitmap_mutex held to call this
+ * function.  Note that this function can temporarily release the lock, but
+ * when the function is returned it'll make sure the lock is still held.
+ *
  * Returns the number of pages written or negative on error
  *
  * @rs: current RAM state
@@ -2462,6 +2467,7 @@ static void postcopy_preempt_reset_channel(RAMState *rs)
  */
 static int ram_save_host_page(RAMState *rs, PageSearchStatus *pss)
 {
+    bool page_dirty, preempt_active = postcopy_preempt_active();
     int tmppages, pages = 0;
     size_t pagesize_bits =
         qemu_ram_pagesize(pss->block) >> TARGET_PAGE_BITS;
@@ -2485,22 +2491,40 @@ static int ram_save_host_page(RAMState *rs, PageSearchStatus *pss)
             break;
         }
 
+        page_dirty = migration_bitmap_clear_dirty(rs, pss->block, pss->page);
+
         /* Check the pages is dirty and if it is send it */
-        if (migration_bitmap_clear_dirty(rs, pss->block, pss->page)) {
+        if (page_dirty) {
+            /*
+             * Properly yield the lock only in postcopy preempt mode
+             * because both migration thread and rp-return thread can
+             * operate on the bitmaps.
+             */
+            if (preempt_active) {
+                qemu_mutex_unlock(&rs->bitmap_mutex);
+            }
             tmppages = ram_save_target_page(rs, pss);
-            if (tmppages < 0) {
-                return tmppages;
+            if (tmppages >= 0) {
+                pages += tmppages;
+                /*
+                 * Allow rate limiting to happen in the middle of huge pages if
+                 * something is sent in the current iteration.
+                 */
+                if (pagesize_bits > 1 && tmppages > 0) {
+                    migration_rate_limit();
+                }
             }
-
-            pages += tmppages;
-            /*
-             * Allow rate limiting to happen in the middle of huge pages if
-             * something is sent in the current iteration.
-             */
-            if (pagesize_bits > 1 && tmppages > 0) {
-                migration_rate_limit();
+            if (preempt_active) {
+                qemu_mutex_lock(&rs->bitmap_mutex);
             }
+        } else {
+            tmppages = 0;
+        }
+
+        if (tmppages < 0) {
+            return tmppages;
         }
+
         pss->page = migration_bitmap_find_dirty(rs, pss->block, pss->page);
     } while ((pss->page < hostpage_boundary) &&
              offset_in_ramblock(pss->block,
-- 
2.38.1

