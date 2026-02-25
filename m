Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A64C3451BB
	for <virtio-fs@lists.linux.dev>; Wed, 25 Feb 2026 13:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772024757; cv=none; b=aTC9wWobqPfVSP51Nqx2q646V3psASeKaWdDOMH8QPy+zPMXat9FWJwpKbtEve9vhJUnUpP/ZbdeHc1QvNKH85X2zesL5BCBGSa5bOLLh1i5RPxMY1D+JiN3tpmiLEDbjCAslS/Y0jgnqCw9FUCSB6TOguuHVL9ox2gEP/4uPsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772024757; c=relaxed/simple;
	bh=aSRzmYl16quamxK3VevR7CZ95xSzkGgVeEwAF+6MWPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TwFWfAXyUUSjgegsDRKHxmVNiyzCrGBW5sawZeVvAMF1N2fuHpigGUeQ4QOqRlj2exDBgNKIkhxFTDqGhkqjsHRLBqxT7r7q0V2dS3wP8oc/dK5VqZmQxvzoBA9yyCAaWHzn0qFkLKJ4+ab+zM/g9jUifmFe5PMd0jyuUTr4RWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MbEpPsG1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MbEpPsG1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772024755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lwnsPzJoMH4XWfrme1gJfiT8NDcUr0VN6UL4SZNwysA=;
	b=MbEpPsG1lzh4zL0Q02lNKZkqt4DX6hTHcY6BsDNgtJ7m2RDsNgK/qF7S9bVk7W7YnpihAu
	LTgAAh5cK8LIf8G+m/pT9Vh71NwYv1/Dnk8BpapWZwwgufAegs3WkH9pqSVQkTDNjNC2qd
	W31sX/ElD6jiN22Fotyya7Ww9jZlf4w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-6mVj4-VrNt6GgdiYFJWqlA-1; Wed,
 25 Feb 2026 08:05:51 -0500
X-MC-Unique: 6mVj4-VrNt6GgdiYFJWqlA-1
X-Mimecast-MFC-AGG-ID: 6mVj4-VrNt6GgdiYFJWqlA_1772024749
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DFB2A1956055;
	Wed, 25 Feb 2026 13:05:48 +0000 (UTC)
Received: from localhost (unknown [10.2.16.91])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ED9251800666;
	Wed, 25 Feb 2026 13:05:46 +0000 (UTC)
Date: Wed, 25 Feb 2026 21:05:43 +0800
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Cc: qemu-devel@nongnu.org, Raphael Norwitz <rnorwitz@nvidia.com>,
	virtio-fs@lists.linux.dev, Milan Zamazal <mzamazal@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, zhenwei pi <zhenwei.pi@linux.dev>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Fam Zheng <fam@euphon.net>, qemu-block@nongnu.org
Subject: Re: [PATCH 1/4] vhost-user.rst: fix typo
Message-ID: <20260225130543.GA1663199@fedora>
References: <20260224075055.863068-1-dtalexundeer@yandex-team.ru>
 <20260224075055.863068-2-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YpuVS3lxF746hVRw"
Content-Disposition: inline
In-Reply-To: <20260224075055.863068-2-dtalexundeer@yandex-team.ru>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


--YpuVS3lxF746hVRw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 24, 2026 at 12:50:52PM +0500, Alexandr Moshkov wrote:
> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> ---
>  docs/interop/vhost-user.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--YpuVS3lxF746hVRw
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmme86cACgkQnKSrs4Gr
c8gyPQf/TTArzOCaQAEb+dXUjpZFd6kTU5agHi+nmDN9ille22nGNVbiH8EU7uUF
ZnPB/PCJhmO+VPoCKwTieQ9WyL5q/ExJ/zJWmqt4ndYWZBXoHsgSk2ma8dBICt6Y
A5zIwSBh0IuJoxhgigmOSjjYMNa6zw+gFNK560KyCYLY3ZMYdFh9NCBUNzHVp+Zl
yKpValSXrr+QoGM000czDeE2FBEB31QEi3c62KfUo6N/2+hkoSEYAFK/3vEj83s8
ocnJoJUpc0c2g8fjYj8Zk9iC61SP3/f6xIv3VEemkd9kY8shbvGAtrxa24sPaA3j
mK1ijOrd8jdKePpqWj94b8MJWjjigQ==
=6roa
-----END PGP SIGNATURE-----

--YpuVS3lxF746hVRw--

