Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78853B961B
	for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 19:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785266198; cv=none; b=KJqMrKkD4XiQLmLBZJSwLh+gunn7Bt7mJjINNdFv+vO1gZiX4mNAi+XGKEaGVDqpKKRE6FPk4+FmwIzsho8cWLhViLL+44FCjQiLYWZX9FE2XTj4nHydZ6A8Q1/9Ba7LHDnHPaYeYJ/kGoMcDGTu8c0VoRfhosPe4HlEvBiFzwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785266198; c=relaxed/simple;
	bh=sKijMCCEextMPGgrun8BB2YF3RbwoZddYQh2mB4ne38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TZNGOlTOxviKfl9A1a2p9XKr3+8sMa/vlZcVwoI4hcinPGR74janZXigjNozqoR1FObmKm35BqQ0vRYOqqIW+U+6Sv7VBSJoErDVQy3kcbc4CGdodyQ0qGLeqXRHggKDd0f4z+IfF7EAMGcdUu0XhNRSaujYzocK1RTxm3b3CCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VVT/8hMw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VVT/8hMw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785266193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n6uGW6wlWh8RqWWbHljukFLawSBIwPC+8fOZw5cwNuo=;
	b=VVT/8hMwgiucrGblb3YIoXslknRrUbrQwAO+AvjC3dXNPRU/5aSUkXA5OAxj/iKIzlAJnQ
	tWSXgZ6qnD97l9wRWaK8SpO5/AeI5z89l/zYVSKgz26TiNzJPsgCHFQAa3CetxuFubR6M5
	/KqvGj/P8gxBWZt6WBMLqEBRixg+tLU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-142-oKGVcqTEMIi1493Ju2pWdw-1; Tue,
 28 Jul 2026 15:16:30 -0400
X-MC-Unique: oKGVcqTEMIi1493Ju2pWdw-1
X-Mimecast-MFC-AGG-ID: oKGVcqTEMIi1493Ju2pWdw_1785266187
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6908B1956052;
	Tue, 28 Jul 2026 19:16:25 +0000 (UTC)
Received: from localhost (unknown [10.2.17.47])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4CB1D404;
	Tue, 28 Jul 2026 19:16:22 +0000 (UTC)
Date: Tue, 28 Jul 2026 15:16:20 -0400
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
Subject: Re: [PATCH RFC 12/15] hw/virtio/vhost-user: send isolation regions
 to device
Message-ID: <20260728191620.GJ371693@fedora>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-12-6b97c439eb28@gmail.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7LousNdYJU3dV+MI"
Content-Disposition: inline
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-12-6b97c439eb28@gmail.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

