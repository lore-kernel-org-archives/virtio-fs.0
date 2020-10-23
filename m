From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Fri, 23 Oct 2020 17:58:12 +0100
Message-Id: <20201023165812.36028-6-dgilbert@redhat.com>
In-Reply-To: <20201023165812.36028-1-dgilbert@redhat.com>
References: <20201023165812.36028-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 5/5] tools/virtiofsd: xattr name mappings:
	Simple 'map'
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

The mapping rule system implemented in the last few patches is
extremely flexible, but not easy to use.  Add a simple
'map' type as a sprinkling of sugar to make it easy.

e.g.

  -o xattrmap=":map::user.virtiofs.:"

would be sufficient to prefix all xattr's
or

  -o xattrmap=":map:trusted.:user.virtiofs.:"

would just prefix 'trusted.' xattr's and leave
everything else alone.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 docs/tools/virtiofsd.rst         |  19 ++++++
 tools/virtiofsd/passthrough_ll.c | 112 ++++++++++++++++++++++++++++++-
 2 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
index 4e74690eca..24268fd67e 100644
--- a/docs/tools/virtiofsd.rst
+++ b/docs/tools/virtiofsd.rst
@@ -129,6 +129,7 @@ Each rule consists of a number of fields separated with a separator that is the
 first non-white space character in the rule.  This separator must then be used
 for the whole rule.
 White space may be added before and after each rule.
+
 Using ':' as the separator a rule is of the form:
 
 ``:type:scope:key:prepend:``
@@ -201,6 +202,14 @@ e.g.:
 
   would hide 'security.' xattr's in listxattr from the server.
 
+A simpler 'map' type provides a shorter syntax for the common case:
+
+``:map:key:prepend:``
+
+The 'map' type adds a number of separate rules to add **prepend** as a prefix
+to the matched **key** (or all attributes if **key** is empty).
+There may be at most one 'map' rule and it must be the last rule in the set.
+
 xattr-mapping Examples
 ----------------------
 
@@ -216,6 +225,11 @@ the first rule prefixes and strips 'user.virtiofs.',
 the second rule hides any non-prefixed attributes that
 the host set.
 
+This is equivalent to the 'map' rule:
+
+::
+-o xattrmap=":map::user.virtiofs.:"
+
 2) Prefix 'trusted.' attributes, allow others through
 
 ::
@@ -238,6 +252,11 @@ the 'user.viritofs.' path directly.
 Finally, the fourth rule lets all remaining attributes
 through.
 
+This is equivalent to the 'map' rule:
+
+::
+-o xattrmap="/map/trusted./user.virtiofs./"
+
 3) Hide 'security.' attributes, and allow everything else
 
 ::
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 57f584ee49..9f1ad9698d 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2078,6 +2078,109 @@ static void free_xattrmap(struct lo_data *lo)
     lo->xattr_map_nentries = -1;
 }
 
