Return-Path: <mst@redhat.com>
Date: Thu, 3 Nov 2022 12:39:46 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20221103123932-mutt-send-email-mst@kernel.org>
References: <20220802095010.3330793-1-alex.bennee@linaro.org>
 <20220802095010.3330793-12-alex.bennee@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20220802095010.3330793-12-alex.bennee@linaro.org>
Content-Type: text/plain; charset="windows-1252"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v4 11/22] hw/virtio: move vhd->started check
 into helper and add FIXME
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, slp@redhat.com, marcandre.lureau@redhat.com, stefanha@redhat.com, mathieu.poirier@linaro.org, viresh.kumar@linaro.org, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>

On Tue, Aug 02, 2022 at 10:49:59AM +0100, Alex Benn=E9e wrote:
> The `started` field is manipulated internally within the vhost code
> except for one place, vhost-user-blk via f5b22d06fb (vhost: recheck
> dev state in the vhost_migration_log routine). Mark that as a FIXME
> because it introduces a potential race. I think the referenced fix
> should be tracking its state locally.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>

And I guess this for good measure.

> ---
>  include/hw/virtio/vhost.h      | 12 ++++++++++++
>  hw/block/vhost-user-blk.c      | 10 ++++++++--
>  hw/scsi/vhost-scsi.c           |  4 ++--
>  hw/scsi/vhost-user-scsi.c      |  2 +-
>  hw/virtio/vhost-user-fs.c      |  3 ++-
>  hw/virtio/vhost-user-i2c.c     |  4 ++--
>  hw/virtio/vhost-user-rng.c     |  4 ++--
>  hw/virtio/vhost-user-vsock.c   |  2 +-
>  hw/virtio/vhost-vsock-common.c |  3 ++-
>  hw/virtio/vhost-vsock.c        |  2 +-
>  10 files changed, 33 insertions(+), 13 deletions(-)
>=20
> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> index 586c5457e2..61b957e927 100644
> --- a/include/hw/virtio/vhost.h
> +++ b/include/hw/virtio/vhost.h
> @@ -94,6 +94,7 @@ struct vhost_dev {
>      uint64_t protocol_features;
>      uint64_t max_queues;
>      uint64_t backend_cap;
> +    /* @started: is the vhost device started? */
>      bool started;
>      bool log_enabled;
>      uint64_t log_size;
> @@ -165,6 +166,17 @@ int vhost_dev_enable_notifiers(struct vhost_dev *hde=
v, VirtIODevice *vdev);
>   */
>  void vhost_dev_disable_notifiers(struct vhost_dev *hdev, VirtIODevice *v=
dev);
> =20
> +/**
> + * vhost_dev_is_started() - report status of vhost device
> + * @hdev: common vhost_dev structure
> + *
> + * Return the started status of the vhost device
> + */
> +static inline bool vhost_dev_is_started(struct vhost_dev *hdev)
> +{
> +    return hdev->started;
> +}
> +
>  /**
>   * vhost_dev_start() - start the vhost device
>   * @hdev: common vhost_dev structure
> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> index 9117222456..2bba42478d 100644
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -229,7 +229,7 @@ static void vhost_user_blk_set_status(VirtIODevice *v=
dev, uint8_t status)
>          return;
>      }
> =20
> -    if (s->dev.started =3D=3D should_start) {
> +    if (vhost_dev_is_started(&s->dev) =3D=3D should_start) {
>          return;
>      }
> =20
> @@ -286,7 +286,7 @@ static void vhost_user_blk_handle_output(VirtIODevice=
 *vdev, VirtQueue *vq)
>          return;
>      }
> =20
> -    if (s->dev.started) {
> +    if (vhost_dev_is_started(&s->dev)) {
>          return;
>      }
> =20
> @@ -415,6 +415,12 @@ static void vhost_user_blk_event(void *opaque, QEMUC=
hrEvent event)
>               * the vhost migration code. If disconnect was caught there =
is an
>               * option for the general vhost code to get the dev state wi=
thout
>               * knowing its type (in this case vhost-user).
> +             *
> +             * FIXME: this is sketchy to be reaching into vhost_dev
> +             * now because we are forcing something that implies we
> +             * have executed vhost_dev_stop() but that won't happen
> +             * until vhost_user_blk_stop() gets called from the bh.
> +             * Really this state check should be tracked locally.
>               */
>              s->dev.started =3D false;
>          }
> diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
> index 3059068175..bdf337a7a2 100644
> --- a/hw/scsi/vhost-scsi.c
> +++ b/hw/scsi/vhost-scsi.c
> @@ -120,7 +120,7 @@ static void vhost_scsi_set_status(VirtIODevice *vdev,=
 uint8_t val)