--7LousNdYJU3dV+MI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 03:30:11PM -0700, Connor Kite wrote:
> Adds features to fill a vhost_user_set_mem_table message with the
> addresses of isolation memory regions corresponding to bounce buffers
> and vrings.
>=20
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>  hw/virtio/vhost-user.c | 80 ++++++++++++++++++++++++++++++++++++++++++++=
+++++-
>  1 file changed, 79 insertions(+), 1 deletion(-)
>=20
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index 710cf966f8..acabfb7f1c 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -625,6 +625,21 @@ static void vhost_user_fill_msg_region(struct vhost_=
dev *dev,
>      dst->mmap_offset =3D mmap_offset;
>  }
> =20
> +static void vhost_user_fill_msg_region_iso(VhostUserMemoryRegion *dst,
> +                                           const struct vhost_user *u,
> +                                           const struct vhost_memory_reg=
ion
> +                                           *iova_reg)
> +{
> +    assert(u !=3D NULL && dst !=3D NULL && iova_reg !=3D NULL);
> +    uint64_t offset;
> +
> +    offset =3D iova_reg->userspace_addr - u->iso_memory.base_addr;
> +    dst->userspace_addr =3D iova_reg->userspace_addr;
> +    dst->memory_size =3D iova_reg->memory_size;
> +    dst->guest_phys_addr =3D iova_reg->userspace_addr;
> +    dst->mmap_offset =3D offset;
> +}
> +
>  static int vhost_user_fill_set_mem_table_msg(struct vhost_user *u,
>                                               struct vhost_dev *dev,
>                                               VhostUserMsg *msg,
> @@ -1136,7 +1151,33 @@ static void cleanup_isolation_regions(struct vhost=
_dev *dev)
>      }
>  }
> =20
> -__attribute__((unused))
> +struct iova_tree_traversal_args {

QEMU coding style:

  typedef struct {
      ...
  } IOVATreeTraversalArgs;

> +    VhostUserMsg *msg;
> +    struct vhost_user *u;
> +    int *fds;
> +    size_t *fd_num;

This field is also used to index into msg->payload.memory.regions[], so
"fd_num" is a misnomer. I suggest something like "region_idx" or just
"idx".

> +};
> +
> +static gboolean vhost_user_iova_tree_traverse_funct(gpointer key,
> +                                                    gpointer value,
> +                                                    gpointer data)
> +{
> +    struct iova_tree_traversal_args *args =3D data;
> +    struct vhost_memory_region msg_region;
> +    VhostUserMemoryRegion region_buffer;
> +    DMAMap *map =3D key;
> +    args->fds[*args->fd_num] =3D args->u->iso_memory.iso_fd;
> +
> +    msg_region.guest_phys_addr =3D map->iova;
> +    msg_region.memory_size =3D map->size + 1;
> +    msg_region.userspace_addr =3D map->iova;
> +    vhost_user_fill_msg_region_iso(&region_buffer, args->u, &msg_region);
> +    args->msg->payload.memory.regions[*args->fd_num] =3D region_buffer;

I'm confused by this code. VhostUserMemoryRegion region_buffer is the
vhost-user protocol struct that is being filled in, but there is also a
struct vhost_memory_region msg_region from the Linux kernel headers?

msg_region and vhost_user_fill_msg_region_iso() make it harder to see
what is going on. Can you open code the region_buffer struct field
assignments instead?

> +    (*args->fd_num)++;
> +
> +    return false;
> +}
> +
>  static int init_isolation_regions(struct vhost_dev *dev,
>                                    VhostUserMsg *msg,
>                                    int *fds, size_t *fd_num)
> @@ -1234,6 +1275,24 @@ static int init_isolation_regions(struct vhost_dev=
 *dev,
>                                        map->translated_addr);
>      }
> =20
> +    struct iova_tree_traversal_args args =3D {
> +        .fd_num =3D fd_num,
> +        .fds =3D fds,
> +        .msg =3D msg,
> +        .u =3D u
> +    };
> +
> +    vhost_iova_tree_foreach(u->iso_iova_tree,
> +                            vhost_user_iova_tree_traverse_funct, &args);
> +
> +    msg->payload.memory.nregions =3D *fd_num;
> +
> +    assert(*fd_num !=3D 0);
> +
> +    msg->hdr.size =3D sizeof(msg->payload.memory.nregions);
> +    msg->hdr.size +=3D sizeof(msg->payload.memory.padding);
> +    msg->hdr.size +=3D *fd_num * sizeof(VhostUserMemoryRegion);
> +
>      return 0;
>  }
> =20
> @@ -1241,6 +1300,7 @@ static int vhost_user_set_mem_table(struct vhost_de=
v *dev,
>                                      struct vhost_memory *mem)
>  {
>      struct vhost_user *u =3D dev->opaque;
> +    bool memory_isolation =3D u->user->memory_isolation;
>      int fds[VHOST_MEMORY_BASELINE_NREGIONS];
>      size_t fd_num =3D 0;
>      bool do_postcopy =3D u->postcopy_listen && u->postcopy_fd.handler;
> @@ -1268,6 +1328,24 @@ static int vhost_user_set_mem_table(struct vhost_d=
ev *dev,
>          msg.hdr.flags |=3D VHOST_USER_NEED_REPLY_MASK;
>      }
> =20
> +    if (memory_isolation) {
> +        ret =3D init_isolation_regions(dev, &msg, fds, &fd_num);
> +        if (ret < 0) {
> +            return ret;
> +        }
> +
> +        ret =3D vhost_user_write(dev, &msg, fds, fd_num);
> +        if (ret < 0) {
> +            return ret;
> +        }
> +
> +        if (reply_supported) {
> +            return process_message_reply(dev, &msg);
> +        }
> +
> +        return 0;
> +    }
> +
>      if (config_mem_slots) {
>          ret =3D vhost_user_add_remove_regions(dev, &msg, reply_supported=
, false);
>          if (ret < 0) {
>=20
> --=20
> 2.43.0
>=20

--7LousNdYJU3dV+MI
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmppAAQACgkQnKSrs4Gr
c8iXlAf/TVBhkZrgVsUI+z+qyzvmD3DJfqr3zuyFtJyyZzkwc4laZEugQGhEUtdS
BAqMG+biQ4Qyb0eII/yzy+ieWUtOj2uDoZx+nvmKRE6iJmwqhn7jZdKHjLbUsNIG
WFWV4Ym/AmMXs1wgnz2n+/L8BQ6qag0KhEc24GTHnuC81+wH7sU1LE5kSSh33x5v
QFJRrPh+4tZpntjGbv/hs3AOOeOiALR8uR4VIPaL6Jz/MeB0iSloE/96bcOrRZDK
JloH1f0QrFhiVM8auiKG56AvGo5hE+JVvYRZaUSspiyna9AaKhptGQ9UPsB07Hc+
P1qOsQtYqgto7jMemu20LWYXo1VAyw==
=vR+H
-----END PGP SIGNATURE-----

--7LousNdYJU3dV+MI--

