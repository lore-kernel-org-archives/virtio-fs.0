Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:52:21 +0100
Message-Id: <20221205095228.1314-45-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 44/51] migration: Send requested page
 directly in rp-return thread
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

With all the facilities ready, send the requested page directly in the
rp-return thread rather than queuing it in the request queue, if and only
if postcopy preempt is enabled.  It can achieve so because it uses separate
channel for sending urgent pages.  The only shared data is bitmap and it's
protected by the bitmap_mutex.

Note that since we're moving the ownership of the urgent channel from the
migration thread to rp thread it also means the rp thread is responsible
for managing the qemufile, e.g. properly close it when pausing migration
happens.  For this, let migration_release_from_dst_file to cover shutdown
of the urgent channel too, renaming it as migration_release_dst_files() to
better show what it does.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/migration.c |  35 +++++++------
 migration/ram.c       | 112 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 131 insertions(+), 16 deletions(-)

diff --git a/migration/migration.c b/migration/migration.c
index de83c50f51..c1d4d76d0c 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -2848,8 +2848,11 @@ static int migrate_handle_rp_resume_ack(MigrationState *s, uint32_t value)
     return 0;
 }
 
-/* Release ms->rp_state.from_dst_file in a safe way */
-static void migration_release_from_dst_file(MigrationState *ms)
+/*
+ * Release ms->rp_state.from_dst_file (and postcopy_qemufile_src if
+ * existed) in a safe way.
+ */
+static void migration_release_dst_files(MigrationState *ms)
 {
     QEMUFile *file;
 
@@ -2862,6 +2865,18 @@ static void migration_release_from_dst_file(MigrationState *ms)
         ms->rp_state.from_dst_file = NULL;
     }
 
+    /*
+     * Do the same to postcopy fast path socket too if there is.  No
+     * locking needed because this qemufile should only be managed by
+     * return path thread.
+     */
+    if (ms->postcopy_qemufile_src) {
+        migration_ioc_unregister_yank_from_file(ms->postcopy_qemufile_src);
+        qemu_file_shutdown(ms->postcopy_qemufile_src);
+        qemu_fclose(ms->postcopy_qemufile_src);
+        ms->postcopy_qemufile_src = NULL;
+    }
+
     qemu_fclose(file);
 }
 
@@ -3006,7 +3021,7 @@ out:
              * Maybe there is something we can do: it looks like a
              * network down issue, and we pause for a recovery.
              */
-            migration_release_from_dst_file(ms);
+            migration_release_dst_files(ms);
             rp = NULL;
             if (postcopy_pause_return_path_thread(ms)) {
                 /*
@@ -3024,7 +3039,7 @@ out:
     }
 
     trace_source_return_path_thread_end();
-    migration_release_from_dst_file(ms);
+    migration_release_dst_files(ms);
     rcu_unregister_thread();
     return NULL;
 }
@@ -3547,18 +3562,6 @@ static MigThrError postcopy_pause(MigrationState *s)
         qemu_file_shutdown(file);
         qemu_fclose(file);
 
-        /*
-         * Do the same to postcopy fast path socket too if there is.  No
-         * locking needed because no racer as long as we do this before setting
-         * status to paused.
-         */
-        if (s->postcopy_qemufile_src) {
-            migration_ioc_unregister_yank_from_file(s->postcopy_qemufile_src);
-            qemu_file_shutdown(s->postcopy_qemufile_src);
-            qemu_fclose(s->postcopy_qemufile_src);
-            s->postcopy_qemufile_src = NULL;
-        }
-
         migrate_set_state(&s->state, s->state,
                           MIGRATION_STATUS_POSTCOPY_PAUSED);
 
diff --git a/migration/ram.c b/migration/ram.c
index 1233ff53ac..16ade7cb70 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -546,6 +546,8 @@ static QemuThread *decompress_threads;
 static QemuMutex decomp_done_lock;
 static QemuCond decomp_done_cond;
 
+static int ram_save_host_page_urgent(PageSearchStatus *pss);
+
 static bool do_compress_ram_page(QEMUFile *f, z_stream *stream, RAMBlock *block,
                                  ram_addr_t offset, uint8_t *source_buf);
 
@@ -560,6 +562,16 @@ static void pss_init(PageSearchStatus *pss, RAMBlock *rb, ram_addr_t page)
     pss->complete_round = false;
 }
 
