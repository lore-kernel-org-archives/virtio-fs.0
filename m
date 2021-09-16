From: Hanna Reitz <hreitz@redhat.com>
Date: Thu, 16 Sep 2021 10:40:38 +0200
Message-Id: <20210916084045.31684-6-hreitz@redhat.com>
In-Reply-To: <20210916084045.31684-1-hreitz@redhat.com>
References: <20210916084045.31684-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 05/12] virtiofsd: Add lo_inode_fd() helper
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

Once we let lo_inode.fd be optional, we will need its users to open the
file handle stored in lo_inode instead.  This function will do that.

For now, it just returns lo_inode.fd, though.

Signed-off-by: Hanna Reitz <hreitz@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 159 +++++++++++++++++++++++++------
 1 file changed, 132 insertions(+), 27 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index d76283d080..c5baa752e4 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -651,6 +651,16 @@ static struct lo_inode *lo_inode(fuse_req_t req, fuse_ino_t ino)
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
@@ -838,11 +848,11 @@ static int lo_fi_fd(fuse_req_t req, struct fuse_file_info *fi)
 static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
                        int valid, struct fuse_file_info *fi)
 {
+    g_auto(TempFd) path_fd = TEMP_FD_INIT;
     int saverr;
     char procname[64];
     struct lo_data *lo = lo_data(req);
     struct lo_inode *inode;
-    int ifd;
     int res;
     int fd = -1;
 
@@ -852,7 +862,11 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
         return;
     }
 
