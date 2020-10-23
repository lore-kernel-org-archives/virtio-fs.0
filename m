From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Fri, 23 Oct 2020 17:58:10 +0100
Message-Id: <20201023165812.36028-4-dgilbert@redhat.com>
In-Reply-To: <20201023165812.36028-1-dgilbert@redhat.com>
References: <20201023165812.36028-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 3/5] tools/virtiofsd: xattr name mappings:
	Map server xattr names
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

Map xattr names coming from the server, i.e. the host filesystem;
currently this is only from listxattr.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 90 ++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index ec3ef7b50d..57f584ee49 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2217,6 +2217,44 @@ static int xattr_map_client(const struct lo_data *lo, const char *client_name,
     return -EPERM;
 }
 
+/*
+ * For use with listxattr where the server fs gives us a name and we may need
+ * to sanitize this for the client.
+ * Returns a pointer to the result in *out_name
+ *   This is always the original string or the current string with some prefix
+ *   removed; no reallocation is done.
+ * Returns 0 on success
+ * Can return -ENODATA to indicate the name should be dropped from the list.
+ */
+static int xattr_map_server(const struct lo_data *lo, const char *server_name,
+                            const char **out_name)
+{
+    size_t i;
+    const char *end;
+
+    for (i = 0; i < lo->xattr_map_nentries; i++) {
+        const XattrMapEntry *cur_entry = lo->xattr_map_list + i;
+
+        if ((cur_entry->flags & XATTR_MAP_FLAG_SERVER) &&
+            (strstart(server_name, cur_entry->prepend, &end))) {
+            if (cur_entry->flags & XATTR_MAP_FLAG_BAD) {
+                return -ENODATA;
+            }
+            if (cur_entry->flags & XATTR_MAP_FLAG_OK) {
+                *out_name = server_name;
+                return 0;
+            }
+            if (cur_entry->flags & XATTR_MAP_FLAG_PREFIX) {
+                /* Remove prefix */
+                *out_name = end;
+                return 0;
+            }
+        }
+    }
+
+    return -ENODATA;
+}
+
 static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
                         size_t size)
 {
@@ -2371,8 +2409,60 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
         if (ret == 0) {
             goto out;
         }
+
+        if (lo->xattr_map_list) {
+            /*
+             * Map the names back, some attributes might be dropped,
+             * some shortened, but not increased, so we shouldn't
+             * run out of room.
+             */
+            size_t out_index, in_index;
+            out_index = 0;
+            in_index = 0;
+            while (in_index < ret) {
+                const char *map_out;
+                char *in_ptr = value + in_index;
+                /* Length of current attribute name */
+                size_t in_len = strlen(value + in_index) + 1;
+
+                int mapret = xattr_map_server(lo, in_ptr, &map_out);
+                if (mapret != -ENODATA && mapret != 0) {
+                    /* Shouldn't happen */
+                    saverr = -mapret;
+                    goto out;
+                }
+                if (mapret == 0) {
+                    /* Either unchanged, or truncated */
+                    size_t out_len;
+                    if (map_out != in_ptr) {
+                        /* +1 copies the NIL */
+                        out_len = strlen(map_out) + 1;
+                    } else {
+                        /* No change */
+                        out_len = in_len;
+                    }
+                    /*
+                     * Move result along, may still be needed for an unchanged
+                     * entry if a previous entry was changed.
+                     */
+                    memmove(value + out_index, map_out, out_len);
+
+                    out_index += out_len;
+                }
+                in_index += in_len;
+            }
+            ret = out_index;
+            if (ret == 0) {
+                goto out;
+            }
+        }
         fuse_reply_buf(req, value, ret);
     } else {
+        /*
+         * xattrmap only ever shortens the result,
+         * so we don't need to do anything clever with the
+         * allocation length here.
+         */
         fuse_reply_xattr(req, ret);
     }
 out_free:
-- 
2.28.0

