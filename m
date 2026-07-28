Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6586B3845B7
	for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 19:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785267721; cv=none; b=SiO9JL5K6NIHaLKA7My/VjHX7MxvuKMsG90JDKiOVomYLvjcRvut2jK1zPwedUfzAh+1EXrng/nRTsIXDqiR1SoD4nUXQ5hAlfBb7qkyvNsxhEzdyWa46/QVozldatuVbPWSSw4FcW0YS7gY1YTMDkwgPLPW/JIelgNORR+G3LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785267721; c=relaxed/simple;
	bh=oGgxPJxvuLc8Wrrer9LNOH3+bQx3oyvEurPzs5Gzf/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eycFSNwiy4D69+/Fpwio0NHb91T+LPqyg+NHOKMbjBKkTJtUKfLVH905CDirga34yltWQ8lCnxKVPQ3hyPKPtY+FaL7LtUtt6e2zrwP1IjuJIUg1NXRV8zKI2vV1JbXgG9Uzq/EcbCfrVJalS7umdRMHXzALhsekuIO2CCM4CZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OGYwNZCV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OGYwNZCV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785267719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x+AkxoWsB7uc2detbeE8+509PBr3u/TvOz/2hh/L2Kw=;
	b=OGYwNZCV3nHy6uAyeeAnTQy9crfhg1i9aexc51a+eiuDtMG1wkqytq0Ju8/o8bbXjhq90t
	/tz1A51V+raxIurcQK1SeqQZW4ZYl5uK1M1AmB30judyjQuE6lDp7TveZM88U/e/pYz27+
	XNkz7/XtdTbecIYKyi32CMnvxmAkHPA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-427-sF0ED4HdOLyGoftEuRehEA-1; Tue,
 28 Jul 2026 15:41:55 -0400
X-MC-Unique: sF0ED4HdOLyGoftEuRehEA-1
X-Mimecast-MFC-AGG-ID: sF0ED4HdOLyGoftEuRehEA_1785267712
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BDC3519560B2;
	Tue, 28 Jul 2026 19:41:50 +0000 (UTC)
Received: from localhost (unknown [10.2.17.47])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EF12F1956089;
	Tue, 28 Jul 2026 19:41:47 +0000 (UTC)
Date: Tue, 28 Jul 2026 15:41:46 -0400
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
Subject: Re: [PATCH RFC 13/15] hw/virtio/vhost-user: add shadow virtqueues
 and eventfd intercepts
Message-ID: <20260728194145.GK371693@fedora>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-13-6b97c439eb28@gmail.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="B6GEy+uFbHjCCumJ"
Content-Disposition: inline
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-13-6b97c439eb28@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

