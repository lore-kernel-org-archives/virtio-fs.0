Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BCC3515D2
	for <virtio-fs@lists.linux.dev>; Fri, 24 Jul 2026 06:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784873212; cv=none; b=LRvNf7gckZ7+sUz50fZwB+COOIpwioHqYYRX8XGhe2PRPIWbdc5XUYZzY6KQw3HQ6isvETeA3fP3K6SeaFJppHVNMFn1lUeV++CnLiEIWbgNFN3hRhEeDKPx9Dj9d3IQhefCkoIGXM0X3QcbboGoRv1Dx2x0hZyWIg9ESSKpNnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784873212; c=relaxed/simple;
	bh=4dno0SUrBXa2HW/xJwuldiFVJN7M4XawhPbXfFXV6O4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=PSDuAKRZuEM1dX9V4fvEyH+qz7/gZpIJqVgGwCOpMarSoe9cwV9/7GDGaBjxx6knNJR9J2JHzGgBh0/EPBlkY+R+0PEwzRFPsLTso+gX+FyMYSjnZELIH8fxRku4h3UNagKUC8yHCdkJjucDtB+c7gDgDe1U06Ui5X2DVxu1TvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IFKJXeKP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IFKJXeKP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784873209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w9O6KyIWmVVPSWAdn3TWrQGghYaE/eWA8y4KU2yeK80=;
	b=IFKJXeKPFnHj7i0USZNmj7AULMp1tRO2OKvgrp4DP8Ci51el5O9p1XzrhOqhfNvap5TW03
	JtyN4in6Vf8+JGgqn2Emmk9zc0VejfBu17Aymbn7N51wJwixE6v3HCil8mT2gngepUngTX
	oscdeIqAK5kF3Eymm6/eUxEWiUABkS4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-5sbwfBJYPbyh3dkZPeYbrg-1; Fri,
 24 Jul 2026 02:06:45 -0400
X-MC-Unique: 5sbwfBJYPbyh3dkZPeYbrg-1
X-Mimecast-MFC-AGG-ID: 5sbwfBJYPbyh3dkZPeYbrg_1784873202
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3861319540E9;
	Fri, 24 Jul 2026 06:06:41 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 18FA21954221;
	Fri, 24 Jul 2026 06:06:38 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 5554521E6920; Fri, 24 Jul 2026 08:06:36 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Connor Kite <connorkite@gmail.com>
Cc: qemu-devel@nongnu.org,  "Michael S. Tsirkin" <mst@redhat.com>,  Stefano
 Garzarella <sgarzare@redhat.com>,  Alex =?utf-8?Q?Benn=C3=A9e?=
 <alex.bennee@linaro.org>,
  Viresh Kumar <viresh.kumar@linaro.org>,  Gerd Hoffmann
 <kraxel@redhat.com>,  Mathieu Poirier <mathieu.poirier@linaro.org>,  Manos
 Pitsidianakis <manos.pitsidianakis@linaro.org>,  Haixu Cui
 <quic_haixcui@quicinc.com>,  Raphael Norwitz <rnorwitz@nvidia.com>,  Kevin
 Wolf <kwolf@redhat.com>,  Hanna Reitz <hreitz@redhat.com>,  =?utf-8?Q?Mar?=
 =?utf-8?Q?c-Andr=C3=A9?=
 Lureau <marcandre.lureau@redhat.com>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Fam Zheng <fam@euphon.net>,  Stefan Hajnoczi
 <stefanha@redhat.com>,  Milan Zamazal <mzamazal@redhat.com>,  Akihiko
 Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,  Dmitry Osipenko
 <dmitry.osipenko@collabora.com>,  qemu-block@nongnu.org,
  virtio-fs@lists.linux.dev,  "Gonglei (Arei)" <arei.gonglei@huawei.com>,
  zhenwei pi <zhenwei.pi@linux.dev>,  Daniel P. =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eric Blake <eblake@redhat.com>,  Jason Wang
 <jasowangio@gmail.com>,  Peter Xu <peterx@redhat.com>,  Eugenio
 =?utf-8?Q?P=C3=A9rez?=
 <eperezma@redhat.com>,  Alyssa Ross <hi@alyssa.is>,  Demi Marie Obenour
 <demiobenour@gmail.com>
Subject: Re: [PATCH RFC 03/15] backends/cryptodev-vhost-user: add memory
 isolation bool
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-3-6b97c439eb28@gmail.com>
	(Connor Kite's message of "Thu, 23 Jul 2026 15:30:02 -0700")
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
	<20260723-vhost-user-isolated-memory-v1-3-6b97c439eb28@gmail.com>
Date: Fri, 24 Jul 2026 08:06:36 +0200
Message-ID: <87fr18diqb.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: k5SEYD6tiSD8xIxpfretG6Vk1Nlfo5ACdGU7kDIRktw_1784873202
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
> index c55776af7d..d7ca1b4203 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -350,11 +350,15 @@
>  # @chardev: the name of a Unix domain socket character device that
>  #     connects to the vhost-user server
>  #
> +# @memory-isolation: disables access from cryptodev to guest memory.
> +#     (default: false)

Want imperative mood and need "since", like this:

   # @memory-isolation: disable access from cryptodev to guest memory.
   #     (default: false) (since 11.2)

Pardon my ignorance...  What exactly is "cryptodev" here?  Is it code
running in another process?

Should the description answer my question?  Perhaps like this:

  # @memory-isolation: isolate guest memory.  Isolated guest memory
  #     cannot be accessed from uh, what exactly?

Fill in the blank.

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

