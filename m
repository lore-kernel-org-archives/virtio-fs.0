Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780FF387370
	for <virtio-fs@lists.linux.dev>; Mon, 12 Jan 2026 18:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768242191; cv=none; b=oxGQi7vKqaLu52WlaESJg8WE/yuIeTRETA4x13UmX3Hr4LNgSoqQvjfApbEKNpdGe1sdvSsYnD73CIPHnLTE3b+Rh5A0t5ilB5CYQ/gd6nLlP4m7MxjAkSwuno3zrM7dm5GGMu5X0EhVoiHV4oMIrhlSSu6XhBYWzG4wl4GMTYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768242191; c=relaxed/simple;
	bh=H9o7QZjhAV/W2Z09LERkEyhqnIEO0ujkz8q+VKgM5sk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r+YT5I+RQYi4d4yCi/hcH8JRvli4EXqdW52FOlmM+MG3cpQGuPD9mTSTHmoNr+GVv1y2h6avavQQmZQYKrFQAVJfpQWgI0hBAgZuEFdjKs4C2BQlOcNrMoZZmb6R+FX0XieSCTAL9mZKD0P7g3858VzXazLT9dEZeWSxl5SGw2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QI7VJ9Rn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QI7VJ9Rn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768242186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u74OqmqYKZGCUm/ziCjn38k34PwihK1pDTC+GGX5BkY=;
	b=QI7VJ9RnnDMNp3PScsnn9tBTs0s5gu4RgBkuaVR/vxuB1KQ1IF8yfy86QhNZR/9iqzGz6e
	5oHAy7yHzGE48c/6VY4dcz9MGfR0iYTMB7aZyPkRxTwghXu7LUqFcGgzmzveUhg34NsoVa
	fmHfC1BEmbmDvdECpXymGFn0n4yEtYk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-CoJnRdylPY2Qw-4NI4CqJw-1; Mon,
 12 Jan 2026 13:23:05 -0500
X-MC-Unique: CoJnRdylPY2Qw-4NI4CqJw-1
X-Mimecast-MFC-AGG-ID: CoJnRdylPY2Qw-4NI4CqJw_1768242184
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D095F195605F;
	Mon, 12 Jan 2026 18:23:02 +0000 (UTC)
Received: from localhost (unknown [10.2.16.84])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EF2D9180009E;
	Mon, 12 Jan 2026 18:23:00 +0000 (UTC)
Date: Mon, 12 Jan 2026 13:22:59 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Cc: qemu-devel@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Zhenwei Pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raphael Norwitz <raphael@enfabrica.net>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	mzamazal@redhat.com, Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>, qemu-block@nongnu.org,
	virtio-fs@lists.linux.dev,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH v5 4/5] vhost: add vmstate for inflight region with inner
 buffer
Message-ID: <20260112182259.GF462084@fedora>
References: <20260112114503.1174330-1-dtalexundeer@yandex-team.ru>
 <20260112114503.1174330-5-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rp3pWHvw0dW3axJi"
Content-Disposition: inline
In-Reply-To: <20260112114503.1174330-5-dtalexundeer@yandex-team.ru>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


--rp3pWHvw0dW3axJi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 04:45:02PM +0500, Alexandr Moshkov wrote:
> Prepare for future inflight region migration for vhost-user-blk.
> We need to migrate size, queue_size, and inner buffer.
>=20
> So firstly it migrate size and queue_size fields, then allocate memory fo=
r buffer with
> migrated size, then migrate inner buffer itself.
>=20
> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> ---
>  hw/virtio/vhost.c         | 42 +++++++++++++++++++++++++++++++++++++++
>  include/hw/virtio/vhost.h |  6 ++++++
>  2 files changed, 48 insertions(+)
>=20
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index c46203eb9c..9a746c9861 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -2028,6 +2028,48 @@ const VMStateDescription vmstate_backend_transfer_=
vhost_inflight =3D {
>      }
>  };
> =20
> +static int vhost_inflight_buffer_pre_load(void *opaque, Error **errp)
> +{
> +    info_report("vhost_inflight_region_buffer_pre_load");
> +    struct vhost_inflight *inflight =3D opaque;
> +
> +    int fd =3D -1;
> +    void *addr =3D qemu_memfd_alloc("vhost-inflight", inflight->size,
> +                                  F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL_S=
EAL,
> +                                  &fd, errp);
> +    if (*errp) {
> +        return -ENOMEM;
> +    }
> +
> +    inflight->offset =3D 0;
> +    inflight->addr =3D addr;
> +    inflight->fd =3D fd;
> +
> +    return 0;
> +}
> +
> +const VMStateDescription vmstate_vhost_inflight_region_buffer =3D {
> +    .name =3D "vhost-inflight-region/buffer",
> +    .pre_load_errp =3D vhost_inflight_buffer_pre_load,
> +    .fields =3D (const VMStateField[]) {
> +        VMSTATE_VBUFFER_UINT64(addr, struct vhost_inflight, 0, NULL, siz=
e),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
> +const VMStateDescription vmstate_vhost_inflight_region =3D {
> +    .name =3D "vhost-inflight-region",
> +    .fields =3D (const VMStateField[]) {
> +        VMSTATE_UINT64(size, struct vhost_inflight),
> +        VMSTATE_UINT16(queue_size, struct vhost_inflight),
> +        VMSTATE_END_OF_LIST()
> +    },
> +    .subsections =3D (const VMStateDescription * const []) {
> +        &vmstate_vhost_inflight_region_buffer,
> +        NULL
> +    }
> +};

The subsection trick is neat - it allows the size to be loaded first and
then the memfd is allocated. However, it introduces a weird case: if the
source QEMU does not send the subsection, then the destination QEMU
loads successfully but with inflight partially uninitialized.

It's not obvious to me that the destination QEMU will fail in a safe way
when this happens. The source QEMU must not be able to trigger undefined
behavior. Can you add an explicit check somewhere to fail when this
required subsection is missing?

Thanks,
Stefan

--rp3pWHvw0dW3axJi
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmllPAMACgkQnKSrs4Gr
c8gihwgApc4mfVgjzgEDk8o01K+eG5FJ31taQzUXQCqNnk3AxS7HVZH3jrC2Tl9S
5Nom7FZacWDr0NTrTtMuzAg0rn6/JKiApBMeXXwup1+xlc1q29NiF2obJW9yO6um
vBDOG52S4yyKorVLenH1CHruscfLJi87E98TeKRfwQ79N/GeufpGof2Z43GXDm94
KrF9ihpMcUuupOZ2fRe4A7DfhEOqV1TEw7FQFXb5ZIVkpOM11Kaown5KQ0ktHbkw
VXwGj8x8isZG5Vl9ONcxFN9UGNvrkYCRTlvKmkJMbwTiSyj9GIDas+pMXbJBWvae
2B54KVeq/H30RQjijvkigwWAf5+c9A==
=5w/y
-----END PGP SIGNATURE-----

--rp3pWHvw0dW3axJi--

