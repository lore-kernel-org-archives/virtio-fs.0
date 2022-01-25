From: Greg Kurz <groug@kaod.org>
Date: Tue, 25 Jan 2022 15:12:11 +0100
Message-Id: <20220125141213.361930-2-groug@kaod.org>
In-Reply-To: <20220125141213.361930-1-groug@kaod.org>
References: <20220125141213.361930-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 1/2] virtiofsd: Track mounts
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

The upcoming implementation of ->sync_fs() needs to know about all
submounts in order to call syncfs() on them when virtiofsd is started
without '-o announce_submounts'.

Track every inode that comes up with a new mount id in a GHashTable.
If the mount id isn't available, e.g. no statx() on the host, fallback
on the device id for the key. This is done during lookup because we
only care for the submounts that the client knows about. The inode
is removed from the hash table when ultimately unreferenced. This
can happen on a per-mount basis when the client posts a FUSE_FORGET
request or for all submounts at once with FUSE_DESTROY.

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 tools/virtiofsd/passthrough_ll.c | 43 +++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 64b5b4fbb186..7bf31fc129c8 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -117,6 +117,7 @@ struct lo_inode {
     GHashTable *posix_locks; /* protected by lo_inode->plock_mutex */
 
     mode_t filetype;
+    bool is_mnt;
 };
 
 struct lo_cred {
@@ -164,6 +165,7 @@ struct lo_data {
     bool use_statx;
     struct lo_inode root;
     GHashTable *inodes; /* protected by lo->mutex */
+    GHashTable *mnt_inodes; /* protected by lo->mutex */
     struct lo_map ino_map; /* protected by lo->mutex */
     struct lo_map dirp_map; /* protected by lo->mutex */
     struct lo_map fd_map; /* protected by lo->mutex */
@@ -1000,6 +1002,31 @@ static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
     return 0;
 }
 
+static uint64_t mnt_inode_key(struct lo_inode *inode)
+{
+    /* Prefer mnt_id, fallback on dev */
+    return inode->key.mnt_id ? inode->key.mnt_id : inode->key.dev;
+}
+
+static void add_mnt_inode(struct lo_data *lo, struct lo_inode *inode)
+{
+    uint64_t mnt_key = mnt_inode_key(inode);
+
+    if (!g_hash_table_contains(lo->mnt_inodes, &mnt_key)) {
+        inode->is_mnt = true;
+        g_hash_table_insert(lo->mnt_inodes, &mnt_key, inode);
+    }
+}
+
+static void remove_mnt_inode(struct lo_data *lo, struct lo_inode *inode)
+{
+    uint64_t mnt_key = mnt_inode_key(inode);
+
+    if (inode->is_mnt) {
+        g_hash_table_remove(lo->mnt_inodes, &mnt_key);
+    }
+}
+
 /*
  * Increments nlookup on the inode on success. unref_inode_lolocked() must be
  * called eventually to decrement nlookup again. If inodep is non-NULL, the
@@ -1086,10 +1113,15 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         pthread_mutex_lock(&lo->mutex);
         inode->fuse_ino = lo_add_inode_mapping(req, inode);
         g_hash_table_insert(lo->inodes, &inode->key, inode);
+        add_mnt_inode(lo, inode);
         pthread_mutex_unlock(&lo->mutex);
     }
     e->ino = inode->fuse_ino;
 
+    fuse_log(FUSE_LOG_DEBUG, "  %lli/%s -> %lli%s\n",
+             (unsigned long long) parent, name, (unsigned long long) e->ino,
+             inode->is_mnt ? " (submount)" : "");
+
     /* Transfer ownership of inode pointer to caller or drop it */
     if (inodep) {
         *inodep = inode;
@@ -1099,9 +1131,6 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 
     lo_inode_put(lo, &dir);
 
-    fuse_log(FUSE_LOG_DEBUG, "  %lli/%s -> %lli\n", (unsigned long long)parent,
-             name, (unsigned long long)e->ino);
-
     return 0;
 
 out_err:
@@ -1563,6 +1592,7 @@ static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
             g_hash_table_destroy(inode->posix_locks);
             pthread_mutex_destroy(&inode->plock_mutex);
         }
+        remove_mnt_inode(lo, inode);
         /* Drop our refcount from lo_do_lookup() */
         lo_inode_put(lo, &inode);
     }
@@ -3337,6 +3367,7 @@ static void lo_destroy(void *userdata)
     struct lo_data *lo = (struct lo_data *)userdata;
 
     pthread_mutex_lock(&lo->mutex);
+    g_hash_table_remove_all(lo->mnt_inodes);
     while (true) {
         GHashTableIter iter;
         gpointer key, value;
@@ -3850,6 +3881,7 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
         root->posix_locks = g_hash_table_new_full(
             g_direct_hash, g_direct_equal, NULL, posix_locks_value_destroy);
     }
+    add_mnt_inode(lo, root);
 }
 
 static guint lo_key_hash(gconstpointer key)
@@ -3869,6 +3901,10 @@ static gboolean lo_key_equal(gconstpointer a, gconstpointer b)
 
 static void fuse_lo_data_cleanup(struct lo_data *lo)
 {
+    if (lo->mnt_inodes) {
+        g_hash_table_destroy(lo->mnt_inodes);
+    }
+
     if (lo->inodes) {
         g_hash_table_destroy(lo->inodes);
     }
@@ -3931,6 +3967,7 @@ int main(int argc, char *argv[])
     lo.root.fd = -1;
     lo.root.fuse_ino = FUSE_ROOT_ID;
     lo.cache = CACHE_AUTO;
+    lo.mnt_inodes = g_hash_table_new(g_int64_hash, g_int64_equal);
 
     /*
      * Set up the ino map like this:
-- 
2.34.1

