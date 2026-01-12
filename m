Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0502A3803ED
	for <virtio-fs@lists.linux.dev>; Mon, 12 Jan 2026 18:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768241969; cv=none; b=LAMAZts62H/cwlUCnaBJDJUBGM1ZPtR6+oJ860CJFJZa7pNxZeEzuv46aoH3q+GOHzybzlAxEGiyZqBEgjcoBvoXcgp53FgbEwGFQkJg5fk+jSVuS1fZ2vS9D5QQh3asGlaxmLgl2CaDj67bRcwR5i/BQOzDGbNsddAthddAYuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768241969; c=relaxed/simple;
	bh=4YyjxoMCLNlLhLyO43aG55Pf5VPDFtievB5Aq9JvJow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mM93EXlbfMskQIqQGG+U4UhjvdbnL6LXbjX++0JISP7MF9uJ31J9MaRPbW4yPxCBKu8wc9bLRBduABm8m/gwf4NpSPxdv8TdKTo09lqrjmRpuHfFid8zALW8ZJdV83QfQD3+lmdqHLqFuf8oLTwZlEb6sBwUxOCRuR9J20yEpQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D6z6kZmc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D6z6kZmc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768241966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uWImpNDY3qDJODMH81isMdTCVl85SC8LSYbHD1B+vjE=;
	b=D6z6kZmcTuunXOqSwCjj46AmXT1Rm0ZhTiqtETTOFlXf6ZBEpPJ9ULu1tBKE0G10oxxC9t
	yrrkN6d3dRRzTzbmTtxgsI1alBMpy1SEjmbX7UPEVmYjX9qtk2Ab8j0zzQHXY/iPfpBZIJ
	soYMzDBEuqA8dseintCUD1xJLM4ZXBM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-39-U2vZ0YlkN_-z0Ho1RkLVlg-1; Mon,
 12 Jan 2026 13:19:23 -0500
X-MC-Unique: U2vZ0YlkN_-z0Ho1RkLVlg-1
X-Mimecast-MFC-AGG-ID: U2vZ0YlkN_-z0Ho1RkLVlg_1768241961
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E61119560A7;
	Mon, 12 Jan 2026 18:19:20 +0000 (UTC)
Received: from localhost (unknown [10.2.16.84])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9994318007D2;
	Mon, 12 Jan 2026 18:19:18 +0000 (UTC)
Date: Mon, 12 Jan 2026 13:19:17 -0500
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
Subject: Re: [PATCH v5 5/5] vhost-user-blk: support inter-host inflight
 migration
Message-ID: <20260112181917.GE462084@fedora>
References: <20260112114503.1174330-1-dtalexundeer@yandex-team.ru>
 <20260112114503.1174330-6-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VTYAjM3KSO5TwbW4"
Content-Disposition: inline
In-Reply-To: <20260112114503.1174330-6-dtalexundeer@yandex-team.ru>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


--VTYAjM3KSO5TwbW4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 04:45:03PM +0500, Alexandr Moshkov wrote:
> During inter-host migration, waiting for disk requests to be drained
> in the vhost-user backend can incur significant downtime.
>=20
> This can be avoided if QEMU migrates the inflight region in
> vhost-user-blk.
> Thus, during the qemu migration, with feature flag the vhost-user
> back-end can immediately stop vrings, so all in-flight requests will be
> migrated to another host.
>=20
> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> ---
>  hw/block/vhost-user-blk.c          | 28 ++++++++++++++++++++++++++++
>  include/hw/virtio/vhost-user-blk.h |  1 +
>  2 files changed, 29 insertions(+)
>=20
> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> index a8fd90480a..5e44f6253c 100644
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -656,6 +656,28 @@ static struct vhost_dev *vhost_user_blk_get_vhost(Vi=
rtIODevice *vdev)
>      return &s->dev;
>  }
> =20
> +static bool vhost_user_blk_inflight_needed(void *opaque)
> +{
> +    struct VHostUserBlk *s =3D opaque;
> +
> +    bool inflight_drain =3D vhost_dev_has_feature(&s->dev,
> +                        VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);

VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT must only be negotiated
when inflight_migration is enabled. Otherwise the backend will use this
feature even though vhost_user_blk_inflight_needed() skips migrating the
in-flight region.

--VTYAjM3KSO5TwbW4
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmllOyUACgkQnKSrs4Gr
c8iujgf/bxbvIfcN+xw9Nboe/6p2dan4K/fTivT0186Z4jMVtyKtHH0h1MzBXzaW
+iNjZKslKLxgcMQiebhXCegC4skgot+yo7edZTR6les1wyDkWWonJ0IOEjTfW1w+
YweITzu8T/IEsgKA4fTiDnLU8oiqGgyTOEZSr4NmpisYh3ia6XvmQCa7MlrJT5tu
3b6eKEcOzKWQa69f3zapszsZ+r6mY2CRUq7i5h4fagt8qrZ9dqBPDC4GTVLcfHuJ
fneyGw6jZe6zA082AHzB5dslFLvH+kH1M1NmYYsq5VSBMja64HufJQHfFAj4W3KZ
vv03Gua765Zz5BInylMhvaRDG351cQ==
=Sllm
-----END PGP SIGNATURE-----

--VTYAjM3KSO5TwbW4--

