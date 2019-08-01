From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu,  1 Aug 2019 17:54:09 +0100
Message-Id: <20190801165409.20121-5-stefanha@redhat.com>
In-Reply-To: <20190801165409.20121-1-stefanha@redhat.com>
References: <20190801165409.20121-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/4] virtiofsd: add --thread-pool-size=NUM option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org

Add an option to control the size of the thread pool.  Requests are now
processed in parallel by default.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/fuse_i.h        | 1 +
 contrib/virtiofsd/fuse_lowlevel.c | 8 ++++++--
 contrib/virtiofsd/fuse_virtio.c   | 4 ++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/contrib/virtiofsd/fuse_i.h b/contrib/virtiofsd/fuse_i.h
index dcde9feb97..5c82cf2eac 100644
--- a/contrib/virtiofsd/fuse_i.h
+++ b/contrib/virtiofsd/fuse_i.h
@@ -74,6 +74,7 @@ struct fuse_session {
         int   vu_listen_fd;
         int   vu_socketfd;
         struct fv_VuDev *virtio_dev;
+        int thread_pool_size;
 };
 
 struct fuse_chan {
diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
index 483a1bc9be..b692791fbc 100644
--- a/contrib/virtiofsd/fuse_lowlevel.c
+++ b/contrib/virtiofsd/fuse_lowlevel.c
@@ -26,7 +26,7 @@
 #include <assert.h>
 #include <sys/file.h>
 
-
+#define THREAD_POOL_SIZE 64
 
 #define OFFSET_MAX 0x7fffffffffffffffLL
 
@@ -2556,6 +2556,7 @@ static const struct fuse_opt fuse_ll_opts[] = {
 	LL_OPTION("--socket-path=%s", vu_socket_path, 0),
         LL_OPTION("vhost_user_socket=%s", vu_socket_path, 0),
 	LL_OPTION("--fd=%d", vu_listen_fd, 0),
+	LL_OPTION("--thread-pool-size=%d", thread_pool_size, 0),
 	FUSE_OPT_END
 };
 
@@ -2575,7 +2576,9 @@ void fuse_lowlevel_help(void)
 "    --socket-path=PATH         path for the vhost-user socket\n"
 "    -o vhost_user_socket=PATH  path for the vhost-user socket\n"
 "    --fd=FDNUM                 fd number of vhost-user socket\n"
-"    -o auto_unmount            auto unmount on process termination\n");
+"    -o auto_unmount            auto unmount on process termination\n"
+"    --thread-pool-size=NUM     thread pool size limit (default %d)\n",
+	       THREAD_POOL_SIZE);
 }
 
 void fuse_session_destroy(struct fuse_session *se)
@@ -2629,6 +2632,7 @@ struct fuse_session *fuse_session_new(struct fuse_args *args,
 	}
 	se->fd = -1;
 	se->vu_listen_fd = -1;
+	se->thread_pool_size = THREAD_POOL_SIZE;
 	se->conn.max_write = UINT_MAX;
 	se->conn.max_readahead = UINT_MAX;
 
diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
index 0c52911144..e13b3cc2e6 100644
--- a/contrib/virtiofsd/fuse_virtio.c
+++ b/contrib/virtiofsd/fuse_virtio.c
@@ -663,8 +663,8 @@ static void *fv_queue_thread(void *opaque)
         struct fuse_session *se = qi->virtio_dev->se;
         GThreadPool *pool;
 
-        pool = g_thread_pool_new(fv_queue_worker, qi, 1 /* TODO max_threads */,
-                        TRUE, NULL);
+        pool = g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_size,
+                                 TRUE, NULL);
         if (!pool) {
                 fuse_err("%s: g_thread_pool_new failed\n", __func__);
                 return NULL;
-- 
2.21.0

