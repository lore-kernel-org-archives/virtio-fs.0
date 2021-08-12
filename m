From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Thu, 12 Aug 2021 13:46:18 +0800
Message-Id: <20210812054618.26057-3-jefflexu@linux.alibaba.com>
In-Reply-To: <20210812054618.26057-1-jefflexu@linux.alibaba.com>
References: <20210812054618.26057-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH 2/2] virtiofs: reduce lock contention on
	fpq->lock
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, virtualization@lists.linux-foundation.org

From: Liu Bo <bo.liu@linux.alibaba.com>

Since %req has been removed from fpq->processing_list, no one except
request_wait_answer() is looking at this %req and request_wait_answer()
waits only on FINISH flag, it's OK to remove fpq->lock after %req is
dropped from the list.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/fuse/virtio_fs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 0050132e2787..7dbf5502c57e 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -557,7 +557,6 @@ static void copy_args_from_argbuf(struct fuse_args *args, struct fuse_req *req)
 static void virtio_fs_request_complete(struct fuse_req *req,
 				       struct virtio_fs_vq *fsvq)
 {
-	struct fuse_pqueue *fpq = &fsvq->fud->pq;
 	struct fuse_args *args;
 	struct fuse_args_pages *ap;
 	unsigned int len, i, thislen;
@@ -586,9 +585,7 @@ static void virtio_fs_request_complete(struct fuse_req *req,
 		}
 	}
 
-	spin_lock(&fpq->lock);
 	clear_bit(FR_SENT, &req->flags);
-	spin_unlock(&fpq->lock);
 
 	fuse_request_end(req);
 	spin_lock(&fsvq->lock);
-- 
2.27.0

