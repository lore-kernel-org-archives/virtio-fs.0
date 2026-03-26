Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FDA37756C
	for <virtio-fs@lists.linux.dev>; Thu, 26 Mar 2026 15:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774540527; cv=none; b=JtcNuvsTXN1GTkFAmZlG5qTok2PapjeuftjGU6mC5XGcUEvuhIjQ/+iDfTWcy+Jp0rDg1mzaixOJ20jRLRGe926uPzL+LhnHx25V8/o+3qfqr3VHcCUacHounW8JqBp3zNzvFBBnQjGqXZlIs9NQRJTuUsgGz3HhHUqmVGLZo/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774540527; c=relaxed/simple;
	bh=HkhsZ+4WYb4UpPprivDQbnPhli6Yt/ZiU2dF3YO8xwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S6ojLle377HU3KyV1igjXR6bFfpmdgfcMVggwxGsC9nceq1tp4kzJzecVDou1l/uKaM46rgVOBC6alLDdFr3V632nvBoPViAjLujcFjun9el7gXZl70a9ktXGrG/xSSFP/wl5LmrjKaJ/juiPINZ9xfPP9ajFnn9N4uerUIhF2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DWdkQCXG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DWdkQCXG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774540525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HkhsZ+4WYb4UpPprivDQbnPhli6Yt/ZiU2dF3YO8xwM=;
	b=DWdkQCXGLIxFr6hv9Qy5lqYjFs0cBhMDtEVC0Ws4PbBOWgkI1srdgFHxna72sSY5EvL4zA
	5AAft5VirPPGgYT9JfelvVq901EmTU+ZyIBH7HhRQWS/gHlD2ayAgmQkXYLY0d95ySPJQq
	OBjlUkelto9awXvub1tyKkcOYF/GvQI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-674-9AB8HI5TOiiMAQVC29dtyA-1; Thu,
 26 Mar 2026 11:55:22 -0400
X-MC-Unique: 9AB8HI5TOiiMAQVC29dtyA-1
X-Mimecast-MFC-AGG-ID: 9AB8HI5TOiiMAQVC29dtyA_1774540520
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A9501800610;
	Thu, 26 Mar 2026 15:55:19 +0000 (UTC)
Received: from localhost (unknown [10.45.226.37])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8779D19560B1;
	Thu, 26 Mar 2026 15:55:16 +0000 (UTC)
Date: Thu, 26 Mar 2026 11:55:14 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Cc: qemu-devel@nongnu.org, virtio-fs@lists.linux.dev,
	zhenwei pi <zhenwei.pi@linux.dev>, Hanna Reitz <hreitz@redhat.com>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	qemu-block@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Fam Zheng <fam@euphon.net>, Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH v2 0/4] vhost-user-blk: fix compatibility with older qemu
 versions
Message-ID: <20260326155514.GF758087@fedora>
References: <20260311084728.751169-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mhkaxRLYx8MX0uJr"
Content-Disposition: inline
In-Reply-To: <20260311084728.751169-1-dtalexundeer@yandex-team.ru>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12


--mhkaxRLYx8MX0uJr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 11, 2026 at 01:47:24PM +0500, Alexandr Moshkov wrote:
> v1 -> v2:
> - reorganize commits: make refactor commits first, then core semantic cha=
nge
> - add additional pre_save check for inflight migration possibility
>=20
> ---
>=20
> This is a small continuation of my series about inflight migration for vh=
ost-user-blk.
>=20
> This series is designed to solve the problem of compatibility with older =
versions of qemu, where this feature has not yet been introduced (for examp=
le, if we want to downgrade versions due to some problems).
>=20
> In the current version for vhost-user-blk, this feature is enabled using =
the parameter and further migration of the inflight region will depend on w=
hether the vhost-user has accepted the new protocol feature or not. This cr=
eates an inconvenient dependency, because there is no way to disable this f=
eature without reconnecting to the backend.
> This series slightly changes the semantics of the introduced protocol fea=
ture VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. Enabling this feature a=
dds a new parameter for GET_VRING_BASE message - skip_drain, which allows t=
o control drain in-flight requests on the backend.
>=20
> Thus, user can enable or disable inflight-migration param for vhost-user-=
blk to maintain compatibility with older versions of QEMU.

Can you describe what the user needs to do in more detail?

While the patch series introduces a way to tell the vhost-user back-end
whether or not to use inflight migration at runtime, I don't see a way
for the user to enable/disable inflight migration at runtime in QEMU. So
how does the user migrate back to an old QEMU if the current VM was
launched with inflight-migration=3Don?

Stefan

--mhkaxRLYx8MX0uJr
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmnFVuIACgkQnKSrs4Gr
c8g/nAf/fg5Y8ZNvlhaxNPN1jfI8plT7beo1az0FD+g2faVR4zLuDlumqocFziQQ
H7qgyugiiJrgdT41sk3AXd/SKiqGgTUAnVLzpYaYFdfRJLIeomJLHPZQxXIO/+Ye
CfCZL0e7Diwt/442ISK3jRwlBcCamEl5frLvn4PGSYPCLzcxds7gsAPN6dEmnGhm
VgZWc7qs6GXTWD3O/WOZkdk3QOR64cRIIE4GVt6w4zszzliRlvqIv7i4VXobCp5Z
83dnaz6xsrR8wT4j3f6TrlJBLZipe+BBYRHlM/mDl+K5nQ5TKrTuTUxrD8ZieobT
ApWq9QsUqScul4vR+NlhwQHXaYhXgQ==
=7g79
-----END PGP SIGNATURE-----

--mhkaxRLYx8MX0uJr--

