From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Mon, 26 Oct 2020 18:43:19 +0000
Message-Id: <20201026184331.272953-5-dgilbert@redhat.com>
In-Reply-To: <20201026184331.272953-1-dgilbert@redhat.com>
References: <20201026184331.272953-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 04/16] tools/virtiofsd: xattr name mappings: Add
	option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, mreitz@redhat.com, misono.tomohiro@jp.fujitsu.com
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Add an option to define mappings of xattr names so that
the client and server filesystems see different views.
This can be used to have different SELinux mappings as
seen by the guest, to run the virtiofsd with less privileges
(e.g. in a case where it can't set trusted/system/security
xattrs but you want the guest to be able to), or to isolate
multiple users of the same name; e.g. trusted attributes
used by stacking overlayfs.

A mapping engine is used with 3 simple rules; the rules can
be combined to allow most useful mapping scenarios.
The ruleset is defined by -o xattrmap='rules...'.

This patch doesn't use the rule maps yet.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Message-Id: <20201023165812.36028-2-dgilbert@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 docs/tools/virtiofsd.rst         |  92 ++++++++++++++++
 tools/virtiofsd/passthrough_ll.c | 173 +++++++++++++++++++++++++++++++
 2 files changed, 265 insertions(+)

diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
index 65f8e76569..67c16f9df0 100644
--- a/docs/tools/virtiofsd.rst
+++ b/docs/tools/virtiofsd.rst
@@ -127,6 +127,98 @@ Options
   timeout.  ``always`` sets a long cache lifetime at the expense of coherency.
   The default is ``auto``.
 
+xattr-mapping
+-------------
+
+By default the name of xattr's used by the client are passed through to the server
+file system.  This can be a problem where either those xattr names are used
+by something on the server (e.g. selinux client/server confusion) or if the
+virtiofsd is running in a container with restricted privileges where it cannot
+access some attributes.
+
+A mapping of xattr names can be made using -o xattrmap=mapping where the ``mapping``
+string consists of a series of rules.
+
+The first matching rule terminates the mapping.
+The set of rules must include a terminating rule to match any remaining attributes
+at the end.
+
+Each rule consists of a number of fields separated with a separator that is the
+first non-white space character in the rule.  This separator must then be used
+for the whole rule.
+White space may be added before and after each rule.
+Using ':' as the separator a rule is of the form:
+
+``:type:scope:key:prepend:``
+
+**scope** is:
+
+- 'client' - match 'key' against a xattr name from the client for
+             setxattr/getxattr/removexattr
+- 'server' - match 'prepend' against a xattr name from the server
+             for listxattr
+- 'all' - can be used to make a single rule where both the server
+          and client matches are triggered.
+
+**type** is one of:
+
+- 'prefix' - is designed to prepend and strip a prefix;  the modified
+  attributes then being passed on to the client/server.
+
+- 'ok' - Causes the rule set to be terminated when a match is found
+  while allowing matching xattr's through unchanged.
+  It is intended both as a way of explicitly terminating
+  the list of rules, and to allow some xattr's to skip following rules.
+
+- 'bad' - If a client tries to use a name matching 'key' it's
+  denied using EPERM; when the server passes an attribute
+  name matching 'prepend' it's hidden.  In many ways it's use is very like
+  'ok' as either an explict terminator or for special handling of certain
+  patterns.
+
+**key** is a string tested as a prefix on an attribute name originating
+on the client.  It maybe empty in which case a 'client' rule
+will always match on client names.
+
+**prepend** is a string tested as a prefix on an attribute name originating
+on the server, and used as a new prefix.  It may be empty
+in which case a 'server' rule will always match on all names from
+the server.
+
+e.g.:
+
+  ``:prefix:client:trusted.:user.virtiofs.:``
+
+  will match 'trusted.' attributes in client calls and prefix them before
+  passing them to the server.
+
+  ``:prefix:server::user.virtiofs.:``
+
+  will strip 'user.virtiofs.' from all server replies.
+
+  ``:prefix:all:trusted.:user.virtiofs.:``
+
+  combines the previous two cases into a single rule.
+
+  ``:ok:client:user.::``
+
+  will allow get/set xattr for 'user.' xattr's and ignore
+  following rules.
+
+  ``:ok:server::security.:``
+
+  will pass 'securty.' xattr's in listxattr from the server
+  and ignore following rules.
+
+  ``:ok:all:::``
+
+  will terminate the rule search passing any remaining attributes
+  in both directions.
+
+  ``:bad:server::security.:``
+
+  would hide 'security.' xattr's in listxattr from the server.
+
 Examples
 --------
 
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index f03b1f9a69..cb24af27f5 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -64,6 +64,7 @@
 #include <syslog.h>
 #include <unistd.h>
 
