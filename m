Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=zQGdXolueJl4+I05fxSRjOKl8hbjw5D0DFTEuJ20ecc=;
 b=dSs4A0z8dw5RwwHYF99GRQfXl84+Jo0mcHfyDXmDeKciGlzrLc848+DfRoiHPI7Ens
 aKup7cQhzIctfcQukQqoT310/ttj2yhn8CGqtLln95LrNy5RfYd2nYiDi7fLXOKwWImr
 kHxJnf5/LW9n+TlURjNBUeymK2hCToIGUV5+V6tY/+QFRoRNAgRAurGurcRF6xwNx0n4
 Md+3n6CGci8hjqSs1VF8H2Pq5bYxxqBJQiXOXAxPDZmtAmWxfGCoEuCc+x+4kfPF6MRc
 ffqnT6nxfOiRzTDBAKtHPOSdJxTGVyY8WkP952jigJ9R+feWahtKggsZpcigBBshnoyr
 2L/Q==
References: <20221123131630.52020-1-sgarzare@redhat.com>
 <Y3+5rfnNmR7R/h6/@fedora>
 <20221125081243.a3q7ep32o6g4r2vd@sgarzare-redhat>
 <Y4fFICp5tBrEPud1@fedora>
 <20221201080250.s3cugnnkf5f4kqvo@sgarzare-redhat>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Thu, 01 Dec 2022 10:14:39 +0000
In-reply-to: <20221201080250.s3cugnnkf5f4kqvo@sgarzare-redhat>
Message-ID: <87k03bctrj.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH for-7.2] vhost: enable vrings in
 vhost_dev_start() for vhost-user devices
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, "Dr. David
 Alan Gilbert" <dgilbert@redhat.com>, Kevin Wolf <kwolf@redhat.com>, virtio-fs@redhat.com, Mathieu Poirier <mathieu.poirier@linaro.org>, Fam Zheng <fam@euphon.net>, Viresh Kumar <viresh.kumar@linaro.org>, German Maglione <gmaglione@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Hanna Reitz <hreitz@redhat.com>, qemu-block@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>


Stefano Garzarella <sgarzare@redhat.com> writes:

