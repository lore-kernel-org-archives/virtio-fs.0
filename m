From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri,  7 Aug 2020 15:55:08 -0400
Message-Id: <20200807195526.426056-3-vgoyal@redhat.com>
In-Reply-To: <20200807195526.426056-1-vgoyal@redhat.com>
References: <20200807195526.426056-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 02/20] dax: Create a range version of
	dax_layout_busy_page()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com
Cc: linux-nvdimm@lists.01.org, miklos@szeredi.hu, Dan Williams <dan.j.williams@intel.com>, vgoyal@redhat.com

virtiofs device has a range of memory which is mapped into file inodes
using dax. This memory is mapped in qemu on host and maps different
sections of real file on host. Size of this memory is limited
(determined by administrator) and depending on filesystem size, we will
soon reach a situation where all the memory is in use and we need to
reclaim some.

As part of reclaim process, we will need to make sure that there are
no active references to pages (taken by get_user_pages()) on the memory
range we are trying to reclaim. I am planning to use
dax_layout_busy_page() for this. But in current form this is per inode
and scans through all the pages of the inode.

We want to reclaim only a portion of memory (say 2MB page). So we want
to make sure that only that 2MB range of pages do not have any
references  (and don't want to unmap all the pages of inode).

Hence, create a range version of this function named
dax_layout_busy_page_range() which can be used to pass a range which
needs to be unmapped.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/dax.c            | 66 ++++++++++++++++++++++++++++++++-------------
 include/linux/dax.h |  6 +++++
 2 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 11b16729b86f..0d51b0fbb489 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -558,27 +558,20 @@ static void *grab_mapping_entry(struct xa_state *xas,
 	return xa_mk_internal(VM_FAULT_FALLBACK);
 }
 
-/**
- * dax_layout_busy_page - find first pinned page in @mapping
- * @mapping: address space to scan for a page with ref count > 1
- *
- * DAX requires ZONE_DEVICE mapped pages. These pages are never
- * 'onlined' to the page allocator so they are considered idle when
- * page->count == 1. A filesystem uses this interface to determine if
- * any page in the mapping is busy, i.e. for DMA, or other
- * get_user_pages() usages.
- *
- * It is expected that the filesystem is holding locks to block the
- * establishment of new mappings in this address_space. I.e. it expects
- * to be able to run unmap_mapping_range() and subsequently not race
- * mapping_mapped() becoming true.
+/*
+ * Partial pages are included. If end is LLONG_MAX, pages in the range from
+ * start to end of the file are inluded.
  */
-struct page *dax_layout_busy_page(struct address_space *mapping)
+struct page *dax_layout_busy_page_range(struct address_space *mapping,
+					loff_t start, loff_t end)
 {
-	XA_STATE(xas, &mapping->i_pages, 0);
 	void *entry;
 	unsigned int scanned = 0;
 	struct page *page = NULL;
+	pgoff_t start_idx = start >> PAGE_SHIFT;
+	pgoff_t end_idx = end >> PAGE_SHIFT;
+	XA_STATE(xas, &mapping->i_pages, start_idx);
+	loff_t len, lstart = round_down(start, PAGE_SIZE);
 
 	/*
 	 * In the 'limited' case get_user_pages() for dax is disabled.
@@ -589,6 +582,22 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
 	if (!dax_mapping(mapping) || !mapping_mapped(mapping))
 		return NULL;
 
+	/* If end == LLONG_MAX, all pages from start to till end of file */
+	if (end == LLONG_MAX) {
+		end_idx = ULONG_MAX;
+		len = 0;
+	} else {
+		/* length is being calculated from lstart and not start.
+		 * This is due to behavior of unmap_mapping_range(). If
+		 * start is say 4094 and end is on 4096 then we want to
+		 * unamp two pages, idx 0 and 1. But unmap_mapping_range()
+		 * will unmap only page at idx 0. If we calculate len
+		 * from the rounded down start, this problem should not
+		 * happen.
+		 */
+		len = end - lstart + 1;
+	}
+
 	/*
 	 * If we race get_user_pages_fast() here either we'll see the
 	 * elevated page count in the iteration and wait, or
@@ -601,10 +610,10 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
 	 * guaranteed to either see new references or prevent new
 	 * references from being established.
 	 */
-	unmap_mapping_range(mapping, 0, 0, 0);
+	unmap_mapping_range(mapping, start, len, 0);
 
 	xas_lock_irq(&xas);
-	xas_for_each(&xas, entry, ULONG_MAX) {
+	xas_for_each(&xas, entry, end_idx) {
 		if (WARN_ON_ONCE(!xa_is_value(entry)))
 			continue;
 		if (unlikely(dax_is_locked(entry)))
@@ -625,6 +634,27 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
 	xas_unlock_irq(&xas);
 	return page;
 }
+EXPORT_SYMBOL_GPL(dax_layout_busy_page_range);
+
+/**
+ * dax_layout_busy_page - find first pinned page in @mapping
+ * @mapping: address space to scan for a page with ref count > 1
+ *
+ * DAX requires ZONE_DEVICE mapped pages. These pages are never
+ * 'onlined' to the page allocator so they are considered idle when
+ * page->count == 1. A filesystem uses this interface to determine if
+ * any page in the mapping is busy, i.e. for DMA, or other
+ * get_user_pages() usages.
+ *
+ * It is expected that the filesystem is holding locks to block the
+ * establishment of new mappings in this address_space. I.e. it expects
+ * to be able to run unmap_mapping_range() and subsequently not race
+ * mapping_mapped() becoming true.
+ */
+struct page *dax_layout_busy_page(struct address_space *mapping)
+{
+	return dax_layout_busy_page_range(mapping, 0, 0);
+}
 EXPORT_SYMBOL_GPL(dax_layout_busy_page);
 
 static int __dax_invalidate_entry(struct address_space *mapping,
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 6904d4e0b2e0..9016929db4c6 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -141,6 +141,7 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 		struct dax_device *dax_dev, struct writeback_control *wbc);
 
 struct page *dax_layout_busy_page(struct address_space *mapping);
+struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
 dax_entry_t dax_lock_page(struct page *page);
 void dax_unlock_page(struct page *page, dax_entry_t cookie);
 #else
@@ -171,6 +172,11 @@ static inline struct page *dax_layout_busy_page(struct address_space *mapping)
 	return NULL;
 }
 
+static inline struct page *dax_layout_busy_page_range(struct address_space *mapping, pgoff_t start, pgoff_t nr_pages)
+{
+	return NULL;
+}
+
 static inline int dax_writeback_mapping_range(struct address_space *mapping,
 		struct dax_device *dax_dev, struct writeback_control *wbc)
 {
-- 
2.25.4

