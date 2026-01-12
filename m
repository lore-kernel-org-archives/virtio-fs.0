Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A33337F74C
	for <virtio-fs@lists.linux.dev>; Mon, 12 Jan 2026 18:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768241302; cv=none; b=VJRi19RbFsvJxPhCtA31S+lLhB5+0C7Q17LE9NSZoc26/2E1L5HMDl1Q2UpgHuPv0+PpWMmKZoXyAfOWgs9wnhIRdNx6e480rfxj++aAvmeoNjFy33Pa9yX3nGrGM98fglJjBBwJ/Hoy3yO/BgdnHUrla5yLSfRpZG+8GVqav9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768241302; c=relaxed/simple;
	bh=CZlG8L36WeuwBF2yrIkCaWUotu9wqw4VBFR9gImNZMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+af7x/8m+he6eDcIxLVwkFXB0sICtY1zCmjPaxgNde9yZ3EIu0qa7ou77EP3XAUR0giV+Ob8amtL7lVWdNhJcsuTp+SmYHszbBXk9p6VbLFjRwZUzM8ikK7fY9SrfpC4zR60q9IhTaUZPZABpBSJIlnBoIQucKsh8LYWaXtDOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jPrDvywQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jPrDvywQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768241298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1/KV3TWlJtNj6z94AHB2yvO5E2UwosMByoL/fEH0Tns=;
	b=jPrDvywQEDvpgnGHBpvn9LOBbSjpp0nn1VcAIAtwqDvrDq/HlYQ73DN+0KFL5RlISXWk48
	R+QtgI1dAh5vL7F2rfkS5YOuMlQRy2JpQsFrvgQFL0eF2Latqz0DPraWc8+Q8RUWEtk1SM
	BiviaDAT3Cy1BDHVxmRhD5PTffnYZwY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-534-22FHcGjVNXOQcitn2KK_Sg-1; Mon,
 12 Jan 2026 13:08:14 -0500
X-MC-Unique: 22FHcGjVNXOQcitn2KK_Sg-1
X-Mimecast-MFC-AGG-ID: 22FHcGjVNXOQcitn2KK_Sg_1768241292
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 475CC18005BF;
	Mon, 12 Jan 2026 18:08:11 +0000 (UTC)
Received: from localhost (unknown [10.2.16.84])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6258619560AB;
	Mon, 12 Jan 2026 18:08:08 +0000 (UTC)
Date: Mon, 12 Jan 2026 13:08:07 -0500
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
Subject: Re: [PATCH v5 2/5] vhost-user: introduce protocol feature for skip
 drain on GET_VRING_BASE
Message-ID: <20260112180807.GD462084@fedora>
References: <20260112114503.1174330-1-dtalexundeer@yandex-team.ru>
 <20260112114503.1174330-3-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="k9oYvRkR3x8Mk6bh"
Content-Disposition: inline
In-Reply-To: <20260112114503.1174330-3-dtalexundeer@yandex-team.ru>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17


