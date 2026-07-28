Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E443FBEAF
	for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 20:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785272271; cv=none; b=Ifm8iKpOaNeOmppP81vyhzp5800VeAEwoD2T72wgTEIsbMYXpFtAigGHqHUA8q8XheScUnCAq/leQK8qAOyitrmjrvKWRyC9sx2ZM/yWrijAHHhtO6Qy7urMOI/YvCIyBUsbTtatPiBOd9iM5CToTegslroC5NTzsjDVbt22sEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785272271; c=relaxed/simple;
	bh=35iT2RC1xXYhJMR5wX5ESKnrQ2OhFNu+fMn/1baS4jQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OWNXzzo9AFsHr6JuUl6nIalltM8MwH5T7jW8FG3Ad25FcK7Kic3I/dZvXrAzRDraMRUZzNlbX1rHWHUfeYsCZ2/cVEMdI0JhutZFPUnMBpp/fpoe0ot8SvrFYestwZuQTgEuU/lL9hJcNHjC6ekSEEl8X1wMgHU9BWNqfkVo1p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bpZdx+se; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bpZdx+se"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785272265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2gQVzdpbxWqZEcXE7NBAxZ1Oi0L9W0NRspalkpY0XQ8=;
	b=bpZdx+seGaDjE5eNdchO2uAi6q0rhQfC19EChnSIVV/UpvhVVqNFnmhRFKJtKeoUdD/l1V
	yxhMq0vC/+g2/cDOWztGQDrQ4Ns++r9+bxXttTEnXw69kFeD38M7UI2T1h2c0UL3ppVYOp
	X+D8fI99sKnHeV0Nh6ezMOkMB9A2LpA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-15-95PmEynJNFq84Bw3LkEj0w-1; Tue,
 28 Jul 2026 16:57:39 -0400
X-MC-Unique: 95PmEynJNFq84Bw3LkEj0w-1
X-Mimecast-MFC-AGG-ID: 95PmEynJNFq84Bw3LkEj0w_1785272257
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 201D019560A6;
	Tue, 28 Jul 2026 20:57:35 +0000 (UTC)
Received: from localhost (unknown [10.2.17.47])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1C0E618004AD;
	Tue, 28 Jul 2026 20:57:31 +0000 (UTC)
Date: Tue, 28 Jul 2026 16:57:28 -0400
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
Subject: Re: [PATCH RFC 14/15] hw/virtio/vhost-user: handle data movement
 with shadow vqs
Message-ID: <20260728205728.GL371693@fedora>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-14-6b97c439eb28@gmail.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jGEHF4PY3Zu7S4sk"
Content-Disposition: inline
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-14-6b97c439eb28@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

