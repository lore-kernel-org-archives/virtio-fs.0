From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu, 25 Jun 2020 17:29:29 +0100
Message-Id: <20200625162929.46672-4-dgilbert@redhat.com>
In-Reply-To: <20200625162929.46672-1-dgilbert@redhat.com>
References: <20200625162929.46672-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/3] virtiofsd: Allow addition or removal of
	capabilities
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, stefanha@redhat.com, vgoyal@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Allow capabilities to be added or removed from the allowed set for the
daemon; e.g.

default:
CapPrm: 00000000880000df
CapEff: 00000000880000df

-o modcaps=+sys_admin

CapPrm: 00000000882000df
CapEff: 00000000882000df

-o modcaps=+sys_admin:-chown

CapPrm: 00000000882000de
CapEff: 00000000882000de

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 docs/tools/virtiofsd.rst         |  5 ++++
 tools/virtiofsd/helper.c         |  2 ++
 tools/virtiofsd/passthrough_ll.c | 50 ++++++++++++++++++++++++++++++--
 3 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
index 378594c422..824e713491 100644
--- a/docs/tools/virtiofsd.rst
+++ b/docs/tools/virtiofsd.rst
@@ -54,6 +54,11 @@ Options
   * flock|no_flock -
     Enable/disable flock.  The default is ``no_flock``.
 
+  * modcaps=CAPLIST
+    Modify the list of capabilities allowed; CAPLIST is a colon separated
+    list of capabilities, each preceded by either + or -, e.g.
+    ''+sys_admin:-chown''.
+
   * log_level=LEVEL -
     Print only log messages matching LEVEL or more severe.  LEVEL is one of
     ``err``, ``warn``, ``info``, or ``debug``.  The default is ``info``.
diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
index 00a1ef666a..3105b6c23a 100644
--- a/tools/virtiofsd/helper.c
+++ b/tools/virtiofsd/helper.c
@@ -174,6 +174,8 @@ void fuse_cmdline_help(void)
            "                               default: no_writeback\n"
            "    -o xattr|no_xattr          enable/disable xattr\n"
            "                               default: no_xattr\n"
+           "    -o modcaps=CAPLIST         Modify the list of capabilities\n"
+           "                               e.g. -o modcaps=+sys_admin:-chown\n"
            "    --rlimit-nofile=<num>      set maximum number of file descriptors\n"
            "                               (0 leaves rlimit unchanged)\n"
            "                               default: min(1000000, fs.file-max - 16384)\n"
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 99d562046a..9d2cbc70ca 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -145,6 +145,7 @@ struct lo_data {
     int posix_lock;
     int xattr;
     char *source;
+    char *modcaps;
     double timeout;
     int cache;
     int timeout_set;
@@ -170,6 +171,7 @@ static const struct fuse_opt lo_opts[] = {
     { "no_posix_lock", offsetof(struct lo_data, posix_lock), 0 },
     { "xattr", offsetof(struct lo_data, xattr), 1 },
     { "no_xattr", offsetof(struct lo_data, xattr), 0 },
+    { "modcaps=%s", offsetof(struct lo_data, modcaps), 0 },
     { "timeout=%lf", offsetof(struct lo_data, timeout), 0 },
     { "timeout=", offsetof(struct lo_data, timeout_set), 1 },
     { "cache=none", offsetof(struct lo_data, cache), CACHE_NONE },
@@ -2571,7 +2573,7 @@ static void setup_mounts(const char *source)
 /*
  * Only keep whitelisted capabilities that are needed for file system operation
  */
-static void setup_capabilities(void)
+static void setup_capabilities(struct lo_data *lo)
 {
     pthread_mutex_lock(&cap.mutex);
     capng_restore_state(&cap.saved);
@@ -2604,6 +2606,50 @@ static void setup_capabilities(void)
         exit(1);
     }
 
+    /*
+     * The modcaps option is a colon separated list of caps,
+     * each preceded by either + or -.
+     */
+    while (lo->modcaps) {
+        capng_act_t action;
+        int cap;
+
+        char *next = strchr(lo->modcaps, ':');
+        if (next) {
+            *next = '\0';
+            next++;
+        }
+
+        switch (lo->modcaps[0]) {
+        case '+':
+            action = CAPNG_ADD;
+            break;
+
+        case '-':
+            action = CAPNG_DROP;
+            break;
+
+        default:
+            fuse_log(FUSE_LOG_ERR,
+                     "%s: Expecting '+'/'-' in modcaps but found '%c'\n",
+                     __func__, lo->modcaps[0]);
+            exit(1);
+        }
+        cap = capng_name_to_capability(lo->modcaps + 1);
+        if (cap < 0) {
+            fuse_log(FUSE_LOG_ERR, "%s: Unknown capability '%s'\n", __func__,
+                     lo->modcaps);
+            exit(1);
+        }
+        if (capng_update(action, CAPNG_PERMITTED | CAPNG_EFFECTIVE, cap)) {
+            fuse_log(FUSE_LOG_ERR, "%s: capng_update failed for '%s'\n",
+                     __func__, lo->modcaps);
+            exit(1);
+        }
+
+        lo->modcaps = next;
+    }
+
     if (capng_apply(CAPNG_SELECT_BOTH)) {
         fuse_log(FUSE_LOG_ERR, "%s: capng_apply failed\n", __func__);
         exit(1);
@@ -2627,7 +2673,7 @@ static void setup_sandbox(struct lo_data *lo, struct fuse_session *se,
     setup_namespaces(lo, se);
     setup_mounts(lo->source);
     setup_seccomp(enable_syslog);
-    setup_capabilities();
+    setup_capabilities(lo);
 }
 
 /* Set the maximum number of open file descriptors */
-- 
2.26.2

