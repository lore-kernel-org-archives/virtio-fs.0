From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 28 Apr 2021 12:00:46 +0100
Message-Id: <20210428110100.27757-13-dgilbert@redhat.com>
In-Reply-To: <20210428110100.27757-1-dgilbert@redhat.com>
References: <20210428110100.27757-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 12/26] DAX: virtiofsd: Add setup/remove
	mappings fuse commands
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, groug@kaod.org
Cc: virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Add commands so that the guest kernel can ask the daemon to map file
sections into a guest kernel visible cache.

Note: Catherine Ho had sent a patch to fix an issue with multiple
removemapping. It was a merge issue though.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
Including-fixes: Catherine Ho <catherine.hecx@gmail.com>
Signed-off-by: Catherine Ho <catherine.hecx@gmail.com>
---
 tools/virtiofsd/fuse_lowlevel.c | 69 +++++++++++++++++++++++++++++++++
 tools/virtiofsd/fuse_lowlevel.h | 23 ++++++++++-
 2 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 58e32fc963..a1a8730b73 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -1870,6 +1870,73 @@ static void do_lseek(fuse_req_t req, fuse_ino_t nodeid,
     }
 }
 
+static void do_setupmapping(fuse_req_t req, fuse_ino_t nodeid,
+                            struct fuse_mbuf_iter *iter)
+{
+    struct fuse_setupmapping_in *arg;
+    struct fuse_file_info fi;
+
+    arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
+    if (!arg) {
+        fuse_reply_err(req, EINVAL);
+        return;
+    }
+
+    memset(&fi, 0, sizeof(fi));
+    fi.fh = arg->fh;
+
+    /*
+     *  TODO: Need to come up with a better definition of flags here; it can't
+     * be the kernel view of the flags, since that's abstracted from the client
+     * similarly, it's not the vhost-user set
+     * for now just use O_ flags
+     */
+    uint64_t genflags;
+
+    genflags = O_RDONLY;
+    if (arg->flags & FUSE_SETUPMAPPING_FLAG_WRITE) {
+        genflags = O_RDWR;
+    }
+
+    if (req->se->op.setupmapping) {
+        req->se->op.setupmapping(req, nodeid, arg->foffset, arg->len,
+                                 arg->moffset, genflags, &fi);
+    } else {
+        fuse_reply_err(req, ENOSYS);
+    }
+}
+
+static void do_removemapping(fuse_req_t req, fuse_ino_t nodeid,
+                             struct fuse_mbuf_iter *iter)
+{
+    struct fuse_removemapping_in *arg;
+    struct fuse_removemapping_one *one;
+
+    arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
+    if (!arg || !arg->count ||
+        (uint64_t)arg->count * sizeof(*one) >= SIZE_MAX) {
+        fuse_log(FUSE_LOG_ERR, "do_removemapping: invalid arg %p\n", arg);
+        fuse_reply_err(req, EINVAL);
+        return;
+    }
+
+    one = fuse_mbuf_iter_advance(iter, arg->count * sizeof(*one));
+    if (!one) {
+        fuse_log(
+            FUSE_LOG_ERR,
+            "do_removemapping: invalid in, expected %d * %zd, has %zd - %zd\n",
+            arg->count, sizeof(*one), iter->size, iter->pos);
+        fuse_reply_err(req, EINVAL);
+        return;
+    }
+
+    if (req->se->op.removemapping) {
+        req->se->op.removemapping(req, req->se, nodeid, arg->count, one);
+    } else {
+        fuse_reply_err(req, ENOSYS);
+    }
+}
+
 static void do_init(fuse_req_t req, fuse_ino_t nodeid,
                     struct fuse_mbuf_iter *iter)
 {
@@ -2267,6 +2334,8 @@ static struct {
     [FUSE_RENAME2] = { do_rename2, "RENAME2" },
     [FUSE_COPY_FILE_RANGE] = { do_copy_file_range, "COPY_FILE_RANGE" },
     [FUSE_LSEEK] = { do_lseek, "LSEEK" },
+    [FUSE_SETUPMAPPING] = { do_setupmapping, "SETUPMAPPING" },
+    [FUSE_REMOVEMAPPING] = { do_removemapping, "REMOVEMAPPING" },
 };
 
 #define FUSE_MAXOP (sizeof(fuse_ll_ops) / sizeof(fuse_ll_ops[0]))
diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index 3383e3a8a0..0bf206264d 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -24,6 +24,7 @@
 #endif
 
 #include "fuse_common.h"
+#include "standard-headers/linux/fuse.h"
 
 #include <sys/statvfs.h>
 #include <sys/uio.h>
@@ -1171,7 +1172,6 @@ struct fuse_lowlevel_ops {
      */
     void (*readdirplus)(fuse_req_t req, fuse_ino_t ino, size_t size, off_t off,
                         struct fuse_file_info *fi);
-
     /**
      * Copy a range of data from one file to another
      *
@@ -1227,6 +1227,27 @@ struct fuse_lowlevel_ops {
      */
     void (*lseek)(fuse_req_t req, fuse_ino_t ino, off_t off, int whence,
                   struct fuse_file_info *fi);
+
+    /*
+     * Map file sections into kernel visible cache
+     *
+     * Map a section of the file into address space visible to the kernel
+     * mounting the filesystem.
+     * TODO
+     */
+    void (*setupmapping)(fuse_req_t req, fuse_ino_t ino, uint64_t foffset,
+                         uint64_t len, uint64_t moffset, uint64_t flags,
+                         struct fuse_file_info *fi);
+
+    /*
+     * Unmap file sections in kernel visible cache
+     *
+     * Unmap sections previously mapped by setupmapping
+     * TODO
+     */
+    void (*removemapping)(fuse_req_t req, struct fuse_session *se,
+                          fuse_ino_t ino, unsigned num,
+                          struct fuse_removemapping_one *argp);
 };
 
 /**
-- 
2.31.1

