From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Fri, 19 Jun 2020 18:18:09 +0100
Message-Id: <20200619171809.30984-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd: Allow capability restriction to be
	turned off
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

Commit a59feb483b8fae24d043 dropped most capabilities at startup,
since in most cases virtiofsd doesn't need them.  Unfortunately we found
a case that needs CAP_SYS_ADMIN - setting trusted extended attributes.
It's rare to need it, and the clean fix for it is going to be more
complicated, but as a way for existing users to continue, allow the
capability restriction to be turned off by adding

  -o no_restrictcaps

We still drop the capabilities by default since this seems much safer;
even if we don't have an explicit problem to fix.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 docs/tools/virtiofsd.rst         | 3 +++
 tools/virtiofsd/helper.c         | 3 +++
 tools/virtiofsd/passthrough_ll.c | 8 +++++++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
index 378594c422..8819d7d19e 100644
--- a/docs/tools/virtiofsd.rst
+++ b/docs/tools/virtiofsd.rst
@@ -81,6 +81,9 @@ Options
     Enable/disable extended attributes (xattr) on files and directories.  The
     default is ``no_xattr``.
 
+  * restrictcaps|no_restrictcaps\n"
+    Restrict capabilities at startup.  The default is ``restrictcaps``.
+
 .. option:: --socket-path=PATH
 
   Listen on vhost-user UNIX domain socket at PATH.
diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
index 00a1ef666a..51ed9fbed0 100644
--- a/tools/virtiofsd/helper.c
+++ b/tools/virtiofsd/helper.c
@@ -174,6 +174,9 @@ void fuse_cmdline_help(void)
            "                               default: no_writeback\n"
            "    -o xattr|no_xattr          enable/disable xattr\n"
            "                               default: no_xattr\n"
+           "    -o restrictcaps|no_restrictcaps\n"
+           "                               restrict capabilities at startup\n"
+           "                               default: restrictcaps\n"
            "    --rlimit-nofile=<num>      set maximum number of file descriptors\n"
            "                               (0 leaves rlimit unchanged)\n"
            "                               default: min(1000000, fs.file-max - 16384)\n"
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 2ce7c96085..8dee657b19 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -144,6 +144,7 @@ struct lo_data {
     int flock;
     int posix_lock;
     int xattr;
+    int restrictcaps;
     char *source;
     double timeout;
     int cache;
@@ -170,6 +171,8 @@ static const struct fuse_opt lo_opts[] = {
     { "no_posix_lock", offsetof(struct lo_data, posix_lock), 0 },
     { "xattr", offsetof(struct lo_data, xattr), 1 },
     { "no_xattr", offsetof(struct lo_data, xattr), 0 },
+    { "restrictcaps", offsetof(struct lo_data, restrictcaps), 1 },
+    { "no_restrictcaps", offsetof(struct lo_data, restrictcaps), 0 },
     { "timeout=%lf", offsetof(struct lo_data, timeout), 0 },
     { "timeout=", offsetof(struct lo_data, timeout_set), 1 },
     { "cache=none", offsetof(struct lo_data, cache), CACHE_NONE },
@@ -2615,7 +2618,9 @@ static void setup_sandbox(struct lo_data *lo, struct fuse_session *se,
     setup_namespaces(lo, se);
     setup_mounts(lo->source);
     setup_seccomp(enable_syslog);
-    setup_capabilities();
+    if (lo->restrictcaps) {
+        setup_capabilities();
+    }
 }
 
 /* Set the maximum number of open file descriptors */
@@ -2764,6 +2769,7 @@ int main(int argc, char *argv[])
         .writeback = 0,
         .posix_lock = 1,
         .proc_self_fd = -1,
+        .restrictcaps = 1,
     };
     struct lo_map_elem *root_elem;
     int ret = -1;
-- 
2.26.2

