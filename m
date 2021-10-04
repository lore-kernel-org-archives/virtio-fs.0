DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=lizzy;
	h=Cc:To:Subject:Date:From:References:In-Reply-To:
	Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
	Content-Description; bh=gbyhVmoZkXJH8ENNg3VoBX0nDZYMIONufEqWD5tBHlk=;
	b=RnfjC
	KyPnNYMKQeWdNAoCwC9LVSEMeI0gFEmpsgRC5Wtq5l4dbsmFjBlA1TGt1tYhVAJHyemXwt09T24Gp
	AAtKkg4QORw7UA6mR7WTMufC4rrrYzgYiWxO2r2JWjBju2oFR3CCW1UPIgyufGiJV6c7YFFhWnHGb
	hOlQXkCDVyfTA9ipi+b7vIyfJVhehtB/ZflLaKQITec3DafyhemzFBNqCYVteXIfGpFJl1zPU5qZ9
	FB5vCObOk79q2z1Wj315k9/+x3fjEu+lsN5J2h9JfnpbZpPcaLGJdj3oo4by9YBgTcSstuNretXJM
	9G+AigDJ/frSWPmbYDNAOxjJMUmyQ==
Message-Id: <c9dea2e27ae19b2b9a51e8f08687067bf3e47bd5.1633376313.git.qemu_oss@crudebyte.com>
In-Reply-To: <cover.1633376313.git.qemu_oss@crudebyte.com>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Mon, 4 Oct 2021 21:38:04 +0200
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v2 1/3] virtio: turn VIRTQUEUE_MAX_SIZE into a
	variable
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Amit Shah <amit@kernel.org>, David Hildenbrand <david@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, Fam Zheng <fam@euphon.net>

Refactor VIRTQUEUE_MAX_SIZE to effectively become a runtime
variable per virtio user.

Reasons:

(1) VIRTQUEUE_MAX_SIZE should reflect the absolute theoretical
    maximum queue size possible. Which is actually the maximum
    queue size allowed by the virtio protocol. The appropriate
    value for VIRTQUEUE_MAX_SIZE would therefore be 32768:

    https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#x1-240006

    Apparently VIRTQUEUE_MAX_SIZE was instead defined with a
    more or less arbitrary value of 1024 in the past, which
    limits the maximum transfer size with virtio to 4M
    (more precise: 1024 * PAGE_SIZE, with the latter typically
    being 4k).

(2) Additionally the current value of 1024 poses a hidden limit,
    invisible to guest, which causes a system hang with the
    following QEMU error if guest tries to exceed it:

    virtio: too many write descriptors in indirect table

(3) Unfortunately not all virtio users in QEMU would currently
    work correctly with the new value of 32768.

So let's turn this hard coded global value into a runtime
variable as a first step in this commit, configurable for each
virtio user by passing a corresponding value with virtio_init()
call.

Signed-off-by: Christian Schoenebeck <qemu_oss@crudebyte.com>
---
 hw/9pfs/virtio-9p-device.c     |  3 ++-
 hw/block/vhost-user-blk.c      |  2 +-
 hw/block/virtio-blk.c          |  3 ++-
 hw/char/virtio-serial-bus.c    |  2 +-
 hw/display/virtio-gpu-base.c   |  2 +-
 hw/input/virtio-input.c        |  2 +-
 hw/net/virtio-net.c            | 15 ++++++++-------
 hw/scsi/virtio-scsi.c          |  2 +-
 hw/virtio/vhost-user-fs.c      |  2 +-
 hw/virtio/vhost-user-i2c.c     |  3 ++-
 hw/virtio/vhost-vsock-common.c |  2 +-
 hw/virtio/virtio-balloon.c     |  4 ++--
 hw/virtio/virtio-crypto.c      |  3 ++-
 hw/virtio/virtio-iommu.c       |  2 +-
 hw/virtio/virtio-mem.c         |  2 +-
 hw/virtio/virtio-pmem.c        |  2 +-
 hw/virtio/virtio-rng.c         |  2 +-
 hw/virtio/virtio.c             | 35 +++++++++++++++++++++++-----------
 include/hw/virtio/virtio.h     |  5 ++++-
 19 files changed, 57 insertions(+), 36 deletions(-)

