From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon, 24 Jan 2022 16:24:51 -0500
Message-Id: <20220124212455.83968-6-vgoyal@redhat.com>
In-Reply-To: <20220124212455.83968-1-vgoyal@redhat.com>
References: <20220124212455.83968-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 5/9] virtiofsd,
	fuse_lowlevel.c: Add capability to parse security context
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com

Add capability to enable and parse security context as sent by client
and put into fuse_req. Filesystems now can get security context from
request and set it on files during creation.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_common.h   |  5 ++
 tools/virtiofsd/fuse_i.h        |  7 +++
 tools/virtiofsd/fuse_lowlevel.c | 95 ++++++++++++++++++++++++++++++++-
 3 files changed, 106 insertions(+), 1 deletion(-)

diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
index 6f8a988202..bf46954dab 100644
--- a/tools/virtiofsd/fuse_common.h
+++ b/tools/virtiofsd/fuse_common.h
@@ -377,6 +377,11 @@ struct fuse_file_info {
  */
 #define FUSE_CAP_SETXATTR_EXT (1 << 29)
 
+/**
+ * Indicates that file server supports creating file security context
+ */
+#define FUSE_CAP_SECURITY_CTX (1ULL << 32)
+
 /**
  * Ioctl flags
  *
diff --git a/tools/virtiofsd/fuse_i.h b/tools/virtiofsd/fuse_i.h
index 492e002181..a5572fa4ae 100644
--- a/tools/virtiofsd/fuse_i.h
+++ b/tools/virtiofsd/fuse_i.h
@@ -15,6 +15,12 @@
 struct fv_VuDev;
 struct fv_QueueInfo;
 
+struct fuse_security_context {
+        const char *name;
+        uint32_t ctxlen;
+        const void *ctx;
+};
+
 struct fuse_req {
     struct fuse_session *se;
     uint64_t unique;
@@ -35,6 +41,7 @@ struct fuse_req {
     } u;
     struct fuse_req *next;
     struct fuse_req *prev;
+    struct fuse_security_context secctx;
 };
 
 struct fuse_notify_req {
diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index f3f5e70be6..0bb6f7f316 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -886,11 +886,59 @@ static void do_readlink(fuse_req_t req, fuse_ino_t nodeid,
     }
 }
 
+static int parse_secctx_fill_req(fuse_req_t req, struct fuse_mbuf_iter *iter)
+{
+    struct fuse_secctx_header *fsecctx_header;
+    struct fuse_secctx *fsecctx;
+    const void *secctx;
+    const char *name;
+
+    fsecctx_header = fuse_mbuf_iter_advance(iter, sizeof(*fsecctx_header));
+    if (!fsecctx_header) {
+        return -EINVAL;
+    }
+
+    /*
+     * As of now maximum of one security context is supported. It can
+     * change in future though.
+     */
+    if (fsecctx_header->nr_secctx > 1) {
+        return -EINVAL;
+    }
+
+    /* No security context sent. Maybe no LSM supports it */
+    if (!fsecctx_header->nr_secctx) {
+        return 0;
+    }
+
+    fsecctx = fuse_mbuf_iter_advance(iter, sizeof(*fsecctx));
+    if (!fsecctx) {
+        return -EINVAL;
+    }
+
+    name = fuse_mbuf_iter_advance_str(iter);
+    if (!name) {
+        return -EINVAL;
+    }
+
+    secctx = fuse_mbuf_iter_advance(iter, fsecctx->size);
+    if (!secctx) {
+        return -EINVAL;
+    }
+
+    req->secctx.name = name;
+    req->secctx.ctx = secctx;
+    req->secctx.ctxlen = fsecctx->size;
+    return 0;
+}
+
 static void do_mknod(fuse_req_t req, fuse_ino_t nodeid,
                      struct fuse_mbuf_iter *iter)
 {
     struct fuse_mknod_in *arg;
     const char *name;
+    bool secctx_enabled = req->se->conn.want & FUSE_CAP_SECURITY_CTX;
+    int err;
 
     arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
     name = fuse_mbuf_iter_advance_str(iter);
@@ -901,6 +949,13 @@ static void do_mknod(fuse_req_t req, fuse_ino_t nodeid,
 
     req->ctx.umask = arg->umask;
 
+    if (secctx_enabled) {
+        err = parse_secctx_fill_req(req, iter);
+        if (err) {
+            fuse_reply_err(req, -err);
+        }
+    }
+
     if (req->se->op.mknod) {
         req->se->op.mknod(req, nodeid, name, arg->mode, arg->rdev);
     } else {
@@ -913,6 +968,8 @@ static void do_mkdir(fuse_req_t req, fuse_ino_t nodeid,
 {
     struct fuse_mkdir_in *arg;
     const char *name;
+    bool secctx_enabled = req->se->conn.want & FUSE_CAP_SECURITY_CTX;
+    int err;
 
     arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
     name = fuse_mbuf_iter_advance_str(iter);
@@ -923,6 +980,13 @@ static void do_mkdir(fuse_req_t req, fuse_ino_t nodeid,
 
     req->ctx.umask = arg->umask;
 
+    if (secctx_enabled) {
+        err = parse_secctx_fill_req(req, iter);
+        if (err) {
+            fuse_reply_err(req, err);
+        }
+    }
+
     if (req->se->op.mkdir) {
         req->se->op.mkdir(req, nodeid, name, arg->mode);
     } else {
@@ -969,12 +1033,21 @@ static void do_symlink(fuse_req_t req, fuse_ino_t nodeid,
 {
     const char *name = fuse_mbuf_iter_advance_str(iter);
     const char *linkname = fuse_mbuf_iter_advance_str(iter);
+    bool secctx_enabled = req->se->conn.want & FUSE_CAP_SECURITY_CTX;
+    int err;
 
     if (!name || !linkname) {
         fuse_reply_err(req, EINVAL);
         return;
     }
 
+    if (secctx_enabled) {
+        err = parse_secctx_fill_req(req, iter);
+        if (err) {
+            fuse_reply_err(req, err);
+        }
+    }
+
     if (req->se->op.symlink) {
         req->se->op.symlink(req, linkname, nodeid, name);
     } else {
@@ -1048,6 +1121,8 @@ static void do_link(fuse_req_t req, fuse_ino_t nodeid,
 static void do_create(fuse_req_t req, fuse_ino_t nodeid,
                       struct fuse_mbuf_iter *iter)
 {
+    bool secctx_enabled = req->se->conn.want & FUSE_CAP_SECURITY_CTX;
+
     if (req->se->op.create) {
         struct fuse_create_in *arg;
         struct fuse_file_info fi;
@@ -1060,6 +1135,15 @@ static void do_create(fuse_req_t req, fuse_ino_t nodeid,
             return;
         }
 
+        if (secctx_enabled) {
+            int err;
+            err = parse_secctx_fill_req(req, iter);
+            if (err) {
+                fuse_reply_err(req, err);
+                return;
+            }
+        }
+
         memset(&fi, 0, sizeof(fi));
         fi.flags = arg->flags;
         fi.kill_priv = arg->open_flags & FUSE_OPEN_KILL_SUIDGID;
@@ -2009,6 +2093,9 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     if (flags & FUSE_SETXATTR_EXT) {
         se->conn.capable |= FUSE_CAP_SETXATTR_EXT;
     }
+    if (flags & FUSE_SECURITY_CTX) {
+        se->conn.capable |= FUSE_CAP_SECURITY_CTX;
+    }
 #ifdef HAVE_SPLICE
 #ifdef HAVE_VMSPLICE
     se->conn.capable |= FUSE_CAP_SPLICE_WRITE | FUSE_CAP_SPLICE_MOVE;
@@ -2148,8 +2235,14 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
         outarg.flags |= FUSE_SETXATTR_EXT;
     }
 
+    if (se->conn.want & FUSE_CAP_SECURITY_CTX) {
+        /* bits 32..63 get shifted down 32 bits into the flags2 field */
+        outarg.flags2 |= FUSE_SECURITY_CTX >> 32;
+    }
+
     fuse_log(FUSE_LOG_DEBUG, "   INIT: %u.%u\n", outarg.major, outarg.minor);
-    fuse_log(FUSE_LOG_DEBUG, "   flags=0x%08x\n", outarg.flags);
+    fuse_log(FUSE_LOG_DEBUG, "   flags2=0x%08x flags=0x%08x\n", outarg.flags2,
+             outarg.flags);
     fuse_log(FUSE_LOG_DEBUG, "   max_readahead=0x%08x\n", outarg.max_readahead);
     fuse_log(FUSE_LOG_DEBUG, "   max_write=0x%08x\n", outarg.max_write);
     fuse_log(FUSE_LOG_DEBUG, "   max_background=%i\n", outarg.max_background);
-- 
2.31.1

