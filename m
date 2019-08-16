References: <5D56248A.5040000@huawei.com>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D5625DC.2010903@huawei.com>
Date: Fri, 16 Aug 2019 11:41:16 +0800
MIME-Version: 1.0
In-Reply-To: <5D56248A.5040000@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] [PATCH v6 1/2] virtiofsd: add definition of
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
bandwidth. Especially, the src bufs with 0 size should be skipped as
their mems are not *block_size* aligned which will cause writev failed
in direct io mode.

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/buffer.c  | 35 +++++++++++++++++++++++++++++++++++
 contrib/virtiofsd/seccomp.c |  2 ++
 2 files changed, 37 insertions(+)

diff --git a/contrib/virtiofsd/buffer.c b/contrib/virtiofsd/buffer.c
index 655be137..0ed284f 100644
--- a/contrib/virtiofsd/buffer.c
+++ b/contrib/virtiofsd/buffer.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <assert.h>
+#include <stdlib.h>

 size_t fuse_buf_size(const struct fuse_bufvec *bufv)
 {
@@ -31,6 +32,40 @@ size_t fuse_buf_size(const struct fuse_bufvec *bufv)
 	return size;
 }

+static ssize_t fuse_buf_writev(fuse_req_t req,
+			     struct fuse_buf *out_buf,
+			     struct fuse_bufvec *in_buf)
+{
+	ssize_t res, i, j;
+	size_t iovcnt = in_buf->count;
+	struct iovec * iov;
+	int fd = out_buf->fd;
+
+	iov = calloc(iovcnt, sizeof(struct iovec));
+	if (!iov)
+		return -ENOMEM;
+
+	for (i = 0, j = 0; i < iovcnt; i++) {
+		/* Skip the buf with 0 size */
+		if (in_buf->buf[i].size) {
+			iov[j].iov_base = in_buf->buf[i].mem;
+			iov[j].iov_len = in_buf->buf[i].size;
+			j++;
+		}
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
 static size_t min_size(size_t s1, size_t s2)
 {
 	return s1 < s2 ? s1 : s2;
diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
index 7384ebe..3b92c6e 100644
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
 	SCMP_SYS(capget),
 	SCMP_SYS(capset),
 };
-- 

