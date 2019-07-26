From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Fri, 26 Jul 2019 10:11:02 +0100
Message-Id: <20190726091103.23503-5-stefanha@redhat.com>
In-Reply-To: <20190726091103.23503-1-stefanha@redhat.com>
References: <20190726091103.23503-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/5] virtiofsd: drop lo_dirp->fd field
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org

fdopendir(3) takes ownership of the file descriptor.  The presence of
the lo_dirp->fd field could lead to someone incorrectly adding a
close(d->fd) cleanup call in the future.

Do not store the file descriptor in struct lo_dirp since it is unused.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index c1500e092d..ad3abdd532 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -1293,7 +1293,6 @@ static void lo_readlink(fuse_req_t req, fuse_ino_t ino)
 }
 
 struct lo_dirp {
-	int fd;
 	DIR *dp;
 	struct dirent *entry;
 	off_t offset;
@@ -1319,16 +1318,17 @@ static void lo_opendir(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi
 	struct lo_data *lo = lo_data(req);
 	struct lo_dirp *d;
 	ssize_t fh;
+	int fd = -1;
 
 	d = calloc(1, sizeof(struct lo_dirp));
 	if (d == NULL)
 		goto out_err;
 
-	d->fd = openat(lo_fd(req, ino), ".", O_RDONLY);
-	if (d->fd == -1)
+	fd = openat(lo_fd(req, ino), ".", O_RDONLY);
+	if (fd == -1)
 		goto out_errno;
 
-	d->dp = fdopendir(d->fd);
+	d->dp = fdopendir(fd);
 	if (d->dp == NULL)
 		goto out_errno;
 
@@ -1348,11 +1348,12 @@ static void lo_opendir(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi
 out_errno:
 	error = errno;
 out_err:
+	if (fd != -1) {
+		close(fd);
+	}
 	if (d) {
 		if (d->dp)
 			closedir(d->dp);
-		if (d->fd != -1)
-			close(d->fd);
 		free(d);
 	}
 	fuse_reply_err(req, error);
-- 
2.21.0

