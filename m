Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C003FE36E
	for <virtio-fs@lists.linux.dev>; Mon, 27 Jul 2026 18:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785176618; cv=none; b=uY24rGN8NBxHC6jCS6t9sh+zabEtyUREQXL+ssQDCfEBsISS5HGxTbprQ3ZmmE337BYIrMjOzs7ecOAAEhrEFnM7RaYKBlM4pdClnYQWP5SbM5R0287ZB/DyOW3RYarTFZP29uJBJJL8yQbPHMesLm4IoUKGVW1a6tc5UOnQn1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785176618; c=relaxed/simple;
	bh=ZXDlJ8n3xPDBjhT4EY3xq+fK/7i5VAnTGhoZVp2UdkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IX/1sQbbzoFSLa/iZPrwSxz9b1qFynPQMadMhOf+ztOnBKyZ+9+X9HZvnd7phbUulWGUgFDT9t9WP4dr2ezdRC9jWbN5Wh+pc4OCkcw8GtMjAMcAXhvUpHhsxqEn3VWNkqT353BAaBfjs8JH1cpQN/bYImycd07tixj/qoll1OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IjTQOBE9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IjTQOBE9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785176615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZXDlJ8n3xPDBjhT4EY3xq+fK/7i5VAnTGhoZVp2UdkA=;
	b=IjTQOBE9Wx5HnHfdk0Tc+vu2UILsL/Zu1VhlYV0mSsZaRaTEkn5DzF2OCuPx/1uNhDydef
	AW+1SWTyWYC27/P/X5sVeDLSiP2GwN/8LnorqRSFSkiwkfJDO2R1rBuRSCqMqFOH7EAC22
	pvusbyZAbzT0PRUAM6S1V928np6vM+k=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-290-LVGBbTrvN66hTohZ7yIYHQ-1; Mon,
 27 Jul 2026 14:23:32 -0400
X-MC-Unique: LVGBbTrvN66hTohZ7yIYHQ-1
X-Mimecast-MFC-AGG-ID: LVGBbTrvN66hTohZ7yIYHQ_1785176609
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3AE5A195E909;
	Mon, 27 Jul 2026 18:23:28 +0000 (UTC)
Received: from localhost (unknown [10.2.16.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A7A5530010D0;
	Mon, 27 Jul 2026 18:23:25 +0000 (UTC)
Date: Mon, 27 Jul 2026 14:23:24 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: ConKite <connorkite@gmail.com>, qemu-devel@nongnu.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
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
Subject: Re: [PATCH RFC 00/15] vhost-user: isolated memory
Message-ID: <20260727182324.GA371693@fedora>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <a45f108c-f897-40b7-a996-9e55150c09c8@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7gZyb6NXvQiWaoF9"
Content-Disposition: inline
In-Reply-To: <a45f108c-f897-40b7-a996-9e55150c09c8@rsg.ci.i.u-tokyo.ac.jp>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

--7gZyb6NXvQiWaoF9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 25, 2026 at 12:45:08PM +0900, Akihiko Odaki wrote:
> I also hope this could fix vhost-user for TCG:
> https://gitlab.com/qemu-project/qemu/-/work_items/2092
>=20
> Perhaps the memory isolation should be enabled by default for TCG.

If I understand the bug correctly, TCG needs the dirty bitmap to be
up-to-date and vhost-user's dirty logging mechanism does not suffice.
Memory isolation would keep the dirty bitmap up-to-date but copying data
between guest RAM and the isolated memory would add overhead.

For the TCG use case it should be possible to use just
vhost-shadow-virtqueue.c without isolated memory so that
vhost_svq_flush() -> virtqueue_fill() -> virtqueue_unmap_sg() ->
dma_memory_unmap() keeps the dirty bitmap updated. There is still an
overhead because the virtqueue kick/call is intercepted by QEMU, but
there is no memcpy.

The TCG use case is something that could be tackled once memory
isolation is finished. If no one has time to implement the pure svq
solution for TCG, then memory isolation could be used in any case.

Stefan

--7gZyb6NXvQiWaoF9
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmpnohwACgkQnKSrs4Gr
c8jIxQgAuhwfSxCzUAdPtmkhQFxI+8GOr3btP712SYvxsAHGWWd4zJ53QTx8uue5
ElpE2sc3AGz1CX++E+AcyrOI2Ut1wnsiAF42M3Zx5eHfpi7X4MEjf2uDUcxcAiEb
RMjgfDl7gOBll5xnICbtouc3N+5PL9KyFXhLV4/kVsS8EamcCfO+X+N82jDxVhFG
gDUUuBWNk2kqla8RffqOO63ccVkWTDwUYnfWWBAC+urVi8E+QGh8RgnW6NS0hXPU
ElgGeB0pRrbfow60Rbd8tQxeF3mLifE3dd9AJTonR7Ivf3CrSvhv7EgdOCiczEQr
Sx+vK5c7gHAJizeupduM8aZCfV9S2g==
=3WQy
-----END PGP SIGNATURE-----

--7gZyb6NXvQiWaoF9--

