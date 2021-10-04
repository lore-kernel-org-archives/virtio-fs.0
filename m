Date: Mon, 4 Oct 2021 15:33:47 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YVsQyxaPHyChcOel@stefanha-x1.localdomain>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-10-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WPlcQ8i1nUBRp1hu"
Content-Disposition: inline
In-Reply-To: <20210930153037.1194279-10-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 09/13] virtiofsd: Specify size of
 notification buffer using config space
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, qemu-devel@nongnu.org, virtio-fs@redhat.com


--WPlcQ8i1nUBRp1hu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 30, 2021 at 11:30:33AM -0400, Vivek Goyal wrote:
> Daemon specifies size of notification buffer needed and that should be
> done using config space.
>=20
> Only ->notify_buf_size value of config space comes from daemon. Rest of
> it is filled by qemu device emulation code.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
> ---
>  hw/virtio/vhost-user-fs.c                  | 27 +++++++++++++++++++
>  include/hw/virtio/vhost-user-fs.h          |  2 ++
>  include/standard-headers/linux/virtio_fs.h |  2 ++
>  tools/virtiofsd/fuse_virtio.c              | 31 ++++++++++++++++++++++
>  4 files changed, 62 insertions(+)
>=20
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index 6bafcf0243..68a94708b4 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -36,15 +36,41 @@ static const int user_feature_bits[] =3D {
>      VHOST_INVALID_FEATURE_BIT
>  };
> =20
> +static int vhost_user_fs_handle_config_change(struct vhost_dev *dev)
> +{
> +    return 0;
> +}
> +
> +const VhostDevConfigOps fs_ops =3D {
> +    .vhost_dev_config_notifier =3D vhost_user_fs_handle_config_change,
> +};
> +
>  static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
>  {
>      VHostUserFS *fs =3D VHOST_USER_FS(vdev);
>      struct virtio_fs_config fscfg =3D {};
> +    Error *local_err =3D NULL;
> +    int ret;
> +
> +    /*
> +     * As of now we only get notification buffer size from device. And t=
hat's
> +     * needed only if notification queue is enabled.
> +     */
> +    if (fs->notify_enabled) {
> +        ret =3D vhost_dev_get_config(&fs->vhost_dev, (uint8_t *)&fs->fsc=
fg,
> +                                   sizeof(struct virtio_fs_config),
> +                                   &local_err);
> +        if (ret) {
> +            error_report_err(local_err);
> +            return;
> +        }
> +    }
> =20
>      memcpy((char *)fscfg.tag, fs->conf.tag,
>             MIN(strlen(fs->conf.tag) + 1, sizeof(fscfg.tag)));
> =20
>      virtio_stl_p(vdev, &fscfg.num_request_queues, fs->conf.num_request_q=
ueues);
> +    virtio_stl_p(vdev, &fscfg.notify_buf_size, fs->fscfg.notify_buf_size=
);
> =20
>      memcpy(config, &fscfg, sizeof(fscfg));
>  }
> @@ -316,6 +342,7 @@ static void vuf_device_realize(DeviceState *dev, Erro=
r **errp)
>                  sizeof(struct virtio_fs_config));
> =20
>      vuf_create_vqs(vdev, true);
> +    vhost_dev_set_config_notifier(&fs->vhost_dev, &fs_ops);
>      ret =3D vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
>                           VHOST_BACKEND_TYPE_USER, 0, errp);
>      if (ret < 0) {
> diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-=
user-fs.h
> index 95dc0dd402..3b114ee260 100644
> --- a/include/hw/virtio/vhost-user-fs.h
> +++ b/include/hw/virtio/vhost-user-fs.h
> @@ -14,6 +14,7 @@
>  #ifndef _QEMU_VHOST_USER_FS_H
>  #define _QEMU_VHOST_USER_FS_H
> =20
> +#include "standard-headers/linux/virtio_fs.h"
>  #include "hw/virtio/virtio.h"
>  #include "hw/virtio/vhost.h"
>  #include "hw/virtio/vhost-user.h"
> @@ -37,6 +38,7 @@ struct VHostUserFS {
>      struct vhost_virtqueue *vhost_vqs;
>      struct vhost_dev vhost_dev;
>      VhostUserState vhost_user;
> +    struct virtio_fs_config fscfg;
>      VirtQueue **req_vqs;
>      VirtQueue *hiprio_vq;
>      VirtQueue *notification_vq;
> diff --git a/include/standard-headers/linux/virtio_fs.h b/include/standar=
d-headers/linux/virtio_fs.h
> index b7f015186e..867d18acf6 100644
> --- a/include/standard-headers/linux/virtio_fs.h
> +++ b/include/standard-headers/linux/virtio_fs.h
> @@ -17,6 +17,8 @@ struct virtio_fs_config {
> =20
>  	/* Number of request queues */
>  	uint32_t num_request_queues;
> +	/* Size of notification buffer */
> +	uint32_t notify_buf_size;
>  } QEMU_PACKED;
> =20
>  /* For the id field in virtio_pci_shm_cap */

Please put all the include/standard-headers/linux/ changes into a single
commit that imports these changes from linux.git. Changes to this header
shouldn't be hand-written, use scripts/update-linux-headers.sh instead.

> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index f5b87a508a..3b720c5d4a 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -856,6 +856,35 @@ static bool fv_queue_order(VuDev *dev, int qidx)
>      return false;
>  }
> =20
> +static uint64_t fv_get_protocol_features(VuDev *dev)
> +{
> +    return 1ull << VHOST_USER_PROTOCOL_F_CONFIG;
> +}
> +
> +static int fv_get_config(VuDev *dev, uint8_t *config, uint32_t len)
> +{
> +    struct virtio_fs_config fscfg =3D {};
> +    unsigned notify_size, roundto =3D 64;
> +    union fuse_notify_union {
> +        struct fuse_notify_poll_wakeup_out  wakeup_out;
> +        struct fuse_notify_inval_inode_out  inode_out;
> +        struct fuse_notify_inval_entry_out  entry_out;
> +        struct fuse_notify_delete_out       delete_out;
> +        struct fuse_notify_store_out        store_out;
> +        struct fuse_notify_retrieve_out     retrieve_out;
> +    };
> +
> +    notify_size =3D sizeof(struct fuse_out_header) +
> +              sizeof(union fuse_notify_union);
> +    notify_size =3D ((notify_size + roundto) / roundto) * roundto;

Why is the size rounded to 64 bytes?

--WPlcQ8i1nUBRp1hu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFbEMsACgkQnKSrs4Gr
c8hyBggAwOxF2L640Vklsmwx/tmQjBMHiL2GL1r8KLwwJGcMo+f6ZkKE/K7TkA50
3Ipifu2xCd+vbaH/qpud8YPWANwFEUxMOrx3uqXWCHP2OUGz/XCcXLkyQQRdXMQu
O7UGzD0ac2imfl4yrAykpjwjvhLtTgKIs6Ul+D1UgQaVdu1RpIfcTShwerhp9iN+
SvN5oX6UqbQiRZUBhVvAXnUB3G90HAJ+dzPted+9sW+OF/438OBZAt3APMNw99/p
QMAL+BJMCA3otw35ZuOWxrs6/rDm/4yvsCk+tWPy8ch/J3EKyx/xhPnCOFEX4FcQ
9ByvvlLRACl8Z0+RYTTL1KcV3QCsDQ==
=prAC
-----END PGP SIGNATURE-----

--WPlcQ8i1nUBRp1hu--

