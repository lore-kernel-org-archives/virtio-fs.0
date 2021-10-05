Date: Tue, 5 Oct 2021 13:45:56 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YVxJBKqsytKlos6M@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<c9dea2e27ae19b2b9a51e8f08687067bf3e47bd5.1633376313.git.qemu_oss@crudebyte.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1etZgNjk4d4mzbq0"
Content-Disposition: inline
In-Reply-To: <c9dea2e27ae19b2b9a51e8f08687067bf3e47bd5.1633376313.git.qemu_oss@crudebyte.com>
Subject: Re: [Virtio-fs] [PATCH v2 1/3] virtio: turn VIRTQUEUE_MAX_SIZE into
	a variable
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christian Schoenebeck <qemu_oss@crudebyte.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, Jason Wang <jasowang@redhat.com>, Amit Shah <amit@kernel.org>, David Hildenbrand <david@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Fam Zheng <fam@euphon.net>


--1etZgNjk4d4mzbq0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 04, 2021 at 09:38:04PM +0200, Christian Schoenebeck wrote:
> Refactor VIRTQUEUE_MAX_SIZE to effectively become a runtime
> variable per virtio user.

virtio user =3D=3D virtio device model?

>=20
> Reasons:
>=20
> (1) VIRTQUEUE_MAX_SIZE should reflect the absolute theoretical
>     maximum queue size possible. Which is actually the maximum
>     queue size allowed by the virtio protocol. The appropriate
>     value for VIRTQUEUE_MAX_SIZE would therefore be 32768:
>=20
>     https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.=
html#x1-240006
>=20
>     Apparently VIRTQUEUE_MAX_SIZE was instead defined with a
>     more or less arbitrary value of 1024 in the past, which
>     limits the maximum transfer size with virtio to 4M
>     (more precise: 1024 * PAGE_SIZE, with the latter typically
>     being 4k).

Being equal to IOV_MAX is a likely reason. Buffers with more iovecs than
that cannot be passed to host system calls (sendmsg(2), pwritev(2),
etc).

> (2) Additionally the current value of 1024 poses a hidden limit,
>     invisible to guest, which causes a system hang with the
>     following QEMU error if guest tries to exceed it:
>=20
>     virtio: too many write descriptors in indirect table

I don't understand this point. 2.6.5 The Virtqueue Descriptor Table says:

  The number of descriptors in the table is defined by the queue size for t=
his virtqueue: this is the maximum possible descriptor chain length.

and 2.6.5.3.1 Driver Requirements: Indirect Descriptors says:

  A driver MUST NOT create a descriptor chain longer than the Queue Size of=
 the device.

Do you mean a broken/malicious guest driver that is violating the spec?
That's not a hidden limit, it's defined by the spec.

> (3) Unfortunately not all virtio users in QEMU would currently
>     work correctly with the new value of 32768.
>=20
> So let's turn this hard coded global value into a runtime
> variable as a first step in this commit, configurable for each
> virtio user by passing a corresponding value with virtio_init()
> call.

virtio_add_queue() already has an int queue_size argument, why isn't
that enough to deal with the maximum queue size? There's probably a good
reason for it, but please include it in the commit description.

