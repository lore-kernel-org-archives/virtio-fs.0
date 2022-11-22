Return-Path: <eperezma@redhat.com>
MIME-Version: 1.0
References: <20221121101101.29400-1-sgarzare@redhat.com>
 <CACGkMEtZ9C0uhnDZ7iPJSHvPcbwGCLrzj742zzc9xAVWD7EMVA@mail.gmail.com>
In-Reply-To: <CACGkMEtZ9C0uhnDZ7iPJSHvPcbwGCLrzj742zzc9xAVWD7EMVA@mail.gmail.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 22 Nov 2022 19:01:38 +0100
Message-ID: <CAJaqyWfAA7p9MB4DZ-qtshr28HG3o4uXcxyg+BPC6C+eeojnbA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] vhost: mask VIRTIO_F_RING_RESET for vhost
 and vhost-user devices
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jason Wang <jasowang@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>, qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>, Fam Zheng <fam@euphon.net>, Mathieu Poirier <mathieu.poirier@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Hanna Reitz <hreitz@redhat.com>, kangjie.xu@linux.alibaba.com

On Tue, Nov 22, 2022 at 4:13 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Mon, Nov 21, 2022 at 6:11 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > Commit 69e1c14aa2 ("virtio: core: vq reset feature negotation support")
> > enabled VIRTIO_F_RING_RESET by default for all virtio devices.
> >
> > This feature is not currently emulated by QEMU, so for vhost and
> > vhost-user devices we need to make sure it is supported by the offloaded
> > device emulation (in-kernel or in another process).
> > To do this we need to add VIRTIO_F_RING_RESET to the features bitmap
> > passed to vhost_get_features(). This way it will be masked if the device
> > does not support it.
> >
> > This issue was initially discovered with vhost-vsock and vhost-user-vsock,
> > and then also tested with vhost-user-rng which confirmed the same issue.
> > They fail when sending features through VHOST_SET_FEATURES ioctl or
> > VHOST_USER_SET_FEATURES message, since VIRTIO_F_RING_RESET is negotiated
> > by the guest (Linux >= v6.0), but not supported by the device.
> >
> > Fixes: 69e1c14aa2 ("virtio: core: vq reset feature negotation support")
> > Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1318
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> > ---
> >
> > To prevent this problem in the future, perhaps we should provide a function
> > (e.g. vhost_device_get_features) where we go to mask all non-device-specific
> > features (e.g VIRTIO_F_*, VIRTIO_RING_F_*) that are not emulated by QEMU but
> > we expect them to be emulated by the vhost or vhost-user devices.
>
> Adding Eugenio, this might not be true if we want to use shadow
> virtqueue for emulating some features?
>

I think we should be able to introduce that in the (hypothetical)
vhost_device_get_features if SVQ starts emulating a ring feature,
isn't it? I think a first version not aware of SVQ is fine anyway, and
to introduce it later should be easy.

Thanks!

