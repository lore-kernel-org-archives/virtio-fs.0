Date: Tue, 17 Nov 2020 14:41:31 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201117194131.GA96587@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH v3] virtiofsd: Use --thread-pool-size=0 to mean
	no thread pool
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

This is V3 of the patch. A minor change since V2 is to reverse the list
before executing requests. We are prepending elements to the list and that
means when we start processing requests, we are processing these in
the reverse order. Though we don't guarantee any ordering but it does
not hurt to process requests in same order as received as much as
possible.

Right now we create a thread pool and main thread hands over the request
to thread in thread pool to process. Number of threads in thread pool
can be managed by option --thread-pool-size.

In tests we have noted that many of the workloads are getting better
performance if we don't use a thread pool at all and process all
the requests in the context of a thread receiving the request.

Hence give user an option to be able to run virtiofsd without using
a thread pool.

To implement this, I have used existing option --thread-pool-size. This
option defines how many maximum threads can be in the thread pool.
Thread pool size zero freezes thead pool. I can't see why will one
start virtiofsd with a frozen thread pool (hence frozen file system).
So I am redefining --thread-pool-size=0 to mean, don't use a thread pool.
Instead process the request in the context of thread receiving request
from the queue.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 37 ++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 83ba07c6cd..6c56e606ef 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -588,13 +588,18 @@ static void *fv_queue_thread(void *opaque)
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
+        fuse_log(FUSE_LOG_DEBUG, "%s: Creating thread pool for Queue %d\n",
+                 __func__, qi->qidx);
+        pool = g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_size,
+                                 FALSE, NULL);
+        if (!pool) {
+            fuse_log(FUSE_LOG_ERR, "%s: g_thread_pool_new failed\n", __func__);
+            return NULL;
+        }
     }
 
     fuse_log(FUSE_LOG_INFO, "%s: Start for queue %d kick_fd %d\n", __func__,
@@ -669,14 +674,28 @@ static void *fv_queue_thread(void *opaque)
 
             req->reply_sent = false;
 
-            g_thread_pool_push(pool, req, NULL);
+            if (!se->thread_pool_size) {
+                req_list = g_list_prepend(req_list, req);
+            } else {
+                g_thread_pool_push(pool, req, NULL);
+            }
         }
 
         pthread_mutex_unlock(&qi->vq_lock);
         pthread_rwlock_unlock(&qi->virtio_dev->vu_dispatch_rwlock);
+
+        /* Process all the requests. */
+        if (!se->thread_pool_size && req_list != NULL) {
+            req_list = g_list_reverse(req_list);
+            g_list_foreach(req_list, fv_queue_worker, qi);
+            g_list_free(req_list);
+            req_list = NULL;
+        }
     }
 
-    g_thread_pool_free(pool, FALSE, TRUE);
+    if (pool) {
+        g_thread_pool_free(pool, FALSE, TRUE);
+    }
 
     return NULL;
 }
-- 
2.25.4

