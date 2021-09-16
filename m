From: Hanna Reitz <hreitz@redhat.com>
Date: Thu, 16 Sep 2021 10:40:45 +0200
Message-Id: <20210916084045.31684-13-hreitz@redhat.com>
In-Reply-To: <20210916084045.31684-1-hreitz@redhat.com>
References: <20210916084045.31684-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 12/12] virtiofsd: Add lazy lo_do_find()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Hanna Reitz <hreitz@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

lo_find() right now takes two lookup keys for two maps, namely the file
handle for inodes_by_handle and the statx information for inodes_by_ids.
However, we only need the statx information if looking up the inode by
the file handle failed.

There are two callers of lo_find(): The first one, lo_do_lookup(), has
both keys anyway, so passing them does not incur any additional cost.
The second one, lookup_name(), though, needs to explicitly invoke
name_to_handle_at() (through get_file_handle()) and statx() (through
do_statx()).  We need to try to get a file handle as the primary key, so
we cannot get rid of get_file_handle(), but we only need the statx
information if looking up an inode by handle failed; so we can defer
that until the lookup has indeed failed.

To this end, replace lo_find()'s st/mnt_id parameters by a get_ids()
closure that is invoked to fill the lo_key struct if necessary.

Also, lo_find() is renamed to lo_do_find(), so we can add a new
lo_find() wrapper whose closure just initializes the lo_key from the
st/mnt_id parameters, just like the old lo_find() did.

lookup_name() directly calls lo_do_find() now and passes its own
closure, which performs the do_statx() call.

Signed-off-by: Hanna Reitz <hreitz@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 93 +++++++++++++++++++++++++-------
 1 file changed, 75 insertions(+), 18 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index e86fad8b2f..368bad17c7 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -1348,22 +1348,23 @@ out_err:
     fuse_reply_err(req, saverr);
 }
 
-static struct lo_inode *lo_find(struct lo_data *lo,
-                                const struct lo_fhandle *fhandle,
-                                struct stat *st, uint64_t mnt_id)
+/*
+ * get_ids() will be called to get the key for lo->inodes_by_ids if
+ * the lookup by file handle has failed.
+ */
+static struct lo_inode *lo_do_find(struct lo_data *lo,
+    const struct lo_fhandle *fhandle,
+    int (*get_ids)(struct lo_key *, const void *),
+    const void *get_ids_opaque)
 {
     struct lo_inode *p = NULL;
-    struct lo_key ids_key = {
-        .ino = st->st_ino,
-        .dev = st->st_dev,
-        .mnt_id = mnt_id,
-    };
+    struct lo_key ids_key;
 
     pthread_mutex_lock(&lo->mutex);
     if (fhandle) {
         p = g_hash_table_lookup(lo->inodes_by_handle, fhandle);
     }
-    if (!p) {
+    if (!p && get_ids(&ids_key, get_ids_opaque) == 0) {
         p = g_hash_table_lookup(lo->inodes_by_ids, &ids_key);
         /*
          * When we had to fall back to looking up an inode by its
@@ -1392,6 +1393,36 @@ static struct lo_inode *lo_find(struct lo_data *lo,
     return p;
 }
 
+struct lo_find_get_ids_key_opaque {
+    const struct stat *st;
+    uint64_t mnt_id;
+};
+
+static int lo_find_get_ids_key(struct lo_key *ids_key, const void *opaque)
+{
+    const struct lo_find_get_ids_key_opaque *stat_info = opaque;
+
+    *ids_key = (struct lo_key){
+        .ino = stat_info->st->st_ino,
+        .dev = stat_info->st->st_dev,
+        .mnt_id = stat_info->mnt_id,
+    };
+
+    return 0;
+}
+
+static struct lo_inode *lo_find(struct lo_data *lo,
+                                const struct lo_fhandle *fhandle,
+                                struct stat *st, uint64_t mnt_id)
+{
+    const struct lo_find_get_ids_key_opaque stat_info = {
+        .st = st,
+        .mnt_id = mnt_id,
+    };
+
+    return lo_do_find(lo, fhandle, lo_find_get_ids_key, &stat_info);
+}
+
 /* value_destroy_func for posix_locks GHashTable */
 static void posix_locks_value_destroy(gpointer data)
 {
@@ -1930,14 +1961,41 @@ out:
     fuse_reply_err(req, saverr);
 }
 
+struct lookup_name_get_ids_key_opaque {
+    struct lo_data *lo;
+    int parent_fd;
+    const char *name;
+};
+
+static int lookup_name_get_ids_key(struct lo_key *ids_key, const void *opaque)
+{
+    const struct lookup_name_get_ids_key_opaque *stat_params = opaque;
+    uint64_t mnt_id;
+    struct stat attr;
+    int res;
+
+    res = do_statx(stat_params->lo, stat_params->parent_fd, stat_params->name,
+                   &attr, AT_SYMLINK_NOFOLLOW, &mnt_id);
+    if (res < 0) {
+        return -errno;
+    }
+
+    *ids_key = (struct lo_key){
+        .ino = attr.st_ino,
+        .dev = attr.st_dev,
+        .mnt_id = mnt_id,
+    };
+
+    return 0;
+}
+
 /* Increments nlookup and caller must release refcount using lo_inode_put() */
 static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
                                     const char *name)
 {
     g_auto(TempFd) dir_path_fd = TEMP_FD_INIT;
     int res;
-    uint64_t mnt_id;
-    struct stat attr;
+    struct lookup_name_get_ids_key_opaque stat_params;
     struct lo_fhandle *fh;
     struct lo_data *lo = lo_data(req);
     struct lo_inode *dir = lo_inode(req, parent);
@@ -1955,13 +2013,12 @@ static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
     fh = get_file_handle(lo, dir_path_fd.fd, name, NULL);
     /* Ignore errors, this is just an optional key for the lookup */
 
-    res = do_statx(lo, dir_path_fd.fd, name, &attr, AT_SYMLINK_NOFOLLOW,
-                   &mnt_id);
-    if (res == -1) {
-        goto out;
-    }
-
-    inode = lo_find(lo, fh, &attr, mnt_id);
+    stat_params = (struct lookup_name_get_ids_key_opaque){
+        .lo = lo,
+        .parent_fd = dir_path_fd.fd,
+        .name = name,
+    };
+    inode = lo_do_find(lo, fh, lookup_name_get_ids_key, &stat_params);
     release_file_handle(lo, fh, false);
 
 out:
-- 
2.31.1

