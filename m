Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37AE378D9C
	for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 21:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426741; cv=none; b=uoi4s2d87ZGBrsO89b2fPJ5v4dyE75Ke2I2jll4OPfW0rhjKqWvUVU++b2clQ9F1++tz14qbAexxkHTmR/6GqucE4tgPZ0TWeRS1RyZqhO0J1AoGfT8nBEwe0mlJv1mV5lnB0qW9lZG8UDF3b6eSMoeyK71d+HMCQ7lk8/40unE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426741; c=relaxed/simple;
	bh=K0zw0vcA3YK2meUa0pufqcKZwzTuW8bw9h9sLS+7H4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jyxJhZpmIusTTuIA357BLiLcENQ/WI33Lar6XaDje2PpfcK4soZPE6Wri5/OzDB0TPqPnd6Xrre8ZAUvIIxWhxJ6sldG1PPmsh/Da/kmQhdEuiE0AwbJsX5JhuzNnZm9GX2DR0j9ddAiYUy68ReedijCPaD54NddQdnVmE2JMnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=StazULHc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="StazULHc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768426707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JPx9uJw4wQmF8PUhN2KKTU9qO0xqstrOMTkwEsCbpVM=;
	b=StazULHcVGMf4BuoUlToZSz0Ooh1Y4utn8m5hUOehiMFKC2Fw0FCapJCieqSioDqaq14d9
	f1pwUx3+8BYyyjREN5yxCuQeveBq5IZUHClPOgj+swWuroNXPCerf29FS6uAKsFENRHytz
	bvhBtaLJ3s4yK6D1Tg6IGtfPezD51FM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-569-eLEcRTmEMTGcoXSAktue6Q-1; Wed,
 14 Jan 2026 16:38:23 -0500
X-MC-Unique: eLEcRTmEMTGcoXSAktue6Q-1
X-Mimecast-MFC-AGG-ID: eLEcRTmEMTGcoXSAktue6Q_1768426702
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF6911956094;
	Wed, 14 Jan 2026 21:38:20 +0000 (UTC)
Received: from localhost (unknown [10.2.17.85])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ADFA330002D8;
	Wed, 14 Jan 2026 21:38:18 +0000 (UTC)
Date: Wed, 14 Jan 2026 16:38:17 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Peter Xu <peterx@redhat.com>
Cc: Alexandr Moshkov <dtalexundeer@yandex-team.ru>, qemu-devel@nongnu.org,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Zhenwei Pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raphael Norwitz <raphael@enfabrica.net>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	mzamazal@redhat.com, Fabiano Rosas <farosas@suse.de>,
	qemu-block@nongnu.org, virtio-fs@lists.linux.dev,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH v6 4/5] vhost: add vmstate for inflight region with inner
 buffer
Message-ID: <20260114213817.GA622013@fedora>
References: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
 <20260113095813.134810-5-dtalexundeer@yandex-team.ru>
 <aWfrT6JOMm9MGoIw@x1.local>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2bB6VCgR7K7AjZez"
Content-Disposition: inline
In-Reply-To: <aWfrT6JOMm9MGoIw@x1.local>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4


--2bB6VCgR7K7AjZez
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2026 at 02:15:27PM -0500, Peter Xu wrote:
> On Tue, Jan 13, 2026 at 02:58:17PM +0500, Alexandr Moshkov wrote:
> > Prepare for future inflight region migration for vhost-user-blk.
> > We need to migrate size, queue_size, and inner buffer.
> >=20
> > So firstly it migrate size and queue_size fields, then allocate memory =
for buffer with
> > migrated size, then migrate inner buffer itself.
> >=20
> > Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> > ---
> >  hw/virtio/vhost.c         | 57 +++++++++++++++++++++++++++++++++++++++
> >  include/hw/virtio/vhost.h |  6 +++++
> >  2 files changed, 63 insertions(+)
> >=20
> > diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> > index c46203eb9c..f655c53b67 100644
> > --- a/hw/virtio/vhost.c
> > +++ b/hw/virtio/vhost.c
> > @@ -2028,6 +2028,63 @@ const VMStateDescription vmstate_backend_transfe=
r_vhost_inflight =3D {
> >      }
> >  };
> > =20
> > +static int vhost_inflight_buffer_pre_load(void *opaque, Error **errp)
> > +{
> > +    info_report("vhost_inflight_region_buffer_pre_load");
> > +    struct vhost_inflight *inflight =3D opaque;
> > +
> > +    int fd =3D -1;
> > +    void *addr =3D qemu_memfd_alloc("vhost-inflight", inflight->size,
> > +                                  F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL=
_SEAL,
> > +                                  &fd, errp);
> > +    if (*errp) {
> > +        return -ENOMEM;
> > +    }
> > +
> > +    inflight->offset =3D 0;
> > +    inflight->addr =3D addr;
> > +    inflight->fd =3D fd;
> > +
> > +    return 0;
> > +}
> > +
> > +const VMStateDescription vmstate_vhost_inflight_region_buffer =3D {
> > +    .name =3D "vhost-inflight-region/buffer",
> > +    .pre_load_errp =3D vhost_inflight_buffer_pre_load,
> > +    .fields =3D (const VMStateField[]) {
> > +        VMSTATE_VBUFFER_UINT64(addr, struct vhost_inflight, 0, NULL, s=
ize),
> > +        VMSTATE_END_OF_LIST()
> > +    }
> > +};
> > +
> > +static int vhost_inflight_region_post_load(void *opaque,
> > +                                           int version_id,
> > +                                           Error **errp)
> > +{
> > +    struct vhost_inflight *inflight =3D opaque;
> > +
> > +    if (inflight->addr =3D=3D NULL) {
>=20
> IIUC this can never happen because pre_load() must trigger before
> post_load(), and when reaching post_load() it means pre_load() must have
> succeeded..
>=20
> So, IIUC we can drop this post_load() completely (or assert addr in
> pre_load instead).

I asked for this input validation check. If the migration stream is
inconsistent (e.g. broken or malicious source QEMU), then the subsection
might be missing but size could be non-zero. The destination QEMU should
fail cleanly and not run into undefined behavior.

Stefan

--2bB6VCgR7K7AjZez
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmloDMkACgkQnKSrs4Gr
c8hbPgf+JtCqYyM/8FZOLpH5UQkkWwKV8n+FMsFmGk9Gkvt7330GJrKEK1GMIAET
gB8d9CJIr1ndEs8iEolaou4YY0yNm8OTFJ0mkv3W+9yDV6ULsY0ydYkAU9eEbFNt
wJjZMuUQAHL5W4w5+8CpPr37LZCcgrlwlWSUw9dhvY1KhOKeLMfSIrbIxQOO3BAO
P/QHJXL/dg8b5PQqkiTPH8+hfWWfRGRCUnPFibOEph+2G3gbbkk9SLTkInIbgWR2
FmMw6SIuaoNEo0yYawA74r0CuJ16x0Z1NLQpAzlyLGNwEuLWub4h8hDcI7OjrtqV
7ObFpwOGg7FbcWV4dsyaJL9C003jVQ==
=xwdv
-----END PGP SIGNATURE-----

--2bB6VCgR7K7AjZez--

