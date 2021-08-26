From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 26 Aug 2021 17:19:36 -0400
Message-Id: <20210826211937.317558-2-vgoyal@redhat.com>
In-Reply-To: <20210826211937.317558-1-vgoyal@redhat.com>
References: <20210826211937.317558-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/2] virtiofsd: Add an array to keep track of
	blocked xattrs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com

Right now we have capability to block "system.posix_acl_access" and
"system.posix_acl_default" xattrs. But we have sort of hardcoded these
two values and its not generic.

Now we want to support blocking of arbitrary xattr as passed in
by user. So let us keep an array of blocked xattrs and consult
that array when deciding whether an attribute is blocked or not.

This should not result any functional change.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 77 ++++++++++++++++++++++++++------
 1 file changed, 63 insertions(+), 14 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 38b2af8599..9e93bcdbb3 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -176,6 +176,8 @@ struct lo_data {
     /* If set, virtiofsd is responsible for setting umask during creation */
     bool change_umask;
     int user_posix_acl, posix_acl;
+    char **blocked_xattrs;
+    size_t num_blocked_xattrs;
 };
 
 static const struct fuse_opt lo_opts[] = {
@@ -2811,19 +2813,57 @@ static int xattr_map_server(const struct lo_data *lo, const char *server_name,
         assert(fchdir_res == 0);                       \
     } while (0)
 
+/* Returns 0 on success, 1 on failure */
+static int add_blocked_xattr(struct lo_data *lo, const char *name)
+{
+    size_t nr_elems = lo->num_blocked_xattrs + 1;
+
+    lo->blocked_xattrs = reallocarray(lo->blocked_xattrs, nr_elems,
+                                      sizeof(char *));
+    if (!lo->blocked_xattrs) {
+        fuse_log(FUSE_LOG_ERR, "failed to grow blocked xattrs array: %m\n");
+        return 1;
+    }
+
+    lo->blocked_xattrs[nr_elems - 1] = strdup(name);
+    if (!lo->blocked_xattrs[nr_elems - 1]) {
+        fuse_log(FUSE_LOG_ERR, "strdup(%s) failed: %m\n", name);
+        return 1;
+    }
+    lo->num_blocked_xattrs++;
+    return 0;
+}
+
+static void free_blocked_xattrs(struct lo_data *lo)
+{
+    size_t i;
+
+    if (!lo->num_blocked_xattrs) {
+        return;
+    }
+
+    for (i = 0; i < lo->num_blocked_xattrs; i++) {
+        free(lo->blocked_xattrs[i]);
+    }
+
+    free(lo->blocked_xattrs);
+    lo->num_blocked_xattrs = 0;
+    lo->blocked_xattrs = NULL;
+}
+
 static bool block_xattr(struct lo_data *lo, const char *name)
 {
-    /*
-     * If user explicitly enabled posix_acl or did not provide any option,
-     * do not block acl. Otherwise block system.posix_acl_access and
-     * system.posix_acl_default xattrs.
-     */
-    if (lo->user_posix_acl) {
+    size_t i;
+
+    if (!lo->num_blocked_xattrs) {
         return false;
     }
-    if (!strcmp(name, "system.posix_acl_access") ||
-        !strcmp(name, "system.posix_acl_default"))
+
+    for (i = 0; i < lo->num_blocked_xattrs; i++) {
+        if (!strcmp(name, lo->blocked_xattrs[i])) {
             return true;
+        }
+    }
 
     return false;
 }
@@ -2840,12 +2880,7 @@ static int remove_blocked_xattrs(struct lo_data *lo, char *xattr_list,
 {
     size_t out_index, in_index;
 
-    /*
-     * As of now we only filter out acl xattrs. If acls are enabled or
-     * they have not been explicitly disabled, there is nothing to
-     * filter.
-     */
-    if (lo->user_posix_acl) {
+    if (!lo->num_blocked_xattrs) {
         return in_size;
     }
 
@@ -3880,6 +3915,7 @@ static void fuse_lo_data_cleanup(struct lo_data *lo)
     free(lo->xattrmap);
     free_xattrmap(lo);
     free(lo->xattr_security_capability);
+    free_blocked_xattrs(lo);
     free(lo->source);
 }
 
@@ -3920,6 +3956,8 @@ int main(int argc, char *argv[])
     lo.root.fd = -1;
     lo.root.fuse_ino = FUSE_ROOT_ID;
     lo.cache = CACHE_AUTO;
+    lo.num_blocked_xattrs = 0;
+    lo.blocked_xattrs = NULL;
 
     /*
      * Set up the ino map like this:
@@ -4036,6 +4074,17 @@ int main(int argc, char *argv[])
         exit(1);
     }
 
+    if (!lo.user_posix_acl) {
+        /* User disabled posix acl explicitly. Block acl xattrs */
+        if (add_blocked_xattr(&lo, "system.posix_acl_access")) {
+            exit(1);
+        }
+
+        if (add_blocked_xattr(&lo, "system.posix_acl_default")) {
+            exit(1);
+        }
+    }
+
     lo.use_statx = true;
 
     se = fuse_session_new(&args, &lo_oper, sizeof(lo_oper), &lo);
-- 
2.31.1

