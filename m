From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon, 24 Jan 2022 16:24:49 -0500
Message-Id: <20220124212455.83968-4-vgoyal@redhat.com>
In-Reply-To: <20220124212455.83968-1-vgoyal@redhat.com>
References: <20220124212455.83968-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 3/9] virtiofsd: Parse extended "struct
	fuse_init_in"
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

Add some code to parse extended "struct fuse_init_in". And use a local
variable "flag" to represent 64 bit flags. This will make it easier
to add more features without having to worry about two 32bit flags (->flags
and ->flags2) in "fuse_struct_in".

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.c | 55 ++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index ce29a70253..c3af5ede08 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -1886,6 +1886,7 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     struct fuse_session *se = req->se;
     size_t bufsize = se->bufsize;
     size_t outargsize = sizeof(outarg);
+    uint64_t flags = 0;
 
     (void)nodeid;
 
@@ -1902,11 +1903,21 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
             fuse_reply_err(req, EINVAL);
             return;
         }
+        flags |= arg->flags;
+    }
+
+    /* fuse_init_in was extended again with minor version 36 */
+    if (sizeof(*arg) > compat2_size && (arg->flags & FUSE_INIT_EXT)) {
+        if (!fuse_mbuf_iter_advance(iter, sizeof(*arg) - compat2_size)) {
+            fuse_reply_err(req, EINVAL);
+            return;
+        }
+        flags |= (uint64_t) arg->flags2 << 32;
     }
 
     fuse_log(FUSE_LOG_DEBUG, "INIT: %u.%u\n", arg->major, arg->minor);
     if (arg->major == 7 && arg->minor >= 6) {
-        fuse_log(FUSE_LOG_DEBUG, "flags=0x%08x\n", arg->flags);
+        fuse_log(FUSE_LOG_DEBUG, "flags=0x%016llx\n", flags);
         fuse_log(FUSE_LOG_DEBUG, "max_readahead=0x%08x\n", arg->max_readahead);
     }
     se->conn.proto_major = arg->major;
@@ -1934,68 +1945,68 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     if (arg->max_readahead < se->conn.max_readahead) {
         se->conn.max_readahead = arg->max_readahead;
     }
-    if (arg->flags & FUSE_ASYNC_READ) {
+    if (flags & FUSE_ASYNC_READ) {
         se->conn.capable |= FUSE_CAP_ASYNC_READ;
     }
-    if (arg->flags & FUSE_POSIX_LOCKS) {
+    if (flags & FUSE_POSIX_LOCKS) {
         se->conn.capable |= FUSE_CAP_POSIX_LOCKS;
     }
-    if (arg->flags & FUSE_ATOMIC_O_TRUNC) {
+    if (flags & FUSE_ATOMIC_O_TRUNC) {
         se->conn.capable |= FUSE_CAP_ATOMIC_O_TRUNC;
     }
-    if (arg->flags & FUSE_EXPORT_SUPPORT) {
+    if (flags & FUSE_EXPORT_SUPPORT) {
         se->conn.capable |= FUSE_CAP_EXPORT_SUPPORT;
     }
-    if (arg->flags & FUSE_DONT_MASK) {
+    if (flags & FUSE_DONT_MASK) {
         se->conn.capable |= FUSE_CAP_DONT_MASK;
     }
-    if (arg->flags & FUSE_FLOCK_LOCKS) {
+    if (flags & FUSE_FLOCK_LOCKS) {
         se->conn.capable |= FUSE_CAP_FLOCK_LOCKS;
     }
-    if (arg->flags & FUSE_AUTO_INVAL_DATA) {
+    if (flags & FUSE_AUTO_INVAL_DATA) {
         se->conn.capable |= FUSE_CAP_AUTO_INVAL_DATA;
     }
-    if (arg->flags & FUSE_DO_READDIRPLUS) {
+    if (flags & FUSE_DO_READDIRPLUS) {
         se->conn.capable |= FUSE_CAP_READDIRPLUS;
     }
-    if (arg->flags & FUSE_READDIRPLUS_AUTO) {
+    if (flags & FUSE_READDIRPLUS_AUTO) {
         se->conn.capable |= FUSE_CAP_READDIRPLUS_AUTO;
     }
-    if (arg->flags & FUSE_ASYNC_DIO) {
+    if (flags & FUSE_ASYNC_DIO) {
         se->conn.capable |= FUSE_CAP_ASYNC_DIO;
     }
-    if (arg->flags & FUSE_WRITEBACK_CACHE) {
+    if (flags & FUSE_WRITEBACK_CACHE) {
         se->conn.capable |= FUSE_CAP_WRITEBACK_CACHE;
     }
-    if (arg->flags & FUSE_NO_OPEN_SUPPORT) {
+    if (flags & FUSE_NO_OPEN_SUPPORT) {
         se->conn.capable |= FUSE_CAP_NO_OPEN_SUPPORT;
     }
-    if (arg->flags & FUSE_PARALLEL_DIROPS) {
+    if (flags & FUSE_PARALLEL_DIROPS) {
         se->conn.capable |= FUSE_CAP_PARALLEL_DIROPS;
     }
-    if (arg->flags & FUSE_POSIX_ACL) {
+    if (flags & FUSE_POSIX_ACL) {
         se->conn.capable |= FUSE_CAP_POSIX_ACL;
     }
-    if (arg->flags & FUSE_HANDLE_KILLPRIV) {
+    if (flags & FUSE_HANDLE_KILLPRIV) {
         se->conn.capable |= FUSE_CAP_HANDLE_KILLPRIV;
     }
-    if (arg->flags & FUSE_NO_OPENDIR_SUPPORT) {
+    if (flags & FUSE_NO_OPENDIR_SUPPORT) {
         se->conn.capable |= FUSE_CAP_NO_OPENDIR_SUPPORT;
     }
-    if (!(arg->flags & FUSE_MAX_PAGES)) {
+    if (!(flags & FUSE_MAX_PAGES)) {
         size_t max_bufsize = FUSE_DEFAULT_MAX_PAGES_PER_REQ * getpagesize() +
                              FUSE_BUFFER_HEADER_SIZE;
         if (bufsize > max_bufsize) {
             bufsize = max_bufsize;
         }
     }
-    if (arg->flags & FUSE_SUBMOUNTS) {
+    if (flags & FUSE_SUBMOUNTS) {
         se->conn.capable |= FUSE_CAP_SUBMOUNTS;
     }
-    if (arg->flags & FUSE_HANDLE_KILLPRIV_V2) {
+    if (flags & FUSE_HANDLE_KILLPRIV_V2) {
         se->conn.capable |= FUSE_CAP_HANDLE_KILLPRIV_V2;
     }
-    if (arg->flags & FUSE_SETXATTR_EXT) {
+    if (flags & FUSE_SETXATTR_EXT) {
         se->conn.capable |= FUSE_CAP_SETXATTR_EXT;
     }
 #ifdef HAVE_SPLICE
@@ -2063,7 +2074,7 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     if (se->conn.max_write < bufsize - FUSE_BUFFER_HEADER_SIZE) {
         se->bufsize = se->conn.max_write + FUSE_BUFFER_HEADER_SIZE;
     }
-    if (arg->flags & FUSE_MAX_PAGES) {
+    if (flags & FUSE_MAX_PAGES) {
         outarg.flags |= FUSE_MAX_PAGES;
         outarg.max_pages = (se->conn.max_write - 1) / getpagesize() + 1;
     }
-- 
2.31.1

