Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:52:16 +0100
Message-Id: <20221205095228.1314-40-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 39/51] migration: Teach PSS about host page
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

Migration code has a lot to do with host pages.  Teaching PSS core about
the idea of host page helps a lot and makes the code clean.  Meanwhile,
this prepares for the future changes that can leverage the new PSS helpers
that this patch introduces to send host page in another thread.

Three more fields are introduced for this:

  (1) host_page_sending: this is set to true when QEMU is sending a host
      page, false otherwise.

  (2) host_page_{start|end}: these point to the start/end of host page
      we're sending, and it's only valid when host_page_sending==true.

For example, when we look up the next dirty page on the ramblock, with
host_page_sending==true, we'll not try to look for anything beyond the
current host page boundary.  This can be slightly efficient than current
code because currently we'll set pss->page to next dirty bit (which can be
over current host page boundary) and reset it to host page boundary if we
found it goes beyond that.

With above, we can easily make migration_bitmap_find_dirty() self contained
by updating pss->page properly.  rs* parameter is removed because it's not
even used in old code.

When sending a host page, we should use the pss helpers like this:

  - pss_host_page_prepare(pss): called before sending host page
  - pss_within_range(pss): whether we're still working on the cur host page?
  - pss_host_page_finish(pss): called after sending a host page

Then we can use ram_save_target_page() to save one small page.

Currently ram_save_host_page() is still the only user. If there'll be
another function to send host page (e.g. in return path thread) in the
future, it should follow the same style.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 95 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 76 insertions(+), 19 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index f4cd9038f4..4d7b50ef79 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -481,6 +481,11 @@ struct PageSearchStatus {
      * postcopy pages via postcopy preempt channel.
      */
     bool         postcopy_target_channel;
+    /* Whether we're sending a host page */
+    bool          host_page_sending;
+    /* The start/end of current host page.  Only valid if host_page_sending==true */
+    unsigned long host_page_start;
+    unsigned long host_page_end;
 };
 typedef struct PageSearchStatus PageSearchStatus;
 
@@ -858,26 +863,38 @@ static int save_xbzrle_page(RAMState *rs, uint8_t **current_data,
 }
 
 /**
- * migration_bitmap_find_dirty: find the next dirty page from start
+ * pss_find_next_dirty: find the next dirty page of current ramblock
  *
- * Returns the page offset within memory region of the start of a dirty page
+ * This function updates pss->page to point to the next dirty page index
+ * within the ramblock to migrate, or the end of ramblock when nothing
+ * found.  Note that when pss->host_page_sending==true it means we're
+ * during sending a host page, so we won't look for dirty page that is
+ * outside the host page boundary.
  *
- * @rs: current RAM state
- * @rb: RAMBlock where to search for dirty pages
- * @start: page where we start the search
+ * @pss: the current page search status
  */
-static inline
-unsigned long migration_bitmap_find_dirty(RAMState *rs, RAMBlock *rb,
-                                          unsigned long start)
+static void pss_find_next_dirty(PageSearchStatus *pss)
 {
+    RAMBlock *rb = pss->block;
     unsigned long size = rb->used_length >> TARGET_PAGE_BITS;
     unsigned long *bitmap = rb->bmap;
 
     if (ramblock_is_ignored(rb)) {
-        return size;
+        /* Points directly to the end, so we know no dirty page */
+        pss->page = size;
+        return;
     }
 
-    return find_next_bit(bitmap, size, start);
+    /*
+     * If during sending a host page, only look for dirty pages within the
+     * current host page being send.
+     */
+    if (pss->host_page_sending) {
+        assert(pss->host_page_end);
+        size = MIN(size, pss->host_page_end);
+    }
+
+    pss->page = find_next_bit(bitmap, size, pss->page);
 }
 
 static void migration_clear_memory_region_dirty_bitmap(RAMBlock *rb,
@@ -1563,7 +1580,9 @@ static bool find_dirty_block(RAMState *rs, PageSearchStatus *pss, bool *again)
     pss->postcopy_requested = false;
     pss->postcopy_target_channel = RAM_CHANNEL_PRECOPY;
 
-    pss->page = migration_bitmap_find_dirty(rs, pss->block, pss->page);
+    /* Update pss->page for the next dirty bit in ramblock */
+    pss_find_next_dirty(pss);
+
     if (pss->complete_round && pss->block == rs->last_seen_block &&
         pss->page >= rs->last_page) {
         /*
@@ -2452,6 +2471,44 @@ static void postcopy_preempt_reset_channel(RAMState *rs)
     }
 }
 
+/* Should be called before sending a host page */
+static void pss_host_page_prepare(PageSearchStatus *pss)
+{
+    /* How many guest pages are there in one host page? */
+    size_t guest_pfns = qemu_ram_pagesize(pss->block) >> TARGET_PAGE_BITS;
+
+    pss->host_page_sending = true;
+    pss->host_page_start = ROUND_DOWN(pss->page, guest_pfns);
+    pss->host_page_end = ROUND_UP(pss->page + 1, guest_pfns);
+}
+
+/*
+ * Whether the page pointed by PSS is within the host page being sent.
+ * Must be called after a previous pss_host_page_prepare().
+ */
+static bool pss_within_range(PageSearchStatus *pss)
+{
+    ram_addr_t ram_addr;
+
+    assert(pss->host_page_sending);
+
+    /* Over host-page boundary? */
+    if (pss->page >= pss->host_page_end) {
+        return false;
+    }
+
+    ram_addr = ((ram_addr_t)pss->page) << TARGET_PAGE_BITS;
+
+    return offset_in_ramblock(pss->block, ram_addr);
+}
+
+static void pss_host_page_finish(PageSearchStatus *pss)
+{
+    pss->host_page_sending = false;
+    /* This is not needed, but just to reset it */
+    pss->host_page_start = pss->host_page_end = 0;
+}
+
 /**
  * ram_save_host_page: save a whole host page
  *
@@ -2479,8 +2536,6 @@ static int ram_save_host_page(RAMState *rs, PageSearchStatus *pss)
     int tmppages, pages = 0;
     size_t pagesize_bits =
         qemu_ram_pagesize(pss->block) >> TARGET_PAGE_BITS;
-    unsigned long hostpage_boundary =
-        QEMU_ALIGN_UP(pss->page + 1, pagesize_bits);
     unsigned long start_page = pss->page;
     int res;
 
@@ -2493,6 +2548,9 @@ static int ram_save_host_page(RAMState *rs, PageSearchStatus *pss)
         postcopy_preempt_choose_channel(rs, pss);
     }
 
+    /* Update host page boundary information */
+    pss_host_page_prepare(pss);
+
     do {
         if (postcopy_needs_preempt(rs, pss)) {
             postcopy_do_preempt(rs, pss);
@@ -2530,15 +2588,14 @@ static int ram_save_host_page(RAMState *rs, PageSearchStatus *pss)
         }
 
         if (tmppages < 0) {
+            pss_host_page_finish(pss);
             return tmppages;
         }
 
-        pss->page = migration_bitmap_find_dirty(rs, pss->block, pss->page);
-    } while ((pss->page < hostpage_boundary) &&
-             offset_in_ramblock(pss->block,
-                                ((ram_addr_t)pss->page) << TARGET_PAGE_BITS));
-    /* The offset we leave with is the min boundary of host page and block */
-    pss->page = MIN(pss->page, hostpage_boundary);
+        pss_find_next_dirty(pss);
+    } while (pss_within_range(pss));
+
+    pss_host_page_finish(pss);
 
     /*
      * When with postcopy preempt mode, flush the data as soon as possible for
-- 
2.38.1

