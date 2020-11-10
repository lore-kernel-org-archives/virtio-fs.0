From: Haotian Li <lihaotian9@huawei.com>
References: <eeb2fd1d-a53d-eae6-4727-7f1a6b20ac9e@huawei.com>
Message-ID: <743d931f-8d19-3368-9170-084f0f11b28e@huawei.com>
Date: Tue, 10 Nov 2020 09:10:23 +0800
MIME-Version: 1.0
In-Reply-To: <eeb2fd1d-a53d-eae6-4727-7f1a6b20ac9e@huawei.com>
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
 tools/virtiofsd/buffer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/virtiofsd/buffer.c b/tools/virtiofsd/buffer.c
index 27c1377f22..c94993b936 100644
--- a/tools/virtiofsd/buffer.c
+++ b/tools/virtiofsd/buffer.c
@@ -246,6 +246,9 @@ static int fuse_bufvec_advance(struct fuse_bufvec *bufv, size_t len)
 {
     const struct fuse_buf *buf = fuse_bufvec_current(bufv);

+    if (!buf)
+        return 0;
+
     bufv->off += len;
     assert(bufv->off <= buf->size);
     if (bufv->off == buf->size) {
-- 

