From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Wed, 31 Jul 2019 17:10:02 +0100
Message-Id: <20190731161006.9447-2-stefanha@redhat.com>
In-Reply-To: <20190731161006.9447-1-stefanha@redhat.com>
References: <20190731161006.9447-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/5] virtiofsd: take lo->mutex around
	lo_add_fd_mapping()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org

The lo_add_fd_mapping() function assumes lo->mutex is held, so we should
acquire it.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 65b7352c95..417a104218 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -1555,7 +1555,9 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
 
 		update_version(lo, lo_inode(req, parent));
 
+		pthread_mutex_lock(&lo->mutex);
 		fh = lo_add_fd_mapping(req, fd);
+		pthread_mutex_unlock(&lo->mutex);
 		if (fh == -1) {
 			close(fd);
 			fuse_reply_err(req, ENOMEM);
@@ -1760,7 +1762,9 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
 	if (fd == -1)
 		return (void) fuse_reply_err(req, errno);
 
+	pthread_mutex_lock(&lo->mutex);
 	fh = lo_add_fd_mapping(req, fd);
+	pthread_mutex_unlock(&lo->mutex);
 	if (fh == -1) {
 		close(fd);
 		fuse_reply_err(req, ENOMEM);
-- 
2.21.0

