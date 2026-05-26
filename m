Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B4A3BFE2E
	for <virtio-fs@lists.linux.dev>; Tue, 26 May 2026 18:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779821349; cv=none; b=O3Onnh/4u+pm29Zu8SGGPCVOxXTeEQQ8t+PEvgjSDomnaAIeIu6URKaDMH99XtGHGJ76Xcq53Q0PbYd4hOrshwzFomYJCnSAwxy7uVkmmzTsjLLXRKHzD46ECw0gbeJ4tqmT2GlLLkuAdwQMzx3o9He0A8RymJHiffhVL6D19dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779821349; c=relaxed/simple;
	bh=oAlxdl4eyya0a/SQVD+VmpQt0sy/ZDm2um8uJpSaQSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TVOZJqevNu+8jfDCxCMNgXKjChTy/NfJIrsMjXorhIW15pfjF3sXFE3JCfwR4+m34mBvIiDdnogB+yDaaEMWFLAjaWF+DGhIoQygt9YsoLW0ebbOT/WznZLXxD5Ie5HRBXdblNx7ANzMLajNKk/Hgb08vrLQjXO+IrmJqBb5oq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IHaOB7Y6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IHaOB7Y6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779821346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oAlxdl4eyya0a/SQVD+VmpQt0sy/ZDm2um8uJpSaQSc=;
	b=IHaOB7Y6UWt+lwUCtnQFIeIVk6b8MGGiTbvPucXFYcG52MW8iuuvIqYrG330KIZFn5G15A
	3r/Jdn0mxIw3DxrlwdTGCG+2FZ4Dbp8kKej1H149QOcAYVSKeOgZaEyRhu7rjGZDCq6+kg
	uQSPv3jQoihSQ2NcHuHXJV2JKVUOTLc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-191-3-GuWBDfPRaYg3gNOa00wQ-1; Tue,
 26 May 2026 14:49:02 -0400
X-MC-Unique: 3-GuWBDfPRaYg3gNOa00wQ-1
X-Mimecast-MFC-AGG-ID: 3-GuWBDfPRaYg3gNOa00wQ_1779821341
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E9C4195608C;
	Tue, 26 May 2026 18:48:59 +0000 (UTC)
Received: from localhost (unknown [10.2.16.201])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BAA3619560A3;
	Tue, 26 May 2026 18:48:56 +0000 (UTC)
Date: Tue, 26 May 2026 14:48:55 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Raphael Norwitz <rnorwitz@nvidia.com>
Cc: Alexandr Moshkov <dtalexundeer@yandex-team.ru>, qemu-devel@nongnu.org,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Milan Zamazal <mzamazal@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jason Wang <jasowang@redhat.com>, qemu-block@nongnu.org,
	Fam Zheng <fam@euphon.net>, zhenwei pi <zhenwei.pi@linux.dev>,
	Hanna Reitz <hreitz@redhat.com>, virtio-fs@lists.linux.dev,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Kevin Wolf <kwolf@redhat.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Subject: Re: [PATCH v3 5/5] vhost-user: add skip_drain param to GET_VRING_BASE
Message-ID: <20260526184855.GA1762453@fedora>
References: <20260330095226.158386-1-dtalexundeer@yandex-team.ru>
 <20260330095226.158386-6-dtalexundeer@yandex-team.ru>
 <613f140f-de27-4f83-8a02-5370833dd659@nvidia.com>
 <965db8ae-b44a-4b29-b006-56e8474d52b5@yandex-team.ru>
 <c9082536-6b4b-4e9a-a6ff-764dbbf649c9@nvidia.com>
 <19b0aa2e-90dc-4467-acc8-adc0bec7c388@yandex-team.ru>
 <1c6af04b-9efd-4d07-ab5c-e6d616818c2c@nvidia.com>
 <9fb43ec4-7825-4382-991f-a2cc17142138@yandex-team.ru>
 <be99a7b5-1575-4da0-93dd-8460a77ddf77@yandex-team.ru>
 <7fc11fc4-4bc7-46b3-8d83-1ab5a8198cda@nvidia.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="G2V4MdiFmcwLQ/A7"
Content-Disposition: inline
In-Reply-To: <7fc11fc4-4bc7-46b3-8d83-1ab5a8198cda@nvidia.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12


