Return-Path: <stefanha@redhat.com>
Date: Mon, 21 Nov 2022 11:20:07 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <Y3ulN5DtIN4YIHy6@fedora>
References: <20221121101101.29400-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="yGYzq2s7HGeIQb5G"
Content-Disposition: inline
In-Reply-To: <20221121101101.29400-1-sgarzare@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] vhost: mask VIRTIO_F_RING_RESET for vhost
 and vhost-user devices
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>, Fam Zheng <fam@euphon.net>, Mathieu Poirier <mathieu.poirier@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Hanna Reitz <hreitz@redhat.com>, kangjie.xu@linux.alibaba.com, Jason Wang <jasowang@redhat.com>


--yGYzq2s7HGeIQb5G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 21, 2022 at 11:11:01AM +0100, Stefano Garzarella wrote:
> Commit 69e1c14aa2 ("virtio: core: vq reset feature negotation support")
> enabled VIRTIO_F_RING_RESET by default for all virtio devices.
>=20
> This feature is not currently emulated by QEMU, so for vhost and
> vhost-user devices we need to make sure it is supported by the offloaded
> device emulation (in-kernel or in another process).
> To do this we need to add VIRTIO_F_RING_RESET to the features bitmap
> passed to vhost_get_features(). This way it will be masked if the device
> does not support it.
>=20
> This issue was initially discovered with vhost-vsock and vhost-user-vsock,
> and then also tested with vhost-user-rng which confirmed the same issue.
> They fail when sending features through VHOST_SET_FEATURES ioctl or
> VHOST_USER_SET_FEATURES message, since VIRTIO_F_RING_RESET is negotiated
> by the guest (Linux >=3D v6.0), but not supported by the device.
>=20
> Fixes: 69e1c14aa2 ("virtio: core: vq reset feature negotation support")
> Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1318
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>=20
> To prevent this problem in the future, perhaps we should provide a functi=
on
> (e.g. vhost_device_get_features) where we go to mask all non-device-speci=
fic
> features (e.g VIRTIO_F_*, VIRTIO_RING_F_*) that are not emulated by QEMU =
but
> we expect them to be emulated by the vhost or vhost-user devices.
> Then we can call it in all .get_features callbacks just before return the
> features.
>=20
> What do you think?
>=20
> But maybe better to do that for the next release, I will send an RFC.

This patch looks good for 7.2.

I agree that in the long run this needs to be more robust so vhost
devices don't break every time a new feature bit is added.

>=20
> Thanks,
> Stefano
> ---
>  hw/block/vhost-user-blk.c      |  1 +
>  hw/net/vhost_net.c             |  1 +
>  hw/scsi/vhost-scsi.c           |  1 +
>  hw/scsi/vhost-user-scsi.c      |  1 +
>  hw/virtio/vhost-user-fs.c      |  1 +
>  hw/virtio/vhost-user-gpio.c    |  1 +
>  hw/virtio/vhost-user-i2c.c     |  1 +
>  hw/virtio/vhost-user-rng.c     | 11 +++++++++--
>  hw/virtio/vhost-vsock-common.c |  1 +
>  net/vhost-vdpa.c               |  1 +
>  10 files changed, 18 insertions(+), 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--yGYzq2s7HGeIQb5G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmN7pTcACgkQnKSrs4Gr
c8gy8gf9GfUs9ASyMEBiAtX7Kr79Btno4bBzs94QMnBUfdCZygUA7V5ROUz5YG6N
2yklQ1VhUHCV+e1+pmFcZ6DzMbhB1RQ9z+rtSUPG4+FCCLvDTqVG8Gf3ZcPABciE
8Neau3FnHxI1cPzPNcDqTfseLO8yhnFLAuBTfXRQkLpb5Q6jklsRb+IARNAOBqeK
wawUXiEJTYJenbRVqmukbNAWVEOh6ciwNKLR70WNdW1AvgQh9cQru2rkuXuQ6Fb6
mKSCvyiNV8Gp1bxCksN232LsGuAFY2qiFq+ckwqp+kjDoVRfp6dvZ4lEN6NfTPZx
nHDh+dnM6X886tjkTpvA830JVW1PKQ==
=2Fm+
-----END PGP SIGNATURE-----

--yGYzq2s7HGeIQb5G--
