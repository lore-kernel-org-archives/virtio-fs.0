Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9CA3CB2E5
	for <virtio-fs@lists.linux.dev>; Mon, 27 Jul 2026 19:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785179179; cv=none; b=n4hKInrcuqcCP0QNgcAS1YNNgoZSrx2yFHQ/2PV4oJKTs+cSYFTlfyM4SZ2Zurr+eiAdtWihCZ1+XzeFBSBZCLnxlDM3tkIwNJ531F7hCW8I//meXmGFmcoGK2PilrhuNBseqz0xrU9RcmQlyBMJunKbQ48pbpa1OspR1vRuuvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785179179; c=relaxed/simple;
	bh=ur0naNpj19H+JnpldDRHdrjL1rdj2IvD/r1kcm7fnTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oCuSggVj7HrrtpT163ohiokp/80NnL81JfrdTKc427Lihp2DGOwIPjZotQ3HZ56plsA0ti76HRN5V5UUbAjHDQqlwa8cOGFrzfN7fpJdvW9CJEuwyuW+tIAW2XRs1aiT0Z3u8koncJc44si7c3spJFN9XG5G50qofRMLpsXl32o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fZjG7rJp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fZjG7rJp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785179176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mM5h3ubQZstLI8T1Ui9C4krWDKq5yQCBW2N0LqK792s=;
	b=fZjG7rJp2SzWX2X2hlrmTEWVC4Jr82QYiISxwPKkDsuvrF35OU27MUJBINriNK72WtGDl+
	IOuaga+Nh1WWJoPj+dhugjWemLeTzTNS7LJDaarjUMfgCS2lEOD35V+R6D/YJ2qP1c2nM4
	O21V+BWNj/nboL5p1001beX66YiUYbs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-443-0hyJ2HrKMBiq2oioB9mdxg-1; Mon,
 27 Jul 2026 15:06:11 -0400
X-MC-Unique: 0hyJ2HrKMBiq2oioB9mdxg-1
X-Mimecast-MFC-AGG-ID: 0hyJ2HrKMBiq2oioB9mdxg_1785179169
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ECD561956072;
	Mon, 27 Jul 2026 19:06:07 +0000 (UTC)
Received: from localhost (unknown [10.2.16.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D5F3E180058F;
	Mon, 27 Jul 2026 19:06:05 +0000 (UTC)
Date: Mon, 27 Jul 2026 15:06:04 -0400
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
Subject: Re: [PATCH RFC 05/15] vhost-user: add memory_isolation to
 VhostUserState
Message-ID: <20260727190604.GD371693@fedora>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-5-6b97c439eb28@gmail.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GRVu7jzoCipJ+wdN"
Content-Disposition: inline
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-5-6b97c439eb28@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

--GRVu7jzoCipJ+wdN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 03:30:04PM -0700, Connor Kite wrote:
> @@ -73,12 +74,14 @@ typedef struct VhostUserState {
>      int memory_slots;
>      bool supports_config;
>      bool supports_inflight_migration;
> +    bool memory_isolation;
>  } VhostUserState;
> =20
>  /**
>   * vhost_user_init() - initialise shared vhost_user state
>   * @user: allocated area for storing shared state
>   * @chr: the chardev for the vhost socket
> + * @memory_isolation: disables device access to guest memory

"Device" is confusing because it has several meanings. "vhost-user
back-end" would be clearer.

"Disables" is also a little confusing because the vhost-user back-end
still needs to access guest memory somehow. Memory access cannot be
completely disabled. Something like "restricts vhost-user back-end
access to guest memory via bounce buffers" could be clearer, but it's up
to you. We probably don't want to repeat the full explanation in every
comment about memory isolation, so it's fine to omit the details as long
as there is user-facing documentation somewhere that explains what the
feature does.

--GRVu7jzoCipJ+wdN
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmpnrBwACgkQnKSrs4Gr
c8g/dggAh1YcQjd3Z68P3Ps7X5qBR06hLTnzCcvxJcgUdkL/zhk2JRB8QNKknhvW
S3BgaUom6aHcIvbo510pR/Y/IH0TqPU/IqKKwCRMS801ifd0K+Ma34s99i3vislo
vq5zrfcfMuyWUKb3KFaiiwGpoRSIEMon+jyZvB2UxU+bfRvRvVDN1wP/1Wn+TsDK
QRVDqg8Gzy4fWGB9YvM+OV6efVcOtLCTdzOLb/TVAFaxG0nJ3529x49lQHG5Myv+
i91ha0m/yl1XM/YMcTwIi8/ptgMgtPdqJPh8fSuU9d03ej4OM7bRsRkowrHE0+eq
F+92L+IMyU7aR8Y1A1vdhcakQZ2IBw==
=3u2s
-----END PGP SIGNATURE-----

--GRVu7jzoCipJ+wdN--

