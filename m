Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32613C061F
	for <virtio-fs@lists.linux.dev>; Mon, 27 Jul 2026 18:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785178104; cv=none; b=nhBlAn1ev2DqBhheJx4FmBM0UFKXRrcK8T0HTNBu6m0ALBs4n8702qLUm2U77kE1RQAhbOic39fNhnjfpDObLz7nRt1h1l44uBIj0x0iZv6ijiEAtdUe4K4CfUxloAuLzk6FCCSVCNE1NcnSrNXma/Ri66YvWQgOvq6P6T27Z84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785178104; c=relaxed/simple;
	bh=DxvmTtchr4UzzMmASLsG9ODgqCC37XNBV1t92AT83uo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LhfT7FQvU7reZDNwYHNSFMTQ42esg+SD3l7dghhgs+/39EKebP+CaBMJLJLUBCHhW7vLS4+0X1ZzW7yHfK42Lq0hadKeHezjN4u8y4m5zJmJt+sG2zcehZuJXjvbN1o/+8VOivyZMkvFkrtvXrrZRJt/0JuohkmPaxo8lmI6WcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K5zLNQZH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K5zLNQZH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785178101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WpsSGUZlY0X4wFyUj6Sc+g+V8RjxHI71Pn+TpdujcMo=;
	b=K5zLNQZHIEmPqrO+ZhLQzjiFtgoTvE66IMTadpLrKBvcH4vALHeREypyX7lAbH7LRsm4uE
	KJiyOG9iOeKr1bYTpywzJEVx/6yZfOX2UKsSHOtooYFDVHAGMg7BKbubzTyvOyVYwEmkIH
	R3Sy2DKxE28SXc7cl7TywpF9qkFlTOQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-352-7h0j0K1_OA2ZPPvNoKDbeQ-1; Mon,
 27 Jul 2026 14:48:15 -0400
X-MC-Unique: 7h0j0K1_OA2ZPPvNoKDbeQ-1
X-Mimecast-MFC-AGG-ID: 7h0j0K1_OA2ZPPvNoKDbeQ_1785178093
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D4AD195607C;
	Mon, 27 Jul 2026 18:48:12 +0000 (UTC)
Received: from localhost (unknown [10.2.16.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E79EE180058F;
	Mon, 27 Jul 2026 18:48:09 +0000 (UTC)
Date: Mon, 27 Jul 2026 14:48:08 -0400
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
Subject: Re: [PATCH RFC 04/15] net/vhost-user: add memory isolation
Message-ID: <20260727184808.GC371693@fedora>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-4-6b97c439eb28@gmail.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1OUtWB2/rX/yB0aQ"
Content-Disposition: inline
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-4-6b97c439eb28@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

--1OUtWB2/rX/yB0aQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 03:30:03PM -0700, Connor Kite wrote:
> Add a memory-isolation property to NetdevPassOptions and
> NetDevVhostUserOptions in net.json.  This property will
> be used for vhost-user devices to disable access to guest
> memory from devices.
>=20
> It will be passed into vhost_user_init() in a future patch.
>=20
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>  net/passt.c      |  7 +++++++
>  net/vhost-user.c |  4 ++++
>  qapi/net.json    | 15 +++++++++++----
>  3 files changed, 22 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/passt.c b/net/passt.c
> index 45440c399b..ce80186883 100644
> --- a/net/passt.c
> +++ b/net/passt.c
> @@ -735,6 +735,13 @@ int net_init_passt(const Netdev *netdev, const char =
*name,
>      s->pidfile =3D pidfile;
> =20
>      if (netdev->u.passt.has_vhost_user && netdev->u.passt.vhost_user) {
> +        bool memory_isolation G_GNUC_UNUSED =3D false;
> +
> +        if (netdev->u.passt.has_memory_isolation &&
> +           netdev->u.passt.memory_isolation) {
> +            memory_isolation =3D true;
> +        }

This is dead code (hence G_GNUC_UNUSED) and is harder to review because
we don't know how it will be used until later in the patch series. I
guess vhost_user_init() and net_passt_vhost_user_init() will gain a
memory_isolation argument in a future patch.

Linear reviews of the patch series are easiest for reviewers. Please
reorder this so that vhost_user_init() and net_pass_vhost_user_init()
are changed first. You can hardcode the argument to false in those
patches. This patch can be moved afterwards so that memory_isolation is
never dead code.

--1OUtWB2/rX/yB0aQ
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmpnp+gACgkQnKSrs4Gr
c8gPOQf/XYHmejG58UtHRz8dS3h1zerjw27qrlpz+sb/VxPkff6Q/N1EFsQBjOYI
mzxUd8rmBkUdE6VtdcU9EBjyJdOFuimihT8mM+GD6fq8Iui6U1tVGVRxFNvefRo4
2lTCTqvDMCQUIIMflryfP5oVGZY2Gq3V65xOslZ7MYvilPWCVG4iIS58/1vk1VI7
qHaQoJPMpSsSyZ/PYLbb8R5JCtGprERCDaadSXXQDqpTF9iiFrAW0CQRhdmKTYXz
K5GA2i1EAO74SJzBBBd1UglZ4mwZBsmv5RBj1eopve0TfTDfMGiUzOlZAiNUvpCl
kw0n/Akh/aL6XnT5z8uReL63ALKMng==
=8TkL
-----END PGP SIGNATURE-----

--1OUtWB2/rX/yB0aQ--

