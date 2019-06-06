From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Fri,  7 Jun 2019 05:43:52 +0800
Message-Id: <1559857436-52685-2-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1559857436-52685-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1559857436-52685-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH v2 1/5] virtiofsd: cleanup allocated resource in
	se
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This cleans up unfreed resources in se on quiting, including
se->virtio_dev, se->vu_socket_path, se->vu_socketfd.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 contrib/virtiofsd/fuse_lowlevel.c | 7 +++++++
 contrib/virtiofsd/fuse_virtio.c   | 7 +++++++
 contrib/virtiofsd/fuse_virtio.h   | 2 +-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
index 0fc2880..c460c4c 100644
--- a/contrib/virtiofsd/fuse_lowlevel.c
+++ b/contrib/virtiofsd/fuse_lowlevel.c
@@ -2557,6 +2557,13 @@ void fuse_session_destroy(struct fuse_session *se)
 	free(se->cuse_data);
 	if (se->fd != -1)
 		close(se->fd);
+
+        if (se->vu_socket_path) {
+                virtio_session_close(se);
+                free(se->vu_socket_path);
+                se->vu_socket_path = NULL;
+        }
+
 	free(se);
 }
 
diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
index cb46558..ed6ba57 100644
--- a/contrib/virtiofsd/fuse_virtio.c
+++ b/contrib/virtiofsd/fuse_virtio.c
@@ -886,6 +886,13 @@ int virtio_session_mount(struct fuse_session *se)
         return 0;
 }
 
+void virtio_session_close(struct fuse_session *se)
+{
+        close(se->vu_socketfd);
+        free(se->virtio_dev);
+        se->virtio_dev = NULL;
+}
+
 int64_t fuse_virtio_map(fuse_req_t req, VhostUserFSSlaveMsg *msg, int fd)
 {
         if (!req->se->virtio_dev) return -ENODEV;
diff --git a/contrib/virtiofsd/fuse_virtio.h b/contrib/virtiofsd/fuse_virtio.h
index 19c468e..e602298 100644
--- a/contrib/virtiofsd/fuse_virtio.h
+++ b/contrib/virtiofsd/fuse_virtio.h
@@ -19,7 +19,7 @@
 struct fuse_session;
 
 int virtio_session_mount(struct fuse_session *se);
-
+void virtio_session_close(struct fuse_session *se);
 int virtio_loop(struct fuse_session *se);
 
 
-- 
1.8.3.1

