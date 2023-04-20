Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu, 20 Apr 2023 08:09:40 -0400
Message-Id: <20230420120948.436661-13-stefanha@redhat.com>
In-Reply-To: <20230420120948.436661-1-stefanha@redhat.com>
References: <20230420120948.436661-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 12/20] block: introduce zone append write for
 zoned devices
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Julia Suvorova <jusual@redhat.com>, Eric Blake <eblake@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org, Cornelia Huck <cohuck@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Fam Zheng <fam@euphon.net>, Aarushi Mehta <mehta.aaru20@gmail.com>, Sam Li <faithilikerun@gmail.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>

From: Sam Li <faithilikerun@gmail.com>

A zone append command is a write operation that specifies the first
logical block of a zone as the write position. When writing to a zoned
block device using zone append, the byte offset of the call may point at
any position within the zone to which the data is being appended. Upon
completion the device will respond with the position where the data has
been written in the zone.

Signed-off-by: Sam Li <faithilikerun@gmail.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-id: 20230407081657.17947-3-faithilikerun@gmail.com
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/block/block-io.h          |  4 +++
 include/block/block_int-common.h  |  3 ++
 include/block/raw-aio.h           |  4 ++-
 include/sysemu/block-backend-io.h |  9 +++++
 block/block-backend.c             | 60 +++++++++++++++++++++++++++++++
 block/file-posix.c                | 58 ++++++++++++++++++++++++++----
 block/io.c                        | 27 ++++++++++++++
 block/io_uring.c                  |  4 +++
 block/linux-aio.c                 |  3 ++
 block/raw-format.c                |  8 +++++
 10 files changed, 172 insertions(+), 8 deletions(-)

