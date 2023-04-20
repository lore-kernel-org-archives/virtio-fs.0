Return-Path: <mark.cave-ayland@ilande.co.uk>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=ilande.co.uk; s=20220518; h=Subject:Content-Transfer-Encoding:Content-Type:
 In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
 Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
 :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=y5kJvOH9QT4Yalt4ovMgT6YsupEsSPlJi6k4IGmUjwk=; b=C9kX1Eqq8q/j/bzfUAbMs+GvkA
 WWrUf94LYisxeE6P0G809iwzftWDAHWSW2SeTbH26wqv1W5FkosT5YUZCS48ivnhQgJ/Gqz5Z0KeH
 ZGLsCm2Xtm/COmf3E6sheBSKXgePSajmYQEON/S3G5sqgGeotgNl3j9cC2FNBPReIpiSU3nqS7QES
 M8DeulIPusdEsmMOeRnwZGCphgB1E2zGNHQ4EITQIYf2MnZuFopdhL44CjJt5Vvne2ACGpXwO1JhI
 NFuyBQ2eFkf13wRTe3gsiU5rztY6W4X33dAlNAIEi/1ORzuZ4yg7+buozEmH36NhcrBU3CG2/a6bx
 LXYTXzCoXXv1BeOkgUf3IJp3YFl/JsQL+L6GTRjrHNVDsDx/Da3zZlMNElO9mBjfCw0CGiZv24LGk
 kU+1HauYOEpBK4UWfH5KF+SqtllCQQF7kdTAntEEB+SgjfY5X4whY20KpBmXA5fFSBJDneBFPPH5V
 2ogufpu+GWDsslKt0aXegu9V7scxpYOiXt9BRLX/7cxpLI5uWXOyGjsMaLvoSLXZCfQUhJNjhwCkq
 tudNnUpBv33N30euRqJHRMFxjzNjioFcK1mev7ZoamIbM+xpmabhLs2iBtce5Nq0lH7l4hDCRj7Nj
 VoTYNy/KpR9O+KVmpbbK0JNbsuWJi0QMyMSOLCxkI=
Message-ID: <cd2c7d64-268f-940d-36aa-2ab30545f503@ilande.co.uk>
Date: Thu, 20 Apr 2023 11:18:22 +0100
MIME-Version: 1.0
References: <20230418162140.373219-1-alex.bennee@linaro.org>
 <20230418162140.373219-13-alex.bennee@linaro.org>
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
In-Reply-To: <20230418162140.373219-13-alex.bennee@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 12/13] hw/virtio: derive vhost-user-i2c
 from vhost-user-base
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

> Now we can take advantage of the new base class and make
> vhost-user-i2c a much simpler boilerplate wrapper. Also as this
> doesn't require any target specific hacks we only need to build the
> stubs once.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> 
> ---
> v2
>    - update to new inheritance scheme
>    - move build to common code
> ---
>   include/hw/virtio/vhost-user-i2c.h |  18 +-
>   hw/virtio/vhost-user-i2c.c         | 255 ++---------------------------
>   hw/virtio/meson.build              |   5 +-
>   3 files changed, 26 insertions(+), 252 deletions(-)
> 
> diff --git a/include/hw/virtio/vhost-user-i2c.h b/include/hw/virtio/vhost-user-i2c.h
> index 0f7acd40e3..47153782d1 100644
> --- a/include/hw/virtio/vhost-user-i2c.h
> +++ b/include/hw/virtio/vhost-user-i2c.h
> @@ -12,20 +12,18 @@
>   #include "hw/virtio/vhost.h"
>   #include "hw/virtio/vhost-user.h"
>   
> +#include "hw/virtio/virtio.h"
> +#include "hw/virtio/vhost.h"
> +#include "hw/virtio/vhost-user.h"
> +#include "hw/virtio/vhost-user-device.h"
> +
>   #define TYPE_VHOST_USER_I2C "vhost-user-i2c-device"
>   OBJECT_DECLARE_SIMPLE_TYPE(VHostUserI2C, VHOST_USER_I2C)
>   
>   struct VHostUserI2C {
> -    VirtIODevice parent;
> -    CharBackend chardev;
> -    struct vhost_virtqueue *vhost_vq;
> -    struct vhost_dev vhost_dev;
> -    VhostUserState vhost_user;
> -    VirtQueue *vq;
> -    bool connected;
> +    /*< private >*/
> +    VHostUserBase parent;
> +    /*< public >*/
>   };

And same again:

struct VHostUserI2C {
     VHostUserBase parent_obj;
};