+#include "qemu/cutils.h"
 #include "passthrough_helpers.h"
 #include "passthrough_seccomp.h"
 
@@ -142,6 +143,12 @@ enum {
     SANDBOX_CHROOT,
 };
 
+typedef struct xattr_map_entry {
+    char *key;
+    char *prepend;
+    unsigned int flags;
+} XattrMapEntry;
+
 struct lo_data {
     pthread_mutex_t mutex;
     int sandbox;
@@ -150,6 +157,7 @@ struct lo_data {
     int flock;
     int posix_lock;
     int xattr;
+    char *xattrmap;
     char *source;
     char *modcaps;
     double timeout;
@@ -163,6 +171,8 @@ struct lo_data {
     struct lo_map ino_map; /* protected by lo->mutex */
     struct lo_map dirp_map; /* protected by lo->mutex */
     struct lo_map fd_map; /* protected by lo->mutex */
+    XattrMapEntry *xattr_map_list;
+    size_t xattr_map_nentries;
 
     /* An O_PATH file descriptor to /proc/self/fd/ */
     int proc_self_fd;
@@ -184,6 +194,7 @@ static const struct fuse_opt lo_opts[] = {
     { "no_posix_lock", offsetof(struct lo_data, posix_lock), 0 },
     { "xattr", offsetof(struct lo_data, xattr), 1 },
     { "no_xattr", offsetof(struct lo_data, xattr), 0 },
+    { "xattrmap=%s", offsetof(struct lo_data, xattrmap), 0 },
     { "modcaps=%s", offsetof(struct lo_data, modcaps), 0 },
     { "timeout=%lf", offsetof(struct lo_data, timeout), 0 },
     { "timeout=", offsetof(struct lo_data, timeout_set), 1 },
@@ -2022,6 +2033,161 @@ static void lo_flock(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
     fuse_reply_err(req, res == -1 ? errno : 0);
 }
 
+/* types */
+/*
+ * Exit; process attribute unmodified if matched.
+ * An empty key applies to all.
+ */
+#define XATTR_MAP_FLAG_OK      (1 <<  0)
+/*
+ * The attribute is unwanted;
+ * EPERM on write, hidden on read.
+ */
+#define XATTR_MAP_FLAG_BAD     (1 <<  1)
+/*
+ * For attr that start with 'key' prepend 'prepend'
+ * 'key' may be empty to prepend for all attrs
+ * key is defined from set/remove point of view.
+ * Automatically reversed on read
+ */
+#define XATTR_MAP_FLAG_PREFIX  (1 <<  2)
+
+/* scopes */
+/* Apply rule to get/set/remove */
+#define XATTR_MAP_FLAG_CLIENT  (1 << 16)
+/* Apply rule to list */
+#define XATTR_MAP_FLAG_SERVER  (1 << 17)
+/* Apply rule to all */
+#define XATTR_MAP_FLAG_ALL   (XATTR_MAP_FLAG_SERVER | XATTR_MAP_FLAG_CLIENT)
+
+static void add_xattrmap_entry(struct lo_data *lo,
+                               const XattrMapEntry *new_entry)
+{
+    XattrMapEntry *res = g_realloc_n(lo->xattr_map_list,
+                                     lo->xattr_map_nentries + 1,
+                                     sizeof(XattrMapEntry));
+    res[lo->xattr_map_nentries++] = *new_entry;
+
+    lo->xattr_map_list = res;
+}
+
+static void free_xattrmap(struct lo_data *lo)
+{
+    XattrMapEntry *map = lo->xattr_map_list;
+    size_t i;
+
+    if (!map) {
+        return;
+    }
+
+    for (i = 0; i < lo->xattr_map_nentries; i++) {
+        g_free(map[i].key);
+        g_free(map[i].prepend);
+    };
+
+    g_free(map);
+    lo->xattr_map_list = NULL;
+    lo->xattr_map_nentries = -1;
+}
+
+static void parse_xattrmap(struct lo_data *lo)
+{
+    const char *map = lo->xattrmap;
+    const char *tmp;
+
+    lo->xattr_map_nentries = 0;
+    while (*map) {
+        XattrMapEntry tmp_entry;
+        char sep;
+
+        if (isspace(*map)) {
+            map++;
+            continue;
+        }
+        /* The separator is the first non-space of the rule */
+        sep = *map++;
+        if (!sep) {
+            break;
+        }
+
+        tmp_entry.flags = 0;
+        /* Start of 'type' */
+        if (strstart(map, "prefix", &map)) {
+            tmp_entry.flags |= XATTR_MAP_FLAG_PREFIX;
+        } else if (strstart(map, "ok", &map)) {
+            tmp_entry.flags |= XATTR_MAP_FLAG_OK;
+        } else if (strstart(map, "bad", &map)) {
+            tmp_entry.flags |= XATTR_MAP_FLAG_BAD;
+        } else {
+            fuse_log(FUSE_LOG_ERR,
+                     "%s: Unexpected type;"
+                     "Expecting 'prefix', 'ok', or 'bad' in rule %zu\n",
+                     __func__, lo->xattr_map_nentries);
+            exit(1);
+        }
+
+        if (*map++ != sep) {
+            fuse_log(FUSE_LOG_ERR,
+                     "%s: Missing '%c' at end of type field of rule %zu\n",
+                     __func__, sep, lo->xattr_map_nentries);
+            exit(1);
+        }
+
+        /* Start of 'scope' */
+        if (strstart(map, "client", &map)) {
+            tmp_entry.flags |= XATTR_MAP_FLAG_CLIENT;
+        } else if (strstart(map, "server", &map)) {
+            tmp_entry.flags |= XATTR_MAP_FLAG_SERVER;
+        } else if (strstart(map, "all", &map)) {
+            tmp_entry.flags |= XATTR_MAP_FLAG_ALL;
+        } else {
+            fuse_log(FUSE_LOG_ERR,
+                     "%s: Unexpected scope;"
+                     " Expecting 'client', 'server', or 'all', in rule %zu\n",
+                     __func__, lo->xattr_map_nentries);
+            exit(1);
+        }
+
+        if (*map++ != sep) {
+            fuse_log(FUSE_LOG_ERR,
+                     "%s: Expecting '%c' found '%c'"
+                     " after scope in rule %zu\n",
+                     __func__, sep, *map, lo->xattr_map_nentries);
+            exit(1);
+        }
+
+        /* At start of 'key' field */
+        tmp = strchr(map, sep);
+        if (!tmp) {
+            fuse_log(FUSE_LOG_ERR,
+                     "%s: Missing '%c' at end of key field of rule %zu",
+                     __func__, sep, lo->xattr_map_nentries);
+            exit(1);
+        }
+        tmp_entry.key = g_strndup(map, tmp - map);
+        map = tmp + 1;
+
+        /* At start of 'prepend' field */
+        tmp = strchr(map, sep);
+        if (!tmp) {
+            fuse_log(FUSE_LOG_ERR,
+                     "%s: Missing '%c' at end of prepend field of rule %zu",
+                     __func__, sep, lo->xattr_map_nentries);
+            exit(1);
+        }
+        tmp_entry.prepend = g_strndup(map, tmp - map);
+        map = tmp + 1;
+
+        add_xattrmap_entry(lo, &tmp_entry);
+        /* End of rule - go around again for another rule */
+    }
+
+    if (!lo->xattr_map_nentries) {
+        fuse_log(FUSE_LOG_ERR, "Empty xattr map\n");
+        exit(1);
+    }
+}
+
 static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
                         size_t size)
 {
@@ -2858,6 +3024,8 @@ static void fuse_lo_data_cleanup(struct lo_data *lo)
         close(lo->root.fd);
     }
 
+    free(lo->xattrmap);
+    free_xattrmap(lo);
     free(lo->source);
 }
 
@@ -2958,6 +3126,11 @@ int main(int argc, char *argv[])
     } else {
         lo.source = strdup("/");
     }
+
+    if (lo.xattrmap) {
+        parse_xattrmap(&lo);
+    }
+
     if (!lo.timeout_set) {
         switch (lo.cache) {
         case CACHE_NONE:
-- 
2.28.0

