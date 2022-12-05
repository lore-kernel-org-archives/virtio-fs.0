Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:51:58 +0100
Message-Id: <20221205095228.1314-22-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 21/51] hw/nvme: remove copy bh scheduling
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

Fix a potential use-after-free by removing the bottom half and enqueuing
the completion directly.

Fixes: 796d20681d9b ("hw/nvme: reimplement the copy command to allow aio cancellation")
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Klaus Jensen <k.jensen@samsung.com>
---
 hw/nvme/ctrl.c | 63 +++++++++++---------------------------------------
 1 file changed, 14 insertions(+), 49 deletions(-)

diff --git a/hw/nvme/ctrl.c b/hw/nvme/ctrl.c
index e847b89461..e54276dc1d 100644
--- a/hw/nvme/ctrl.c
+++ b/hw/nvme/ctrl.c
@@ -2552,7 +2552,6 @@ typedef struct NvmeCopyAIOCB {
     BlockAIOCB common;
     BlockAIOCB *aiocb;
     NvmeRequest *req;
-    QEMUBH *bh;
     int ret;
 
     void *ranges;
@@ -2590,9 +2589,8 @@ static const AIOCBInfo nvme_copy_aiocb_info = {
     .cancel_async = nvme_copy_cancel,
 };
 
-static void nvme_copy_bh(void *opaque)
+static void nvme_copy_done(NvmeCopyAIOCB *iocb)
 {
-    NvmeCopyAIOCB *iocb = opaque;
     NvmeRequest *req = iocb->req;
     NvmeNamespace *ns = req->ns;
     BlockAcctStats *stats = blk_get_stats(ns->blkconf.blk);
@@ -2604,9 +2602,6 @@ static void nvme_copy_bh(void *opaque)
     qemu_iovec_destroy(&iocb->iov);
     g_free(iocb->bounce);
 
-    qemu_bh_delete(iocb->bh);
-    iocb->bh = NULL;
-
     if (iocb->ret < 0) {
         block_acct_failed(stats, &iocb->acct.read);
         block_acct_failed(stats, &iocb->acct.write);
@@ -2619,7 +2614,7 @@ static void nvme_copy_bh(void *opaque)
     qemu_aio_unref(iocb);
 }
 
-static void nvme_copy_cb(void *opaque, int ret);
+static void nvme_do_copy(NvmeCopyAIOCB *iocb);
 
 static void nvme_copy_source_range_parse_format0(void *ranges, int idx,
                                                  uint64_t *slba, uint32_t *nlb,
@@ -2731,7 +2726,7 @@ static void nvme_copy_out_completed_cb(void *opaque, int ret)
     iocb->idx++;
     iocb->slba += nlb;
 out:
-    nvme_copy_cb(iocb, iocb->ret);
+    nvme_do_copy(iocb);
 }
 
 static void nvme_copy_out_cb(void *opaque, int ret)
@@ -2743,16 +2738,8 @@ static void nvme_copy_out_cb(void *opaque, int ret)
     size_t mlen;
     uint8_t *mbounce;
 
-    if (ret < 0) {
-        iocb->ret = ret;
+    if (ret < 0 || iocb->ret < 0 || !ns->lbaf.ms) {
         goto out;
-    } else if (iocb->ret < 0) {
-        goto out;
-    }
-
-    if (!ns->lbaf.ms) {
-        nvme_copy_out_completed_cb(iocb, 0);
-        return;
     }
 
     nvme_copy_source_range_parse(iocb->ranges, iocb->idx, iocb->format, NULL,
@@ -2771,7 +2758,7 @@ static void nvme_copy_out_cb(void *opaque, int ret)
     return;
 
 out:
-    nvme_copy_cb(iocb, ret);
+    nvme_copy_out_completed_cb(iocb, ret);
 }
 
 static void nvme_copy_in_completed_cb(void *opaque, int ret)
@@ -2865,15 +2852,9 @@ static void nvme_copy_in_completed_cb(void *opaque, int ret)
 
 invalid:
     req->status = status;
-    iocb->aiocb = NULL;
-    if (iocb->bh) {
-        qemu_bh_schedule(iocb->bh);
-    }
-
-    return;
-
+    iocb->ret = -1;
 out:
-    nvme_copy_cb(iocb, ret);
+    nvme_do_copy(iocb);
 }
 
 static void nvme_copy_in_cb(void *opaque, int ret)
@@ -2884,16 +2865,8 @@ static void nvme_copy_in_cb(void *opaque, int ret)
     uint64_t slba;
     uint32_t nlb;
 
-    if (ret < 0) {
-        iocb->ret = ret;
+    if (ret < 0 || iocb->ret < 0 || !ns->lbaf.ms) {
         goto out;
-    } else if (iocb->ret < 0) {
-        goto out;
-    }
-
-    if (!ns->lbaf.ms) {
-        nvme_copy_in_completed_cb(iocb, 0);
-        return;
     }
 
     nvme_copy_source_range_parse(iocb->ranges, iocb->idx, iocb->format, &slba,
@@ -2909,12 +2882,11 @@ static void nvme_copy_in_cb(void *opaque, int ret)
     return;
 
 out:
-    nvme_copy_cb(iocb, iocb->ret);
+    nvme_copy_in_completed_cb(iocb, ret);
 }
 
-static void nvme_copy_cb(void *opaque, int ret)
+static void nvme_do_copy(NvmeCopyAIOCB *iocb)
 {
-    NvmeCopyAIOCB *iocb = opaque;
     NvmeRequest *req = iocb->req;
     NvmeNamespace *ns = req->ns;
     uint64_t slba;
@@ -2922,10 +2894,7 @@ static void nvme_copy_cb(void *opaque, int ret)
     size_t len;
     uint16_t status;
 
-    if (ret < 0) {
-        iocb->ret = ret;
-        goto done;
-    } else if (iocb->ret < 0) {
+    if (iocb->ret < 0) {
         goto done;
     }
 
@@ -2972,14 +2941,11 @@ static void nvme_copy_cb(void *opaque, int ret)
 
 invalid:
     req->status = status;
+    iocb->ret = -1;
 done:
-    iocb->aiocb = NULL;
-    if (iocb->bh) {
-        qemu_bh_schedule(iocb->bh);
-    }
+    nvme_copy_done(iocb);
 }
 
-
 static uint16_t nvme_copy(NvmeCtrl *n, NvmeRequest *req)
 {
     NvmeNamespace *ns = req->ns;
@@ -3049,7 +3015,6 @@ static uint16_t nvme_copy(NvmeCtrl *n, NvmeRequest *req)
     }
 
     iocb->req = req;
-    iocb->bh = qemu_bh_new(nvme_copy_bh, iocb);
     iocb->ret = 0;
     iocb->nr = nr;
     iocb->idx = 0;
@@ -3066,7 +3031,7 @@ static uint16_t nvme_copy(NvmeCtrl *n, NvmeRequest *req)
                      BLOCK_ACCT_WRITE);
 
     req->aiocb = &iocb->common;
-    nvme_copy_cb(iocb, 0);
+    nvme_do_copy(iocb);
 
     return NVME_NO_COMPLETE;
 
-- 
2.38.1

