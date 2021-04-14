From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 14 Apr 2021 16:51:22 +0100
Message-Id: <20210414155137.46522-11-dgilbert@redhat.com>
In-Reply-To: <20210414155137.46522-1-dgilbert@redhat.com>
References: <20210414155137.46522-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 10/25] DAX: virtiofsd Add cache accessor
	functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Add low level functions that the clients can use to map/unmap cache
areas.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.h | 21 +++++++++++++++++++++
 tools/virtiofsd/fuse_virtio.c   | 18 ++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index 3bf786b034..3383e3a8a0 100644
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
@@ -1971,4 +1973,23 @@ void fuse_session_process_buf(struct fuse_session *se,
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
index 2604e7f418..85d90ca595 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -1123,3 +1123,21 @@ void virtio_session_close(struct fuse_session *se)
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
2.31.1

