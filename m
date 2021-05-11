From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 11 May 2021 17:37:32 -0400
Message-Id: <20210511213736.281016-4-vgoyal@redhat.com>
In-Reply-To: <20210511213736.281016-1-vgoyal@redhat.com>
References: <20210511213736.281016-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/7] virtiofsd: Use iov_discard_front() to skip
	bytes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com

There are places where we need to skip few bytes from front of the iovec
array. We have our own custom code for that. Looks like iov_discard_front()
can do same thing. So use that helper instead.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 5dcd08fccb..d56b225800 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -389,23 +389,15 @@ int virtio_send_data_iov(struct fuse_session *se, struct fuse_chan *ch,
     memcpy(in_sg_cpy, in_sg, sizeof(struct iovec) * in_num);
     /* These get updated as we skip */
     struct iovec *in_sg_ptr = in_sg_cpy;
-    int in_sg_cpy_count = in_num;
+    unsigned int in_sg_cpy_count = in_num;
 
     /* skip over parts of in_sg that contained the header iov */
     size_t skip_size = iov_len;
 
     size_t in_sg_left = 0;
     do {
-        while (skip_size != 0 && in_sg_cpy_count) {
-            if (skip_size >= in_sg_ptr[0].iov_len) {
-                skip_size -= in_sg_ptr[0].iov_len;
-                in_sg_ptr++;
-                in_sg_cpy_count--;
-            } else {
-                in_sg_ptr[0].iov_len -= skip_size;
-                in_sg_ptr[0].iov_base += skip_size;
-                break;
-            }
+        if (skip_size != 0) {
+	    iov_discard_front(&in_sg_ptr, &in_sg_cpy_count, skip_size);
         }
 
         int i;
-- 
2.25.4

