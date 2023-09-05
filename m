Return-Path: <mvaralar@redhat.com>
Date: Tue, 5 Sep 2023 16:19:15 +0200
From: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
Message-ID: <ZPc44//qJCPNAOXE@fedora>
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
 <20230710153522.3469097-8-alex.bennee@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20230710153522.3469097-8-alex.bennee@linaro.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v3 07/20] virtio: add vhost-user-base and a
 generic vhost-user-device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Hanna Reitz <hreitz@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>

On Mon, Jul 10, 2023 at 04:35:09PM +0100, Alex Benn=E9e wrote:
> In theory we shouldn't need to repeat so much boilerplate to support
> vhost-user backends. This provides a generic vhost-user-base QOM
> object and a derived vhost-user-device for which the user needs to
> provide the few bits of information that aren't currently provided by
> the vhost-user protocol. This should provide a baseline implementation
> from which the other vhost-user stub can specialise.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
>=20
> ---
> v2
>   - split into vub and vud
> ---
>  include/hw/virtio/vhost-user-device.h |  45 ++++
>  hw/virtio/vhost-user-device.c         | 324 ++++++++++++++++++++++++++
>  hw/virtio/meson.build                 |   2 +
>  3 files changed, 371 insertions(+)
>  create mode 100644 include/hw/virtio/vhost-user-device.h
>  create mode 100644 hw/virtio/vhost-user-device.c
>=20
> diff --git a/include/hw/virtio/vhost-user-device.h b/include/hw/virtio/vh=
ost-user-device.h
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
> +
> +    /* needed so we can use the base realize after specialisation
> +       tweaks */
> +struct VHostUserBaseClass {
> +    /*< private >*/
> +    VirtioDeviceClass parent_class;
> +    /*< public >*/
> +    DeviceRealize parent_realize;
> +};
> +
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
> + * Author: Alex Benn=E9e <alex.bennee@linaro.org>
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
> +    BusState *qbus =3D BUS(qdev_get_parent_bus(DEVICE(vdev)));
> +    VirtioBusClass *k =3D VIRTIO_BUS_GET_CLASS(qbus);
> +    VHostUserBase *vub =3D VHOST_USER_BASE(vdev);
> +    int ret, i;
> +
> +    if (!k->set_guest_notifiers) {
> +        error_report("binding does not support guest notifiers");
> +        return;
> +    }
> +
> +    ret =3D vhost_dev_enable_notifiers(&vub->vhost_dev, vdev);
> +    if (ret < 0) {
> +        error_report("Error enabling host notifiers: %d", -ret);
> +        return;
> +    }
> +
> +    ret =3D k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, tr=
ue);
> +    if (ret < 0) {
> +        error_report("Error binding guest notifier: %d", -ret);
> +        goto err_host_notifiers;
> +    }
> +
> +    vub->vhost_dev.acked_features =3D vdev->guest_features;
> +
> +    ret =3D vhost_dev_start(&vub->vhost_dev, vdev, true);
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
> +    for (i =3D 0; i < vub->vhost_dev.nvqs; i++) {
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
> +    VHostUserBase *vub =3D VHOST_USER_BASE(vdev);
> +    BusState *qbus =3D BUS(qdev_get_parent_bus(DEVICE(vdev)));
> +    VirtioBusClass *k =3D VIRTIO_BUS_GET_CLASS(qbus);
> +    int ret;
> +
> +    if (!k->set_guest_notifiers) {
> +        return;
> +    }
> +
> +    vhost_dev_stop(&vub->vhost_dev, vdev, true);
> +
> +    ret =3D k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, fa=
lse);
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
> +    VHostUserBase *vub =3D VHOST_USER_BASE(vdev);
> +    bool should_start =3D virtio_device_should_start(vdev, status);
> +
> +    if (vhost_dev_is_started(&vub->vhost_dev) =3D=3D should_start) {
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
> +                                 uint64_t requested_features, Error **er=
rp)
> +{
> +    VHostUserBase *vub =3D VHOST_USER_BASE(vdev);
> +    /* This should be set when the vhost connection initialises */
> +    g_assert(vub->vhost_dev.features);
> +    return vub->vhost_dev.features & ~(1ULL << VHOST_USER_F_PROTOCOL_FEA=
TURES);
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
> +    for (int i =3D 0; i < vub->num_vqs; i++) {
> +        VirtQueue *vq =3D g_ptr_array_index(vub->vqs, i);
> +        virtio_delete_queue(vq);
> +    }
> +
> +    virtio_cleanup(vdev);
> +}
> +
> +static int vub_connect(DeviceState *dev)
> +{
> +    VirtIODevice *vdev =3D VIRTIO_DEVICE(dev);
> +    VHostUserBase *vub =3D VHOST_USER_BASE(vdev);
> +
> +    if (vub->connected) {
> +        return 0;
> +    }
> +    vub->connected =3D true;
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
> +    VirtIODevice *vdev =3D VIRTIO_DEVICE(dev);
> +    VHostUserBase *vub =3D VHOST_USER_BASE(vdev);
> +
> +    if (!vub->connected) {
> +        return;
> +    }
> +    vub->connected =3D false;
> +
> +    if (vhost_dev_is_started(&vub->vhost_dev)) {
> +        vub_stop(vdev);
> +    }
> +}
> +
> +static void vub_event(void *opaque, QEMUChrEvent event)
> +{
> +    DeviceState *dev =3D opaque;
> +    VirtIODevice *vdev =3D VIRTIO_DEVICE(dev);
> +    VHostUserBase *vub =3D VHOST_USER_BASE(vdev);
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
> +    VirtIODevice *vdev =3D VIRTIO_DEVICE(dev);
> +    VHostUserBase *vub =3D VHOST_USER_BASE(dev);
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
> +        vub->num_vqs =3D 1; /* reasonable default? */
> +    }
> +
> +    if (!vhost_user_init(&vub->vhost_user, &vub->chardev, errp)) {
> +        return;
> +    }
> +
> +    virtio_init(vdev, vub->virtio_id, 0);
> +
> +    /*
> +     * Disable guest notifiers, by default all notifications will be via=
 the
> +     * asynchronous vhost-user socket.
> +     */
> +    vdev->use_guest_notifier_mask =3D false;
> +
> +    /* Allocate queues */
> +    vub->vqs =3D g_ptr_array_sized_new(vub->num_vqs);
> +    for (int i =3D 0; i < vub->num_vqs; i++) {
> +        g_ptr_array_add(vub->vqs,
> +                        virtio_add_queue(vdev, 4, vub_handle_output));
> +    }
> +

Hello Alex, apologies if someone already asked this. If I understand
correctly, the second parameter of virtio_add_queue() is the len of the
queue. Why have you chosen "4" as its value? Shall qemu query the len of
the queue from the vhost-user device instead?

Matias

