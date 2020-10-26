From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Mon, 26 Oct 2020 18:43:29 +0000
Message-Id: <20201026184331.272953-15-dgilbert@redhat.com>
In-Reply-To: <20201026184331.272953-1-dgilbert@redhat.com>
References: <20201026184331.272953-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 14/16] virtiofsd: Announce sub-mount points
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, mreitz@redhat.com, misono.tomohiro@jp.fujitsu.com
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

From: Max Reitz <mreitz@redhat.com>

Whenever we encounter a directory with an st_dev that differs from that
of its parent, we set the FUSE_ATTR_SUBMOUNT flag so the guest can
create a submount for it.

Make this behavior optional, so submounts are only announced to the
guest with the announce_submounts option.  Some users may prefer the
current behavior, so that the guest learns nothing about the host mount
structure.

Signed-off-by: Max Reitz <mreitz@redhat.com>
Message-Id: <20200909184028.262297-7-mreitz@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
  Manual merge
---
 tools/virtiofsd/helper.c         |  1 +
 tools/virtiofsd/passthrough_ll.c | 67 ++++++++++++++++++++++++++++----
 2 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
index 2e181a49b5..a212f32931 100644
--- a/tools/virtiofsd/helper.c
+++ b/tools/virtiofsd/helper.c
@@ -178,6 +178,7 @@ void fuse_cmdline_help(void)
            "                               default: depends on cache= option.\n"
            "    -o writeback|no_writeback  enable/disable writeback cache\n"
            "                               default: no_writeback\n"
+           "    -o announce_submounts      Announce sub-mount points to the guest\n"
            "    -o xattr|no_xattr          enable/disable xattr\n"
            "                               default: no_xattr\n"
            "    -o modcaps=CAPLIST         Modify the list of capabilities\n"
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 4188bf3ad2..4db50046d4 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -40,6 +40,7 @@
 #include "fuse_virtio.h"
 #include "fuse_log.h"
 #include "fuse_lowlevel.h"
+#include "standard-headers/linux/fuse.h"
 #include <assert.h>
 #include <cap-ng.h>
 #include <dirent.h>
@@ -173,6 +174,7 @@ struct lo_data {
     int timeout_set;
     int readdirplus_set;
     int readdirplus_clear;
+    int announce_submounts;
     int allow_direct_io;
     struct lo_inode root;
     GHashTable *inodes; /* protected by lo->mutex */
@@ -211,6 +213,7 @@ static const struct fuse_opt lo_opts[] = {
     { "cache=always", offsetof(struct lo_data, cache), CACHE_ALWAYS },
     { "readdirplus", offsetof(struct lo_data, readdirplus_set), 1 },
     { "no_readdirplus", offsetof(struct lo_data, readdirplus_clear), 1 },
+    { "announce_submounts", offsetof(struct lo_data, announce_submounts), 1 },
     { "allow_direct_io", offsetof(struct lo_data, allow_direct_io), 1 },
     { "no_allow_direct_io", offsetof(struct lo_data, allow_direct_io), 0 },
     FUSE_OPT_END
@@ -608,22 +611,52 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
     }
 }
 
+/**
+ * Call fstatat() and set st_rdev whenever a directory's st_dev
+ * differs from the rparent's st_dev (@parent_dev).  This will
+ * announce submounts to the FUSE client (unless @announce_submounts
+ * is false).
+ */
+static int do_fstatat(int dirfd, const char *pathname, struct stat *statbuf,
+                      int flags, dev_t parent_dev, uint32_t *fuse_attr_flags)
+{
+    int res = fstatat(dirfd, pathname, statbuf, flags);
+    if (res == -1) {
+        return res;
+    }
+
+    if (statbuf->st_dev != parent_dev && S_ISDIR(statbuf->st_mode) &&
+        fuse_attr_flags)
+    {
+        *fuse_attr_flags |= FUSE_ATTR_SUBMOUNT;
+    }
+
+    return 0;
+}
+
 static void lo_getattr(fuse_req_t req, fuse_ino_t ino,
                        struct fuse_file_info *fi)
 {
     int res;
     struct stat buf;
     struct lo_data *lo = lo_data(req);
+    struct lo_inode *inode = lo_inode(req, ino);
+    uint32_t fuse_attr_flags = 0;
 
     (void)fi;
 
-    res =
-        fstatat(lo_fd(req, ino), "", &buf, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+    res = do_fstatat(inode->fd, "", &buf, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW,
+                     inode->parent_dev, &fuse_attr_flags);
+    lo_inode_put(lo, &inode);
     if (res == -1) {
         return (void)fuse_reply_err(req, errno);
     }
 
-    fuse_reply_attr(req, &buf, lo->timeout);
+    if (!lo->announce_submounts) {
+        fuse_attr_flags &= ~FUSE_ATTR_SUBMOUNT;
+    }
+
+    fuse_reply_attr_with_flags(req, &buf, lo->timeout, fuse_attr_flags);
 }
 
 static int lo_fi_fd(fuse_req_t req, struct fuse_file_info *fi)
@@ -819,11 +852,16 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         goto out_err;
     }
 
-    res = fstatat(newfd, "", &e->attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+    res = do_fstatat(newfd, "", &e->attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW,
+                     dir->key.dev, &e->attr_flags);
     if (res == -1) {
         goto out_err;
     }
 
+    if (!lo->announce_submounts) {
+        e->attr_flags &= ~FUSE_ATTR_SUBMOUNT;
+    }
+
     inode = lo_find(lo, &e->attr);
     if (inode) {
         close(newfd);
@@ -1069,11 +1107,17 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
         goto out_err;
     }
 
-    res = fstatat(inode->fd, "", &e.attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+    res = do_fstatat(inode->fd, "", &e.attr,
+                     AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW,
+                     parent_inode->key.dev, &e.attr_flags);
     if (res == -1) {
         goto out_err;
     }
 
+    if (!lo->announce_submounts) {
+        e.attr_flags &= ~FUSE_ATTR_SUBMOUNT;
+    }
+
     pthread_mutex_lock(&lo->mutex);
     inode->nlookup++;
     pthread_mutex_unlock(&lo->mutex);
@@ -1108,14 +1152,21 @@ static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
 {
     int res;
     struct stat attr;
+    struct lo_data *lo = lo_data(req);
+    struct lo_inode *dir = lo_inode(req, parent);
+
+    if (!dir) {
+        return NULL;
+    }
 
-    res = fstatat(lo_fd(req, parent), name, &attr,
-                  AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+    res = do_fstatat(dir->fd, name, &attr,
+                     AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW, dir->key.dev, NULL);
+    lo_inode_put(lo, &dir);
     if (res == -1) {
         return NULL;
     }
 
-    return lo_find(lo_data(req), &attr);
+    return lo_find(lo, &attr);
 }
 
 static void lo_rmdir(fuse_req_t req, fuse_ino_t parent, const char *name)
-- 
2.28.0

