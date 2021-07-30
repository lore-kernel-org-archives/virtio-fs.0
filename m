From: Max Reitz <mreitz@redhat.com>
Date: Fri, 30 Jul 2021 17:01:28 +0200
Message-Id: <20210730150134.216126-5-mreitz@redhat.com>
In-Reply-To: <20210730150134.216126-1-mreitz@redhat.com>
References: <20210730150134.216126-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 04/10] virtiofsd: Add lo_inode_fd() helper
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Max Reitz <mreitz@redhat.com>

Once we let lo_inode.fd be optional, we will need its users to open the
file handle stored in lo_inode instead.  This function will do that.

For now, it just returns lo_inode.fd, though.

Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 150 +++++++++++++++++++++++++------
 1 file changed, 125 insertions(+), 25 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index a444c3a7e2..86b901cf19 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -635,6 +635,16 @@ static struct lo_inode *lo_inode(fuse_req_t req, fuse_ino_t ino)
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
@@ -822,11 +832,11 @@ static int lo_fi_fd(fuse_req_t req, struct fuse_file_info *fi)
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
 
@@ -836,7 +846,11 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
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
@@ -847,7 +861,7 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
         if (fi) {
             res = fchmod(fd, attr->st_mode);
         } else {
-            sprintf(procname, "%i", ifd);
+            sprintf(procname, "%i", inode_fd.fd);
             res = fchmodat(lo->proc_self_fd, procname, attr->st_mode, 0);
         }
         if (res == -1) {
@@ -859,12 +873,13 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
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
@@ -943,7 +958,7 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
         if (fi) {
             res = futimens(fd, tv);
         } else {
-            sprintf(procname, "%i", inode->fd);
+            sprintf(procname, "%i", inode_fd.fd);
             res = utimensat(lo->proc_self_fd, procname, tv, 0);
         }
         if (res == -1) {
@@ -1058,7 +1073,8 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
                         struct fuse_entry_param *e,
                         struct lo_inode **inodep)
 {
-    int newfd;
+    g_auto(TempFd) dir_fd = TEMP_FD_INIT;
+    int newfd = -1;
     int res;
     int saverr;
     uint64_t mnt_id;
@@ -1088,7 +1104,13 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
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
@@ -1155,6 +1177,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 
 out_err:
     saverr = errno;
+out:
     if (newfd != -1) {
         close(newfd);
     }
@@ -1312,6 +1335,7 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
                              const char *name, mode_t mode, dev_t rdev,
                              const char *link)
 {
+    g_auto(TempFd) dir_fd = TEMP_FD_INIT;
     int res;
     int saverr;
     struct lo_data *lo = lo_data(req);
@@ -1335,12 +1359,18 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
         return;
     }
 
+    res = lo_inode_fd(dir, &dir_fd);
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
+    res = mknod_wrapper(dir_fd.fd, name, link, mode, rdev);
 
     saverr = errno;
 
@@ -1388,6 +1418,8 @@ static void lo_symlink(fuse_req_t req, const char *link, fuse_ino_t parent,
 static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
                     const char *name)
 {
+    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
+    g_auto(TempFd) parent_fd = TEMP_FD_INIT;
     int res;
     struct lo_data *lo = lo_data(req);
     struct lo_inode *parent_inode;
@@ -1413,18 +1445,31 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
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
@@ -1453,23 +1498,33 @@ out_err:
 static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
                                     const char *name)
 {
+    g_auto(TempFd) dir_fd = TEMP_FD_INIT;
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
+    res = lo_inode_fd(dir, &dir_fd);
+    if (res < 0) {
+        goto out;
+    }
+
+    res = do_statx(lo, dir_fd.fd, name, &attr, AT_SYMLINK_NOFOLLOW, &mnt_id);
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
@@ -1505,6 +1560,8 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
                       fuse_ino_t newparent, const char *newname,
                       unsigned int flags)
 {
+    g_auto(TempFd) parent_fd = TEMP_FD_INIT;
+    g_auto(TempFd) newparent_fd = TEMP_FD_INIT;
     int res;
     struct lo_inode *parent_inode;
     struct lo_inode *newparent_inode;
@@ -1537,12 +1594,24 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
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
@@ -1552,7 +1621,7 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
         goto out;
     }
 
-    res = renameat(parent_inode->fd, name, newparent_inode->fd, newname);
+    res = renameat(parent_fd.fd, name, newparent_fd.fd, newname);
 
     fuse_reply_err(req, res == -1 ? errno : 0);
 out:
@@ -2037,6 +2106,7 @@ static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
 static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
                       mode_t mode, struct fuse_file_info *fi)
 {
+    g_auto(TempFd) parent_fd = TEMP_FD_INIT;
     int fd = -1;
     struct lo_data *lo = lo_data(req);
     struct lo_inode *parent_inode;
@@ -2059,6 +2129,12 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
         return;
     }
 
+    err = lo_inode_fd(parent_inode, &parent_fd);
+    if (err < 0) {
+        err = -err;
+        goto out;
+    }
+
     err = lo_change_cred(req, &old, lo->change_umask);
     if (err) {
         goto out;
@@ -2067,7 +2143,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
     update_open_flags(lo->writeback, lo->allow_direct_io, fi);
 
     /* Try to create a new file but don't open existing files */
-    fd = openat(parent_inode->fd, name, fi->flags | O_CREAT | O_EXCL, mode);
+    fd = openat(parent_fd.fd, name, fi->flags | O_CREAT | O_EXCL, mode);
     err = fd == -1 ? errno : 0;
 
     lo_restore_cred(&old, lo->change_umask);
@@ -2929,6 +3005,7 @@ static int remove_blocked_xattrs(struct lo_data *lo, char *xattr_list,
 static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
                         size_t size)
 {
+    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
     struct lo_data *lo = lo_data(req);
     g_autofree char *value = NULL;
     char procname[64];
@@ -2997,7 +3074,12 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
         ret = fgetxattr(fd, name, value, size);
         saverr = ret == -1 ? errno : 0;
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
@@ -3035,6 +3117,7 @@ out:
 
 static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
 {
+    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
     struct lo_data *lo = lo_data(req);
     g_autofree char *value = NULL;
     char procname[64];
@@ -3073,7 +3156,12 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
         ret = flistxattr(fd, value, size);
         saverr = ret == -1 ? errno : 0;
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
@@ -3170,6 +3258,7 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
                         const char *value, size_t size, int flags,
                         uint32_t extra_flags)
 {
+    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
     char procname[64];
     const char *name;
     char *mapped_name;
@@ -3229,7 +3318,12 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
             goto out;
         }
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
     }
@@ -3286,6 +3380,7 @@ out:
 
 static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
 {
+    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
     char procname[64];
     const char *name;
     char *mapped_name;
@@ -3337,7 +3432,12 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
         ret = fremovexattr(fd, name);
         saverr = ret == -1 ? errno : 0;
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

