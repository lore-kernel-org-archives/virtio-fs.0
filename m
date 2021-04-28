From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 28 Apr 2021 12:50:38 -0400
Message-Id: <20210428165040.1856202-2-vgoyal@redhat.com>
In-Reply-To: <20210428165040.1856202-1-vgoyal@redhat.com>
References: <20210428165040.1856202-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v5 1/3] dax: Add an enum for specifying dax
	wakup mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, virtio-fs@redhat.com, dan.j.williams@intel.com
Cc: jack@suse.cz, miklos@szeredi.hu, willy@infradead.org, vgoyal@redhat.com

Dan mentioned that he is not very fond of passing around a boolean true/false
to specify if only next waiter should be woken up or all waiters should be
woken up. He instead prefers that we introduce an enum and make it very
explicity at the callsite itself. Easier to read code.

This patch should not introduce any change of behavior.

Reviewed-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/dax.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index b3d27fdc6775..c8cd2ae4440b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -144,6 +144,16 @@ struct wait_exceptional_entry_queue {
 	struct exceptional_entry_key key;
 };
 
+/**
+ * enum dax_wake_mode: waitqueue wakeup behaviour
+ * @WAKE_NEXT: wake only the first waiter in the waitqueue
+ * @WAKE_ALL: wake all waiters in the waitqueue
+ */
+enum dax_wake_mode {
+	WAKE_ALL,
+	WAKE_NEXT,
+};
+
 static wait_queue_head_t *dax_entry_waitqueue(struct xa_state *xas,
 		void *entry, struct exceptional_entry_key *key)
 {
@@ -182,7 +192,8 @@ static int wake_exceptional_entry_func(wait_queue_entry_t *wait,
  * The important information it's conveying is whether the entry at
  * this index used to be a PMD entry.
  */
-static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
+static void dax_wake_entry(struct xa_state *xas, void *entry,
+			   enum dax_wake_mode mode)
 {
 	struct exceptional_entry_key key;
 	wait_queue_head_t *wq;
@@ -196,7 +207,7 @@ static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
 	 * must be in the waitqueue and the following check will see them.
 	 */
 	if (waitqueue_active(wq))
-		__wake_up(wq, TASK_NORMAL, wake_all ? 0 : 1, &key);
+		__wake_up(wq, TASK_NORMAL, mode == WAKE_ALL ? 0 : 1, &key);
 }
 
 /*
@@ -268,7 +279,7 @@ static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
 	/* If we were the only waiter woken, wake the next one */
 	if (entry && !dax_is_conflict(entry))
-		dax_wake_entry(xas, entry, false);
+		dax_wake_entry(xas, entry, WAKE_NEXT);
 }
 
 /*
@@ -286,7 +297,7 @@ static void dax_unlock_entry(struct xa_state *xas, void *entry)
 	old = xas_store(xas, entry);
 	xas_unlock_irq(xas);
 	BUG_ON(!dax_is_locked(old));
-	dax_wake_entry(xas, entry, false);
+	dax_wake_entry(xas, entry, WAKE_NEXT);
 }
 
 /*
@@ -524,7 +535,7 @@ static void *grab_mapping_entry(struct xa_state *xas,
 
 		dax_disassociate_entry(entry, mapping, false);
 		xas_store(xas, NULL);	/* undo the PMD join */
-		dax_wake_entry(xas, entry, true);
+		dax_wake_entry(xas, entry, WAKE_ALL);
 		mapping->nrexceptional--;
 		entry = NULL;
 		xas_set(xas, index);
@@ -937,7 +948,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 	xas_lock_irq(xas);
 	xas_store(xas, entry);
 	xas_clear_mark(xas, PAGECACHE_TAG_DIRTY);
-	dax_wake_entry(xas, entry, false);
+	dax_wake_entry(xas, entry, WAKE_NEXT);
 
 	trace_dax_writeback_one(mapping->host, index, count);
 	return ret;
-- 
2.25.4

