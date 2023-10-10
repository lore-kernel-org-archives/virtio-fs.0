Return-Path: <mark.cave-ayland@ilande.co.uk>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=ilande.co.uk; s=20220518; h=Subject:Content-Transfer-Encoding:Content-Type:
 In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
 Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
 :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=3O6AKuRP/UFLASTxPtS1okDjl6xYQh5VeE+kW3AYs/c=; b=LPhfKFC0MqUQXIPvVANnd+nyLw
 fe5Szh+RSZ4ChRmBSlvNSrDmVIV4Kxw73FqaCJ/8vbPDHoBj4JzT2GoXooM1AA1x9JXNo6nROEuC5
 9d0ztVKj2U/jTCWmr6vOfeZjRpTGMFw6nC+mRi5uDtFf69VnRMSCrtn5k5TeTdo0fBCQgltFhuGhx
 Nypucv6J3I/v+miV4qoz9qkv1NM1zk3Fm6P5kV438nqrOTAzTcMjvIjiryPGcO9qhrOerQgXzRh4T
 /e28v/P0Mb9+E/cAJUoaE6tmg0MBT3sGk8AU9OG4zJ3I4Cw1zSSbQ92phKEj7ckvlGCY5QaI43f3e
 NGOTQ1He721PCKNiTT2oPzCsf7zkP388HliWvmtkUU7Zr/WwX2c1pRXAwPPHchopS2M3l24YJBBOK
 12hWo82d2zTSMhPyb4RMAH/Dxz22yimeKjlEuFpDQVkC2WcZxyRyG+ze4903uztP/gFf355JpJF7I
 ISncDF4BAkZpKqfBvTltqYSBSZq6U8QusbQt6GwE+g+EaaBm7s3wPviHbXEuD6tbVSFEaRydIVgaP
 K0HX4mbLxqzqk0pm4LQaKNHFY3rfeHlolxCRJF3tSbyHLKfZts3vCYsW84h0cSGFI46SKbhy/5fiR
 1dbBN3VlcDtzDmTiJKnkxNIqUYKJXZL+hHdPZmdAw=
Message-ID: <c70d1440-a2d3-4af4-80bc-77904077e2e3@ilande.co.uk>
Date: Tue, 10 Oct 2023 16:08:43 +0100
MIME-Version: 1.0
References: <20231009095937.195728-1-alex.bennee@linaro.org>
 <20231009095937.195728-2-alex.bennee@linaro.org>
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
In-Reply-To: <20231009095937.195728-2-alex.bennee@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v4 1/6] virtio: split into vhost-user-base
 and vhost-user-device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Fam Zheng <fam@euphon.net>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, qemu-block@nongnu.org, Eduardo Habkost <eduardo@habkost.net>, Paolo Bonzini <pbonzini@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, virtio-fs@redhat.com, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>

On 09/10/2023 10:59, Alex Bennée wrote:

