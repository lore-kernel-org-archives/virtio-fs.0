From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu,  6 May 2021 19:56:39 +0100
Message-Id: <20210506185641.284821-11-dgilbert@redhat.com>
In-Reply-To: <20210506185641.284821-1-dgilbert@redhat.com>
References: <20210506185641.284821-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 10/12] virtiofsd: Changed allocations of fv_VuDev
	& its internals to GLib functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, groug@kaod.org, jose.carlos.venegas.munoz@intel.com, ma.mandourr@gmail.com
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

From: Mahmoud Mandour <ma.mandourr@gmail.com>

Changed the allocations of fv_VuDev structs, VuDev structs, and
fv_QueueInfo strcuts from using calloc()/realloc() & free() to using
the equivalent functions from GLib.

In instances, removed the pair of allocation and assertion for
non-NULL checking with a GLib function that aborts on error.

Removed NULL-checking for fv_VuDev struct allocation and used
a GLib function that crashes on error; namely, g_new0(). This
is because allocating one struct should not be a problem on an
healthy system. Also following the pattern of aborting-on-null
behaviour that is taken with allocating VuDev structs and
fv_QueueInfo structs.

Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20210420154643.58439-6-ma.mandourr@gmail.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index a3d37ab696..828f0fa590 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -782,7 +782,7 @@ static void fv_queue_cleanup_thread(struct fv_VuDev *vud, int qidx)
     pthread_mutex_destroy(&ourqi->vq_lock);
     close(ourqi->kill_fd);
     ourqi->kick_fd = -1;
-    free(vud->qi[qidx]);
+    g_free(vud->qi[qidx]);
     vud->qi[qidx] = NULL;
 }
 
@@ -813,15 +813,13 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
     if (started) {
         /* Fire up a thread to watch this queue */
         if (qidx >= vud->nqueues) {
-            vud->qi = realloc(vud->qi, (qidx + 1) * sizeof(vud->qi[0]));
-            assert(vud->qi);
+            vud->qi = g_realloc_n(vud->qi, qidx + 1, sizeof(vud->qi[0]));
             memset(vud->qi + vud->nqueues, 0,
                    sizeof(vud->qi[0]) * (1 + (qidx - vud->nqueues)));
             vud->nqueues = qidx + 1;
         }
         if (!vud->qi[qidx]) {
-            vud->qi[qidx] = calloc(sizeof(struct fv_QueueInfo), 1);
-            assert(vud->qi[qidx]);
+            vud->qi[qidx] = g_new0(struct fv_QueueInfo, 1);
             vud->qi[qidx]->virtio_dev = vud;
             vud->qi[qidx]->qidx = qidx;
         } else {
@@ -1087,12 +1085,7 @@ int virtio_session_mount(struct fuse_session *se)
              __func__);
 
     /* TODO: Some cleanup/deallocation! */
-    se->virtio_dev = calloc(sizeof(struct fv_VuDev), 1);
-    if (!se->virtio_dev) {
-        fuse_log(FUSE_LOG_ERR, "%s: virtio_dev calloc failed\n", __func__);
-        close(data_sock);
-        return -1;
-    }
+    se->virtio_dev = g_new0(struct fv_VuDev, 1);
 
     se->vu_socketfd = data_sock;
     se->virtio_dev->se = se;
@@ -1114,8 +1107,8 @@ void virtio_session_close(struct fuse_session *se)
         return;
     }
 
-    free(se->virtio_dev->qi);
+    g_free(se->virtio_dev->qi);
     pthread_rwlock_destroy(&se->virtio_dev->vu_dispatch_rwlock);
-    free(se->virtio_dev);
+    g_free(se->virtio_dev);
     se->virtio_dev = NULL;
 }
-- 
2.31.1

