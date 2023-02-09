Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu,  9 Feb 2023 10:25:16 -0500
Message-Id: <20230209152520.434183-3-stefanha@redhat.com>
In-Reply-To: <20230209152520.434183-1-stefanha@redhat.com>
References: <20230209152520.434183-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 2/6] virtio-blk: add missing AioContext lock
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Emanuele Giuseppe Esposito <eesposit@redhat.com>, =?UTF-8?q?Luk=C3=A1=C5=A1=20Doktor?= <ldoktor@redhat.com>

From: Emanuele Giuseppe Esposito <eesposit@redhat.com>

virtio_blk_update_config() calls blk_get_geometry and blk_getlength,
and both functions eventually end up calling bdrv_poll_co when not
running in a coroutine:
- blk_getlength is a co_wrapper_mixed function
- blk_get_geometry calls bdrv_get_geometry -> bdrv_nb_sectors, a
  co_wrapper_mixed function too

Since we are not running in a coroutine, we need to take s->blk
AioContext lock, otherwise bdrv_poll_co will inevitably call
AIO_WAIT_WHILE and therefore try to un unlock() an AioContext lock
that was never acquired.

RHBZ: https://bugzilla.redhat.com/show_bug.cgi?id=2167838

Steps to reproduce the issue: simply boot a VM with
-object '{"qom-type":"iothread","id":"iothread1"}' \
-blockdev '{"driver":"file","filename":"$QCOW2","aio":"native","node-name":"libvirt-1-storage","cache":{"direct":true,"no-flush":false},"auto-read-only":true,"discard":"unmap"}' \
-blockdev '{"node-name":"libvirt-1-format","read-only":false,"cache":{"direct":true,"no-flush":false},"driver":"qcow2","file":"libvirt-1-storage"}' \
-device virtio-blk-pci,iothread=iothread1,drive=libvirt-1-format,id=virtio-disk0,bootindex=1,write-cache=on

and observe that it will fail not manage to boot with "qemu_mutex_unlock_impl: Operation not permitted"

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Lukáš Doktor <ldoktor@redhat.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20230208111148.1040083-1-eesposit@redhat.com>
---
 hw/block/virtio-blk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
index 1762517878..cefca93b31 100644
--- a/hw/block/virtio-blk.c
+++ b/hw/block/virtio-blk.c
@@ -894,6 +894,10 @@ static void virtio_blk_update_config(VirtIODevice *vdev, uint8_t *config)
     uint64_t capacity;
     int64_t length;
     int blk_size = conf->logical_block_size;
+    AioContext *ctx;
+
+    ctx = blk_get_aio_context(s->blk);
+    aio_context_acquire(ctx);
 
     blk_get_geometry(s->blk, &capacity);
     memset(&blkcfg, 0, sizeof(blkcfg));
@@ -917,6 +921,7 @@ static void virtio_blk_update_config(VirtIODevice *vdev, uint8_t *config)
      * per track (cylinder).
      */
     length = blk_getlength(s->blk);
+    aio_context_release(ctx);
     if (length > 0 && length / conf->heads / conf->secs % blk_size) {
         blkcfg.geometry.sectors = conf->secs & ~s->sector_mask;
     } else {
-- 
2.39.1

