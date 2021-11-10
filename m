From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 10 Nov 2021 18:17:23 -0500
Message-Id: <20211110231728.50385-2-vgoyal@redhat.com>
In-Reply-To: <20211110231728.50385-1-vgoyal@redhat.com>
References: <20211110231728.50385-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 1/6] fuse: Header file changes for
	FUSE_SECURITY_CTX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, dgilbert@redhat.com
Cc: casey@schaufler-ca.com, omosnace@redhat.com, vgoyal@redhat.com

These are just header file changes which should show up in qemu if
corresponding kernel changes get merged.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/standard-headers/linux/fuse.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/standard-headers/linux/fuse.h b/include/standard-headers/linux/fuse.h
index cce105bfba..f412ff7f50 100644
--- a/include/standard-headers/linux/fuse.h
+++ b/include/standard-headers/linux/fuse.h
@@ -181,6 +181,10 @@
  *  - add FUSE_OPEN_KILL_SUIDGID
  *  - extend fuse_setxattr_in, add FUSE_SETXATTR_EXT
  *  - add FUSE_SETXATTR_ACL_KILL_SGID
+ *
+ *  7.35
+ *  - add FUSE_SECURITY_CTX flag for fuse_init_out
+ *  - add security context to create, mkdir, symlink, and mknod requests
  */
 
 #ifndef _LINUX_FUSE_H
@@ -212,7 +216,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 33
+#define FUSE_KERNEL_MINOR_VERSION 35
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -329,6 +333,8 @@ struct fuse_file_lock {
  *			write/truncate sgid is killed only if file has group
  *			execute permission. (Same as Linux VFS behavior).
  * FUSE_SETXATTR_EXT:	Server supports extended struct fuse_setxattr_in
+ * FUSE_SECURITY_CTX:  add security context to create, mkdir, symlink, and
+ *                     mknod
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -360,6 +366,7 @@ struct fuse_file_lock {
 #define FUSE_SUBMOUNTS		(1 << 27)
 #define FUSE_HANDLE_KILLPRIV_V2	(1 << 28)
 #define FUSE_SETXATTR_EXT	(1 << 29)
+#define FUSE_SECURITY_CTX	(1 << 30)
 
 /**
  * CUSE INIT request/reply flags
@@ -967,4 +974,14 @@ struct fuse_removemapping_one {
 #define FUSE_REMOVEMAPPING_MAX_ENTRY   \
 		(PAGE_SIZE / sizeof(struct fuse_removemapping_one))
 
+struct fuse_secctx {
+	uint32_t        size;
+	uint32_t        padding;
+};
+
+struct fuse_secctx_header {
+	uint32_t        size;
+	uint32_t        nr_secctx;
+};
+
 #endif /* _LINUX_FUSE_H */
-- 
2.31.1

