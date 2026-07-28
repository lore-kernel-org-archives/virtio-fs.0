Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4EA2DECB2
	for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 15:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785252207; cv=none; b=CxjVSOtdHWVP/oIX1PV6Q2Jo5XzjBNdchVslaCT1YOVn/FTk5Be79iO1Bv4vvrPW3yKIcFP2yFsZ5xZaikyuswo8wvsyR7UFt8WRWUho+oRqi1TrtAFFl+wcY4tkJbLvcNPoaObpzVITXgKe2wj0tV0QO6PT++lzO/PUw06rrQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785252207; c=relaxed/simple;
	bh=oCHK2PqbVSW7OrHbcjL6A0t2l24DQfH2IyB4jPoxPNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cbR7470UCG/AGEHhZvuPgqByGd8B9xKcITpDdXnjp7gKKClNZO1Js39uh9EKeZSPcaNr+9JXZU2hCKgaIU0faeq3hy1PJGFPKYCe3UPmIO9NLDnRu6/SGosIyiZ8i9EbrsO22g/kRTOgbJH0O4X++Kf13XP738jN2f23OjyogRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aizlnjVX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aizlnjVX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785252204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yGLmE0Uup5xWQ2G+SyVEbIDUzauE43uCgyclhivM0xc=;
	b=aizlnjVXAm9h3STdP2wQllq0/bFdnuOI0pseQavg2Mf5wxTePfsLjIG59dRnqSF8Nwmbe6
	sImmBChyWcw0judn84nshBflW9SD6X3ycoQQ330uLdm6DK4X9vNZqTWB0RVGWWircJVE4I
	aqzoE5RlVa/38FHx2esUlBJ+NCmEYpU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-qGo7YqOsNRW6cQPfrLF7kQ-1; Tue,
 28 Jul 2026 11:23:18 -0400
X-MC-Unique: qGo7YqOsNRW6cQPfrLF7kQ-1
X-Mimecast-MFC-AGG-ID: qGo7YqOsNRW6cQPfrLF7kQ_1785252194
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6582E1956058;
	Tue, 28 Jul 2026 15:23:12 +0000 (UTC)
Received: from localhost (unknown [10.2.16.73])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4D3D818004AD;
	Tue, 28 Jul 2026 15:23:09 +0000 (UTC)
Date: Tue, 28 Jul 2026 11:23:08 -0400
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
Subject: Re: [PATCH RFC 09/15] hw/virtio/vhost-shadow-virtqueue: specified
 vring placement
Message-ID: <20260728152308.GG371693@fedora>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-9-6b97c439eb28@gmail.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Dl4fy5/Nk4W7j/qR"
Content-Disposition: inline
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-9-6b97c439eb28@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

--Dl4fy5/Nk4W7j/qR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 03:30:08PM -0700, Connor Kite wrote:
> By default svq vrings are placed in an anonymous memory map. As svqs
> will be leveraged to enable memory isolation in vhost-user, it is useful
> to be able to place the vrings in a shared isolation memory region.
>=20
> Adds the option to specify vring placement by providing a vring base
> address before starting the svq.
>=20
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>  hw/virtio/vhost-shadow-virtqueue.c | 22 +++++++++++++++-------
>  hw/virtio/vhost-shadow-virtqueue.h |  3 +++
>  2 files changed, 18 insertions(+), 7 deletions(-)
>=20
> diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-=
virtqueue.c
> index eb86c1ee37..9e3c359f50 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.c
> +++ b/hw/virtio/vhost-shadow-virtqueue.c
> @@ -857,14 +857,21 @@ void vhost_svq_start(VhostShadowVirtqueue *svq, Vir=
tIODevice *vdev,
> =20
>      svq->vring.num =3D virtio_queue_get_num(vdev, virtio_get_queue_index=
(vq));
>      svq->num_free =3D svq->vring.num;
> -    svq->vring.desc =3D mmap(NULL, vhost_svq_driver_area_size(svq),
> -                           PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANON=
YMOUS,
> -                           -1, 0);
>      desc_size =3D sizeof(vring_desc_t) * svq->vring.num;
> -    svq->vring.avail =3D (void *)((char *)svq->vring.desc + desc_size);
> -    svq->vring.used =3D mmap(NULL, vhost_svq_device_area_size(svq),
> -                           PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANON=
YMOUS,
> -                           -1, 0);
> +    if (svq->base_addr =3D=3D NULL) {
> +        svq->vring.desc =3D mmap(NULL, vhost_svq_driver_area_size(svq),
> +                            PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANO=
NYMOUS,
> +                            -1, 0);
> +        svq->vring.avail =3D (void *)((char *)svq->vring.desc + desc_siz=
e);
> +        svq->vring.used =3D mmap(NULL, vhost_svq_device_area_size(svq),
> +                            PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANO=
NYMOUS,
> +                            -1, 0);
> +    } else {
> +        svq->vring.desc =3D (void *) svq->base_addr;
> +        svq->vring.avail =3D (void *)((char *)svq->vring.desc + desc_siz=
e);
> +        svq->vring.used =3D (void *)((char *)svq->base_addr +
> +                          vhost_svq_driver_area_size(svq));
> +    }
>      svq->desc_state =3D g_new0(SVQDescState, svq->vring.num);
>      if (virtio_vdev_has_feature(svq->vdev, VIRTIO_F_IN_ORDER)) {
>          svq->batch_last.id =3D VIRTIO_RING_NOT_IN_BATCH;
> @@ -929,6 +936,7 @@ VhostShadowVirtqueue *vhost_svq_new(const VhostShadow=
VirtqueueOps *ops,
>      event_notifier_init_fd(&svq->svq_kick, VHOST_FILE_UNBIND);
>      svq->ops =3D ops;
>      svq->ops_opaque =3D ops_opaque;
> +    svq->base_addr =3D NULL;
>      return svq;
>  }
> =20
> diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-=
virtqueue.h
> index ccfeee36d7..39f69e6455 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.h
> +++ b/hw/virtio/vhost-shadow-virtqueue.h
> @@ -148,6 +148,9 @@ typedef struct VhostShadowVirtqueue {
> =20
>      /* Size of SVQ vring free descriptors */
>      uint16_t num_free;
> +
> +    /* Location assigned to vrings if not in default anon memory map*/
> +    hwaddr *base_addr;

Why is base_addr a hwaddr? This is QEMU memory, not guest RAM. I
expected this to be void *.

A size needs to be at least documented here to reduce the chance of
memory bugs. Even better would be an interface like
vhost_svq_vring_total_size() so the caller can fetch the number of bytes
before allocating the memory.

--Dl4fy5/Nk4W7j/qR
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmpoyVwACgkQnKSrs4Gr
c8jUuwgAvMc/G3tOhj0RTFEXylyhHMcyDAfcvVg+19MNnwq8RSuEjpwK7ongL+Do
s3rzWOVKWxQS8RMFhq0E1zXoLWZ0+nt3Ziqi2XBOj28SEiO3eZyfXMQ6lC1UYo1i
ZiN0+qHov/H69XAb8cKJgt4xKyiLhVEZfC/DKBzNzVOiFHApRfzdPQapfqTXA4PJ
5z0v+rRysNK9dCaLDf6hqlXki1xWm3M877IeDEztVtof0FolUwLgy4DM9r8lwEdi
efKoa9g6Jb083QGMMCKEzXR5wkxvrIVsbIc/OonhN8XDNjJNPpiaZeLlDj0WddGb
BECKOD1lZ+YB9/soytLlda2bjV2M8g==
=jc6J
-----END PGP SIGNATURE-----

--Dl4fy5/Nk4W7j/qR--

