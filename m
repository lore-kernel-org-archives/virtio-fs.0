Date: Tue, 5 Oct 2021 09:35:54 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20211005093554.6d6eff10@bahia.huguette>
In-Reply-To: <20211005031333-mutt-send-email-mst@kernel.org>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<d39e127ecae12fa18bf01d1e405eb4010a275cf5.1633376313.git.qemu_oss@crudebyte.com>
	<20211005031333-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v2 2/3] virtio: increase VIRTQUEUE_MAX_SIZE
	to 32k
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, Gerd, Amit Shah <amit@kernel.org>, Jason Wang <jasowang@redhat.com>, Hildenbrand <david@redhat.com>, Christian Schoenebeck <qemu_oss@crudebyte.com>, qemu-devel@nongnu.org, Raphael Norwitz <raphael.norwitz@nutanix.com>, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Hoffmann <kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>, Fam Zheng <fam@euphon.net>, David

On Tue, 5 Oct 2021 03:16:07 -0400
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Oct 04, 2021 at 09:38:08PM +0200, Christian Schoenebeck wrote:
> > Raise the maximum possible virtio transfer size to 128M
> > (more precisely: 32k * PAGE_SIZE). See previous commit for a
> > more detailed explanation for the reasons of this change.
> > 
> > For not breaking any virtio user, all virtio users transition
> > to using the new macro VIRTQUEUE_LEGACY_MAX_SIZE instead of
> > VIRTQUEUE_MAX_SIZE, so they are all still using the old value
> > of 1k with this commit.
> > 
> > On the long-term, each virtio user should subsequently either
> > switch from VIRTQUEUE_LEGACY_MAX_SIZE to VIRTQUEUE_MAX_SIZE
> > after checking that they support the new value of 32k, or
> > otherwise they should replace the VIRTQUEUE_LEGACY_MAX_SIZE
> > macro by an appropriate value supported by them.
> > 
> > Signed-off-by: Christian Schoenebeck <qemu_oss@crudebyte.com>
> 
> 
> I don't think we need this. Legacy isn't descriptive either.  Just leave
> VIRTQUEUE_MAX_SIZE alone, and come up with a new name for 32k.
> 

Yes I agree. Only virtio-9p is going to benefit from the new
size in the short/medium term, so it looks a bit excessive to
patch all devices. Also in the end, you end up reverting the name
change in the last patch for virtio-9p... which is a indication
that this patch does too much.

Introduce the new macro in virtio-9p and use it only there.

