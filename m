Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFEB36B90B
	for <virtio-fs@lists.linux.dev>; Thu, 20 Aug 2026 09:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787216441; cv=none; b=QbOKyRS1GttHezXX4xI14JMJyH8lx1y8sG/yywf1Qf0yVH1dEp/CTYEXSb0KiiJ9+DVaY0v6d1DJi1WD7pnSxi5lSiUJZMt/rSPshmURQJP7NReT3NCzl9k5kidyKdDJbZBp1zZai5eEb2CKfb6DBNhspBk0A1lCHExSxlp6e0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787216441; c=relaxed/simple;
	bh=bbDIEqNxtmZSOV6NoxRyP3QerCIe31d4iuNJ9uPaWRk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mWQ8lGZ5/UGPaX3rx1Tue7mSFYvJ7H5Y788H2NcfDgPoBuzaxJ3pHFJ/e3+kZJB2nIjIPQkUp1d2NBLElxeax4/QqC3tWuztBFQv1HSFnjs2hF3ALAQVRaTkhvxXSsZb+7ZHYzt3WOTYDPr1nnjp9GgBEO28Ne8L1QtzoUdPkcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QMAwic4r; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QMAwic4r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787216438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nzMGwljsMZ4U6CxcMqMO9az3lZ1eStsTxI29qdoslA4=;
	b=QMAwic4rW/c2gHVk1iu1rK9Hq6TzCxNCQrikyh4dJNgSrPP5RaF1WN51Uthm/s0j7Hex8w
	GJeEMtMS+0nXHGavnsYQJq0nHxoSZwSwXTvPzAw6Q+kfgY3PGOjJPGif2RrKM2u1lgt3DY
	WWL1ezYwhqxJiYo32eBzVHMs2nVIF3k=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584-iEy-tMaVPwyFGNo48zaQsQ-1; Thu,
 20 Aug 2026 05:00:29 -0400
X-MC-Unique: iEy-tMaVPwyFGNo48zaQsQ-1
X-Mimecast-MFC-AGG-ID: iEy-tMaVPwyFGNo48zaQsQ_1787216426
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 467AD1800651;
	Thu, 20 Aug 2026 09:00:25 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C38D21955F03;
	Thu, 20 Aug 2026 09:00:23 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 226D921E6920; Thu, 20 Aug 2026 11:00:21 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Connor Kite <connorkite@gmail.com>
Cc: qemu-devel@nongnu.org,  "Michael S. Tsirkin" <mst@redhat.com>,  Stefano
 Garzarella <sgarzare@redhat.com>,  Alex =?utf-8?Q?Benn=C3=A9e?=
 <alex.bennee@linaro.org>,
  Viresh Kumar <viresh.kumar@linaro.org>,  Gerd Hoffmann
 <kraxel@redhat.com>,  Mathieu Poirier <mathieu.poirier@linaro.org>,  Manos
 Pitsidianakis <manos.pitsidianakis@linaro.org>,  Raphael Norwitz
 <rnorwitz@nvidia.com>,  Kevin Wolf <kwolf@redhat.com>,  Hanna Reitz
 <hreitz@redhat.com>,  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>,
  Paolo Bonzini <pbonzini@redhat.com>,  Fam Zheng <fam@euphon.net>,  Stefan
 Hajnoczi <stefanha@redhat.com>,  Milan Zamazal <mzamazal@redhat.com>,
  Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,  Dmitry Osipenko
 <dmitry.osipenko@collabora.com>,  qemu-block@nongnu.org,
  virtio-fs@lists.linux.dev,  "Gonglei (Arei)" <arei.gonglei@huawei.com>,
  zhenwei pi <zhenwei.pi@linux.dev>,  Daniel P. =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eric Blake <eblake@redhat.com>,  Jason Wang
 <jasowangio@gmail.com>,  Peter Xu <peterx@redhat.com>,  Eugenio
 =?utf-8?Q?P=C3=A9rez?=
 <eperezma@redhat.com>,  Alyssa Ross <hi@alyssa.is>,  Demi Marie Obenour
 <demiobenour@gmail.com>,  20260817233147.2867623-1-connorkite@gmail.com
Subject: Re: [PATCH RFC v2 12/13] backends/cryptodev-vhost-user: add memory
 isolation bool
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-12-948aae960abb@gmail.com>
	(Connor Kite's message of "Mon, 17 Aug 2026 22:12:27 -0700")
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
	<20260817-vhost-user-isolated-memory-v2-12-948aae960abb@gmail.com>
Date: Thu, 20 Aug 2026 11:00:21 +0200
Message-ID: <87pkzd2ml6.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: t9nB9x_3J6xB8YF49VhAbqXAmTwiOD-99JDV4ZvbNf4_1787216426
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Connor Kite <connorkite@gmail.com> writes:

> Add a memory_isolation property to CryptoDevBackendVhostUser and
> add add it as an optional member of CryptodevVhostUserProperties
> in qapi.
>
> This is needed to be able to specify memory isolation for
> cryptodev-vhost-user objects, and the bool will eventually be
> passed to vhost_user_init() in a future patch.
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>

[...]

> diff --git a/qapi/qom.json b/qapi/qom.json
> index c55776af7d..1024027195 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -350,11 +350,17 @@
>  # @chardev: the name of a Unix domain socket character device that
>  #     connects to the vhost-user server
>  #
> +# @memory-isolation: disable direct access from vhost-user back-end
> +#     to guest memory.  The back-end will instead access data via
> +#     bounce buffers residing in the QEMU virtual address space.
> +#     (default: false) (Since 11.2)

We spell it "backend" elsewhere in doc comments.

Any guidance on when to enable it?

> +#
>  # Since: 2.12
>  ##
>  { 'struct': 'CryptodevVhostUserProperties',
>    'base': 'CryptodevBackendProperties',
> -  'data': { 'chardev': 'str' },
> +  'data': { 'chardev': 'str',
> +            '*memory-isolation': 'bool' },
>    'if': 'CONFIG_VHOST_CRYPTO' }
>  
>  ##

