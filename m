From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 25 Mar 2021 11:38:51 -0400
Message-Id: <20210325153852.572927-5-vgoyal@redhat.com>
In-Reply-To: <20210325153852.572927-1-vgoyal@redhat.com>
References: <20210325153852.572927-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v5 4/5] virtiofsd: Add support for setxattr_v2
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com, miklos@szeredi.hu

Add the bits to enable support for setxattr_v2 if fuse offers it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/standard-headers/linux/fuse.h | 12 +++++++-
 tools/virtiofsd/fuse_common.h         |  6 ++++
 tools/virtiofsd/fuse_lowlevel.c       | 42 ++++++++++++++++++++++++++-
 tools/virtiofsd/fuse_lowlevel.h       |  3 +-
 tools/virtiofsd/passthrough_ll.c      |  3 +-
 5 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/include/standard-headers/linux/fuse.h b/include/standard-headers/linux/fuse.h
index 950d7edb7e..cc87ff27d0 100644
--- a/include/standard-headers/linux/fuse.h
+++ b/include/standard-headers/linux/fuse.h
@@ -179,6 +179,7 @@
  *  7.33
  *  - add FUSE_HANDLE_KILLPRIV_V2, FUSE_WRITE_KILL_SUIDGID, FATTR_KILL_SUIDGID
  *  - add FUSE_OPEN_KILL_SUIDGID
+ *  - add FUSE_SETXATTR_V2
  */
 
 #ifndef _LINUX_FUSE_H
@@ -210,7 +211,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 33
+#define FUSE_KERNEL_MINOR_VERSION 34
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -326,6 +327,7 @@ struct fuse_file_lock {
  *			does not have CAP_FSETID. Additionally upon
  *			write/truncate sgid is killed only if file has group
  *			execute permission. (Same as Linux VFS behavior).
+ * FUSE_SETXATTR_V2:	Does file server support V2 of struct fuse_setxattr_in
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -356,6 +358,7 @@ struct fuse_file_lock {
 #define FUSE_MAP_ALIGNMENT	(1 << 26)
 #define FUSE_SUBMOUNTS		(1 << 27)
 #define FUSE_HANDLE_KILLPRIV_V2	(1 << 28)
+#define FUSE_SETXATTR_V2	(1 << 29)
 
 /**
  * CUSE INIT request/reply flags
@@ -682,6 +685,13 @@ struct fuse_setxattr_in {
 	uint32_t	flags;
 };
 
+struct fuse_setxattr_in_v2 {
+	uint32_t	size;
+	uint32_t	flags;
+	uint32_t	setxattr_flags;
+	uint32_t	padding;
+};
+
 struct fuse_getxattr_in {
 	uint32_t	size;
 	uint32_t	padding;
diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
index fa9671872e..84e78c2a56 100644
--- a/tools/virtiofsd/fuse_common.h
+++ b/tools/virtiofsd/fuse_common.h
@@ -372,6 +372,12 @@ struct fuse_file_info {
  */
 #define FUSE_CAP_HANDLE_KILLPRIV_V2 (1 << 28)
 
+/**
+ * Indicates that file server will expect "struct fuse_setxattr_in_v2" type
+ * of struct in setxattr requests
+ */
+#define FUSE_CAP_SETXATTR_V2 (1 << 29)
+
 /**
  * Ioctl flags
  *
diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 1aa26c6333..3dcf8a5f8b 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -1420,6 +1420,34 @@ static void do_statfs(fuse_req_t req, fuse_ino_t nodeid,
     }
 }
 
+static void do_setxattr_v2(fuse_req_t req, fuse_ino_t nodeid,
+                           struct fuse_mbuf_iter *iter)
+{
+    struct fuse_setxattr_in_v2 *arg;
+    const char *name;
+    const char *value;
+
+    arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
+    name = fuse_mbuf_iter_advance_str(iter);
+    if (!arg || !name) {
+        fuse_reply_err(req, EINVAL);
+        return;
+    }
+
+    value = fuse_mbuf_iter_advance(iter, arg->size);
+    if (!value) {
+        fuse_reply_err(req, EINVAL);
+        return;
+    }
+
+    if (req->se->op.setxattr) {
+        req->se->op.setxattr(req, nodeid, name, value, arg->size, arg->flags,
+                             arg->setxattr_flags);
+    } else {
+        fuse_reply_err(req, ENOSYS);
+    }
+}
+
 static void do_setxattr(fuse_req_t req, fuse_ino_t nodeid,
                         struct fuse_mbuf_iter *iter)
 {
@@ -1427,6 +1455,9 @@ static void do_setxattr(fuse_req_t req, fuse_ino_t nodeid,
     const char *name;
     const char *value;
 
+    if (req->se->conn.want & FUSE_CAP_SETXATTR_V2) {
+        return do_setxattr_v2(req, nodeid, iter);
+    }
     arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
     name = fuse_mbuf_iter_advance_str(iter);
     if (!arg || !name) {
@@ -1441,7 +1472,8 @@ static void do_setxattr(fuse_req_t req, fuse_ino_t nodeid,
     }
 
     if (req->se->op.setxattr) {
-        req->se->op.setxattr(req, nodeid, name, value, arg->size, arg->flags);
+        req->se->op.setxattr(req, nodeid, name, value, arg->size, arg->flags,
+                             0);
     } else {
         fuse_reply_err(req, ENOSYS);
     }
@@ -1988,6 +2020,9 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     if (arg->flags & FUSE_HANDLE_KILLPRIV_V2) {
         se->conn.capable |= FUSE_CAP_HANDLE_KILLPRIV_V2;
     }
+    if (arg->flags & FUSE_SETXATTR_V2) {
+        se->conn.capable |= FUSE_CAP_SETXATTR_V2;
+    }
 #ifdef HAVE_SPLICE
 #ifdef HAVE_VMSPLICE
     se->conn.capable |= FUSE_CAP_SPLICE_WRITE | FUSE_CAP_SPLICE_MOVE;
@@ -2020,6 +2055,7 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     LL_SET_DEFAULT(se->op.readdirplus, FUSE_CAP_READDIRPLUS);
     LL_SET_DEFAULT(se->op.readdirplus && se->op.readdir,
                    FUSE_CAP_READDIRPLUS_AUTO);
+    LL_SET_DEFAULT(1, FUSE_CAP_SETXATTR_V2);
     se->conn.time_gran = 1;
 
     if (bufsize < FUSE_MIN_READ_BUFFER) {
@@ -2123,6 +2159,10 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
         outarg.flags |= FUSE_HANDLE_KILLPRIV_V2;
     }
 
+    if (se->conn.want & FUSE_CAP_SETXATTR_V2) {
+        outarg.flags |= FUSE_SETXATTR_V2;
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
index f5fcdeba15..3f5c267604 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3045,7 +3045,8 @@ out:
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

