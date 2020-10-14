From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 14 Oct 2020 19:02:06 +0100
Message-Id: <20201014180209.49299-3-dgilbert@redhat.com>
In-Reply-To: <20201014180209.49299-1-dgilbert@redhat.com>
References: <20201014180209.49299-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 2/5] tools/virtiofsd: xattr name mappings:
	Map client xattr names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, dinechin@redhat.com, virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Map xattr names originating at the client; from get/set/remove xattr.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 101 ++++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 3 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index f5a33014f9..57ebe17ed6 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2183,20 +2183,80 @@ static XattrMapEntry *parse_xattrmap(struct lo_data *lo)
     return res;
 }
 
-static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
+/*
+ * For use with getxattr/setxattr/removexattr, where the client
+ * gives us a name and we may need to choose a different one.
+ * Allocates a buffer for the result placing it in *out_name.
+ *   If there's no change then *out_name is not set.
+ * Returns 0 on success
+ * Can return -EPERM to indicate we block a given attribute
+ *   (in which case out_name is not allocated)
+ * Can return -ENOMEM to indicate out_name couldn't be allocated.
+ */
+static int xattr_map_client(const struct lo_data *lo, const char *client_name,
+                            char **out_name)
+{
+    const XattrMapEntry *cur_entry;
+
+    for (cur_entry = lo->xattr_map_list; ; cur_entry++) {
+        if ((cur_entry->flags & XATTR_MAP_FLAG_CLIENT) &&
+            (strstart(client_name, cur_entry->key, NULL))) {
+            if (cur_entry->flags & XATTR_MAP_FLAG_END_BAD) {
+                return -EPERM;
+            }
+            if (cur_entry->flags & XATTR_MAP_FLAG_END_OK) {
+                /* Unmodified name */
+                return 0;
+            }
+            if (cur_entry->flags & XATTR_MAP_FLAG_PREFIX) {
+                *out_name = g_try_malloc(strlen(client_name) +
+                                         strlen(cur_entry->prepend) + 1);
+                if (!*out_name) {
+                    return -ENOMEM;
+                }
+                sprintf(*out_name, "%s%s", cur_entry->prepend, client_name);
+                return 0;
+            }
+        }
+    }
+
+    /* Shouldn't get here - rules should have an END_* */
+    abort();
+}
+
+static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
                         size_t size)
 {
     struct lo_data *lo = lo_data(req);
     char *value = NULL;
     char procname[64];
+    const char *name;
+    char *mapped_name;
     struct lo_inode *inode;
     ssize_t ret;
     int saverr;
     int fd = -1;
 
+    mapped_name = NULL;
+    name = in_name;
+    if (lo->xattrmap) {
+        ret = xattr_map_client(lo, in_name, &mapped_name);
+        if (ret < 0) {
+            if (ret == -EPERM) {
+                ret = -ENODATA;
+            }
+            fuse_reply_err(req, -ret);
+            return;
+        }
+        if (mapped_name) {
+            name = mapped_name;
+        }
+    }
+
     inode = lo_inode(req, ino);
     if (!inode) {
         fuse_reply_err(req, EBADF);
+        g_free(mapped_name);
         return;
     }
 
@@ -2261,6 +2321,7 @@ out_err:
     saverr = errno;
 out:
     fuse_reply_err(req, saverr);
+    g_free(mapped_name);
     goto out_free;
 }
 
@@ -2338,19 +2399,35 @@ out:
     goto out_free;
 }
 
-static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
+static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
                         const char *value, size_t size, int flags)
 {
     char procname[64];
+    const char *name;
+    char *mapped_name;
     struct lo_data *lo = lo_data(req);
     struct lo_inode *inode;
     ssize_t ret;
     int saverr;
     int fd = -1;
 
+    mapped_name = NULL;
+    name = in_name;
+    if (lo->xattrmap) {
+        ret = xattr_map_client(lo, in_name, &mapped_name);
+        if (ret < 0) {
+            fuse_reply_err(req, -ret);
+            return;
+        }
+        if (mapped_name) {
+            name = mapped_name;
+        }
+    }
+
     inode = lo_inode(req, ino);
     if (!inode) {
         fuse_reply_err(req, EBADF);
+        g_free(mapped_name);
         return;
     }
 
@@ -2385,21 +2462,38 @@ out:
     }
 
     lo_inode_put(lo, &inode);
+    g_free(mapped_name);
     fuse_reply_err(req, saverr);
 }
 
-static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *name)
+static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
 {
     char procname[64];
+    const char *name;
+    char *mapped_name;
     struct lo_data *lo = lo_data(req);
     struct lo_inode *inode;
     ssize_t ret;
     int saverr;
     int fd = -1;
 
+    mapped_name = NULL;
+    name = in_name;
+    if (lo->xattrmap) {
+        ret = xattr_map_client(lo, in_name, &mapped_name);
+        if (ret < 0) {
+            fuse_reply_err(req, -ret);
+            return;
+        }
+        if (mapped_name) {
+            name = mapped_name;
+        }
+    }
+
     inode = lo_inode(req, ino);
     if (!inode) {
         fuse_reply_err(req, EBADF);
+        g_free(mapped_name);
         return;
     }
 
@@ -2434,6 +2528,7 @@ out:
     }
 
     lo_inode_put(lo, &inode);
+    g_free(mapped_name);
     fuse_reply_err(req, saverr);
 }
 
-- 
2.28.0