> Lets keep a cleaner split between the base class and the derived
> vhost-user-device which we can use for generic vhost-user stubs. This
> includes an update to introduce the vq_size property so the number of
> entries in a virtq can be defined.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> 
> ---
> v1
>    - merge and re-base, reset testing/review tags
> ---
>   include/hw/virtio/vhost-user-base.h |  49 ++++
>   hw/virtio/vhost-user-base.c         | 348 ++++++++++++++++++++++++++++
>   hw/virtio/vhost-user-device-pci.c   |  10 +-
>   hw/virtio/vhost-user-device.c       | 335 +-------------------------
>   hw/virtio/meson.build               |   1 +
>   5 files changed, 410 insertions(+), 333 deletions(-)
>   create mode 100644 include/hw/virtio/vhost-user-base.h
>   create mode 100644 hw/virtio/vhost-user-base.c
> 
> diff --git a/include/hw/virtio/vhost-user-base.h b/include/hw/virtio/vhost-user-base.h
> new file mode 100644
> index 0000000000..cad377468b
> --- /dev/null
> +++ b/include/hw/virtio/vhost-user-base.h
> @@ -0,0 +1,49 @@
> +/*
> + * Vhost-user generic virtio device
> + *
> + * Copyright (c) 2023 Linaro Ltd
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */
> +
> +#ifndef QEMU_VHOST_USER_BASE_H
> +#define QEMU_VHOST_USER_BASE_H
> +
> +#include "hw/virtio/vhost.h"
> +#include "hw/virtio/vhost-user.h"
> +
> +#define TYPE_VHOST_USER_BASE "vhost-user-base"
> +
> +OBJECT_DECLARE_TYPE(VHostUserBase, VHostUserBaseClass, VHOST_USER_BASE)
> +
> +struct VHostUserBase {
> +    VirtIODevice parent;

This one should be parent_obj here.

> +
> +    /* Properties */
> +    CharBackend chardev;
> +    uint16_t virtio_id;
> +    uint32_t num_vqs;
> +    uint32_t vq_size; /* can't exceed VIRTIO_QUEUE_MAX */
> +    uint32_t config_size;
> +    /* State tracking */
> +    VhostUserState vhost_user;
> +    struct vhost_virtqueue *vhost_vq;
> +    struct vhost_dev vhost_dev;
> +    GPtrArray *vqs;
> +    bool connected;
> +};
> +
> +/*
> + * Needed so we can use the base realize after specialisation
> + * tweaks
> + */
> +struct VHostUserBaseClass {
> +    VirtioDeviceClass parent_class;
> +
> +    DeviceRealize parent_realize;
> +};
> +
> +
> +#define TYPE_VHOST_USER_DEVICE "vhost-user-device"
> +
> +#endif /* QEMU_VHOST_USER_BASE_H */
> diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
> new file mode 100644
> index 0000000000..a8b811c394
> --- /dev/null
> +++ b/hw/virtio/vhost-user-base.c
> @@ -0,0 +1,348 @@
> +/*
> + * Base vhost-user-base implementation. This can be used to derive a
> + * more fully specified vhost-user backend either generically (see
> + * vhost-user-device) or via a specific stub for a device which
> + * encapsulates some fixed parameters.
> + *
> + * Copyright (c) 2023 Linaro Ltd
> + * Author: Alex Bennée <alex.bennee@linaro.org>
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "hw/qdev-properties.h"
> +#include "hw/virtio/virtio-bus.h"
> +#include "hw/virtio/vhost-user-base.h"
> +#include "qemu/error-report.h"
> +
> +static void vub_start(VirtIODevice *vdev)
> +{
> +    BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
> +    VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
> +    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> +    int ret, i;
> +
> +    if (!k->set_guest_notifiers) {
> +        error_report("binding does not support guest notifiers");
> +        return;
> +    }
> +
> +    ret = vhost_dev_enable_notifiers(&vub->vhost_dev, vdev);
> +    if (ret < 0) {
> +        error_report("Error enabling host notifiers: %d", -ret);
> +        return;
> +    }
> +
> +    ret = k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, true);
> +    if (ret < 0) {
> +        error_report("Error binding guest notifier: %d", -ret);
> +        goto err_host_notifiers;
> +    }
> +
> +    vub->vhost_dev.acked_features = vdev->guest_features;
> +
> +    ret = vhost_dev_start(&vub->vhost_dev, vdev, true);
> +    if (ret < 0) {
> +        error_report("Error starting vhost-user-base: %d", -ret);
> +        goto err_guest_notifiers;
> +    }
> +
> +    /*
> +     * guest_notifier_mask/pending not used yet, so just unmask
> +     * everything here. virtio-pci will do the right thing by
> +     * enabling/disabling irqfd.
> +     */
> +    for (i = 0; i < vub->vhost_dev.nvqs; i++) {
> +        vhost_virtqueue_mask(&vub->vhost_dev, vdev, i, false);
> +    }
> +
> +    return;
> +
> +err_guest_notifiers:
> +    k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, false);
> +err_host_notifiers:
> +    vhost_dev_disable_notifiers(&vub->vhost_dev, vdev);
> +}
> +
> +static void vub_stop(VirtIODevice *vdev)
> +{
> +    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> +    BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
> +    VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
> +    int ret;
> +
> +    if (!k->set_guest_notifiers) {
> +        return;
> +    }
> +
> +    vhost_dev_stop(&vub->vhost_dev, vdev, true);
> +
> +    ret = k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, false);
> +    if (ret < 0) {
> +        error_report("vhost guest notifier cleanup failed: %d", ret);
> +        return;
> +    }
> +
> +    vhost_dev_disable_notifiers(&vub->vhost_dev, vdev);
> +}
> +
> +static void vub_set_status(VirtIODevice *vdev, uint8_t status)
> +{
> +    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> +    bool should_start = virtio_device_should_start(vdev, status);
> +
> +    if (vhost_dev_is_started(&vub->vhost_dev) == should_start) {
> +        return;
> +    }
> +
> +    if (should_start) {
> +        vub_start(vdev);
> +    } else {
> +        vub_stop(vdev);
> +    }
> +}
> +
> +/*
> + * For an implementation where everything is delegated to the backend
> + * we don't do anything other than return the full feature set offered
> + * by the daemon (module the reserved feature bit).
> + */
> +static uint64_t vub_get_features(VirtIODevice *vdev,
> +                                 uint64_t requested_features, Error **errp)
> +{
> +    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> +    /* This should be set when the vhost connection initialises */
> +    g_assert(vub->vhost_dev.features);
> +    return vub->vhost_dev.features & ~(1ULL << VHOST_USER_F_PROTOCOL_FEATURES);
> +}
> +
> +/*
> + * To handle VirtIO config we need to know the size of the config
> + * space. We don't cache the config but re-fetch it from the guest
> + * every time in case something has changed.
> + */
> +static void vub_get_config(VirtIODevice *vdev, uint8_t *config)
> +{
> +    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> +    Error *local_err = NULL;
> +
> +    /*
> +     * There will have been a warning during vhost_dev_init, but lets
> +     * assert here as nothing will go right now.
> +     */
> +    g_assert(vub->config_size && vub->vhost_user.supports_config == true);
> +
> +    if (vhost_dev_get_config(&vub->vhost_dev, config,
> +                             vub->config_size, &local_err)) {
> +        error_report_err(local_err);
> +    }
> +}
> +
> +/*
> + * When the daemon signals an update to the config we just need to
> + * signal the guest as we re-read the config on demand above.
> + */
> +static int vub_config_notifier(struct vhost_dev *dev)
> +{
> +    virtio_notify_config(dev->vdev);
> +    return 0;
> +}
> +
> +const VhostDevConfigOps vub_config_ops = {
> +    .vhost_dev_config_notifier = vub_config_notifier,
> +};
> +
> +static void vub_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> +{
> +    /*
> +     * Not normally called; it's the daemon that handles the queue;
> +     * however virtio's cleanup path can call this.
> +     */
> +}
> +
> +static void do_vhost_user_cleanup(VirtIODevice *vdev, VHostUserBase *vub)
> +{
> +    vhost_user_cleanup(&vub->vhost_user);
> +
> +    for (int i = 0; i < vub->num_vqs; i++) {
> +        VirtQueue *vq = g_ptr_array_index(vub->vqs, i);
> +        virtio_delete_queue(vq);
> +    }
> +
> +    virtio_cleanup(vdev);
> +}
> +
> +static int vub_connect(DeviceState *dev)
> +{
> +    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> +    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> +    struct vhost_dev *vhost_dev = &vub->vhost_dev;
> +
> +    if (vub->connected) {
> +        return 0;
> +    }
> +    vub->connected = true;
> +
> +    /*
> +     * If we support VHOST_USER_GET_CONFIG we must enable the notifier
> +     * so we can ping the guest when it updates.
> +     */
> +    if (vub->vhost_user.supports_config) {
> +        vhost_dev_set_config_notifier(vhost_dev, &vub_config_ops);
> +    }
> +
> +    /* restore vhost state */
> +    if (virtio_device_started(vdev, vdev->status)) {
> +        vub_start(vdev);
> +    }
> +
> +    return 0;
> +}
> +
> +static void vub_disconnect(DeviceState *dev)
> +{
> +    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> +    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> +
> +    if (!vub->connected) {
> +        return;
> +    }
> +    vub->connected = false;
> +
> +    if (vhost_dev_is_started(&vub->vhost_dev)) {
> +        vub_stop(vdev);
> +    }
> +}
> +
> +static void vub_event(void *opaque, QEMUChrEvent event)
> +{
> +    DeviceState *dev = opaque;
> +    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> +    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> +
> +    switch (event) {
> +    case CHR_EVENT_OPENED:
> +        if (vub_connect(dev) < 0) {
> +            qemu_chr_fe_disconnect(&vub->chardev);
> +            return;
> +        }
> +        break;
> +    case CHR_EVENT_CLOSED:
> +        vub_disconnect(dev);
> +        break;
> +    case CHR_EVENT_BREAK:
> +    case CHR_EVENT_MUX_IN:
> +    case CHR_EVENT_MUX_OUT:
> +        /* Ignore */
> +        break;
> +    }
> +}
> +
> +static void vub_device_realize(DeviceState *dev, Error **errp)
> +{
> +    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> +    VHostUserBase *vub = VHOST_USER_BASE(dev);
> +    int ret;
> +
> +    if (!vub->chardev.chr) {
> +        error_setg(errp, "vhost-user-base: missing chardev");
> +        return;
> +    }
> +
> +    if (!vub->virtio_id) {
> +        error_setg(errp, "vhost-user-base: need to define device id");
> +        return;
> +    }
> +
> +    if (!vub->num_vqs) {
> +        vub->num_vqs = 1; /* reasonable default? */
> +    }
> +
> +    if (!vub->vq_size) {
> +        vub->vq_size = 64;
> +    }
> +
> +    /*
> +     * We can't handle config requests unless we know the size of the
> +     * config region, specialisations of the vhost-user-base will be
> +     * able to set this.
> +     */
> +    if (vub->config_size) {
> +        vub->vhost_user.supports_config = true;
> +    }
> +
> +    if (!vhost_user_init(&vub->vhost_user, &vub->chardev, errp)) {
> +        return;
> +    }
> +
> +    virtio_init(vdev, vub->virtio_id, vub->config_size);
> +
> +    /*
> +     * Disable guest notifiers, by default all notifications will be via the
> +     * asynchronous vhost-user socket.
> +     */
> +    vdev->use_guest_notifier_mask = false;
> +
> +    /* Allocate queues */
> +    vub->vqs = g_ptr_array_sized_new(vub->num_vqs);
> +    for (int i = 0; i < vub->num_vqs; i++) {
> +        g_ptr_array_add(vub->vqs,
> +                        virtio_add_queue(vdev, vub->vq_size, vub_handle_output));
> +    }
> +
> +    vub->vhost_dev.nvqs = vub->num_vqs;
> +    vub->vhost_dev.vqs = g_new0(struct vhost_virtqueue, vub->vhost_dev.nvqs);
> +
> +    /* connect to backend */
> +    ret = vhost_dev_init(&vub->vhost_dev, &vub->vhost_user,
> +                         VHOST_BACKEND_TYPE_USER, 0, errp);
> +
> +    if (ret < 0) {
> +        do_vhost_user_cleanup(vdev, vub);
> +    }
> +
> +    qemu_chr_fe_set_handlers(&vub->chardev, NULL, NULL, vub_event, NULL,
> +                             dev, NULL, true);
> +}
> +
> +static void vub_device_unrealize(DeviceState *dev)
> +{
> +    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> +    VHostUserBase *vub = VHOST_USER_BASE(dev);
> +    struct vhost_virtqueue *vhost_vqs = vub->vhost_dev.vqs;
> +
> +    /* This will stop vhost backend if appropriate. */
> +    vub_set_status(vdev, 0);
> +    vhost_dev_cleanup(&vub->vhost_dev);
> +    g_free(vhost_vqs);
> +    do_vhost_user_cleanup(vdev, vub);
> +}
> +
> +static void vub_class_init(ObjectClass *klass, void *data)
> +{
> +    VirtioDeviceClass *vdc = VIRTIO_DEVICE_CLASS(klass);
> +
> +    vdc->realize = vub_device_realize;
> +    vdc->unrealize = vub_device_unrealize;
> +    vdc->get_features = vub_get_features;
> +    vdc->get_config = vub_get_config;
> +    vdc->set_status = vub_set_status;
> +}
> +
> +static const TypeInfo vub_info = {
> +    .name = TYPE_VHOST_USER_BASE,
> +    .parent = TYPE_VIRTIO_DEVICE,
> +    .instance_size = sizeof(VHostUserBase),
> +    .class_init = vub_class_init,
> +    .class_size = sizeof(VHostUserBaseClass),
> +    .abstract = true
> +};
> +
> +static void vu_register_types(void)
> +{
> +    type_register_static(&vub_info);
> +}
> +
> +type_init(vu_register_types)
> diff --git a/hw/virtio/vhost-user-device-pci.c b/hw/virtio/vhost-user-device-pci.c
> index 41f9b7905b..22a5e95b9c 100644
> --- a/hw/virtio/vhost-user-device-pci.c
> +++ b/hw/virtio/vhost-user-device-pci.c
> @@ -9,21 +9,18 @@
>   
>   #include "qemu/osdep.h"
>   #include "hw/qdev-properties.h"
> -#include "hw/virtio/vhost-user-device.h"
> +#include "hw/virtio/vhost-user-base.h"
>   #include "hw/virtio/virtio-pci.h"
>   
>   struct VHostUserDevicePCI {
>       VirtIOPCIProxy parent_obj;
> +
>       VHostUserBase vub;
>   };
>   
> -typedef struct VHostUserDevicePCI VHostUserDevicePCI;
> -
>   #define TYPE_VHOST_USER_DEVICE_PCI "vhost-user-device-pci-base"
>   
> -DECLARE_INSTANCE_CHECKER(VHostUserDevicePCI,
> -                         VHOST_USER_DEVICE_PCI,
> -                         TYPE_VHOST_USER_DEVICE_PCI)
> +OBJECT_DECLARE_SIMPLE_TYPE(VHostUserDevicePCI, VHOST_USER_DEVICE_PCI)
>   
>   static void vhost_user_device_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
>   {
> @@ -39,6 +36,7 @@ static void vhost_user_device_pci_class_init(ObjectClass *klass, void *data)
>       DeviceClass *dc = DEVICE_CLASS(klass);
>       VirtioPCIClass *k = VIRTIO_PCI_CLASS(klass);
>       PCIDeviceClass *pcidev_k = PCI_DEVICE_CLASS(klass);
> +
>       k->realize = vhost_user_device_pci_realize;
>       set_bit(DEVICE_CATEGORY_INPUT, dc->categories);
>       pcidev_k->vendor_id = PCI_VENDOR_ID_REDHAT_QUMRANET;
> diff --git a/hw/virtio/vhost-user-device.c b/hw/virtio/vhost-user-device.c
> index 2b028cae08..4adc1e8991 100644
> --- a/hw/virtio/vhost-user-device.c
> +++ b/hw/virtio/vhost-user-device.c
> @@ -1,7 +1,10 @@
>   /*
> - * Generic vhost-user stub. This can be used to connect to any
> - * vhost-user backend. All configuration details must be handled by
> - * the vhost-user daemon itself
> + * Generic vhost-user-device implementation for any vhost-user-backend
> + *
> + * This is a concrete implementation of vhost-user-base which can be
> + * configured via properties. It is useful for development and
> + * prototyping. It expects configuration details (if any) to be
> + * handled by the vhost-user daemon itself.
>    *
>    * Copyright (c) 2023 Linaro Ltd
>    * Author: Alex Bennée <alex.bennee@linaro.org>
> @@ -13,329 +16,9 @@
>   #include "qapi/error.h"
>   #include "hw/qdev-properties.h"
>   #include "hw/virtio/virtio-bus.h"
> -#include "hw/virtio/vhost-user-device.h"
> +#include "hw/virtio/vhost-user-base.h"
>   #include "qemu/error-report.h"
>   
> -static void vub_start(VirtIODevice *vdev)
> -{
> -    BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
> -    VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
> -    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> -    int ret, i;
> -
> -    if (!k->set_guest_notifiers) {
> -        error_report("binding does not support guest notifiers");
> -        return;
> -    }
> -
> -    ret = vhost_dev_enable_notifiers(&vub->vhost_dev, vdev);
> -    if (ret < 0) {
> -        error_report("Error enabling host notifiers: %d", -ret);
> -        return;
> -    }
> -
> -    ret = k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, true);
> -    if (ret < 0) {
> -        error_report("Error binding guest notifier: %d", -ret);
> -        goto err_host_notifiers;
> -    }
> -
> -    vub->vhost_dev.acked_features = vdev->guest_features;
> -
> -    ret = vhost_dev_start(&vub->vhost_dev, vdev, true);
> -    if (ret < 0) {
> -        error_report("Error starting vhost-user-device: %d", -ret);
> -        goto err_guest_notifiers;
> -    }
> -
> -    /*
> -     * guest_notifier_mask/pending not used yet, so just unmask
> -     * everything here. virtio-pci will do the right thing by
> -     * enabling/disabling irqfd.
> -     */
> -    for (i = 0; i < vub->vhost_dev.nvqs; i++) {
> -        vhost_virtqueue_mask(&vub->vhost_dev, vdev, i, false);
> -    }
> -
> -    return;
> -
> -err_guest_notifiers:
> -    k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, false);
> -err_host_notifiers:
> -    vhost_dev_disable_notifiers(&vub->vhost_dev, vdev);
> -}
> -
> -static void vub_stop(VirtIODevice *vdev)
> -{
> -    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> -    BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
> -    VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
> -    int ret;
> -
> -    if (!k->set_guest_notifiers) {
> -        return;
> -    }
> -
> -    vhost_dev_stop(&vub->vhost_dev, vdev, true);
> -
> -    ret = k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, false);
> -    if (ret < 0) {
> -        error_report("vhost guest notifier cleanup failed: %d", ret);
> -        return;
> -    }
> -
> -    vhost_dev_disable_notifiers(&vub->vhost_dev, vdev);
> -}
> -
> -static void vub_set_status(VirtIODevice *vdev, uint8_t status)
> -{
> -    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> -    bool should_start = virtio_device_should_start(vdev, status);
> -
> -    if (vhost_dev_is_started(&vub->vhost_dev) == should_start) {
> -        return;
> -    }
> -
> -    if (should_start) {
> -        vub_start(vdev);
> -    } else {
> -        vub_stop(vdev);
> -    }
> -}
> -
> -/*
> - * For an implementation where everything is delegated to the backend
> - * we don't do anything other than return the full feature set offered
> - * by the daemon (module the reserved feature bit).
> - */
> -static uint64_t vub_get_features(VirtIODevice *vdev,
> -                                 uint64_t requested_features, Error **errp)
> -{
> -    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> -    /* This should be set when the vhost connection initialises */
> -    g_assert(vub->vhost_dev.features);
> -    return vub->vhost_dev.features & ~(1ULL << VHOST_USER_F_PROTOCOL_FEATURES);
> -}
> -
> -/*
> - * To handle VirtIO config we need to know the size of the config
> - * space. We don't cache the config but re-fetch it from the guest
> - * every time in case something has changed.
> - */
> -static void vub_get_config(VirtIODevice *vdev, uint8_t *config)
> -{
> -    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> -    Error *local_err = NULL;
> -
> -    /*
> -     * There will have been a warning during vhost_dev_init, but lets
> -     * assert here as nothing will go right now.
> -     */
> -    g_assert(vub->config_size && vub->vhost_user.supports_config == true);
> -
> -    if (vhost_dev_get_config(&vub->vhost_dev, config,
> -                             vub->config_size, &local_err)) {
> -        error_report_err(local_err);
> -    }
> -}
> -
> -/*
> - * When the daemon signals an update to the config we just need to
> - * signal the guest as we re-read the config on demand above.
> - */
> -static int vub_config_notifier(struct vhost_dev *dev)
> -{
> -    virtio_notify_config(dev->vdev);
> -    return 0;
> -}
> -
> -const VhostDevConfigOps vub_config_ops = {
> -    .vhost_dev_config_notifier = vub_config_notifier,
> -};
> -
> -static void vub_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> -{
> -    /*
> -     * Not normally called; it's the daemon that handles the queue;
> -     * however virtio's cleanup path can call this.
> -     */
> -}
> -
> -static void do_vhost_user_cleanup(VirtIODevice *vdev, VHostUserBase *vub)
> -{
> -    vhost_user_cleanup(&vub->vhost_user);
> -
> -    for (int i = 0; i < vub->num_vqs; i++) {
> -        VirtQueue *vq = g_ptr_array_index(vub->vqs, i);
> -        virtio_delete_queue(vq);
> -    }
> -
> -    virtio_cleanup(vdev);
> -}
> -
> -static int vub_connect(DeviceState *dev)
> -{
> -    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> -    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> -    struct vhost_dev *vhost_dev = &vub->vhost_dev;
> -
> -    if (vub->connected) {
> -        return 0;
> -    }
> -    vub->connected = true;
> -
> -    /*
> -     * If we support VHOST_USER_GET_CONFIG we must enable the notifier
> -     * so we can ping the guest when it updates.
> -     */
> -    if (vub->vhost_user.supports_config) {
> -        vhost_dev_set_config_notifier(vhost_dev, &vub_config_ops);
> -    }
> -
> -    /* restore vhost state */
> -    if (virtio_device_started(vdev, vdev->status)) {
> -        vub_start(vdev);
> -    }
> -
> -    return 0;
> -}
> -
> -static void vub_disconnect(DeviceState *dev)
> -{
> -    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> -    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> -
> -    if (!vub->connected) {
> -        return;
> -    }
> -    vub->connected = false;
> -
> -    if (vhost_dev_is_started(&vub->vhost_dev)) {
> -        vub_stop(vdev);
> -    }
> -}
> -
> -static void vub_event(void *opaque, QEMUChrEvent event)
> -{
> -    DeviceState *dev = opaque;
> -    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> -    VHostUserBase *vub = VHOST_USER_BASE(vdev);
> -
> -    switch (event) {
> -    case CHR_EVENT_OPENED:
> -        if (vub_connect(dev) < 0) {
> -            qemu_chr_fe_disconnect(&vub->chardev);
> -            return;
> -        }
> -        break;
> -    case CHR_EVENT_CLOSED:
> -        vub_disconnect(dev);
> -        break;
> -    case CHR_EVENT_BREAK:
> -    case CHR_EVENT_MUX_IN:
> -    case CHR_EVENT_MUX_OUT:
> -        /* Ignore */
> -        break;
> -    }
> -}
> -
> -static void vub_device_realize(DeviceState *dev, Error **errp)
> -{
> -    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> -    VHostUserBase *vub = VHOST_USER_BASE(dev);
> -    int ret;
> -
> -    if (!vub->chardev.chr) {
> -        error_setg(errp, "vhost-user-device: missing chardev");
> -        return;
> -    }
> -
> -    if (!vub->virtio_id) {
> -        error_setg(errp, "vhost-user-device: need to define device id");
> -        return;
> -    }
> -
> -    if (!vub->num_vqs) {
> -        vub->num_vqs = 1; /* reasonable default? */
> -    }
> -
> -    /*
> -     * We can't handle config requests unless we know the size of the
> -     * config region, specialisations of the vhost-user-device will be
> -     * able to set this.
> -     */
> -    if (vub->config_size) {
> -        vub->vhost_user.supports_config = true;
> -    }
> -
> -    if (!vhost_user_init(&vub->vhost_user, &vub->chardev, errp)) {
> -        return;
> -    }
> -
> -    virtio_init(vdev, vub->virtio_id, vub->config_size);
> -
> -    /*
> -     * Disable guest notifiers, by default all notifications will be via the
> -     * asynchronous vhost-user socket.
> -     */
> -    vdev->use_guest_notifier_mask = false;
> -
> -    /* Allocate queues */
> -    vub->vqs = g_ptr_array_sized_new(vub->num_vqs);
> -    for (int i = 0; i < vub->num_vqs; i++) {
> -        g_ptr_array_add(vub->vqs,
> -                        virtio_add_queue(vdev, 4, vub_handle_output));
> -    }
> -
> -    vub->vhost_dev.nvqs = vub->num_vqs;
> -    vub->vhost_dev.vqs = g_new0(struct vhost_virtqueue, vub->vhost_dev.nvqs);
> -
> -    /* connect to backend */
> -    ret = vhost_dev_init(&vub->vhost_dev, &vub->vhost_user,
> -                         VHOST_BACKEND_TYPE_USER, 0, errp);
> -
> -    if (ret < 0) {
> -        do_vhost_user_cleanup(vdev, vub);
> -    }
> -
> -    qemu_chr_fe_set_handlers(&vub->chardev, NULL, NULL, vub_event, NULL,
> -                             dev, NULL, true);
> -}
> -
> -static void vub_device_unrealize(DeviceState *dev)
> -{
> -    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> -    VHostUserBase *vub = VHOST_USER_BASE(dev);
> -    struct vhost_virtqueue *vhost_vqs = vub->vhost_dev.vqs;
> -
> -    /* This will stop vhost backend if appropriate. */
> -    vub_set_status(vdev, 0);
> -    vhost_dev_cleanup(&vub->vhost_dev);
> -    g_free(vhost_vqs);
> -    do_vhost_user_cleanup(vdev, vub);
> -}
> -
> -static void vub_class_init(ObjectClass *klass, void *data)
> -{
> -    VirtioDeviceClass *vdc = VIRTIO_DEVICE_CLASS(klass);
> -
> -    vdc->realize = vub_device_realize;
> -    vdc->unrealize = vub_device_unrealize;
> -    vdc->get_features = vub_get_features;
> -    vdc->get_config = vub_get_config;
> -    vdc->set_status = vub_set_status;
> -}
> -
> -static const TypeInfo vub_info = {
> -    .name = TYPE_VHOST_USER_BASE,
> -    .parent = TYPE_VIRTIO_DEVICE,
> -    .instance_size = sizeof(VHostUserBase),
> -    .class_init = vub_class_init,
> -    .class_size = sizeof(VHostUserBaseClass),
> -    .abstract = true
> -};
> -
> -
>   /*
>    * The following is a concrete implementation of the base class which
>    * allows the user to define the key parameters via the command line.
> @@ -349,6 +32,7 @@ static const VMStateDescription vud_vmstate = {
>   static Property vud_properties[] = {
>       DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
>       DEFINE_PROP_UINT16("virtio-id", VHostUserBase, virtio_id, 0),
> +    DEFINE_PROP_UINT32("vq_size", VHostUserBase, vq_size, 64),
>       DEFINE_PROP_UINT32("num_vqs", VHostUserBase, num_vqs, 1),
>       DEFINE_PROP_UINT32("config_size", VHostUserBase, config_size, 0),
>       DEFINE_PROP_END_OF_LIST(),
> @@ -366,14 +50,11 @@ static void vud_class_init(ObjectClass *klass, void *data)
>   static const TypeInfo vud_info = {
>       .name = TYPE_VHOST_USER_DEVICE,
>       .parent = TYPE_VHOST_USER_BASE,
> -    .instance_size = sizeof(VHostUserBase),
>       .class_init = vud_class_init,
> -    .class_size = sizeof(VHostUserBaseClass),
>   };
>   
>   static void vu_register_types(void)
>   {
> -    type_register_static(&vub_info);
>       type_register_static(&vud_info);
>   }

And if you're touching this part here, it's worth updating to use the DEFINE_TYPES() 
macro instead.

> diff --git a/hw/virtio/meson.build b/hw/virtio/meson.build
> index c0055a7832..51c3f97c2d 100644
> --- a/hw/virtio/meson.build
> +++ b/hw/virtio/meson.build
> @@ -17,6 +17,7 @@ if have_vhost
>     if have_vhost_user
>       # fixme - this really should be generic
>       specific_virtio_ss.add(files('vhost-user.c'))
> +    system_virtio_ss.add(files('vhost-user-base.c'))
>       system_virtio_ss.add(files('vhost-user-device.c'))
>       system_virtio_ss.add(when: 'CONFIG_VIRTIO_PCI', if_true: files('vhost-user-device-pci.c'))
>     endif


ATB,

Mark.