> On Wed, Nov 30, 2022 at 04:03:28PM -0500, Stefan Hajnoczi wrote:
>>On Fri, Nov 25, 2022 at 09:12:43AM +0100, Stefano Garzarella wrote:
>>> On Thu, Nov 24, 2022 at 01:36:29PM -0500, Stefan Hajnoczi wrote:
>>> > On Wed, Nov 23, 2022 at 02:16:30PM +0100, Stefano Garzarella wrote:
>>> > > Commit 02b61f38d3 ("hw/virtio: incorporate backend features in feat=
ures")
>>> > > properly negotiates VHOST_USER_F_PROTOCOL_FEATURES with the vhost-u=
ser
>>> > > backend, but we forgot to enable vrings as specified in
>>> > > docs/interop/vhost-user.rst:
>>> > >
>>> > >     If ``VHOST_USER_F_PROTOCOL_FEATURES`` has not been negotiated, =
the
>>> > >     ring starts directly in the enabled state.
>>> > >
>>> > >     If ``VHOST_USER_F_PROTOCOL_FEATURES`` has been negotiated, the =
ring is
>>> > >     initialized in a disabled state and is enabled by
>>> > >     ``VHOST_USER_SET_VRING_ENABLE`` with parameter 1.
>>> > >
>>> > > Some vhost-user front-ends already did this by calling
>>> > > vhost_ops.vhost_set_vring_enable() directly:
>>> > > - backends/cryptodev-vhost.c
>>> > > - hw/net/virtio-net.c
>>> > > - hw/virtio/vhost-user-gpio.c
>>> > >
>>> > > But most didn't do that, so we would leave the vrings disabled and =
some
>>> > > backends would not work. We observed this issue with the rust versi=
on of
>>> > > virtiofsd [1], which uses the event loop [2] provided by the
>>> > > vhost-user-backend crate where requests are not processed if vring =
is
>>> > > not enabled.
>>> > >
>>> > > Let's fix this issue by enabling the vrings in vhost_dev_start() fo=
r
>>> > > vhost-user front-ends that don't already do this directly. Same thi=
ng
>>> > > also in vhost_dev_stop() where we disable vrings.
>>> > >
>>> > > [1] https://gitlab.com/virtio-fs/virtiofsd
>>> > > [2]
> https://github.com/rust-vmm/vhost/blob/240fc2966/crates/vhost-user-backen=
d/src/event_loop.rs#L217
>>> > >
>>> > > Fixes: 02b61f38d3 ("hw/virtio: incorporate backend features in feat=
ures")
>>> > > Reported-by: German Maglione <gmaglione@redhat.com>
>>> > > Tested-by: German Maglione <gmaglione@redhat.com>
>>> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>> > > ---
>>> > >  include/hw/virtio/vhost.h      |  6 +++--
>>> > >  backends/cryptodev-vhost.c     |  4 ++--
>>> > >  backends/vhost-user.c          |  4 ++--
>>> > >  hw/block/vhost-user-blk.c      |  4 ++--
>>> > >  hw/net/vhost_net.c             |  8 +++----
>>> > >  hw/scsi/vhost-scsi-common.c    |  4 ++--
>>> > >  hw/virtio/vhost-user-fs.c      |  4 ++--
>>> > >  hw/virtio/vhost-user-gpio.c    |  4 ++--
>>> > >  hw/virtio/vhost-user-i2c.c     |  4 ++--
>>> > >  hw/virtio/vhost-user-rng.c     |  4 ++--
>>> > >  hw/virtio/vhost-vsock-common.c |  4 ++--
>>> > >  hw/virtio/vhost.c              | 44 ++++++++++++++++++++++++++++++=
----
>>> > >  hw/virtio/trace-events         |  4 ++--
>>> > >  13 files changed, 67 insertions(+), 31 deletions(-)
>>> > >
>>> > > diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
>>> > > index 353252ac3e..67a6807fac 100644
>>> > > --- a/include/hw/virtio/vhost.h
>>> > > +++ b/include/hw/virtio/vhost.h
>>> > > @@ -184,24 +184,26 @@ static inline bool vhost_dev_is_started(struc=
t vhost_dev *hdev)
>>> > >   * vhost_dev_start() - start the vhost device
>>> > >   * @hdev: common vhost_dev structure
>>> > >   * @vdev: the VirtIODevice structure
>>> > > + * @vrings: true to have vrings enabled in this call
>>> > >   *
>>> > >   * Starts the vhost device. From this point VirtIO feature negotia=
tion
>>> > >   * can start and the device can start processing VirtIO transactio=
ns.
>>> > >   *
>>> > >   * Return: 0 on success, < 0 on error.
>>> > >   */
>>> > > -int vhost_dev_start(struct vhost_dev *hdev, VirtIODevice *vdev);
>>> > > +int vhost_dev_start(struct vhost_dev *hdev, VirtIODevice *vdev, bo=
ol vrings);
>>> > >
>>> > >  /**
>>> > >   * vhost_dev_stop() - stop the vhost device
>>> > >   * @hdev: common vhost_dev structure
>>> > >   * @vdev: the VirtIODevice structure
>>> > > + * @vrings: true to have vrings disabled in this call
>>> > >   *
>>> > >   * Stop the vhost device. After the device is stopped the notifier=
s
>>> > >   * can be disabled (@vhost_dev_disable_notifiers) and the device c=
an
>>> > >   * be torn down (@vhost_dev_cleanup).
>>> > >   */
>>> > > -void vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev);
>>> > > +void vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bo=
ol vrings);
>>> > >
>>> > >  /**
>>> > >   * DOC: vhost device configuration handling
>>> > > diff --git a/backends/cryptodev-vhost.c b/backends/cryptodev-vhost.=
c
>>> > > index bc13e466b4..572f87b3be 100644
>>> > > --- a/backends/cryptodev-vhost.c
>>> > > +++ b/backends/cryptodev-vhost.c
>>> > > @@ -94,7 +94,7 @@ cryptodev_vhost_start_one(CryptoDevBackendVhost *=
crypto,
>>> > >          goto fail_notifiers;
>>> > >      }
>>> > >
>>> > > -    r =3D vhost_dev_start(&crypto->dev, dev);
>>> > > +    r =3D vhost_dev_start(&crypto->dev, dev, false);
>>> > >      if (r < 0) {
>>> > >          goto fail_start;
>>> > >      }
>>> > > @@ -111,7 +111,7 @@ static void
>>> > >  cryptodev_vhost_stop_one(CryptoDevBackendVhost *crypto,
>>> > >                                   VirtIODevice *dev)
>>> > >  {
>>> > > -    vhost_dev_stop(&crypto->dev, dev);
>>> > > +    vhost_dev_stop(&crypto->dev, dev, false);
>>> > >      vhost_dev_disable_notifiers(&crypto->dev, dev);
>>> > >  }
>>> > >
>>> > > diff --git a/backends/vhost-user.c b/backends/vhost-user.c
>>> > > index 5dedb2d987..7bfcaef976 100644
>>> > > --- a/backends/vhost-user.c
>>> > > +++ b/backends/vhost-user.c
>>> > > @@ -85,7 +85,7 @@ vhost_user_backend_start(VhostUserBackend *b)
>>> > >      }
>>> > >
>>> > >      b->dev.acked_features =3D b->vdev->guest_features;
>>> > > -    ret =3D vhost_dev_start(&b->dev, b->vdev);
>>> > > +    ret =3D vhost_dev_start(&b->dev, b->vdev, true);
>>> > >      if (ret < 0) {
>>> > >          error_report("Error start vhost dev");
>>> > >          goto err_guest_notifiers;
>>> > > @@ -120,7 +120,7 @@ vhost_user_backend_stop(VhostUserBackend *b)
>>> > >          return;
>>> > >      }
>>> > >
>>> > > -    vhost_dev_stop(&b->dev, b->vdev);
>>> > > +    vhost_dev_stop(&b->dev, b->vdev, true);
>>> > >
>>> > >      if (k->set_guest_notifiers) {
>>> > >          ret =3D k->set_guest_notifiers(qbus->parent,
>>> > > diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
>>> > > index 0d5190accf..1177064631 100644
>>> > > --- a/hw/block/vhost-user-blk.c
>>> > > +++ b/hw/block/vhost-user-blk.c
>>> > > @@ -178,7 +178,7 @@ static int vhost_user_blk_start(VirtIODevice *v=
dev, Error **errp)
>>> > >      }
>>> > >
>>> > >      s->dev.vq_index_end =3D s->dev.nvqs;
>>> > > -    ret =3D vhost_dev_start(&s->dev, vdev);
>>> > > +    ret =3D vhost_dev_start(&s->dev, vdev, true);
>>> > >      if (ret < 0) {
>>> > >          error_setg_errno(errp, -ret, "Error starting vhost");
>>> > >          goto err_guest_notifiers;
>>> > > @@ -213,7 +213,7 @@ static void vhost_user_blk_stop(VirtIODevice *v=
dev)
>>> > >          return;
>>> > >      }
>>> > >
>>> > > -    vhost_dev_stop(&s->dev, vdev);
>>> > > +    vhost_dev_stop(&s->dev, vdev, true);
>>> > >
>>> > >      ret =3D k->set_guest_notifiers(qbus->parent, s->dev.nvqs, fals=
e);
>>> > >      if (ret < 0) {
>>> > > diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
>>> > > index 26e4930676..043058ff43 100644
>>> > > --- a/hw/net/vhost_net.c
>>> > > +++ b/hw/net/vhost_net.c
>>> > > @@ -259,7 +259,7 @@ static int vhost_net_start_one(struct vhost_net=
 *net,
>>> > >          goto fail_notifiers;
>>> > >      }
>>> > >
>>> > > -    r =3D vhost_dev_start(&net->dev, dev);
>>> > > +    r =3D vhost_dev_start(&net->dev, dev, false);
>>> > >      if (r < 0) {
>>> > >          goto fail_start;
>>> > >      }
>>> > > @@ -308,7 +308,7 @@ fail:
>>> > >      if (net->nc->info->poll) {
>>> > >          net->nc->info->poll(net->nc, true);
>>> > >      }
>>> > > -    vhost_dev_stop(&net->dev, dev);
>>> > > +    vhost_dev_stop(&net->dev, dev, false);
>>> > >  fail_start:
>>> > >      vhost_dev_disable_notifiers(&net->dev, dev);
>>> > >  fail_notifiers:
>>> > > @@ -329,7 +329,7 @@ static void vhost_net_stop_one(struct vhost_net=
 *net,
>>> > >      if (net->nc->info->poll) {
>>> > >          net->nc->info->poll(net->nc, true);
>>> > >      }
>>> > > -    vhost_dev_stop(&net->dev, dev);
>>> > > +    vhost_dev_stop(&net->dev, dev, false);
>>> > >      if (net->nc->info->stop) {
>>> > >          net->nc->info->stop(net->nc);
>>> > >      }
>>> > > @@ -606,7 +606,7 @@ err_start:
>>> > >          assert(r >=3D 0);
>>> > >      }
>>> > >
>>> > > -    vhost_dev_stop(&net->dev, vdev);
>>> > > +    vhost_dev_stop(&net->dev, vdev, false);
>>> > >
>>> > >      return r;
>>> > >  }
>>> > > diff --git a/hw/scsi/vhost-scsi-common.c b/hw/scsi/vhost-scsi-commo=
n.c
>>> > > index 767f827e55..18ea5dcfa1 100644
>>> > > --- a/hw/scsi/vhost-scsi-common.c
>>> > > +++ b/hw/scsi/vhost-scsi-common.c
>>> > > @@ -68,7 +68,7 @@ int vhost_scsi_common_start(VHostSCSICommon *vsc)
>>> > >          goto err_guest_notifiers;
>>> > >      }
>>> > >
>>> > > -    ret =3D vhost_dev_start(&vsc->dev, vdev);
>>> > > +    ret =3D vhost_dev_start(&vsc->dev, vdev, true);
>>> > >      if (ret < 0) {
>>> > >          error_report("Error start vhost dev");
>>> > >          goto err_guest_notifiers;
>>> > > @@ -101,7 +101,7 @@ void vhost_scsi_common_stop(VHostSCSICommon *vs=
c)
>>> > >      VirtioBusClass *k =3D VIRTIO_BUS_GET_CLASS(qbus);
>>> > >      int ret =3D 0;
>>> > >
>>> > > -    vhost_dev_stop(&vsc->dev, vdev);
>>> > > +    vhost_dev_stop(&vsc->dev, vdev, true);
>>> > >
>>> > >      if (k->set_guest_notifiers) {
>>> > >          ret =3D k->set_guest_notifiers(qbus->parent, vsc->dev.nvqs=
, false);
>>> > > diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
>>> > > index dc4014cdef..d97b179e6f 100644
>>> > > --- a/hw/virtio/vhost-user-fs.c
>>> > > +++ b/hw/virtio/vhost-user-fs.c
>>> > > @@ -76,7 +76,7 @@ static void vuf_start(VirtIODevice *vdev)
>>> > >      }
>>> > >
>>> > >      fs->vhost_dev.acked_features =3D vdev->guest_features;
>>> > > -    ret =3D vhost_dev_start(&fs->vhost_dev, vdev);
>>> > > +    ret =3D vhost_dev_start(&fs->vhost_dev, vdev, true);
>>> > >      if (ret < 0) {
>>> > >          error_report("Error starting vhost: %d", -ret);
>>> > >          goto err_guest_notifiers;
>>> > > @@ -110,7 +110,7 @@ static void vuf_stop(VirtIODevice *vdev)
>>> > >          return;
>>> > >      }
>>> > >
>>> > > -    vhost_dev_stop(&fs->vhost_dev, vdev);
>>> > > +    vhost_dev_stop(&fs->vhost_dev, vdev, true);
>>> > >
>>> > >      ret =3D k->set_guest_notifiers(qbus->parent, fs->vhost_dev.nvq=
s, false);
>>> > >      if (ret < 0) {
>>> > > diff --git a/hw/virtio/vhost-user-gpio.c b/hw/virtio/vhost-user-gpi=
o.c
>>> > > index 5851cb3bc9..0b40ebd15a 100644
>>> > > --- a/hw/virtio/vhost-user-gpio.c
>>> > > +++ b/hw/virtio/vhost-user-gpio.c
>>> > > @@ -81,7 +81,7 @@ static int vu_gpio_start(VirtIODevice *vdev)
>>> > >       */
>>> > >      vhost_ack_features(&gpio->vhost_dev, feature_bits, vdev->guest=
_features);
>>> > >
>>> > > -    ret =3D vhost_dev_start(&gpio->vhost_dev, vdev);
>>> > > +    ret =3D vhost_dev_start(&gpio->vhost_dev, vdev, false);
>>> > >      if (ret < 0) {
>>> > >          error_report("Error starting vhost-user-gpio: %d", ret);
>>> > >          goto err_guest_notifiers;
>>> > > @@ -139,7 +139,7 @@ static void vu_gpio_stop(VirtIODevice *vdev)
>>> > >          return;
>>> > >      }
>>> > >
>>> > > -    vhost_dev_stop(vhost_dev, vdev);
>>> > > +    vhost_dev_stop(vhost_dev, vdev, false);
>>> > >
>>> > >      ret =3D k->set_guest_notifiers(qbus->parent, vhost_dev->nvqs, =
false);
>>> > >      if (ret < 0) {
>>> > > diff --git a/hw/virtio/vhost-user-i2c.c b/hw/virtio/vhost-user-i2c.=
c
>>> > > index 1c9f3d20dc..dc5c828ba6 100644
>>> > > --- a/hw/virtio/vhost-user-i2c.c
>>> > > +++ b/hw/virtio/vhost-user-i2c.c
>>> > > @@ -46,7 +46,7 @@ static void vu_i2c_start(VirtIODevice *vdev)
>>> > >
>>> > >      i2c->vhost_dev.acked_features =3D vdev->guest_features;
>>> > >
>>> > > -    ret =3D vhost_dev_start(&i2c->vhost_dev, vdev);
>>> > > +    ret =3D vhost_dev_start(&i2c->vhost_dev, vdev, true);
>>> > >      if (ret < 0) {
>>> > >          error_report("Error starting vhost-user-i2c: %d", -ret);
>>> > >          goto err_guest_notifiers;
>>> > > @@ -80,7 +80,7 @@ static void vu_i2c_stop(VirtIODevice *vdev)
>>> > >          return;
>>> > >      }
>>> > >
>>> > > -    vhost_dev_stop(&i2c->vhost_dev, vdev);
>>> > > +    vhost_dev_stop(&i2c->vhost_dev, vdev, true);
>>> > >
>>> > >      ret =3D k->set_guest_notifiers(qbus->parent, i2c->vhost_dev.nv=
qs, false);
>>> > >      if (ret < 0) {
>>> > > diff --git a/hw/virtio/vhost-user-rng.c b/hw/virtio/vhost-user-rng.=
c
>>> > > index f9084cde58..201a39e220 100644
>>> > > --- a/hw/virtio/vhost-user-rng.c
>>> > > +++ b/hw/virtio/vhost-user-rng.c
>>> > > @@ -47,7 +47,7 @@ static void vu_rng_start(VirtIODevice *vdev)
>>> > >      }
>>> > >
>>> > >      rng->vhost_dev.acked_features =3D vdev->guest_features;
>>> > > -    ret =3D vhost_dev_start(&rng->vhost_dev, vdev);
>>> > > +    ret =3D vhost_dev_start(&rng->vhost_dev, vdev, true);
>>> > >      if (ret < 0) {
>>> > >          error_report("Error starting vhost-user-rng: %d", -ret);
>>> > >          goto err_guest_notifiers;
>>> > > @@ -81,7 +81,7 @@ static void vu_rng_stop(VirtIODevice *vdev)
>>> > >          return;
>>> > >      }
>>> > >
>>> > > -    vhost_dev_stop(&rng->vhost_dev, vdev);
>>> > > +    vhost_dev_stop(&rng->vhost_dev, vdev, true);
>>> > >
>>> > >      ret =3D k->set_guest_notifiers(qbus->parent, rng->vhost_dev.nv=
qs, false);
>>> > >      if (ret < 0) {
>>> > > diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock=
-common.c
>>> > > index a67a275de2..d21c72b401 100644
>>> > > --- a/hw/virtio/vhost-vsock-common.c
>>> > > +++ b/hw/virtio/vhost-vsock-common.c
>>> > > @@ -70,7 +70,7 @@ int vhost_vsock_common_start(VirtIODevice *vdev)
>>> > >      }
>>> > >
>>> > >      vvc->vhost_dev.acked_features =3D vdev->guest_features;
>>> > > -    ret =3D vhost_dev_start(&vvc->vhost_dev, vdev);
>>> > > +    ret =3D vhost_dev_start(&vvc->vhost_dev, vdev, true);
>>> > >      if (ret < 0) {
>>> > >          error_report("Error starting vhost: %d", -ret);
>>> > >          goto err_guest_notifiers;
>>> > > @@ -105,7 +105,7 @@ void vhost_vsock_common_stop(VirtIODevice *vdev=
)
>>> > >          return;
>>> > >      }
>>> > >
>>> > > -    vhost_dev_stop(&vvc->vhost_dev, vdev);
>>> > > +    vhost_dev_stop(&vvc->vhost_dev, vdev, true);
>>> > >
>>> > >      ret =3D k->set_guest_notifiers(qbus->parent, vvc->vhost_dev.nv=
qs, false);
>>> > >      if (ret < 0) {
>>> > > diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
>>> > > index d1c4c20b8c..7fb008bc9e 100644
>>> > > --- a/hw/virtio/vhost.c
>>> > > +++ b/hw/virtio/vhost.c
>>> > > @@ -1777,15 +1777,36 @@ int vhost_dev_get_inflight(struct vhost_dev=
 *dev, uint16_t queue_size,
>>> > >      return 0;
>>> > >  }
>>> > >
>>> > > +static int vhost_dev_set_vring_enable(struct vhost_dev *hdev, int =
enable)
>>> >
>>> > There is a similarly-named vhost_set_vring_enable(NetClientState *nc,
>>> > int enable) function which is actually part of vhost_net. Please rena=
me
>>> > it to vhost_net_set_vring_enable().
>>>
>>> Should I rename it in this patch?
>>>
>>> > It should probably call
>>> > vhost_dev_set_vring_enable().
>>>
>>> Ehm, the idea of this patch was to touch as little as possible to avoid=
 new
>>> regressions.
>>>
>>> Also, the semantics of vhost_dev_set_vring_enable() was meant to keep
>>> vhost_dev_start()/vhost_dev_stop() simple, not to be exposed to fronten=
ds.
>>> (maybe I should have written it, sorry about that).
>>>
>>> However I agree that we should clean up vhost-net and also the other
>>> frontends as Raphael also suggested, but honestly I'm scared to do that=
 now
>>> in this patch...
>>>
>>> What I would have wanted to do, would be similar to what we do for
>>> vhost-vdpa: call SET_VRING_ENABLE in the vhost_ops->vhost_dev_start()
>>> callback of vhost-user.c.
>>> Removing all the call to vhost_ops->vhost_set_vring_enable() in the
>>> frontends, but I think it's too risky to do that now.
>>>
>>> >
>>> > > +{
>>> > > +    if (!hdev->vhost_ops->vhost_set_vring_enable) {
>>> > > +        return 0;
>>> > > +    }
>>> > > +
>>> > > +    /*
>>> > > +     * For vhost-user devices, if VHOST_USER_F_PROTOCOL_FEATURES h=
as not
>>> > > +     * been negotiated, the rings start directly in the enabled st=
ate, and
>>> > > +     * .vhost_set_vring_enable callback will fail since
>>> > > +     * VHOST_USER_SET_VRING_ENABLE is not supported.
>>> > > +     */
>>> > > +    if (hdev->vhost_ops->backend_type =3D=3D VHOST_BACKEND_TYPE_US=
ER &&
>>> > > +        !virtio_has_feature(hdev->backend_features,
>>> > > +                            VHOST_USER_F_PROTOCOL_FEATURES)) {
>>> > > +        return 0;
>>> > > +    }
>>> >
>>> > These semantics are the opposite of vhost_user_set_vring_enable():
>>> >
>>> >  if (!virtio_has_feature(dev->features, VHOST_USER_F_PROTOCOL_FEATURE=
S)) {
>>> >      return -EINVAL;
>>> >  }
>>> >
>>> > Please make vhost_user_set_vring_enable() and
>>> > vhost_dev_set_vring_enable() consistent. Code gets really confusing w=
hen
>>> > layers have different semantics for the same operation.
>>>
>>> It's the opposite precisely because we shouldn't let
>>> vhost_dev_start()/vhost_dev_stop() fail if
>>> vhost_ops->vhost_set_vring_enable() can't be called because it would fa=
il.
>>>
>>> If I do it this way, then I have to put the check inside
>>> vhost_dev_start()/vhost_dev_stop(), and at this point I remove the func=
tion
>>> that would be useless (just a wrapper of
>>> hdev->vhost_ops->vhost_set_vring_enable).
>>> Actually this was the first implementation I did, then I added the func=
tion
>>> just to have vhost_dev_start()/vhost_dev_stop() cleaner and to avoid
>>> duplicating the check.
>>>
>>> >
>>> > > +
>>> > > +    return hdev->vhost_ops->vhost_set_vring_enable(hdev, enable);
>>> > > +}
>>> >
>>> > The return value is hard to understand. An error return is only retur=
ned
>>> > by vhost-user devices with VHOST_USER_F_PROTOCOL_FEATURES. There are
>>> > other cases that seem like they should return an error but return
>>> > success instead. For example, when called with enable=3Dfalse on a
>>> > non-VHOST_USER_F_PROTOCOL_FEATURES device (e.g. vhost-kernel or legac=
y
>>> > vhost-user) we return success even though the vring wasn't disabled.
>>>
>>> As I explained above, the idea was not to expose this function outside,=
 but
>>> to use it only in vhost_dev_start()/vhost_dev_stop(). So the return val=
ue is
>>> 0 both when it has successes and when there is no need/way to enable/di=
sable
>>> the vrings.
>>>
>>> Perhaps since it is confusing, I will remove the function and put the c=
ode
>>> directly into vhost_dev_start()/vhost_dev_stop().
>>>
>>> What do you think?
>>
>>It's late now. We can merge it as-is.
>>
>>I think this patch makes the vhost code even harder to understand and
>>it's important to do the clean ups that have been discussed for 8.0.
>
> Agree.
>
>>Will you work on the changes we discussed for 8.0?
>
> Yep, sure.
> I will try to unify all vhost/vhost-user devices.
> Now I think it's also a mess because the devices do different things,
> we should have everything in the core.

Do you think rust-vmm's vhost crates have enough of the state
management to manage vhost and vhost-user backends? Maybe it would be a
good experiment in replacing a (small well defined) piece of
functionality with rust?

That said there is a lot of deep magic in the vhost-net stuff which I
think is down to the interaction with things like vdpk and other network
optimisations that might be missing. For the rest of the devices most of
the code is basically boiler plate which has grown variations due to
code motion and change. This is the sort of thing that generics solves
well.

>
> Thanks,
> Stefano


--=20
Alex Benn=C3=A9e

