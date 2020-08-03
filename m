From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Mon,  3 Aug 2020 20:15:09 +0100
Message-Id: <20200803191511.45261-2-dgilbert@redhat.com>
In-Reply-To: <20200803191511.45261-1-dgilbert@redhat.com>
References: <20200803191511.45261-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/3] tools/virtiofsd: xattr name mappings: Add
	option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Add an option to define mappings of xattr names so that
the client and host filesystems see different views.
This can be used to have different SELinux mappings as
seen by the guest, to run the virtiofsd with less privileges
(e.g. in a case where it can't set trusted/system/security
xattrs but you want the guest to be able to), or to isolate
multiple users of the same name; e.g. trusted attributes
used by stacking overlayfs.

A mapping engine is used wit 3 simple rules; the rules can
be combined to allow most useful mapping scenarios.
The ruleset is defined by -o xattrmap='rules...'.

This patch doesn't use the rule maps yet.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 docs/tools/virtiofsd.rst         |  46 +++++++++
 tools/virtiofsd/passthrough_ll.c | 156 ++++++++++++++++++++++++++++++-
 2 files changed, 201 insertions(+), 1 deletion(-)

diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
index 824e713491..82b6f6d90a 100644
--- a/docs/tools/virtiofsd.rst
+++ b/docs/tools/virtiofsd.rst
@@ -107,6 +107,51 @@ Options
   performance.  ``auto`` acts similar to NFS with a 1 second metadata cache
   timeout.  ``always`` sets a long cache lifetime at the expense of coherency.
 
+xattr-mapping
+-------------
+
+By default the name of xattr's used by the client are passe through to the host
+file system.  This can be a problem where either those xattr names are used
+by something on the host (e.g. selinux guest/host confusion) or if the
+virtiofsd is running in a container with restricted priviliges where it cannot
+access some attributes.
+
+A mapping of xattr names can be made using -o xattrmap=mapping where the ``mapping``
+string consists of a series of rules.
+
+Each rule starts and ends with a ':'.  The mapping stops on a matching
+rule.  White space may be added before and after each rule.
+
+:scope:type:key:prepend:
+
+scope= 'c' - match 'key' against a xattr name from the client
+            for setxattr/getxattr/removexattr
+       'h' - match 'prepend' against a xattr name from the host
+            for listxattr
+       both letters can be included to match both cases.
+
+type is one of:
+       'p' Prefixing: If 'key' matches the client then the 'prepend'
+           is added before the name is passed to the host.
+           For a host case, the prepend is tested and stripped
+           if matching.
+
+       'o' OK: The attribute name is OK and passed through to
+           the host unchanged.
+
+       'b' Bad: If a client tries to use this name it's
+           denied using EPERM; when the host passes an attribute
+           name matching it's hidden.
+
+key is a string tested as a prefix on an attribute name originating
+       on the client.  It maybe empty in which case a 'c' rule
+       will always match on client names.
+
+prepend is a string tested as a prefix on an attribute name originiating
+       on the host, and used as a new prefix by 'p'.  It maybe empty
+       in which case a 'h' rule will always match on host names.
+
+
 Examples
 --------
 
@@ -123,3 +168,4 @@ Export ``/var/lib/fs/vm001/`` on vhost-user UNIX domain socket
       -numa node,memdev=mem \
       ...
   guest# mount -t virtiofs myfs /mnt