> > ---
> >  hw/9pfs/virtio-9p-device.c     |  2 +-
> >  hw/block/vhost-user-blk.c      |  6 +++---
> >  hw/block/virtio-blk.c          |  6 +++---
> >  hw/char/virtio-serial-bus.c    |  2 +-
> >  hw/input/virtio-input.c        |  2 +-
> >  hw/net/virtio-net.c            | 12 ++++++------
> >  hw/scsi/virtio-scsi.c          |  2 +-
> >  hw/virtio/vhost-user-fs.c      |  6 +++---
> >  hw/virtio/vhost-user-i2c.c     |  2 +-
> >  hw/virtio/vhost-vsock-common.c |  2 +-
> >  hw/virtio/virtio-balloon.c     |  2 +-
> >  hw/virtio/virtio-crypto.c      |  2 +-
> >  hw/virtio/virtio-iommu.c       |  2 +-
> >  hw/virtio/virtio-mem.c         |  2 +-
> >  hw/virtio/virtio-mmio.c        |  4 ++--
> >  hw/virtio/virtio-pmem.c        |  2 +-
> >  hw/virtio/virtio-rng.c         |  3 ++-
> >  include/hw/virtio/virtio.h     | 20 +++++++++++++++++++-
> >  18 files changed, 49 insertions(+), 30 deletions(-)
> > 
> > diff --git a/hw/9pfs/virtio-9p-device.c b/hw/9pfs/virtio-9p-device.c
> > index cd5d95dd51..9013e7df6e 100644
> > --- a/hw/9pfs/virtio-9p-device.c
> > +++ b/hw/9pfs/virtio-9p-device.c
> > @@ -217,7 +217,7 @@ static void virtio_9p_device_realize(DeviceState *dev, Error **errp)
> >  
> >      v->config_size = sizeof(struct virtio_9p_config) + strlen(s->fsconf.tag);
> >      virtio_init(vdev, "virtio-9p", VIRTIO_ID_9P, v->config_size,
> > -                VIRTQUEUE_MAX_SIZE);
> > +                VIRTQUEUE_LEGACY_MAX_SIZE);
> >      v->vq = virtio_add_queue(vdev, MAX_REQ, handle_9p_output);
> >  }
> >  
> > diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> > index 336f56705c..e5e45262ab 100644
> > --- a/hw/block/vhost-user-blk.c
> > +++ b/hw/block/vhost-user-blk.c
> > @@ -480,9 +480,9 @@ static void vhost_user_blk_device_realize(DeviceState *dev, Error **errp)
> >          error_setg(errp, "queue size must be non-zero");
> >          return;
> >      }
> > -    if (s->queue_size > VIRTQUEUE_MAX_SIZE) {
> > +    if (s->queue_size > VIRTQUEUE_LEGACY_MAX_SIZE) {
> >          error_setg(errp, "queue size must not exceed %d",
> > -                   VIRTQUEUE_MAX_SIZE);
> > +                   VIRTQUEUE_LEGACY_MAX_SIZE);
> >          return;
> >      }
> >  
> > @@ -491,7 +491,7 @@ static void vhost_user_blk_device_realize(DeviceState *dev, Error **errp)
> >      }
> >  
> >      virtio_init(vdev, "virtio-blk", VIRTIO_ID_BLOCK,
> > -                sizeof(struct virtio_blk_config), VIRTQUEUE_MAX_SIZE);
> > +                sizeof(struct virtio_blk_config), VIRTQUEUE_LEGACY_MAX_SIZE);
> >  
> >      s->virtqs = g_new(VirtQueue *, s->num_queues);
> >      for (i = 0; i < s->num_queues; i++) {
> > diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
> > index 9c0f46815c..5883e3e7db 100644
> > --- a/hw/block/virtio-blk.c
> > +++ b/hw/block/virtio-blk.c
> > @@ -1171,10 +1171,10 @@ static void virtio_blk_device_realize(DeviceState *dev, Error **errp)
> >          return;
> >      }
> >      if (!is_power_of_2(conf->queue_size) ||
> > -        conf->queue_size > VIRTQUEUE_MAX_SIZE) {
> > +        conf->queue_size > VIRTQUEUE_LEGACY_MAX_SIZE) {
> >          error_setg(errp, "invalid queue-size property (%" PRIu16 "), "
> >                     "must be a power of 2 (max %d)",
> > -                   conf->queue_size, VIRTQUEUE_MAX_SIZE);
> > +                   conf->queue_size, VIRTQUEUE_LEGACY_MAX_SIZE);
> >          return;
> >      }
> >  
> > @@ -1214,7 +1214,7 @@ static void virtio_blk_device_realize(DeviceState *dev, Error **errp)
> >      virtio_blk_set_config_size(s, s->host_features);
> >  
> >      virtio_init(vdev, "virtio-blk", VIRTIO_ID_BLOCK, s->config_size,
> > -                VIRTQUEUE_MAX_SIZE);
> > +                VIRTQUEUE_LEGACY_MAX_SIZE);
> >  
> >      s->blk = conf->conf.blk;
> >      s->rq = NULL;
> > diff --git a/hw/char/virtio-serial-bus.c b/hw/char/virtio-serial-bus.c
> > index 9ad9111115..2d4285ab53 100644
> > --- a/hw/char/virtio-serial-bus.c
> > +++ b/hw/char/virtio-serial-bus.c
> > @@ -1045,7 +1045,7 @@ static void virtio_serial_device_realize(DeviceState *dev, Error **errp)
> >          config_size = offsetof(struct virtio_console_config, emerg_wr);
> >      }
> >      virtio_init(vdev, "virtio-serial", VIRTIO_ID_CONSOLE,
> > -                config_size, VIRTQUEUE_MAX_SIZE);
> > +                config_size, VIRTQUEUE_LEGACY_MAX_SIZE);
> >  
> >      /* Spawn a new virtio-serial bus on which the ports will ride as devices */
> >      qbus_init(&vser->bus, sizeof(vser->bus), TYPE_VIRTIO_SERIAL_BUS,
> > diff --git a/hw/input/virtio-input.c b/hw/input/virtio-input.c
> > index 345eb2cce7..b6b77488f2 100644
> > --- a/hw/input/virtio-input.c
> > +++ b/hw/input/virtio-input.c
> > @@ -258,7 +258,7 @@ static void virtio_input_device_realize(DeviceState *dev, Error **errp)
> >      assert(vinput->cfg_size <= sizeof(virtio_input_config));
> >  
> >      virtio_init(vdev, "virtio-input", VIRTIO_ID_INPUT,
> > -                vinput->cfg_size, VIRTQUEUE_MAX_SIZE);
> > +                vinput->cfg_size, VIRTQUEUE_LEGACY_MAX_SIZE);
> >      vinput->evt = virtio_add_queue(vdev, 64, virtio_input_handle_evt);
> >      vinput->sts = virtio_add_queue(vdev, 64, virtio_input_handle_sts);
> >  }
> > diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
> > index f74b5f6268..5100978b07 100644
> > --- a/hw/net/virtio-net.c
> > +++ b/hw/net/virtio-net.c
> > @@ -636,7 +636,7 @@ static int virtio_net_max_tx_queue_size(VirtIONet *n)
> >          return VIRTIO_NET_TX_QUEUE_DEFAULT_SIZE;
> >      }
> >  
> > -    return VIRTQUEUE_MAX_SIZE;
> > +    return VIRTQUEUE_LEGACY_MAX_SIZE;
> >  }
> >  
> >  static int peer_attach(VirtIONet *n, int index)
> > @@ -3365,7 +3365,7 @@ static void virtio_net_device_realize(DeviceState *dev, Error **errp)
> >  
> >      virtio_net_set_config_size(n, n->host_features);
> >      virtio_init(vdev, "virtio-net", VIRTIO_ID_NET, n->config_size,
> > -                VIRTQUEUE_MAX_SIZE);
> > +                VIRTQUEUE_LEGACY_MAX_SIZE);
> >  
> >      /*
> >       * We set a lower limit on RX queue size to what it always was.
> > @@ -3373,23 +3373,23 @@ static void virtio_net_device_realize(DeviceState *dev, Error **errp)
> >       * help from us (using virtio 1 and up).
> >       */
> >      if (n->net_conf.rx_queue_size < VIRTIO_NET_RX_QUEUE_MIN_SIZE ||
> > -        n->net_conf.rx_queue_size > VIRTQUEUE_MAX_SIZE ||
> > +        n->net_conf.rx_queue_size > VIRTQUEUE_LEGACY_MAX_SIZE ||
> >          !is_power_of_2(n->net_conf.rx_queue_size)) {
> >          error_setg(errp, "Invalid rx_queue_size (= %" PRIu16 "), "
> >                     "must be a power of 2 between %d and %d.",
> >                     n->net_conf.rx_queue_size, VIRTIO_NET_RX_QUEUE_MIN_SIZE,
> > -                   VIRTQUEUE_MAX_SIZE);
> > +                   VIRTQUEUE_LEGACY_MAX_SIZE);
> >          virtio_cleanup(vdev);
> >          return;
> >      }
> >  
> >      if (n->net_conf.tx_queue_size < VIRTIO_NET_TX_QUEUE_MIN_SIZE ||
> > -        n->net_conf.tx_queue_size > VIRTQUEUE_MAX_SIZE ||
> > +        n->net_conf.tx_queue_size > VIRTQUEUE_LEGACY_MAX_SIZE ||
> >          !is_power_of_2(n->net_conf.tx_queue_size)) {
> >          error_setg(errp, "Invalid tx_queue_size (= %" PRIu16 "), "
> >                     "must be a power of 2 between %d and %d",
> >                     n->net_conf.tx_queue_size, VIRTIO_NET_TX_QUEUE_MIN_SIZE,
> > -                   VIRTQUEUE_MAX_SIZE);
> > +                   VIRTQUEUE_LEGACY_MAX_SIZE);
> >          virtio_cleanup(vdev);
> >          return;
> >      }
> > diff --git a/hw/scsi/virtio-scsi.c b/hw/scsi/virtio-scsi.c
> > index 5e5e657e1d..f204e8878a 100644
> > --- a/hw/scsi/virtio-scsi.c
> > +++ b/hw/scsi/virtio-scsi.c
> > @@ -973,7 +973,7 @@ void virtio_scsi_common_realize(DeviceState *dev,
> >      int i;
> >  
> >      virtio_init(vdev, "virtio-scsi", VIRTIO_ID_SCSI,
> > -                sizeof(VirtIOSCSIConfig), VIRTQUEUE_MAX_SIZE);
> > +                sizeof(VirtIOSCSIConfig), VIRTQUEUE_LEGACY_MAX_SIZE);
> >  
> >      if (s->conf.num_queues == VIRTIO_SCSI_AUTO_NUM_QUEUES) {
> >          s->conf.num_queues = 1;
> > diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> > index ae1672d667..decc5def39 100644
> > --- a/hw/virtio/vhost-user-fs.c
> > +++ b/hw/virtio/vhost-user-fs.c
> > @@ -209,9 +209,9 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
> >          return;
> >      }
> >  
> > -    if (fs->conf.queue_size > VIRTQUEUE_MAX_SIZE) {
> > +    if (fs->conf.queue_size > VIRTQUEUE_LEGACY_MAX_SIZE) {
> >          error_setg(errp, "queue-size property must be %u or smaller",
> > -                   VIRTQUEUE_MAX_SIZE);
> > +                   VIRTQUEUE_LEGACY_MAX_SIZE);
> >          return;
> >      }
> >  
> > @@ -220,7 +220,7 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
> >      }
> >  
> >      virtio_init(vdev, "vhost-user-fs", VIRTIO_ID_FS,
> > -                sizeof(struct virtio_fs_config), VIRTQUEUE_MAX_SIZE);
> > +                sizeof(struct virtio_fs_config), VIRTQUEUE_LEGACY_MAX_SIZE);
> >  
> >      /* Hiprio queue */
> >      fs->hiprio_vq = virtio_add_queue(vdev, fs->conf.queue_size, vuf_handle_output);
> > diff --git a/hw/virtio/vhost-user-i2c.c b/hw/virtio/vhost-user-i2c.c
> > index eeb1d8853a..b248ddbe93 100644
> > --- a/hw/virtio/vhost-user-i2c.c
> > +++ b/hw/virtio/vhost-user-i2c.c
> > @@ -221,7 +221,7 @@ static void vu_i2c_device_realize(DeviceState *dev, Error **errp)
> >      }
> >  
> >      virtio_init(vdev, "vhost-user-i2c", VIRTIO_ID_I2C_ADAPTER, 0,
> > -                VIRTQUEUE_MAX_SIZE);
> > +                VIRTQUEUE_LEGACY_MAX_SIZE);
> >  
> >      i2c->vhost_dev.nvqs = 1;
> >      i2c->vq = virtio_add_queue(vdev, 4, vu_i2c_handle_output);
> > diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
> > index a81fa884a8..73e6b72bba 100644
> > --- a/hw/virtio/vhost-vsock-common.c
> > +++ b/hw/virtio/vhost-vsock-common.c
> > @@ -201,7 +201,7 @@ void vhost_vsock_common_realize(VirtIODevice *vdev, const char *name)
> >      VHostVSockCommon *vvc = VHOST_VSOCK_COMMON(vdev);
> >  
> >      virtio_init(vdev, name, VIRTIO_ID_VSOCK,
> > -                sizeof(struct virtio_vsock_config), VIRTQUEUE_MAX_SIZE);
> > +                sizeof(struct virtio_vsock_config), VIRTQUEUE_LEGACY_MAX_SIZE);
> >  
> >      /* Receive and transmit queues belong to vhost */
> >      vvc->recv_vq = virtio_add_queue(vdev, VHOST_VSOCK_QUEUE_SIZE,
> > diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
> > index 067c73223d..890fb15ed3 100644
> > --- a/hw/virtio/virtio-balloon.c
> > +++ b/hw/virtio/virtio-balloon.c
> > @@ -886,7 +886,7 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
> >      int ret;
> >  
> >      virtio_init(vdev, "virtio-balloon", VIRTIO_ID_BALLOON,
> > -                virtio_balloon_config_size(s), VIRTQUEUE_MAX_SIZE);
> > +                virtio_balloon_config_size(s), VIRTQUEUE_LEGACY_MAX_SIZE);
> >  
> >      ret = qemu_add_balloon_handler(virtio_balloon_to_target,
> >                                     virtio_balloon_stat, s);
> > diff --git a/hw/virtio/virtio-crypto.c b/hw/virtio/virtio-crypto.c
> > index 1e70d4d2a8..e13b6091d6 100644
> > --- a/hw/virtio/virtio-crypto.c
> > +++ b/hw/virtio/virtio-crypto.c
> > @@ -811,7 +811,7 @@ static void virtio_crypto_device_realize(DeviceState *dev, Error **errp)
> >      }
> >  
> >      virtio_init(vdev, "virtio-crypto", VIRTIO_ID_CRYPTO, vcrypto->config_size,
> > -                VIRTQUEUE_MAX_SIZE);
> > +                VIRTQUEUE_LEGACY_MAX_SIZE);
> >      vcrypto->curr_queues = 1;
> >      vcrypto->vqs = g_malloc0(sizeof(VirtIOCryptoQueue) * vcrypto->max_queues);
> >      for (i = 0; i < vcrypto->max_queues; i++) {
> > diff --git a/hw/virtio/virtio-iommu.c b/hw/virtio/virtio-iommu.c
> > index ca360e74eb..845df78842 100644
> > --- a/hw/virtio/virtio-iommu.c
> > +++ b/hw/virtio/virtio-iommu.c
> > @@ -974,7 +974,7 @@ static void virtio_iommu_device_realize(DeviceState *dev, Error **errp)
> >      VirtIOIOMMU *s = VIRTIO_IOMMU(dev);
> >  
> >      virtio_init(vdev, "virtio-iommu", VIRTIO_ID_IOMMU,
> > -                sizeof(struct virtio_iommu_config), VIRTQUEUE_MAX_SIZE);
> > +                sizeof(struct virtio_iommu_config), VIRTQUEUE_LEGACY_MAX_SIZE);
> >  
> >      memset(s->iommu_pcibus_by_bus_num, 0, sizeof(s->iommu_pcibus_by_bus_num));
> >  
> > diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> > index 1d9d01b871..7a39550cde 100644
> > --- a/hw/virtio/virtio-mem.c
> > +++ b/hw/virtio/virtio-mem.c
> > @@ -738,7 +738,7 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
> >      vmem->bitmap = bitmap_new(vmem->bitmap_size);
> >  
> >      virtio_init(vdev, TYPE_VIRTIO_MEM, VIRTIO_ID_MEM,
> > -                sizeof(struct virtio_mem_config), VIRTQUEUE_MAX_SIZE);
> > +                sizeof(struct virtio_mem_config), VIRTQUEUE_LEGACY_MAX_SIZE);
> >      vmem->vq = virtio_add_queue(vdev, 128, virtio_mem_handle_request);
> >  
> >      host_memory_backend_set_mapped(vmem->memdev, true);
> > diff --git a/hw/virtio/virtio-mmio.c b/hw/virtio/virtio-mmio.c
> > index 7b3ebca178..ae0cc223e9 100644
> > --- a/hw/virtio/virtio-mmio.c
> > +++ b/hw/virtio/virtio-mmio.c
> > @@ -174,7 +174,7 @@ static uint64_t virtio_mmio_read(void *opaque, hwaddr offset, unsigned size)
> >          if (!virtio_queue_get_num(vdev, vdev->queue_sel)) {
> >              return 0;
> >          }
> > -        return VIRTQUEUE_MAX_SIZE;
> > +        return VIRTQUEUE_LEGACY_MAX_SIZE;
> >      case VIRTIO_MMIO_QUEUE_PFN:
> >          if (!proxy->legacy) {
> >              qemu_log_mask(LOG_GUEST_ERROR,
> > @@ -348,7 +348,7 @@ static void virtio_mmio_write(void *opaque, hwaddr offset, uint64_t value,
> >          }
> >          break;
> >      case VIRTIO_MMIO_QUEUE_NUM:
> > -        trace_virtio_mmio_queue_write(value, VIRTQUEUE_MAX_SIZE);
> > +        trace_virtio_mmio_queue_write(value, VIRTQUEUE_LEGACY_MAX_SIZE);
> >          virtio_queue_set_num(vdev, vdev->queue_sel, value);
> >  
> >          if (proxy->legacy) {
> > diff --git a/hw/virtio/virtio-pmem.c b/hw/virtio/virtio-pmem.c
> > index 82b54b00c5..5f4d375b58 100644
> > --- a/hw/virtio/virtio-pmem.c
> > +++ b/hw/virtio/virtio-pmem.c
> > @@ -124,7 +124,7 @@ static void virtio_pmem_realize(DeviceState *dev, Error **errp)
> >  
> >      host_memory_backend_set_mapped(pmem->memdev, true);
> >      virtio_init(vdev, TYPE_VIRTIO_PMEM, VIRTIO_ID_PMEM,
> > -                sizeof(struct virtio_pmem_config), VIRTQUEUE_MAX_SIZE);
> > +                sizeof(struct virtio_pmem_config), VIRTQUEUE_LEGACY_MAX_SIZE);
> >      pmem->rq_vq = virtio_add_queue(vdev, 128, virtio_pmem_flush);
> >  }
> >  
> > diff --git a/hw/virtio/virtio-rng.c b/hw/virtio/virtio-rng.c
> > index 0e91d60106..ab075b22b6 100644
> > --- a/hw/virtio/virtio-rng.c
> > +++ b/hw/virtio/virtio-rng.c
> > @@ -215,7 +215,8 @@ static void virtio_rng_device_realize(DeviceState *dev, Error **errp)
> >          return;
> >      }
> >  
> > -    virtio_init(vdev, "virtio-rng", VIRTIO_ID_RNG, 0, VIRTQUEUE_MAX_SIZE);
> > +    virtio_init(vdev, "virtio-rng", VIRTIO_ID_RNG, 0,
> > +                VIRTQUEUE_LEGACY_MAX_SIZE);
> >  
> >      vrng->vq = virtio_add_queue(vdev, 8, handle_input);
> >      vrng->quota_remaining = vrng->conf.max_bytes;
> > diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> > index a37d1f7d52..fe0f13266b 100644
> > --- a/include/hw/virtio/virtio.h
> > +++ b/include/hw/virtio/virtio.h
> > @@ -48,7 +48,25 @@ size_t virtio_feature_get_config_size(const VirtIOFeature *features,
> >  
> >  typedef struct VirtQueue VirtQueue;
> >  
> > -#define VIRTQUEUE_MAX_SIZE 1024
> > +/*
> > + * This is meant as transitional measure for VIRTQUEUE_MAX_SIZE's old value
> > + * of 1024 to its new value of 32768. On the long-term virtio users should
> > + * either switch to VIRTQUEUE_MAX_SIZE, provided they support 32768,
> > + * otherwise they should replace this macro on their side with an
> > + * appropriate value actually supported by them.
> > + *
> > + * Once all virtio users switched, this macro will be removed.
> > + */
> > +#define VIRTQUEUE_LEGACY_MAX_SIZE 1024
> > +
> > +/*
> > + * Reflects the absolute theoretical maximum queue size (in amount of pages)
> > + * ever possible, which is actually the maximum queue size allowed by the
> > + * virtio protocol. This value therefore construes the maximum transfer size
> > + * possible with virtio (multiplied by system dependent PAGE_SIZE); assuming
> > + * a typical page size of 4k this would be a maximum transfer size of 128M.
> > + */
> > +#define VIRTQUEUE_MAX_SIZE 32768
> >  
> >  typedef struct VirtQueueElement
> >  {
> > -- 
> > 2.20.1
> 