> -/* Virtio Feature bits */
> -#define VIRTIO_I2C_F_ZERO_LENGTH_REQUEST		0
> -
>   #endif /* QEMU_VHOST_USER_I2C_H */
> diff --git a/hw/virtio/vhost-user-i2c.c b/hw/virtio/vhost-user-i2c.c
> index 60eaf0d95b..4a1f644a87 100644
> --- a/hw/virtio/vhost-user-i2c.c
> +++ b/hw/virtio/vhost-user-i2c.c
> @@ -14,237 +14,21 @@
>   #include "qemu/error-report.h"
>   #include "standard-headers/linux/virtio_ids.h"
>   
> -static const int feature_bits[] = {
> -    VIRTIO_I2C_F_ZERO_LENGTH_REQUEST,
> -    VIRTIO_F_RING_RESET,
> -    VHOST_INVALID_FEATURE_BIT
> +static Property vi2c_properties[] = {
> +    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
> +    DEFINE_PROP_END_OF_LIST(),
>   };
>   
> -static void vu_i2c_start(VirtIODevice *vdev)
> -{
> -    BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
> -    VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
> -    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
> -    int ret, i;
> -
> -    if (!k->set_guest_notifiers) {
> -        error_report("binding does not support guest notifiers");
> -        return;
> -    }
> -
> -    ret = vhost_dev_enable_notifiers(&i2c->vhost_dev, vdev);
> -    if (ret < 0) {
> -        error_report("Error enabling host notifiers: %d", -ret);
> -        return;
> -    }
> -
> -    ret = k->set_guest_notifiers(qbus->parent, i2c->vhost_dev.nvqs, true);
> -    if (ret < 0) {
> -        error_report("Error binding guest notifier: %d", -ret);
> -        goto err_host_notifiers;
> -    }
> -
> -    i2c->vhost_dev.acked_features = vdev->guest_features;
> -
> -    ret = vhost_dev_start(&i2c->vhost_dev, vdev, true);
> -    if (ret < 0) {
> -        error_report("Error starting vhost-user-i2c: %d", -ret);
> -        goto err_guest_notifiers;
> -    }
> -
> -    /*
> -     * guest_notifier_mask/pending not used yet, so just unmask
> -     * everything here. virtio-pci will do the right thing by
> -     * enabling/disabling irqfd.
> -     */
> -    for (i = 0; i < i2c->vhost_dev.nvqs; i++) {
> -        vhost_virtqueue_mask(&i2c->vhost_dev, vdev, i, false);
> -    }
> -
> -    return;
> -
> -err_guest_notifiers:
> -    k->set_guest_notifiers(qbus->parent, i2c->vhost_dev.nvqs, false);
> -err_host_notifiers:
> -    vhost_dev_disable_notifiers(&i2c->vhost_dev, vdev);
> -}
> -
> -static void vu_i2c_stop(VirtIODevice *vdev)
> -{
> -    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
> -    BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
> -    VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
> -    int ret;
> -
> -    if (!k->set_guest_notifiers) {
> -        return;
> -    }
> -
> -    vhost_dev_stop(&i2c->vhost_dev, vdev, true);
> -
> -    ret = k->set_guest_notifiers(qbus->parent, i2c->vhost_dev.nvqs, false);
> -    if (ret < 0) {
> -        error_report("vhost guest notifier cleanup failed: %d", ret);
> -        return;
> -    }
> -
> -    vhost_dev_disable_notifiers(&i2c->vhost_dev, vdev);
> -}
> -
> -static void vu_i2c_set_status(VirtIODevice *vdev, uint8_t status)
> -{
> -    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
> -    bool should_start = virtio_device_should_start(vdev, status);
> -
> -    if (vhost_dev_is_started(&i2c->vhost_dev) == should_start) {
> -        return;
> -    }
> -
> -    if (should_start) {
> -        vu_i2c_start(vdev);
> -    } else {
> -        vu_i2c_stop(vdev);
> -    }
> -}
> -
> -static uint64_t vu_i2c_get_features(VirtIODevice *vdev,
> -                                    uint64_t requested_features, Error **errp)
> -{
> -    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
> -
> -    virtio_add_feature(&requested_features, VIRTIO_I2C_F_ZERO_LENGTH_REQUEST);
> -    return vhost_get_features(&i2c->vhost_dev, feature_bits, requested_features);
> -}
> -
> -static void vu_i2c_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> -{
> -    /*
> -     * Not normally called; it's the daemon that handles the queue;
> -     * however virtio's cleanup path can call this.
> -     */
> -}
> -
> -static void vu_i2c_guest_notifier_mask(VirtIODevice *vdev, int idx, bool mask)
> -{
> -    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
> -
> -    vhost_virtqueue_mask(&i2c->vhost_dev, vdev, idx, mask);
> -}
> -
> -static bool vu_i2c_guest_notifier_pending(VirtIODevice *vdev, int idx)
> -{
> -    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
> -
> -    return vhost_virtqueue_pending(&i2c->vhost_dev, idx);
> -}
> -
> -static void do_vhost_user_cleanup(VirtIODevice *vdev, VHostUserI2C *i2c)
> -{
> -    vhost_user_cleanup(&i2c->vhost_user);
> -    virtio_delete_queue(i2c->vq);
> -    virtio_cleanup(vdev);
> -}
> -
> -static int vu_i2c_connect(DeviceState *dev)
> -{
> -    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> -    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
> -
> -    if (i2c->connected) {
> -        return 0;
> -    }
> -    i2c->connected = true;
> -
> -    /* restore vhost state */
> -    if (virtio_device_started(vdev, vdev->status)) {
> -        vu_i2c_start(vdev);
> -    }
> -
> -    return 0;
> -}
> -
> -static void vu_i2c_disconnect(DeviceState *dev)
> -{
> -    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> -    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
> -
> -    if (!i2c->connected) {
> -        return;
> -    }
> -    i2c->connected = false;
> -
> -    if (vhost_dev_is_started(&i2c->vhost_dev)) {
> -        vu_i2c_stop(vdev);
> -    }
> -}
> -
> -static void vu_i2c_event(void *opaque, QEMUChrEvent event)
> +static void vi2c_realize(DeviceState *dev, Error **errp)
>   {
> -    DeviceState *dev = opaque;
> -    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> -    VHostUserI2C *i2c = VHOST_USER_I2C(vdev);
> -
> -    switch (event) {
> -    case CHR_EVENT_OPENED:
> -        if (vu_i2c_connect(dev) < 0) {
> -            qemu_chr_fe_disconnect(&i2c->chardev);
> -            return;
> -        }
> -        break;
> -    case CHR_EVENT_CLOSED:
> -        vu_i2c_disconnect(dev);
> -        break;
> -    case CHR_EVENT_BREAK:
> -    case CHR_EVENT_MUX_IN:
> -    case CHR_EVENT_MUX_OUT:
> -        /* Ignore */
> -        break;
> -    }
> -}
> -
> -static void vu_i2c_device_realize(DeviceState *dev, Error **errp)
> -{
> -    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> -    VHostUserI2C *i2c = VHOST_USER_I2C(dev);
> -    int ret;
> -
> -    if (!i2c->chardev.chr) {
> -        error_setg(errp, "vhost-user-i2c: missing chardev");
> -        return;
> -    }
> -
> -    if (!vhost_user_init(&i2c->vhost_user, &i2c->chardev, errp)) {
> -        return;
> -    }
> -
> -    virtio_init(vdev, VIRTIO_ID_I2C_ADAPTER, 0);
> +    VHostUserBase *vub = VHOST_USER_BASE(dev);
> +    VHostUserBaseClass *vubc = VHOST_USER_BASE_GET_CLASS(dev);
>   
> -    i2c->vhost_dev.nvqs = 1;
> -    i2c->vq = virtio_add_queue(vdev, 4, vu_i2c_handle_output);
> -    i2c->vhost_dev.vqs = g_new0(struct vhost_virtqueue, i2c->vhost_dev.nvqs);
> +    /* Fixed for I2C */
> +    vub->virtio_id = VIRTIO_ID_I2C_ADAPTER;
> +    vub->num_vqs = 1;
>   
> -    ret = vhost_dev_init(&i2c->vhost_dev, &i2c->vhost_user,
> -                         VHOST_BACKEND_TYPE_USER, 0, errp);
> -    if (ret < 0) {
> -        g_free(i2c->vhost_dev.vqs);
> -        do_vhost_user_cleanup(vdev, i2c);
> -    }
> -
> -    qemu_chr_fe_set_handlers(&i2c->chardev, NULL, NULL, vu_i2c_event, NULL,
> -                             dev, NULL, true);
> -}
> -
> -static void vu_i2c_device_unrealize(DeviceState *dev)
> -{
> -    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> -    VHostUserI2C *i2c = VHOST_USER_I2C(dev);
> -    struct vhost_virtqueue *vhost_vqs = i2c->vhost_dev.vqs;
> -
> -    /* This will stop vhost backend if appropriate. */
> -    vu_i2c_set_status(vdev, 0);
> -    vhost_dev_cleanup(&i2c->vhost_dev);
> -    g_free(vhost_vqs);
> -    do_vhost_user_cleanup(vdev, i2c);
> +    vubc->parent_realize(dev, errp);
>   }
>   
>   static const VMStateDescription vu_i2c_vmstate = {
> @@ -252,30 +36,21 @@ static const VMStateDescription vu_i2c_vmstate = {
>       .unmigratable = 1,
>   };
>   
> -static Property vu_i2c_properties[] = {
> -    DEFINE_PROP_CHR("chardev", VHostUserI2C, chardev),
> -    DEFINE_PROP_END_OF_LIST(),
> -};
> -
>   static void vu_i2c_class_init(ObjectClass *klass, void *data)
>   {
>       DeviceClass *dc = DEVICE_CLASS(klass);
> -    VirtioDeviceClass *vdc = VIRTIO_DEVICE_CLASS(klass);
> +    VHostUserBaseClass *vubc = VHOST_USER_BASE_CLASS(klass);
>   
> -    device_class_set_props(dc, vu_i2c_properties);
>       dc->vmsd = &vu_i2c_vmstate;
> +    device_class_set_props(dc, vi2c_properties);
> +    device_class_set_parent_realize(dc, vi2c_realize,
> +                                    &vubc->parent_realize);
>       set_bit(DEVICE_CATEGORY_INPUT, dc->categories);
> -    vdc->realize = vu_i2c_device_realize;
> -    vdc->unrealize = vu_i2c_device_unrealize;
> -    vdc->get_features = vu_i2c_get_features;
> -    vdc->set_status = vu_i2c_set_status;
> -    vdc->guest_notifier_mask = vu_i2c_guest_notifier_mask;
> -    vdc->guest_notifier_pending = vu_i2c_guest_notifier_pending;
>   }
>   
>   static const TypeInfo vu_i2c_info = {
>       .name = TYPE_VHOST_USER_I2C,
> -    .parent = TYPE_VIRTIO_DEVICE,
> +    .parent = TYPE_VHOST_USER_BASE,
>       .instance_size = sizeof(VHostUserI2C),
>       .class_init = vu_i2c_class_init,
>   };
> diff --git a/hw/virtio/meson.build b/hw/virtio/meson.build
> index 8c6cb2143d..31c0406f05 100644
> --- a/hw/virtio/meson.build
> +++ b/hw/virtio/meson.build
> @@ -10,6 +10,9 @@ softmmu_virtio_ss.add(when: ['CONFIG_VIRTIO_PCI', 'CONFIG_VHOST_USER_RNG'],
>   softmmu_virtio_ss.add(when: 'CONFIG_VHOST_USER_GPIO', if_true: files('vhost-user-gpio.c'))
>   softmmu_virtio_ss.add(when: ['CONFIG_VIRTIO_PCI', 'CONFIG_VHOST_USER_GPIO'],
>                         if_true: files('vhost-user-gpio-pci.c'))
> +softmmu_virtio_ss.add(when: 'CONFIG_VHOST_USER_I2C', if_true: files('vhost-user-i2c.c'))
> +softmmu_virtio_ss.add(when: ['CONFIG_VIRTIO_PCI', 'CONFIG_VHOST_USER_I2C'],
> +                       if_true: files('vhost-user-i2c-pci.c'))
>   
>   specific_virtio_ss = ss.source_set()
>   specific_virtio_ss.add(files('virtio.c'))
> @@ -39,14 +42,12 @@ specific_virtio_ss.add(when: 'CONFIG_VHOST_USER_VSOCK', if_true: files('vhost-us
>   specific_virtio_ss.add(when: 'CONFIG_VIRTIO_RNG', if_true: files('virtio-rng.c'))
>   specific_virtio_ss.add(when: 'CONFIG_VIRTIO_IOMMU', if_true: files('virtio-iommu.c'))
>   specific_virtio_ss.add(when: 'CONFIG_VIRTIO_MEM', if_true: files('virtio-mem.c'))
> -specific_virtio_ss.add(when: 'CONFIG_VHOST_USER_I2C', if_true: files('vhost-user-i2c.c'))
>   specific_virtio_ss.add(when: 'CONFIG_VHOST_VDPA_DEV', if_true: files('vdpa-dev.c'))
>   
>   virtio_pci_ss = ss.source_set()
>   virtio_pci_ss.add(when: 'CONFIG_VHOST_VSOCK', if_true: files('vhost-vsock-pci.c'))
>   virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_VSOCK', if_true: files('vhost-user-vsock-pci.c'))
>   virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_BLK', if_true: files('vhost-user-blk-pci.c'))
> -virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_I2C', if_true: files('vhost-user-i2c-pci.c'))
>   virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_INPUT', if_true: files('vhost-user-input-pci.c'))
>   virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_SCSI', if_true: files('vhost-user-scsi-pci.c'))
>   virtio_pci_ss.add(when: 'CONFIG_VHOST_SCSI', if_true: files('vhost-scsi-pci.c'))

Otherwise:

Acked-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>


ATB,

Mark.

