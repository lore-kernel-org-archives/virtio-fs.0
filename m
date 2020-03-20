From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Sat, 21 Mar 2020 02:34:14 +0800
Message-Id: <1584729254-123546-2-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1584729254-123546-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1584729254-123546-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 2/2] virtiofsd: fix mmap write under nondax
	mode
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

Fixes: Commit 469f9d2f ("virtiofsd: Plumb fuse_bufvec through do_write_buf")
Reported-by: Yiqun Leng <yqleng@linux.alibaba.com>
Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 tools/virtiofsd/fuse_lowlevel.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index ca2056f..4f8bfb6 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -1221,6 +1221,23 @@ static void do_write_buf(fuse_req_t req, fuse_ino_t nodeid,
          * and the data in the rest, we need to skip that first element
          */
         ibufv->buf[0].size = 0;
+
+        /*
+         * In case of mmap, fuse_buf_size(pbufv) may need to truncate if
+         * arg->size has been cropped by inode size inside guest.  The
+         * diff can only be (0, PAGE_SIZE) because inode size must be
+         * overlapped with the last buf.
+         */
+        if (arg->write_flags & FUSE_WRITE_CACHE) {
+                size_t total = fuse_buf_size(pbufv);
+                int last = ibufv->count - 1;
+
+                if (total > arg->size) {
+                        size_t diff = total - arg->size;
+                        if (diff < ibufv->buf[last].size)
+                                ibufv->buf[last].size -= diff;
+                }
+        }
     }
 
     if (fuse_buf_size(pbufv) != arg->size) {
-- 
1.8.3.1


