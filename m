From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Wed, 16 Oct 2019 19:37:54 +0900
Message-ID: <20191016103754.2047-3-misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
References: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Subject: [Virtio-fs] [PATCH 2/2] virtiofsd: Allow setxattr operation to
	directry
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

setxattr to directry fails because lo_setxattr (and lo_remove_xattr)
tries to open any file with O_RDWR even if it is a directory.
Since O_RDONLY is enough for the operation, change O_RDWR flag to
O_RDONLY to fix the problem.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 contrib/virtiofsd/passthrough_ll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 645324da58..1b439d58ed 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -2397,7 +2397,7 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
 	}
 
 	sprintf(procname, "%i", inode->fd);
-	fd = openat(lo->proc_self_fd, procname, O_RDWR|O_NONBLOCK);
+	fd = openat(lo->proc_self_fd, procname, O_RDONLY|O_NONBLOCK);
 	if (fd < 0) {
 		saverr = errno;
 		goto out;
@@ -2446,7 +2446,7 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *name)
 	}
 
 	sprintf(procname, "%i", inode->fd);
-	fd = openat(lo->proc_self_fd, procname, O_RDWR|O_NONBLOCK);
+	fd = openat(lo->proc_self_fd, procname, O_RDONLY|O_NONBLOCK);
 	if (fd < 0) {
 		saverr = errno;
 		goto out;
-- 
2.21.0

