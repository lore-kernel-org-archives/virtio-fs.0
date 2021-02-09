From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  9 Feb 2021 19:02:09 +0000
Message-Id: <20210209190224.62827-10-dgilbert@redhat.com>
In-Reply-To: <20210209190224.62827-1-dgilbert@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 09/24] DAX: virtiofsd Add cache accessor
	functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Add low level functions that the clients can use to map/unmap cache
areas.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.h | 21 +++++++++++++++++++++
 tools/virtiofsd/fuse_virtio.c   | 18 ++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index 0e10a14bc9..c0ff4f07a4 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -29,6 +29,8 @@
 #include <sys/uio.h>
 #include <utime.h>
 
+#include "subprojects/libvhost-user/libvhost-user.h"
+
 /*
  * Miscellaneous definitions
  */
@@ -1970,4 +1972,23 @@ void fuse_session_process_buf(struct fuse_session *se,
  */
 int fuse_session_receive_buf(struct fuse_session *se, struct fuse_buf *buf);
 
+/**
+ * For use with virtio-fs; request an fd be mapped into the cache
+ *
+ * @param req The request that triggered this action
+ * @param msg A set of mapping requests
+ * @param fd The fd to map
+ * @return Zero on success
+ */
+int64_t fuse_virtio_map(fuse_req_t req, VhostUserFSSlaveMsg *msg, int fd);
+
+/**
+ * For use with virtio-fs; request unmapping of part of the cache
+ *
+ * @param se The session this request is on
+ * @param msg A set of unmapping requests
+ * @return Zero on success
+ */
+int64_t fuse_virtio_unmap(struct fuse_session *se, VhostUserFSSlaveMsg *msg);
+
 #endif /* FUSE_LOWLEVEL_H_ */
diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index bd19358437..f217a093c8 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -1044,3 +1044,21 @@ void virtio_session_close(struct fuse_session *se)
     free(se->virtio_dev);
     se->virtio_dev = NULL;
 }
+
+int64_t fuse_virtio_map(fuse_req_t req, VhostUserFSSlaveMsg *msg, int fd)
+{
+    if (!req->se->virtio_dev) {
+        return -ENODEV;
+    }
+    return vu_fs_cache_request(&req->se->virtio_dev->dev,
+                               VHOST_USER_SLAVE_FS_MAP, fd, msg);
+}
+
+int64_t fuse_virtio_unmap(struct fuse_session *se, VhostUserFSSlaveMsg *msg)
+{
+    if (!se->virtio_dev) {
+        return -ENODEV;
+    }
+    return vu_fs_cache_request(&se->virtio_dev->dev, VHOST_USER_SLAVE_FS_UNMAP,
+                               -1, msg);
+}
-- 
2.29.2

