Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:51:46 +0100
Message-Id: <20221205095228.1314-10-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 09/51] block-backend: avoid
 bdrv_unregister_buf() NULL pointer deref
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>

From: Stefan Hajnoczi <stefanha@redhat.com>

bdrv_*() APIs expect a valid BlockDriverState. Calling them with bs=NULL
leads to undefined behavior.

Jonathan Cameron reported this following NULL pointer dereference when a
VM with a virtio-blk device and a memory-backend-file object is
terminated:
1. qemu_cleanup() closes all drives, setting blk->root to NULL
2. qemu_cleanup() calls user_creatable_cleanup(), which results in a RAM
   block notifier callback because the memory-backend-file is destroyed.
3. blk_unregister_buf() is called by virtio-blk's BlockRamRegistrar
   notifier callback and undefined behavior occurs.

Fixes: baf422684d73 ("virtio-blk: use BDRV_REQ_REGISTERED_BUF optimization hint")
Co-authored-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Kevin Wolf <kwolf@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20221121211923.1993171-1-stefanha@redhat.com>
---
 block/block-backend.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/block/block-backend.c b/block/block-backend.c
index b48c91f4e1..d98a96ff37 100644
--- a/block/block-backend.c
+++ b/block/block-backend.c
@@ -2576,14 +2576,25 @@ static void blk_root_drained_end(BdrvChild *child, int *drained_end_counter)
 
 bool blk_register_buf(BlockBackend *blk, void *host, size_t size, Error **errp)
 {
+    BlockDriverState *bs = blk_bs(blk);
+
     GLOBAL_STATE_CODE();
-    return bdrv_register_buf(blk_bs(blk), host, size, errp);
+
+    if (bs) {
+        return bdrv_register_buf(bs, host, size, errp);
+    }
+    return true;
 }
 
 void blk_unregister_buf(BlockBackend *blk, void *host, size_t size)
 {
+    BlockDriverState *bs = blk_bs(blk);
+
     GLOBAL_STATE_CODE();
-    bdrv_unregister_buf(blk_bs(blk), host, size);
+
+    if (bs) {
+        bdrv_unregister_buf(bs, host, size);
+    }
 }
 
 int coroutine_fn blk_co_copy_range(BlockBackend *blk_in, int64_t off_in,
-- 
2.38.1

