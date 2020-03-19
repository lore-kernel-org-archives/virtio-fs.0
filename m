From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Fri, 20 Mar 2020 07:50:15 +0800
Message-Id: <1584661815-6802-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd: fix mmap write under nondax mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When a file size is not aligned to PAGE_SIZE, a mmap write on it may
encounter -EIO (can be observed from virtiofsd's log) due to the difference
between the buf size and the size recorded in struct fuse_write_in.  The
difference comes from the fact that for mmap, writeback IO is used and
guest kernel sets fuse_write_in's size to inode size if EOF, while the buf
len still remains PAGE_SIZE aligned.

This handles the above special mmap case by truncating the last buf'size.

Fixes: Commit 5560349681 ("virtiofsd: Plumb fuse_bufvec through do_write_buf")
Reported-by: Yiqun Leng <lenggou.lyq@linux.alibaba.com>
Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 contrib/virtiofsd/fuse_lowlevel.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
index 7375bae..5f14172 100644
--- a/contrib/virtiofsd/fuse_lowlevel.c
+++ b/contrib/virtiofsd/fuse_lowlevel.c
@@ -1218,12 +1218,23 @@ static void do_write_buf(fuse_req_t req, fuse_ino_t nodeid,
 		tmpbufv.buf[0].mem = ((char *) arg) + arg_size;
 		tmpbufv.buf[0].size -= sizeof(struct fuse_in_header) +
 				       arg_size;
-                pbufv = &tmpbufv;
-        } else {
-                // Input bufv contains the headers in the first element
-                // and the data in the rest, we need to skip that first element
-                ibufv->buf[0].size = 0;
-        }
+		pbufv = &tmpbufv;
+	} else {
+		// Input bufv contains the headers in the first element
+		// and the data in the rest, we need to skip that first element
+		ibufv->buf[0].size = 0;
+
+		if (arg->write_flags & FUSE_WRITE_CACHE) {
+			size_t total = fuse_buf_size(pbufv);
+			int last = ibufv->count - 1;
+
+			if (total > arg->size) {
+				size_t diff = total - arg->size;
+				if (diff < ibufv->buf[last].size)
+					ibufv->buf[last].size -= diff;
+			}
+		}
+	}
 
 	if (fuse_buf_size(pbufv) != arg->size) {
 		fuse_err("fuse: do_write_buf: buffer size %lu doesn't match arg->size %u offset %lu flags %u\n",
-- 
1.8.3.1


