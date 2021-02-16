From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 16 Feb 2021 18:36:11 -0500
Message-Id: <20210216233611.33400-4-vgoyal@redhat.com>
In-Reply-To: <20210216233611.33400-1-vgoyal@redhat.com>
References: <20210216233611.33400-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/3] virtiofsd: Change umask if posix acls are
	enabled
List-Id: Development discussions about virtio-fs <virtio-fs.listman.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@listman.redhat.com>
List-Help: <mailto:virtio-fs-request@listman.redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: miklos@szeredi.hu, vgoyal@redhat.com

When parent directory has default acl and a file is created in that
directory, then umask is ignored and final file permissions are
determined using default acl instead. (man 2 umask).

Currently, fuse applies the umask and sends modified mode in create
request accordingly. fuse server can set FUSE_DONT_MASK and tell
fuse client to not apply umask and fuse server will take care of
it as needed.

With posix acls enabled, requirement will be that we want umask
to determine final file mode if parent directory does not have
default acl.

So if posix acls are enabled, opt in for FUSE_DONT_MASK. virtiofsd
will set umask of the thread doing file creation. And host kernel
should use that umask if parent directory does not have default
acls, otherwise umask does not take affect.

Miklos mentioned that we already call unshare(CLONE_FS) for
every thread. That means umask has now become property of per
thread and it should be ok to manipulate it in file creation path.

So this patch opts in for FUSE_DONT_MASK if posix acls are enabled
and changes umask to caller umask before file creation and restores
original umask after file creation is done.

This should fix fstest generic/099.

Reported-by: Luis Henriques <lhenriques@suse.de>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 34b2848e61..84691571d2 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -120,6 +120,7 @@ struct lo_inode {
 struct lo_cred {
     uid_t euid;
     gid_t egid;
+    mode_t umask;
 };
 
 enum {
@@ -169,6 +170,8 @@ struct lo_data {
     /* An O_PATH file descriptor to /proc/self/fd/ */
     int proc_self_fd;
     int user_posix_acl;
+    /* If set, virtiofsd is responsible for setting umask during creation */
+    bool change_umask;
 };
 
 static const struct fuse_opt lo_opts[] = {
@@ -641,7 +644,8 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
          * in fuse_lowlevel.c
          */
         fuse_log(FUSE_LOG_DEBUG, "lo_init: enabling posix acl\n");
-        conn->want |= FUSE_CAP_POSIX_ACL;
+        conn->want |= FUSE_CAP_POSIX_ACL | FUSE_CAP_DONT_MASK;
+        lo->change_umask = true;
     } else {
         /*
          * Either user specified to disable posix_acl, or did not specify
@@ -649,6 +653,7 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
          */
         fuse_log(FUSE_LOG_DEBUG, "lo_init: disabling posix_acl\n");
         conn->want &= ~FUSE_CAP_POSIX_ACL;
+        lo->change_umask = false;
     }
 }
 
@@ -1043,7 +1048,8 @@ static void lo_lookup(fuse_req_t req, fuse_ino_t parent, const char *name)
  * ownership of caller.
  * TODO: What about selinux context?
  */
-static int lo_change_cred(fuse_req_t req, struct lo_cred *old)
+static int lo_change_cred(fuse_req_t req, struct lo_cred *old,
+                          bool change_umask)
 {
     int res;
 
@@ -1063,11 +1069,14 @@ static int lo_change_cred(fuse_req_t req, struct lo_cred *old)
         return errno_save;
     }
 
+    if (change_umask)
+        old->umask = umask(req->ctx.umask);
+
     return 0;
 }
 
 /* Regain Privileges */
-static void lo_restore_cred(struct lo_cred *old)
+static void lo_restore_cred(struct lo_cred *old, bool restore_umask)
 {
     int res;
 
@@ -1082,6 +1091,9 @@ static void lo_restore_cred(struct lo_cred *old)
         fuse_log(FUSE_LOG_ERR, "setegid(%u): %m\n", old->egid);
         exit(1);
     }
+
+    if (restore_umask)
+        umask(old->umask);
 }
 
 static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
@@ -1106,7 +1118,7 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
         return;
     }
 
-    saverr = lo_change_cred(req, &old);
+    saverr = lo_change_cred(req, &old, lo->change_umask && !S_ISLNK(mode));
     if (saverr) {
         goto out;
     }
@@ -1115,7 +1127,7 @@ static void lo_mknod_symlink(fuse_req_t req, fuse_ino_t parent,
 
     saverr = errno;
 
-    lo_restore_cred(&old);
+    lo_restore_cred(&old, lo->change_umask && !S_ISLNK(mode));
 
     if (res == -1) {
         goto out;
@@ -1780,7 +1792,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
         return;
     }
 
-    err = lo_change_cred(req, &old);
+    err = lo_change_cred(req, &old, lo->change_umask);
     if (err) {
         goto out;
     }
@@ -1791,7 +1803,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
     fd = openat(parent_inode->fd, name, fi->flags | O_CREAT | O_EXCL, mode);
     err = fd == -1 ? errno : 0;
 
-    lo_restore_cred(&old);
+    lo_restore_cred(&old, lo->change_umask);
 
     /* Ignore the error if file exists and O_EXCL was not given */
     if (err && (err != EEXIST || (fi->flags & O_EXCL))) {
-- 
2.25.4

