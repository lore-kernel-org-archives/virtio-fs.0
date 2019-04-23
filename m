From: Eryu Guan <eguan@linux.alibaba.com>
Date: Tue, 23 Apr 2019 14:27:53 +0800
Message-Id: <20190423062753.114282-1-eguan@linux.alibaba.com>
In-Reply-To: <20190416190858.16833-2-bo.liu@linux.alibaba.com>
References: <20190416190858.16833-2-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH v2] virtiofsd: send reply correctly on read
	failure
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently when a lo_read() operation fails, we don't send the failure
back to fuse client, and read(2) operation from guest kernel would hang
on waiting for the reply.

This is easily triggered by a direct read with non-aligned length.

Fix it by detecting preadv(2) error in virtio_send_data_iov(), and
teaching fuse_reply_data() to reply error on error case.

Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
---
v2:
- return postive error number on read error
- also return postive EIO in short read case
- drop "-1" -> "-EOPNOTSUPP" update, which should be in a sperate patch

 contrib/virtiofsd/fuse_virtio.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
index ca988aac923f..7337f2a2c3ab 100644
--- a/contrib/virtiofsd/fuse_virtio.c
+++ b/contrib/virtiofsd/fuse_virtio.c
@@ -333,8 +333,13 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
                 ret = preadv(buf->buf[0].fd, in_sg_ptr, in_sg_cpy_count, buf->buf[0].pos);
 
                 if (se->debug)
-                        fprintf(stderr, "%s: preadv_res=%d len=%zd\n",
-                                __func__, ret, len);
+                        fprintf(stderr, "%s: preadv_res=%d(%s) len=%zd\n",
+                                __func__, ret, strerror(errno), len);
+                if (ret == -1) {
+                        ret = errno;
+                        free(in_sg_cpy);
+                        goto err;
+                }
                 if (ret < len && ret) {
                         if (se->debug)
                                 fprintf(stderr, "%s: ret < len\n", __func__);
@@ -356,7 +361,7 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
                 if (ret != len) {
                         if (se->debug)
                                 fprintf(stderr, "%s: ret!=len\n", __func__);
-                        ret = -EIO;
+                        ret = EIO;
                         free(in_sg_cpy);
                         goto err;
                 }
@@ -379,7 +384,8 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
         vu_queue_notify(&se->virtio_dev->dev, q);
 
 err:
-        ch->qi->reply_sent = true;
+        if (ret == 0)
+                ch->qi->reply_sent = true;
 
         return ret;
 }
-- 
2.14.4.44.g2045bb6

