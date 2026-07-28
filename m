Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27A6456E0B
	for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 15:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785252897; cv=none; b=ODC7wBdTW6dMxiwGQs8lJ3wfZuJsOx2KomFnKhFyUeo/dahe+hjMBcZYTk9PAwcXWQD16zaguyUwvkpkw8uA0WZyfp923V4vX2HhYrWMdOuBCwTPq/9/b8QFlan7/tbzjHS1zC/XDoQWsWhy5F+hrARVL25a8Hj7xeXmdxhn0c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785252897; c=relaxed/simple;
	bh=AxTeyW46VHxAPifZAJxoU78kEBKKdXQA6MgD4aF219w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdYxaVwFIBMA0PKraRWMzwZaIbptWtdTAYuJtzNBoPDuAf0kHr4f2HVa+tJ8v1unP1wYeMKHW79KOktzxtgpUATerYbNfmpmS9+B4+XMD0Ir2H2iVwwW3agY4WpP4nsEVD+aJZSeA8Hpky2E/QSZ+SlvhkebRNitNzr52+C+FLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VCgYILTu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VCgYILTu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785252895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NbtalUn5YV2BwRJOn3NO24/BoVQk+aDGSJLl569UGPk=;
	b=VCgYILTug2OxSdTJR4id4/aSm2sjFEMDeBg4hyGvp74P2q/7kLuvx4nggNsEx740W5GYQk
	U/ogJoCDwLUuujpjkssHHKjaqjYHNRmVxD1xAe8vycP61vM5aC0jjfOo0OepdByk3tQd0D
	SDCIa7m+aAv1C6ZgdTFqd7babD0HTjg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-551-CE9NSsIVMn2FkcD1ILBUOA-1; Tue,
 28 Jul 2026 11:34:49 -0400
X-MC-Unique: CE9NSsIVMn2FkcD1ILBUOA-1
X-Mimecast-MFC-AGG-ID: CE9NSsIVMn2FkcD1ILBUOA_1785252887
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F1EE1800366;
	Tue, 28 Jul 2026 15:34:46 +0000 (UTC)
Received: from localhost (unknown [10.2.16.73])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 19BBB30001A4;
	Tue, 28 Jul 2026 15:34:43 +0000 (UTC)
Date: Tue, 28 Jul 2026 11:34:43 -0400
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
Subject: Re: [PATCH RFC 10/15] hw/virtio/vhost-shadow-virtqueue: range
 boundary in translation
Message-ID: <20260728153443.GH371693@fedora>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-10-6b97c439eb28@gmail.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eti39NJJ1w8JEReO"
Content-Disposition: inline
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-10-6b97c439eb28@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

--eti39NJJ1w8JEReO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 03:30:09PM -0700, Connor Kite wrote:
> iova-tree expects inclusive range sizing when maps are allocated or searc=
hed.
> Currently, svqs use exclusive sizing when searching their
> vhost-iova-tree for a match to the region to be translated.  This could
> lead to errors if the region to be translated is at the edge of an iova
> region.
>=20
> Fix this by reducing `needle.size` by 1 in
> vhost_svq_translate_addr to bring then it line with DMAMap and iova-tree
> convention.
>=20
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>  hw/virtio/vhost-shadow-virtqueue.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--eti39NJJ1w8JEReO
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmpozBMACgkQnKSrs4Gr
c8izowf/U64p6OABThy11Z3fSW1rmXEl6Jrd7XezbfHbOKColkSAkObbzoE0UooI
zEUJUK3xgnTg5eTmYBfJt7KlROkw4hCbE5IFi6/Cga1Wwy5FdTIHjWpEz1KrYstE
o7qkGETt4hN5fTSCGYzbUqrTtH0mkazVnrfTQEiDfTDUNw1uf2A+9flfS8HBeqt3
Vt2rO0KlSOghWg4eOq0jXvVHu1PNV4vSiO0Y9xgNxcR0BcUIqsIvpzpYwORk+pCp
CuegZKktdLHsJPyrOfAhzbJNOjF1MM2Fg8ve+duMk/ylrQYI8Kc8SfR8EzNXZDsH
AbsjyIybOyIO0Qud6z0irH+hOynbEg==
=3T2c
-----END PGP SIGNATURE-----

--eti39NJJ1w8JEReO--