>=20
> Signed-off-by: Christian Schoenebeck <qemu_oss@crudebyte.com>
> ---
>  hw/9pfs/virtio-9p-device.c     |  3 ++-
>  hw/block/vhost-user-blk.c      |  2 +-
>  hw/block/virtio-blk.c          |  3 ++-
>  hw/char/virtio-serial-bus.c    |  2 +-
>  hw/display/virtio-gpu-base.c   |  2 +-
>  hw/input/virtio-input.c        |  2 +-
>  hw/net/virtio-net.c            | 15 ++++++++-------
>  hw/scsi/virtio-scsi.c          |  2 +-
>  hw/virtio/vhost-user-fs.c      |  2 +-
>  hw/virtio/vhost-user-i2c.c     |  3 ++-
>  hw/virtio/vhost-vsock-common.c |  2 +-
>  hw/virtio/virtio-balloon.c     |  4 ++--
>  hw/virtio/virtio-crypto.c      |  3 ++-
>  hw/virtio/virtio-iommu.c       |  2 +-
>  hw/virtio/virtio-mem.c         |  2 +-
>  hw/virtio/virtio-pmem.c        |  2 +-
>  hw/virtio/virtio-rng.c         |  2 +-
>  hw/virtio/virtio.c             | 35 +++++++++++++++++++++++-----------
>  include/hw/virtio/virtio.h     |  5 ++++-
>  19 files changed, 57 insertions(+), 36 deletions(-)
>=20
> diff --git a/hw/9pfs/virtio-9p-device.c b/hw/9pfs/virtio-9p-device.c
> index 54ee93b71f..cd5d95dd51 100644
> --- a/hw/9pfs/virtio-9p-device.c
> +++ b/hw/9pfs/virtio-9p-device.c
> @@ -216,7 +216,8 @@ static void virtio_9p_device_realize(DeviceState *dev=
, Error **errp)
>      }
> =20
>      v->config_size =3D sizeof(struct virtio_9p_config) + strlen(s->fscon=
f.tag);
> -    virtio_init(vdev, "virtio-9p", VIRTIO_ID_9P, v->config_size);
> +    virtio_init(vdev, "virtio-9p", VIRTIO_ID_9P, v->config_size,
> +                VIRTQUEUE_MAX_SIZE);
>      v->vq =3D virtio_add_queue(vdev, MAX_REQ, handle_9p_output);
>  }
> =20
> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> index ba13cb87e5..336f56705c 100644
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -491,7 +491,7 @@ static void vhost_user_blk_device_realize(DeviceState=
 *dev, Error **errp)