--jGEHF4PY3Zu7S4sk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 03:30:13PM -0700, Connor Kite wrote:
> - Add start logic for shadow virtqueues, which sets vring addresses.
> - Update logic for sending vring addresses to backend to point
>   to the shadow vrings when isolation mode is active.
> - Implement handlers for intercepted avail and used descriptors. These
>   handlers copy buffer contents between bounce buffers in the isolation
>   region and the buffers made available by the guest
> - Implement logic to stop svqs
>=20
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>  hw/virtio/vhost-user.c | 167 +++++++++++++++++++++++++++++++++++++++++++=
+++++-
>  1 file changed, 166 insertions(+), 1 deletion(-)
>=20
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index 75858289a2..e65f877f9a 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -1299,6 +1299,97 @@ static int init_isolation_regions(struct vhost_dev=
 *dev,
>      return 0;
>  }
> =20
> +static int vhost_user_memory_lookup(struct vhost_dev *dev, hwaddr gpa,
> +                                    hwaddr *hva)
> +{
> +    int i;
> +    hwaddr offset;
> +
> +    for (i =3D 0; i < dev->mem->nregions; i++) {
> +        struct vhost_memory_region *reg =3D dev->mem->regions + i;
> +
> +        if (gpa >=3D reg->guest_phys_addr &&
> +            reg->guest_phys_addr + reg->memory_size > gpa) {
> +            offset =3D gpa - reg->guest_phys_addr;
> +            *hva =3D reg->userspace_addr + offset;
> +            return 0;
> +        }
> +    }
> +
> +    return -EFAULT;
> +}
> +
> +static int vhost_user_svq_handle_used(VhostShadowVirtqueue *svq,
> +                                      VirtQueueElement *elem,
> +                                      void *opaque)
> +{
> +    hwaddr hva;
> +    int r;
> +    struct vhost_dev *dev =3D opaque;
> +
> +    for (int i =3D 0; i < elem->in_num; i++) {
> +        r =3D vhost_user_memory_lookup(dev, elem->in_addr[i], &hva);
> +        if (r < 0) {
> +            return r;
> +        }
> +
> +        memcpy((void *) hva, elem->in_sg[i].iov_base, elem->in_sg[i].iov=
_len);
> +        elem->in_sg[i].iov_base =3D (void *) hva;
> +    }
> +
> +    for (int i =3D 0; i < elem->out_num; i++) {
> +        r =3D vhost_user_memory_lookup(dev, elem->out_addr[i], &hva);
> +        if (r < 0) {
> +            return r;
> +        }
> +
> +        memcpy((void *) hva, elem->out_sg[i].iov_base, elem->out_sg[i].i=
ov_len);
> +        elem->out_sg[i].iov_base =3D (void *) hva;
> +    }
> +
> +    return 0;
> +}
> +
> +static int vhost_user_svq_handle_avail(VhostShadowVirtqueue *svq,
> +                                       VirtQueueElement *elem,
> +                                       void *opaque)
> +{
> +    hwaddr offset;
> +    const DMAMap *map;
> +    DMAMap needle;
> +    hwaddr *iova_base;
> +
> +    for (int i =3D 0; i < elem->out_num; i++) {
> +        needle.translated_addr =3D elem->out_addr[i];
> +        needle.size =3D elem->out_sg[i].iov_len - 1;
> +        map =3D vhost_iova_tree_find_gpa(svq->iova_tree, &needle);

Mapping failure must be handled.

> +        offset =3D needle.translated_addr - map->translated_addr;
> +        iova_base =3D (void *)(map->iova + offset);
> +
> +        elem->out_sg[i].iov_base =3D iova_base;
> +        memcpy(iova_base, elem->out_sg[i].iov_base, needle.size + 1);

iova_base is an iova, not QEMU memory (HVA). Memcpy cannot be used with
IOVAs. The address of the mapped shared memory is needed as the
destination instead.

> +    }
> +
> +    for (int i =3D 0; i < elem->in_num; i++) {
> +        needle.translated_addr =3D elem->in_addr[i];
> +        needle.size =3D elem->in_sg[i].iov_len - 1;
> +        map =3D vhost_iova_tree_find_gpa(svq->iova_tree, &needle);

Mapping failure must be handled.

> +        offset =3D needle.translated_addr - map->translated_addr;
> +        iova_base =3D (void *)(map->iova + offset);
> +
> +        elem->in_sg[i].iov_base =3D iova_base;
> +        memcpy(iova_base, elem->in_sg[i].iov_base, needle.size + 1);

No memcpy is necessary before vhost_svq_add() since this is data that
will be read from the device upon I/O completion.

> +    }

elem->out_sg[] and elem->in_sg[] are modified in this function. Have we
lost the original I/O buffer memory address from the guest virtqueue?
This is a problem because they will be needed when completing the
request.

> +
> +    vhost_svq_add(svq, elem->out_sg, elem->out_num, elem->out_addr,
> +                  elem->in_sg, elem->in_num, elem->in_addr, elem);
> +
> +    return 0;
> +}
> +
> +
> +
> +
>  static int vhost_user_set_mem_table(struct vhost_dev *dev,
>                                      struct vhost_memory *mem)
>  {
> @@ -1772,6 +1863,8 @@ static int vhost_user_set_vring_err(struct vhost_de=
v *dev,
>  static int vhost_user_set_vring_addr(struct vhost_dev *dev,
>                                       struct vhost_vring_addr *addr)
>  {
> +    struct vhost_user *u =3D dev->opaque;
> +
>      VhostUserMsg msg =3D {
>          .hdr.request =3D VHOST_USER_SET_VRING_ADDR,
>          .hdr.flags =3D VHOST_USER_VERSION,
> @@ -1779,6 +1872,25 @@ static int vhost_user_set_vring_addr(struct vhost_=
dev *dev,
>          .hdr.size =3D sizeof(msg.payload.addr),
>      };
> =20
> +    if (u->user->memory_isolation) {
> +        if (!u->svqs_allocated) {
> +            return 0;
> +        }

Is the idea that this returns silently when called before
vhost_user_dev_start()? State make code harder to understand. It would
be cleaner to set up the vring addresses without relying on
svqs_allocated. What is the reason for deferring the vring address
setup to vhost_user_dev_start()?

> +
> +        int svq_idx =3D addr->index - dev->vq_index;
> +        VhostShadowVirtqueue *svq =3D g_ptr_array_index(u->shadow_vqs,
> +                                                      svq_idx);
> +
> +        struct vhost_vring_addr svq_addr =3D {
> +            .avail_user_addr =3D (uint64_t)(uintptr_t)svq->vring.avail,
> +            .desc_user_addr =3D (uint64_t)(uintptr_t)svq->vring.desc,
> +            .used_user_addr =3D (uint64_t)(uintptr_t)svq->vring.used,
> +            .index =3D addr->index,
> +        };
> +
> +        msg.payload.addr =3D svq_addr;
> +    }
> +
>      /*
>       * wait for a reply if logging is enabled to make sure
>       * backend is actually logging changes
> @@ -2754,13 +2866,18 @@ static int vhost_user_postcopy_notifier(NotifierW=
ithReturn *notifier,
>      return 0;
>  }
> =20
> +static const VhostShadowVirtqueueOps vhost_user_svq_ops =3D {
> +    .avail_handler =3D vhost_user_svq_handle_avail,
> +    .used_handler =3D vhost_user_svq_handle_used
> +};
> +
>  static void vhost_user_init_svq(struct vhost_dev *dev, struct vhost_user=
 *u)
>  {
>      /*Modified from vhost-vdpa*/
>      u->shadow_vqs =3D g_ptr_array_new_full(dev->nvqs, vhost_svq_free);
>      for (int i =3D 0; i < dev->nvqs; i++) {
>          VhostShadowVirtqueue *svq;
> -        svq =3D vhost_svq_new(NULL, NULL);
> +        svq =3D vhost_svq_new(&vhost_user_svq_ops, dev);
>          g_ptr_array_add(u->shadow_vqs, svq);
>      }
>  }
> @@ -3466,8 +3583,56 @@ void vhost_user_async_close(DeviceState *d,
>      }
>  }
> =20
> +static bool vhost_user_svqs_start(struct vhost_dev *dev)
> +{
> +    struct vhost_user *u =3D dev->opaque;
> +    uint64_t vring_base =3D u->iso_memory.vring_base_addr;
> +    u->svqs_allocated =3D true;

Where is this field cleared to false on reset?

> +
> +    for (int i =3D 0; i < u->shadow_vqs->len; i++) {
> +        VirtQueue *vq =3D virtio_get_queue(dev->vdev, dev->vq_index + i);
> +        VhostShadowVirtqueue *svq =3D g_ptr_array_index(u->shadow_vqs, i=
);
> +        svq->base_addr =3D (hwaddr *) vring_base;

Does this support multiple virtqueues, it looks like they will all use
the same base_addr?

> +        vhost_svq_start(svq, dev->vdev, vq, u->iso_iova_tree);
> +
> +        struct vhost_vring_addr addr =3D {
> +            .index =3D dev->vq_index + i,
> +            .desc_user_addr =3D vring_base,
> +            .avail_user_addr =3D vring_base + sizeof(vring_desc_t) *
> +                svq->vring.num,
> +            .used_user_addr =3D vring_base + vhost_svq_driver_area_size(=
svq)
> +        };
> +
> +        vhost_user_set_vring_addr(dev, &addr);

Also mentioned above in vhost_user_set_vring_addr():

Sending a vhost-user message here is strange since that should already
be done by vhost.c:vhost_virtqueue_start() ->
vhost_user_set_vring_addr().

> +
> +        vring_base +=3D vhost_svq_device_area_size(svq) +
> +                      vhost_svq_driver_area_size(svq);
> +    }
> +
> +    return false;
> +}
> +
> +static void vhost_user_svqs_stop(struct vhost_dev *dev)
> +{
> +    struct vhost_user *u =3D dev->opaque;
> +
> +    for (int i =3D 0; i < u->shadow_vqs->len; i++) {
> +        vhost_svq_stop(g_ptr_array_index(u->shadow_vqs, i));
> +    }
> +}
> +
> +
>  static int vhost_user_dev_start(struct vhost_dev *dev, bool started)
>  {
> +    struct vhost_user *u =3D dev->opaque;
> +    if (u->user->memory_isolation) {
> +        if (started) {
> +            vhost_user_svqs_start(dev);
> +        } else {
> +            vhost_user_svqs_stop(dev);
> +        }
> +    }
> +
>      if (!vhost_user_has_protocol_feature(dev, VHOST_USER_PROTOCOL_F_STAT=
US)) {
>          return 0;
>      }
>=20
> --=20
> 2.43.0
>=20

--jGEHF4PY3Zu7S4sk
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmppF7gACgkQnKSrs4Gr
c8iMXQf/flRUGehIw2aZaL3YqKW3Ey6JqYz3KCvxDySSHiWXLHLTS4zwL/hYasxN
oa8/Mj6z97q/u4m+/jNgbi0kH70Or/BvDFlTyKN2rLDZaSSB/4KnXmXky5G1dWaw
T0smQfvc3gWP9XP8H0PM+GQ5VyqroFz0tSXDkhmgHmkcsskn/8mvFjDU5Pq2cNTc
VUMqMBKUjLHMWsIBoYoAC14JX3WRXC3hKHtUubBrZeMiz4zrPjQnVup14wIVZkmu
E2/1xZflft+qFSLPl5kXHvHv2bANBgnmN0uOQBhLFZvn+utheat9BlFZuU35EKfC
r6m/0t6HEpMn6a6J8oLLs0LOtuIk/g==
=gpUw
-----END PGP SIGNATURE-----

--jGEHF4PY3Zu7S4sk--

