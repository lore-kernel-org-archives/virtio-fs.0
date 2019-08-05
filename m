From: piaojun <piaojun@huawei.com>
Message-ID: <5D478C13.3020406@huawei.com>
Date: Mon, 5 Aug 2019 09:53:23 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] [PATCH] virtiofsd: move assert just after calloc()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

It's better to assert NULL pointer just after calloc().

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 contrib/virtiofsd/fuse_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
index d543c6d..8a4f627 100644
--- a/contrib/virtiofsd/fuse_virtio.c
+++ b/contrib/virtiofsd/fuse_virtio.c
@@ -748,9 +748,9 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
                 }
                 if (!vud->qi[qidx]) {
                         vud->qi[qidx] = calloc(sizeof(struct fv_QueueInfo), 1);
+                        assert(vud->qi[qidx]);
                         vud->qi[qidx]->virtio_dev = vud;
                         vud->qi[qidx]->qidx = qidx;
-                        assert(vud->qi[qidx]);
                 } else {
                         /* Shouldn't have been started */
                         assert(vud->qi[qidx]->kick_fd == -1);
-- 

