From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Tue,  2 Nov 2021 13:56:44 +0800
Message-Id: <20211102055646.103337-5-jefflexu@linux.alibaba.com>
In-Reply-To: <20211102055646.103337-1-jefflexu@linux.alibaba.com>
References: <20211102055646.103337-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v7 4/6] virtiofsd: negotiate per inode DAX in
	FUSE_INIT
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, joseph.qi@linux.alibaba.com

Among the FUSE_INIT phase, guest virtiofs will advertise per inode DAX
if it's mounted with "-o dax=inode". Then virtiofsd is aware that client
is in per inode DAX mode, and will construct per-inode DAX attribute
accordingly.

Virtiofsd shall also advertise support for per inode DAX. DAX policy
must be specified to enable this capability for per inode DAX. That is,
when no DAX policy is specified for virtiofsd, virtiofsd won't advertise
support for per inode DAX then.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 tools/virtiofsd/fuse_common.h    |  5 +++++
 tools/virtiofsd/fuse_lowlevel.c  |  6 ++++++
 tools/virtiofsd/passthrough_ll.c | 14 +++++++++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
index f0df821c6d..f1b4497448 100644
--- a/tools/virtiofsd/fuse_common.h
+++ b/tools/virtiofsd/fuse_common.h
@@ -377,6 +377,11 @@ struct fuse_file_info {
  */
 #define FUSE_CAP_SETXATTR_EXT (1 << 29)
 
+/**
+ * Indicates support for per inode DAX.
+ */
+#define FUSE_CAP_INODE_DAX (1 << 30)
+
 /**
  * Ioctl flags
  *
diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index f11ed576e4..9efe01dc54 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -2075,6 +2075,9 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     if (arg->flags & FUSE_SETXATTR_EXT) {
         se->conn.capable |= FUSE_CAP_SETXATTR_EXT;
     }
+    if (arg->flags & FUSE_HAS_INODE_DAX) {
+        se->conn.capable |= FUSE_CAP_INODE_DAX;
+    }
 #ifdef HAVE_SPLICE
 #ifdef HAVE_VMSPLICE
     se->conn.capable |= FUSE_CAP_SPLICE_WRITE | FUSE_CAP_SPLICE_MOVE;
@@ -2190,6 +2193,9 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     if (se->conn.want & FUSE_CAP_POSIX_ACL) {
         outarg.flags |= FUSE_POSIX_ACL;
     }
+    if (se->conn.want & FUSE_CAP_INODE_DAX) {
+        outarg.flags |= FUSE_HAS_INODE_DAX;
+    }
     outarg.max_readahead = se->conn.max_readahead;
     outarg.max_write = se->conn.max_write;
     if (se->conn.max_background >= (1 << 16)) {
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 13a632bddd..999c906da2 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -747,7 +747,19 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
         conn->want &= ~FUSE_CAP_POSIX_ACL;
     }
 
-    lo->dax = lo->user_dax;
+    if (conn->capable & FUSE_CAP_INODE_DAX) {
+        lo->dax = lo->user_dax;
+    } else {
+        lo->dax = INODE_DAX_NONE;
+    }
+
+    /*
+     * If no dax policy is specified, then virtiofsd won't advertise support
+     * for per indoe DAX.
+     */
+    if (lo->dax != INODE_DAX_NONE) {
+        conn->want |= FUSE_CAP_INODE_DAX;
+    }
 }
 
 static void lo_getattr(fuse_req_t req, fuse_ino_t ino,
-- 
2.27.0