-    ifd = inode->fd;
+    res = lo_inode_fd(inode, &path_fd);
+    if (res < 0) {
+        saverr = -res;
+        goto out_err;
+    }
 
     /* If fi->fh is invalid we'll report EBADF later */
     if (fi) {
@@ -863,7 +877,7 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
         if (fi) {
             res = fchmod(fd, attr->st_mode);
         } else {
-            sprintf(procname, "%i", ifd);
+            sprintf(procname, "%i", path_fd.fd);
             res = fchmodat(lo->proc_self_fd, procname, attr->st_mode, 0);
         }
         if (res == -1) {
@@ -875,12 +889,13 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
         uid_t uid = (valid & FUSE_SET_ATTR_UID) ? attr->st_uid : (uid_t)-1;
         gid_t gid = (valid & FUSE_SET_ATTR_GID) ? attr->st_gid : (gid_t)-1;
 
-        saverr = drop_security_capability(lo, ifd);
+        saverr = drop_security_capability(lo, path_fd.fd);
         if (saverr) {
             goto out_err;
         }
 
-        res = fchownat(ifd, "", uid, gid, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+        res = fchownat(path_fd.fd, "", uid, gid,
+                       AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
         if (res == -1) {
             saverr = errno;
             goto out_err;
@@ -959,7 +974,7 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
         if (fi) {
             res = futimens(fd, tv);
         } else {
-            sprintf(procname, "%i", inode->fd);
+            sprintf(procname, "%i", path_fd.fd);
             res = utimensat(lo->proc_self_fd, procname, tv, 0);
         }
         if (res == -1) {
@@ -1074,7 +1089,8 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
                         struct fuse_entry_param *e,
                         struct lo_inode **inodep)
 {
-    int newfd;
+    g_auto(TempFd) dir_path_fd = TEMP_FD_INIT;
+    int newfd = -1;
     int res;
     int saverr;
     uint64_t mnt_id;
@@ -1104,7 +1120,13 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         name = ".";
     }
 
-    newfd = openat(dir->fd, name, O_PATH | O_NOFOLLOW);
+    res = lo_inode_fd(dir, &dir_path_fd);
+    if (res < 0) {
+        saverr = -res;
+        goto out;
+    }
+
+    newfd = openat(dir_path_fd.fd, name, O_PATH | O_NOFOLLOW);
     if (newfd == -1) {
         goto out_err;
     }
@@ -1171,6 +1193,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 
 out_err:
     saverr = errno;
+out:
     if (newfd != -1) {
         close(newfd);
     }
@@ -1328,6 +1351,7 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
                              const char *name, mode_t mode, dev_t rdev,
                              const char *link)
 {
+    g_auto(TempFd) dir_path_fd = TEMP_FD_INIT;
     int res;
     int saverr;
     struct lo_data *lo = lo_data(req);
@@ -1351,12 +1375,18 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
         return;
     }
 
+    res = lo_inode_fd(dir, &dir_path_fd);
+    if (res < 0) {
+        saverr = -res;
+        goto out;
+    }
+
     saverr = lo_change_cred(req, &old, lo->change_umask && !S_ISLNK(mode));
     if (saverr) {
         goto out;
     }
 
-    res = mknod_wrapper(dir->fd, name, link, mode, rdev);
+    res = mknod_wrapper(dir_path_fd.fd, name, link, mode, rdev);
 
     saverr = errno;
 
@@ -1404,6 +1434,8 @@ static void lo_symlink(fuse_req_t req, const char *link, fuse_ino_t parent,
 static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
                     const char *name)
 {
+    g_auto(TempFd) path_fd = TEMP_FD_INIT;
+    g_auto(TempFd) parent_path_fd = TEMP_FD_INIT;
     int res;
     struct lo_data *lo = lo_data(req);
     struct lo_inode *parent_inode;
@@ -1425,22 +1457,35 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
     parent_inode = lo_inode(req, parent);
     inode = lo_inode(req, ino);
     if (!parent_inode || !inode) {
-        errno = EBADF;
-        goto out_err;
+        saverr = EBADF;
+        goto out;
+    }
+
+    res = lo_inode_fd(inode, &path_fd);
+    if (res < 0) {
+        saverr = -res;
+        goto out;
+    }
+
+    res = lo_inode_fd(parent_inode, &parent_path_fd);
+    if (res < 0) {
+        saverr = -res;
+        goto out;
     }
 
     memset(&e, 0, sizeof(struct fuse_entry_param));
     e.attr_timeout = lo->timeout;
     e.entry_timeout = lo->timeout;
 
-    sprintf(procname, "%i", inode->fd);
-    res = linkat(lo->proc_self_fd, procname, parent_inode->fd, name,
+    sprintf(procname, "%i", path_fd.fd);
+    res = linkat(lo->proc_self_fd, procname, parent_path_fd.fd, name,
                  AT_SYMLINK_FOLLOW);
     if (res == -1) {
         goto out_err;
     }
 
-    res = fstatat(inode->fd, "", &e.attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
+    res = fstatat(path_fd.fd, "", &e.attr,
+                  AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
     if (res == -1) {
         goto out_err;
     }
@@ -1460,6 +1505,7 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
 
 out_err:
     saverr = errno;
+out:
     lo_inode_put(lo, &parent_inode);
     lo_inode_put(lo, &inode);
     fuse_reply_err(req, saverr);
@@ -1469,23 +1515,34 @@ out_err:
 static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
                                     const char *name)
 {
+    g_auto(TempFd) dir_path_fd = TEMP_FD_INIT;
     int res;
     uint64_t mnt_id;
     struct stat attr;
     struct lo_data *lo = lo_data(req);
     struct lo_inode *dir = lo_inode(req, parent);
+    struct lo_inode *inode = NULL;
 
     if (!dir) {
-        return NULL;
+        goto out;
     }
 
-    res = do_statx(lo, dir->fd, name, &attr, AT_SYMLINK_NOFOLLOW, &mnt_id);
-    lo_inode_put(lo, &dir);
+    res = lo_inode_fd(dir, &dir_path_fd);
+    if (res < 0) {
+        goto out;
+    }
+
+    res = do_statx(lo, dir_path_fd.fd, name, &attr, AT_SYMLINK_NOFOLLOW,
+                   &mnt_id);
     if (res == -1) {
-        return NULL;
+        goto out;
     }
 
-    return lo_find(lo, &attr, mnt_id);
+    inode = lo_find(lo, &attr, mnt_id);
+
+out:
+    lo_inode_put(lo, &dir);
+    return inode;
 }
 
 static void lo_rmdir(fuse_req_t req, fuse_ino_t parent, const char *name)
@@ -1521,6 +1578,8 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
                       fuse_ino_t newparent, const char *newname,
                       unsigned int flags)
 {
+    g_auto(TempFd) parent_path_fd = TEMP_FD_INIT;
+    g_auto(TempFd) newparent_path_fd = TEMP_FD_INIT;
     int res;
     struct lo_inode *parent_inode;
     struct lo_inode *newparent_inode;
@@ -1553,12 +1612,24 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
         goto out;
     }
 
+    res = lo_inode_fd(parent_inode, &parent_path_fd);
+    if (res < 0) {
+        fuse_reply_err(req, -res);
+        goto out;
+    }
+
+    res = lo_inode_fd(newparent_inode, &newparent_path_fd);
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
+        res = syscall(SYS_renameat2, parent_path_fd.fd, name,
+                        newparent_path_fd.fd, newname, flags);
         if (res == -1 && errno == ENOSYS) {
             fuse_reply_err(req, EINVAL);
         } else {
@@ -1568,7 +1639,7 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
         goto out;
     }
 
-    res = renameat(parent_inode->fd, name, newparent_inode->fd, newname);
+    res = renameat(parent_path_fd.fd, name, newparent_path_fd.fd, newname);
 
     fuse_reply_err(req, res == -1 ? errno : 0);
 out:
@@ -2054,6 +2125,7 @@ static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
 static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
                       mode_t mode, struct fuse_file_info *fi)
 {
+    g_auto(TempFd) parent_path_fd = TEMP_FD_INIT;
     int fd = -1;
     struct lo_data *lo = lo_data(req);
     struct lo_inode *parent_inode;
@@ -2076,6 +2148,12 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
         return;
     }
 
+    err = lo_inode_fd(parent_inode, &parent_path_fd);
+    if (err < 0) {
+        err = -err;
+        goto out;
+    }
+
     err = lo_change_cred(req, &old, lo->change_umask);
     if (err) {
         goto out;
@@ -2084,7 +2162,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
     update_open_flags(lo->writeback, lo->allow_direct_io, fi);
 
     /* Try to create a new file but don't open existing files */
-    fd = openat(parent_inode->fd, name, fi->flags | O_CREAT | O_EXCL, mode);
+    fd = openat(parent_path_fd.fd, name, fi->flags | O_CREAT | O_EXCL, mode);
     err = fd == -1 ? errno : 0;
 
     lo_restore_cred(&old, lo->change_umask);
@@ -3014,7 +3092,14 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
         ret = fgetxattr(fd, name, value, size);
         saverr = ret == -1 ? errno : 0;
     } else {
-        sprintf(procname, "%i", inode->fd);
+        g_auto(TempFd) path_fd = TEMP_FD_INIT;
+
+        ret = lo_inode_fd(inode, &path_fd);
+        if (ret < 0) {
+            saverr = -ret;
+            goto out;
+        }
+        sprintf(procname, "%i", path_fd.fd);
         /* fchdir should not fail here */
         FCHDIR_NOFAIL(lo->proc_self_fd);
         ret = getxattr(procname, name, value, size);
@@ -3090,7 +3175,14 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
         ret = flistxattr(fd, value, size);
         saverr = ret == -1 ? errno : 0;
     } else {
-        sprintf(procname, "%i", inode->fd);
+        g_auto(TempFd) path_fd = TEMP_FD_INIT;
+
+        ret = lo_inode_fd(inode, &path_fd);
+        if (ret < 0) {
+            saverr = -ret;
+            goto out;
+        }
+        sprintf(procname, "%i", path_fd.fd);
         /* fchdir should not fail here */
         FCHDIR_NOFAIL(lo->proc_self_fd);
         ret = listxattr(procname, value, size);
@@ -3187,6 +3279,7 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
                         const char *value, size_t size, int flags,
                         uint32_t extra_flags)
 {
+    g_auto(TempFd) path_fd = TEMP_FD_INIT;
     const char *name;
     char *mapped_name;
     struct lo_data *lo = lo_data(req);
@@ -3244,6 +3337,11 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
             goto out;
         }
     } else {
+        ret = lo_inode_fd(inode, &path_fd);
+        if (ret < 0) {
+            saverr = -ret;
+            goto out;
+        }
         /* fchdir should not fail here */
         FCHDIR_NOFAIL(lo->proc_self_fd);
         /* Set flag so the clean-up path will chdir back */
@@ -3276,7 +3374,7 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
     } else {
         char procname[64];
 
-        sprintf(procname, "%i", inode->fd);
+        sprintf(procname, "%i", path_fd.fd);
         ret = setxattr(procname, name, value, size, flags);
         saverr = ret == -1 ? errno : 0;
     }
@@ -3355,7 +3453,14 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
         ret = fremovexattr(fd, name);
         saverr = ret == -1 ? errno : 0;
     } else {
-        sprintf(procname, "%i", inode->fd);
+        g_auto(TempFd) path_fd = TEMP_FD_INIT;
+
+        ret = lo_inode_fd(inode, &path_fd);
+        if (ret < 0) {
+            saverr = -ret;
+            goto out;
+        }
+        sprintf(procname, "%i", path_fd.fd);
         /* fchdir should not fail here */
         FCHDIR_NOFAIL(lo->proc_self_fd);
         ret = removexattr(procname, name);
-- 
2.31.1

