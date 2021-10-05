Date: Tue, 5 Oct 2021 09:14:14 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YVwJVlRFUaw+W+lo@stefanha-x1.localdomain>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-9-vgoyal@redhat.com>
	<YVsQDkoNPyvC/Uoo@stefanha-x1.localdomain>
	<YVtrk6/sWwoUfXs+@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GNMiKuBvTSe6DbNh"
Content-Disposition: inline
In-Reply-To: <YVtrk6/sWwoUfXs+@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 08/13] virtiofsd: Create a notification queue
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


--GNMiKuBvTSe6DbNh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 04, 2021 at 05:01:07PM -0400, Vivek Goyal wrote:
> On Mon, Oct 04, 2021 at 03:30:38PM +0100, Stefan Hajnoczi wrote:
> > On Thu, Sep 30, 2021 at 11:30:32AM -0400, Vivek Goyal wrote:
> > > Add a notification queue which will be used to send async notificatio=
ns
> > > for file lock availability.
> > >=20
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
> > > ---
> > >  hw/virtio/vhost-user-fs-pci.c     |  4 +-
> > >  hw/virtio/vhost-user-fs.c         | 62 +++++++++++++++++++++++++--
> > >  include/hw/virtio/vhost-user-fs.h |  2 +
> > >  tools/virtiofsd/fuse_i.h          |  1 +
> > >  tools/virtiofsd/fuse_virtio.c     | 70 +++++++++++++++++++++++------=
--
> > >  5 files changed, 116 insertions(+), 23 deletions(-)
> > >=20
> > > diff --git a/hw/virtio/vhost-user-fs-pci.c b/hw/virtio/vhost-user-fs-=
pci.c
> > > index 2ed8492b3f..cdb9471088 100644
> > > --- a/hw/virtio/vhost-user-fs-pci.c
> > > +++ b/hw/virtio/vhost-user-fs-pci.c
> > > @@ -41,8 +41,8 @@ static void vhost_user_fs_pci_realize(VirtIOPCIProx=
y *vpci_dev, Error **errp)
> > >      DeviceState *vdev =3D DEVICE(&dev->vdev);
> > > =20
> > >      if (vpci_dev->nvectors =3D=3D DEV_NVECTORS_UNSPECIFIED) {
> > > -        /* Also reserve config change and hiprio queue vectors */
> > > -        vpci_dev->nvectors =3D dev->vdev.conf.num_request_queues + 2;
> > > +        /* Also reserve config change, hiprio and notification queue=
 vectors */
> > > +        vpci_dev->nvectors =3D dev->vdev.conf.num_request_queues + 3;
> > >      }
> > > =20
> > >      qdev_realize(vdev, BUS(&vpci_dev->bus), errp);
> > > diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> > > index d1efbc5b18..6bafcf0243 100644
> > > --- a/hw/virtio/vhost-user-fs.c
> > > +++ b/hw/virtio/vhost-user-fs.c
> > > @@ -31,6 +31,7 @@ static const int user_feature_bits[] =3D {
> > >      VIRTIO_F_NOTIFY_ON_EMPTY,
> > >      VIRTIO_F_RING_PACKED,
> > >      VIRTIO_F_IOMMU_PLATFORM,
> > > +    VIRTIO_FS_F_NOTIFICATION,
> > > =20
> > >      VHOST_INVALID_FEATURE_BIT
> > >  };
> > > @@ -147,7 +148,7 @@ static void vuf_handle_output(VirtIODevice *vdev,=
 VirtQueue *vq)
