From: Max Reitz <mreitz@redhat.com>
Date: Wed,  9 Jun 2021 17:55:45 +0200
Message-Id: <20210609155551.44437-4-mreitz@redhat.com>
In-Reply-To: <20210609155551.44437-1-mreitz@redhat.com>
References: <20210609155551.44437-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 3/9] virtiofsd: Add lo_inode_fd() helper
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Max Reitz <mreitz@redhat.com>

Once we let lo_inode.fd be optional, we will need its users to open the
file handle stored in lo_inode instead.  This function will do that.

For now, it just returns lo_inode.fd, though.

Signed-off-by: Max Reitz <mreitz@redhat.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 138 ++++++++++++++++++++++++++-----
 1 file changed, 117 insertions(+), 21 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 436f771d2a..46c9dfe200 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -629,6 +629,16 @@ static struct lo_inode *lo_inode(fuse_req_t req, fuse_ino_t ino)
     return elem->inode;
 }
 
+static int lo_inode_fd(const struct lo_inode *inode, TempFd *tfd)
+{
+    *tfd = (TempFd) {
+        .fd = inode->fd,
+        .owned = false,
+    };
+
+    return 0;
+}
+
 /*
  * TODO Remove this helper and force callers to hold an inode refcount until
  * they are done with the fd.  This will be done in a later patch to make
@@ -790,11 +800,11 @@ static int lo_fi_fd(fuse_req_t req, struct fuse_file_info *fi)
 static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
                        int valid, struct fuse_file_info *fi)
 {
+    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
     int saverr;
     char procname[64];
     struct lo_data *lo = lo_data(req);
     struct lo_inode *inode;
-    int ifd;
     int res;
     int fd = -1;
 
@@ -804,7 +814,11 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
         return;
     }
 
-    ifd = inode->fd;
+    res = lo_inode_fd(inode, &inode_fd);
+    if (res < 0) {
+        saverr = -res;
+        goto out_err;
+    }
 
     /* If fi->fh is invalid we'll report EBADF later */
     if (fi) {
@@ -815,7 +829,7 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
         if (fi) {
             res = fchmod(fd, attr->st_mode);
         } else {
-            sprintf(procname, "%i", ifd);
+            sprintf(procname, "%i", inode_fd.fd);
             res = fchmodat(lo->proc_self_fd, procname, attr->st_mode, 0);
         }
         if (res == -1) {
@@ -827,12 +841,13 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
         uid_t uid = (valid & FUSE_SET_ATTR_UID) ? attr->st_uid : (uid_t)-1;
         gid_t gid = (valid & FUSE_SET_ATTR_GID) ? attr->st_gid : (gid_t)-1;
 
-        saverr = drop_security_capability(lo, ifd);
+        saverr = drop_security_capability(lo, inode_fd.fd);
         if (saverr) {
             goto out_err;
         }
 
-        res = fchownat(ifd, "", uid, gid, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+        res = fchownat(inode_fd.fd, "", uid, gid,
+                       AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
         if (res == -1) {
             saverr = errno;
             goto out_err;
@@ -911,7 +926,7 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
         if (fi) {
             res = futimens(fd, tv);
         } else {
-            sprintf(procname, "%i", inode->fd);
+            sprintf(procname, "%i", inode_fd.fd);
             res = utimensat(lo->proc_self_fd, procname, tv, 0);
         }
         if (res == -1) {
@@ -1026,7 +1041,8 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
                         struct fuse_entry_param *e,
                         struct lo_inode **inodep)
 {
-    int newfd;
+    g_auto(TempFd) dir_fd = TEMP_FD_INIT;
+    int newfd = -1;
     int res;
     int saverr;
     uint64_t mnt_id;
@@ -1056,7 +1072,13 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         name = ".";
     }
 
-    newfd = openat(dir->fd, name, O_PATH | O_NOFOLLOW);
+    res = lo_inode_fd(dir, &dir_fd);
+    if (res < 0) {
+        saverr = -res;
+        goto out;
+    }
+
+    newfd = openat(dir_fd.fd, name, O_PATH | O_NOFOLLOW);
     if (newfd == -1) {
         goto out_err;
     }
@@ -1123,6 +1145,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 
 out_err:
     saverr = errno;
+out:
     if (newfd != -1) {
         close(newfd);
     }
@@ -1228,6 +1251,7 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
                              const char *name, mode_t mode, dev_t rdev,
                              const char *link)
 {
+    g_auto(TempFd) dir_fd = TEMP_FD_INIT;
     int res;
     int saverr;
     struct lo_data *lo = lo_data(req);
@@ -1251,12 +1275,18 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
         return;
     }
 
+    res = lo_inode_fd(dir, &dir_fd);
+    if (res < 0) {
+        saverr = -res;
+        goto out;
+    }
+
     saverr = lo_change_cred(req, &old);
     if (saverr) {
         goto out;
     }
 
-    res = mknod_wrapper(dir->fd, name, link, mode, rdev);
+    res = mknod_wrapper(dir_fd.fd, name, link, mode, rdev);
 
     saverr = errno;
 
@@ -1304,6 +1334,8 @@ static void lo_symlink(fuse_req_t req, const char *link, fuse_ino_t parent,
 static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
                     const char *name)
 {
+    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
+    g_auto(TempFd) parent_fd = TEMP_FD_INIT;
     int res;
     struct lo_data *lo = lo_data(req);
     struct lo_inode *parent_inode;
@@ -1329,18 +1361,31 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
         goto out_err;
     }
 
+    res = lo_inode_fd(inode, &inode_fd);
+    if (res < 0) {
+        errno = -res;
+        goto out_err;
+    }
+
+    res = lo_inode_fd(parent_inode, &parent_fd);
+    if (res < 0) {
+        errno = -res;
+        goto out_err;
+    }
+
     memset(&e, 0, sizeof(struct fuse_entry_param));
     e.attr_timeout = lo->timeout;
     e.entry_timeout = lo->timeout;
 
-    sprintf(procname, "%i", inode->fd);
-    res = linkat(lo->proc_self_fd, procname, parent_inode->fd, name,
+    sprintf(procname, "%i", inode_fd.fd);
+    res = linkat(lo->proc_self_fd, procname, parent_fd.fd, name,
                  AT_SYMLINK_FOLLOW);
     if (res == -1) {
         goto out_err;
     }
 
-    res = fstatat(inode->fd, "", &e.attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+    res = fstatat(inode_fd.fd, "", &e.attr,
+                  AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
     if (res == -1) {
         goto out_err;
     }
@@ -1369,6 +1414,7 @@ out_err:
 static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
                                     const char *name)
 {
+    g_auto(TempFd) dir_fd = TEMP_FD_INIT;
     int res;
     uint64_t mnt_id;
     struct stat attr;
@@ -1379,7 +1425,12 @@ static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
         return NULL;
     }
 
-    res = do_statx(lo, dir->fd, name, &attr, AT_SYMLINK_NOFOLLOW, &mnt_id);
+    res = lo_inode_fd(dir, &dir_fd);
+    if (res < 0) {
+        return NULL;
+    }
+
+    res = do_statx(lo, dir_fd.fd, name, &attr, AT_SYMLINK_NOFOLLOW, &mnt_id);
     lo_inode_put(lo, &dir);
     if (res == -1) {
         return NULL;
@@ -1421,6 +1472,8 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
                       fuse_ino_t newparent, const char *newname,
                       unsigned int flags)
 {
+    g_auto(TempFd) parent_fd = TEMP_FD_INIT;
+    g_auto(TempFd) newparent_fd = TEMP_FD_INIT;
     int res;
     struct lo_inode *parent_inode;
     struct lo_inode *newparent_inode;
@@ -1453,12 +1506,24 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
         goto out;
     }
 
+    res = lo_inode_fd(parent_inode, &parent_fd);
+    if (res < 0) {
+        fuse_reply_err(req, -res);
+        goto out;
+    }
+
+    res = lo_inode_fd(newparent_inode, &newparent_fd);
+    if (res < 0) {
+        fuse_reply_err(req, -res);
+        goto out;
+    }
+
     if (flags) {
 #ifndef SYS_renameat2
         fuse_reply_err(req, EINVAL);
 #else
-        res = syscall(SYS_renameat2, parent_inode->fd, name,
-                        newparent_inode->fd, newname, flags);
+        res = syscall(SYS_renameat2, parent_fd.fd, name,
+                        newparent_fd.fd, newname, flags);
         if (res == -1 && errno == ENOSYS) {
             fuse_reply_err(req, EINVAL);
         } else {
@@ -1468,7 +1533,7 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
         goto out;
     }
 
-    res = renameat(parent_inode->fd, name, newparent_inode->fd, newname);
+    res = renameat(parent_fd.fd, name, newparent_fd.fd, newname);
 
     fuse_reply_err(req, res == -1 ? errno : 0);
 out:
@@ -1953,6 +2018,7 @@ static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
 static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
                       mode_t mode, struct fuse_file_info *fi)
 {
+    g_auto(TempFd) parent_fd = TEMP_FD_INIT;
     int fd = -1;
     struct lo_data *lo = lo_data(req);
     struct lo_inode *parent_inode;
@@ -1975,6 +2041,12 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
         return;
     }
 
+    err = lo_inode_fd(parent_inode, &parent_fd);
+    if (err < 0) {
+        err = -err;
+        goto out;
+    }
+
     err = lo_change_cred(req, &old);
     if (err) {
         goto out;
@@ -1983,7 +2055,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
     update_open_flags(lo->writeback, lo->allow_direct_io, fi);
 
     /* Try to create a new file but don't open existing files */
-    fd = openat(parent_inode->fd, name, fi->flags | O_CREAT | O_EXCL, mode);
+    fd = openat(parent_fd.fd, name, fi->flags | O_CREAT | O_EXCL, mode);
     err = fd == -1 ? errno : 0;
 
     lo_restore_cred(&old);
@@ -2788,6 +2860,7 @@ static int xattr_map_server(const struct lo_data *lo, const char *server_name,
 static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
                         size_t size)
 {
+    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
     struct lo_data *lo = lo_data(req);
     g_autofree char *value = NULL;
     char procname[64];
@@ -2850,7 +2923,12 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
         }
         ret = fgetxattr(fd, name, value, size);
     } else {
-        sprintf(procname, "%i", inode->fd);
+        ret = lo_inode_fd(inode, &inode_fd);
+        if (ret < 0) {
+            saverr = -ret;
+            goto out;
+        }
+        sprintf(procname, "%i", inode_fd.fd);
         /* fchdir should not fail here */
         FCHDIR_NOFAIL(lo->proc_self_fd);
         ret = getxattr(procname, name, value, size);
@@ -2887,6 +2965,7 @@ out:
 
 static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
 {
+    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
     struct lo_data *lo = lo_data(req);
     g_autofree char *value = NULL;
     char procname[64];
@@ -2924,7 +3003,12 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
         }
         ret = flistxattr(fd, value, size);
     } else {
-        sprintf(procname, "%i", inode->fd);
+        ret = lo_inode_fd(inode, &inode_fd);
+        if (ret < 0) {
+            saverr = -ret;
+            goto out;
+        }
+        sprintf(procname, "%i", inode_fd.fd);
         /* fchdir should not fail here */
         FCHDIR_NOFAIL(lo->proc_self_fd);
         ret = listxattr(procname, value, size);
@@ -3013,6 +3097,7 @@ out:
 static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
                         const char *value, size_t size, int flags)
 {
+    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
     char procname[64];
     const char *name;
     char *mapped_name;
@@ -3058,7 +3143,12 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
         }
         ret = fsetxattr(fd, name, value, size, flags);
     } else {
-        sprintf(procname, "%i", inode->fd);
+        ret = lo_inode_fd(inode, &inode_fd);
+        if (ret < 0) {
+            saverr = -ret;
+            goto out;
+        }
+        sprintf(procname, "%i", inode_fd.fd);
         /* fchdir should not fail here */
         FCHDIR_NOFAIL(lo->proc_self_fd);
         ret = setxattr(procname, name, value, size, flags);
@@ -3079,6 +3169,7 @@ out:
 
 static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
 {
+    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
     char procname[64];
     const char *name;
     char *mapped_name;
@@ -3124,7 +3215,12 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
         }
         ret = fremovexattr(fd, name);
     } else {
-        sprintf(procname, "%i", inode->fd);
+        ret = lo_inode_fd(inode, &inode_fd);
+        if (ret < 0) {
+            saverr = -ret;
+            goto out;
+        }
+        sprintf(procname, "%i", inode_fd.fd);
         /* fchdir should not fail here */
         FCHDIR_NOFAIL(lo->proc_self_fd);
         ret = removexattr(procname, name);
-- 
2.31.1

