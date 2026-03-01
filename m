Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D7E2C187
	for <virtio-fs@lists.linux.dev>; Sun,  1 Mar 2026 23:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772408061; cv=none; b=LdN8COzPrh81klBgHRS0YjjNPCGz6EAPQcFMd/vIFtuQYYngB0XmxNkUMyaltGRoEDWTESNVGo2cOpuzRKpDQuJmQIM9dSw1Gtx184OiytZCaSsOCImS6UGnu5v84gtyIRmKL1itavh/EvrGfJCk3OpFJAVykYCHX2AC7WuxTJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772408061; c=relaxed/simple;
	bh=sbD/jocntGDXU+qqeVFdxg9PXYjw13Nd1Up9nt4VS+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tmY9U0aWXuGaOem5SlXFfWORfV3uUGU80yLY1YWqmo7BLzAjoHYF+OUcphlgr5wsEdantQF0e6ajFt1SxonoRQEJzUPTKdka+//4WGBNEldUfxI7FHw8kkZ3nkrRmd1h4EWUwxJq/F5EGdHaPh/GNQmgEchUCI+/aQl61BHpIWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ixB2cXYn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ixB2cXYn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772408058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=07dDEmE1h8ak+wx3QfgX9Lfx4a884I8U+mdw8d4aP3s=;
	b=ixB2cXYnjsf7gz78S3K9EGSVOHMu0yXaQhoV2jbDLj5Vz+eipdbwXeRM7mRqaR5J2Bovjq
	F+mSNHRuNFbV5FfCTgeSr7t/MlEEeFlQyLvuM4GUUrdnNkZM2gWCGe+bU47UuJFV8QG9SD
	pMIjQ1gtq0eA2yO/B6x/z4MMXscHgNI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-CGnN9_qfMAeFxHmbtBK6pw-1; Sun,
 01 Mar 2026 18:34:17 -0500
X-MC-Unique: CGnN9_qfMAeFxHmbtBK6pw-1
X-Mimecast-MFC-AGG-ID: CGnN9_qfMAeFxHmbtBK6pw_1772408055
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5AA8319560B7;
	Sun,  1 Mar 2026 23:34:14 +0000 (UTC)
Received: from localhost (unknown [10.44.32.49])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BA16D19560A3;
	Sun,  1 Mar 2026 23:34:09 +0000 (UTC)
Date: Mon, 2 Mar 2026 07:34:06 +0800
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Cc: qemu-devel@nongnu.org, Raphael Norwitz <rnorwitz@nvidia.com>,
	virtio-fs@lists.linux.dev, Milan Zamazal <mzamazal@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, zhenwei pi <zhenwei.pi@linux.dev>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Fam Zheng <fam@euphon.net>, qemu-block@nongnu.org
Subject: Re: [PATCH 2/4] vhost-user: add skip_drain param to GET_VRING_BASE
Message-ID: <20260301233406.GA8465@fedora>
References: <20260224075055.863068-1-dtalexundeer@yandex-team.ru>
 <20260224075055.863068-3-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="c88M+712av5Zw/ul"
Content-Disposition: inline
In-Reply-To: <20260224075055.863068-3-dtalexundeer@yandex-team.ru>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12


