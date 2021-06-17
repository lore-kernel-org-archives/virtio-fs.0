From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 17 Jun 2021 14:12:09 -0400
Message-Id: <20210617181213.1177835-5-vgoyal@redhat.com>
In-Reply-To: <20210617181213.1177835-1-vgoyal@redhat.com>
References: <20210617181213.1177835-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v6 4/8] virtiofsd: Add support for extended
	setxattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, vgoyal@redhat.com, miklos@szeredi.hu

Add the bits to enable support for setxattr_ext if fuse offers it. Do not
enable it by default yet. Let passthrough_ll opt-in. Enabling it by deafult
kind of automatically means that you are taking responsibility of clearing
SGID if ACL is set.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_common.h    |  5 +++++
 tools/virtiofsd/fuse_lowlevel.c  | 11 ++++++++++-
 tools/virtiofsd/fuse_lowlevel.h  |  3 ++-
 tools/virtiofsd/passthrough_ll.c |  3 ++-
 4 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
index 0c2665b977..8abac80098 100644
--- a/tools/virtiofsd/fuse_common.h
+++ b/tools/virtiofsd/fuse_common.h
@@ -377,6 +377,11 @@ struct fuse_file_info {
  */
 #define FUSE_CAP_SETXATTR_EXT (1 << 29)
 
+/**
+ * Indicates that file server supports extended struct fuse_setxattr_in
+ */
+#define FUSE_CAP_SETXATTR_EXT (1 << 29)
+
 /**
  * Ioctl flags
  *
diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 156f1494f5..0eec3b70ec 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -1439,7 +1439,9 @@ static void do_setxattr(fuse_req_t req, fuse_ino_t nodeid,
     }
 
     if (req->se->op.setxattr) {
-        req->se->op.setxattr(req, nodeid, name, value, arg->size, arg->flags);
+        uint32_t setxattr_flags = setxattr_ext ? arg->setxattr_flags : 0;
+        req->se->op.setxattr(req, nodeid, name, value, arg->size, arg->flags,
+                             setxattr_flags);
     } else {
         fuse_reply_err(req, ENOSYS);
     }
@@ -1986,6 +1988,9 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     if (arg->flags & FUSE_HANDLE_KILLPRIV_V2) {
         se->conn.capable |= FUSE_CAP_HANDLE_KILLPRIV_V2;
     }
+    if (arg->flags & FUSE_SETXATTR_EXT) {
+        se->conn.capable |= FUSE_CAP_SETXATTR_EXT;
+    }
 #ifdef HAVE_SPLICE
 #ifdef HAVE_VMSPLICE
     se->conn.capable |= FUSE_CAP_SPLICE_WRITE | FUSE_CAP_SPLICE_MOVE;
@@ -2121,6 +2126,10 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
         outarg.flags |= FUSE_HANDLE_KILLPRIV_V2;
     }
 
+    if (se->conn.want & FUSE_CAP_SETXATTR_EXT) {
+        outarg.flags |= FUSE_SETXATTR_EXT;
+    }
+
     fuse_log(FUSE_LOG_DEBUG, "   INIT: %u.%u\n", outarg.major, outarg.minor);
     fuse_log(FUSE_LOG_DEBUG, "   flags=0x%08x\n", outarg.flags);
     fuse_log(FUSE_LOG_DEBUG, "   max_readahead=0x%08x\n", outarg.max_readahead);
diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index 3bf786b034..4b4e8c9724 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -798,7 +798,8 @@ struct fuse_lowlevel_ops {
      *   fuse_reply_err
      */
     void (*setxattr)(fuse_req_t req, fuse_ino_t ino, const char *name,
-                     const char *value, size_t size, int flags);
+                     const char *value, size_t size, int flags,
+                     uint32_t setxattr_flags);
 
     /**
      * Get an extended attribute
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index ec91b3c133..9f5cd98fb5 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2955,7 +2955,8 @@ out:
 }
 
 static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
-                        const char *value, size_t size, int flags)
+                        const char *value, size_t size, int flags,
+                        uint32_t extra_flags)
 {
     char procname[64];
     const char *name;
-- 
2.25.4