>      }
> =20
>      virtio_init(vdev, "virtio-blk", VIRTIO_ID_BLOCK,
> -                sizeof(struct virtio_blk_config));
> +                sizeof(struct virtio_blk_config), VIRTQUEUE_MAX_SIZE);
> =20
>      s->virtqs =3D g_new(VirtQueue *, s->num_queues);
>      for (i =3D 0; i < s->num_queues; i++) {
> diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
> index f139cd7cc9..9c0f46815c 100644
> --- a/hw/block/virtio-blk.c
> +++ b/hw/block/virtio-blk.c
> @@ -1213,7 +1213,8 @@ static void virtio_blk_device_realize(DeviceState *=
dev, Error **errp)
> =20
>      virtio_blk_set_config_size(s, s->host_features);
> =20
> -    virtio_init(vdev, "virtio-blk", VIRTIO_ID_BLOCK, s->config_size);
> +    virtio_init(vdev, "virtio-blk", VIRTIO_ID_BLOCK, s->config_size,
> +                VIRTQUEUE_MAX_SIZE);
> =20
>      s->blk =3D conf->conf.blk;
>      s->rq =3D NULL;
> diff --git a/hw/char/virtio-serial-bus.c b/hw/char/virtio-serial-bus.c
> index f01ec2137c..9ad9111115 100644
> --- a/hw/char/virtio-serial-bus.c
> +++ b/hw/char/virtio-serial-bus.c
> @@ -1045,7 +1045,7 @@ static void virtio_serial_device_realize(DeviceStat=
e *dev, Error **errp)
>          config_size =3D offsetof(struct virtio_console_config, emerg_wr);
>      }
>      virtio_init(vdev, "virtio-serial", VIRTIO_ID_CONSOLE,
> -                config_size);
> +                config_size, VIRTQUEUE_MAX_SIZE);
> =20
>      /* Spawn a new virtio-serial bus on which the ports will ride as dev=
ices */
>      qbus_init(&vser->bus, sizeof(vser->bus), TYPE_VIRTIO_SERIAL_BUS,
> diff --git a/hw/display/virtio-gpu-base.c b/hw/display/virtio-gpu-base.c
> index c8da4806e0..20b06a7adf 100644
> --- a/hw/display/virtio-gpu-base.c
> +++ b/hw/display/virtio-gpu-base.c
> @@ -171,7 +171,7 @@ virtio_gpu_base_device_realize(DeviceState *qdev,
> =20
>      g->virtio_config.num_scanouts =3D cpu_to_le32(g->conf.max_outputs);
>      virtio_init(VIRTIO_DEVICE(g), "virtio-gpu", VIRTIO_ID_GPU,
> -                sizeof(struct virtio_gpu_config));
> +                sizeof(struct virtio_gpu_config), VIRTQUEUE_MAX_SIZE);
> =20
>      if (virtio_gpu_virgl_enabled(g->conf)) {
>          /* use larger control queue in 3d mode */
> diff --git a/hw/input/virtio-input.c b/hw/input/virtio-input.c
> index 54bcb46c74..345eb2cce7 100644
> --- a/hw/input/virtio-input.c
> +++ b/hw/input/virtio-input.c
> @@ -258,7 +258,7 @@ static void virtio_input_device_realize(DeviceState *=
dev, Error **errp)
>      assert(vinput->cfg_size <=3D sizeof(virtio_input_config));
> =20
>      virtio_init(vdev, "virtio-input", VIRTIO_ID_INPUT,
> -                vinput->cfg_size);
> +                vinput->cfg_size, VIRTQUEUE_MAX_SIZE);
>      vinput->evt =3D virtio_add_queue(vdev, 64, virtio_input_handle_evt);
>      vinput->sts =3D virtio_add_queue(vdev, 64, virtio_input_handle_sts);
>  }
> diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
> index f205331dcf..f74b5f6268 100644
> --- a/hw/net/virtio-net.c
> +++ b/hw/net/virtio-net.c
> @@ -1746,9 +1746,9 @@ static ssize_t virtio_net_receive_rcu(NetClientStat=
e *nc, const uint8_t *buf,
>      VirtIONet *n =3D qemu_get_nic_opaque(nc);
>      VirtIONetQueue *q =3D virtio_net_get_subqueue(nc);
>      VirtIODevice *vdev =3D VIRTIO_DEVICE(n);
> -    VirtQueueElement *elems[VIRTQUEUE_MAX_SIZE];
> -    size_t lens[VIRTQUEUE_MAX_SIZE];
> -    struct iovec mhdr_sg[VIRTQUEUE_MAX_SIZE];
> +    VirtQueueElement *elems[vdev->queue_max_size];
> +    size_t lens[vdev->queue_max_size];
> +    struct iovec mhdr_sg[vdev->queue_max_size];

Can you make this value per-vq instead of per-vdev since virtqueues can
have different queue sizes?

The same applies to the rest of this patch. Anything using
vdev->queue_max_size should probably use vq->vring.num instead.

--1etZgNjk4d4mzbq0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFcSQQACgkQnKSrs4Gr
c8hrsAf/TA5H5Q3u1uLa9YtVuqwhBwEKcQVlG9VgXmh2lhhAjrkOGtBqt3a3FSIa
Yz4ERbLyDw8j+Cxdtt0rWYZCyRXtge5dQSvUkfxWBSrF8ZMIZPYs3JTWGRCZrDOw
msZ5yzwnM6lcI0/VXsgUVBwHejKh1d0L40svfPR6ccH8yzYqYcqf301cDC8wTn11
BRnq0ZHJmirSA9Es46j9oV1JVJbaXAf3E05edIIt2OHOmZge5on7Gf64Cx8YV1Vu
ACJct4BkBCdObOrNT6ZQr7ZYJCMWGdvTiZRQa74N2XowyXo8lEjhQeBFbOR4LN1K
XyO+h0gx4XvpIcMSWf8F+sQ7yzyFaw==
=MM9Z
-----END PGP SIGNATURE-----

--1etZgNjk4d4mzbq0--