>          start =3D false;
>      }
> =20
> -    if (vsc->dev.started =3D=3D start) {
> +    if (vhost_dev_is_started(&vsc->dev) =3D=3D start) {
>          return;
>      }
> =20
> @@ -147,7 +147,7 @@ static int vhost_scsi_pre_save(void *opaque)
> =20
>      /* At this point, backend must be stopped, otherwise
>       * it might keep writing to memory. */
> -    assert(!vsc->dev.started);
> +    assert(!vhost_dev_is_started(&vsc->dev));
> =20
>      return 0;
>  }
> diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
> index 1b2f7eed98..bc37317d55 100644
> --- a/hw/scsi/vhost-user-scsi.c
> +++ b/hw/scsi/vhost-user-scsi.c
> @@ -49,7 +49,7 @@ static void vhost_user_scsi_set_status(VirtIODevice *vd=
ev, uint8_t status)
>      VHostSCSICommon *vsc =3D VHOST_SCSI_COMMON(s);
>      bool start =3D (status & VIRTIO_CONFIG_S_DRIVER_OK) && vdev->vm_runn=
ing;
> =20
> -    if (vsc->dev.started =3D=3D start) {
> +    if (vhost_dev_is_started(&vsc->dev) =3D=3D start) {
>          return;
>      }
> =20
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index d2bebba785..ad0f91c607 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -20,6 +20,7 @@
>  #include "hw/virtio/virtio-bus.h"
>  #include "hw/virtio/virtio-access.h"
>  #include "qemu/error-report.h"
> +#include "hw/virtio/vhost.h"
>  #include "hw/virtio/vhost-user-fs.h"
>  #include "monitor/monitor.h"
>  #include "sysemu/sysemu.h"
> @@ -124,7 +125,7 @@ static void vuf_set_status(VirtIODevice *vdev, uint8_=
t status)
>      VHostUserFS *fs =3D VHOST_USER_FS(vdev);
>      bool should_start =3D virtio_device_started(vdev, status);
> =20
> -    if (fs->vhost_dev.started =3D=3D should_start) {
> +    if (vhost_dev_is_started(&fs->vhost_dev) =3D=3D should_start) {
>          return;
>      }
> =20
> diff --git a/hw/virtio/vhost-user-i2c.c b/hw/virtio/vhost-user-i2c.c
> index b930cf6d5e..bc58b6c0d1 100644
> --- a/hw/virtio/vhost-user-i2c.c
> +++ b/hw/virtio/vhost-user-i2c.c
> @@ -95,7 +95,7 @@ static void vu_i2c_set_status(VirtIODevice *vdev, uint8=
_t status)
>      VHostUserI2C *i2c =3D VHOST_USER_I2C(vdev);
>      bool should_start =3D virtio_device_started(vdev, status);
> =20
> -    if (i2c->vhost_dev.started =3D=3D should_start) {
> +    if (vhost_dev_is_started(&i2c->vhost_dev) =3D=3D should_start) {
>          return;
>      }
> =20
> @@ -174,7 +174,7 @@ static void vu_i2c_disconnect(DeviceState *dev)
>      }
>      i2c->connected =3D false;
> =20
> -    if (i2c->vhost_dev.started) {
> +    if (vhost_dev_is_started(&i2c->vhost_dev)) {
>          vu_i2c_stop(vdev);
>      }
>  }
> diff --git a/hw/virtio/vhost-user-rng.c b/hw/virtio/vhost-user-rng.c
> index a9c1c4bc79..bc1f36c5ac 100644
> --- a/hw/virtio/vhost-user-rng.c
> +++ b/hw/virtio/vhost-user-rng.c
> @@ -92,7 +92,7 @@ static void vu_rng_set_status(VirtIODevice *vdev, uint8=
_t status)
>      VHostUserRNG *rng =3D VHOST_USER_RNG(vdev);
>      bool should_start =3D virtio_device_started(vdev, status);
> =20
> -    if (rng->vhost_dev.started =3D=3D should_start) {
> +    if (vhost_dev_is_started(&rng->vhost_dev) =3D=3D should_start) {
>          return;
>      }
> =20
> @@ -160,7 +160,7 @@ static void vu_rng_disconnect(DeviceState *dev)
> =20
>      rng->connected =3D false;
> =20
> -    if (rng->vhost_dev.started) {
> +    if (vhost_dev_is_started(&rng->vhost_dev)) {
>          vu_rng_stop(vdev);
>      }
>  }
> diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
> index 22c1616ebd..7b67e29d83 100644
> --- a/hw/virtio/vhost-user-vsock.c
> +++ b/hw/virtio/vhost-user-vsock.c
> @@ -57,7 +57,7 @@ static void vuv_set_status(VirtIODevice *vdev, uint8_t =
status)
>      VHostVSockCommon *vvc =3D VHOST_VSOCK_COMMON(vdev);
>      bool should_start =3D virtio_device_started(vdev, status);
> =20
> -    if (vvc->vhost_dev.started =3D=3D should_start) {
> +    if (vhost_dev_is_started(&vvc->vhost_dev) =3D=3D should_start) {
>          return;
>      }
> =20
> diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-commo=
n.c
> index 7394818e00..29b9ab4f72 100644
> --- a/hw/virtio/vhost-vsock-common.c
> +++ b/hw/virtio/vhost-vsock-common.c
> @@ -14,6 +14,7 @@
>  #include "hw/virtio/virtio-access.h"
>  #include "qemu/error-report.h"
>  #include "hw/qdev-properties.h"
> +#include "hw/virtio/vhost.h"
>  #include "hw/virtio/vhost-vsock.h"
>  #include "qemu/iov.h"
>  #include "monitor/monitor.h"
> @@ -199,7 +200,7 @@ int vhost_vsock_common_pre_save(void *opaque)
>       * At this point, backend must be stopped, otherwise
>       * it might keep writing to memory.
>       */
> -    assert(!vvc->vhost_dev.started);
> +    assert(!vhost_dev_is_started(&vvc->vhost_dev));
> =20
>      return 0;
>  }
> diff --git a/hw/virtio/vhost-vsock.c b/hw/virtio/vhost-vsock.c
> index 8031c164a5..7dc3c73931 100644
> --- a/hw/virtio/vhost-vsock.c
> +++ b/hw/virtio/vhost-vsock.c
> @@ -73,7 +73,7 @@ static void vhost_vsock_set_status(VirtIODevice *vdev, =
uint8_t status)
>      bool should_start =3D virtio_device_started(vdev, status);
>      int ret;
> =20
> -    if (vvc->vhost_dev.started =3D=3D should_start) {
> +    if (vhost_dev_is_started(&vvc->vhost_dev) =3D=3D should_start) {
>          return;
>      }
> =20
> --=20
> 2.30.2

