Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:52:19 +0100
Message-Id: <20221205095228.1314-43-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 42/51] migration: Make PageSearchStatus part
 of RAMState
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

We used to allocate PSS structure on the stack for precopy when sending
pages.  Make it static, so as to describe per-channel ram migration status.

Here we declared RAM_CHANNEL_MAX instances, preparing for postcopy to use
it, even though this patch has not yet to start using the 2nd instance.

This should not have any functional change per se, but it already starts to
export PSS information via the RAMState, so that e.g. one PSS channel can
start to reference the other PSS channel.

Always protect PSS access using the same RAMState.bitmap_mutex.  We already
do so, so no code change needed, just some comment update.  Maybe we should
consider renaming bitmap_mutex some day as it's going to be a more commonly
and big mutex we use for ram states, but just leave it for later.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 112 ++++++++++++++++++++++++++----------------------
 1 file changed, 61 insertions(+), 51 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index d81bf7b183..3194997738 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -85,6 +85,46 @@
 
 XBZRLECacheStats xbzrle_counters;
 
+/* used by the search for pages to send */
+struct PageSearchStatus {
+    /* The migration channel used for a specific host page */
+    QEMUFile    *pss_channel;
+    /* Current block being searched */
+    RAMBlock    *block;
+    /* Current page to search from */
+    unsigned long page;
+    /* Set once we wrap around */
+    bool         complete_round;
+    /*
+     * [POSTCOPY-ONLY] Whether current page is explicitly requested by
+     * postcopy.  When set, the request is "urgent" because the dest QEMU
+     * threads are waiting for us.
+     */
+    bool         postcopy_requested;
+    /*
+     * [POSTCOPY-ONLY] The target channel to use to send current page.
+     *
+     * Note: This may _not_ match with the value in postcopy_requested
+     * above. Let's imagine the case where the postcopy request is exactly
+     * the page that we're sending in progress during precopy. In this case
+     * we'll have postcopy_requested set to true but the target channel
+     * will be the precopy channel (so that we don't split brain on that
+     * specific page since the precopy channel already contains partial of
+     * that page data).
+     *
+     * Besides that specific use case, postcopy_target_channel should
+     * always be equal to postcopy_requested, because by default we send
+     * postcopy pages via postcopy preempt channel.
+     */
+    bool         postcopy_target_channel;
+    /* Whether we're sending a host page */
+    bool          host_page_sending;
+    /* The start/end of current host page.  Invalid if host_page_sending==false */
+    unsigned long host_page_start;
+    unsigned long host_page_end;
+};
+typedef struct PageSearchStatus PageSearchStatus;
+
 /* struct contains XBZRLE cache and a static page
    used by the compression */
 static struct {
@@ -319,6 +359,11 @@ typedef struct {
 struct RAMState {
     /* QEMUFile used for this migration */
     QEMUFile *f;
+    /*
+     * PageSearchStatus structures for the channels when send pages.
+     * Protected by the bitmap_mutex.
+     */
+    PageSearchStatus pss[RAM_CHANNEL_MAX];
     /* UFFD file descriptor, used in 'write-tracking' migration */
     int uffdio_fd;
     /* Last block that we have visited searching for dirty pages */
@@ -362,7 +407,12 @@ struct RAMState {
     uint64_t target_page_count;
     /* number of dirty bits in the bitmap */
     uint64_t migration_dirty_pages;
-    /* Protects modification of the bitmap and migration dirty pages */
+    /*
+     * Protects:
+     * - dirty/clear bitmap
+     * - migration_dirty_pages
+     * - pss structures
+     */
     QemuMutex bitmap_mutex;
     /* The RAMBlock used in the last src_page_requests */
     RAMBlock *last_req_rb;
@@ -451,46 +501,6 @@ void dirty_sync_missed_zero_copy(void)
     ram_counters.dirty_sync_missed_zero_copy++;
 }
 
-/* used by the search for pages to send */
-struct PageSearchStatus {
-    /* The migration channel used for a specific host page */
-    QEMUFile    *pss_channel;
-    /* Current block being searched */
-    RAMBlock    *block;
-    /* Current page to search from */
-    unsigned long page;
-    /* Set once we wrap around */
-    bool         complete_round;
-    /*
-     * [POSTCOPY-ONLY] Whether current page is explicitly requested by
-     * postcopy.  When set, the request is "urgent" because the dest QEMU
-     * threads are waiting for us.
-     */
-    bool         postcopy_requested;
-    /*
-     * [POSTCOPY-ONLY] The target channel to use to send current page.
-     *
-     * Note: This may _not_ match with the value in postcopy_requested
-     * above. Let's imagine the case where the postcopy request is exactly
-     * the page that we're sending in progress during precopy. In this case
-     * we'll have postcopy_requested set to true but the target channel
-     * will be the precopy channel (so that we don't split brain on that
-     * specific page since the precopy channel already contains partial of
-     * that page data).
-     *
-     * Besides that specific use case, postcopy_target_channel should
-     * always be equal to postcopy_requested, because by default we send
-     * postcopy pages via postcopy preempt channel.
-     */
-    bool         postcopy_target_channel;
-    /* Whether we're sending a host page */
-    bool          host_page_sending;
-    /* The start/end of current host page.  Only valid if host_page_sending==true */
-    unsigned long host_page_start;
-    unsigned long host_page_end;
-};
-typedef struct PageSearchStatus PageSearchStatus;
-
 CompressionStats compression_counters;
 
 struct CompressParam {
@@ -2637,7 +2647,7 @@ static int ram_save_host_page(RAMState *rs, PageSearchStatus *pss)
  */
 static int ram_find_and_save_block(RAMState *rs)
 {
-    PageSearchStatus pss;
+    PageSearchStatus *pss = &rs->pss[RAM_CHANNEL_PRECOPY];
     int pages = 0;
     bool again, found;
 
@@ -2658,11 +2668,11 @@ static int ram_find_and_save_block(RAMState *rs)
         rs->last_page = 0;
     }
 
-    pss_init(&pss, rs->last_seen_block, rs->last_page);
+    pss_init(pss, rs->last_seen_block, rs->last_page);
 
     do {
         again = true;
-        found = get_queued_page(rs, &pss);
+        found = get_queued_page(rs, pss);
 
         if (!found) {
             /*
@@ -2670,27 +2680,27 @@ static int ram_find_and_save_block(RAMState *rs)
              * preempted precopy.  Otherwise find the next dirty bit.
              */
             if (postcopy_preempt_triggered(rs)) {
-                postcopy_preempt_restore(rs, &pss, false);
+                postcopy_preempt_restore(rs, pss, false);
                 found = true;
             } else {
                 /* priority queue empty, so just search for something dirty */
-                found = find_dirty_block(rs, &pss, &again);
+                found = find_dirty_block(rs, pss, &again);
             }
         }
 
         if (found) {
             /* Update rs->f with correct channel */
             if (postcopy_preempt_active()) {
-                postcopy_preempt_choose_channel(rs, &pss);
+                postcopy_preempt_choose_channel(rs, pss);
             }
             /* Cache rs->f in pss_channel (TODO: remove rs->f) */
-            pss.pss_channel = rs->f;
-            pages = ram_save_host_page(rs, &pss);
+            pss->pss_channel = rs->f;
+            pages = ram_save_host_page(rs, pss);
         }
     } while (!pages && again);
 
-    rs->last_seen_block = pss.block;
-    rs->last_page = pss.page;
+    rs->last_seen_block = pss->block;
+    rs->last_page = pss->page;
 
     return pages;
 }
-- 
2.38.1

