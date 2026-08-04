Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025733EC2E3
	for <virtio-fs@lists.linux.dev>; Tue,  4 Aug 2026 18:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785867442; cv=none; b=IU+6mHnpTIvus8M/gHZQWqIh9TtdRcAZcYU/SeezPa8nVQ82aGD9vPFB4IeP6F7f5AAvrLzDtYR2XmmLuwBAhJgCZk37FdACAzRnbFIpYY9CRsD6ATaTo/vSi9AE0aVFAdl13j4rZkcphJhhifTHf1dHTeSii+RLMzs0MLt8gtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785867442; c=relaxed/simple;
	bh=3lWhPtOAxXJzeBBLIl6OODawf1Z59FlsChaST9EYacc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VQpUtAZNCi0Tmt/UCBe7u1aTAGOl8yJInQnPKMrbRYdr+0jnzc7s1XCMvBZLJgYoiWQO/3kR2bHBicPXDr833Zv6hEhtkgH9GwHHtR0GH3TRzMq3NBIRx3H+Hbbzc62Hr17LJy4Hvl7WaetDSah9WaZtxyKzYv27MifOzDeudXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HVJ/MTYr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HVJ/MTYr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785867437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PW24GpLjdxocxVmbrxYcONmZtLw2HMPyNF1/hlL8Uo4=;
	b=HVJ/MTYr4apeAFR1pnH1rTI9wzd2y28I3hYM+bz7pm1DjkkEZdz1hVr8bTVQeCpV8fVx81
	oPvwcDXN3w89+V/RW+T8J5KgmI3ermhsPyvkFrIrtrJdRu9Ru1+9sDBR2ft6HDkbzaM7yP
	H5lxJiq005OiTBuQtgx99uEV3kHhu3U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-336-itBefzPcPV2eoo6VCQb6Fw-1; Tue,
 04 Aug 2026 14:17:07 -0400
X-MC-Unique: itBefzPcPV2eoo6VCQb6Fw-1
X-Mimecast-MFC-AGG-ID: itBefzPcPV2eoo6VCQb6Fw_1785867425
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9B17195605E;
	Tue,  4 Aug 2026 18:17:03 +0000 (UTC)
Received: from localhost (unknown [10.2.16.106])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 82CDD1956087;
	Tue,  4 Aug 2026 18:17:00 +0000 (UTC)
Date: Tue, 4 Aug 2026 14:16:59 -0400
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
Subject: Re: [PATCH RFC 11/15] hw/virtio/vhost-user: create isolation region
Message-ID: <20260804181659.GB488200@fedora>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-11-6b97c439eb28@gmail.com>
 <20260728175931.GI371693@fedora>
 <CA+spn3qkZ-2=4q2nn_6-wp85U4Xv3oaDAmCHEP_yB=N4aZSceg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CCi6ZsUm/3bY9z1X"
Content-Disposition: inline
In-Reply-To: <CA+spn3qkZ-2=4q2nn_6-wp85U4Xv3oaDAmCHEP_yB=N4aZSceg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

--CCi6ZsUm/3bY9z1X
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 03, 2026 at 11:26:29AM -0700, Connor Kite wrote:
> On Tue, Jul 28, 2026 at 10:59=E2=80=AFAM Stefan Hajnoczi <stefanha@redhat=
=2Ecom> wrote:
> > >
> > > +typedef struct IsolationRegion {
> > > +    uint64_t base_addr;
> > > +    uint64_t vring_base_addr;
> > > +    uint64_t size;
> > > +    int iso_fd;
> > > +} IsolationRegion;
> >
> > The purpose of the base_addr and vring_base_addr fields is not obvious.
> > I suggest adjusting the types, names, and adding comments to make the
> > purpose clearer:
> >
> >   typedef struct {
> >       void *mem;           /* mapped shared memory */
> >       size_t size;
> >       uint64_t vring_iova;
> >       int fd;              /* shared memory fd */
> >   } IsolationRegion;
> >
>=20
> Agreed on adding clarification.  Is there a reason to change from uint64_t
> to void * for referencing the shared memory region address?  Most uses of
> that variable expect uint64_t currently.  Here's what I am currently thin=
king:

The shared memory region address is a C pointer where the shared memory
is mmapped and the type for an arbitrary C pointer is void *. The casts
needed around qemu_memfd_alloc() and qemu_memfd_free() suggest that
uint64_t is not the natural type for this.

Keeping this as a C pointer helps differentiate the address from an
IOVA, making the code clearer.

Also, with the comments about base_addr below addressed, the
hwaddr/uint64_t uses will be reduced.

--CCi6ZsUm/3bY9z1X
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmpyLJsACgkQnKSrs4Gr
c8hsiAf+O8eM6Cm6J6F5SQQRKO0xloi/SxDmc8rg8+3ejKgi0Op58cDsYH1QmPSs
Uht7u5Rl2m+Ams45gEXKW+IFfGgc1hZVW1IxqGdJ2FIgcfdUADQojWUoCmUF1MHR
o7J6tJHssUOpbLYuob6Lms2+K1LOVQabsvgCo1ZlRAMIvv5keZFcEtAj63G9S9tq
LKZQSNZpkhCa78yguOzWMgQxuTBxbSvgPyzkQP5Md6aKq+Dqui7i8O59qyvXQS/1
YGD24AAEtT96qzl5N5/wtowy4J13gIQTJmgnfGo0pUF9dxtn+oxiXD2gdZTraGWX
/Y/2w+Ik+ph8gDiOqQQoHbzXR0b8Fg==
=42sH
-----END PGP SIGNATURE-----

--CCi6ZsUm/3bY9z1X--

