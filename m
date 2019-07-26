From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Fri, 26 Jul 2019 10:11:01 +0100
Message-Id: <20190726091103.23503-4-stefanha@redhat.com>
In-Reply-To: <20190726091103.23503-1-stefanha@redhat.com>
References: <20190726091103.23503-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/5] virtiofsd: make lo_release() atomic
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org

Hold the lock across both lo_map_get() and lo_map_remove() to prevent
races between two FUSE_RELEASE requests.  In this case I don't see a
serious bug but it's safer to do things atomically.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 277a17fc03..c1500e092d 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -1759,14 +1759,18 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
 static void lo_release(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
 {
 	struct lo_data *lo = lo_data(req);
-	int fd;
+	struct lo_map_elem *elem;
+	int fd = -1;
 
 	(void) ino;
 
-	fd = lo_fi_fd(req, fi);
-
 	pthread_mutex_lock(&lo->mutex);
-	lo_map_remove(&lo->fd_map, fi->fh);
+	elem = lo_map_get(&lo->fd_map, fi->fh);
+	if (elem) {
+		fd = elem->fd;
+		elem = NULL;
+		lo_map_remove(&lo->fd_map, fi->fh);
+	}
 	pthread_mutex_unlock(&lo->mutex);
 
 	close(fd);
-- 
2.21.0

