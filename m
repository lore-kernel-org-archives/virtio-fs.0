From: Ioannis Angelakopoulos <iangelak@redhat.com>
Date: Mon, 25 Oct 2021 16:46:28 -0400
Message-Id: <20211025204634.2517-2-iangelak@redhat.com>
In-Reply-To: <20211025204634.2517-1-iangelak@redhat.com>
References: <20211025204634.2517-1-iangelak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH 1/7] FUSE: Add the fsnotify opcode and
	in/out structs to FUSE
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, jack@suse.cz, amir73il@gmail.com, viro@zeniv.linux.org.uk, miklos@szeredi.hu, vgoyal@redhat.com

Since fsnotify is the backend for the inotify subsystem all the backend
code implementation we add is related to fsnotify.

To support an fsnotify request in FUSE and specifically virtiofs we add a
new opcode for the FSNOTIFY (51) operation request in the "fuse.h" header.

Also add the "fuse_notify_fsnotify_in" and "fuse_notify_fsnotify_out"
structs that are responsible for passing the fsnotify/inotify related data
to and from the FUSE server.

Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
---
 include/uapi/linux/fuse.h | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 46838551ea84..418b7fc72417 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -186,6 +186,9 @@
  *  - add FUSE_SYNCFS
  *  7.35
  *  - add FUSE_NOTIFY_LOCK
+ *  7.36
+ *  - add FUSE_HAVE_FSNOTIFY
+ *  - add fuse_notify_fsnotify_(in,out)
  */
 
 #ifndef _LINUX_FUSE_H
@@ -221,7 +224,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 35
+#define FUSE_KERNEL_MINOR_VERSION 36
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -338,6 +341,7 @@ struct fuse_file_lock {
  *			write/truncate sgid is killed only if file has group
  *			execute permission. (Same as Linux VFS behavior).
  * FUSE_SETXATTR_EXT:	Server supports extended struct fuse_setxattr_in
+ * FUSE_HAVE_FSNOTIFY:	remote fsnotify/inotify event subsystem support
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -369,6 +373,7 @@ struct fuse_file_lock {
 #define FUSE_SUBMOUNTS		(1 << 27)
 #define FUSE_HANDLE_KILLPRIV_V2	(1 << 28)
 #define FUSE_SETXATTR_EXT	(1 << 29)
+#define FUSE_HAVE_FSNOTIFY	(1 << 30)
 
 /**
  * CUSE INIT request/reply flags
@@ -515,6 +520,7 @@ enum fuse_opcode {
 	FUSE_SETUPMAPPING	= 48,
 	FUSE_REMOVEMAPPING	= 49,
 	FUSE_SYNCFS		= 50,
+	FUSE_FSNOTIFY		= 51,
 
 	/* CUSE specific operations */
 	CUSE_INIT		= 4096,
@@ -532,6 +538,7 @@ enum fuse_notify_code {
 	FUSE_NOTIFY_RETRIEVE = 5,
 	FUSE_NOTIFY_DELETE = 6,
 	FUSE_NOTIFY_LOCK = 7,
+	FUSE_NOTIFY_FSNOTIFY = 8,
 	FUSE_NOTIFY_CODE_MAX,
 };
 
@@ -571,6 +578,20 @@ struct fuse_getattr_in {
 	uint64_t	fh;
 };
 
+struct fuse_notify_fsnotify_out {
+	uint64_t inode;
+	uint64_t mask;
+	uint32_t namelen;
+	uint32_t cookie;
+};
+
+struct fuse_notify_fsnotify_in {
+	uint64_t mask;
+	uint64_t group;
+	uint32_t action;
+	uint32_t padding;
+};
+
 #define FUSE_COMPAT_ATTR_OUT_SIZE 96
 
 struct fuse_attr_out {
-- 
2.33.0

