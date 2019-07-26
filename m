From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Fri, 26 Jul 2019 10:11:03 +0100
Message-Id: <20190726091103.23503-6-stefanha@redhat.com>
In-Reply-To: <20190726091103.23503-1-stefanha@redhat.com>
References: <20190726091103.23503-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 5/5] virtiofsd: prevent races with lo_dirp_put()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org

Introduce lo_dirp_put() so that FUSE_RELEASEDIR does not cause
use-after-free races with other threads that are accessing lo_dirp.

Also make lo_releasedir() atomic to prevent FUSE_RELEASEDIR racing with
itself.  This prevents double-frees.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c | 42 +++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index ad3abdd532..f74e7d2d21 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -1293,11 +1293,28 @@ static void lo_readlink(fuse_req_t req, fuse_ino_t ino)
 }
 
 struct lo_dirp {
+	gint refcount;
 	DIR *dp;
 	struct dirent *entry;
 	off_t offset;
 };
 
+static void lo_dirp_put(struct lo_dirp **dp)
+{
+	struct lo_dirp *d = *dp;
+
+	if (!d) {
+		return;
+	}
+	*dp = NULL;
+
+	if (g_atomic_int_dec_and_test(&d->refcount)) {
+		closedir(d->dp);
+		free(d);
+	}
+}
+
+/* Call lo_dirp_put() on the return value when no longer needed */
 static struct lo_dirp *lo_dirp(fuse_req_t req, struct fuse_file_info *fi)
 {
 	struct lo_data *lo = lo_data(req);
@@ -1305,6 +1322,9 @@ static struct lo_dirp *lo_dirp(fuse_req_t req, struct fuse_file_info *fi)
 
 	pthread_mutex_lock(&lo->mutex);
 	elem = lo_map_get(&lo->dirp_map, fi->fh);
+	if (elem) {
+		g_atomic_int_inc(&elem->dirp->refcount);
+	}
 	pthread_mutex_unlock(&lo->mutex);
 	if (!elem)
 		return NULL;
@@ -1335,6 +1355,8 @@ static void lo_opendir(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi
 	d->offset = 0;
 	d->entry = NULL;
 
+	g_atomic_int_set(&d->refcount, 1); /* paired with lo_releasedir() */
+
 	fh = lo_add_dirp_mapping(req, d);
 	if (fh == -1)
 		goto out_err;
@@ -1363,7 +1385,7 @@ static void lo_do_readdir(fuse_req_t req, fuse_ino_t ino, size_t size,
 			  off_t offset, struct fuse_file_info *fi, int plus)
 {
 	struct lo_data *lo = lo_data(req);
-	struct lo_dirp *d;
+	struct lo_dirp *d = NULL;
 	struct lo_inode *dinode;
 	char *buf = NULL;
 	char *p;
@@ -1451,6 +1473,8 @@ static void lo_do_readdir(fuse_req_t req, fuse_ino_t ino, size_t size,
 
     err = 0;
 error:
+    lo_dirp_put(&d);
+
     // If there's an error, we can only signal it if we haven't stored
     // any entries yet - otherwise we'd end up with wrong lookup
     // counts for the entries that are already in the buffer. So we
@@ -1477,22 +1501,25 @@ static void lo_readdirplus(fuse_req_t req, fuse_ino_t ino, size_t size,
 static void lo_releasedir(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
 {
 	struct lo_data *lo = lo_data(req);
+	struct lo_map_elem *elem;
 	struct lo_dirp *d;
 
 	(void) ino;
 
-	d = lo_dirp(req, fi);
-	if (!d) {
+	pthread_mutex_lock(&lo->mutex);
+	elem = lo_map_get(&lo->dirp_map, fi->fh);
+	if (!elem) {
+		pthread_mutex_unlock(&lo->mutex);
 		fuse_reply_err(req, EBADF);
 		return;
 	}
 
-	pthread_mutex_lock(&lo->mutex);
+	d = elem->dirp;
 	lo_map_remove(&lo->dirp_map, fi->fh);
 	pthread_mutex_unlock(&lo->mutex);
 
-	closedir(d->dp);
-	free(d);
+	lo_dirp_put(&d); /* paired with lo_opendir() */
+
 	fuse_reply_err(req, 0);
 }
 
@@ -1701,6 +1728,9 @@ static void lo_fsyncdir(fuse_req_t req, fuse_ino_t ino, int datasync,
 		res = fdatasync(fd);
 	else
 		res = fsync(fd);
+
+	lo_dirp_put(&d);
+
 	fuse_reply_err(req, res == -1 ? errno : 0);
 }
 
-- 
2.21.0

