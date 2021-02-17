From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 17 Feb 2021 18:30:44 -0500
Message-Id: <20210217233046.81418-2-vgoyal@redhat.com>
In-Reply-To: <20210217233046.81418-1-vgoyal@redhat.com>
References: <20210217233046.81418-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 1/3] virtiofsd: Add an option to
	enable/disable posix acls
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

fuse has an option FUSE_POSIX_ACL which needs to be opted in by fuse
server to enable posix acls.

Add virtiofsd option "-o posix_acl/no_posix_acl" to let users enable/disable
posix acl support. By default it is disabled as of now.

Currently even if file server has not opted in for FUSE_POSIX_ACL, user can
still query acl and set acl, and system.posix_acl_access and
system.posix_acl_default xattrs show up listxattr response.

Miklos said this is confusing. So he said lets block and filter
system.posix_acl_access and system.posix_acl_default xattrs in
getxattr/setxattr/listxattr if user has explicitly disabled
posix acls using -o no_posix_acl.

As of now continuing to keeping the existing behavior if user did not
specify any option to disable acl support due to concerns about backward
compatibility.

v2: block system.posix_acl_access and system.posix_acl_default xattrs
    if user explicitly disabled acls. (Miklos)

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 95 +++++++++++++++++++++++++++++++-
 1 file changed, 94 insertions(+), 1 deletion(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 58d24c0010..26cdfbd1f0 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -169,6 +169,7 @@ struct lo_data {
     /* An O_PATH file descriptor to /proc/self/fd/ */
     int proc_self_fd;
     int user_killpriv_v2, killpriv_v2;
+    int user_posix_acl;
 };
 
 static const struct fuse_opt lo_opts[] = {
@@ -201,6 +202,8 @@ static const struct fuse_opt lo_opts[] = {
     { "announce_submounts", offsetof(struct lo_data, announce_submounts), 1 },
     { "killpriv_v2", offsetof(struct lo_data, user_killpriv_v2), 1 },
     { "no_killpriv_v2", offsetof(struct lo_data, user_killpriv_v2), 0 },
+    { "posix_acl", offsetof(struct lo_data, user_posix_acl), 1 },
+    { "no_posix_acl", offsetof(struct lo_data, user_posix_acl), 0 },
     FUSE_OPT_END
 };
 static bool use_syslog = false;
@@ -661,6 +664,23 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
         conn->want &= ~FUSE_CAP_HANDLE_KILLPRIV_V2;
         lo->killpriv_v2 = 0;
     }
+
+    if (lo->user_posix_acl == 1) {
+        /*
+         * User explicitly asked for this option. Enable it unconditionally.
+         * If connection does not have this capability, it should fail
+         * in fuse_lowlevel.c
+         */
+        fuse_log(FUSE_LOG_DEBUG, "lo_init: enabling posix acl\n");
+        conn->want |= FUSE_CAP_POSIX_ACL;
+    } else {
+        /*
+         * Either user specified to disable posix_acl, or did not specify
+         * anything. In both the cases do not enable posix acl.
+         */
+        fuse_log(FUSE_LOG_DEBUG, "lo_init: disabling posix_acl\n");
+        conn->want &= ~FUSE_CAP_POSIX_ACL;
+    }
 }
 
 static void lo_getattr(fuse_req_t req, fuse_ino_t ino,
@@ -2612,6 +2632,63 @@ static int xattr_map_server(const struct lo_data *lo, const char *server_name,
     return -ENODATA;
 }
 
+static bool block_xattr(struct lo_data *lo, const char *name)
+{
+    /*
+     * If user explicitly enabled posix_acl or did not provide any option,
+     * do not block acl. Otherwise block system.posix_acl_access and
+     * system.posix_acl_default xattrs.
+     */
+    if (lo->user_posix_acl) {
+        return false;
+    }
+    if (!strcmp(name, "system.posix_acl_access") ||
+        !strcmp(name, "system.posix_acl_default"))
+            return true;
+
+    return false;
+}
+
+/*
+ * Returns number of bytes in xattr_list after filtering on success. This
+ * could be zero as well if nothing is left after filtering.
+ *
+ * Returns negative error code on failure.
+ * xattr_list is modified in place.
+ */
+static int remove_blocked_xattrs(struct lo_data *lo, char *xattr_list,
+                                 unsigned in_size)
+{
+    size_t out_index, in_index;
+
+    /*
+     * As of now we only filter out acl xattrs. If acls are enabled or
+     * they have not been explicitly disabled, there is nothing to
+     * filter.
+     */
+    if (lo->user_posix_acl) {
+        return in_size;
+    }
+
+    out_index = 0;
+    in_index = 0;
+    while (in_index < in_size) {
+        char *in_ptr = xattr_list + in_index;
+
+        /* Length of current attribute name */
+        size_t in_len = strlen(xattr_list + in_index) + 1;
+
+        if (!block_xattr(lo, in_ptr)) {
+            if (in_index != out_index) {
+                memmove(xattr_list + out_index, xattr_list + in_index, in_len);
+            }
+            out_index += in_len;
+        }
+        in_index += in_len;
+     }
+    return out_index;
+}
+
 static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
                         size_t size)
 {
@@ -2625,6 +2702,11 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
     int saverr;
     int fd = -1;
 
+    if (block_xattr(lo, in_name)) {
+        fuse_reply_err(req, EOPNOTSUPP);
+        return;
+    }
+
     mapped_name = NULL;
     name = in_name;
     if (lo->xattrmap) {
@@ -2766,7 +2848,6 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
         if (ret == 0) {
             goto out;
         }
-
         if (lo->xattr_map_list) {
             /*
              * Map the names back, some attributes might be dropped,
@@ -2813,6 +2894,12 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
                 goto out;
             }
         }
+
+        ret = remove_blocked_xattrs(lo, value, ret);
+        if (ret <= 0) {
+            saverr = -ret;
+            goto out;
+        }
         fuse_reply_buf(req, value, ret);
     } else {
         /*
@@ -2851,6 +2938,11 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
     int saverr;
     int fd = -1;
 
+    if (block_xattr(lo, in_name)) {
+        fuse_reply_err(req, EOPNOTSUPP);
+        return;
+    }
+
     mapped_name = NULL;
     name = in_name;
     if (lo->xattrmap) {
@@ -3604,6 +3696,7 @@ int main(int argc, char *argv[])
         .allow_direct_io = 0,
         .proc_self_fd = -1,
         .user_killpriv_v2 = -1,
+        .user_posix_acl = -1,
     };
     struct lo_map_elem *root_elem;
     struct lo_map_elem *reserve_elem;
-- 
2.25.4

