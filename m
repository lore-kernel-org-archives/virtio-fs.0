Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:51:54 +0100
Message-Id: <20221205095228.1314-18-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 17/51] hw/nvme: fix aio cancel in format
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>, Klaus Jensen <k.jensen@samsung.com>, Jonathan Derrick <jonathan.derrick@linux.dev>

From: Klaus Jensen <k.jensen@samsung.com>

There are several bugs in the async cancel code for the Format command.

Firstly, cancelling a format operation neglects to set iocb->ret as well
as clearing the iocb->aiocb after cancelling the underlying aiocb which
causes the aio callback to ignore the cancellation. Trivial fix.

Secondly, and worse, because the request is queued up for posting to the
CQ in a bottom half, if the cancellation is due to the submission queue
being deleted (which calls blk_aio_cancel), the req structure is
deallocated in nvme_del_sq prior to the bottom half being schedulued.

Fix this by simply removing the bottom half, there is no reason to defer
it anyway.

Fixes: 3bcf26d3d619 ("hw/nvme: reimplement format nvm to allow cancellation")
Reported-by: Jonathan Derrick <jonathan.derrick@linux.dev>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Klaus Jensen <k.jensen@samsung.com>
---
 hw/nvme/ctrl.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/hw/nvme/ctrl.c b/hw/nvme/ctrl.c
index ac3885ce50..9bc56075f6 100644
--- a/hw/nvme/ctrl.c
+++ b/hw/nvme/ctrl.c
@@ -5741,7 +5741,6 @@ static uint16_t nvme_ns_attachment(NvmeCtrl *n, NvmeRequest *req)
 typedef struct NvmeFormatAIOCB {
     BlockAIOCB common;
     BlockAIOCB *aiocb;
-    QEMUBH *bh;
     NvmeRequest *req;
     int ret;
 
@@ -5756,14 +5755,15 @@ typedef struct NvmeFormatAIOCB {
     uint8_t pil;
 } NvmeFormatAIOCB;
 
-static void nvme_format_bh(void *opaque);
-
 static void nvme_format_cancel(BlockAIOCB *aiocb)
 {
     NvmeFormatAIOCB *iocb = container_of(aiocb, NvmeFormatAIOCB, common);
 
+    iocb->ret = -ECANCELED;
+
     if (iocb->aiocb) {
         blk_aio_cancel_async(iocb->aiocb);
+        iocb->aiocb = NULL;
     }
 }
 
@@ -5787,13 +5787,17 @@ static void nvme_format_set(NvmeNamespace *ns, uint8_t lbaf, uint8_t mset,
     nvme_ns_init_format(ns);
 }
 
+static void nvme_do_format(NvmeFormatAIOCB *iocb);
+
 static void nvme_format_ns_cb(void *opaque, int ret)
 {
     NvmeFormatAIOCB *iocb = opaque;
     NvmeNamespace *ns = iocb->ns;
     int bytes;
 
-    if (ret < 0) {
+    if (iocb->ret < 0) {
+        goto done;
+    } else if (ret < 0) {
         iocb->ret = ret;
         goto done;
     }
@@ -5817,8 +5821,7 @@ static void nvme_format_ns_cb(void *opaque, int ret)
     iocb->offset = 0;
 
 done:
-    iocb->aiocb = NULL;
-    qemu_bh_schedule(iocb->bh);
+    nvme_do_format(iocb);
 }
 
 static uint16_t nvme_format_check(NvmeNamespace *ns, uint8_t lbaf, uint8_t pi)
@@ -5842,9 +5845,8 @@ static uint16_t nvme_format_check(NvmeNamespace *ns, uint8_t lbaf, uint8_t pi)
     return NVME_SUCCESS;
 }
 
-static void nvme_format_bh(void *opaque)
+static void nvme_do_format(NvmeFormatAIOCB *iocb)
 {
-    NvmeFormatAIOCB *iocb = opaque;
     NvmeRequest *req = iocb->req;
     NvmeCtrl *n = nvme_ctrl(req);
     uint32_t dw10 = le32_to_cpu(req->cmd.cdw10);
@@ -5882,11 +5884,7 @@ static void nvme_format_bh(void *opaque)
     return;
 
 done:
-    qemu_bh_delete(iocb->bh);
-    iocb->bh = NULL;
-
     iocb->common.cb(iocb->common.opaque, iocb->ret);
-
     qemu_aio_unref(iocb);
 }
 
@@ -5905,7 +5903,6 @@ static uint16_t nvme_format(NvmeCtrl *n, NvmeRequest *req)
     iocb = qemu_aio_get(&nvme_format_aiocb_info, NULL, nvme_misc_cb, req);
 
     iocb->req = req;
-    iocb->bh = qemu_bh_new(nvme_format_bh, iocb);
     iocb->ret = 0;
     iocb->ns = NULL;
     iocb->nsid = 0;
@@ -5934,14 +5931,13 @@ static uint16_t nvme_format(NvmeCtrl *n, NvmeRequest *req)
     }
 
     req->aiocb = &iocb->common;
-    qemu_bh_schedule(iocb->bh);
+    nvme_do_format(iocb);
 
     return NVME_NO_COMPLETE;
 
 out:
-    qemu_bh_delete(iocb->bh);
-    iocb->bh = NULL;
     qemu_aio_unref(iocb);
+
     return status;
 }
 
-- 
2.38.1

