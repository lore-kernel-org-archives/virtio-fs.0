From: Max Reitz <mreitz@redhat.com>
Date: Mon,  2 Nov 2020 17:18:57 +0100
Message-Id: <20201102161859.156603-6-mreitz@redhat.com>
In-Reply-To: <20201102161859.156603-1-mreitz@redhat.com>
References: <20201102161859.156603-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 5/7] virtiofsd: Announce sub-mount points
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Eduardo Habkost <ehabkost@redhat.com>, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com

Whenever we encounter a directory with an st_dev or mount ID that
differs from that of its parent, we set the FUSE_ATTR_SUBMOUNT flag so
the guest can create a submount for it.

We only need to do so in lo_do_lookup().  The following functions return
a fuse_attr object:
- lo_create(), though fuse_reply_create(): Calls lo_do_lookup().
- lo_lookup(), though fuse_reply_entry(): Calls lo_do_lookup().
- lo_mknod_symlink(), through fuse_reply_entry(): Calls lo_do_lookup().
- lo_link(), through fuse_reply_entry(): Creating a link cannot create a
  submount, so there is no need to check for it.
- lo_getattr(), through fuse_reply_attr(): Announcing submounts when the
  node is first detected (at lookup) is sufficient.  We do not need to
  return the submount attribute later.
- lo_do_readdir(), through fuse_add_direntry_plus(): Calls
  lo_do_lookup().

Make announcing submounts optional, so submounts are only announced to
the guest with the announce_submounts option.  Some users may prefer the
current behavior, so that the guest learns nothing about the host mount
structure.

(announce_submounts is force-disabled when the guest does not present
the FUSE_SUBMOUNTS capability, or when there is no statx().)

Signed-off-by: Max Reitz <mreitz@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/helper.c         |  1 +
 tools/virtiofsd/passthrough_ll.c | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
index 2e181a49b5..4433724d3a 100644
--- a/tools/virtiofsd/helper.c
+++ b/tools/virtiofsd/helper.c
@@ -190,6 +190,7 @@ void fuse_cmdline_help(void)
            "                               retain/discard O_DIRECT flags passed down\n"
            "                               to virtiofsd from guest applications.\n"
            "                               default: no_allow_direct_io\n"
+           "    -o announce_submounts      Announce sub-mount points to the guest\n"
            );
 }
 
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 34d107975f..ec1008bceb 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -40,6 +40,7 @@
 #include "fuse_virtio.h"
 #include "fuse_log.h"
 #include "fuse_lowlevel.h"
+#include "standard-headers/linux/fuse.h"
 #include <assert.h>
 #include <cap-ng.h>
 #include <dirent.h>
@@ -167,6 +168,7 @@ struct lo_data {
     int readdirplus_set;
     int readdirplus_clear;
     int allow_direct_io;
+    int announce_submounts;
     bool use_statx;
     struct lo_inode root;
     GHashTable *inodes; /* protected by lo->mutex */
@@ -207,6 +209,7 @@ static const struct fuse_opt lo_opts[] = {
     { "no_readdirplus", offsetof(struct lo_data, readdirplus_clear), 1 },
     { "allow_direct_io", offsetof(struct lo_data, allow_direct_io), 1 },
     { "no_allow_direct_io", offsetof(struct lo_data, allow_direct_io), 0 },
+    { "announce_submounts", offsetof(struct lo_data, announce_submounts), 1 },
     FUSE_OPT_END
 };
 static bool use_syslog = false;
@@ -601,6 +604,20 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
         fuse_log(FUSE_LOG_DEBUG, "lo_init: disabling readdirplus\n");
         conn->want &= ~FUSE_CAP_READDIRPLUS;
     }
+
+    if (!(conn->capable & FUSE_CAP_SUBMOUNTS) && lo->announce_submounts) {
+        fuse_log(FUSE_LOG_WARNING, "lo_init: Cannot announce submounts, client "
+                 "does not support it\n");
+        lo->announce_submounts = false;
+    }
+
+#ifndef CONFIG_STATX
+    if (lo->announce_submounts) {
+        fuse_log(FUSE_LOG_WARNING, "lo_init: Cannot announce submounts, there "
+                 "is no statx()\n");
+        lo->announce_submounts = false;
+    }
+#endif
 }
 
 static void lo_getattr(fuse_req_t req, fuse_ino_t ino,
@@ -877,6 +894,11 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         goto out_err;
     }
 
+    if (S_ISDIR(e->attr.st_mode) && lo->announce_submounts &&
+        (e->attr.st_dev != dir->key.dev || mnt_id != dir->key.mnt_id)) {
+        e->attr_flags |= FUSE_ATTR_SUBMOUNT;
+    }
+
     inode = lo_find(lo, &e->attr, mnt_id);
     if (inode) {
         close(newfd);
-- 
2.26.2