> > >       */
> > >  }
> > > =20
> > > -static void vuf_create_vqs(VirtIODevice *vdev)
> > > +static void vuf_create_vqs(VirtIODevice *vdev, bool notification_vq)
> > >  {
> > >      VHostUserFS *fs =3D VHOST_USER_FS(vdev);
> > >      unsigned int i;
> > > @@ -155,6 +156,15 @@ static void vuf_create_vqs(VirtIODevice *vdev)
> > >      /* Hiprio queue */
> > >      fs->hiprio_vq =3D virtio_add_queue(vdev, fs->conf.queue_size,
> > >                                       vuf_handle_output);
> > > +    /*
> > > +     * Notification queue. Feature negotiation happens later. So at =
this
> > > +     * point of time we don't know if driver will use notification q=
ueue
> > > +     * or not.
> > > +     */
> > > +    if (notification_vq) {
> > > +        fs->notification_vq =3D virtio_add_queue(vdev, fs->conf.queu=
e_size,
> > > +                                               vuf_handle_output);
> > > +    }
> > > =20
> > >      /* Request queues */
> > >      fs->req_vqs =3D g_new(VirtQueue *, fs->conf.num_request_queues);
> > > @@ -163,8 +173,12 @@ static void vuf_create_vqs(VirtIODevice *vdev)
> > >                                            vuf_handle_output);
> > >      }
> > > =20
> > > -    /* 1 high prio queue, plus the number configured */
> > > -    fs->vhost_dev.nvqs =3D 1 + fs->conf.num_request_queues;
> > > +    /* 1 high prio queue, 1 notification queue plus the number confi=
gured */
> > > +    if (notification_vq) {
> > > +        fs->vhost_dev.nvqs =3D 2 + fs->conf.num_request_queues;
> > > +    } else {
> > > +        fs->vhost_dev.nvqs =3D 1 + fs->conf.num_request_queues;
> > > +    }
> > >      fs->vhost_dev.vqs =3D g_new0(struct vhost_virtqueue, fs->vhost_d=
ev.nvqs);
> > >  }
> > > =20
> > > @@ -176,6 +190,11 @@ static void vuf_cleanup_vqs(VirtIODevice *vdev)
> > >      virtio_delete_queue(fs->hiprio_vq);
> > >      fs->hiprio_vq =3D NULL;
> > > =20
> > > +    if (fs->notification_vq) {
> > > +        virtio_delete_queue(fs->notification_vq);
> > > +    }
> > > +    fs->notification_vq =3D NULL;
> > > +
> > >      for (i =3D 0; i < fs->conf.num_request_queues; i++) {
> > >          virtio_delete_queue(fs->req_vqs[i]);
> > >      }
> > > @@ -194,9 +213,43 @@ static uint64_t vuf_get_features(VirtIODevice *v=
dev,
> > >  {
> > >      VHostUserFS *fs =3D VHOST_USER_FS(vdev);
> > > =20
> > > +    virtio_add_feature(&features, VIRTIO_FS_F_NOTIFICATION);
> > > +
> > >      return vhost_get_features(&fs->vhost_dev, user_feature_bits, fea=
tures);
> > >  }
> > > =20
> > > +static void vuf_set_features(VirtIODevice *vdev, uint64_t features)
> > > +{
> > > +    VHostUserFS *fs =3D VHOST_USER_FS(vdev);
> > > +
> > > +    if (virtio_has_feature(features, VIRTIO_FS_F_NOTIFICATION)) {
> > > +        fs->notify_enabled =3D true;
> > > +        /*
> > > +         * If guest first booted with no notification queue support =
and
> > > +         * later rebooted with kernel which supports notification, we
> > > +         * can end up here
> > > +         */
> > > +        if (!fs->notification_vq) {
> > > +            vuf_cleanup_vqs(vdev);
> > > +            vuf_create_vqs(vdev, true);
> > > +        }
> >=20
> > I would simplify things by unconditionally creating the notification vq
> > for the device and letting the vhost-user device backend decide whether
> > it wants to handle the vq or not.
> > If the backend doesn't implement the
> > vq then it also won't advertise VIRTIO_FS_F_NOTIFICATION so the guest
> > driver won't submit virtqueue buffers.
>=20
> I think I am did not understand the idea. This code deals with that
> both qemu and vhost-user device can deal with notification queue. But
> driver can't deal with it.=20
>=20
> So if we first booted into a guest kernel which does not support
> notification queue, then we will not have instantiated notification
> queue. But later we reboot guest into a newer kernel and now it
> has capability to deal with notification queues, so we create it
> now.
>=20
> IIUC, you are suggesting that somehow keep notification queue
> instantiated even if guest driver does not support notifications, so
> that we will not have to get into the exercise of cleaning up queues
> and re-instantiating these?

Yes.

> But I think we can't keep notification queue around if driver does
> not support it. Because it changes queue index. queue index 1 will
> belong to request queue if notifications are not enabled otherwise
> it will belong to notification queue. So If I always instantiate
> notification queue, then guest and qemu/virtiofsd will have
> different understanding of which queue index belongs to what
> queue.

The meaning of the virtqueue doesn't matter. That only matters to
virtiofsd when processing virtqueues. Since QEMU's -device
vhost-user-fs doesn't process virtqueues there's no difference between
hipri, request, and notification virtqueues.

I'm not 100% sure that the vhost-user code is set up to work smoothly in
this fashion, but I think it should be possible to make this work and
the end result will be simpler.

Stefan

--GNMiKuBvTSe6DbNh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFcCVYACgkQnKSrs4Gr
c8gUhQgAhDSDoXmBt36ckc/L1xioUJPhdWpIRjhR9GQ0aaI3NMTI6CauS+5MmYwg
+PEoDIScGxtZOqYk1HKMAKYo/HmxSF3EH4lnkdi4SFgOQoejmDibywTo1djT6cm/
OsChgjfSblqsLN6j+QRCNi1/fLPoWRR7qYBXelnHIDrs9/ruLEYPWvg8jDulSjie
muLvuhFCpxBZrrTmDCy1xBa2JO2tGBSSbyDz4kOuLzb0lTM3UtDtojoiwJdT0ols
yltahA/qpdR3KPBOEMxQwO0WA6u8YyqLR0gc+WvqqfB3UaARGwJvvDNm+K0NiA/E
9CzvIBhNJ7E+lpql3sMdSA6YTxJ9eQ==
=SxKk
-----END PGP SIGNATURE-----

--GNMiKuBvTSe6DbNh--

