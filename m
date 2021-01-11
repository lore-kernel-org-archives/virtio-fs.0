DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
	h=subject : to : cc :
	references : from : message-id : date : mime-version : in-reply-to :
	content-type : content-transfer-encoding; s=pp1;
	bh=ItrIfx1YNuyHTNeOf33J+V0QCsMMJ872rZLTmqbNzT8=;
	b=eW8p9s+apV4yn68mQd5n9R0CyxfKLKBTcc2u4c5HUFwDaCe+ASqOrZCALP1k7OlOabCT
	8NVcAqMhT6Xuy+ULaGm+Ri4bj8vBeH2dcGOg1PrpncxloVfgLZzR3p/vEB/zTaWKsP6Z
	frsd1g/MtJ/eMI3AK0HQcznNDTTD5NvS8GdXvyEMGXp7zDfN3jwo1qn/rEbHO/MFf1tR
	15KgV7LbfodpJCKq4CAGfJcwDCdYAKvJcECmIaTLR5CsjjiJAsILr/hijETSI72vCgH1
	7RrqdEHEdCMJSSQYtPduaUGrexa7z3mJ2lRDVTqThOkhEj0ESgpdI1G7jQ/XqPeFuy5W
	eQ==
References: <20210104132401.5100-1-lersek@redhat.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <f296274e-3c4b-bb90-ca4a-273c3bd97f7f@de.ibm.com>
Date: Mon, 11 Jan 2021 10:46:06 +0100
MIME-Version: 1.0
In-Reply-To: <20210104132401.5100-1-lersek@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH] vhost-user-fs: add the "bootindex" property
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Laszlo Ersek <lersek@redhat.com>, qemu devel list <qemu-devel@nongnu.org>
Cc: virtio-fs@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, qemu-s390x@nongnu.org



On 04.01.21 14:24, Laszlo Ersek wrote:
> virtio-fs qualifies as a bootable device minimally under OVMF, but
> currently the necessary "bootindex" property is missing (fw_cfg kernel
> boot notwithstanding).
> 
> Add the property. For completeness, add it to the CCW device as well;
> other virtio-ccw devices seem to have "bootindex" properties too.

Currently we do not have boot support for virtiofs on s390x (ccw)
Not sure if it is better if we should add the property now or whenever
boot support is implemented. 
As of today we do have bootindex for block and net. Maybe it is better
to defer bootindex for virtio-fs-ccw until we can boot from it? In
that way management software can detect if this is bootable or not?

> 
> Example OpenFirmware device path for the "vhost-user-fs-pci" device in the
> "bootorder" fw_cfg file:
> 
>   /pci@i0cf8/pci-bridge@1,6/pci1af4,105a@0/filesystem@0
> 
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: qemu-s390x@nongnu.org
> Cc: virtio-fs@redhat.com
> Signed-off-by: Laszlo Ersek <lersek@redhat.com>
> ---
>  include/hw/virtio/vhost-user-fs.h |  1 +
>  hw/s390x/vhost-user-fs-ccw.c      |  2 ++
>  hw/virtio/vhost-user-fs-pci.c     |  2 ++
>  hw/virtio/vhost-user-fs.c         | 10 ++++++++++
>  4 files changed, 15 insertions(+)
> 
> diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
> index 698575277101..0d62834c2510 100644
> --- a/include/hw/virtio/vhost-user-fs.h
> +++ b/include/hw/virtio/vhost-user-fs.h
> @@ -39,6 +39,7 @@ struct VHostUserFS {
>      VhostUserState vhost_user;
>      VirtQueue **req_vqs;
>      VirtQueue *hiprio_vq;
> +    int32_t bootindex;
>  
>      /*< public >*/
>  };
> diff --git a/hw/s390x/vhost-user-fs-ccw.c b/hw/s390x/vhost-user-fs-ccw.c
> index 6c6f26929301..474e97e937b8 100644
> --- a/hw/s390x/vhost-user-fs-ccw.c
> +++ b/hw/s390x/vhost-user-fs-ccw.c
> @@ -47,6 +47,8 @@ static void vhost_user_fs_ccw_instance_init(Object *obj)
>      ccw_dev->force_revision_1 = true;
>      virtio_instance_init_common(obj, &dev->vdev, sizeof(dev->vdev),
>                                  TYPE_VHOST_USER_FS);
> +    object_property_add_alias(obj, "bootindex", OBJECT(&dev->vdev),
> +                              "bootindex");
>  }
>  
>  static void vhost_user_fs_ccw_class_init(ObjectClass *klass, void *data)
> diff --git a/hw/virtio/vhost-user-fs-pci.c b/hw/virtio/vhost-user-fs-pci.c
> index 8bb389bd282a..2ed8492b3fa3 100644
> --- a/hw/virtio/vhost-user-fs-pci.c
> +++ b/hw/virtio/vhost-user-fs-pci.c
> @@ -68,6 +68,8 @@ static void vhost_user_fs_pci_instance_init(Object *obj)
>  
>      virtio_instance_init_common(obj, &dev->vdev, sizeof(dev->vdev),
>                                  TYPE_VHOST_USER_FS);
> +    object_property_add_alias(obj, "bootindex", OBJECT(&dev->vdev),
> +                              "bootindex");
>  }
>  
>  static const VirtioPCIDeviceTypeInfo vhost_user_fs_pci_info = {
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index ed036ad9c13f..ac4fc34b36a2 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -22,6 +22,7 @@
>  #include "qemu/error-report.h"
>  #include "hw/virtio/vhost-user-fs.h"
>  #include "monitor/monitor.h"
> +#include "sysemu/sysemu.h"
>  
>  static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
>  {
> @@ -279,6 +280,14 @@ static Property vuf_properties[] = {
>      DEFINE_PROP_END_OF_LIST(),
>  };
>  
> +static void vuf_instance_init(Object *obj)
> +{
> +    VHostUserFS *fs = VHOST_USER_FS(obj);
> +
> +    device_add_bootindex_property(obj, &fs->bootindex, "bootindex",
> +                                  "/filesystem@0", DEVICE(obj));
> +}
> +
>  static void vuf_class_init(ObjectClass *klass, void *data)
>  {
>      DeviceClass *dc = DEVICE_CLASS(klass);
> @@ -300,6 +309,7 @@ static const TypeInfo vuf_info = {
>      .name = TYPE_VHOST_USER_FS,
>      .parent = TYPE_VIRTIO_DEVICE,
>      .instance_size = sizeof(VHostUserFS),
> +    .instance_init = vuf_instance_init,
>      .class_init = vuf_class_init,
>  };
>  
> 

