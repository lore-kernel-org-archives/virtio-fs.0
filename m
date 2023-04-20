Return-Path: <mark.cave-ayland@ilande.co.uk>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=ilande.co.uk; s=20220518; h=Subject:Content-Transfer-Encoding:Content-Type:
 In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
 Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
 :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=+8FLUzGCvZBUO5uZUNG8U0mmyyLszsfPGFPXz9SIa7k=; b=JmB00NO9Ygk+UCr6Ms5jv6u1JC
 1FG+8Wb7Ohxr+fd3rApPJoCVBIW4Lv4gEHCpBWBLx+a/eOAU6SK3Hm3x6EGEpBFAgRt6IVGKJ4NRP
 9iiU6GFnbp2ZDagQukClXoB3gnFK7vom7+lD91a4KSBqaAeaHdF6hvygujndwuStlUh2KtSblM7LO
 9ntsuP88Ga41nEpvvlMTBGQ4Kb6G750MSaklmyB8M4zRwdBn3R1vkE3e0LKaNsZUCUA+yF188eyLQ
 VXeYBSysgxa6jciVL+BaEzbhKoYBVs2mAoy0N4gA/4hV8BGEeQdQqluGtn6VH5apZ0uibfrizVCV7
 RwfhraA/z8YbWM/w6sQ13jWEGrsooSjkntx+lETJiyYwKq2U56jVv3N0RfWOUV6+71a9XLbC5WgXN
 jvA/m8gwka1Vc3rN4QiE/38xI0SLhuwwHwEXu3cSv2Z0iPlp20Dg3g9YUT2ASAM7IEry2q2LPB/yN
 oAU7ZxqGV1lWgvVEF17gjIG1phDjrea8b/XpRfVpx3O/FQ+pZY8SC+RHN9sBvvQzYOL1CoGiAVqok
 64uRMN6kiZDQST3a3yadXLzVjcl6D0tnsqOqCTr4olC0IQMogTDnb+eDaLtZMa2X5OwbRMYPsMEWU
 Hwd8/goAqkfQTzNG4wrmo+rdG2YqjhwPEmYFmbX0E=
Message-ID: <33641fa3-f617-3151-e7ca-becaf06e2641@ilande.co.uk>
Date: Thu, 20 Apr 2023 10:47:31 +0100
MIME-Version: 1.0
References: <20230418162140.373219-1-alex.bennee@linaro.org>
 <20230418162140.373219-8-alex.bennee@linaro.org>
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
In-Reply-To: <20230418162140.373219-8-alex.bennee@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 07/13] virtio: add vhost-user-base and a
 generic vhost-user-device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Markus Armbruster <armbru@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Jason Wang <jasowang@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, virtio-fs@redhat.com, =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>

On 18/04/2023 17:21, Alex Bennée wrote:

> In theory we shouldn't need to repeat so much boilerplate to support
> vhost-user backends. This provides a generic vhost-user-base QOM
> object and a derived vhost-user-device for which the user needs to
> provide the few bits of information that aren't currently provided by
> the vhost-user protocol. This should provide a baseline implementation
> from which the other vhost-user stub can specialise.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> 
> ---
> v2
>    - split into vub and vud
> ---
>   include/hw/virtio/vhost-user-device.h |  45 ++++
>   hw/virtio/vhost-user-device.c         | 324 ++++++++++++++++++++++++++
>   hw/virtio/meson.build                 |   2 +
>   3 files changed, 371 insertions(+)
>   create mode 100644 include/hw/virtio/vhost-user-device.h
>   create mode 100644 hw/virtio/vhost-user-device.c
> 
> diff --git a/include/hw/virtio/vhost-user-device.h b/include/hw/virtio/vhost-user-device.h
> new file mode 100644
> index 0000000000..9105011e25
> --- /dev/null
> +++ b/include/hw/virtio/vhost-user-device.h
> @@ -0,0 +1,45 @@
> +/*
> + * Vhost-user generic virtio device
> + *
> + * Copyright (c) 2023 Linaro Ltd
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */
> +
> +#ifndef QEMU_VHOST_USER_DEVICE_H
> +#define QEMU_VHOST_USER_DEVICE_H
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
> +    /* Properties */
> +    CharBackend chardev;
> +    uint16_t virtio_id;
> +    uint32_t num_vqs;
> +    /* State tracking */
> +    VhostUserState vhost_user;
> +    struct vhost_virtqueue *vhost_vq;
> +    struct vhost_dev vhost_dev;
> +    GPtrArray *vqs;
> +    bool connected;
> +};

Boring style point: we should ensure that for QOM object definitions there should be 
a newline after the first member, and the first member is always parent_obj e.g.

struct VHostUserBase {
     VirtIODevice parent_obj;

     /* Properties */
     CharBackend chardev;
     uint16_t virtio_id;
     uint32_t num_vqs;
     /* State tracking */
     VhostUserState vhost_user;
     struct vhost_virtqueue *vhost_vq;
     struct vhost_dev vhost_dev;
     GPtrArray *vqs;
     bool connected;
};

