From: Hanna Reitz <hreitz@redhat.com>
Date: Thu, 16 Sep 2021 10:40:35 +0200
Message-Id: <20210916084045.31684-3-hreitz@redhat.com>
In-Reply-To: <20210916084045.31684-1-hreitz@redhat.com>
References: <20210916084045.31684-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 02/12] virtiofsd: Limit setxattr()'s
	creds-dropped region
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

We only need to drop/switch our credentials for the (f)setxattr() call
alone, not for the openat() or fchdir() around it.

(Right now, this may not be that big of a problem, but with inodes being
identified by file handles instead of an O_PATH fd, we will need
open_by_handle_at() calls here, which is really fickle when it comes to
credentials being dropped.)

Signed-off-by: Hanna Reitz <hreitz@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 34 +++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 6511a6acb4..b43afdfbd3 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3123,6 +3123,7 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
     bool switched_creds = false;
     bool cap_fsetid_dropped = false;
     struct lo_cred old = {};
+    bool changed_cwd = false;
 
     if (block_xattr(lo, in_name)) {
         fuse_reply_err(req, EOPNOTSUPP);
@@ -3158,6 +3159,24 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
              ", name=%s value=%s size=%zd)\n", ino, name, value, size);
 
     sprintf(procname, "%i", inode->fd);
+    /*
+     * We can only open regular files or directories.  If the inode is
+     * something else, we have to enter /proc/self/fd and use
+     * setxattr() on the link's filename there.
+     */
+    if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
+        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
+        if (fd < 0) {
+            saverr = errno;
+            goto out;
+        }
+    } else {
+        /* fchdir should not fail here */
+        FCHDIR_NOFAIL(lo->proc_self_fd);
+        /* Set flag so the clean-up path will chdir back */
+        changed_cwd = true;
+    }
+
     /*
      * If we are setting posix access acl and if SGID needs to be
      * cleared, then switch to caller's gid and drop CAP_FSETID
@@ -3178,20 +3197,12 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
         }
         switched_creds = true;
     }
-    if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
-        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
-        if (fd < 0) {
-            saverr = errno;
-            goto out;
-        }
+    if (fd >= 0) {
         ret = fsetxattr(fd, name, value, size, flags);
         saverr = ret == -1 ? errno : 0;
     } else {
-        /* fchdir should not fail here */
-        FCHDIR_NOFAIL(lo->proc_self_fd);
         ret = setxattr(procname, name, value, size, flags);
         saverr = ret == -1 ? errno : 0;
-        FCHDIR_NOFAIL(lo->root.fd);
     }
     if (switched_creds) {
         if (cap_fsetid_dropped)
@@ -3201,6 +3212,11 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
     }
 
 out:
+    if (changed_cwd) {
+        /* Change CWD back, fchdir should not fail here */
+        FCHDIR_NOFAIL(lo->root.fd);
+    }
+
     if (fd >= 0) {
         close(fd);
     }
-- 
2.31.1

