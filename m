Date: Mon, 19 Apr 2021 14:45:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210419184516.GC1472665@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH][v2] dax: Fix missed wakeup during dax entry
	invalidation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Linux fsdevel mailing list <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, willy@infradead.org
Cc: virtio-fs-list <virtio-fs@redhat.com>, linux-nvdimm@lists.01.org, linux kernel mailing list <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

This is V2 of the patch. Posted V1 here.

https://lore.kernel.org/linux-fsdevel/20210416173524.GA1379987@redhat.com/

Based on feedback from Dan and Jan, modified the patch to wake up 
all waiters when dax entry is invalidated. This solves the issues
of missed wakeups.

I am seeing missed wakeups which ultimately lead to a deadlock when I am
using virtiofs with DAX enabled and running "make -j". I had to mount
virtiofs as rootfs and also reduce to dax window size to 256M to reproduce
the problem consistently.

So here is the problem. put_unlocked_entry() wakes up waiters only
if entry is not null as well as !dax_is_conflict(entry). But if I
call multiple instances of invalidate_inode_pages2() in parallel,
then I can run into a situation where there are waiters on
this index but nobody will wait these.

invalidate_inode_pages2()
  invalidate_inode_pages2_range()
    invalidate_exceptional_entry2()
      dax_invalidate_mapping_entry_sync()
        __dax_invalidate_entry() {
                xas_lock_irq(&xas);
                entry = get_unlocked_entry(&xas, 0);
                ...
                ...
                dax_disassociate_entry(entry, mapping, trunc);
                xas_store(&xas, NULL);
                ...
                ...
                put_unlocked_entry(&xas, entry);
                xas_unlock_irq(&xas);
        }

Say a fault in in progress and it has locked entry at offset say "0x1c".
Now say three instances of invalidate_inode_pages2() are in progress
(A, B, C) and they all try to invalidate entry at offset "0x1c". Given
dax entry is locked, all tree instances A, B, C will wait in wait queue.

When dax fault finishes, say A is woken up. It will store NULL entry
at index "0x1c" and wake up B. When B comes along it will find "entry=0"
at page offset 0x1c and it will call put_unlocked_entry(&xas, 0). And
this means put_unlocked_entry() will not wake up next waiter, given
the current code. And that means C continues to wait and is not woken
up.

This patch fixes the issue by waking up all waiters when a dax entry
has been invalidated. This seems to fix the deadlock I am facing
and I can make forward progress.

Reported-by: Sergio Lopez <slp@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/dax.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: redhat-linux/fs/dax.c
===================================================================
--- redhat-linux.orig/fs/dax.c	2021-04-16 14:16:44.332140543 -0400
+++ redhat-linux/fs/dax.c	2021-04-19 11:24:11.465213474 -0400
@@ -264,11 +264,11 @@ static void wait_entry_unlocked(struct x
 	finish_wait(wq, &ewait.wait);
 }
 
-static void put_unlocked_entry(struct xa_state *xas, void *entry)
+static void put_unlocked_entry(struct xa_state *xas, void *entry, bool wake_all)
 {
 	/* If we were the only waiter woken, wake the next one */
 	if (entry && !dax_is_conflict(entry))
-		dax_wake_entry(xas, entry, false);
+		dax_wake_entry(xas, entry, wake_all);
 }
 
 /*
@@ -622,7 +622,7 @@ struct page *dax_layout_busy_page_range(
 			entry = get_unlocked_entry(&xas, 0);
 		if (entry)
 			page = dax_busy_page(entry);
-		put_unlocked_entry(&xas, entry);
+		put_unlocked_entry(&xas, entry, false);
 		if (page)
 			break;
 		if (++scanned % XA_CHECK_SCHED)
@@ -664,7 +664,7 @@ static int __dax_invalidate_entry(struct
 	mapping->nrexceptional--;
 	ret = 1;
 out:
-	put_unlocked_entry(&xas, entry);
+	put_unlocked_entry(&xas, entry, true);
 	xas_unlock_irq(&xas);
 	return ret;
 }
@@ -943,7 +943,7 @@ static int dax_writeback_one(struct xa_s
 	return ret;
 
  put_unlocked:
-	put_unlocked_entry(xas, entry);
+	put_unlocked_entry(xas, entry, false);
 	return ret;
 }
 
@@ -1684,7 +1684,7 @@ dax_insert_pfn_mkwrite(struct vm_fault *
 	/* Did we race with someone splitting entry or so? */
 	if (!entry || dax_is_conflict(entry) ||
 	    (order == 0 && !dax_is_pte_entry(entry))) {
-		put_unlocked_entry(&xas, entry);
+		put_unlocked_entry(&xas, entry, false);
 		xas_unlock_irq(&xas);
 		trace_dax_insert_pfn_mkwrite_no_entry(mapping->host, vmf,
 						      VM_FAULT_NOPAGE);

