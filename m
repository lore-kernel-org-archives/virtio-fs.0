From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 14 May 2020 16:07:36 +0200
Message-Id: <20200514140736.20561-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd: remove symlink fallbacks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com

Path lookup in the kernel has special rules for looking up magic symlinks
under /proc.  If a filesystem operation is instructed to follow symlinks
(e.g. via AT_SYMLINK_FOLLOW or lack of AT_SYMLINK_NOFOLLOW), and the final
component is such a proc symlink, then the target of the magic symlink is
used for the operation, even if the target itself is a symlink.  I.e. path
lookup is always terminated after following a final magic symlink.

I was erronously assuming that in the above case the target symlink would
also be followed, and so workarounds were added for a couple of operations
to handle the symlink case.  Since the symlink can be handled simply by
following the proc symlink, these workardouds are not needed.

Also remove the "norace" option, which disabled the workarounds.

Commit bdfd66788349 ("virtiofsd: Fix xattr operations") already dealt with
the same issue for xattr operations.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 175 ++-----------------------------
 1 file changed, 6 insertions(+), 169 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 3ba1d9098460..2ce7c96085bf 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -140,7 +140,6 @@ enum {
 struct lo_data {
     pthread_mutex_t mutex;
     int debug;
-    int norace;
     int writeback;
     int flock;
     int posix_lock;
@@ -176,7 +175,6 @@ static const struct fuse_opt lo_opts[] = {
     { "cache=none", offsetof(struct lo_data, cache), CACHE_NONE },
     { "cache=auto", offsetof(struct lo_data, cache), CACHE_AUTO },
     { "cache=always", offsetof(struct lo_data, cache), CACHE_ALWAYS },
-    { "norace", offsetof(struct lo_data, norace), 1 },
     { "readdirplus", offsetof(struct lo_data, readdirplus_set), 1 },
     { "no_readdirplus", offsetof(struct lo_data, readdirplus_clear), 1 },
     FUSE_OPT_END
@@ -592,136 +590,6 @@ static void lo_getattr(fuse_req_t req, fuse_ino_t ino,
     fuse_reply_attr(req, &buf, lo->timeout);
 }
 
-/*
- * Increments parent->nlookup and caller must release refcount using
- * lo_inode_put(&parent).
- */
-static int lo_parent_and_name(struct lo_data *lo, struct lo_inode *inode,
-                              char path[PATH_MAX], struct lo_inode **parent)
-{
-    char procname[64];
-    char *last;
-    struct stat stat;
-    struct lo_inode *p;
-    int retries = 2;
-    int res;
-
-retry:
-    sprintf(procname, "%i", inode->fd);
-
-    res = readlinkat(lo->proc_self_fd, procname, path, PATH_MAX);
-    if (res < 0) {
-        fuse_log(FUSE_LOG_WARNING, "%s: readlink failed: %m\n", __func__);
-        goto fail_noretry;
-    }
-
-    if (res >= PATH_MAX) {
-        fuse_log(FUSE_LOG_WARNING, "%s: readlink overflowed\n", __func__);
-        goto fail_noretry;
-    }
-    path[res] = '\0';
-
-    last = strrchr(path, '/');
-    if (last == NULL) {
-        /* Shouldn't happen */
-        fuse_log(
-            FUSE_LOG_WARNING,
-            "%s: INTERNAL ERROR: bad path read from proc\n", __func__);
-        goto fail_noretry;
-    }
-    if (last == path) {
-        p = &lo->root;
-        pthread_mutex_lock(&lo->mutex);
-        p->nlookup++;
-        g_atomic_int_inc(&p->refcount);
-        pthread_mutex_unlock(&lo->mutex);
-    } else {
-        *last = '\0';
-        res = fstatat(AT_FDCWD, last == path ? "/" : path, &stat, 0);
-        if (res == -1) {
-            if (!retries) {
-                fuse_log(FUSE_LOG_WARNING,
-                         "%s: failed to stat parent: %m\n", __func__);
-            }
-            goto fail;
-        }
-        p = lo_find(lo, &stat);
-        if (p == NULL) {
-            if (!retries) {
-                fuse_log(FUSE_LOG_WARNING,
-                         "%s: failed to find parent\n", __func__);
-            }
-            goto fail;
-        }
-    }
-    last++;
-    res = fstatat(p->fd, last, &stat, AT_SYMLINK_NOFOLLOW);
-    if (res == -1) {
-        if (!retries) {
-            fuse_log(FUSE_LOG_WARNING,
-                     "%s: failed to stat last\n", __func__);
-        }
-        goto fail_unref;
-    }
-    if (stat.st_dev != inode->key.dev || stat.st_ino != inode->key.ino) {
-        if (!retries) {
-            fuse_log(FUSE_LOG_WARNING,
-                     "%s: failed to match last\n", __func__);
-        }
-        goto fail_unref;
-    }
-    *parent = p;
-    memmove(path, last, strlen(last) + 1);
-
-    return 0;
-
-fail_unref:
-    unref_inode_lolocked(lo, p, 1);
-    lo_inode_put(lo, &p);
-fail:
-    if (retries) {
-        retries--;
-        goto retry;
-    }
-fail_noretry:
-    errno = EIO;
-    return -1;
-}
-
-static int utimensat_empty(struct lo_data *lo, struct lo_inode *inode,
-                           const struct timespec *tv)
-{
-    int res;
-    struct lo_inode *parent;
-    char path[PATH_MAX];
-
-    if (S_ISLNK(inode->filetype)) {
-        res = utimensat(inode->fd, "", tv, AT_EMPTY_PATH);
-        if (res == -1 && errno == EINVAL) {
-            /* Sorry, no race free way to set times on symlink. */
-            if (lo->norace) {
-                errno = EPERM;
-            } else {
-                goto fallback;
-            }
-        }
-        return res;
-    }
-    sprintf(path, "%i", inode->fd);
-
-    return utimensat(lo->proc_self_fd, path, tv, 0);
-
-fallback:
-    res = lo_parent_and_name(lo, inode, path, &parent);
-    if (res != -1) {
-        res = utimensat(parent->fd, path, tv, AT_SYMLINK_NOFOLLOW);
-        unref_inode_lolocked(lo, parent, 1);
-        lo_inode_put(lo, &parent);
-    }
-
-    return res;
-}
-
 static int lo_fi_fd(fuse_req_t req, struct fuse_file_info *fi)
 {
     struct lo_data *lo = lo_data(req);
@@ -828,7 +696,8 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
         if (fi) {
             res = futimens(fd, tv);
         } else {
-            res = utimensat_empty(lo, inode, tv);
+            sprintf(procname, "%i", inode->fd);
+            res = utimensat(lo->proc_self_fd, procname, tv, 0);
         }
         if (res == -1) {
             goto out_err;
@@ -1129,41 +998,6 @@ static void lo_symlink(fuse_req_t req, const char *link, fuse_ino_t parent,
     lo_mknod_symlink(req, parent, name, S_IFLNK, 0, link);
 }
 
-static int linkat_empty_nofollow(struct lo_data *lo, struct lo_inode *inode,
-                                 int dfd, const char *name)
-{
-    int res;
-    struct lo_inode *parent;
-    char path[PATH_MAX];
-
-    if (S_ISLNK(inode->filetype)) {
-        res = linkat(inode->fd, "", dfd, name, AT_EMPTY_PATH);
-        if (res == -1 && (errno == ENOENT || errno == EINVAL)) {
-            /* Sorry, no race free way to hard-link a symlink. */
-            if (lo->norace) {
-                errno = EPERM;
-            } else {
-                goto fallback;
-            }
-        }
-        return res;
-    }
-
-    sprintf(path, "%i", inode->fd);
-
-    return linkat(lo->proc_self_fd, path, dfd, name, AT_SYMLINK_FOLLOW);
-
-fallback:
-    res = lo_parent_and_name(lo, inode, path, &parent);
-    if (res != -1) {
-        res = linkat(parent->fd, path, dfd, name, 0);
-        unref_inode_lolocked(lo, parent, 1);
-        lo_inode_put(lo, &parent);
-    }
-
-    return res;
-}
-
 static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
                     const char *name)
 {
@@ -1172,6 +1006,7 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
     struct lo_inode *parent_inode;
     struct lo_inode *inode;
     struct fuse_entry_param e;
+    char procname[64];
     int saverr;
 
     if (!is_safe_path_component(name)) {
@@ -1190,7 +1025,9 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
     e.attr_timeout = lo->timeout;
     e.entry_timeout = lo->timeout;
 
-    res = linkat_empty_nofollow(lo, inode, parent_inode->fd, name);
+    sprintf(procname, "%i", inode->fd);
+    res = linkat(lo->proc_self_fd, procname, parent_inode->fd, name,
+                 AT_SYMLINK_FOLLOW);
     if (res == -1) {
         goto out_err;
     }
-- 
2.21.1