--k9oYvRkR3x8Mk6bh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 04:45:00PM +0500, Alexandr Moshkov wrote:
> Add vhost-user protocol feature
> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT
>=20
> Now on GET_VRING_BASE this feature can control whether to wait for
> in-flight requests to complete or not.
>=20
> It will be helpfull in future for in-flight requests migration in
> vhost-user devices.
>=20
> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> ---
>  docs/interop/vhost-user.rst    | 52 ++++++++++++++++++----------------
>  include/hw/virtio/vhost-user.h |  1 +
>  2 files changed, 29 insertions(+), 24 deletions(-)
>=20
> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> index 02908b48fa..80c80aada5 100644
> --- a/docs/interop/vhost-user.rst
> +++ b/docs/interop/vhost-user.rst
> @@ -1033,26 +1033,27 @@ Protocol features
> =20
>  .. code:: c
> =20
> -  #define VHOST_USER_PROTOCOL_F_MQ                    0
> -  #define VHOST_USER_PROTOCOL_F_LOG_SHMFD             1
> -  #define VHOST_USER_PROTOCOL_F_RARP                  2
> -  #define VHOST_USER_PROTOCOL_F_REPLY_ACK             3
> -  #define VHOST_USER_PROTOCOL_F_MTU                   4
> -  #define VHOST_USER_PROTOCOL_F_BACKEND_REQ           5
> -  #define VHOST_USER_PROTOCOL_F_CROSS_ENDIAN          6
> -  #define VHOST_USER_PROTOCOL_F_CRYPTO_SESSION        7
> -  #define VHOST_USER_PROTOCOL_F_PAGEFAULT             8
> -  #define VHOST_USER_PROTOCOL_F_CONFIG                9
> -  #define VHOST_USER_PROTOCOL_F_BACKEND_SEND_FD      10
> -  #define VHOST_USER_PROTOCOL_F_HOST_NOTIFIER        11
> -  #define VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD       12
> -  #define VHOST_USER_PROTOCOL_F_RESET_DEVICE         13
> -  #define VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS 14
> -  #define VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS  15
> -  #define VHOST_USER_PROTOCOL_F_STATUS               16
> -  #define VHOST_USER_PROTOCOL_F_XEN_MMAP             17
> -  #define VHOST_USER_PROTOCOL_F_SHARED_OBJECT        18
> -  #define VHOST_USER_PROTOCOL_F_DEVICE_STATE         19
> +  #define VHOST_USER_PROTOCOL_F_MQ                       0
> +  #define VHOST_USER_PROTOCOL_F_LOG_SHMFD                1
> +  #define VHOST_USER_PROTOCOL_F_RARP                     2
> +  #define VHOST_USER_PROTOCOL_F_REPLY_ACK                3
> +  #define VHOST_USER_PROTOCOL_F_MTU                      4
> +  #define VHOST_USER_PROTOCOL_F_BACKEND_REQ              5
> +  #define VHOST_USER_PROTOCOL_F_CROSS_ENDIAN             6
> +  #define VHOST_USER_PROTOCOL_F_CRYPTO_SESSION           7
> +  #define VHOST_USER_PROTOCOL_F_PAGEFAULT                8
> +  #define VHOST_USER_PROTOCOL_F_CONFIG                   9
> +  #define VHOST_USER_PROTOCOL_F_BACKEND_SEND_FD         10
> +  #define VHOST_USER_PROTOCOL_F_HOST_NOTIFIER           11
> +  #define VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD          12
> +  #define VHOST_USER_PROTOCOL_F_RESET_DEVICE            13
> +  #define VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS    14
> +  #define VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS     15
> +  #define VHOST_USER_PROTOCOL_F_STATUS                  16
> +  #define VHOST_USER_PROTOCOL_F_XEN_MMAP                17
> +  #define VHOST_USER_PROTOCOL_F_SHARED_OBJECT           18
> +  #define VHOST_USER_PROTOCOL_F_DEVICE_STATE            19
> +  #define VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT 20
> =20
>  Front-end message types
>  -----------------------
> @@ -1243,11 +1244,14 @@ Front-end message types
> =20
>    When and as long as all of a device's vrings are stopped, it is
>    *suspended*, see :ref:`Suspended device state
> -  <suspended_device_state>`. The back-end must complete all inflight I/O
> -  requests for the specified vring before stopping it.
> +  <suspended_device_state>`.
> =20
> -  The request payload's *num* field is currently reserved and must be
> -  set to 0.
> +  By default, the back-end must complete all inflight I/O requests for t=
he
> +  specified vring before stopping it.
> +
> +  If the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT`` protocol feat=
ure
> +  has been negotiated, the back-end may stop the vring immediately witho=
ut
> +  waiting for inflight I/O requests to complete.

This paragraph is not specific enough. It gives the impression that I/O
requests can be left running, but that's not the case. They need to be
quiesced and recorded in the Inflight I/O Tracking
(VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD) shared memory data structure.

I suggest rewording it as follows:

  If the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT`` protocol
  feature has been negotiated, the back-end may suspend in-flight I/O
  requests and record them as described in :ref:`inflight-io-tracking`
  instead of completing them before stopping the vring. How to suspend
  an in-flight request depends on the implementation of the back-end but
  it typically can be done by aborting or cancelling the underlying I/O
  request. The ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT``
  protocol feature must only be neogotiated if
  ``VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD`` is also negotiated.

(A _inflight-io-tracking label needs to be added in order to reference
the "Inflight I/O tracking" section.)

--k9oYvRkR3x8Mk6bh
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmllOIYACgkQnKSrs4Gr
c8h2JQf/SPamntOaL6elDTbdtpbcZDZu0cJlltQLSs3d1yrm/mQ9d3Ww4nMB5L56
f7IntZUZjHmDdD3zO0s6T2z8JffKNYibpeM5Lvh1yUZgkBZunwEhHZlMAtygYH01
8WYxBaT1ZWhbnH52y4YZBsHO0xMj9SAiKJ1gOU/zbvRnsaLxf9dN+ZFWIsPr8Pmv
VzrVr3WbvVbHQzGUsiazRPloQrmmFfZ9/jodmSw0TBfrtag5HRPQSsLbdxopvISY
VTi3ApEO9qkeHPSp89cqAaQUJrOygVgBk6KAni56/XlmqaFaLvKJ4Rcw32wq/ou/
NCy2PlF2BWPYWWIgyeSjEGbq+5cAtQ==
=y8QB
-----END PGP SIGNATURE-----

--k9oYvRkR3x8Mk6bh--

