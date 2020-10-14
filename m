From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 14 Oct 2020 19:02:09 +0100
Message-Id: <20201014180209.49299-6-dgilbert@redhat.com>
In-Reply-To: <20201014180209.49299-1-dgilbert@redhat.com>
References: <20201014180209.49299-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 5/5] tools/virtiofsd: xattr name mappings:
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
 docs/tools/virtiofsd.rst         |  18 ++++++
 tools/virtiofsd/passthrough_ll.c | 108 ++++++++++++++++++++++++++++++-
 2 files changed, 125 insertions(+), 1 deletion(-)

diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
index 5cb64612ed..e388ef253e 100644
--- a/docs/tools/virtiofsd.rst
+++ b/docs/tools/virtiofsd.rst
@@ -127,6 +127,7 @@ Each rule consists of a number of fields separated with a separator that is the
 first non-white space character in the rule.  This separator must then be used
 for the whole rule.
 White space may be added before and after each rule.
+
 Using ':' as the separator a rule is of the form:
 
 ``:type:scope:key:prepend:``
@@ -162,6 +163,13 @@ on the server, and used as a new prefix.  It may be empty
 in which case a 'server' rule will always match on all names from
 the server.
 
+A simpler 'map' type provides a shorter syntax for the common case:
+
+``:map:key:prepend:``
+
+The 'map' type adds a number of separate rules to add **prepend** as a prefix
+to the matched **key** (or all attributes if **key** is empty).
+There may be at most one 'map' rule and it must be the last rule in the set.
 
 xattr-mapping Examples
 ----------------------
@@ -178,6 +186,11 @@ the first rule prefixes and strips 'user.virtiofs.',
 the second rule hides any non-prefixed attributes that
 the host set.
 
+This is equivalent to the 'map' rule:
+
+::
+-o xattrmap=":map::user.virtiofs.:"
+
 2) Prefix 'trusted.' attributes, allow others through
 
 ::
@@ -200,6 +213,11 @@ the 'user.viritofs.' path directly.
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
index 8406a2ae86..a1b3364ba3 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2074,6 +2074,106 @@ static void free_xattrmap(XattrMapEntry *map)
     g_free(map);
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
+static XattrMapEntry *parse_xattrmap_map(const char *rule,
+                                         XattrMapEntry *map,
+                                         size_t *nentries)
+{
+    char sep = *rule++;
+    const char *tmp;
+    char *key;
+    char *prefix;
+    XattrMapEntry tmp_entry;
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
+    map = add_xattrmap_entry(map, nentries, &tmp_entry);
+
+    if (!*key) {
+        /* Prefix all case */
+
+        /* 2nd: Hide any non-prefixed entries on the host */
+        tmp_entry.flags = XATTR_MAP_FLAG_END_BAD | XATTR_MAP_FLAG_ALL |
+                          XATTR_MAP_FLAG_LAST;
+        tmp_entry.key = g_strdup("");
+        tmp_entry.prepend = g_strdup("");
+        map = add_xattrmap_entry(map, nentries, &tmp_entry);
+    } else {
+        /* Prefix matching case */
+
+        /* 2nd: Hide non-prefixed but matching entries on the host */
+        tmp_entry.flags = XATTR_MAP_FLAG_END_BAD | XATTR_MAP_FLAG_SERVER;
+        tmp_entry.key = g_strdup(""); /* Not used */
+        tmp_entry.prepend = g_strdup(key);
+        map = add_xattrmap_entry(map, nentries, &tmp_entry);
+
+        /* 3rd: Stop the client accessing prefixed attributes directly */
+        tmp_entry.flags = XATTR_MAP_FLAG_END_BAD | XATTR_MAP_FLAG_CLIENT;
+        tmp_entry.key = g_strdup(prefix);
+        tmp_entry.prepend = g_strdup(""); /* Not used */
+        map = add_xattrmap_entry(map, nentries, &tmp_entry);
+
+        /* 4th: Everything else is OK */
+        tmp_entry.flags = XATTR_MAP_FLAG_END_OK | XATTR_MAP_FLAG_ALL |
+                          XATTR_MAP_FLAG_LAST;
+        tmp_entry.key = g_strdup("");
+        tmp_entry.prepend = g_strdup("");
+        map = add_xattrmap_entry(map, nentries, &tmp_entry);
+    }
+
+    g_free(key);
+    g_free(prefix);
+
+    return map;
+}
+
 static XattrMapEntry *parse_xattrmap(struct lo_data *lo)
 {
     XattrMapEntry *res = NULL;
@@ -2102,10 +2202,16 @@ static XattrMapEntry *parse_xattrmap(struct lo_data *lo)
             tmp_entry.flags |= XATTR_MAP_FLAG_END_OK;
         } else if (strstart(map, "bad", &map)) {
             tmp_entry.flags |= XATTR_MAP_FLAG_END_BAD;
+        } else if (strstart(map, "map", &map)) {
+            /*
+             * map is sugar that adds a number of rules, and must be
+             * the last entry.
+             */
+            return parse_xattrmap_map(map, res, &nentries);
         } else {
             fuse_log(FUSE_LOG_ERR,
                      "%s: Unexpected type;"
-                     "Expecting 'prefix', 'ok', or 'bad' in rule %zu\n",
+                     "Expecting 'prefix', 'ok', 'bad' or 'map' in rule %zu\n",
                      __func__, nentries);
             exit(1);
         }
-- 
2.28.0

