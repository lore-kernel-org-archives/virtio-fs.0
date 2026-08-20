Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B512DECCB
	for <virtio-fs@lists.linux.dev>; Thu, 20 Aug 2026 09:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787216552; cv=none; b=GfLpXrP8O6buqrutPDlhiHvx2R32eTf7Zqj0UJ+V0eNyVTmc0be0tEnn9uSR41nIiHgbWp00V8/duDJuTHJG2+/ruYtr8QUQo9J015mNG+6cMHiO8vSTFSQFzKJDeNv8J9FYTbHOYHd3kDVJkx/dtE+psJG/zV29ori6DSRenU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787216552; c=relaxed/simple;
	bh=1dFwLWAwfGredqFuQBr4kWmExp323yovGM7OqLhApa0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tvOtW3ghDC/jby+3UVeGvXlREyrioM/AYPMCT5VfQzHn769jjs3a6YJilk4KUTfeTKNGgDBTsIoC5qcXhSIE3G2eauTb8rIqrOttxrDPgxUTHAxFDOVTROAJDOB99cyUjUZ58JAqcWua+8kSZtjiYejfvIwPDF3OrLgZEx2B/UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T+gYfOCm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T+gYfOCm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787216550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GMOvKqYz772f80GS5MjGp+n2WJ9885iZjVIwOTgYBRw=;
	b=T+gYfOCmHhVH40YFTkMNIXFtiL36+FW1Ryh4oW3YlpW8LaE9OowN6RRykiIOWCJiAnVNmi
	ARBFRmxCQcjQgOAlAFzCMCwps6LioeLcpBjLPnCfZeejzlXRaNRa/DT00VsenpMHs9nPCv
	RwaFgzC4pwBThpcJlY99dHYe43RfsoI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-Zqk86PbOORyeZZrGzQOhxA-1; Thu,
 20 Aug 2026 05:02:24 -0400
X-MC-Unique: Zqk86PbOORyeZZrGzQOhxA-1
X-Mimecast-MFC-AGG-ID: Zqk86PbOORyeZZrGzQOhxA_1787216542
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CBEA9195609F;
	Thu, 20 Aug 2026 09:02:20 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3D481955F03;
	Thu, 20 Aug 2026 09:02:19 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 88C2221E6920; Thu, 20 Aug 2026 11:02:17 +0200 (CEST)
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
Subject: Re: [PATCH RFC v2 13/13] net/vhost-user: add memory isolation
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-13-948aae960abb@gmail.com>
	(Connor Kite's message of "Mon, 17 Aug 2026 22:12:28 -0700")
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
	<20260817-vhost-user-isolated-memory-v2-13-948aae960abb@gmail.com>
Date: Thu, 20 Aug 2026 11:02:17 +0200
Message-ID: <87lda12mhy.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: kx0zdFVFLd0Ph2iIbbkWqi_X0OFGJ_bPN_9akqKbuEQ_1787216542
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Connor Kite <connorkite@gmail.com> writes:

> Add a memory-isolation property to NetdevPassOptions and
> NetDevVhostUserOptions in net.json.  This property will
> be used for vhost-user devices to disable access to guest
> memory from vhost-user backends.
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>

[...]

> diff --git a/qapi/net.json b/qapi/net.json
> index 1a6382825c..add7cb5408 100644
> --- a/qapi/net.json
> +++ b/qapi/net.json
> @@ -213,6 +213,9 @@
>  #
>  # @param: parameter to pass to passt command
>  #
> +# @memory-isolation: isolate guest memory from vhost-user back-end
> +#     (default: false) (Since 11.2)
> +#

Any guidance on when to enable it?

>  # Since: 10.1
>  ##
>  { 'struct': 'NetdevPasstOptions',
> @@ -250,7 +253,8 @@
>      '*ipv6':               'bool',
>      '*tcp-ports':          ['PasstPortForward'],
>      '*udp-ports':          ['PasstPortForward'],
> -    '*param':              ['PasstParameter'] },
> +    '*param':              ['PasstParameter'],
> +    '*memory-isolation':   'bool'},
>      'if': 'CONFIG_PASST' }
>  
>  ##
> @@ -685,13 +689,17 @@
>  # @queues: number of queues to be created for multiqueue vhost-user
>  #     (default: 1) (Since 2.5)
>  #
> +# @memory-isolation: isolate guest memory from vhost-user back-end
> +#     (default: false) (Since 11.2)

Likewise.

> +#
>  # Since: 2.1
>  ##
>  { 'struct': 'NetdevVhostUserOptions',
>    'data': {
> -    'chardev':        'str',
> -    '*vhostforce':    'bool',
> -    '*queues':        'int' } }
> +    'chardev':              'str',
> +    '*vhostforce':          'bool',
> +    '*queues':              'int',
> +    '*memory-isolation':    'bool' } }
>  
>  ##
>  # @NetdevVhostVDPAOptions:

