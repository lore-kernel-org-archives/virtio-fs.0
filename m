Date: Fri, 22 Nov 2019 10:33:00 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191122103300.GD464656@stefanha-x1.localdomain>
References: <20191115205543.1816-1-vgoyal@redhat.com>
	<20191115205543.1816-4-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="AbQceqfdZEv+FvjW"
Content-Disposition: inline
In-Reply-To: <20191115205543.1816-4-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 3/4] virtiofsd: Specify size of notification
 buffer using config space
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, miklos@szeredi.hu, qemu-devel@nongnu.org


--AbQceqfdZEv+FvjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2019 at 03:55:42PM -0500, Vivek Goyal wrote:
> diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_vir=
tio.c
> index 411114c9b3..982b6ad0bd 100644
> --- a/contrib/virtiofsd/fuse_virtio.c
> +++ b/contrib/virtiofsd/fuse_virtio.c
> @@ -109,7 +109,8 @@ static uint64_t fv_get_features(VuDev *dev)
>      uint64_t features;
> =20
>      features =3D 1ull << VIRTIO_F_VERSION_1 |
> -               1ull << VIRTIO_FS_F_NOTIFICATION;
> +               1ull << VIRTIO_FS_F_NOTIFICATION |
> +               1ull << VHOST_USER_F_PROTOCOL_FEATURES;

This is not needed since VHOST_USER_F_PROTOCOL_FEATURES is already added
by vu_get_features_exec():

  vu_get_features_exec(VuDev *dev, VhostUserMsg *vmsg)
  {
      vmsg->payload.u64 =3D
          1ULL << VHOST_F_LOG_ALL |
          1ULL << VHOST_USER_F_PROTOCOL_FEATURES;

      if (dev->iface->get_features) {
          vmsg->payload.u64 |=3D dev->iface->get_features(dev);
      }

> =20
>      return features;
>  }
> @@ -927,6 +928,27 @@ static bool fv_queue_order(VuDev *dev, int qidx)
>      return false;
>  }
> =20
> +static uint64_t fv_get_protocol_features(VuDev *dev)
> +{
> +	return 1ull << VHOST_USER_PROTOCOL_F_CONFIG;
> +}

Please change vu_get_protocol_features_exec() in a separate patch so
that devices don't need this boilerplate .get_protocol_features() code:

  static bool
  vu_get_protocol_features_exec(VuDev *dev, VhostUserMsg *vmsg)
  {
      ...
 -    if (dev->iface->get_config && dev->iface->set_config) {
 +    if (dev->iface->get_config || dev->iface->set_config) {
          features |=3D 1ULL << VHOST_USER_PROTOCOL_F_CONFIG;
      }

> +
> +static int fv_get_config(VuDev *dev, uint8_t *config, uint32_t len)
> +{
> +	struct virtio_fs_config fscfg =3D {};
> +
> +	fuse_log(FUSE_LOG_DEBUG, "%s:Setting notify_buf_size=3D%d\n", __func__,
> +                 sizeof(struct fuse_notify_lock_out));
> +	/*
> +	 * As of now only notification related to lock is supported. As more
> +	 * notification types are supported, bump up the size accordingly.
> +	 */
> +	fscfg.notify_buf_size =3D sizeof(struct fuse_notify_lock_out);

Missing cpu_to_le32().

I'm not sure about specifying the size precisely down to the last byte
because any change to guest-visible aspects of the device (like VIRTIO
Configuration Space) are not compatible across live migration.  It will
be necessary to introduce a device version command-line option for live
migration compatibility so that existing guests can be migrated to a new
virtiofsd without the device changing underneath them.

How about rounding this up to 4 KB?

>  static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
>  {
>      VHostUserFS *fs =3D VHOST_USER_FS(vdev);
>      struct virtio_fs_config fscfg =3D {};
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
> +                                   sizeof(struct virtio_fs_config));
> +	if (ret < 0) {

Indentation.

> +            error_report("vhost-user-fs: get device config space failed."
> +                         " ret=3D%d\n", ret);
> +            return;
> +        }

Missing le32_to_cpu() for notify_buf_size.

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
> @@ -545,6 +569,8 @@ static void vuf_device_realize(DeviceState *dev, Erro=
r **errp)
>      fs->vhost_dev.nvqs =3D 2 + fs->conf.num_request_queues;
> =20
>      fs->vhost_dev.vqs =3D g_new0(struct vhost_virtqueue, fs->vhost_dev.n=
vqs);
> +
> +    vhost_dev_set_config_notifier(&fs->vhost_dev, &fs_ops);

Is this really needed since vhost_user_fs_handle_config_change() ignores
it?

--AbQceqfdZEv+FvjW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3XuVsACgkQnKSrs4Gr
c8j4VggAi4w8EWBDE1nc8SdYJWXqXT0eFyXBrX9mIEcJ6pWiISozM5q8hpaUfwuu
yNM9kc1LNMHjbMULZRDncuQnJFmNyWnveseerrFktRyu+CnZs2dVtGcc/yMmRQhf
PlnCfInyMVwC7gP7MMqyrVYVW7ut0ROue2IggeCYw163pz9/zjWoTDGQTY7IzC3j
8zYw4WxCeF296HS/KOOcgoYzqAg80s6lU019SLmkHRtaZ6N/Gec6NiDlwYpacxRU
2YGhbbEUVuRo+q1fSHayH3ADUbPEel/rgNtH45Csxk+4xmpT8hXGWS0VhwP/eNA+
zDkAE33WTkLyXCHFh0STAWxFpqfT0w==
=OEYD
-----END PGP SIGNATURE-----

--AbQceqfdZEv+FvjW--

