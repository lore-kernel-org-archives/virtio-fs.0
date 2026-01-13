Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CFC30DD1E
	for <virtio-fs@lists.linux.dev>; Tue, 13 Jan 2026 18:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768327974; cv=none; b=sTnCACWPvwxGPfhzl+jPPBpkC/559Wewn6O3ly36KPk5JnC0WYPxTdk775Ea+XFxPWQLz9/dnl6orGx91avZ9Cs6tw9Xov74r3k0TTduItT+dQ+UFo0mZVG2NlnrWEeuFmR9/S26oaK19z+P5ALeqLJC/dl4CF0Jw2mLYKOnuvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768327974; c=relaxed/simple;
	bh=WYui2i1hQ7LVffqnmW2T9U1xwARvetElHKxctWqTjNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ldNU6hD6BmzSVoaPQ/ci8hhJAYCumlFi2ATN1dFrk5Yi/oIlxzDQkKOjyybtmzeKNfydYyi9QZTUiLmlK8adtWyjpB1oiLWv8vOOnSNusIdpgNWDEfzfdA4WhymQv/ZMgxRxjGG44bJ8KN9IXRu7btKi7VPPcdwB9vbbTtezSLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=USc8X6Vl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="USc8X6Vl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768327972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WYui2i1hQ7LVffqnmW2T9U1xwARvetElHKxctWqTjNo=;
	b=USc8X6VlMt+OsGVqQYZhUoSbNZGd9w0QQxenUtk/yGGGAPS6PzDt4IAUWk+v/Dn4HPKXBZ
	WZum2Uv2YrFexiWa+mAlW4xViZS8Sm7utabOmHBVsTzr/s7rPsCGU5SmDxZ4EI8hodU1zz
	/gPOpvp9fO/GYPCjBQihCqYLoMNxkaA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-126-iIDlxvY5PsyLnLoB3ImLOg-1; Tue,
 13 Jan 2026 13:12:48 -0500
X-MC-Unique: iIDlxvY5PsyLnLoB3ImLOg-1
X-Mimecast-MFC-AGG-ID: iIDlxvY5PsyLnLoB3ImLOg_1768327966
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E559A1955F34;
	Tue, 13 Jan 2026 18:12:45 +0000 (UTC)
Received: from localhost (unknown [10.2.16.89])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0990430001A2;
	Tue, 13 Jan 2026 18:12:43 +0000 (UTC)
Date: Tue, 13 Jan 2026 13:12:42 -0500
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
Subject: Re: [PATCH v6 0/5] support inflight migration
Message-ID: <20260113181242.GB528940@fedora>
References: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lVzFgWl4xxlRkd0j"
Content-Disposition: inline
In-Reply-To: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4


--lVzFgWl4xxlRkd0j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 13, 2026 at 02:58:09PM +0500, Alexandr Moshkov wrote:

Peter: Please review the migration aspects (especially the vmstates).
Thank you!

> v6:
> - fix documentation about new protocol feature
> - add check to ensure that inflight buffer subsection has been successfully loaded
> - disable support for the new feature if in-flight or inflight migration is not supported.

Aside from the comment I posted:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

This patch series should go through Michael Tsirkin's VIRTIO/vhost tree.

--lVzFgWl4xxlRkd0j
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmlmixoACgkQnKSrs4Gr
c8gqpAf7BnhCzUazDaA9ZO1q8fUjkEgNhEQnAQhtHKHWOiK2SLxnnQJ/Ub77R2a/
dN962xmc4tjpDeMYgou6eRyyGFt1gC17AW4AFFShDENkarArqSWbpxeDZmaHVXVF
UA1Jd8VaCzeMReiAXmbm71nf65OnUK4ZHLVWilEhnOEyCE+I6Ma8QaSaOUTcFO3G
9e/glq8lIddQ/UXhbTZ2jwqRh6QI6S/JrV3LJP3zE3QlSqERRCNb+1EaoyFVud9v
lQRFjW3JctZIzbkgGXKUeSdCgU6lJIM8nOZB7/7kL0VbJ8kdms6ojgKllbwozQRo
iSRKOxM89Bwlq9+1J0QXvx23KUu7RQ==
=gow+
-----END PGP SIGNATURE-----

--lVzFgWl4xxlRkd0j--

