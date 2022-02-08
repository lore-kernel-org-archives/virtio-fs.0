From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue,  8 Feb 2022 15:48:12 -0500
Message-Id: <20220208204813.682906-10-vgoyal@redhat.com>
In-Reply-To: <20220208204813.682906-1-vgoyal@redhat.com>
References: <20220208204813.682906-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v6 09/10] virtiofsd: Create new file using
	O_TMPFILE and set security context
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: berrange@redhat.com, vgoyal@redhat.com

If guest and host policies can't work with each other, then guest security
context (selinux label) needs to be set into an xattr. Say remap guest
security.selinux xattr to trusted.virtiofs.security.selinux.

That means setting "fscreate" is not going to help as that's ony useful
for security.selinux xattr on host.

So we need another method which is atomic. Use O_TMPFILE to create new
file, set xattr and then linkat() to proper place.

But this works only for regular files. So dir, symlinks will continue
to be non-atomic.

Also if host filesystem does not support O_TMPFILE, we fallback to
non-atomic behavior.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 80 ++++++++++++++++++++++++++++----
 1 file changed, 72 insertions(+), 8 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 68fa542fac..d49128a58d 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2153,14 +2153,29 @@ static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
 
 static int do_create_nosecctx(fuse_req_t req, struct lo_inode *parent_inode,
                                const char *name, mode_t mode,
-                               struct fuse_file_info *fi, int *open_fd)
+                               struct fuse_file_info *fi, int *open_fd,
+                              bool tmpfile)
 {
     int err, fd;
     struct lo_cred old = {};
     struct lo_data *lo = lo_data(req);
     int flags;
 
-    flags = fi->flags | O_CREAT | O_EXCL;
+    if (tmpfile) {
+        flags = fi->flags | O_TMPFILE;
+        /*
+         * Don't use O_EXCL as we want to link file later. Also reset O_CREAT
+         * otherwise openat() returns -EINVAL.
+         */
+        flags &= ~(O_CREAT | O_EXCL);
+
+        /* O_TMPFILE needs either O_RDWR or O_WRONLY */
+        if ((flags & O_ACCMODE) == O_RDONLY) {
+            flags |= O_RDWR;
+        }
+    } else {
+        flags = fi->flags | O_CREAT | O_EXCL;
+    }
 
     err = lo_change_cred(req, &old, lo->change_umask);
     if (err) {
@@ -2191,7 +2206,7 @@ static int do_create_secctx_fscreate(fuse_req_t req,
         return err;
     }
 
-    err = do_create_nosecctx(req, parent_inode, name, mode, fi, &fd);
+    err = do_create_nosecctx(req, parent_inode, name, mode, fi, &fd, false);
 
     close_reset_proc_fscreate(fscreate_fd);
     if (!err) {
@@ -2200,6 +2215,44 @@ static int do_create_secctx_fscreate(fuse_req_t req,
     return err;
 }
 
+static int do_create_secctx_tmpfile(fuse_req_t req,
+                                    struct lo_inode *parent_inode,
+                                    const char *name, mode_t mode,
+                                    struct fuse_file_info *fi,
+                                    const char *secctx_name, int *open_fd)
+{
+    int err, fd = -1;
+    struct lo_data *lo = lo_data(req);
+    char procname[64];
+
+    err = do_create_nosecctx(req, parent_inode, ".", mode, fi, &fd, true);
+    if (err) {
+        return err;
+    }
+
+    err = fsetxattr(fd, secctx_name, req->secctx.ctx, req->secctx.ctxlen, 0);
+    if (err) {
+        err = errno;
+        goto out;
+    }
+
+    /* Security context set on file. Link it in place */
+    sprintf(procname, "%d", fd);
+    FCHDIR_NOFAIL(lo->proc_self_fd);
+    err = linkat(AT_FDCWD, procname, parent_inode->fd, name,
+                 AT_SYMLINK_FOLLOW);
+    err = err == -1 ? errno : 0;
+    FCHDIR_NOFAIL(lo->root.fd);
+
+out:
+    if (!err) {
+        *open_fd = fd;
+    } else if (fd != -1) {
+        close(fd);
+    }
+    return err;
+}
+
 static int do_create_secctx_noatomic(fuse_req_t req,
                                      struct lo_inode *parent_inode,
                                      const char *name, mode_t mode,
@@ -2208,7 +2261,7 @@ static int do_create_secctx_noatomic(fuse_req_t req,
 {
     int err = 0, fd = -1;
 
-    err = do_create_nosecctx(req, parent_inode, name, mode, fi, &fd);
+    err = do_create_nosecctx(req, parent_inode, name, mode, fi, &fd, false);
     if (err) {
         goto out;
     }
@@ -2250,20 +2303,31 @@ static int do_lo_create(fuse_req_t req, struct lo_inode *parent_inode,
     if (secctx_enabled) {
         /*
          * If security.selinux has not been remapped and selinux is enabled,
-         * use fscreate to set context before file creation.
-         * Otherwise fallback to non-atomic method of file creation
-         * and xattr settting.
+         * use fscreate to set context before file creation. If not, use
+         * tmpfile method for regular files. Otherwise fallback to
+         * non-atomic method of file creation and xattr settting.
          */
         if (!mapped_name && lo->use_fscreate) {
             err = do_create_secctx_fscreate(req, parent_inode, name, mode, fi,
                                             open_fd);
             goto out;
+        } else if (S_ISREG(mode)) {
+            err = do_create_secctx_tmpfile(req, parent_inode, name, mode, fi,
+                                           ctxname, open_fd);
+            /*
+             * If filesystem does not support O_TMPFILE, fallback to non-atomic
+             * method.
+             */
+            if (!err || err != EOPNOTSUPP) {
+                goto out;
+            }
         }
 
         err = do_create_secctx_noatomic(req, parent_inode, name, mode, fi,
                                         ctxname, open_fd);
     } else {
-        err = do_create_nosecctx(req, parent_inode, name, mode, fi, open_fd);
+        err = do_create_nosecctx(req, parent_inode, name, mode, fi, open_fd,
+                                 false);
     }
 
 out:
-- 
2.34.1

