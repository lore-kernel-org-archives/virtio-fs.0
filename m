From: Greg Kurz <groug@kaod.org>
Date: Thu,  3 Mar 2022 18:13:23 +0100
Message-Id: <20220303171323.580712-3-groug@kaod.org>
In-Reply-To: <20220303171323.580712-1-groug@kaod.org>
References: <20220303171323.580712-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/2] virtiofsd: Support FUSE_SYNCFS on
	unannounced submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

This adds the missing bits to support FUSE_SYNCFS in the case submounts
aren't announced to the client.

Iterate over all submounts and call syncfs() on them. Since syncfs() can
block for an indefinite time, we cannot call it with lo->mutex held as
it would prevent the server to process other requests. Generate a list
of submounts with lo->mutex held and bump their reference count to
ensure they don't vanish when lo->mutex is dropped.

Each individual call to syncfs() can legitimately fail. Try to flush
as much as possible anyway. A single error will be returned to the
client so that it knows that the flush didn't fully succeed.

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 tools/virtiofsd/passthrough_ll.c | 37 ++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 177e4b46c1bb..628ae0e9589d 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3746,9 +3746,42 @@ static void lo_syncfs(fuse_req_t req, fuse_ino_t ino)
 
     /*
      * If submounts aren't announced, the client only sends a request to
-     * sync the root inode. TODO: Track submounts internally and iterate
-     * over them as well.
+     * sync the root inode. Iterate over the known submounts to sync them
+     * as well.
      */
+    if (!lo->announce_submounts) {
+        g_autoptr(GSList) submount_list = NULL;
+        GSList *elem;
+        GHashTableIter iter;
+        gpointer key, value;
+
+        pthread_mutex_lock(&lo->mutex);
+
+        g_hash_table_iter_init(&iter, lo->submounts);
+        while (g_hash_table_iter_next(&iter, &key, &value)) {
+            struct lo_inode *inode = value;
+
+            g_atomic_int_inc(&inode->refcount);
+            submount_list = g_slist_prepend(submount_list, inode);
+        }
+
+        pthread_mutex_unlock(&lo->mutex);
+
+        for (elem = submount_list; elem; elem = g_slist_next(elem)) {
+            struct lo_inode *inode = elem->data;
+            int r;
+
+            r = lo_do_syncfs(lo, inode);
+            if (r) {
+                /*
+                 * Try to sync as much as possible. Only one error can be
+                 * reported to the client though, arbitrarily the last one.
+                 */
+                err = r;
+            }
+            lo_inode_put(lo, &inode);
+        }
+    }
 
     fuse_reply_err(req, err);
 }
-- 
2.34.1

