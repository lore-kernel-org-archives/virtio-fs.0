From: Max Reitz <mreitz@redhat.com>
Date: Wed,  6 May 2020 17:40:10 +0200
Message-Id: <20200506154010.241055-2-mreitz@redhat.com>
In-Reply-To: <20200506153832.240812-1-mreitz@redhat.com>
References: <20200506153832.240812-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC 2/2] virtiofsd: Set st_rdev for sub-mount points
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Max Reitz <mreitz@redhat.com>

Whenever we encounter a directory with an st_dev that differs from that
of its parent, we set st_rdev accordingly so the guest can create a
submount for it.

Make this behavior optional, so submounts are only announced to the
guest with the announce_submounts option.  Some users may prefer the
current behavior, so that the guest learns nothing about the host mount
structure.

Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 59 +++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 9 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 6cf471d31a..abf9d33493 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -159,6 +159,7 @@ struct lo_data {
     int timeout_set;
     int readdirplus_set;
     int readdirplus_clear;
+    int announce_submounts;
     struct lo_inode root;
     GHashTable *inodes; /* protected by lo->mutex */
     struct lo_map ino_map; /* protected by lo->mutex */
@@ -187,6 +188,7 @@ static const struct fuse_opt lo_opts[] = {
     { "norace", offsetof(struct lo_data, norace), 1 },
     { "readdirplus", offsetof(struct lo_data, readdirplus_set), 1 },
     { "no_readdirplus", offsetof(struct lo_data, readdirplus_clear), 1 },
+    { "announce_submounts", offsetof(struct lo_data, announce_submounts), 1 },
     FUSE_OPT_END
 };
 static bool use_syslog = false;
@@ -582,17 +584,42 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
     }
 }
 
+/**
+ * Call fstatat() and set st_rdev whenever a directory's st_dev
+ * differs from the rparent's st_dev (@parent_dev).  This will
+ * announce submounts to the FUSE client (unless @announce_submounts
+ * is false).
+ */
+static int do_fstatat(int dirfd, const char *pathname, struct stat *statbuf,
+                      int flags, dev_t parent_dev, bool announce_submounts)
+{
+    int res = fstatat(dirfd, pathname, statbuf, flags);
+    if (res == -1) {
+        return res;
+    }
+
+    if (statbuf->st_dev != parent_dev && S_ISDIR(statbuf->st_mode) &&
+        announce_submounts)
+    {
+        statbuf->st_rdev = statbuf->st_dev;
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
 
     (void)fi;
 
-    res =
-        fstatat(lo_fd(req, ino), "", &buf, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+    res = do_fstatat(inode->fd, "", &buf, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW,
+                     inode->parent_dev, lo->announce_submounts);
+    lo_inode_put(lo, &inode);
     if (res == -1) {
         return (void)fuse_reply_err(req, errno);
     }
@@ -645,7 +672,9 @@ retry:
         pthread_mutex_unlock(&lo->mutex);
     } else {
         *last = '\0';
-        res = fstatat(AT_FDCWD, last == path ? "/" : path, &stat, 0);
+        /* Pass parent_dev=0 because st_rdev will be ignored anyway */
+        res = do_fstatat(AT_FDCWD, last == path ? "/" : path, &stat, 0, 0,
+                         lo->announce_submounts);
         if (res == -1) {
             if (!retries) {
                 fuse_log(FUSE_LOG_WARNING,
@@ -663,7 +692,8 @@ retry:
         }
     }
     last++;
-    res = fstatat(p->fd, last, &stat, AT_SYMLINK_NOFOLLOW);
+    res = do_fstatat(p->fd, last, &stat, AT_SYMLINK_NOFOLLOW, p->key.dev,
+                     lo->announce_submounts);
     if (res == -1) {
         if (!retries) {
             fuse_log(FUSE_LOG_WARNING,
@@ -925,7 +955,8 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         goto out_err;
     }
 
-    res = fstatat(newfd, "", &e->attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+    res = do_fstatat(newfd, "", &e->attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW,
+                     dir->key.dev, lo->announce_submounts);
     if (res == -1) {
         goto out_err;
     }
@@ -1207,7 +1238,9 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
         goto out_err;
     }
 
-    res = fstatat(inode->fd, "", &e.attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+    res = do_fstatat(inode->fd, "", &e.attr,
+                     AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW,
+                     parent_inode->key.dev, lo->announce_submounts);
     if (res == -1) {
         goto out_err;
     }
@@ -1246,14 +1279,22 @@ static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
 {
     int res;
     struct stat attr;
+    struct lo_data *lo = lo_data(req);
+    struct lo_inode *dir = lo_inode(req, parent);
 
-    res = fstatat(lo_fd(req, parent), name, &attr,
-                  AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+    if (!dir) {
+        return NULL;
+    }
+
+    res = do_fstatat(dir->fd, name, &attr,
+                     AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW, dir->key.dev,
+                     lo->announce_submounts);
+    lo_inode_put(lo, &dir);
     if (res == -1) {
         return NULL;
     }
 
-    return lo_find(lo_data(req), &attr);
+    return lo_find(lo, &attr);
 }
 
 static void lo_rmdir(fuse_req_t req, fuse_ino_t parent, const char *name)
-- 
2.26.2

