From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 14 Apr 2021 16:51:34 +0100
Message-Id: <20210414155137.46522-23-dgilbert@redhat.com>
In-Reply-To: <20210414155137.46522-1-dgilbert@redhat.com>
References: <20210414155137.46522-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 22/25] DAX:virtiofsd: implement FUSE_INIT
	map_alignment field
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, virtio-fs@redhat.com

From: Stefan Hajnoczi <stefanha@redhat.com>

Communicate the host page size to the FUSE client so that
FUSE_SETUPMAPPING/FUSE_REMOVEMAPPING requests are aware of our alignment
constraints.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index e82edce72a..08999a6bc5 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -10,6 +10,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/host-utils.h"
 #include "fuse_i.h"
 #include "standard-headers/linux/fuse.h"
 #include "fuse_misc.h"
@@ -2194,6 +2195,12 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     outarg.max_background = se->conn.max_background;
     outarg.congestion_threshold = se->conn.congestion_threshold;
     outarg.time_gran = se->conn.time_gran;
+    if (arg->flags & FUSE_MAP_ALIGNMENT) {
+        outarg.flags |= FUSE_MAP_ALIGNMENT;
+
+        /* This constraint comes from mmap(2) and munmap(2) */
+        outarg.map_alignment = ctz64(sysconf(_SC_PAGE_SIZE));
+    }
 
     if (se->conn.want & FUSE_CAP_HANDLE_KILLPRIV_V2) {
         outarg.flags |= FUSE_HANDLE_KILLPRIV_V2;
@@ -2207,6 +2214,7 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     fuse_log(FUSE_LOG_DEBUG, "   congestion_threshold=%i\n",
              outarg.congestion_threshold);
     fuse_log(FUSE_LOG_DEBUG, "   time_gran=%u\n", outarg.time_gran);
+    fuse_log(FUSE_LOG_DEBUG, "   map_alignment=%u\n", outarg.map_alignment);
 
     send_reply_ok(req, &outarg, outargsize);
 }
-- 
2.31.1

