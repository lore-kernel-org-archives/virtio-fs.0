From: Greg Kurz <groug@kaod.org>
Date: Mon, 14 Feb 2022 14:58:20 +0100
Message-Id: <20220214135820.43897-4-groug@kaod.org>
In-Reply-To: <20220214135820.43897-1-groug@kaod.org>
References: <20220214135820.43897-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v5 3/3] virtiofsd: Add support for FUSE_SYNCFS
	request without announce_submounts
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

Iterate over all inodes and call syncfs() on the ones marked as submounts.
Since syncfs() can block for an indefinite time, we cannot call it with
lo->mutex held as it would prevent the server to process other requests.
This is thus broken down in two steps. First build a list of submounts
with lo->mutex held, drop the mutex and finally process the list. A
reference is taken on the inodes to ensure they don't go away when
lo->mutex is dropped.

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 tools/virtiofsd/passthrough_ll.c | 38 ++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index e94c4e6f8635..7ce944bfe2a0 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3400,8 +3400,42 @@ static void lo_syncfs(fuse_req_t req, fuse_ino_t ino)
         err = lo_do_syncfs(lo, inode);
         lo_inode_put(lo, &inode);
     } else {
-        /* Requires the sever to track submounts. Not implemented yet */
-        err = ENOSYS;
+        g_autoptr(GSList) submount_list = NULL;
+        GSList *elem;
+        GHashTableIter iter;
+        gpointer key, value;
+
+        pthread_mutex_lock(&lo->mutex);
+
+        g_hash_table_iter_init(&iter, lo->inodes);
+        while (g_hash_table_iter_next(&iter, &key, &value)) {
+            struct lo_inode *inode = value;
+
+            if (inode->is_submount) {
+                g_atomic_int_inc(&inode->refcount);
+                submount_list = g_slist_prepend(submount_list, inode);
+            }
+        }
+
+        pthread_mutex_unlock(&lo->mutex);
+
+        /* The root inode is always present and not tracked in the hash table */
+        err = lo_do_syncfs(lo, &lo->root);
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
     }
 
     fuse_reply_err(req, err);
-- 
2.34.1

