Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:51:55 +0100
Message-Id: <20221205095228.1314-19-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 18/51] hw/nvme: fix aio cancel in flush
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>, Klaus Jensen <k.jensen@samsung.com>

From: Klaus Jensen <k.jensen@samsung.com>

Make sure that iocb->aiocb is NULL'ed when cancelling.

Fix a potential use-after-free by removing the bottom half and enqueuing
the completion directly.

Fixes: 38f4ac65ac88 ("hw/nvme: reimplement flush to allow cancellation")
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Klaus Jensen <k.jensen@samsung.com>
---
 hw/nvme/ctrl.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/hw/nvme/ctrl.c b/hw/nvme/ctrl.c
index 9bc56075f6..fede5af6af 100644
--- a/hw/nvme/ctrl.c
+++ b/hw/nvme/ctrl.c
@@ -3160,7 +3160,6 @@ typedef struct NvmeFlushAIOCB {
     BlockAIOCB common;
     BlockAIOCB *aiocb;
     NvmeRequest *req;
-    QEMUBH *bh;
     int ret;
 
     NvmeNamespace *ns;
@@ -3176,6 +3175,7 @@ static void nvme_flush_cancel(BlockAIOCB *acb)
 
     if (iocb->aiocb) {
         blk_aio_cancel_async(iocb->aiocb);
+        iocb->aiocb = NULL;
     }
 }
 
@@ -3185,6 +3185,8 @@ static const AIOCBInfo nvme_flush_aiocb_info = {
     .get_aio_context = nvme_get_aio_context,
 };
 
+static void nvme_do_flush(NvmeFlushAIOCB *iocb);
+
 static void nvme_flush_ns_cb(void *opaque, int ret)
 {
     NvmeFlushAIOCB *iocb = opaque;
@@ -3206,13 +3208,11 @@ static void nvme_flush_ns_cb(void *opaque, int ret)
     }
 
 out:
-    iocb->aiocb = NULL;
-    qemu_bh_schedule(iocb->bh);
+    nvme_do_flush(iocb);
 }
 
-static void nvme_flush_bh(void *opaque)
+static void nvme_do_flush(NvmeFlushAIOCB *iocb)
 {
-    NvmeFlushAIOCB *iocb = opaque;
     NvmeRequest *req = iocb->req;
     NvmeCtrl *n = nvme_ctrl(req);
     int i;
@@ -3239,14 +3239,8 @@ static void nvme_flush_bh(void *opaque)
     return;
 
 done:
-    qemu_bh_delete(iocb->bh);
-    iocb->bh = NULL;
-
     iocb->common.cb(iocb->common.opaque, iocb->ret);
-
     qemu_aio_unref(iocb);
-
-    return;
 }
 
 static uint16_t nvme_flush(NvmeCtrl *n, NvmeRequest *req)
@@ -3258,7 +3252,6 @@ static uint16_t nvme_flush(NvmeCtrl *n, NvmeRequest *req)
     iocb = qemu_aio_get(&nvme_flush_aiocb_info, NULL, nvme_misc_cb, req);
 
     iocb->req = req;
-    iocb->bh = qemu_bh_new(nvme_flush_bh, iocb);
     iocb->ret = 0;
     iocb->ns = NULL;
     iocb->nsid = 0;
@@ -3280,13 +3273,11 @@ static uint16_t nvme_flush(NvmeCtrl *n, NvmeRequest *req)
     }
 
     req->aiocb = &iocb->common;
-    qemu_bh_schedule(iocb->bh);
+    nvme_do_flush(iocb);
 
     return NVME_NO_COMPLETE;
 
 out:
-    qemu_bh_delete(iocb->bh);
-    iocb->bh = NULL;
     qemu_aio_unref(iocb);
 
     return status;
-- 
2.38.1

