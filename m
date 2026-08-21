Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4693064B5
	for <virtio-fs@lists.linux.dev>; Fri, 21 Aug 2026 00:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787272770; cv=pass; b=DVuHYt9SIE4nBLOhEVdjGNdZlp67tjyVPadVPBV1kJGEP69kkx4kFQIm9Y10/c5mFU3iOzJjh8HRyTPwjbpbK4YuQMfcgvCTMk80HpsEha1iSNuzrWYD/UnpBCK/DmMyjpwfoUAxwSHMFZqgwoU07f4wtNDTTTUcYXV3Uxw3QGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787272770; c=relaxed/simple;
	bh=uHuNG1o27hYKH6QFwD4NZwJ6ePkRTFVHwR63LpDFRtM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gESnFnrdryCCrOA3Z0aMlCIwlt2jB2botbbinaoGD5Ow0mXs+tF8HnD2YrLTcoWlW7FQd9GxtAb6oJGWNogWvo4fEHFdfghlStcF8XN/6QLzQV8xTY548LD3EeZFS+yFOLAnYrkwhQjwHIdFXlOSTG9Aupbf5x+L7CRu/J1/9vQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wutbq442; arc=pass smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wutbq442"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e65e18969so30221085a.1
        for <virtio-fs@lists.linux.dev>; Thu, 20 Aug 2026 17:39:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787272767; cv=none;
        d=google.com; s=arc-20260327;
        b=j7OXrWnCFqxRNgWV8w9VL1al2CxwYaZGragcsYnlLcfiUDcEoWe6dxuFema2V9lBMd
         ldUn1b8sVQ2hM2HMJasdrrgVJHByo28obX7nbwjA83m01461PTndruGu9VIDEPNsATNa
         Ar13L/fkcPWSiqU7YQR8XvO1sYvORyXbs8G55ZX/6uDSzzCbnXVqa7hPlVt8UGEEIUdq
         Ayzt9VoXwybkc6cqP2vSY/kQ5h6tyZ0sePUUKEF9dTyodx+a2Hbc5dXi9LM28fHZKLh2
         R2ZRZQxvx8bR5JgyWVhU+cVFX2ZwCXdiUCQ8Ihtb7ZzFVsTZYMJK5wpPDKkm0g4mhxqA
         kPwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j70X1/99ULtJfEdnx9W5U/uMiQZCyEzvH771g5wfHE4=;
        fh=6DUSGryACDcidtJUwEcK3z9FiwzupAU2aO7QlFFVDIo=;
        b=KSGlvr94XzOaFLhBsZvQHyX4pYkR6mEHv1g1T5ICaeNIN045ayRD5j1jrD94zfjueV
         QwLH20L9vCorCrRzl5AWTjeNWAK6jGMr0czzaWBw1DTUUk910YomlU7KOXE4xcL6P3BY
         NiXim2Qm+cMgxRDYPKwPsiMHu/kY5zTx3A0mwRSJSO8Gi/gQzyhxosALnHLlHP3lcOLA
         JD80dc7hgUMXq23N26o8yzoOcBm+9vgcnWdpFLfIYd07Mkyb6h1rgILtOC4LONTvs34Z
         gMoetPb1Z0PrMXhG5+TU0xzHViQ5kRvV/odkphZkmtxPP8Vv68p3lKIkzaDQaT6l0QDj
         /DcA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787272767; x=1787877567; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j70X1/99ULtJfEdnx9W5U/uMiQZCyEzvH771g5wfHE4=;
        b=Wutbq442HV9w3Y5mXDJD0PTz522Hr17kf9GTp5K90YMBIFs634L59COhCRphV8ZQSe
         +2q4XmMYshRYsIZBS5yHnW2zwCTunz0ynaRCr8o0GiEdp819+pKqIRf2emInffaTrTyU
         MDK1wGKvpCIdrORdHY+HXTM4gkNN1oaPzyNdxxEDh3LvRehSn18nwndVFSkCnoAIPiXi
         1jBA8Axgyn/lb4hvwKaWKS2mzyDmziGCswgrhh8CEFpnCoFl0kRpZB/UN+iTGhGaKEsW
         zA0jYciQXvFe0VixPSDfxB4WmPc0x4hkmMyJwQGhuNuVli7PyJ5NledAjAfvLLjZM37y
         t7og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787272767; x=1787877567;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j70X1/99ULtJfEdnx9W5U/uMiQZCyEzvH771g5wfHE4=;
        b=tHGSfWE8AaF7seqEkV1ArvPwrMQZDV6VLx0m3PrWk9NZMrN42gjfIU02QMaS9WYEaL
         9/FMV9Ll9zvefMJfgMD0hU9GoF7rXNcC8s8MtuQCRfLv5RKiMR6oYmNc7dsCZZHBlhKY
         qnmY6YQ6B8o9I4F0FwHch4T/XhyOWucqSQ12R5wTXsct4LKA5oImng483c/7lmiHTxjC
         MNpKvvOloZard7FE8sOXOhAOe0KOn3z67xO+VXGN1DAOkxRXWeCrZQY2JhT0CPUc718Z
         mkSPp5CSW6C9q3yVjxpFnx/lhmYKT9GebLknS/PP2GOafmwrB5q2Sugvjsh+9O0GoFEn
         fFEA==