> Thanks
>
> > Then we can call it in all .get_features callbacks just before return the
> > features.
> >
> > What do you think?
> >
> > But maybe better to do that for the next release, I will send an RFC.
> >
> > Thanks,
> > Stefano
> > ---
> >  hw/block/vhost-user-blk.c      |  1 +
> >  hw/net/vhost_net.c             |  1 +
> >  hw/scsi/vhost-scsi.c           |  1 +
> >  hw/scsi/vhost-user-scsi.c      |  1 +
> >  hw/virtio/vhost-user-fs.c      |  1 +
> >  hw/virtio/vhost-user-gpio.c    |  1 +
> >  hw/virtio/vhost-user-i2c.c     |  1 +
> >  hw/virtio/vhost-user-rng.c     | 11 +++++++++--
> >  hw/virtio/vhost-vsock-common.c |  1 +
> >  net/vhost-vdpa.c               |  1 +
> >  10 files changed, 18 insertions(+), 2 deletions(-)
> >
> > diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> > index 16ad400889..0d5190accf 100644
> > --- a/hw/block/vhost-user-blk.c
> > +++ b/hw/block/vhost-user-blk.c
> > @@ -52,6 +52,7 @@ static const int user_feature_bits[] = {
> >      VIRTIO_F_NOTIFY_ON_EMPTY,
> >      VIRTIO_F_RING_PACKED,
> >      VIRTIO_F_IOMMU_PLATFORM,
> > +    VIRTIO_F_RING_RESET,
> >      VHOST_INVALID_FEATURE_BIT
> >  };
> >
> > diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
> > index feda448878..26e4930676 100644
> > --- a/hw/net/vhost_net.c
> > +++ b/hw/net/vhost_net.c
> > @@ -75,6 +75,7 @@ static const int user_feature_bits[] = {
> >      VIRTIO_NET_F_MTU,
> >      VIRTIO_F_IOMMU_PLATFORM,
> >      VIRTIO_F_RING_PACKED,
> > +    VIRTIO_F_RING_RESET,
> >      VIRTIO_NET_F_RSS,
> >      VIRTIO_NET_F_HASH_REPORT,
> >
> > diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
> > index bdf337a7a2..6a0fd0dfb1 100644
> > --- a/hw/scsi/vhost-scsi.c
> > +++ b/hw/scsi/vhost-scsi.c
> > @@ -38,6 +38,7 @@ static const int kernel_feature_bits[] = {
> >      VIRTIO_RING_F_INDIRECT_DESC,
> >      VIRTIO_RING_F_EVENT_IDX,
> >      VIRTIO_SCSI_F_HOTPLUG,
> > +    VIRTIO_F_RING_RESET,
> >      VHOST_INVALID_FEATURE_BIT
> >  };
> >
> > diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
> > index bc37317d55..b7a71a802c 100644
> > --- a/hw/scsi/vhost-user-scsi.c
> > +++ b/hw/scsi/vhost-user-scsi.c
> > @@ -36,6 +36,7 @@ static const int user_feature_bits[] = {
> >      VIRTIO_RING_F_INDIRECT_DESC,
> >      VIRTIO_RING_F_EVENT_IDX,
> >      VIRTIO_SCSI_F_HOTPLUG,
> > +    VIRTIO_F_RING_RESET,
> >      VHOST_INVALID_FEATURE_BIT
> >  };
> >
> > diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> > index 1c40f42045..dc4014cdef 100644
> > --- a/hw/virtio/vhost-user-fs.c
> > +++ b/hw/virtio/vhost-user-fs.c
> > @@ -32,6 +32,7 @@ static const int user_feature_bits[] = {
> >      VIRTIO_F_NOTIFY_ON_EMPTY,
> >      VIRTIO_F_RING_PACKED,
> >      VIRTIO_F_IOMMU_PLATFORM,
> > +    VIRTIO_F_RING_RESET,
> >
> >      VHOST_INVALID_FEATURE_BIT
> >  };
> > diff --git a/hw/virtio/vhost-user-gpio.c b/hw/virtio/vhost-user-gpio.c
> > index 677d1c7730..5851cb3bc9 100644
> > --- a/hw/virtio/vhost-user-gpio.c
> > +++ b/hw/virtio/vhost-user-gpio.c
> > @@ -24,6 +24,7 @@ static const int feature_bits[] = {
> >      VIRTIO_RING_F_INDIRECT_DESC,
> >      VIRTIO_RING_F_EVENT_IDX,
> >      VIRTIO_GPIO_F_IRQ,
> > +    VIRTIO_F_RING_RESET,
> >      VHOST_INVALID_FEATURE_BIT
> >  };
> >
> > diff --git a/hw/virtio/vhost-user-i2c.c b/hw/virtio/vhost-user-i2c.c
> > index 864eba695e..1c9f3d20dc 100644
> > --- a/hw/virtio/vhost-user-i2c.c
> > +++ b/hw/virtio/vhost-user-i2c.c
> > @@ -16,6 +16,7 @@
> >
> >  static const int feature_bits[] = {
> >      VIRTIO_I2C_F_ZERO_LENGTH_REQUEST,
> > +    VIRTIO_F_RING_RESET,
> >      VHOST_INVALID_FEATURE_BIT
> >  };
> >
> > diff --git a/hw/virtio/vhost-user-rng.c b/hw/virtio/vhost-user-rng.c
> > index 8b47287875..f9084cde58 100644
> > --- a/hw/virtio/vhost-user-rng.c
> > +++ b/hw/virtio/vhost-user-rng.c
> > @@ -16,6 +16,11 @@
> >  #include "qemu/error-report.h"
> >  #include "standard-headers/linux/virtio_ids.h"
> >
> > +static const int feature_bits[] = {
> > +    VIRTIO_F_RING_RESET,
> > +    VHOST_INVALID_FEATURE_BIT
> > +};
> > +
> >  static void vu_rng_start(VirtIODevice *vdev)
> >  {
> >      VHostUserRNG *rng = VHOST_USER_RNG(vdev);
> > @@ -106,8 +111,10 @@ static void vu_rng_set_status(VirtIODevice *vdev, uint8_t status)
> >  static uint64_t vu_rng_get_features(VirtIODevice *vdev,
> >                                      uint64_t requested_features, Error **errp)
> >  {
> > -    /* No feature bits used yet */
> > -    return requested_features;
> > +    VHostUserRNG *rng = VHOST_USER_RNG(vdev);
> > +
> > +    return vhost_get_features(&rng->vhost_dev, feature_bits,
> > +                              requested_features);
> >  }
> >
> >  static void vu_rng_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> > diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
> > index 29b9ab4f72..a67a275de2 100644
> > --- a/hw/virtio/vhost-vsock-common.c
> > +++ b/hw/virtio/vhost-vsock-common.c
> > @@ -21,6 +21,7 @@
> >
> >  const int feature_bits[] = {
> >      VIRTIO_VSOCK_F_SEQPACKET,
> > +    VIRTIO_F_RING_RESET,
> >      VHOST_INVALID_FEATURE_BIT
> >  };
> >
> > diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> > index 6811089231..2b4b85d8f8 100644
> > --- a/net/vhost-vdpa.c
> > +++ b/net/vhost-vdpa.c
> > @@ -69,6 +69,7 @@ const int vdpa_feature_bits[] = {
> >      VIRTIO_NET_F_CTRL_VQ,
> >      VIRTIO_F_IOMMU_PLATFORM,
> >      VIRTIO_F_RING_PACKED,
> > +    VIRTIO_F_RING_RESET,
> >      VIRTIO_NET_F_RSS,
> >      VIRTIO_NET_F_HASH_REPORT,
> >      VIRTIO_NET_F_GUEST_ANNOUNCE,
> > --
> > 2.38.1
> >
>