--B6GEy+uFbHjCCumJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 03:30:12PM -0700, Connor Kite wrote:
> Adds shadow virtqueues that will eventually be used to transfer data
> between device and host via bounce buffers when isolation mode is
> active.  The svqs are initalized, and eventfd assignments are
> intercepted so that notifications come to svqs first before
> the guest or backend receive them.
>=20
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>  hw/virtio/vhost-user.c | 54 ++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 54 insertions(+)
>=20
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index acabfb7f1c..75858289a2 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -18,6 +18,7 @@
>  #include "hw/virtio/vhost-backend.h"
>  #include "hw/virtio/virtio.h"
>  #include "hw/virtio/virtio-net.h"
> +#include "hw/virtio/vhost-shadow-virtqueue.h"
>  #include "hw/virtio/vhost-iova-tree.h"
>  #include "chardev/char-fe.h"
>  #include "io/channel-socket.h"
> @@ -365,7 +366,9 @@ struct vhost_user {
> =20
>      /* Isolated memory data*/
>      struct IsolationRegion iso_memory;
> +    GPtrArray *shadow_vqs;
>      VhostIOVATree *iso_iova_tree;
> +    bool svqs_allocated;
>  };
> =20
>  struct scrub_regions {
> @@ -1693,6 +1696,24 @@ static int vhost_set_vring_file(struct vhost_dev *=
dev,
>  static int vhost_user_set_vring_kick(struct vhost_dev *dev,
>                                       struct vhost_vring_file *file)
>  {
> +    struct vhost_user *u =3D dev->opaque;
> +    int svq_idx =3D file->index - dev->vq_index;
> +    if (u->user->memory_isolation) {
> +        VhostShadowVirtqueue *svq =3D g_ptr_array_index(u->shadow_vqs,
> +                                                      svq_idx);
> +        vhost_svq_set_svq_kick_fd(svq, file->fd);
> +
> +        if (svq->hdev_kick.initialized =3D=3D false) {
> +            int r =3D event_notifier_init(&svq->hdev_kick, 0);

Where is event_notifier_cleanup() called?

> +            if (r) {
> +                error_report("Failed to create kick event notifier");
> +                return r;
> +            }
> +        }
> +
> +        file->fd =3D event_notifier_get_fd(&svq->hdev_kick);

Modifying the function argument is probably not expected but
vhost_virtqueue_start() doesn't use it after this call, so there is no
immediate problem. It would be safer to have a local struct
vhost_vring_file that can be modified without affecting the caller's
copy.

> +    }
> +
>      int ret =3D vhost_set_vring_file(dev, VHOST_USER_SET_VRING_KICK, fil=
e);
>      if (ret < 0) {
>          return ret;
> @@ -1721,6 +1742,24 @@ static int vhost_user_set_vring_kick(struct vhost_=
dev *dev,
>  static int vhost_user_set_vring_call(struct vhost_dev *dev,
>                                       struct vhost_vring_file *file)
>  {
> +    struct vhost_user *u =3D dev->opaque;
> +    int svq_idx =3D file->index - dev->vq_index;
> +    if (u->user->memory_isolation) {
> +        VhostShadowVirtqueue *svq =3D g_ptr_array_index(u->shadow_vqs,
> +                                                      svq_idx);
> +        vhost_svq_set_svq_call_fd(svq, file->fd);
> +
> +        if (svq->hdev_call.initialized =3D=3D false) {
> +            int r =3D event_notifier_init(&svq->hdev_call, 0);

Where is event_notifier_cleanup() called?

> +            if (r) {
> +                error_report("Failed to create call event notifier");
> +                return r;
> +            }
> +        }
> +
> +        file->fd =3D event_notifier_get_fd(&svq->hdev_call);

Same as above.

> +    }
> +
>      return vhost_set_vring_file(dev, VHOST_USER_SET_VRING_CALL, file);
>  }
> =20
> @@ -2715,6 +2754,17 @@ static int vhost_user_postcopy_notifier(NotifierWi=
thReturn *notifier,
>      return 0;
>  }
> =20
> +static void vhost_user_init_svq(struct vhost_dev *dev, struct vhost_user=
 *u)
> +{
> +    /*Modified from vhost-vdpa*/
> +    u->shadow_vqs =3D g_ptr_array_new_full(dev->nvqs, vhost_svq_free);
> +    for (int i =3D 0; i < dev->nvqs; i++) {
> +        VhostShadowVirtqueue *svq;
> +        svq =3D vhost_svq_new(NULL, NULL);
> +        g_ptr_array_add(u->shadow_vqs, svq);
> +    }
> +}
> +
>  static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
>                                     Error **errp)
>  {
> @@ -2859,6 +2909,10 @@ static int vhost_user_backend_init(struct vhost_de=
v *dev, void *opaque,
>      u->postcopy_notifier.notify =3D vhost_user_postcopy_notifier;
>      postcopy_add_notifier(&u->postcopy_notifier);
> =20
> +    if (vus->memory_isolation) {
> +        vhost_user_init_svq(dev, u);
> +    }
> +
>      return 0;
>  }
> =20
>=20
> --=20
> 2.43.0
>=20

--B6GEy+uFbHjCCumJ
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmppBfkACgkQnKSrs4Gr
c8incggAjXD8O74CX7ZbPEI9yeqAUza43JWOz78Ypa4LvWMaqWm0MK2nSmjunVjC
99wXDVM2Dz2DVphziIy7C6D/zyJBopg1K/N08Z1ZKB43TY3BtteU0tfEgJuAOooA
TKK5UJynp/mLbMG8IWEVB1Sg9bogNL8cckPMzVVzkQwCD+33CPBfwHChwmR4zuai
XNUeTUnU3D4mQycDXAlsWG+MwGQRh1GPd6i0Q8bIXM7Uv1w8qSSeZ4skNGEvH0SZ
Xq7Y0sXONrDVkRGyvKkHOb7claFGvm4KoCUTt8rVwe1BSM9+JMC+apsDBiLvTxlX
qAJCi8AzjycweYFAENIpHtQrM5h0uw==
=gN7E
-----END PGP SIGNATURE-----

--B6GEy+uFbHjCCumJ--

