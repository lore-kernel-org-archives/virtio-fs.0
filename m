References: <5D4CC344.7030706@huawei.com>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D4CC400.9040606@huawei.com>
Date: Fri, 9 Aug 2019 08:53:20 +0800
MIME-Version: 1.0
In-Reply-To: <5D4CC344.7030706@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] [PATCH v4 2/2] virtiofsd: use fuse_buf_writev to
 replace fuse_buf_write for better performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

fuse_buf_writev() only handles the normal write in which src is buffer
and dest is fd. Specially if src buffer represents guest physical
address that can't be mapped by the daemon process, IO must be bounced
back to the VMM to do it by fuse_buf_copy().

Signed-off-by: Jun Piao <piaojun@huawei.com>
Suggested-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/buffer.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/contrib/virtiofsd/buffer.c b/contrib/virtiofsd/buffer.c
index cec762f..d127c45 100644
--- a/contrib/virtiofsd/buffer.c
+++ b/contrib/virtiofsd/buffer.c
@@ -318,11 +318,22 @@ static int fuse_bufvec_advance(struct fuse_bufvec *bufv, size_t len)
 ssize_t fuse_buf_copy(fuse_req_t req, struct fuse_bufvec *dstv, struct fuse_bufvec *srcv,
 		      enum fuse_buf_copy_flags flags)
 {
+	size_t i;
 	size_t copied = 0;

 	if (dstv == srcv)
 		return fuse_buf_size(dstv);

+	/* use writev to improve bandwidth when all the
+	 * src buffers already mapped by the daemon
+	 * process */
+	for (i = 0; i < srcv->count; i++) {
+		if (srcv->buf[i].flags & FUSE_BUF_PHYS_ADDR)
+			break;
+	}
+	if (i == srcv->count)
+		return fuse_buf_writev(req, &dstv->buf[0], srcv);
+
 	for (;;) {
 		const struct fuse_buf *src = fuse_bufvec_current(srcv);
 		const struct fuse_buf *dst = fuse_bufvec_current(dstv);
-- 

