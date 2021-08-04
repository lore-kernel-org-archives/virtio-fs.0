From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Wed,  4 Aug 2021 15:06:48 +0800
Message-Id: <20210804070653.118123-4-jefflexu@linux.alibaba.com>
In-Reply-To: <20210804070653.118123-1-jefflexu@linux.alibaba.com>
References: <20210804070653.118123-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v3 3/8] fuse: support per-file DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, virtualization@lists.linux-foundation.org

Expand the fuse protocol to support per-file DAX.

FUSE_PERFILE_DAX flag is added indicating if fuse server/client
supporting per-file DAX when sending or replying FUSE_INIT request.

Besides, FUSE_ATTR_DAX flag is added indicating if DAX shall be enabled
for corresponding file when replying FUSE_LOOKUP request.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 include/uapi/linux/fuse.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 36ed092227fa..15a1f5fc0797 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -184,6 +184,9 @@
  *
  *  7.34
  *  - add FUSE_SYNCFS
+ *
+ *  7.35
+ *  - add FUSE_PERFILE_DAX, FUSE_ATTR_DAX
  */
 
 #ifndef _LINUX_FUSE_H
@@ -219,7 +222,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 34
+#define FUSE_KERNEL_MINOR_VERSION 35
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -336,6 +339,7 @@ struct fuse_file_lock {
  *			write/truncate sgid is killed only if file has group
  *			execute permission. (Same as Linux VFS behavior).
  * FUSE_SETXATTR_EXT:	Server supports extended struct fuse_setxattr_in
+ * FUSE_PERFILE_DAX:	kernel supports per-file DAX
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -367,6 +371,7 @@ struct fuse_file_lock {
 #define FUSE_SUBMOUNTS		(1 << 27)
 #define FUSE_HANDLE_KILLPRIV_V2	(1 << 28)
 #define FUSE_SETXATTR_EXT	(1 << 29)
+#define FUSE_PERFILE_DAX	(1 << 30)
 
 /**
  * CUSE INIT request/reply flags
@@ -449,8 +454,10 @@ struct fuse_file_lock {
  * fuse_attr flags
  *
  * FUSE_ATTR_SUBMOUNT: Object is a submount root
+ * FUSE_ATTR_DAX: Enable DAX for this file in per-file DAX mode
  */
 #define FUSE_ATTR_SUBMOUNT      (1 << 0)
+#define FUSE_ATTR_DAX		(1 << 1)
 
 /**
  * Open flags
-- 
2.27.0

