From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Wed, 16 Oct 2019 19:37:53 +0900
Message-ID: <20191016103754.2047-2-misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
References: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Subject: [Virtio-fs] [PATCH 1/2] virtiofsd: Avoid process hang when doing
	xattr operation to FIFO
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: qemu-devel@nongnu.org, misono.tomohiro@jp.fujitsu.com

I see xfstest generic/062 causes process hang because of xattr operation to
FIFO created by mknod. The problem is that virtiofsd opens any files
with only O_RDWR or O_RDONLY flags for xattr operation, and therefore
if a file is FIFO, open may not return.

Since O_NONBLOCK flag has no effect to regular files, add it to
open flags to fix the problem.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 contrib/virtiofsd/passthrough_ll.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 84b60d85bd..645324da58 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -2251,7 +2251,7 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
 	}
 
 	sprintf(procname, "%i", inode->fd);
-	fd = openat(lo->proc_self_fd, procname, O_RDONLY);
+	fd = openat(lo->proc_self_fd, procname, O_RDONLY|O_NONBLOCK);
 	if (fd < 0) {
 		goto out_err;
 	}
@@ -2323,7 +2323,7 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
 	}
 
 	sprintf(procname, "%i", inode->fd);
-	fd = openat(lo->proc_self_fd, procname, O_RDONLY);
+	fd = openat(lo->proc_self_fd, procname, O_RDONLY|O_NONBLOCK);
 	if (fd < 0) {
 		goto out_err;
 	}
@@ -2397,7 +2397,7 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
 	}
 
 	sprintf(procname, "%i", inode->fd);
-	fd = openat(lo->proc_self_fd, procname, O_RDWR);
+	fd = openat(lo->proc_self_fd, procname, O_RDWR|O_NONBLOCK);
 	if (fd < 0) {
 		saverr = errno;
 		goto out;
@@ -2446,7 +2446,7 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *name)
 	}
 
 	sprintf(procname, "%i", inode->fd);
-	fd = openat(lo->proc_self_fd, procname, O_RDWR);
+	fd = openat(lo->proc_self_fd, procname, O_RDWR|O_NONBLOCK);
 	if (fd < 0) {
 		saverr = errno;
 		goto out;
-- 
2.21.0

