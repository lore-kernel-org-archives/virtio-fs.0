From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Fri, 26 Jul 2019 09:33:20 +0100
Message-Id: <20190726083322.13637-2-stefanha@redhat.com>
In-Reply-To: <20190726083322.13637-1-stefanha@redhat.com>
References: <20190726083322.13637-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/3] virtiofsd: sync up fuse.h Linux 5.1 header
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/fuse_kernel.h | 51 ++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/contrib/virtiofsd/fuse_kernel.h b/contrib/virtiofsd/fuse_kernel.h
index 3186efbed6..7722e0ac23 100644
--- a/contrib/virtiofsd/fuse_kernel.h
+++ b/contrib/virtiofsd/fuse_kernel.h
@@ -119,6 +119,12 @@
  *
  *  7.28
  *  - add FUSE_COPY_FILE_RANGE
+ *  - add FOPEN_CACHE_DIR
+ *  - add FUSE_MAX_PAGES, add max_pages to init_out
+ *  - add FUSE_CACHE_SYMLINKS
+ *
+ *  7.29
+ *  - add FUSE_NO_OPENDIR_SUPPORT flag
  */
 
 #ifndef _LINUX_FUSE_H
@@ -154,7 +160,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 27
+#define FUSE_KERNEL_MINOR_VERSION 29
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -222,10 +228,12 @@ struct fuse_file_lock {
  * FOPEN_DIRECT_IO: bypass page cache for this open file
  * FOPEN_KEEP_CACHE: don't invalidate the data cache on open
  * FOPEN_NONSEEKABLE: the file is not seekable
+ * FOPEN_CACHE_DIR: allow caching this directory
  */
 #define FOPEN_DIRECT_IO		(1 << 0)
 #define FOPEN_KEEP_CACHE	(1 << 1)
 #define FOPEN_NONSEEKABLE	(1 << 2)
+#define FOPEN_CACHE_DIR		(1 << 3)
 
 /**
  * INIT request/reply flags
@@ -252,6 +260,9 @@ struct fuse_file_lock {
  * FUSE_HANDLE_KILLPRIV: fs handles killing suid/sgid/cap on write/chown/trunc
  * FUSE_POSIX_ACL: filesystem supports posix acls
  * FUSE_ABORT_ERROR: reading the device after abort returns ECONNABORTED
+ * FUSE_MAX_PAGES: init_out.max_pages contains the max number of req pages
+ * FUSE_CACHE_SYMLINKS: cache READLINK responses
+ * FUSE_NO_OPENDIR_SUPPORT: kernel supports zero-message opendir
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -275,6 +286,9 @@ struct fuse_file_lock {
 #define FUSE_HANDLE_KILLPRIV	(1 << 19)
 #define FUSE_POSIX_ACL		(1 << 20)
 #define FUSE_ABORT_ERROR	(1 << 21)
+#define FUSE_MAX_PAGES		(1 << 22)
+#define FUSE_CACHE_SYMLINKS	(1 << 23)
+#define FUSE_NO_OPENDIR_SUPPORT (1 << 24)
 
 /**
  * CUSE INIT request/reply flags
@@ -385,8 +399,8 @@ enum fuse_opcode {
 	FUSE_RENAME2		= 45,
 	FUSE_LSEEK		= 46,
 	FUSE_COPY_FILE_RANGE	= 47,
-        FUSE_SETUPMAPPING       = 48,
-        FUSE_REMOVEMAPPING      = 49,
+	FUSE_SETUPMAPPING       = 48,
+	FUSE_REMOVEMAPPING      = 49,
 
 	/* CUSE specific operations */
 	CUSE_INIT		= 4096,
@@ -621,7 +635,9 @@ struct fuse_init_out {
 	uint16_t	congestion_threshold;
 	uint32_t	max_write;
 	uint32_t	time_gran;
-	uint32_t	unused[9];
+	uint16_t	max_pages;
+	uint16_t	padding;
+	uint32_t	unused[8];
 };
 
 #define CUSE_INIT_INFO_MAX 4096
@@ -814,31 +830,32 @@ struct fuse_copy_file_range_in {
 };
 
 #define FUSE_SETUPMAPPING_FLAG_WRITE (1ull << 0)
+#define FUSE_SETUPMAPPING_FLAG_READ (1ull << 1)
 struct fuse_setupmapping_in {
-        /* An already open handle */
+	/* An already open handle */
 	uint64_t	fh;
-        /* Offset into the file to start the mapping */
-        uint64_t        foffset;
-        /* Length of mapping required */
-        uint64_t        len;
-        /* Flags, FUSE_SETUPMAPPING_FLAG_* */
-        uint64_t        flags;
-        /* memory offset in to dax window */
-        uint64_t        moffset;
+	/* Offset into the file to start the mapping */
+	uint64_t	foffset;
+	/* Length of mapping required */
+	uint64_t	len;
+	/* Flags, FUSE_SETUPMAPPING_FLAG_* */
+	uint64_t	flags;
+	/* Offset in Memory Window */
+	uint64_t	moffset;
 };
 
 struct fuse_removemapping_in {
         /* An already open handle */
-	uint64_t	fh;
+        uint64_t	fh;
 	/* number of fuse_removemapping_one follows */
 	uint32_t        count;
 };
 
 struct fuse_removemapping_one {
-        /* Offset into the dax to start the unmapping */
+	/* Offset into the dax window start the unmapping */
 	uint64_t        moffset;
-	/* Length of mapping required */
-	uint64_t        len;
+        /* Length of mapping required */
+        uint64_t	len;
 };
 
 #endif /* _LINUX_FUSE_H */
-- 
2.21.0

