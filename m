From: Haotian Li <lihaotian9@huawei.com>
References: <4bfe8bbd-282f-f271-735d-8892791327e1@huawei.com>
Message-ID: <54579ad7-a07a-ebbd-7289-48b68883849c@huawei.com>
Date: Tue, 10 Nov 2020 14:35:21 +0800
MIME-Version: 1.0
In-Reply-To: <4bfe8bbd-282f-f271-735d-8892791327e1@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] [PATCH 1/2] tools/virtiofsd/buffer.c: check whether buf
 is NULL in fuse_bufvec_advance func
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: linfeilong@huawei.com

In fuse_bufvec_advance func, calling fuse_bufvec_current func
may return NULL, so we should check whether buf is NULL before
using it.

Signed-off-by: Haotian Li <lihaotian9@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 tools/virtiofsd/buffer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/virtiofsd/buffer.c b/tools/virtiofsd/buffer.c
index 27c1377f22..bdc608c221 100644
--- a/tools/virtiofsd/buffer.c
+++ b/tools/virtiofsd/buffer.c
@@ -246,6 +246,10 @@ static int fuse_bufvec_advance(struct fuse_bufvec *bufv, size_t len)
 {
     const struct fuse_buf *buf = fuse_bufvec_current(bufv);

+    if (!buf) {
+        return 0;
+    }
+
     bufv->off += len;
     assert(bufv->off <= buf->size);
     if (bufv->off == buf->size) {
-- 

