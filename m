From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Tue,  7 May 2019 13:58:40 +0800
Message-Id: <1557208720-44561-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH] virtiofsd: do fallocate for setupmapping
	requests with write flag
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

We'll have to make sure filesystem has allocated space for the dax
mapping, otherwise, guest writes from virtiofs may hang since write
page fault is not able to be resolved if host fs is full
(->page_mkwrite() return -ENOSPC).

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 contrib/virtiofsd/passthrough_ll.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index f14f471..1ddb68f 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -1897,12 +1897,28 @@ static void lo_setupmapping(fuse_req_t req, fuse_ino_t ino, uint64_t foffset,
 
 	}
 
+        if (flags & O_WRONLY) {
+                /* this may allocate more space than we need. */
+                ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, foffset, len);
+                if (ret < 0) {
+                        ret = errno;
+                        fprintf(stderr, "%s: fallocate fail (ino=%" PRId64 "fd=%d foffset=0x%" PRIx64 ")\n",
+                                __func__, ino, fi ? (int)fi->fh : lo_fd(req, ino), foffset);
+                        goto err;
+                }
+
+                if (lo_debug(req))
+                        fprintf(stderr, "fallocate (foffset=%" PRIx64 "moffset=%" PRIx64 ")\n",
+                                foffset, moffset);
+        }
+
         if (fuse_virtio_map(req, &msg, fd)) {
                 fprintf(stderr, "%s: map over virtio failed (ino=%" PRId64 "fd=%d moffset=0x%" PRIx64 ")\n",
                         __func__, ino, fi ? (int)fi->fh : lo_fd(req, ino), moffset);
                 ret = EINVAL;
         }
 
+err:
 	if (!fi)
 		close(fd);
 	fuse_reply_err(req, ret);
-- 
1.8.3.1

