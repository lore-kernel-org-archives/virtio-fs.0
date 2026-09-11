Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA055488DAF
	for <virtio-fs@lists.linux.dev>; Fri, 11 Sep 2026 16:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789143962; cv=none; b=ERvG57RjC4VetO2G1q7iQf7GxlTLFi5hw+W+V5wAqlXk0Ve7eibr5Ez767rMpj2fH2IGauH/4ug2dm/EbaL0cHEXAqhnlP2A0j/64YSPoYfZeXQZY6eDvqPUPSP1xml6W2gZFHtN0PHkzUZCqqg0EC8ZrJk9iILuPjm2Ys64nOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789143962; c=relaxed/simple;
	bh=bquhT/ngeU3LRCEI/rNOxqGD6easUmuD5vQSEkaa5Kc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kxIwf9lUYH3Wy8q6A3ylbkrYRbxwfia4ZC1EpeJqSxKL/LV42fdJ3h+oMKwfG2QIJVJ1sxTVKlg8cyCOXEuCFFeBykY3y0qm77p2VdnB1MYmYzH//IhOiy23x1tkA4OL8S/H4yzDzsfEQ3iP36m3gmfOuvsM5fFMZG9SMGOlY38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YZFA78TW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YZFA78TW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789143959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4q4XIxW/vwNesCg/a34TUO9RXpsXNeKwK6PzYAFAAaI=;
	b=YZFA78TWlwmtvD/dvEJp5/lxmzXjHl83Dkb8IjRIFSYIuOwgpn0v/M5tdOS7huqY3yYnka
	aYTlwO9E3F7sjykOCA1SjA8N70eAuU0eaV7ksfHvxNHHZJou72/WplFdtSeRpX5aywC/Fk
	HsMYLi/muQaSQ47/5Ujq3Az8nBt/8Rc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-570-BbleVnsAMvOQUHwFoS9lPQ-1; Fri,
 11 Sep 2026 12:25:55 -0400
X-MC-Unique: BbleVnsAMvOQUHwFoS9lPQ-1
X-Mimecast-MFC-AGG-ID: BbleVnsAMvOQUHwFoS9lPQ_1789143952
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 551D81954B0A;
	Fri, 11 Sep 2026 16:25:51 +0000 (UTC)
Received: from localhost (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3E455433;
	Fri, 11 Sep 2026 16:25:48 +0000 (UTC)
Date: Fri, 11 Sep 2026 12:25:47 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Connor Kite <connorkite@gmail.com>, qemu-devel@nongnu.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
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
	Eric Blake <eblake@redhat.com>, Jason Wang <jasowangio@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Alyssa Ross <hi@alyssa.is>,
	Demi Marie Obenour <demiobenour@gmail.com>
Subject: Re: [PATCH RFC v2 13/13] net/vhost-user: add memory isolation
Message-ID: <20260911162547.GA157639@fedora>
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
 <20260817-vhost-user-isolated-memory-v2-13-948aae960abb@gmail.com>
 <87lda12mhy.fsf@pond.sub.org>
 <CA+spn3qK+n+buANnmkT6J8Yu4ZbwS_CqRbisE1uOmNsn1835iw@mail.gmail.com>
 <87lda010j1.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KnjVaE+vH1BLpuM3"
Content-Disposition: inline
In-Reply-To: <87lda010j1.fsf@pond.sub.org>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

--KnjVaE+vH1BLpuM3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2026 at 07:54:26AM +0200, Markus Armbruster wrote:
> Connor Kite <connorkite@gmail.com> writes:
>=20
> > On Thu, Aug 20, 2026 at 2:02=E2=80=AFAM Markus Armbruster <armbru@redha=
t.com> wrote:
> >>
> >>
> >> Any guidance on when to enable it?
> >>
> > ...
> >
> >> Likewise.
> >>
> >
> > In both cases, you would enable this for added security.  There's
> > obviously a performance hit, but it prevents a potentially misbehaving
> > vhost-user backend from reading or modifying undesired portions of
> > guest memory, since data transfer occurs wholly via bounce buffers.
> > This may be more useful in the generic netdev vhost user case than it
> > is with the passt version, but the goal is for the mode to be
> > accessible for any vhost-user device.
>=20
> Work this into the commit message, please.
>=20
> > Do you think guidance is needed here in net.json?  I was thinking
> > that, if isolation-mode gets to a point of being merged, then
> > information like this would make sense somewhere in the online
> > documentation, but I'm happy to add something here as well.  I was
> > just trying to be similarly short and to-the-point as the other option
> > descriptions for these structs.
>=20
> I think it needs to be somewhere in the user documentation.  We have so
> many configuration options, and so little guidance on what to do with
> them.
>=20
> The doc comments in the QAPI schema are reference documentation (they go
> into the "QEMU QMP Reference Manual").  Reference documentation should
> be concise and to the point.  When you have more useful things to say
> than fit there, you need to find nother place, and maybe link to it from
> the reference docs.
>=20
> I suggest to try adding brief guidance to the doc comment, and then we
> see how we feel about it.
>=20

Here is the vhost-user documentation:
docs/system/devices/virtio/vhost-user.rst

You could add a section to this document explaining the memory isolation
feature.

Stefan

--KnjVaE+vH1BLpuM3
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmqkK4sACgkQnKSrs4Gr
c8iXVwf8DGpxrzx9sLiqhzx/nPuFuWno1XrNXMpuygfYefGT3kkNbrCM+7Ajf3sF
Zf+R2yKfp7zLKw4wk2fFXxr9xBC+betiNkPGzHNardyzABhHmDvbaYXsthlzeNp3
/3Tn7BcLjc8rH7h3BoE30GgnGvRBJSLsJ2iyQodjha2V6SEWq+dqF6T9KduOPXr1
6C8cIHs6FqBRNP6kPAZ0ZkjUGv3XeMhnC3UXRb9mR447T4la/TucQOXZJtp4qbo8
O/G2SmK0Kim9OXwljF4zQgXTczoZannQnx4gVgsC3vBU2glM2Bjr7LbbMCzFYkud
RjaktYz9gizD10dTMLT+tnxBNZS54Q==
=buAp
-----END PGP SIGNATURE-----

--KnjVaE+vH1BLpuM3--