X-Forwarded-Encrypted: i=1; AHgh+RqhlBeB0nu4J9JV5FwPhmGLqePPfDtaOe50kRv80/DZpLTQypX/myvoDN0yMTD1s4tEN9RzqH8N8X4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzf/Pc/KtGmd+iv/7cK/8BpkCqH0U+J4I4PQPaYbEiF5pd1A+Nq
	43sXAphT8S/cs1Ji9mjrJOSm2O8d1jRCNiIIAyjchZQhCb+c496f8QEWNF7JjxJMrM4sy0XA6GE
	EIXuIK7iskDb/f8h/Rfy6gIjmp2QC3uY=
X-Gm-Gg: AR+sD13EkRyUaK+175s1nmo/mU7fvT/hHJtG0uXTJQbrH/vGA5uQtTPfAJBPCAiOK0d
	lQ+9U5GX1cXq/MZjSsSKRZrZcnuyitXb2YB2aEXaE4d2Ep6rorUWSqBAAMSJLhczrO8+yVU4cli
	fVC9PUK5exDeSz9AxsDXqaB5mh9t3XYk8czQCNvOei/33bXXImRdYd31jI7xATHChN/Tb7fop/s
	nT5rGSK7yBYXAsTTp/HuyJwFwZkFWYCtdLRyhPEVPjP6eM99IsI2UJ/ft+f+7b2kQR9GZYT/ULA
	5/2sZxYAJ9mb1B2e1XK10b2WW+r3d8B8lbWk20cUy1EITbNRqdR+B/uSL7taib8x7pTiszT1h9H
	b/es=
X-Received: by 2002:a05:620a:600a:b0:92e:e601:d238 with SMTP id
 af79cd13be357-9373978e84emr205763185a.10.1787272767594; Thu, 20 Aug 2026
 17:39:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
 <20260817-vhost-user-isolated-memory-v2-13-948aae960abb@gmail.com> <87lda12mhy.fsf@pond.sub.org>
In-Reply-To: <87lda12mhy.fsf@pond.sub.org>
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 20 Aug 2026 17:39:15 -0700
X-Gm-Features: AcwNN1WrRaBcGhG63PkCW5nddEDBgRPe97ID1cUOrGwzNYdpOnePhPHAXOe4_q4
Message-ID: <CA+spn3qK+n+buANnmkT6J8Yu4ZbwS_CqRbisE1uOmNsn1835iw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 13/13] net/vhost-user: add memory isolation
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Jason Wang <jasowangio@gmail.com>, Peter Xu <peterx@redhat.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2026 at 2:02=E2=80=AFAM Markus Armbruster <armbru@redhat.co=
m> wrote:
>
>
> Any guidance on when to enable it?
>
...

> Likewise.
>

In both cases, you would enable this for added security.  There's
obviously a performance hit, but it prevents a potentially misbehaving
vhost-user backend from reading or modifying undesired portions of
guest memory, since data transfer occurs wholly via bounce buffers.
This may be more useful in the generic netdev vhost user case than it
is with the passt version, but the goal is for the mode to be
accessible for any vhost-user device.

Do you think guidance is needed here in net.json?  I was thinking
that, if isolation-mode gets to a point of being merged, then
information like this would make sense somewhere in the online
documentation, but I'm happy to add something here as well.  I was
just trying to be similarly short and to-the-point as the other option
descriptions for these structs.

Thanks!
Connor
