Return-Path: <mark.cave-ayland@ilande.co.uk>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=ilande.co.uk; s=20220518; h=Subject:Content-Transfer-Encoding:Content-Type:
 In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
 Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
 :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=TU76x5jGQrmil9GBDqBPZ4ZalsFmbm65tU6Uf/x1Qpk=; b=KPAmabDw3vIDR7dtRWs4Exar7E
 lk1wXl599/ju3xsFXshDl4MI/RgIjhZ9XRVoWod9WU5EcRkbLi+hARRFzRRDHXMiAEAYKbRsP6iq/
 hIhRqjnujTBVOSS4Af4bJoC5zkEwHbOl/M+UDKEFu3j2qjRfEMK49n67ACxLtxLU+rOpOzfVtBdvL
 hhTBx91QkfxyPOmrcLgea+4lVaVVWwbo7RpU8nvZOSOcqyPn9JcCzkRRd0B31x7A/qPUXrfa56p3f
 jvUgxMrcEDJMGF4b2cuNoIraRbaPSpSdfTvgGg6LBFHAfMiCWSjV2aNy1PIpGN3BXydqtL+cA2Byf
 ZcBpnLU7giY4JMPAg5IWimQ2dwVA0iVaTzbIBngxD0C1ZgwpwJnwi9R+Lu+lkWs2nA7Kp5F0XPS8b
 C7qcXAVdkJODVDs6S4pnjkyEQOjud5iiuL0c06jAdnA+3CqdgTUU/ruwQnTDHzHqx55Ee/Dj6XNde
 xnfMaqLy30Bt8qCkkmWdVuCbtCDAE6tLgTZke0smlF2Lu07Am3lpH22tbjDKY3OsLtlqntN//KF5j
 56c4MyMqv1G+D3OwYnoX07zcIhIYmH6qBDre6Y3b8po+qpRiRjWDGQNuAysx7oUZN9e47iSWvKrBS
 8wAK4kwEyt7LM5MWDuMFDFOSR+Y9CSwr1uus7yBIA=
Message-ID: <424da7de-21b8-4117-39f6-7ec7d3996593@ilande.co.uk>
Date: Thu, 20 Apr 2023 10:54:24 +0100
MIME-Version: 1.0
References: <20230418162140.373219-1-alex.bennee@linaro.org>
 <20230418162140.373219-9-alex.bennee@linaro.org>
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
In-Reply-To: <20230418162140.373219-9-alex.bennee@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 08/13] virtio: add PCI stub for
 vhost-user-device
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

> This is all pretty much boilerplate.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Tested-by: Erik Schilling <erik.schilling@linaro.org>
> ---
>   hw/virtio/vhost-user-device-pci.c | 71 +++++++++++++++++++++++++++++++
>   hw/virtio/meson.build             |  1 +
>   2 files changed, 72 insertions(+)
>   create mode 100644 hw/virtio/vhost-user-device-pci.c
> 
> diff --git a/hw/virtio/vhost-user-device-pci.c b/hw/virtio/vhost-user-device-pci.c
> new file mode 100644
> index 0000000000..41f9b7905b
> --- /dev/null
> +++ b/hw/virtio/vhost-user-device-pci.c
> @@ -0,0 +1,71 @@
> +/*
> + * Vhost-user generic virtio device PCI glue
> + *
> + * Copyright (c) 2023 Linaro Ltd
> + * Author: Alex Bennée <alex.bennee@linaro.org>
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */
> +
> +#include "qemu/osdep.h"
> +#include "hw/qdev-properties.h"
> +#include "hw/virtio/vhost-user-device.h"
> +#include "hw/virtio/virtio-pci.h"
> +
> +struct VHostUserDevicePCI {
> +    VirtIOPCIProxy parent_obj;
> +    VHostUserBase vub;
> +};

Spacing here, as mentioned in my previous email.

> +typedef struct VHostUserDevicePCI VHostUserDevicePCI;
> +
> +#define TYPE_VHOST_USER_DEVICE_PCI "vhost-user-device-pci-base"
> +
> +DECLARE_INSTANCE_CHECKER(VHostUserDevicePCI,
> +                         VHOST_USER_DEVICE_PCI,
> +                         TYPE_VHOST_USER_DEVICE_PCI)

You should be able to drop the typedef here and replace DECLARE_INSTANCE_CHECKER with 
OBJECT_DECLARE_SIMPLE_TYPE.

> +static void vhost_user_device_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
> +{
> +    VHostUserDevicePCI *dev = VHOST_USER_DEVICE_PCI(vpci_dev);
> +    DeviceState *vdev = DEVICE(&dev->vub);
> +
> +    vpci_dev->nvectors = 1;
> +    qdev_realize(vdev, BUS(&vpci_dev->bus), errp);
> +}
> +
> +static void vhost_user_device_pci_class_init(ObjectClass *klass, void *data)
> +{
> +    DeviceClass *dc = DEVICE_CLASS(klass);
> +    VirtioPCIClass *k = VIRTIO_PCI_CLASS(klass);
> +    PCIDeviceClass *pcidev_k = PCI_DEVICE_CLASS(klass);

Minor nit: an empty line after the class casts here makes it much easier to read.

> +    k->realize = vhost_user_device_pci_realize;
> +    set_bit(DEVICE_CATEGORY_INPUT, dc->categories);
> +    pcidev_k->vendor_id = PCI_VENDOR_ID_REDHAT_QUMRANET;
> +    pcidev_k->device_id = 0; /* Set by virtio-pci based on virtio id */
> +    pcidev_k->revision = 0x00;
> +    pcidev_k->class_id = PCI_CLASS_COMMUNICATION_OTHER;
> +}
> +
> +static void vhost_user_device_pci_instance_init(Object *obj)
> +{
> +    VHostUserDevicePCI *dev = VHOST_USER_DEVICE_PCI(obj);
> +
> +    virtio_instance_init_common(obj, &dev->vub, sizeof(dev->vub),
> +                                TYPE_VHOST_USER_DEVICE);
> +}
> +
> +static const VirtioPCIDeviceTypeInfo vhost_user_device_pci_info = {
> +    .base_name = TYPE_VHOST_USER_DEVICE_PCI,
> +    .non_transitional_name = "vhost-user-device-pci",
> +    .instance_size = sizeof(VHostUserDevicePCI),
> +    .instance_init = vhost_user_device_pci_instance_init,
> +    .class_init = vhost_user_device_pci_class_init,
> +};
> +
> +static void vhost_user_device_pci_register(void)
> +{
> +    virtio_pci_types_register(&vhost_user_device_pci_info);
> +}
> +
> +type_init(vhost_user_device_pci_register);
> diff --git a/hw/virtio/meson.build b/hw/virtio/meson.build
> index 43e5fa3f7d..c0a86b94ae 100644
> --- a/hw/virtio/meson.build
> +++ b/hw/virtio/meson.build
> @@ -13,6 +13,7 @@ if have_vhost
>       # fixme - this really should be generic
>       specific_virtio_ss.add(files('vhost-user.c'))
>       softmmu_virtio_ss.add(files('vhost-user-device.c'))
> +    softmmu_virtio_ss.add(when: 'CONFIG_VIRTIO_PCI', if_true: files('vhost-user-device-pci.c'))
>     endif
>     if have_vhost_vdpa
>       specific_virtio_ss.add(files('vhost-vdpa.c', 'vhost-shadow-virtqueue.c'))


ATB,

Mark.

