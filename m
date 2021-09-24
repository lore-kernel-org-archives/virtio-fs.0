From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 24 Sep 2021 15:48:51 -0400
Message-Id: <20210924194854.919414-3-vgoyal@redhat.com>
In-Reply-To: <20210924194854.919414-1-vgoyal@redhat.com>
References: <20210924194854.919414-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/5] fuse_lowlevel.c: Add capability to parse
	security context
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: miklos@szeredi.hu, stephen.smalley.work@gmail.com, vgoyal@redhat.com

Add capability to enable and parse security context as sent by client
and put into fuse_req. Filesystems now can get security context from
request and set it on files during creation.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_common.h   |  5 +++
 tools/virtiofsd/fuse_i.h        |  7 ++++
 tools/virtiofsd/fuse_lowlevel.c | 74 +++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+)

diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
index 0c2665b977..6f3485d1dc 100644
--- a/tools/virtiofsd/fuse_common.h
+++ b/tools/virtiofsd/fuse_common.h
@@ -377,6 +377,11 @@ struct fuse_file_info {
  */
 #define FUSE_CAP_SETXATTR_EXT (1 << 29)
 
+/**
+ * Indicates that file server supports creating file security context
+ */
+#define FUSE_CAP_SECURITY_CTX (1 << 30)
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
index e4679c73ab..fae92e0f3f 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -886,11 +886,41 @@ static void do_readlink(fuse_req_t req, fuse_ino_t nodeid,
     }
 }
 
+static int parse_secctx_fill_req(fuse_req_t req, struct fuse_mbuf_iter *iter)
+{
+    struct fuse_secctx *fsecctx;
+    const void *secctx;
+
+    fsecctx = fuse_mbuf_iter_advance(iter, sizeof(*fsecctx));
+    if (!fsecctx) {
+        return -EINVAL;
+    }
+
+    if (fsecctx->size) {
+        const char *name = fuse_mbuf_iter_advance_str(iter);
+        if (!name) {
+            return -EINVAL;
+        }
+
+        secctx = fuse_mbuf_iter_advance(iter, fsecctx->size);
+        if (!secctx) {
+            return -EINVAL;
+        }
+
+        req->secctx.name = name;
+        req->secctx.ctx = secctx;
+        req->secctx.ctxlen = fsecctx->size;
+    }
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
@@ -901,6 +931,13 @@ static void do_mknod(fuse_req_t req, fuse_ino_t nodeid,
 
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
@@ -913,6 +950,8 @@ static void do_mkdir(fuse_req_t req, fuse_ino_t nodeid,
 {
     struct fuse_mkdir_in *arg;
     const char *name;
+    bool secctx_enabled = req->se->conn.want & FUSE_CAP_SECURITY_CTX;
+    int err;
 
     arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
     name = fuse_mbuf_iter_advance_str(iter);
@@ -923,6 +962,13 @@ static void do_mkdir(fuse_req_t req, fuse_ino_t nodeid,
 
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
@@ -969,12 +1015,21 @@ static void do_symlink(fuse_req_t req, fuse_ino_t nodeid,
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
@@ -1048,6 +1103,8 @@ static void do_link(fuse_req_t req, fuse_ino_t nodeid,
 static void do_create(fuse_req_t req, fuse_ino_t nodeid,
                       struct fuse_mbuf_iter *iter)
 {
+    bool secctx_enabled = req->se->conn.want & FUSE_CAP_SECURITY_CTX;
+
     if (req->se->op.create) {
         struct fuse_create_in *arg;
         struct fuse_file_info fi;
@@ -1060,6 +1117,15 @@ static void do_create(fuse_req_t req, fuse_ino_t nodeid,
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
@@ -1997,6 +2063,9 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     if (arg->flags & FUSE_SETXATTR_EXT) {
         se->conn.capable |= FUSE_CAP_SETXATTR_EXT;
     }
+    if (arg->flags & FUSE_SECURITY_CTX) {
+        se->conn.capable |= FUSE_CAP_SECURITY_CTX;
+    }
 #ifdef HAVE_SPLICE
 #ifdef HAVE_VMSPLICE
     se->conn.capable |= FUSE_CAP_SPLICE_WRITE | FUSE_CAP_SPLICE_MOVE;
@@ -2029,6 +2098,7 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     LL_SET_DEFAULT(se->op.readdirplus, FUSE_CAP_READDIRPLUS);
     LL_SET_DEFAULT(se->op.readdirplus && se->op.readdir,
                    FUSE_CAP_READDIRPLUS_AUTO);
+    LL_SET_DEFAULT(1, FUSE_CAP_SECURITY_CTX);
     se->conn.time_gran = 1;
 
     if (bufsize < FUSE_MIN_READ_BUFFER) {
@@ -2136,6 +2206,10 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
         outarg.flags |= FUSE_SETXATTR_EXT;
     }
 
+    if (se->conn.want & FUSE_CAP_SECURITY_CTX) {
+        outarg.flags |= FUSE_SECURITY_CTX;
+    }
+
     fuse_log(FUSE_LOG_DEBUG, "   INIT: %u.%u\n", outarg.major, outarg.minor);
     fuse_log(FUSE_LOG_DEBUG, "   flags=0x%08x\n", outarg.flags);
     fuse_log(FUSE_LOG_DEBUG, "   max_readahead=0x%08x\n", outarg.max_readahead);
-- 
2.31.1