+/*
+ * Handle the 'map' type, which is sugar for a set of commands
+ * for the common case of prefixing a subset or everything,
+ * and allowing anything not prefixed through.
+ * It must be the last entry in the stream, although there
+ * can be other entries before it.
+ * The form is:
+ *    :map:key:prefix:
+ *
+ * key maybe empty in which case all entries are prefixed.
+ */
+static void parse_xattrmap_map(struct lo_data *lo,
+                               const char *rule, char sep)
+{
+    const char *tmp;
+    char *key;
+    char *prefix;
+    XattrMapEntry tmp_entry;
+
+    if (*rule != sep) {
+        fuse_log(FUSE_LOG_ERR,
+                 "%s: Expecting '%c' after 'map' keyword, found '%c'\n",
+                 __func__, sep, *rule);
+        exit(1);
+    }
+
+    rule++;
+
+    /* At start of 'key' field */
+    tmp = strchr(rule, sep);
+    if (!tmp) {
+        fuse_log(FUSE_LOG_ERR,
+                 "%s: Missing '%c' at end of key field in map rule\n",
+                 __func__, sep);
+        exit(1);
+    }
+
+    key = g_strndup(rule, tmp - rule);
+    rule = tmp + 1;
+
+    /* At start of prefix field */
+    tmp = strchr(rule, sep);
+    if (!tmp) {
+        fuse_log(FUSE_LOG_ERR,
+                 "%s: Missing '%c' at end of prefix field in map rule\n",
+                 __func__, sep);
+        exit(1);
+    }
+
+    prefix = g_strndup(rule, tmp - rule);
+    rule = tmp + 1;
+
+    /*
+     * This should be the end of the string, we don't allow
+     * any more commands after 'map'.
+     */
+    if (*rule) {
+        fuse_log(FUSE_LOG_ERR,
+                 "%s: Expecting end of command after map, found '%c'\n",
+                 __func__, *rule);
+        exit(1);
+    }
+
+    /* 1st: Prefix matches/everything */
+    tmp_entry.flags = XATTR_MAP_FLAG_PREFIX | XATTR_MAP_FLAG_ALL;
+    tmp_entry.key = g_strdup(key);
+    tmp_entry.prepend = g_strdup(prefix);
+    add_xattrmap_entry(lo, &tmp_entry);
+
+    if (!*key) {
+        /* Prefix all case */
+
+        /* 2nd: Hide any non-prefixed entries on the host */
+        tmp_entry.flags = XATTR_MAP_FLAG_BAD | XATTR_MAP_FLAG_ALL;
+        tmp_entry.key = g_strdup("");
+        tmp_entry.prepend = g_strdup("");
+        add_xattrmap_entry(lo, &tmp_entry);
+    } else {
+        /* Prefix matching case */
+
+        /* 2nd: Hide non-prefixed but matching entries on the host */
+        tmp_entry.flags = XATTR_MAP_FLAG_BAD | XATTR_MAP_FLAG_SERVER;
+        tmp_entry.key = g_strdup(""); /* Not used */
+        tmp_entry.prepend = g_strdup(key);
+        add_xattrmap_entry(lo, &tmp_entry);
+
+        /* 3rd: Stop the client accessing prefixed attributes directly */
+        tmp_entry.flags = XATTR_MAP_FLAG_BAD | XATTR_MAP_FLAG_CLIENT;
+        tmp_entry.key = g_strdup(prefix);
+        tmp_entry.prepend = g_strdup(""); /* Not used */
+        add_xattrmap_entry(lo, &tmp_entry);
+
+        /* 4th: Everything else is OK */
+        tmp_entry.flags = XATTR_MAP_FLAG_OK | XATTR_MAP_FLAG_ALL;
+        tmp_entry.key = g_strdup("");
+        tmp_entry.prepend = g_strdup("");
+        add_xattrmap_entry(lo, &tmp_entry);
+    }
+
+    g_free(key);
+    g_free(prefix);
+}
+
 static void parse_xattrmap(struct lo_data *lo)
 {
     const char *map = lo->xattrmap;
@@ -2106,10 +2209,17 @@ static void parse_xattrmap(struct lo_data *lo)
             tmp_entry.flags |= XATTR_MAP_FLAG_OK;
         } else if (strstart(map, "bad", &map)) {
             tmp_entry.flags |= XATTR_MAP_FLAG_BAD;
+        } else if (strstart(map, "map", &map)) {
+            /*
+             * map is sugar that adds a number of rules, and must be
+             * the last entry.
+             */
+            parse_xattrmap_map(lo, map, sep);
+            return;
         } else {
             fuse_log(FUSE_LOG_ERR,
                      "%s: Unexpected type;"
-                     "Expecting 'prefix', 'ok', or 'bad' in rule %zu\n",
+                     "Expecting 'prefix', 'ok', 'bad' or 'map' in rule %zu\n",
                      __func__, lo->xattr_map_nentries);
             exit(1);
         }
-- 
2.28.0

