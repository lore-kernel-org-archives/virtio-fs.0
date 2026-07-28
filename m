Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE42217BED0
	for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 15:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785251208; cv=none; b=c9PAVDzVn4iM7AAT0Qtn8iVuCQNf0/iBAb7fBOc3vuKvATnB9UDkMMdj89uBcqispgbu0v9CKtY3e9N5nhpQLkZdkKnnrqVpQipDWqg9MoIu1io/G3ch8hS9TNQ1yPSrvyyFIdUwfq1/TRyUunNOJqSXU5h17hUwZZt4DDUUb/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785251208; c=relaxed/simple;
	bh=q+U65BvYJ9TIbTQThIlR6EqQI5XMsXnts5GWIEaNEM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rWGLU2CA3CPSmfPWm6di7Wz1VuRpbN3AUf5bZswjrrqu8Ok2rClN7SDYhTPIpkCVhwOtK4SeGE3as6nfMVBJ+GMJoryrDty+9TUL8Z+nH9Mqj8oCtYYPh5Ih+TcEaryHa35bod6y42iefd5TBp2J1i7H51ZmaPw2fzUU5iyM5kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YrkMBkzT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YrkMBkzT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785251205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gGCW8S6/PwqcOTJQB5tkv7+LFwSBeoEStZwBaaCZweo=;
	b=YrkMBkzT5g+ThS94Pw7IQclN78fyJ7oLhL6ds7OY2BVkUas+aFDoJFnTjLfwkCfmwJD0De
	BGTOQng/icEz0jmTpjBC8MEU9Z8DmnxLjOs7MLy+mCZ7rg3evif7U7c78wer7eIPU/hKuA
	N4ZWiquBfpiFEpsqJ0qMTieIke6Kqtw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-6-S56wrrqEOp298gCaXqdk6w-1; Tue,
 28 Jul 2026 11:06:41 -0400
X-MC-Unique: S56wrrqEOp298gCaXqdk6w-1
X-Mimecast-MFC-AGG-ID: S56wrrqEOp298gCaXqdk6w_1785251198
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D70D01956095;
	Tue, 28 Jul 2026 15:06:37 +0000 (UTC)
Received: from localhost (unknown [10.2.16.73])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4D4391956045;
	Tue, 28 Jul 2026 15:06:35 +0000 (UTC)
Date: Tue, 28 Jul 2026 11:06:31 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Connor Kite <connorkite@gmail.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Haixu Cui <quic_haixcui@quicinc.com>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Milan Zamazal <mzamazal@redhat.com>,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	qemu-block@nongnu.org, virtio-fs@lists.linux.dev,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Jason Wang <jasowangio@gmail.com>, Peter Xu <peterx@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Alyssa Ross <hi@alyssa.is>,
	Demi Marie Obenour <demiobenour@gmail.com>
Subject: Re: [PATCH RFC 08/15] hw/virtio/vhost-shadow-virtqueue: used handler
Message-ID: <20260728150631.GF371693@fedora>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-8-6b97c439eb28@gmail.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bnqYc8PExKM7h3vZ"
Content-Disposition: inline
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-8-6b97c439eb28@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

--bnqYc8PExKM7h3vZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 03:30:07PM -0700, Connor Kite wrote:
> Adds a handler callback to shadow virtqueues in order to enable
> non-default processing of used vring elements from the device.
>=20
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>  hw/virtio/vhost-shadow-virtqueue.c |  4 ++++
>  hw/virtio/vhost-shadow-virtqueue.h | 14 ++++++++++++++
>  2 files changed, 18 insertions(+)
>=20
> diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-=
virtqueue.c
> index bcb7f2ffc7..eb86c1ee37 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.c
> +++ b/hw/virtio/vhost-shadow-virtqueue.c
> @@ -669,6 +669,10 @@ static void vhost_svq_flush(VhostShadowVirtqueue *sv=
q,
>                  break;
>              }
> =20
> +            if (svq->ops && svq->ops->used_handler) {
> +                svq->ops->used_handler(svq, elem, svq->ops_opaque);
> +            }
> +
>              if (unlikely(i >=3D svq->vring.num)) {
>                  qemu_log_mask(LOG_GUEST_ERROR,
>                           "More than %u used buffers obtained in a %u siz=
e SVQ",
> diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-=
virtqueue.h
> index ec16a1e838..ccfeee36d7 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.h
> +++ b/hw/virtio/vhost-shadow-virtqueue.h
> @@ -56,8 +56,22 @@ typedef int (*VirtQueueAvailCallback)(VhostShadowVirtq=
ueue *svq,
>                                        VirtQueueElement *elem,
>                                        void *vq_callback_opaque);
> =20
> +/**
> + * Callback to handle a used buffer
> + *
> + * @svq: Shadow virtqueue
> + * @elem: Element placed in the queue by the device
> + * @vq_callback_opaque: Used to pass arguments to callback
> + *
> + * Returns 0 if the vq is running as expected

The doc comment should mention what non-0 look like. Are errors reported
as a negative errno?

> + */
> +typedef int (*VirtQueueUsedCallback)(VhostShadowVirtqueue *svq,
> +                                      VirtQueueElement *elem,
> +                                      void *vq_callback_opaque);
> +
>  typedef struct VhostShadowVirtqueueOps {
>      VirtQueueAvailCallback avail_handler;
> +    VirtQueueUsedCallback used_handler;
>  } VhostShadowVirtqueueOps;
> =20
>  /* Shadow virtqueue to relay notifications */
>=20
> --=20
> 2.43.0
>=20

--bnqYc8PExKM7h3vZ
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmpoxXcACgkQnKSrs4Gr
c8gEPAgAnM6gyWjjb6vq24pJXR1H067s9W6tNHemw0rnqT+tOhL0zrKs5bwsa7QJ
C5GmytVPByQVkR5AAvGVNioKhkx366NbjkUFCb9T+lJUACWTWZHha/4fH+HuLaI/
+paYr3L5wQ2DWD5sTeHw9kUa5koz+zZEX3dBFh8rRGT8NuxsizK43ObYziMx4tlQ
maxC4ffSsCnQ1JtVlkfbD4OhgJFilrpwXoHCmWaR/MynF/QCVcN2rIQPmB9BEUZC
siRj6oL3FVHYBqy2yFWusYLvaUb0ksEjxZWr4hA4ZpJrzXlxF1JFPf9KChzI43B3
2s/BlDWvdUL7ZLNJfdHVgOqS3OiwTw==
=7ZzM
-----END PGP SIGNATURE-----

--bnqYc8PExKM7h3vZ--

