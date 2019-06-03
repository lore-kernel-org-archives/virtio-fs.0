From: Peng Tao <tao.peng@linux.alibaba.com>
Date: Mon,  3 Jun 2019 10:47:19 +0800
Message-Id: <20190603024719.47457-1-tao.peng@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH-v3] virtiofsd: make FUSE_REMOVEMAPPING support
	multiple entries
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Peng Tao <tao.peng@linux.alibaba.com>

The fuse wire protocol is changed so that we can unmap multiple
mappings in a single call.

Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
---
v2-v3: make fuse_removemapping_in count fuse_removemapping_one

This works with corresponding kernel side virtio-fs patch:
"[PATCH-v2] virtiofs: FUSE_REMOVEMAPPING remove multiple entries in one call"

 contrib/virtiofsd/fuse_kernel.h    |  9 +++++++--
 contrib/virtiofsd/fuse_lowlevel.c  | 15 ++++++++++++---
 contrib/virtiofsd/fuse_lowlevel.h  |  5 +++--
 contrib/virtiofsd/passthrough_ll.c | 31 ++++++++++++++++++++----------
 4 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/contrib/virtiofsd/fuse_kernel.h b/contrib/virtiofsd/fuse_kernel.h
index ce46046a4f..04ad461b73 100644
--- a/contrib/virtiofsd/fuse_kernel.h
+++ b/contrib/virtiofsd/fuse_kernel.h
@@ -830,9 +830,14 @@ struct fuse_setupmapping_out {
         uint64_t        len[FUSE_SETUPMAPPING_ENTRIES];
 };
 
-struct fuse_removemapping_in {
+struct fuse_removemapping_in{
         /* An already open handle */
-	uint64_t	fh;
+        uint64_t        fh;
+        /* number of fuse_removemapping_one follows */
+        uint32_t        count;
+};
+
+struct fuse_removemapping_one {
         /* Offset into the dax to start the unmapping */
         uint64_t        moffset;
         /* Length of mapping required */
diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
index 0fc2880acd..9856eaba29 100644
--- a/contrib/virtiofsd/fuse_lowlevel.c
+++ b/contrib/virtiofsd/fuse_lowlevel.c
@@ -1908,10 +1908,20 @@ static void do_removemapping(fuse_req_t req, fuse_ino_t nodeid,
 			     struct fuse_mbuf_iter *iter)
 {
 	struct fuse_removemapping_in *arg;
+	struct fuse_removemapping_one *one;
         struct fuse_file_info fi;
 
 	arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
-	if (!arg) {
+	if (!arg || arg->count <= 0) {
+		fprintf(stderr, "do_removemapping: invalid arg %p\n", arg);
+		fuse_reply_err(req, EINVAL);
+		return;
+	}
+
+	one = fuse_mbuf_iter_advance(iter, arg->count * sizeof(*one));
+	if (!one) {
+		fprintf(stderr, "do_removemapping: invalid in, expected %d * %ld, has %ld - %ld\n",
+				arg->count, sizeof(*one), iter->size, iter->pos);
 		fuse_reply_err(req, EINVAL);
 		return;
 	}
@@ -1920,8 +1930,7 @@ static void do_removemapping(fuse_req_t req, fuse_ino_t nodeid,
 	fi.fh = arg->fh;
 
 	if (req->se->op.removemapping)
-		req->se->op.removemapping(req, req->se, nodeid, arg->moffset,
-                                          arg->len, &fi);
+		req->se->op.removemapping(req, req->se, nodeid, arg->count, one, &fi);
 	else
 		fuse_reply_err(req, ENOSYS);
 }
diff --git a/contrib/virtiofsd/fuse_lowlevel.h b/contrib/virtiofsd/fuse_lowlevel.h
index 1b03e46dfd..e47e58062b 100644
--- a/contrib/virtiofsd/fuse_lowlevel.h
+++ b/contrib/virtiofsd/fuse_lowlevel.h
@@ -23,6 +23,7 @@
 #endif
 
 #include "fuse_common.h"
+#include "fuse_kernel.h"
 
 #include <utime.h>
 #include <fcntl.h>
@@ -1197,8 +1198,8 @@ struct fuse_lowlevel_ops {
          * TODO
          */
         void (*removemapping) (fuse_req_t req, struct fuse_session *se,
-                               fuse_ino_t ino, uint64_t moffset,
-                               uint64_t len, struct fuse_file_info *fi);
+                               fuse_ino_t ino, unsigned num,
+                               struct fuse_removemapping_one *argp, struct fuse_file_info *fi);
 };
 
 /**
diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 662bee5b94..8a3adc9414 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -1908,20 +1908,31 @@ static void lo_setupmapping(fuse_req_t req, fuse_ino_t ino, uint64_t foffset,
 }
 
 static void lo_removemapping(fuse_req_t req, struct fuse_session *se,
-                             fuse_ino_t ino, uint64_t moffset,
-                             uint64_t len, struct fuse_file_info *fi)
+                             fuse_ino_t ino, unsigned num,
+                             struct fuse_removemapping_one *argp,
+                             struct fuse_file_info *fi)
 {
         VhostUserFSSlaveMsg msg = { 0 };
 	int ret = 0;
 
-	msg.len[0] = len;
-	msg.c_offset[0] = moffset;
-        if (fuse_virtio_unmap(se, &msg)) {
-                fprintf(stderr,
-                        "%s: unmap over virtio failed "
-                        "(offset=0x%lx, len=0x%lx)\n", __func__, moffset, len);
-                ret = EINVAL;
-        }
+	for (int i = 0; num > 0; i++, argp++) {
+		msg.len[i] = argp->len;
+		msg.c_offset[i] = argp->moffset;
+
+		if (--num == 0 || i == VHOST_USER_FS_SLAVE_ENTRIES - 1) {
+			if (fuse_virtio_unmap(se, &msg)) {
+				fprintf(stderr,
+					"%s: unmap over virtio failed "
+					"(offset=0x%lx, len=0x%lx)\n", __func__, argp->moffset, argp->len);
+				ret = EINVAL;
+				break;
+			}
+			if (num > 0) {
+				i = 0;
+				memset(&msg, 0, sizeof(msg));
+			}
+		}
+	}
 
 	fuse_reply_err(req, ret);
 }
-- 
2.17.1

