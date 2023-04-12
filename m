Return-Path: <stefanha@redhat.com>
Date: Wed, 12 Apr 2023 16:51:38 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230412205138.GA2813183@fedora>
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-2-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="rRJT1mSd1+ho7w0n"
Content-Disposition: inline
In-Reply-To: <20230411150515.14020-2-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/4] vhost: Re-enable vrings after setting
 features
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Roman Kagan <rvkagan@yandex-team.ru>, Maxime Coquelin <maxime.coquelin@redhat.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>


--rRJT1mSd1+ho7w0n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 11, 2023 at 05:05:12PM +0200, Hanna Czenczek wrote:
> If the back-end supports the VHOST_USER_F_PROTOCOL_FEATURES feature,
> setting the vhost features will set this feature, too.  Doing so
> disables all vrings, which may not be intended.
>=20
> For example, enabling or disabling logging during migration requires
> setting those features (to set or unset VHOST_F_LOG_ALL), which will
> automatically disable all vrings.  In either case, the VM is running
> (disabling logging is done after a failed or cancelled migration, and
> only once the VM is running again, see comment in
> memory_global_dirty_log_stop()), so the vrings should really be enabled.
> As a result, the back-end seems to hang.
>=20
> To fix this, we must remember whether the vrings are supposed to be
> enabled, and, if so, re-enable them after a SET_FEATURES call that set
> VHOST_USER_F_PROTOCOL_FEATURES.
>=20
> It seems less than ideal that there is a short period in which the VM is
> running but the vrings will be stopped (between SET_FEATURES and
> SET_VRING_ENABLE).  To fix this, we would need to change the protocol,
> e.g. by introducing a new flag or vhost-user protocol feature to disable
> disabling vrings whenever VHOST_USER_F_PROTOCOL_FEATURES is set, or add
> new functions for setting/clearing singular feature bits (so that
> F_LOG_ALL can be set/cleared without touching F_PROTOCOL_FEATURES).
>=20
> Even with such a potential addition to the protocol, we still need this
> fix here, because we cannot expect that back-ends will implement this
> addition.
>=20
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  include/hw/virtio/vhost.h | 10 ++++++++++
>  hw/virtio/vhost.c         | 13 +++++++++++++
>  2 files changed, 23 insertions(+)
>=20
> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> index a52f273347..2fe02ed5d4 100644
> --- a/include/hw/virtio/vhost.h
> +++ b/include/hw/virtio/vhost.h
> @@ -90,6 +90,16 @@ struct vhost_dev {
>      int vq_index_end;
>      /* if non-zero, minimum required value for max_queues */
>      int num_queues;
> +
> +    /*
> +     * Whether the virtqueues are supposed to be enabled (via
> +     * SET_VRING_ENABLE).  Setting the features (e.g. for
> +     * enabling/disabling logging) will disable all virtqueues if
> +     * VHOST_USER_F_PROTOCOL_FEATURES is set, so then we need to
> +     * re-enable them if this field is set.
> +     */
> +    bool enable_vqs;
> +
>      /**
>       * vhost feature handling requires matching the feature set
>       * offered by a backend which may be a subset of the total
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index a266396576..cbff589efa 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -50,6 +50,8 @@ static unsigned int used_memslots;
>  static QLIST_HEAD(, vhost_dev) vhost_devices =3D
>      QLIST_HEAD_INITIALIZER(vhost_devices);
> =20
> +static int vhost_dev_set_vring_enable(struct vhost_dev *hdev, int enable=
);
> +
>  bool vhost_has_free_slot(void)
>  {
>      unsigned int slots_limit =3D ~0U;
> @@ -899,6 +901,15 @@ static int vhost_dev_set_features(struct vhost_dev *=
dev,
>          }
>      }
> =20
> +    if (dev->enable_vqs) {
> +        /*
> +         * Setting VHOST_USER_F_PROTOCOL_FEATURES would have disabled all
> +         * virtqueues, even if that was not intended; re-enable them if
> +         * necessary.
> +         */
> +        vhost_dev_set_vring_enable(dev, true);
> +    }
> +
>  out:
>      return r;
>  }
> @@ -1896,6 +1907,8 @@ int vhost_dev_get_inflight(struct vhost_dev *dev, u=
int16_t queue_size,
> =20
>  static int vhost_dev_set_vring_enable(struct vhost_dev *hdev, int enable)
>  {
> +    hdev->enable_vqs =3D enable;
> +
>      if (!hdev->vhost_ops->vhost_set_vring_enable) {
>          return 0;
>      }

The vhost-user spec doesn't say that VHOST_F_LOG_ALL needs to be toggled
at runtime and I don't think VHOST_USER_SET_PROTOCOL_FEATURES is
intended to be used like that. This issue shows why doing so is a bad
idea.

VHOST_F_LOG_ALL does not need to be toggled to control logging. Logging
is controlled at runtime by the presence of the dirty log
(VHOST_USER_SET_LOG_BASE) and the per-vring logging flag
(VHOST_VRING_F_LOG).

I suggest permanently enabling VHOST_F_LOG_ALL upon connection when the
the backend supports it. No spec changes are required.

libvhost-user looks like it will work. I didn't look at DPDK/SPDK, but
checking that it works there is important too.

I have CCed people who may be interested in this issue. This is the
first time I've looked at vhost-user logging, so this idea may not work.

Stefan

--rRJT1mSd1+ho7w0n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQ3GdoACgkQnKSrs4Gr
c8gRgAf/aLQ0EfT9jbbQjInu5Fc1ww8V3UXzGc3Voqlv5rzjaI/5aTFUZmXUJYAQ
YQ6QAQY0+VBwBKlYHs9Ru704GuJt/jROiejganu/IoYd1EsJQuMGLYY/gLodx/sW
10hvSuBorC1afLwYY7A2YCo3Y/rM/9N/v0hO3BEMV5bHyhyBslUDf5BULN/jDhJP
dpwiuWtgeKFviT1FEuxjDfk2avjGEDYrnzmdmPKu9eqfqbZGyRy+EJsHAgluiZoB
10SacXeKLNjdm33MFW3xmTvWJw4aX8JlR0bV+woMM7MG1NtNBvQJr76bSWHVtGGL
wbg9o/5R/UNM43k0dfWPYyCdbZx4QQ==
=mbed
-----END PGP SIGNATURE-----

--rRJT1mSd1+ho7w0n--