diff --git a/hw/9pfs/virtio-9p-device.c b/hw/9pfs/virtio-9p-device.c
index 54ee93b71f..cd5d95dd51 100644
--- a/hw/9pfs/virtio-9p-device.c
+++ b/hw/9pfs/virtio-9p-device.c
@@ -216,7 +216,8 @@ static void virtio_9p_device_realize(DeviceState *dev, Error **errp)
     }
 
     v->config_size = sizeof(struct virtio_9p_config) + strlen(s->fsconf.tag);
-    virtio_init(vdev, "virtio-9p", VIRTIO_ID_9P, v->config_size);
+    virtio_init(vdev, "virtio-9p", VIRTIO_ID_9P, v->config_size,
+                VIRTQUEUE_MAX_SIZE);
     v->vq = virtio_add_queue(vdev, MAX_REQ, handle_9p_output);
 }
 
diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index ba13cb87e5..336f56705c 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -491,7 +491,7 @@ static void vhost_user_blk_device_realize(DeviceState *dev, Error **errp)
     }
 
     virtio_init(vdev, "virtio-blk", VIRTIO_ID_BLOCK,
-                sizeof(struct virtio_blk_config));
+                sizeof(struct virtio_blk_config), VIRTQUEUE_MAX_SIZE);
 
     s->virtqs = g_new(VirtQueue *, s->num_queues);
     for (i = 0; i < s->num_queues; i++) {
diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
index f139cd7cc9..9c0f46815c 100644
--- a/hw/block/virtio-blk.c
+++ b/hw/block/virtio-blk.c
@@ -1213,7 +1213,8 @@ static void virtio_blk_device_realize(DeviceState *dev, Error **errp)
 
     virtio_blk_set_config_size(s, s->host_features);
 
-    virtio_init(vdev, "virtio-blk", VIRTIO_ID_BLOCK, s->config_size);
+    virtio_init(vdev, "virtio-blk", VIRTIO_ID_BLOCK, s->config_size,
+                VIRTQUEUE_MAX_SIZE);
 
     s->blk = conf->conf.blk;
     s->rq = NULL;
diff --git a/hw/char/virtio-serial-bus.c b/hw/char/virtio-serial-bus.c
index f01ec2137c..9ad9111115 100644
--- a/hw/char/virtio-serial-bus.c
+++ b/hw/char/virtio-serial-bus.c
@@ -1045,7 +1045,7 @@ static void virtio_serial_device_realize(DeviceState *dev, Error **errp)
         config_size = offsetof(struct virtio_console_config, emerg_wr);
     }
     virtio_init(vdev, "virtio-serial", VIRTIO_ID_CONSOLE,
-                config_size);
+                config_size, VIRTQUEUE_MAX_SIZE);
 
     /* Spawn a new virtio-serial bus on which the ports will ride as devices */
     qbus_init(&vser->bus, sizeof(vser->bus), TYPE_VIRTIO_SERIAL_BUS,
diff --git a/hw/display/virtio-gpu-base.c b/hw/display/virtio-gpu-base.c
index c8da4806e0..20b06a7adf 100644
--- a/hw/display/virtio-gpu-base.c
+++ b/hw/display/virtio-gpu-base.c
@@ -171,7 +171,7 @@ virtio_gpu_base_device_realize(DeviceState *qdev,
 
     g->virtio_config.num_scanouts = cpu_to_le32(g->conf.max_outputs);
     virtio_init(VIRTIO_DEVICE(g), "virtio-gpu", VIRTIO_ID_GPU,
-                sizeof(struct virtio_gpu_config));
+                sizeof(struct virtio_gpu_config), VIRTQUEUE_MAX_SIZE);
 
     if (virtio_gpu_virgl_enabled(g->conf)) {
         /* use larger control queue in 3d mode */
diff --git a/hw/input/virtio-input.c b/hw/input/virtio-input.c
index 54bcb46c74..345eb2cce7 100644
--- a/hw/input/virtio-input.c
+++ b/hw/input/virtio-input.c
@@ -258,7 +258,7 @@ static void virtio_input_device_realize(DeviceState *dev, Error **errp)
     assert(vinput->cfg_size <= sizeof(virtio_input_config));
 
     virtio_init(vdev, "virtio-input", VIRTIO_ID_INPUT,
-                vinput->cfg_size);
+                vinput->cfg_size, VIRTQUEUE_MAX_SIZE);
     vinput->evt = virtio_add_queue(vdev, 64, virtio_input_handle_evt);
     vinput->sts = virtio_add_queue(vdev, 64, virtio_input_handle_sts);
 }
diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index f205331dcf..f74b5f6268 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -1746,9 +1746,9 @@ static ssize_t virtio_net_receive_rcu(NetClientState *nc, const uint8_t *buf,
     VirtIONet *n = qemu_get_nic_opaque(nc);
     VirtIONetQueue *q = virtio_net_get_subqueue(nc);
     VirtIODevice *vdev = VIRTIO_DEVICE(n);
-    VirtQueueElement *elems[VIRTQUEUE_MAX_SIZE];
-    size_t lens[VIRTQUEUE_MAX_SIZE];
-    struct iovec mhdr_sg[VIRTQUEUE_MAX_SIZE];
+    VirtQueueElement *elems[vdev->queue_max_size];
+    size_t lens[vdev->queue_max_size];
+    struct iovec mhdr_sg[vdev->queue_max_size];
     struct virtio_net_hdr_mrg_rxbuf mhdr;
     unsigned mhdr_cnt = 0;
     size_t offset, i, guest_offset, j;
@@ -1783,7 +1783,7 @@ static ssize_t virtio_net_receive_rcu(NetClientState *nc, const uint8_t *buf,
 
         total = 0;
 
-        if (i == VIRTQUEUE_MAX_SIZE) {
+        if (i == vdev->queue_max_size) {
             virtio_error(vdev, "virtio-net unexpected long buffer chain");
             err = size;
             goto err;
@@ -2532,7 +2532,7 @@ static int32_t virtio_net_flush_tx(VirtIONetQueue *q)
     for (;;) {
         ssize_t ret;
         unsigned int out_num;
-        struct iovec sg[VIRTQUEUE_MAX_SIZE], sg2[VIRTQUEUE_MAX_SIZE + 1], *out_sg;
+        struct iovec sg[vdev->queue_max_size], sg2[vdev->queue_max_size + 1], *out_sg;
         struct virtio_net_hdr_mrg_rxbuf mhdr;
 
         elem = virtqueue_pop(q->tx_vq, sizeof(VirtQueueElement));
@@ -2564,7 +2564,7 @@ static int32_t virtio_net_flush_tx(VirtIONetQueue *q)
                 out_num = iov_copy(&sg2[1], ARRAY_SIZE(sg2) - 1,
                                    out_sg, out_num,
                                    n->guest_hdr_len, -1);
-                if (out_num == VIRTQUEUE_MAX_SIZE) {
+                if (out_num == vdev->queue_max_size) {
                     goto drop;
                 }
                 out_num += 1;
@@ -3364,7 +3364,8 @@ static void virtio_net_device_realize(DeviceState *dev, Error **errp)
     }
 
     virtio_net_set_config_size(n, n->host_features);
-    virtio_init(vdev, "virtio-net", VIRTIO_ID_NET, n->config_size);
+    virtio_init(vdev, "virtio-net", VIRTIO_ID_NET, n->config_size,
+                VIRTQUEUE_MAX_SIZE);
 
     /*
      * We set a lower limit on RX queue size to what it always was.
diff --git a/hw/scsi/virtio-scsi.c b/hw/scsi/virtio-scsi.c
index 51fd09522a..5e5e657e1d 100644
--- a/hw/scsi/virtio-scsi.c
+++ b/hw/scsi/virtio-scsi.c
@@ -973,7 +973,7 @@ void virtio_scsi_common_realize(DeviceState *dev,
     int i;
 
     virtio_init(vdev, "virtio-scsi", VIRTIO_ID_SCSI,
-                sizeof(VirtIOSCSIConfig));
+                sizeof(VirtIOSCSIConfig), VIRTQUEUE_MAX_SIZE);
 
     if (s->conf.num_queues == VIRTIO_SCSI_AUTO_NUM_QUEUES) {
         s->conf.num_queues = 1;
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index c595957983..ae1672d667 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -220,7 +220,7 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
     }
 
     virtio_init(vdev, "vhost-user-fs", VIRTIO_ID_FS,
-                sizeof(struct virtio_fs_config));
+                sizeof(struct virtio_fs_config), VIRTQUEUE_MAX_SIZE);
 
     /* Hiprio queue */
     fs->hiprio_vq = virtio_add_queue(vdev, fs->conf.queue_size, vuf_handle_output);
diff --git a/hw/virtio/vhost-user-i2c.c b/hw/virtio/vhost-user-i2c.c
index d172632bb0..eeb1d8853a 100644
--- a/hw/virtio/vhost-user-i2c.c
+++ b/hw/virtio/vhost-user-i2c.c
@@ -220,7 +220,8 @@ static void vu_i2c_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    virtio_init(vdev, "vhost-user-i2c", VIRTIO_ID_I2C_ADAPTER, 0);
+    virtio_init(vdev, "vhost-user-i2c", VIRTIO_ID_I2C_ADAPTER, 0,
+                VIRTQUEUE_MAX_SIZE);
 
     i2c->vhost_dev.nvqs = 1;
     i2c->vq = virtio_add_queue(vdev, 4, vu_i2c_handle_output);
diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
index 4ad6e234ad..a81fa884a8 100644
--- a/hw/virtio/vhost-vsock-common.c
+++ b/hw/virtio/vhost-vsock-common.c
@@ -201,7 +201,7 @@ void vhost_vsock_common_realize(VirtIODevice *vdev, const char *name)
     VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
 
     virtio_init(vdev, name, VIRTIO_ID_VSOCK,
-                sizeof(struct virtio_vsock_config));
+                sizeof(struct virtio_vsock_config), VIRTQUEUE_MAX_SIZE);
 
     /* Receive and transmit queues belong to vhost */
     vvc->recv_vq = virtio_add_queue(vdev, VHOST_VSOCK_QUEUE_SIZE,
diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
index 5a69dce35d..067c73223d 100644
--- a/hw/virtio/virtio-balloon.c
+++ b/hw/virtio/virtio-balloon.c
@@ -886,7 +886,7 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
     int ret;
 
     virtio_init(vdev, "virtio-balloon", VIRTIO_ID_BALLOON,
-                virtio_balloon_config_size(s));
+                virtio_balloon_config_size(s), VIRTQUEUE_MAX_SIZE);
 
     ret = qemu_add_balloon_handler(virtio_balloon_to_target,
                                    virtio_balloon_stat, s);
@@ -909,7 +909,7 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
     s->svq = virtio_add_queue(vdev, 128, virtio_balloon_receive_stats);
 
     if (virtio_has_feature(s->host_features, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
-        s->free_page_vq = virtio_add_queue(vdev, VIRTQUEUE_MAX_SIZE,
+        s->free_page_vq = virtio_add_queue(vdev, vdev->queue_max_size,
                                            virtio_balloon_handle_free_page_vq);
         precopy_add_notifier(&s->free_page_hint_notify);
 
diff --git a/hw/virtio/virtio-crypto.c b/hw/virtio/virtio-crypto.c
index 54f9bbb789..1e70d4d2a8 100644
--- a/hw/virtio/virtio-crypto.c
+++ b/hw/virtio/virtio-crypto.c
@@ -810,7 +810,8 @@ static void virtio_crypto_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    virtio_init(vdev, "virtio-crypto", VIRTIO_ID_CRYPTO, vcrypto->config_size);
+    virtio_init(vdev, "virtio-crypto", VIRTIO_ID_CRYPTO, vcrypto->config_size,
+                VIRTQUEUE_MAX_SIZE);
     vcrypto->curr_queues = 1;
     vcrypto->vqs = g_malloc0(sizeof(VirtIOCryptoQueue) * vcrypto->max_queues);
     for (i = 0; i < vcrypto->max_queues; i++) {
diff --git a/hw/virtio/virtio-iommu.c b/hw/virtio/virtio-iommu.c
index 1b23e8e18c..ca360e74eb 100644
--- a/hw/virtio/virtio-iommu.c
+++ b/hw/virtio/virtio-iommu.c
@@ -974,7 +974,7 @@ static void virtio_iommu_device_realize(DeviceState *dev, Error **errp)
     VirtIOIOMMU *s = VIRTIO_IOMMU(dev);
 
     virtio_init(vdev, "virtio-iommu", VIRTIO_ID_IOMMU,
-                sizeof(struct virtio_iommu_config));
+                sizeof(struct virtio_iommu_config), VIRTQUEUE_MAX_SIZE);
 
     memset(s->iommu_pcibus_by_bus_num, 0, sizeof(s->iommu_pcibus_by_bus_num));
 
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index df91e454b2..1d9d01b871 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -738,7 +738,7 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
     vmem->bitmap = bitmap_new(vmem->bitmap_size);
 
     virtio_init(vdev, TYPE_VIRTIO_MEM, VIRTIO_ID_MEM,
-                sizeof(struct virtio_mem_config));
+                sizeof(struct virtio_mem_config), VIRTQUEUE_MAX_SIZE);
     vmem->vq = virtio_add_queue(vdev, 128, virtio_mem_handle_request);
 
     host_memory_backend_set_mapped(vmem->memdev, true);
diff --git a/hw/virtio/virtio-pmem.c b/hw/virtio/virtio-pmem.c
index d1aeb90a31..82b54b00c5 100644
--- a/hw/virtio/virtio-pmem.c
+++ b/hw/virtio/virtio-pmem.c
@@ -124,7 +124,7 @@ static void virtio_pmem_realize(DeviceState *dev, Error **errp)
 
     host_memory_backend_set_mapped(pmem->memdev, true);
     virtio_init(vdev, TYPE_VIRTIO_PMEM, VIRTIO_ID_PMEM,
-                sizeof(struct virtio_pmem_config));
+                sizeof(struct virtio_pmem_config), VIRTQUEUE_MAX_SIZE);
     pmem->rq_vq = virtio_add_queue(vdev, 128, virtio_pmem_flush);
 }
 
diff --git a/hw/virtio/virtio-rng.c b/hw/virtio/virtio-rng.c
index cc8e9f775d..0e91d60106 100644
--- a/hw/virtio/virtio-rng.c
+++ b/hw/virtio/virtio-rng.c
@@ -215,7 +215,7 @@ static void virtio_rng_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    virtio_init(vdev, "virtio-rng", VIRTIO_ID_RNG, 0);
+    virtio_init(vdev, "virtio-rng", VIRTIO_ID_RNG, 0, VIRTQUEUE_MAX_SIZE);
 
     vrng->vq = virtio_add_queue(vdev, 8, handle_input);
     vrng->quota_remaining = vrng->conf.max_bytes;
diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 240759ff0b..60e094d96a 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -1419,8 +1419,8 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
     VirtIODevice *vdev = vq->vdev;
     VirtQueueElement *elem = NULL;
     unsigned out_num, in_num, elem_entries;
-    hwaddr addr[VIRTQUEUE_MAX_SIZE];
-    struct iovec iov[VIRTQUEUE_MAX_SIZE];
+    hwaddr addr[vdev->queue_max_size];
+    struct iovec iov[vdev->queue_max_size];
     VRingDesc desc;
     int rc;
 
@@ -1492,7 +1492,7 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
         if (desc.flags & VRING_DESC_F_WRITE) {
             map_ok = virtqueue_map_desc(vdev, &in_num, addr + out_num,
                                         iov + out_num,
-                                        VIRTQUEUE_MAX_SIZE - out_num, true,
+                                        vdev->queue_max_size - out_num, true,
                                         desc.addr, desc.len);
         } else {
             if (in_num) {
@@ -1500,7 +1500,7 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
                 goto err_undo_map;
             }
             map_ok = virtqueue_map_desc(vdev, &out_num, addr, iov,
-                                        VIRTQUEUE_MAX_SIZE, false,
+                                        vdev->queue_max_size, false,
                                         desc.addr, desc.len);
         }
         if (!map_ok) {
@@ -1556,8 +1556,8 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
     VirtIODevice *vdev = vq->vdev;
     VirtQueueElement *elem = NULL;
     unsigned out_num, in_num, elem_entries;
-    hwaddr addr[VIRTQUEUE_MAX_SIZE];
-    struct iovec iov[VIRTQUEUE_MAX_SIZE];
+    hwaddr addr[vdev->queue_max_size];
+    struct iovec iov[vdev->queue_max_size];
     VRingPackedDesc desc;
     uint16_t id;
     int rc;
@@ -1620,7 +1620,7 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
         if (desc.flags & VRING_DESC_F_WRITE) {
             map_ok = virtqueue_map_desc(vdev, &in_num, addr + out_num,
                                         iov + out_num,
-                                        VIRTQUEUE_MAX_SIZE - out_num, true,
+                                        vdev->queue_max_size - out_num, true,
                                         desc.addr, desc.len);
         } else {
             if (in_num) {
@@ -1628,7 +1628,7 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
                 goto err_undo_map;
             }
             map_ok = virtqueue_map_desc(vdev, &out_num, addr, iov,
-                                        VIRTQUEUE_MAX_SIZE, false,
+                                        vdev->queue_max_size, false,
                                         desc.addr, desc.len);
         }
         if (!map_ok) {
@@ -2249,7 +2249,7 @@ void virtio_queue_set_num(VirtIODevice *vdev, int n, int num)
      * nonexistent states, or to set it to an invalid size.
      */
     if (!!num != !!vdev->vq[n].vring.num ||
-        num > VIRTQUEUE_MAX_SIZE ||
+        num > vdev->queue_max_size ||
         num < 0) {
         return;
     }
@@ -2400,7 +2400,7 @@ VirtQueue *virtio_add_queue(VirtIODevice *vdev, int queue_size,
             break;
     }
 
-    if (i == VIRTIO_QUEUE_MAX || queue_size > VIRTQUEUE_MAX_SIZE)
+    if (i == VIRTIO_QUEUE_MAX || queue_size > vdev->queue_max_size)
         abort();
 
     vdev->vq[i].vring.num = queue_size;
@@ -3239,13 +3239,25 @@ void virtio_instance_init_common(Object *proxy_obj, void *data,
 }
 
 void virtio_init(VirtIODevice *vdev, const char *name,
-                 uint16_t device_id, size_t config_size)
+                 uint16_t device_id, size_t config_size,
+                 uint16_t queue_max_size)
 {
     BusState *qbus = qdev_get_parent_bus(DEVICE(vdev));
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
     int i;
     int nvectors = k->query_nvectors ? k->query_nvectors(qbus->parent) : 0;
 
+    if (queue_max_size > VIRTQUEUE_MAX_SIZE ||
+        !is_power_of_2(queue_max_size))
+    {
+        error_report(
+            "virtio: invalid queue_max_size (= %" PRIu16 "), must be a "
+            "power of 2 and between 1 ... %d.",
+            queue_max_size, VIRTQUEUE_MAX_SIZE
+        );
+        abort();
+    }
+
     if (nvectors) {
         vdev->vector_queues =
             g_malloc0(sizeof(*vdev->vector_queues) * nvectors);
@@ -3258,6 +3270,7 @@ void virtio_init(VirtIODevice *vdev, const char *name,
     qatomic_set(&vdev->isr, 0);
     vdev->queue_sel = 0;
     vdev->config_vector = VIRTIO_NO_VECTOR;
+    vdev->queue_max_size = queue_max_size;
     vdev->vq = g_malloc0(sizeof(VirtQueue) * VIRTIO_QUEUE_MAX);
     vdev->vm_running = runstate_is_running();
     vdev->broken = false;
diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 8bab9cfb75..a37d1f7d52 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -89,6 +89,7 @@ struct VirtIODevice
     size_t config_len;
     void *config;
     uint16_t config_vector;
+    uint16_t queue_max_size;
     uint32_t generation;
     int nvectors;
     VirtQueue *vq;
@@ -166,7 +167,9 @@ void virtio_instance_init_common(Object *proxy_obj, void *data,
                                  size_t vdev_size, const char *vdev_name);
 
 void virtio_init(VirtIODevice *vdev, const char *name,
-                         uint16_t device_id, size_t config_size);
+                 uint16_t device_id, size_t config_size,
+                 uint16_t queue_max_size);
+
 void virtio_cleanup(VirtIODevice *vdev);
 
 void virtio_error(VirtIODevice *vdev, const char *fmt, ...) GCC_FMT_ATTR(2, 3);
-- 
2.20.1