--G2V4MdiFmcwLQ/A7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 25, 2026 at 05:34:37PM -0400, Raphael Norwitz wrote:
> Apologies for the late reply.
>=20
> On 5/12/26 1:55 AM, Alexandr Moshkov wrote:
> > Gentle ping :)
> >=20
>=20
> [...]
>=20
> > > > > > On 4/16/26 5:26 AM, Alexandr Moshkov wrote:
> > > > > > > Greetings! Thanks for reply!
> > > > > > >=20
> > > > > > >=20
> > > > > > > On 4/15/26 20:21, Raphael Norwitz wrote:
> > > > > > > > I=E2=80=99m not sure I like using the num field in
> > > > > > > > vhost_vring_state to set magic values which
> > > > > > > > affect protocol behavior for GET_VRING_BASE. It
> > > > > > > > feels like a hack to me. I would think the
> > > > > > > > proper solution if we want to support migration
> > > > > > > > from new to old would be to have new use a
> > > > > > > > different new message entirely. Can we do that?
> > > > > > >=20
> > > > > > > I think we can, but I thought at first that this
> > > > > > > will be almost a complete copy of GET_VRING_BASE
> > > > > > > message, with the exception of waiting for drain of
> > > > > > > requests, so I choose to expand existing message.
> > > > > > >=20
> > > > > >=20
> > > > > > I think a new message would be cleaner. Anyone else have though=
ts?
> > > > > >=20
> > > > > > > If this is not an appropriate approach, is it better
> > > > > > > to make a new message like GET_VRING_BASE or a
> > > > > > > separate message used together with default
> > > > > > > GET_VRING_BASE message (for example, message for
> > > > > > > setting some kind of status on the server)? What
> > > > > > > should I name this new message?
> > > > > > >=20
> > > > > >=20
> > > > > > Maybe GET_VRING_BASE_SKIP_DRAIN? How would a separate
> > > > > > message used together with default GET_VRING_BASE
> > > > > > message work?
> > > > >=20
> > > > > I was thinking about a message something like
> > > > > SET_VRING_ENABLE - for example SET_SKIP_DRAIN_ENABLE, that
> > > > > would enable/disable some state (skip_drain) in the backend.
> > > >=20
> > > > I'd need to see the flow in more detail but sounds promising.
> > >=20
> > > On migration vhost-user-blk firstly send SET_SKIP_DRAIN_ENABLE with
> > > num =3D 1 message if `inflight-migration` device parameter
> > > and=C2=A0VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT enabled. Then =
send
> > > GET_VRING_BASE and continue work as usual.
> > >=20
> > > On SET_SKIP_DRAIN_ENABLE backend sets inner state (skip_drain) so
> > > when GET_VRING_BASE is called and skip_drain is true the drain will
> > > skipped.
> > >=20
> > > What do you think?
> > >=20
>=20
> I'm happy with that in theory but would like more clarity on the details.=
 In
> particular, I'm not sure what you mean by "vhost-user-blk firstly send
> SET_SKIP_DRAIN_ENABLE". To add a new message I would think we would have =
to
> do a vhost-user protocol feature negotiation to gate it.
>=20
> Also what are the precise semantics for SET_SKIP_DRAIN_ENABLE? Would it be
> sent on backend connect or when we're about to migrate?
>=20
> I was hoping others would comment but at this point I'd suggest drafting =
the
> code and then we can re-review.

Adding a new GET_VRING_BASE_SKIP_DRAIN message seems simpler to me than
a stateful SET_SKIP_DRAIN_ENABLE where the back-end needs to stash the
enable_skip_drain state and the front-end would have to toggle the state
if it switches between skip drain and classic behavior.

Stefan

--G2V4MdiFmcwLQ/A7
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmoV6xcACgkQnKSrs4Gr
c8gO5QgAgA3dv5wURe71crXnlRC9xGXeM1mgFfgbXQxAHQPyeVbmGMoilz8NyqqH
lIzGb3uLNi5Sa6Zsnp0bWYZ6VF7AB3oDKUrRT/mqE7fG0MZBj3NQu2MgftOb4zk5
Vlt4phkUNBsPePj32pRkxY9+vHvxoyAGBMQd6H0QNW6HZP3x8aYMuqDCGlXYCO7R
7B1oRrvhcvVobpWNQqWLYT3nVUdRULbOML/V5VMPm3LHizNE+Dx1hzJJJ8+IS9Xd
9NefbVhUGlvEtq8mXvWTZakko7xL9I1lrMId7RTmEcscgwOfI5SfGItex5c4yM/z
2GMkooROV2GEUxkzzItRe6rhPmdjOA==
=hmVh
-----END PGP SIGNATURE-----

--G2V4MdiFmcwLQ/A7--