--c88M+712av5Zw/ul
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 24, 2026 at 12:50:53PM +0500, Alexandr Moshkov wrote:
> In case of migration of QEMU from the new version (where the
> inllight-migration parameter is present), to the old one (where it is
> absent) there is no way to disable this feature on the backend during
> runtime.
>=20
> This commit slightly changes the semantics of the protocol feature
> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. Enabling this feature
> adds a new parameter for GET_VRING_BASE, which allows to control the
> drain in-flight requests on the backend.
> Thus, QEMU will be able to turn this feature on GET_VRING_BASE off and
> on anytime.
>=20
> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> ---
>  backends/cryptodev-vhost.c     |  2 +-
>  backends/vhost-user.c          |  2 +-
>  docs/interop/vhost-user.rst    |  3 ++-
>  hw/block/vhost-user-blk.c      |  2 +-
>  hw/net/vhost_net.c             |  9 +++++----
>  hw/scsi/vhost-scsi-common.c    |  2 +-
>  hw/virtio/vdpa-dev.c           |  2 +-
>  hw/virtio/vhost-user-base.c    |  2 +-
>  hw/virtio/vhost-user-fs.c      |  2 +-
>  hw/virtio/vhost-user-scmi.c    |  2 +-
>  hw/virtio/vhost-vsock-common.c |  2 +-
>  hw/virtio/vhost.c              | 24 +++++++++++++++---------
>  include/hw/virtio/vhost.h      |  7 +++++--
>  13 files changed, 36 insertions(+), 25 deletions(-)
>=20
> diff --git a/backends/cryptodev-vhost.c b/backends/cryptodev-vhost.c
> index 943680a23a..7a457380d0 100644
> --- a/backends/cryptodev-vhost.c
> +++ b/backends/cryptodev-vhost.c
> @@ -110,7 +110,7 @@ static void
>  cryptodev_vhost_stop_one(CryptoDevBackendVhost *crypto,
>                                   VirtIODevice *dev)
>  {
> -    vhost_dev_stop(&crypto->dev, dev, false);
> +    vhost_dev_stop(&crypto->dev, dev, false, false);
>      vhost_dev_disable_notifiers(&crypto->dev, dev);
>  }
> =20
> diff --git a/backends/vhost-user.c b/backends/vhost-user.c
> index 42845329e7..10be713ebd 100644
> --- a/backends/vhost-user.c
> +++ b/backends/vhost-user.c
> @@ -108,7 +108,7 @@ vhost_user_backend_stop(VhostUserBackend *b)
>          return 0;
>      }
> =20
> -    ret =3D vhost_dev_stop(&b->dev, b->vdev, true);
> +    ret =3D vhost_dev_stop(&b->dev, b->vdev, true, false);
> =20
>      if (k->set_guest_notifiers &&
>          k->set_guest_notifiers(qbus->parent, b->dev.nvqs, false) < 0) {
> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> index bfa75ff9a3..5b944322b4 100644
> --- a/docs/interop/vhost-user.rst
> +++ b/docs/interop/vhost-user.rst
> @@ -1262,7 +1262,8 @@ Front-end message types
>    specified vring before stopping it.
> =20
>    If the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT`` protocol
> -  feature has been negotiated, the back-end may suspend in-flight I/O
> +  feature has been negotiated, using request payload's *num* field,
> +  when num is set to 1, QEMU can tell the back-end to suspend in-flight =
I/O

This changes the behavior of an existing feature bit. How can the
front-end detect that the back-end supports this new behavior?

>    requests and record them as described in :ref:`Inflight I/O tracking
>    <inflight_io_tracking>` instead of completing them before stopping the=
 vring.
>    How to suspend an in-flight request depends on the implementation of t=
he back-end
> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> index c151e83677..7f2067d6cf 100644
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -225,7 +225,7 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
>                   qemu_force_shutdown_requested();
> =20
>      ret =3D force_stop ? vhost_dev_force_stop(&s->dev, vdev, true) :
> -                       vhost_dev_stop(&s->dev, vdev, true);
> +                       vhost_dev_stop(&s->dev, vdev, true, false);
> =20
>      if (k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false) < 0) {
>          error_report("vhost guest notifier cleanup failed: %d", ret);
> diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
> index a8ee18a912..604f19e03a 100644
> --- a/hw/net/vhost_net.c
> +++ b/hw/net/vhost_net.c
> @@ -384,7 +384,7 @@ fail:
>      if (net->nc->info->poll) {
>          net->nc->info->poll(net->nc, true);
>      }
> -    vhost_dev_stop(&net->dev, dev, false);
> +    vhost_dev_stop(&net->dev, dev, false, false);
>  fail_start:
>      return r;
>  }
> @@ -403,7 +403,7 @@ static void vhost_net_stop_one(struct vhost_net *net,
>      if (net->nc->info->poll) {
>          net->nc->info->poll(net->nc, true);
>      }
> -    vhost_dev_stop(&net->dev, dev, false);
> +    vhost_dev_stop(&net->dev, dev, false, false);
>      if (net->nc->info->stop) {
>          net->nc->info->stop(net->nc);
>      }
> @@ -641,7 +641,8 @@ void vhost_net_virtqueue_reset(VirtIODevice *vdev, Ne=
tClientState *nc,
>      vhost_virtqueue_stop(&net->dev,
>                           vdev,
>                           net->dev.vqs + idx,
> -                         net->dev.vq_index + idx);
> +                         net->dev.vq_index + idx,
> +                         false);
>  }
> =20
>  int vhost_net_virtqueue_restart(VirtIODevice *vdev, NetClientState *nc,
> @@ -691,7 +692,7 @@ err_start:
>          assert(ret >=3D 0);
>      }
> =20
> -    vhost_dev_stop(&net->dev, vdev, false);
> +    vhost_dev_stop(&net->dev, vdev, false, false);
> =20
>      return r;
>  }
> diff --git a/hw/scsi/vhost-scsi-common.c b/hw/scsi/vhost-scsi-common.c
> index 0bb4305de6..41c1e45aac 100644
> --- a/hw/scsi/vhost-scsi-common.c
> +++ b/hw/scsi/vhost-scsi-common.c
> @@ -108,7 +108,7 @@ int vhost_scsi_common_stop(VHostSCSICommon *vsc)
>      VirtioBusClass *k =3D VIRTIO_BUS_GET_CLASS(qbus);
>      int ret =3D 0;
> =20
> -    ret =3D vhost_dev_stop(&vsc->dev, vdev, true);
> +    ret =3D vhost_dev_stop(&vsc->dev, vdev, true, false);
> =20
>      if (k->set_guest_notifiers) {
>          int r =3D k->set_guest_notifiers(qbus->parent, vsc->dev.nvqs, fa=
lse);
> diff --git a/hw/virtio/vdpa-dev.c b/hw/virtio/vdpa-dev.c
> index 4532d63653..7279f18442 100644
> --- a/hw/virtio/vdpa-dev.c
> +++ b/hw/virtio/vdpa-dev.c
> @@ -301,7 +301,7 @@ static void vhost_vdpa_device_stop(VirtIODevice *vdev)
>          return;
>      }
> =20
> -    vhost_dev_stop(&s->dev, vdev, false);
> +    vhost_dev_stop(&s->dev, vdev, false, false);
> =20
>      ret =3D k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false);
>      if (ret < 0) {
> diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
> index 01ab9ca56b..9d3875a04b 100644
> --- a/hw/virtio/vhost-user-base.c
> +++ b/hw/virtio/vhost-user-base.c
> @@ -77,7 +77,7 @@ static int vub_stop(VirtIODevice *vdev)
>          return 0;
>      }
> =20
> -    ret =3D vhost_dev_stop(&vub->vhost_dev, vdev, true);
> +    ret =3D vhost_dev_stop(&vub->vhost_dev, vdev, true, false);
> =20
>      if (k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, false)=
 < 0) {
>          error_report("vhost guest notifier cleanup failed: %d", ret);
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index ad6fcacf06..2f6f6df67f 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -111,7 +111,7 @@ static int vuf_stop(VirtIODevice *vdev)
>          return 0;
>      }
> =20
> -    ret =3D vhost_dev_stop(&fs->vhost_dev, vdev, true);
> +    ret =3D vhost_dev_stop(&fs->vhost_dev, vdev, true, false);
> =20
>      if (k->set_guest_notifiers(qbus->parent, fs->vhost_dev.nvqs, false) =
< 0) {
>          error_report("vhost guest notifier cleanup failed: %d", ret);
> diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
> index f9264c4374..dbde342a6e 100644
> --- a/hw/virtio/vhost-user-scmi.c
> +++ b/hw/virtio/vhost-user-scmi.c
> @@ -101,7 +101,7 @@ static int vu_scmi_stop(VirtIODevice *vdev)
>          return 0;
>      }
> =20
> -    ret =3D vhost_dev_stop(vhost_dev, vdev, true);
> +    ret =3D vhost_dev_stop(vhost_dev, vdev, true, false);
> =20
>      if (k->set_guest_notifiers(qbus->parent, vhost_dev->nvqs, false) < 0=
) {
>          error_report("vhost guest notifier cleanup failed: %d", ret);
> diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-commo=
n.c
> index b33def900a..3d086ed825 100644
> --- a/hw/virtio/vhost-vsock-common.c
> +++ b/hw/virtio/vhost-vsock-common.c
> @@ -106,7 +106,7 @@ int vhost_vsock_common_stop(VirtIODevice *vdev)
>          return 0;
>      }
> =20
> -    ret =3D vhost_dev_stop(&vvc->vhost_dev, vdev, true);
> +    ret =3D vhost_dev_stop(&vvc->vhost_dev, vdev, true, false);
> =20
>      if (k->set_guest_notifiers(qbus->parent, vvc->vhost_dev.nvqs, false)=
 < 0) {
>          error_report("vhost guest notifier cleanup failed: %d", ret);
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index b4cdb7762f..c04bb53159 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -1387,11 +1387,13 @@ fail_alloc_desc:
>  static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
>                                     struct VirtIODevice *vdev,
>                                     struct vhost_virtqueue *vq,
> -                                   unsigned idx, bool force)
> +                                   unsigned idx, bool force,
> +                                   bool skip_drain)
>  {
>      int vhost_vq_index =3D dev->vhost_ops->vhost_get_vq_index(dev, idx);
>      struct vhost_vring_state state =3D {
>          .index =3D vhost_vq_index,
> +        .num =3D skip_drain,
>      };
>      int r =3D 0;
> =20
> @@ -1439,9 +1441,10 @@ static int do_vhost_virtqueue_stop(struct vhost_de=
v *dev,
>  int vhost_virtqueue_stop(struct vhost_dev *dev,
>                           struct VirtIODevice *vdev,
>                           struct vhost_virtqueue *vq,
> -                         unsigned idx)
> +                         unsigned idx,
> +                         bool skip_drain)
>  {
> -    return do_vhost_virtqueue_stop(dev, vdev, vq, idx, false);
> +    return do_vhost_virtqueue_stop(dev, vdev, vq, idx, false, skip_drain=
);
>  }
> =20
>  static int vhost_virtqueue_set_busyloop_timeout(struct vhost_dev *dev,
> @@ -2220,7 +2223,8 @@ fail_vq:
>          vhost_virtqueue_stop(hdev,
>                               vdev,
>                               hdev->vqs + i,
> -                             hdev->vq_index + i);
> +                             hdev->vq_index + i,
> +                             false);
>      }
> =20
>  fail_mem:
> @@ -2235,7 +2239,7 @@ fail_features:
> =20
>  /* Host notifiers must be enabled at this point. */
>  static int do_vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
> -                             bool vrings, bool force)
> +                             bool vrings, bool force, bool skip_drain)
>  {
>      int i;
>      int rc =3D 0;
> @@ -2262,7 +2266,8 @@ static int do_vhost_dev_stop(struct vhost_dev *hdev=
, VirtIODevice *vdev,
>                                        vdev,
>                                        hdev->vqs + i,
>                                        hdev->vq_index + i,
> -                                      force);
> +                                      force,
> +                                      skip_drain);
>      }
>      if (hdev->vhost_ops->vhost_reset_status) {
>          hdev->vhost_ops->vhost_reset_status(hdev);
> @@ -2282,15 +2287,16 @@ static int do_vhost_dev_stop(struct vhost_dev *hd=
ev, VirtIODevice *vdev,
>      return rc;
>  }
> =20
> -int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrin=
gs)
> +int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrin=
gs,
> +                   bool skip_drain)
>  {
> -    return do_vhost_dev_stop(hdev, vdev, vrings, false);
> +    return do_vhost_dev_stop(hdev, vdev, vrings, false, skip_drain);
>  }
> =20
>  int vhost_dev_force_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
>                           bool vrings)
>  {
> -    return do_vhost_dev_stop(hdev, vdev, vrings, true);
> +    return do_vhost_dev_stop(hdev, vdev, vrings, true, false);
>  }
> =20
>  int vhost_net_set_backend(struct vhost_dev *hdev,
> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> index 89817bd848..3881f6784b 100644
> --- a/include/hw/virtio/vhost.h
> +++ b/include/hw/virtio/vhost.h
> @@ -233,6 +233,7 @@ int vhost_dev_start(struct vhost_dev *hdev, VirtIODev=
ice *vdev, bool vrings);
>   * @hdev: common vhost_dev structure
>   * @vdev: the VirtIODevice structure
>   * @vrings: true to have vrings disabled in this call
> + * @skip_drain: true to notice back-end to skip draining all in-flight r=
equests
>   *
>   * Stop the vhost device. After the device is stopped the notifiers
>   * can be disabled (@vhost_dev_disable_notifiers) and the device can
> @@ -240,7 +241,8 @@ int vhost_dev_start(struct vhost_dev *hdev, VirtIODev=
ice *vdev, bool vrings);
>   *
>   * Return: 0 on success, !=3D 0 on error when stopping dev.
>   */
> -int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrin=
gs);
> +int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrin=
gs,
> +                   bool skip_drain);
> =20
>  /**
>   * vhost_dev_force_stop() - force stop the vhost device
> @@ -398,7 +400,8 @@ int vhost_device_iotlb_miss(struct vhost_dev *dev, ui=
nt64_t iova, int write);
>  int vhost_virtqueue_start(struct vhost_dev *dev, struct VirtIODevice *vd=
ev,
>                            struct vhost_virtqueue *vq, unsigned idx);
>  int vhost_virtqueue_stop(struct vhost_dev *dev, struct VirtIODevice *vde=
v,
> -                         struct vhost_virtqueue *vq, unsigned idx);
> +                         struct vhost_virtqueue *vq, unsigned idx,
> +                         bool skip_drain);
> =20
>  void vhost_dev_reset_inflight(struct vhost_inflight *inflight);
>  void vhost_dev_free_inflight(struct vhost_inflight *inflight);
> --=20
> 2.34.1
>=20

--c88M+712av5Zw/ul
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmmkzOwACgkQnKSrs4Gr
c8hz8Af+NABviNSJPS7xBLOB/q0/cGcsAEWgZiz1fsGO5iNbJgnPx6JwTYwzuSwf
32rmK7VpPnbbOj51dt6kyARDaEmsW+3GNXq4vF6h1XPMFYZTI+RLZ2pEp9pNwORv
5PtkI5okRBRvET/JdBz6FGJDDz68R4fsD6Ph6uPJRnzHSpNlGuKfW3Y4eX9RR/Le
/2TWPd6FLKUrufz51oBYHn8C972p+73mwrLTH0udLPw1HEWiT/GRg+6RumLkJg18
R0DJ/QzyadffeHIIj3QzZi7maJ8g0D82yC6EDtnhLwCD98iHzGm2dWCbLK6+uLh+
/UAavl2lZVEJTbDMB1K5o3pqrkb6zQ==
=FC/v
-----END PGP SIGNATURE-----

--c88M+712av5Zw/ul--

