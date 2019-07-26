From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Fri, 26 Jul 2019 09:29:33 +0100
Message-Id: <20190726082933.13314-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] fuse: implement FUSE_INIT map_alignment field
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Miklos Szeredi <mszeredi@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

The device communicates FUSE_SETUPMAPPING/FUSE_REMOVMAPPING alignment
constraints via the FUST_INIT map_alignment field.  Parse this field and
ensure our DAX mappings meet the alignment constraints.

We don't actually align anything differently since our mappings are
already 2MB aligned.  Just check the value when the connection is
established.  If it becomes necessary to honor arbitrary alignments in
the future we'll have to adjust how mappings are sized.

The upshot of this commit is that we can be confident that mappings will
work even when emulating x86 on Power and similar combinations where the
host page sizes are different.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
Please see separate virtiofsd patch for the server-side implementation.

 fs/fuse/fuse_i.h          |  5 ++++-
 include/uapi/linux/fuse.h |  7 ++++++-
 fs/fuse/inode.c           | 18 ++++++++++++++++--
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index edcc4a3e119b..988ea5c39d41 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -46,7 +46,10 @@
 /** Number of page pointers embedded in fuse_req */
 #define FUSE_REQ_INLINE_PAGES 1
 
-/* Default memory range size, 2MB */
+/*
+ * Default memory range size.  A power of 2 so it agrees with common FUSE_INIT
+ * map_alignment values 4KB and 64KB.
+ */
 #define FUSE_DAX_MEM_RANGE_SZ	(2*1024*1024)
 #define FUSE_DAX_MEM_RANGE_PAGES	(FUSE_DAX_MEM_RANGE_SZ/PAGE_SIZE)
 
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 0f4b69b9c751..41d384b189b6 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -263,6 +263,9 @@ struct fuse_file_lock {
  * FUSE_MAX_PAGES: init_out.max_pages contains the max number of req pages
  * FUSE_CACHE_SYMLINKS: cache READLINK responses
  * FUSE_NO_OPENDIR_SUPPORT: kernel supports zero-message opendir
+ * FUSE_MAP_ALIGNMENT: init_out.map_alignment contains byte alignment for
+ *                     foffset and moffset fields in struct
+ *                     fuse_setupmapping_out and fuse_removemapping_one.
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -289,6 +292,7 @@ struct fuse_file_lock {
 #define FUSE_MAX_PAGES		(1 << 22)
 #define FUSE_CACHE_SYMLINKS	(1 << 23)
 #define FUSE_NO_OPENDIR_SUPPORT (1 << 24)
+#define FUSE_MAP_ALIGNMENT      (1 << 25)
 
 /**
  * CUSE INIT request/reply flags
@@ -632,7 +636,8 @@ struct fuse_init_out {
 	uint32_t	time_gran;
 	uint16_t	max_pages;
 	uint16_t	padding;
-	uint32_t	unused[8];
+	uint32_t	map_alignment;
+	uint32_t	unused[7];
 };
 
 #define CUSE_INIT_INFO_MAX 4096
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index ffa00caeea01..ecb47c65f514 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -969,9 +969,10 @@ static void process_init_limits(struct fuse_conn *fc, struct fuse_init_out *arg)
 static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 {
 	struct fuse_init_out *arg = &req->misc.init_out;
+	bool ok = true;
 
 	if (req->out.h.error || arg->major != FUSE_KERNEL_VERSION)
-		fc->conn_error = 1;
+		ok = false;
 	else {
 		unsigned long ra_pages;
 
@@ -1032,6 +1033,13 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 					min_t(unsigned int, FUSE_MAX_MAX_PAGES,
 					max_t(unsigned int, arg->max_pages, 1));
 			}
+			if ((arg->flags & FUSE_MAP_ALIGNMENT) &&
+			    (FUSE_DAX_MEM_RANGE_SZ % arg->map_alignment)) {
+				printk(KERN_ERR "FUSE: map_alignment %u incompatible with dax mem range size %u\n",
+				       arg->map_alignment,
+				       FUSE_DAX_MEM_RANGE_SZ);
+				ok = false;
+			}
 		} else {
 			ra_pages = fc->max_read / PAGE_SIZE;
 			fc->no_lock = 1;
@@ -1045,6 +1053,12 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 		fc->max_write = max_t(unsigned, 4096, fc->max_write);
 		fc->conn_init = 1;
 	}
+
+	if (!ok) {
+		fc->conn_init = 0;
+		fc->conn_error = 1;
+	}
+
 	fuse_set_initialized(fc);
 	wake_up_all(&fc->blocked_waitq);
 }
@@ -1064,7 +1078,7 @@ void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 		FUSE_WRITEBACK_CACHE | FUSE_NO_OPEN_SUPPORT |
 		FUSE_PARALLEL_DIROPS | FUSE_HANDLE_KILLPRIV | FUSE_POSIX_ACL |
 		FUSE_ABORT_ERROR | FUSE_MAX_PAGES | FUSE_CACHE_SYMLINKS |
-		FUSE_NO_OPENDIR_SUPPORT;
+		FUSE_NO_OPENDIR_SUPPORT | FUSE_MAP_ALIGNMENT;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
-- 
2.21.0

