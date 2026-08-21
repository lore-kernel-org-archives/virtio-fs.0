Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1023C4B64
	for <virtio-fs@lists.linux.dev>; Fri, 21 Aug 2026 05:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787291683; cv=none; b=THhcW7NUtZtlzh0CNJjSFLKPgvAfwjPxa9UgT4/D0c5eFPU1eF77eA6v+ey989mEqEq9a2E+QiY6cP1sOSsxCY3KSh0JembJk0kz6j1yUKsWnZRwCUrsDHeazYZILjNoXLz8QCyemk1/zDRdPZQLQzICnx/ga8v2Y8PZGi7RbeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787291683; c=relaxed/simple;
	bh=ItJ4vmpzzan0xAq/Q5wdKW9vMt0OMXHAe5gMUH4m44M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=IwK4Zu0RT4Dy2KDrQ/w2fD27aicFr6vCfS5x4o3FxqW6pTrKbp7EGFObi7cAqGMBqHFCPfNmjkVKphLsQCo/DCw8KCkFdPkQro8J6kfd45kIZT0GUO50G+eaVS/Y/5HpTcmv25uZ3bPTM9HKv0fxCwE3Sq4BPNqf/fgSL+VtIZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JqXUY/oW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JqXUY/oW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787291680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IITfrQYVQZTRWeGyLUAzKTecmtJHIaQ1eqmBG4Gip/I=;
	b=JqXUY/oWUhspe3hljER6AlRAjNkpfbGYeZGK6I4GlPa977z8rrpeP3BCMZ5V8+eEdcEYR0
	IgZLQj6dFF8nrTqLfb1mkbu5I/IZ3Hnj5s40hHR4X6H5pw2EuxXWeHXcNiekdbCcsQgzve
	TPqf1hCCoFLDeqxQuW6DUqnu295yj9Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-45-XxR4cDKLMhaZoBaEXWyhVw-1; Fri,
 21 Aug 2026 01:54:34 -0400
X-MC-Unique: XxR4cDKLMhaZoBaEXWyhVw-1
X-Mimecast-MFC-AGG-ID: XxR4cDKLMhaZoBaEXWyhVw_1787291672
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BBC3C195609D;
	Fri, 21 Aug 2026 05:54:30 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56CA41955F03;
	Fri, 21 Aug 2026 05:54:29 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id A0A9421E6920; Fri, 21 Aug 2026 07:54:26 +0200 (CEST)
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
 <demiobenour@gmail.com>
Subject: Re: [PATCH RFC v2 13/13] net/vhost-user: add memory isolation
In-Reply-To: <CA+spn3qK+n+buANnmkT6J8Yu4ZbwS_CqRbisE1uOmNsn1835iw@mail.gmail.com>
	(Connor Kite's message of "Thu, 20 Aug 2026 17:39:15 -0700")
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
	<20260817-vhost-user-isolated-memory-v2-13-948aae960abb@gmail.com>
	<87lda12mhy.fsf@pond.sub.org>
	<CA+spn3qK+n+buANnmkT6J8Yu4ZbwS_CqRbisE1uOmNsn1835iw@mail.gmail.com>
Date: Fri, 21 Aug 2026 07:54:26 +0200
Message-ID: <87lda010j1.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: -mZ4Kfj0KPA-9qicmuyxKf7LzLvH9Ax2SKPQaodTN6M_1787291672
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Connor Kite <connorkite@gmail.com> writes:

> On Thu, Aug 20, 2026 at 2:02=E2=80=AFAM Markus Armbruster <armbru@redhat.=
com> wrote:
>>
>>
>> Any guidance on when to enable it?
>>
> ...
>
>> Likewise.
>>
>
> In both cases, you would enable this for added security.  There's
> obviously a performance hit, but it prevents a potentially misbehaving
> vhost-user backend from reading or modifying undesired portions of
> guest memory, since data transfer occurs wholly via bounce buffers.
> This may be more useful in the generic netdev vhost user case than it
> is with the passt version, but the goal is for the mode to be
> accessible for any vhost-user device.

Work this into the commit message, please.

> Do you think guidance is needed here in net.json?  I was thinking
> that, if isolation-mode gets to a point of being merged, then
> information like this would make sense somewhere in the online
> documentation, but I'm happy to add something here as well.  I was
> just trying to be similarly short and to-the-point as the other option
> descriptions for these structs.

I think it needs to be somewhere in the user documentation.  We have so
many configuration options, and so little guidance on what to do with
them.

The doc comments in the QAPI schema are reference documentation (they go
into the "QEMU QMP Reference Manual").  Reference documentation should
be concise and to the point.  When you have more useful things to say
than fit there, you need to find nother place, and maybe link to it from
the reference docs.

I suggest to try adding brief guidance to the doc comment, and then we
see how we feel about it.

