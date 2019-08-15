References: <5D54AD38.3060008@huawei.com>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D54ADFC.8060106@huawei.com>
Date: Thu, 15 Aug 2019 08:57:32 +0800
MIME-Version: 1.0
In-Reply-To: <5D54AD38.3060008@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] [PATCH v5 1/2] virtiofsd: add definition of
	fuse_buf_writev()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Define fuse_buf_writev() which use pwritev and writev to improve io
bandwidth.

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/buffer.c  | 31 +++++++++++++++++++++++++++++++
 contrib/virtiofsd/seccomp.c |  2 ++
 2 files changed, 33 insertions(+)

diff --git a/contrib/virtiofsd/buffer.c b/contrib/virtiofsd/buffer.c
index 655be137..cec762f 100644
--- a/contrib/virtiofsd/buffer.c
+++ b/contrib/virtiofsd/buffer.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <assert.h>
+#include <stdlib.h>

 size_t fuse_buf_size(const struct fuse_bufvec *bufv)
 {
@@ -71,6 +72,36 @@ static ssize_t fuse_buf_write(const struct fuse_buf *dst, size_t dst_off,
 	return copied;
 }

+static ssize_t fuse_buf_writev(fuse_req_t req,
+			     struct fuse_buf *out_buf,
+			     struct fuse_bufvec *in_buf)
+{
+	ssize_t res, i;
+	size_t iovcnt = in_buf->count;
+	struct iovec * iov;
+	int fd = out_buf->fd;
+
+	iov = calloc(iovcnt, sizeof(struct iovec));
+	if (!iov)
+		return -ENOMEM;
+
+	for (i = 0; i < iovcnt; i++) {
+		iov[i].iov_base = in_buf->buf[i].mem;
+		iov[i].iov_len = in_buf->buf[i].size;
+	}
+
+	if (out_buf->flags & FUSE_BUF_FD_SEEK)
+		res = pwritev(fd, iov, iovcnt, out_buf->pos);
+	else
+		res = writev(fd, iov, iovcnt);
+
+	if (res == -1)
+		res = -errno;
+
+	free(iov);
+	return res;
+}
+
 static ssize_t fuse_buf_read(const struct fuse_buf *dst, size_t dst_off,
 			     const struct fuse_buf *src, size_t src_off,
 			     size_t len)
diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
index 5f1c873..4bba30b 100644
--- a/contrib/virtiofsd/seccomp.c
+++ b/contrib/virtiofsd/seccomp.c
@@ -60,6 +60,7 @@ static const int syscall_whitelist[] = {
 	SCMP_SYS(ppoll),
 	SCMP_SYS(prctl), /* TODO restrict to just PR_SET_NAME? */
 	SCMP_SYS(preadv),
+	SCMP_SYS(pwritev),
 	SCMP_SYS(pwrite64),
 	SCMP_SYS(read),
 	SCMP_SYS(readlinkat),
@@ -78,6 +79,7 @@ static const int syscall_whitelist[] = {
 	SCMP_SYS(unlinkat),
 	SCMP_SYS(utimensat),
 	SCMP_SYS(write),
+	SCMP_SYS(writev),
 };

 /* Syscalls used when --syslog is enabled */
-- 