+
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 94e0de2d2b..5506d84132 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -144,6 +144,7 @@ struct lo_data {
     int flock;
     int posix_lock;
     int xattr;
+    char *xattrmap;
     char *source;
     char *modcaps;
     double timeout;
@@ -171,6 +172,7 @@ static const struct fuse_opt lo_opts[] = {
     { "no_posix_lock", offsetof(struct lo_data, posix_lock), 0 },
     { "xattr", offsetof(struct lo_data, xattr), 1 },
     { "no_xattr", offsetof(struct lo_data, xattr), 0 },
+    { "xattrmap=%s", offsetof(struct lo_data, xattrmap), 0 },
     { "modcaps=%s", offsetof(struct lo_data, modcaps), 0 },
     { "timeout=%lf", offsetof(struct lo_data, timeout), 0 },
     { "timeout=", offsetof(struct lo_data, timeout_set), 1 },
@@ -2003,7 +2005,154 @@ static void lo_flock(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
     fuse_reply_err(req, res == -1 ? errno : 0);
 }
 
-static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
+typedef struct xattr_map_entry {
+    const char *key;
+    const char *prepend;
+    unsigned int flags;
+} XattrMapEntry;
+
+/*
+ * Exit; process attribute unmodified if matched.
+ * An empty key applies to all.
+ */
+#define XATTR_MAP_FLAG_END_OK  (1 <<  0)
+/*
+ * The attribute is unwanted;
+ * EPERM on write hidden on read.
+ */
+#define XATTR_MAP_FLAG_END_BAD (1 <<  1)
+/*
+ * For attr that start with 'key' prepend 'prepend'
+ * 'key' maybe empty to prepend for all attrs
+ * key is defined from set/remove point of view.
+ * Automatically reversed on read
+ */
+#define XATTR_MAP_FLAG_PREFIX  (1 <<  2)
+/* Apply rule to get/set/remove */
+#define XATTR_MAP_FLAG_CLIENT  (1 << 16)
+/* Apply rule to list */
+#define XATTR_MAP_FLAG_HOST    (1 << 17)
+/* Apply rule to all */
+#define XATTR_MAP_FLAG_ALL   (XATTR_MAP_FLAG_HOST | XATTR_MAP_FLAG_CLIENT)
+
+static XattrMapEntry *xattr_map_list;
+
+static XattrMapEntry *parse_xattrmap(const char *map)
+{
+    XattrMapEntry *res = NULL;
+    size_t nentries = 0;
+    const char *tmp;
+
+    while (*map) {
+        /* Find the : at the start of a rule */
+        if (isspace(*map)) {
+            map++;
+            continue;
+        }
+        if (*map != ':') {
+            fuse_log(FUSE_LOG_ERR,
+                     "%s: Expecting : or space, found '%c'"
+                     " at start of rule %zu\n",
+                     __func__, *map, nentries + 1);
+            exit(1);
+        }
+        /* Skip the :, now at the start of the 'scope' */
+        map++;
+
+        /* Allocate some space for the rule */
+        res = g_realloc_n(res, ++nentries, sizeof(XattrMapEntry));
+        res[nentries - 1].flags = 0;
+
+        /* Scope is one or both of 'c' or 'h' */
+        do {
+            switch (*map) {
+            case 'c':
+                res[nentries - 1].flags |= XATTR_MAP_FLAG_CLIENT;
+                map++;
+                break;
+            case 'h':
+                res[nentries - 1].flags |= XATTR_MAP_FLAG_HOST;
+                map++;
+                break;
+            case ':':
+                break;
+            default:
+                fuse_log(FUSE_LOG_ERR,
+                         "%s: Expecting 'c', 'h', or ':', found '%c' in scope"
+                         " section of rule %zu\n",
+                         __func__, *map, nentries);
+                exit(1);
+            }
+        } while (*map != ':');
+
+        /* Start of 'type' */
+        switch (*++map) {
+        case 'p':
+            res[nentries - 1].flags |= XATTR_MAP_FLAG_PREFIX;
+            map++;
+            break;
+        case 'o':
+            res[nentries - 1].flags |= XATTR_MAP_FLAG_END_OK;
+            map++;
+            break;
+        case 'b':
+            res[nentries - 1].flags |= XATTR_MAP_FLAG_END_BAD;
+            map++;
+            break;
+        default:
+            fuse_log(FUSE_LOG_ERR,
+                     "%s: Expecting 'p', 'o', or 'b', found '%c' in type"
+                     " section of rule %zu\n",
+                     __func__, *map, nentries);
+            exit(1);
+        }
+
+        if (*map++ != ':') {
+            fuse_log(FUSE_LOG_ERR,
+                     "%s: Missing ':' at end of type field of rule %zu\n",
+                     __func__, *map, nentries);
+            exit(1);
+        }
+
+        /* At start of 'key' field */
+        tmp = strchr(map, ':');
+        if (!tmp) {
+            fuse_log(FUSE_LOG_ERR,
+                     "%s: Missing ':' at end of key field of rule %zu",
+                     __func__, *map, nentries);
+            exit(1);
+        }
+        res[nentries - 1].key = g_strndup(map, tmp - map);
+        map = tmp + 1;
+
+        /* At start of 'prepend' field */
+        tmp = strchr(map, ':');
+        if (!tmp) {
+            fuse_log(FUSE_LOG_ERR,
+                     "%s: Missing ':' at end of prepend field of rule %zu",
+                     __func__, *map, nentries);
+            exit(1);
+        }
+        res[nentries - 1].prepend = g_strndup(map, tmp - map);
+        map = tmp + 1;
+        /* End of rule - go around again for another rule */
+    }
+
+    if (!nentries) {
+        fuse_log(FUSE_LOG_ERR, "Empty xattr map\n");
+        exit(1);
+    }
+
+    /* Add a terminaotr to error in cases the user hasn't specified */
+    res = g_realloc_n(res, ++nentries, sizeof(XattrMapEntry));
+    res[nentries - 1].flags = XATTR_MAP_FLAG_ALL | XATTR_MAP_FLAG_END_BAD;
+    res[nentries - 1].key = g_strdup("");
+    res[nentries - 1].prepend = g_strdup("");
+
+    return res;
+}
+
+static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
                         size_t size)
 {
     struct lo_data *lo = lo_data(req);
@@ -2909,6 +3058,11 @@ int main(int argc, char *argv[])
     } else {
         lo.source = strdup("/");
     }
+
+    if (lo.xattrmap) {
+        xattr_map_list = parse_xattrmap(lo.xattrmap);
+    }
+
     if (!lo.timeout_set) {
         switch (lo.cache) {
         case CACHE_NONE:
-- 
2.26.2

