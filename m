DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding;
	bh=DMmCP/nq64/5+dSP7ehwkK/KzSCcP4/pvUdlB1H1Ib8=;
	b=uyJe/qGT8CrrzJIynMquh4rDa+/5CQGgn6RE/u1a4p5RvDa7jTXAmZnb1Ouwl+BVLn
	cKnMB+bsd1tCTQl3gqLwGUkkfaq5OcXCBtkcFBfR6M/szumNJbQhSk+hH2KctK4O5xwO
	2pGaOFxg6h/xTJXFJGIySm+A3MKk8GCNY2H5xXDSrbA37wJID4y/upxEtYmUZQ4javZn
	XXryLQBxNYdau/7XS+2/bbgkcItabe2Qz3QBPcrmIIKItZ0X6z3TxKA4NxcTyD3Qw1k+
	CUrRG1C9kjBtnn1h0fvGBiOeMwCriAbZ2xfDNh+YdTs/Bvf4jLXI3vuRZUxImuUQgWR7
	OIfw==
From: Mahmoud Mandour <ma.mandourr@gmail.com>
Date: Tue, 20 Apr 2021 17:46:40 +0200
Message-Id: <20210420154643.58439-6-ma.mandourr@gmail.com>
In-Reply-To: <20210420154643.58439-1-ma.mandourr@gmail.com>
References: <20210420154643.58439-1-ma.mandourr@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v2 5/7] virtiofsd: Changed allocations of
	fv_VuDev & its internals to GLib functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "open list:virtiofs" <virtio-fs@redhat.com>, Mahmoud Mandour <ma.mandourr@gmail.com>

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
---
 tools/virtiofsd/fuse_virtio.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 07e5d91a9f..5828b9a76f 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -729,7 +729,7 @@ static void fv_queue_cleanup_thread(struct fv_VuDev *vud, int qidx)
     pthread_mutex_destroy(&ourqi->vq_lock);
     close(ourqi->kill_fd);
     ourqi->kick_fd = -1;
-    free(vud->qi[qidx]);
+    g_free(vud->qi[qidx]);
     vud->qi[qidx] = NULL;
 }
 
@@ -760,15 +760,13 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
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
@@ -1034,12 +1032,7 @@ int virtio_session_mount(struct fuse_session *se)
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
@@ -1061,8 +1054,8 @@ void virtio_session_close(struct fuse_session *se)
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
2.25.1

