From: Eryu Guan <eguan@linux.alibaba.com>
Date: Wed, 18 Dec 2019 17:22:58 +0800
Message-Id: <20191218092258.76554-1-eguan@linux.alibaba.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd: sync FUSE_DESTROY with session
	destroy
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: qingming.su@linux.alibaba.com

Normally on guest shutdown, guest umounts virtiofs (FUSE_DESTROY) and
waits for umount to return then cleans up virtio device.

But if guest gets killed, for whatever reason, right after sending
FUSE_DESTROY, it's possible that virtiofsd cleans up session and virtio
dev first, then fv_queue_worker() wants to send reply to guest and hits
abort() in fuse_send_msg(), because fuse_lowlevel_is_virtio() returns
false.

Fix it by acquiring se->init_rwlock first in fuse_session_destroy() to
wait for inflight FUSE_DESTROY to be completed, then clean up session
and virtio dev.

Reported-by: Qingming Su <qingming.su@linux.alibaba.com>
Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
---
 tools/virtiofsd/fuse_lowlevel.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 29b9b1cad979..e345b0bae7c2 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -2660,6 +2660,13 @@ void fuse_session_destroy(struct fuse_session *se)
             se->op.destroy(se->userdata, se);
         }
     }
+
+    /*
+     * Wait for inflight FUSE_DESTROY to be completed before cleaning up
+     * session and virtio dev.
+     */
+    pthread_rwlock_wrlock(&se->init_rwlock);
+
     pthread_rwlock_destroy(&se->init_rwlock);
     pthread_mutex_destroy(&se->lock);
     free(se->cuse_data);
-- 
2.14.4.44.g2045bb6


