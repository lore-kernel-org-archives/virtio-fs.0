Date: Thu, 5 Nov 2020 14:44:16 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201105194416.GA1384085@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH] virtiofsd: Use --thread-pool-size=0 to mean no
	thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs-list <virtio-fs@redhat.com>
Cc: jose.carlos.venegas.munoz@intel.com

Right now we create a thread pool and main thread hands over the request
to thread in thread pool to process. Number of threads in thread pool
can be managed by option --thread-pool-size.

There is a chance that in case of some workloads, we might get better
performance if we don't handover the request to a different thread
and process in the context of thread receiving the request.

To implement that, redefine the meaning of --thread-pool-size=0 to
mean that don't use a thread pool. Instead process the request in
the context of thread receiving request from the queue.

I can't think how --thread-pool-size=0 is useful and hence using
that. If it is already useful somehow, I could look at defining
a new option say "--no-thread-pool".

I think this patch will be used more as a debug help to do comparison
when it is more effecient to do not hand over the requests to a
thread pool.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index ff86f6d1ce..60aa7cd3e5 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -695,13 +695,17 @@ static void *fv_queue_thread(void *opaque)
     struct VuDev *dev = &qi->virtio_dev->dev;
     struct VuVirtq *q = vu_get_queue(dev, qi->qidx);
     struct fuse_session *se = qi->virtio_dev->se;
-    GThreadPool *pool;
-
-    pool = g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_size, FALSE,
-                             NULL);
-    if (!pool) {
-        fuse_log(FUSE_LOG_ERR, "%s: g_thread_pool_new failed\n", __func__);
-        return NULL;
+    GThreadPool *pool = NULL;
+    GList *req_list = NULL;
+
+    if (se->thread_pool_size) {
+        fuse_log(FUSE_LOG_DEBUG, "%s: Creating thread pool for Queue %d\n", __func__, qi->qidx);
+        pool = g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_size,
+                                 FALSE, NULL);
+        if (!pool) {
+            fuse_log(FUSE_LOG_ERR, "%s: g_thread_pool_new failed\n", __func__);
+            return NULL;
+        }
     }
 
     fuse_log(FUSE_LOG_INFO, "%s: Start for queue %d kick_fd %d\n", __func__,
@@ -780,14 +784,25 @@ static void *fv_queue_thread(void *opaque)
             req->bad_in_num = bad_in_num;
             req->bad_out_num = bad_out_num;
 
-            g_thread_pool_push(pool, req, NULL);
+            if (!se->thread_pool_size)
+                req_list = g_list_prepend(req_list, req);
+            else
+                g_thread_pool_push(pool, req, NULL);
         }
 
         pthread_mutex_unlock(&qi->vq_lock);
         pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
+
+        // Process all the requests.
+        if (!se->thread_pool_size && req_list != NULL) {
+	    g_list_foreach(req_list, fv_queue_worker, qi);
+	    g_list_free(req_list);
+            req_list = NULL;
+	}
     }
 
-    g_thread_pool_free(pool, FALSE, TRUE);
+    if (pool)
+        g_thread_pool_free(pool, FALSE, TRUE);
 
     return NULL;
 }
-- 
2.25.4