This is good for 2 reasons: firstly it screams "this struct is a QOM object" (and 
therefore there should be an OBJECT_DECLARE_*_TYPE() macro nearby, and secondly by 
isolating the parent and making it obvious it is easier for reviewers to understand 
the class hierarchy, and indeed forces the developer to think about what the parent 
should actually be.

Unfortunately it seems that exceptions to this rule have started to creep it, but I 
think it is useful to keep this.

> +    /* needed so we can use the base realize after specialisation
> +       tweaks */
> +struct VHostUserBaseClass {
> +    /*< private >*/
> +    VirtioDeviceClass parent_class;
> +    /*< public >*/
> +    DeviceRealize parent_realize;
> +};

Same here for VHostUserBaseClass except the first member should always be 
parent_class i.e.

struct VHostUserBaseClass {
     VirtioDeviceClass parent_class;

     DeviceRealize parent_realize;
};

Anthony's original documentation made use of the "/*< private >*/" and /*< public >*/ 
comments, but IMO this doesn't really mean anything and they should be removed to 
avoid confusion. If an object member is externally accessible outside of the 
hierarchy then it should simply be declared as a property.

> +/* shared for the benefit of the derived pci class */
> +#define TYPE_VHOST_USER_DEVICE "vhost-user-device"
> +
> +#endif /* QEMU_VHOST_USER_DEVICE_H */
> diff --git a/hw/virtio/vhost-user-device.c b/hw/virtio/vhost-user-device.c
> new file mode 100644
> index 0000000000..b0239fa033
> --- /dev/null
> +++ b/hw/virtio/vhost-user-device.c
> @@ -0,0 +1,324 @@
> +/*
> + * Generic vhost-user stub. This can be used to connect to any
> + * vhost-user backend. All configuration details must be handled by
> + * the vhost-user daemon itself
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
> +#include "hw/virtio/vhost-user-device.h"
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
> +        error_report("Error starting vhost-user-device: %d", -ret);
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
> +
> +    if (vub->connected) {
> +        return 0;
> +    }
> +    vub->connected = true;
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
> +        error_setg(errp, "vhost-user-device: missing chardev");
> +        return;
> +    }
> +
> +    if (!vub->virtio_id) {
> +        error_setg(errp, "vhost-user-device: need to define device id");
> +        return;
> +    }
> +
> +    if (!vub->num_vqs) {
> +        vub->num_vqs = 1; /* reasonable default? */
> +    }
> +
> +    if (!vhost_user_init(&vub->vhost_user, &vub->chardev, errp)) {
> +        return;
> +    }
> +
> +    virtio_init(vdev, vub->virtio_id, 0);
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
> +                        virtio_add_queue(vdev, 4, vub_handle_output));
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
> +
> +/*
> + * The following is a concrete implementation of the base class which
> + * allows the user to define the key parameters via the command line.
> + */
> +
> +static const VMStateDescription vud_vmstate = {
> +    .name = "vhost-user-device",
> +    .unmigratable = 1,
> +};
> +
> +static Property vud_properties[] = {
> +    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
> +    DEFINE_PROP_UINT16("virtio-id", VHostUserBase, virtio_id, 0),
> +    DEFINE_PROP_UINT32("num_vqs", VHostUserBase, num_vqs, 1),
> +    DEFINE_PROP_END_OF_LIST(),
> +};
> +
> +static void vud_class_init(ObjectClass *klass, void *data)
> +{
> +    DeviceClass *dc = DEVICE_CLASS(klass);
> +
> +    device_class_set_props(dc, vud_properties);
> +    dc->vmsd = &vud_vmstate;
> +    set_bit(DEVICE_CATEGORY_INPUT, dc->categories);
> +}
> +
> +static const TypeInfo vud_info = {
> +    .name = TYPE_VHOST_USER_DEVICE,
> +    .parent = TYPE_VHOST_USER_BASE,
> +    .instance_size = sizeof(VHostUserBase),
> +    .class_init = vud_class_init,
> +    .class_size = sizeof(VHostUserBaseClass),
> +};

If you like you can drop the .instance_size and .class_size properties here since 
they are inherited from the parent type by default.

> +static void vu_register_types(void)
> +{
> +    type_register_static(&vub_info);
> +    type_register_static(&vud_info);
> +}
> +
> +type_init(vu_register_types)
> diff --git a/hw/virtio/meson.build b/hw/virtio/meson.build
> index bdec78bfc6..43e5fa3f7d 100644
> --- a/hw/virtio/meson.build
> +++ b/hw/virtio/meson.build
> @@ -10,7 +10,9 @@ specific_virtio_ss.add(files('virtio-config-io.c', 'virtio-qmp.c'))
>   if have_vhost
>     specific_virtio_ss.add(files('vhost.c', 'vhost-backend.c', 'vhost-iova-tree.c'))
>     if have_vhost_user
> +    # fixme - this really should be generic
>       specific_virtio_ss.add(files('vhost-user.c'))
> +    softmmu_virtio_ss.add(files('vhost-user-device.c'))
>     endif
>     if have_vhost_vdpa
>       specific_virtio_ss.add(files('vhost-vdpa.c', 'vhost-shadow-virtqueue.c'))


ATB,

Mark.