diff --git a/include/block/block-io.h b/include/block/block-io.h
index 58f415ab64..f44e524a1c 100644
--- a/include/block/block-io.h
+++ b/include/block/block-io.h
@@ -119,6 +119,10 @@ int coroutine_fn GRAPH_RDLOCK bdrv_co_zone_report(BlockDriverState *bs,
 int coroutine_fn GRAPH_RDLOCK bdrv_co_zone_mgmt(BlockDriverState *bs,
                                                 BlockZoneOp op,
                                                 int64_t offset, int64_t len);
+int coroutine_fn GRAPH_RDLOCK bdrv_co_zone_append(BlockDriverState *bs,
+                                                  int64_t *offset,
+                                                  QEMUIOVector *qiov,
+                                                  BdrvRequestFlags flags);
 
 bool bdrv_can_write_zeroes_with_unmap(BlockDriverState *bs);
 int bdrv_block_status(BlockDriverState *bs, int64_t offset,
diff --git a/include/block/block_int-common.h b/include/block/block_int-common.h
index fba95181bd..06aea47480 100644
--- a/include/block/block_int-common.h
+++ b/include/block/block_int-common.h
@@ -722,6 +722,9 @@ struct BlockDriver {
             BlockZoneDescriptor *zones);
     int coroutine_fn (*bdrv_co_zone_mgmt)(BlockDriverState *bs, BlockZoneOp op,
             int64_t offset, int64_t len);
+    int coroutine_fn (*bdrv_co_zone_append)(BlockDriverState *bs,
+            int64_t *offset, QEMUIOVector *qiov,
+            BdrvRequestFlags flags);
 
     /* removable device specific */
     bool coroutine_fn GRAPH_RDLOCK_PTR (*bdrv_co_is_inserted)(
diff --git a/include/block/raw-aio.h b/include/block/raw-aio.h
index eda6a7a253..fb9c9f5a01 100644
--- a/include/block/raw-aio.h
+++ b/include/block/raw-aio.h
@@ -30,6 +30,7 @@
 #define QEMU_AIO_TRUNCATE     0x0080
 #define QEMU_AIO_ZONE_REPORT  0x0100
 #define QEMU_AIO_ZONE_MGMT    0x0200
+#define QEMU_AIO_ZONE_APPEND  0x0400
 #define QEMU_AIO_TYPE_MASK \
         (QEMU_AIO_READ | \
          QEMU_AIO_WRITE | \
@@ -40,7 +41,8 @@
          QEMU_AIO_COPY_RANGE | \
          QEMU_AIO_TRUNCATE | \
          QEMU_AIO_ZONE_REPORT | \
-         QEMU_AIO_ZONE_MGMT)
+         QEMU_AIO_ZONE_MGMT | \
+         QEMU_AIO_ZONE_APPEND)
 
 /* AIO flags */
 #define QEMU_AIO_MISALIGNED   0x1000
diff --git a/include/sysemu/block-backend-io.h b/include/sysemu/block-backend-io.h
index 097a7a3851..3122017bdf 100644
--- a/include/sysemu/block-backend-io.h
+++ b/include/sysemu/block-backend-io.h
@@ -53,6 +53,9 @@ BlockAIOCB *blk_aio_zone_report(BlockBackend *blk, int64_t offset,
 BlockAIOCB *blk_aio_zone_mgmt(BlockBackend *blk, BlockZoneOp op,
                               int64_t offset, int64_t len,
                               BlockCompletionFunc *cb, void *opaque);
+BlockAIOCB *blk_aio_zone_append(BlockBackend *blk, int64_t *offset,
+                                QEMUIOVector *qiov, BdrvRequestFlags flags,
+                                BlockCompletionFunc *cb, void *opaque);
 BlockAIOCB *blk_aio_pdiscard(BlockBackend *blk, int64_t offset, int64_t bytes,
                              BlockCompletionFunc *cb, void *opaque);
 void blk_aio_cancel_async(BlockAIOCB *acb);
@@ -203,6 +206,12 @@ int coroutine_fn blk_co_zone_mgmt(BlockBackend *blk, BlockZoneOp op,
                                   int64_t offset, int64_t len);
 int co_wrapper_mixed blk_zone_mgmt(BlockBackend *blk, BlockZoneOp op,
                                        int64_t offset, int64_t len);
+int coroutine_fn blk_co_zone_append(BlockBackend *blk, int64_t *offset,
+                                    QEMUIOVector *qiov,
+                                    BdrvRequestFlags flags);
+int co_wrapper_mixed blk_zone_append(BlockBackend *blk, int64_t *offset,
+                                         QEMUIOVector *qiov,
+                                         BdrvRequestFlags flags);
 
 int co_wrapper_mixed blk_pdiscard(BlockBackend *blk, int64_t offset,
                                   int64_t bytes);
diff --git a/block/block-backend.c b/block/block-backend.c
index 4475b8b085..6b2b92b7ff 100644
--- a/block/block-backend.c
+++ b/block/block-backend.c
@@ -1915,6 +1915,45 @@ BlockAIOCB *blk_aio_zone_mgmt(BlockBackend *blk, BlockZoneOp op,
     return &acb->common;
 }
 
+static void coroutine_fn blk_aio_zone_append_entry(void *opaque)
+{
+    BlkAioEmAIOCB *acb = opaque;
+    BlkRwCo *rwco = &acb->rwco;
+
+    rwco->ret = blk_co_zone_append(rwco->blk, (int64_t *)acb->bytes,
+                                   rwco->iobuf, rwco->flags);
+    blk_aio_complete(acb);
+}
+
+BlockAIOCB *blk_aio_zone_append(BlockBackend *blk, int64_t *offset,
+                                QEMUIOVector *qiov, BdrvRequestFlags flags,
+                                BlockCompletionFunc *cb, void *opaque) {
+    BlkAioEmAIOCB *acb;
+    Coroutine *co;
+    IO_CODE();
+
+    blk_inc_in_flight(blk);
+    acb = blk_aio_get(&blk_aio_em_aiocb_info, blk, cb, opaque);
+    acb->rwco = (BlkRwCo) {
+        .blk    = blk,
+        .ret    = NOT_DONE,
+        .flags  = flags,
+        .iobuf  = qiov,
+    };
+    acb->bytes = (int64_t)offset;
+    acb->has_returned = false;
+
+    co = qemu_coroutine_create(blk_aio_zone_append_entry, acb);
+    aio_co_enter(blk_get_aio_context(blk), co);
+    acb->has_returned = true;
+    if (acb->rwco.ret != NOT_DONE) {
+        replay_bh_schedule_oneshot_event(blk_get_aio_context(blk),
+                                         blk_aio_complete_bh, acb);
+    }
+
+    return &acb->common;
+}
+
 /*
  * Send a zone_report command.
  * offset is a byte offset from the start of the device. No alignment
@@ -1966,6 +2005,27 @@ int coroutine_fn blk_co_zone_mgmt(BlockBackend *blk, BlockZoneOp op,
     return ret;
 }
 
+/*
+ * Send a zone_append command.
+ */
+int coroutine_fn blk_co_zone_append(BlockBackend *blk, int64_t *offset,
+        QEMUIOVector *qiov, BdrvRequestFlags flags)
+{
+    int ret;
+    IO_CODE();
+
+    blk_inc_in_flight(blk);
+    blk_wait_while_drained(blk);
+    if (!blk_is_available(blk)) {
+        blk_dec_in_flight(blk);
+        return -ENOMEDIUM;
+    }
+
+    ret = bdrv_co_zone_append(blk_bs(blk), offset, qiov, flags);
+    blk_dec_in_flight(blk);
+    return ret;
+}
+
 void blk_drain(BlockBackend *blk)
 {
     BlockDriverState *bs = blk_bs(blk);
diff --git a/block/file-posix.c b/block/file-posix.c
index e6d0df052e..444b34dad2 100644
--- a/block/file-posix.c
+++ b/block/file-posix.c
@@ -160,6 +160,7 @@ typedef struct BDRVRawState {
     bool has_write_zeroes:1;
     bool use_linux_aio:1;
     bool use_linux_io_uring:1;
+    int64_t *offset; /* offset of zone append operation */
     int page_cache_inconsistent; /* errno from fdatasync failure */
     bool has_fallocate;
     bool needs_alignment;
@@ -1687,7 +1688,7 @@ static ssize_t handle_aiocb_rw_vector(RawPosixAIOData *aiocb)
     ssize_t len;
 
     len = RETRY_ON_EINTR(
-        (aiocb->aio_type & QEMU_AIO_WRITE) ?
+        (aiocb->aio_type & (QEMU_AIO_WRITE | QEMU_AIO_ZONE_APPEND)) ?
             qemu_pwritev(aiocb->aio_fildes,
                            aiocb->io.iov,
                            aiocb->io.niov,
@@ -1716,7 +1717,7 @@ static ssize_t handle_aiocb_rw_linear(RawPosixAIOData *aiocb, char *buf)
     ssize_t len;
 
     while (offset < aiocb->aio_nbytes) {
-        if (aiocb->aio_type & QEMU_AIO_WRITE) {
+        if (aiocb->aio_type & (QEMU_AIO_WRITE | QEMU_AIO_ZONE_APPEND)) {
             len = pwrite(aiocb->aio_fildes,
                          (const char *)buf + offset,
                          aiocb->aio_nbytes - offset,
@@ -1809,7 +1810,7 @@ static int handle_aiocb_rw(void *opaque)
     }
 
     nbytes = handle_aiocb_rw_linear(aiocb, buf);
-    if (!(aiocb->aio_type & QEMU_AIO_WRITE)) {
+    if (!(aiocb->aio_type & (QEMU_AIO_WRITE | QEMU_AIO_ZONE_APPEND))) {
         char *p = buf;
         size_t count = aiocb->aio_nbytes, copy;
         int i;
@@ -2444,8 +2445,12 @@ static int coroutine_fn raw_co_prw(BlockDriverState *bs, uint64_t offset,
     if (fd_open(bs) < 0)
         return -EIO;
 #if defined(CONFIG_BLKZONED)
-    if (type & QEMU_AIO_WRITE && bs->wps) {
+    if ((type & (QEMU_AIO_WRITE | QEMU_AIO_ZONE_APPEND)) && bs->wps) {
         qemu_co_mutex_lock(&bs->wps->colock);
+        if (type & QEMU_AIO_ZONE_APPEND && bs->bl.zone_size) {
+            int index = offset / bs->bl.zone_size;
+            offset = bs->wps->wp[index];
+        }
     }
 #endif
 
@@ -2493,9 +2498,13 @@ out:
 #if defined(CONFIG_BLKZONED)
     BlockZoneWps *wps = bs->wps;
     if (ret == 0) {
-        if (type & QEMU_AIO_WRITE && wps && bs->bl.zone_size) {
+        if ((type & (QEMU_AIO_WRITE | QEMU_AIO_ZONE_APPEND))
+            && wps && bs->bl.zone_size) {
             uint64_t *wp = &wps->wp[offset / bs->bl.zone_size];
             if (!BDRV_ZT_IS_CONV(*wp)) {
+                if (type & QEMU_AIO_ZONE_APPEND) {
+                    *s->offset = *wp;
+                }
                 /* Advance the wp if needed */
                 if (offset + bytes > *wp) {
                     *wp = offset + bytes;
@@ -2503,12 +2512,12 @@ out:
             }
         }
     } else {
-        if (type & QEMU_AIO_WRITE) {
+        if (type & (QEMU_AIO_WRITE | QEMU_AIO_ZONE_APPEND)) {
             update_zones_wp(bs, s->fd, 0, 1);
         }
     }
 
-    if (type & QEMU_AIO_WRITE && wps) {
+    if ((type & (QEMU_AIO_WRITE | QEMU_AIO_ZONE_APPEND)) && wps) {
         qemu_co_mutex_unlock(&wps->colock);
     }
 #endif
@@ -3511,6 +3520,40 @@ static int coroutine_fn raw_co_zone_mgmt(BlockDriverState *bs, BlockZoneOp op,
 }
 #endif
 
+#if defined(CONFIG_BLKZONED)
+static int coroutine_fn raw_co_zone_append(BlockDriverState *bs,
+                                           int64_t *offset,
+                                           QEMUIOVector *qiov,
+                                           BdrvRequestFlags flags) {
+    assert(flags == 0);
+    int64_t zone_size_mask = bs->bl.zone_size - 1;
+    int64_t iov_len = 0;
+    int64_t len = 0;
+    BDRVRawState *s = bs->opaque;
+    s->offset = offset;
+
+    if (*offset & zone_size_mask) {
+        error_report("sector offset %" PRId64 " is not aligned to zone size "
+                     "%" PRId32 "", *offset / 512, bs->bl.zone_size / 512);
+        return -EINVAL;
+    }
+
+    int64_t wg = bs->bl.write_granularity;
+    int64_t wg_mask = wg - 1;
+    for (int i = 0; i < qiov->niov; i++) {
+        iov_len = qiov->iov[i].iov_len;
+        if (iov_len & wg_mask) {
+            error_report("len of IOVector[%d] %" PRId64 " is not aligned to "
+                         "block size %" PRId64 "", i, iov_len, wg);
+            return -EINVAL;
+        }
+        len += iov_len;
+    }
+
+    return raw_co_prw(bs, *offset, len, qiov, QEMU_AIO_ZONE_APPEND);
+}
+#endif
+
 static coroutine_fn int
 raw_do_pdiscard(BlockDriverState *bs, int64_t offset, int64_t bytes,
                 bool blkdev)
@@ -4272,6 +4315,7 @@ static BlockDriver bdrv_host_device = {
     /* zone management operations */
     .bdrv_co_zone_report = raw_co_zone_report,
     .bdrv_co_zone_mgmt = raw_co_zone_mgmt,
+    .bdrv_co_zone_append = raw_co_zone_append,
 #endif
 };
 
diff --git a/block/io.c b/block/io.c
index ca941457d4..79e14b674c 100644
--- a/block/io.c
+++ b/block/io.c
@@ -3156,6 +3156,33 @@ out:
     return co.ret;
 }
 
+int coroutine_fn bdrv_co_zone_append(BlockDriverState *bs, int64_t *offset,
+                        QEMUIOVector *qiov,
+                        BdrvRequestFlags flags)
+{
+    int ret;
+    BlockDriver *drv = bs->drv;
+    CoroutineIOCompletion co = {
+            .coroutine = qemu_coroutine_self(),
+    };
+    IO_CODE();
+
+    ret = bdrv_check_qiov_request(*offset, qiov->size, qiov, 0, NULL);
+    if (ret < 0) {
+        return ret;
+    }
+
+    bdrv_inc_in_flight(bs);
+    if (!drv || !drv->bdrv_co_zone_append || bs->bl.zoned == BLK_Z_NONE) {
+        co.ret = -ENOTSUP;
+        goto out;
+    }
+    co.ret = drv->bdrv_co_zone_append(bs, offset, qiov, flags);
+out:
+    bdrv_dec_in_flight(bs);
+    return co.ret;
+}
+
 void *qemu_blockalign(BlockDriverState *bs, size_t size)
 {
     IO_CODE();
diff --git a/block/io_uring.c b/block/io_uring.c
index 973e15d876..f7488c241a 100644
--- a/block/io_uring.c
+++ b/block/io_uring.c
@@ -345,6 +345,10 @@ static int luring_do_submit(int fd, LuringAIOCB *luringcb, LuringState *s,
         io_uring_prep_writev(sqes, fd, luringcb->qiov->iov,
                              luringcb->qiov->niov, offset);
         break;
+    case QEMU_AIO_ZONE_APPEND:
+        io_uring_prep_writev(sqes, fd, luringcb->qiov->iov,
+                             luringcb->qiov->niov, offset);
+        break;
     case QEMU_AIO_READ:
         io_uring_prep_readv(sqes, fd, luringcb->qiov->iov,
                             luringcb->qiov->niov, offset);
diff --git a/block/linux-aio.c b/block/linux-aio.c
index d2cfb7f523..1959834156 100644
--- a/block/linux-aio.c
+++ b/block/linux-aio.c
@@ -389,6 +389,9 @@ static int laio_do_submit(int fd, struct qemu_laiocb *laiocb, off_t offset,
     case QEMU_AIO_WRITE:
         io_prep_pwritev(iocbs, fd, qiov->iov, qiov->niov, offset);
         break;
+    case QEMU_AIO_ZONE_APPEND:
+        io_prep_pwritev(iocbs, fd, qiov->iov, qiov->niov, offset);
+        break;
     case QEMU_AIO_READ:
         io_prep_preadv(iocbs, fd, qiov->iov, qiov->niov, offset);
         break;
diff --git a/block/raw-format.c b/block/raw-format.c
index 1a1dce8da4..9816f1af80 100644
--- a/block/raw-format.c
+++ b/block/raw-format.c
@@ -332,6 +332,13 @@ raw_co_zone_mgmt(BlockDriverState *bs, BlockZoneOp op,
     return bdrv_co_zone_mgmt(bs->file->bs, op, offset, len);
 }
 
+static int coroutine_fn GRAPH_RDLOCK
+raw_co_zone_append(BlockDriverState *bs,int64_t *offset, QEMUIOVector *qiov,
+                   BdrvRequestFlags flags)
+{
+    return bdrv_co_zone_append(bs->file->bs, offset, qiov, flags);
+}
+
 static int64_t coroutine_fn GRAPH_RDLOCK
 raw_co_getlength(BlockDriverState *bs)
 {
@@ -637,6 +644,7 @@ BlockDriver bdrv_raw = {
     .bdrv_co_pdiscard     = &raw_co_pdiscard,
     .bdrv_co_zone_report  = &raw_co_zone_report,
     .bdrv_co_zone_mgmt  = &raw_co_zone_mgmt,
+    .bdrv_co_zone_append = &raw_co_zone_append,
     .bdrv_co_block_status = &raw_co_block_status,
     .bdrv_co_copy_range_from = &raw_co_copy_range_from,
     .bdrv_co_copy_range_to  = &raw_co_copy_range_to,
-- 
2.39.2

