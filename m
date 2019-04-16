From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed, 17 Apr 2019 03:08:58 +0800
Message-Id: <20190416190858.16833-5-bo.liu@linux.alibaba.com>
In-Reply-To: <20190416190858.16833-1-bo.liu@linux.alibaba.com>
References: <20190416190858.16833-1-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/4] virtiofsd: use fallocate(2) instead
	posix_fallocate(3)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

This is because posix_fallocate(3) does not support FALLOC_FL_KEEP_SIZE
and FALLOC_FL_PUNCH_HOLE. Our underlying host filesystem is ext4 and
ext4 supports FALLOC_FL_KEEP_SIZE and FALLOC_FL_PUNCH_HOLE well, so
this change will be ok.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 contrib/virtiofsd/passthrough_ll.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 10ea8aa..ccb5312 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -1568,15 +1568,10 @@ static void lo_fallocate(fuse_req_t req, fuse_ino_t ino, int mode,
 			 off_t offset, off_t length, struct fuse_file_info *fi)
 {
 	int err;
-	(void) ino;
-
-	if (mode) {
-		fuse_reply_err(req, EOPNOTSUPP);
-		return;
-	}
 
-	err = posix_fallocate(lo_fi_fd(req, fi), offset,
-			      length);
+	err = fallocate(lo_fi_fd(req, fi), mode, offset, length);
+        if (err < 0)
+                err = errno;
 
 	fuse_reply_err(req, err);
 }
-- 
1.8.3.1

