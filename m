From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 25 Mar 2021 11:38:52 -0400
Message-Id: <20210325153852.572927-6-vgoyal@redhat.com>
In-Reply-To: <20210325153852.572927-1-vgoyal@redhat.com>
References: <20210325153852.572927-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v5 5/5] virtiofsd: Switch creds,
	drop FSETID for system.posix_acl_access xattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com, miklos@szeredi.hu

When posix access acls are set on a file, it can lead to adjusting file
permissions (mode) as well. If caller does not have CAP_FSETID and it
also does not have membership of owner group, this will lead to clearing
SGID bit in mode.

Current fuse code is written in such a way that it expects file server
to take care of chaning file mode (permission), if there is a need.
Right now, host kernel does not clear SGID bit because virtiofsd is
running as root and has CAP_FSETID. For host kernel to clear SGID,
virtiofsd need to switch to gid of caller in guest and also drop
CAP_FSETID (if caller did not have it to begin with).

If SGID needs to be cleared, client will set the flag
FUSE_SETXATTR_ACL_KILL_SGID in setxattr request. In that case server
should kill sgid.

Currently just switch to uid/gid of the caller and drop CAP_FSETID
and that should do it.

This should fix the xfstest generic/375 test case.

We don't have to switch uid for this to work. That could be one optimization
that pass a parameter to lo_change_cred() to only switch gid and not uid.

Also this will not work whenever (if ever) we support idmapped mounts. In
that case it is possible that uid/gid in request are 0/0 but still we
need to clear SGID. So we will have to pick a non-root sgid and switch
to that instead. That's an TODO item for future when idmapped mount
support is introduced.

Reported-by: Luis Henriques <lhenriques@suse.de>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/standard-headers/linux/fuse.h |  7 +++++
 tools/virtiofsd/passthrough_ll.c      | 42 +++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/include/standard-headers/linux/fuse.h b/include/standard-headers/linux/fuse.h
index cc87ff27d0..4eb79399d4 100644
--- a/include/standard-headers/linux/fuse.h
+++ b/include/standard-headers/linux/fuse.h
@@ -180,6 +180,7 @@
  *  - add FUSE_HANDLE_KILLPRIV_V2, FUSE_WRITE_KILL_SUIDGID, FATTR_KILL_SUIDGID
  *  - add FUSE_OPEN_KILL_SUIDGID
  *  - add FUSE_SETXATTR_V2
+ *  - add FUSE_SETXATTR_ACL_KILL_SGID
  */
 
 #ifndef _LINUX_FUSE_H
@@ -450,6 +451,12 @@ struct fuse_file_lock {
  */
 #define FUSE_OPEN_KILL_SUIDGID	(1 << 0)
 
+/**
+ * setxattr flags
+ * FUSE_SETXATTR_ACL_KILL_SGID: Clear SGID when system.posix_acl_access is set
+ */
+#define FUSE_SETXATTR_ACL_KILL_SGID    (1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP		= 1,
 	FUSE_FORGET		= 2,  /* no reply */
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 3f5c267604..8a48071d0b 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -175,7 +175,7 @@ struct lo_data {
     int user_killpriv_v2, killpriv_v2;
     /* If set, virtiofsd is responsible for setting umask during creation */
     bool change_umask;
-    int user_posix_acl;
+    int user_posix_acl, posix_acl;
 };
 
 static const struct fuse_opt lo_opts[] = {
@@ -716,8 +716,10 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
          * in fuse_lowlevel.c
          */
         fuse_log(FUSE_LOG_DEBUG, "lo_init: enabling posix acl\n");
-        conn->want |= FUSE_CAP_POSIX_ACL | FUSE_CAP_DONT_MASK;
+        conn->want |= FUSE_CAP_POSIX_ACL | FUSE_CAP_DONT_MASK |
+                      FUSE_CAP_SETXATTR_V2;
         lo->change_umask = true;
+        lo->posix_acl = true;
     } else {
         /* User either did not specify anything or wants it disabled */
         fuse_log(FUSE_LOG_DEBUG, "lo_init: disabling posix_acl\n");
@@ -3092,12 +3094,48 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
 
     sprintf(procname, "%i", inode->fd);
     if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
+        bool switched_creds = false;
+        struct lo_cred old = {};
+
         fd = openat(lo->proc_self_fd, procname, O_RDONLY);
         if (fd < 0) {
             saverr = errno;
             goto out;
         }
+
+        /*
+         * If we are setting posix access acl and if SGID needs to be
+         * cleared, then switch to caller's gid and drop CAP_FSETID
+         * and that should make sure host kernel clears SGID.
+         *
+         * This probably will not work when we support idmapped mounts.
+         * In that case we will need to find a non-root gid and switch
+         * to it. (Instead of gid in request). Fix it when we support
+         * idmapped mounts.
+         */
+        if (lo->posix_acl && !strcmp(name, "system.posix_acl_access")
+            && (extra_flags & FUSE_SETXATTR_ACL_KILL_SGID)) {
+            ret = lo_change_cred(req, &old, false);
+            if (ret) {
+                saverr = ret;
+                goto out;
+            }
+            ret = drop_effective_cap("FSETID", NULL);
+            if (ret != 0) {
+                lo_restore_cred(&old, false);
+                saverr = ret;
+                goto out;
+            }
+            switched_creds = true;
+        }
+
         ret = fsetxattr(fd, name, value, size, flags);
+
+        if (switched_creds) {
+            if (gain_effective_cap("FSETID"))
+                fuse_log(FUSE_LOG_ERR, "Failed to gain CAP_FSETID\n");
+            lo_restore_cred(&old, false);
+        }
     } else {
         /* fchdir should not fail here */
         assert(fchdir(lo->proc_self_fd) == 0);
-- 
2.25.4