+/*
+ * Check whether two PSSs are actively sending the same page.  Return true
+ * if it is, false otherwise.
+ */
+static bool pss_overlap(PageSearchStatus *pss1, PageSearchStatus *pss2)
+{
+    return pss1->host_page_sending && pss2->host_page_sending &&
+        (pss1->host_page_start == pss2->host_page_start);
+}
+
 static void *do_data_compress(void *opaque)
 {
     CompressParam *param = opaque;
@@ -2260,6 +2272,57 @@ int ram_save_queue_pages(const char *rbname, ram_addr_t start, ram_addr_t len)
         return -1;
     }
 
+    /*
+     * When with postcopy preempt, we send back the page directly in the
+     * rp-return thread.
+     */
+    if (postcopy_preempt_active()) {
+        ram_addr_t page_start = start >> TARGET_PAGE_BITS;
+        size_t page_size = qemu_ram_pagesize(ramblock);
+        PageSearchStatus *pss = &ram_state->pss[RAM_CHANNEL_POSTCOPY];
+        int ret = 0;
+
+        qemu_mutex_lock(&rs->bitmap_mutex);
+
+        pss_init(pss, ramblock, page_start);
+        /*
+         * Always use the preempt channel, and make sure it's there.  It's
+         * safe to access without lock, because when rp-thread is running
+         * we should be the only one who operates on the qemufile
+         */
+        pss->pss_channel = migrate_get_current()->postcopy_qemufile_src;
+        pss->postcopy_requested = true;
+        assert(pss->pss_channel);
+
+        /*
+         * It must be either one or multiple of host page size.  Just
+         * assert; if something wrong we're mostly split brain anyway.
+         */
+        assert(len % page_size == 0);
+        while (len) {
+            if (ram_save_host_page_urgent(pss)) {
+                error_report("%s: ram_save_host_page_urgent() failed: "
+                             "ramblock=%s, start_addr=0x"RAM_ADDR_FMT,
+                             __func__, ramblock->idstr, start);
+                ret = -1;
+                break;
+            }
+            /*
+             * NOTE: after ram_save_host_page_urgent() succeeded, pss->page
+             * will automatically be moved and point to the next host page
+             * we're going to send, so no need to update here.
+             *
+             * Normally QEMU never sends >1 host page in requests, so
+             * logically we don't even need that as the loop should only
+             * run once, but just to be consistent.
+             */
+            len -= page_size;
+        };
+        qemu_mutex_unlock(&rs->bitmap_mutex);
+
+        return ret;
+    }
+
     struct RAMSrcPageRequest *new_entry =
         g_new0(struct RAMSrcPageRequest, 1);
     new_entry->rb = ramblock;
@@ -2537,6 +2600,55 @@ static void pss_host_page_finish(PageSearchStatus *pss)
     pss->host_page_start = pss->host_page_end = 0;
 }
 
+/*
+ * Send an urgent host page specified by `pss'.  Need to be called with
+ * bitmap_mutex held.
+ *
+ * Returns 0 if save host page succeeded, false otherwise.
+ */
+static int ram_save_host_page_urgent(PageSearchStatus *pss)
+{
+    bool page_dirty, sent = false;
+    RAMState *rs = ram_state;
+    int ret = 0;
+
+    trace_postcopy_preempt_send_host_page(pss->block->idstr, pss->page);
+    pss_host_page_prepare(pss);
+
+    /*
+     * If precopy is sending the same page, let it be done in precopy, or
+     * we could send the same page in two channels and none of them will
+     * receive the whole page.
+     */
+    if (pss_overlap(pss, &ram_state->pss[RAM_CHANNEL_PRECOPY])) {
+        trace_postcopy_preempt_hit(pss->block->idstr,
+                                   pss->page << TARGET_PAGE_BITS);
+        return 0;
+    }
+
+    do {
+        page_dirty = migration_bitmap_clear_dirty(rs, pss->block, pss->page);
+
+        if (page_dirty) {
+            /* Be strict to return code; it must be 1, or what else? */
+            if (ram_save_target_page(rs, pss) != 1) {
+                error_report_once("%s: ram_save_target_page failed", __func__);
+                ret = -1;
+                goto out;
+            }
+            sent = true;
+        }
+        pss_find_next_dirty(pss);
+    } while (pss_within_range(pss));
+out:
+    pss_host_page_finish(pss);
+    /* For urgent requests, flush immediately if sent */
+    if (sent) {
+        qemu_fflush(pss->pss_channel);
+    }
+    return ret;
+}
+
 /**
  * ram_save_host_page: save a whole host page
  *
-- 
2.38.1

