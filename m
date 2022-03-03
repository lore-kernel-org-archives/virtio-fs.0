From: Greg Kurz <groug@kaod.org>
Date: Thu,  3 Mar 2022 18:13:22 +0100
Message-Id: <20220303171323.580712-2-groug@kaod.org>
In-Reply-To: <20220303171323.580712-1-groug@kaod.org>
References: <20220303171323.580712-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/2] virtiofsd: Track submounts
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

If the server doesn't announce submounts to the client, it needs to
track them internally to properly support FUSE_SYNCFS. lo_do_lookup()
already knows how to detect them : it is a directory with a different
device ID or mount ID than its parent. Use the same logic and put
submount inodes into a dedicated hash : this will allow to iterate
on them in lo_syncfs().

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 tools/virtiofsd/passthrough_ll.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index dfa2fc250d64..177e4b46c1bb 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -165,6 +165,7 @@ struct lo_data {
     bool use_statx;
     struct lo_inode root;
     GHashTable *inodes; /* protected by lo->mutex */
+    GHashTable *submounts; /* protected by lo->mutex */
     struct lo_map ino_map; /* protected by lo->mutex */
     struct lo_map dirp_map; /* protected by lo->mutex */
     struct lo_map fd_map; /* protected by lo->mutex */
@@ -1104,6 +1105,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
     struct lo_data *lo = lo_data(req);
     struct lo_inode *inode = NULL;
     struct lo_inode *dir = lo_inode(req, parent);
+    bool is_submount;
 
     if (inodep) {
         *inodep = NULL; /* in case there is an error */
@@ -1138,8 +1140,10 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         goto out_err;
     }
 
-    if (S_ISDIR(e->attr.st_mode) && lo->announce_submounts &&
-        (e->attr.st_dev != dir->key.dev || mnt_id != dir->key.mnt_id)) {
+    is_submount = S_ISDIR(e->attr.st_mode) &&
+        (e->attr.st_dev != dir->key.dev || mnt_id != dir->key.mnt_id);
+
+    if (is_submount && lo->announce_submounts) {
         e->attr_flags |= FUSE_ATTR_SUBMOUNT;
     }
 
@@ -1174,6 +1178,9 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         pthread_mutex_lock(&lo->mutex);
         inode->fuse_ino = lo_add_inode_mapping(req, inode);
         g_hash_table_insert(lo->inodes, &inode->key, inode);
+        if (is_submount && !lo->announce_submounts) {
+            g_hash_table_insert(lo->submounts, &inode->key, inode);
+        }
         pthread_mutex_unlock(&lo->mutex);
     }
     e->ino = inode->fuse_ino;
@@ -1187,8 +1194,9 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 
     lo_inode_put(lo, &dir);
 
-    fuse_log(FUSE_LOG_DEBUG, "  %lli/%s -> %lli\n", (unsigned long long)parent,
-             name, (unsigned long long)e->ino);
+    fuse_log(FUSE_LOG_DEBUG, "  %lli/%s -> %lli%s\n",
+             (unsigned long long) parent, name, (unsigned long long) e->ino,
+             is_submount ? " (submount)" : "");
 
     return 0;
 
@@ -1745,6 +1753,9 @@ static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
     if (!inode->nlookup) {
         lo_map_remove(&lo->ino_map, inode->fuse_ino);
         g_hash_table_remove(lo->inodes, &inode->key);
+        if (!lo->announce_submounts) {
+            g_hash_table_remove(lo->submounts, &inode->key);
+        }
         if (lo->posix_lock) {
             if (g_hash_table_size(inode->posix_locks)) {
                 fuse_log(FUSE_LOG_WARNING, "Hash table is not empty\n");
@@ -4297,6 +4308,10 @@ static gboolean lo_key_equal(gconstpointer a, gconstpointer b)
 
 static void fuse_lo_data_cleanup(struct lo_data *lo)
 {
+    if (lo->submounts) {
+        g_hash_table_destroy(lo->submounts);
+    }
+
     if (lo->inodes) {
         g_hash_table_destroy(lo->inodes);
     }
@@ -4364,6 +4379,7 @@ int main(int argc, char *argv[])
 
     pthread_mutex_init(&lo.mutex, NULL);
     lo.inodes = g_hash_table_new(lo_key_hash, lo_key_equal);
+    lo.submounts = g_hash_table_new(lo_key_hash, lo_key_equal);
     lo.root.fd = -1;
     lo.root.fuse_ino = FUSE_ROOT_ID;
     lo.cache = CACHE_AUTO;
-- 
2.34.1

