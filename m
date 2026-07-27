Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFD23CB560
	for <virtio-fs@lists.linux.dev>; Mon, 27 Jul 2026 19:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785179291; cv=none; b=SAQA7M64wyosRYguv0SMKu7XJjPe6k8VI+Op8hCnxDX0rEAXyQWwGSgBglvvxXktUbunfqvevuqFbPXedjqd+h6T68Yzl1xxMAjajV5203xKbjo3yClcirVtZpocIOr8jf1YAzjigpJ4p9QtyOGKhvmit0cB46+e7Z1r+YrOhLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785179291; c=relaxed/simple;
	bh=SwpbPOqnnD9MA+Mzfzya6NMAzVVkgKaInegsKNu3mh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/CJTKpLvQauROwd6clbyYyeVXYUv0ZGnZL+z+h0q6oMEF4rHfMCfqdE/qdSBfoL8Xg3njTFLIzqyRUUrwgD3bW81MPVhmZBNLjuGHyVk1xCSxMdShkLn3HQFraGW/heLxN3OdHiksbIbUs5GMhW/+kepLeV9+3krIpRXGfYTfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H9HpfYCI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H9HpfYCI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785179287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cw9QiKJEcDCqbqsrfebfrHfj7TpToTYGJg3XpH6yQcc=;
	b=H9HpfYCI2cdRBDBrCS6PvR0OkGb+pgPmRH2C5pcF9PVa5fHi5NY09XiHPuDHrxmfHL093W
	GyQYoYAair+ziODT+dUn1dIBDLfk7O8vKzjTIbMK9sukUfcRLjS6JbUohV3fOhsYXYvTVG
	Z1KGcmsOPnQyh+ueazaRwqfc4r3Gx/g=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-kR_sglepMACP-qwhZrRPrw-1; Mon,
 27 Jul 2026 15:08:03 -0400
X-MC-Unique: kR_sglepMACP-qwhZrRPrw-1
X-Mimecast-MFC-AGG-ID: kR_sglepMACP-qwhZrRPrw_1785179281
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B380D195396E;
	Mon, 27 Jul 2026 19:08:00 +0000 (UTC)
Received: from localhost (unknown [10.2.16.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EF5841956041;
	Mon, 27 Jul 2026 19:07:58 +0000 (UTC)
Date: Mon, 27 Jul 2026 15:07:57 -0400
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
Subject: Re: [PATCH RFC 06/15] util/iova-tree: g_tree_foreach wrapper
Message-ID: <20260727190757.GE371693@fedora>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-6-6b97c439eb28@gmail.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qaZp+mfEdxI91Vos"
Content-Disposition: inline
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-6-6b97c439eb28@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

--qaZp+mfEdxI91Vos
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 03:30:05PM -0700, Connor Kite wrote:
> Add a wrapper to iova-tree to call g_tree_foreach.  Provies a means to

Provies -> Provides

> execute some function on each node of the iova-tree.
>=20
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>  include/qemu/iova-tree.h | 13 +++++++++++++
>  util/iova-tree.c         |  5 +++++
>  2 files changed, 18 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--qaZp+mfEdxI91Vos
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmpnrI0ACgkQnKSrs4Gr
c8ir3gf+OhQnbV3Foqq0Lf/GTYzHYVcXw+hQuD59mttfXx4LCtLw83jYFDEZ+WzM
AiEoJZzsE7gbEN1gdySWD8eFeVhBKlF73gYql6D92NvbmaO+a+dGb6EKOfCOUiXN
FLxV8zCxk8EKziyO2I5HTDasT1uF4fgVLKzZ+Ya2UYOn2h8jrEucRvkcwrjsChCH
uXu9SaivKmoBy8lt4UgaKfmkoxh2QBAlQ6efiA5IVjUxFYI6jxS93mHgTZ1j9bjH
rljvLlQvtK+DzUHEg0VvU4lSvMBGN9n9YH/KRW6KdZCC40gtHF51NvBMWwJ0w6Bx
SnaLhHLzzmsuU9amMYNIB/k7u4KSBQ==
=4xZZ
-----END PGP SIGNATURE-----

--qaZp+mfEdxI91Vos--

