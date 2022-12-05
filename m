Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:51:56 +0100
Message-Id: <20221205095228.1314-20-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 19/51] hw/nvme: fix aio cancel in zone reset
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

If the zone reset operation is cancelled but the block unmap operation
completes normally, the callback will continue resetting the next zone
since it neglects to check iocb->ret which will have been set to
-ECANCELED. Make sure that this is checked and bail out if an error is
present.

Secondly, fix a potential use-after-free by removing the bottom half and
enqueuing the completion directly.

Fixes: 63d96e4ffd71 ("hw/nvme: reimplement zone reset to allow cancellation")
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Klaus Jensen <k.jensen@samsung.com>
---
 hw/nvme/ctrl.c | 36 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/hw/nvme/ctrl.c b/hw/nvme/ctrl.c
index fede5af6af..bf4abf73f7 100644
--- a/hw/nvme/ctrl.c
+++ b/hw/nvme/ctrl.c
@@ -3712,7 +3712,6 @@ typedef struct NvmeZoneResetAIOCB {
     BlockAIOCB common;
     BlockAIOCB *aiocb;
     NvmeRequest *req;
-    QEMUBH *bh;
     int ret;
 
     bool all;
@@ -3741,17 +3740,6 @@ static const AIOCBInfo nvme_zone_reset_aiocb_info = {
     .cancel_async = nvme_zone_reset_cancel,
 };
 
-static void nvme_zone_reset_bh(void *opaque)
-{
-    NvmeZoneResetAIOCB *iocb = opaque;
-
-    iocb->common.cb(iocb->common.opaque, iocb->ret);
-
-    qemu_bh_delete(iocb->bh);
-    iocb->bh = NULL;
-    qemu_aio_unref(iocb);
-}
-
 static void nvme_zone_reset_cb(void *opaque, int ret);
 
 static void nvme_zone_reset_epilogue_cb(void *opaque, int ret)
@@ -3762,14 +3750,8 @@ static void nvme_zone_reset_epilogue_cb(void *opaque, int ret)
     int64_t moff;
     int count;
 
-    if (ret < 0) {
-        nvme_zone_reset_cb(iocb, ret);
-        return;
-    }
-
-    if (!ns->lbaf.ms) {
-        nvme_zone_reset_cb(iocb, 0);
-        return;
+    if (ret < 0 || iocb->ret < 0 || !ns->lbaf.ms) {
+        goto out;
     }
 
     moff = nvme_moff(ns, iocb->zone->d.zslba);
@@ -3779,6 +3761,9 @@ static void nvme_zone_reset_epilogue_cb(void *opaque, int ret)
                                         BDRV_REQ_MAY_UNMAP,
                                         nvme_zone_reset_cb, iocb);
     return;
+
+out:
+    nvme_zone_reset_cb(iocb, ret);
 }
 
 static void nvme_zone_reset_cb(void *opaque, int ret)
@@ -3787,7 +3772,9 @@ static void nvme_zone_reset_cb(void *opaque, int ret)
     NvmeRequest *req = iocb->req;
     NvmeNamespace *ns = req->ns;
 
-    if (ret < 0) {
+    if (iocb->ret < 0) {
+        goto done;
+    } else if (ret < 0) {
         iocb->ret = ret;
         goto done;
     }
@@ -3835,9 +3822,9 @@ static void nvme_zone_reset_cb(void *opaque, int ret)
 
 done:
     iocb->aiocb = NULL;
-    if (iocb->bh) {
-        qemu_bh_schedule(iocb->bh);
-    }
+
+    iocb->common.cb(iocb->common.opaque, iocb->ret);
+    qemu_aio_unref(iocb);
 }
 
 static uint16_t nvme_zone_mgmt_send_zrwa_flush(NvmeCtrl *n, NvmeZone *zone,
@@ -3942,7 +3929,6 @@ static uint16_t nvme_zone_mgmt_send(NvmeCtrl *n, NvmeRequest *req)
                            nvme_misc_cb, req);
 
         iocb->req = req;
-        iocb->bh = qemu_bh_new(nvme_zone_reset_bh, iocb);
         iocb->ret = 0;
         iocb->all = all;
         iocb->idx = zone_idx;
-- 
2.38.1

