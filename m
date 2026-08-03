Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823FD32AAA0
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 12:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785761325; cv=none; b=KljGblB4wT8uaxvAft9Q/w9Wf2hIKvhUdFIekGSjRecMcE46rbelmAOX7+q8fZUj0D9GrMXxNxlS7jg+r+1uFd/goC97C7oB6eIjaGNaw6KMX84YcOzNSseyuI9CInjWng+LI8ZjAfKyepZoYoRQf2b30caesHk2WqWvjG20GOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785761325; c=relaxed/simple;
	bh=LahwUC7y1uwUNXOYT8iCNl4+8oIPeqA47b1n8edCeM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dlRvkYnjezZ/CuVqo+50YB3xDibxPnW6Pd+Yg02vdTLtNBZ6Fopz7O7JGCmr82BLZgsc2fVS0YdctTSYndti1uOFVol+Vd7UWFs8Goo4Pz1rNwg9FQTxvuZ0/fuAANEKDUymfwTTbJLEKtLRXkswbkmRmtRaDTmpP7bj4orvU3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ba0PWXqM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ba0PWXqM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785761323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EylLULFFNIyW9QFwnCcRwYfOQ+N8tY2o7WCX2WWXMfM=;
	b=Ba0PWXqMxbaBVnELlnWcj0orIzZHjRislfbszsc/cs/j7NkCBZfPmAnsSESX7m64gpWOc1
	IjidcRVTOd+DvP7Xwn9OgpSCGw5OEZ6n5yAo419lljvp6ZUordMNPWUYkFBUBUtlxIP81G
	Oc6yVdV+tychfkz7bcHqCgHTLWFHSU4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-ssURRzHlOVaftoPjlKK7Ag-1; Mon, 03 Aug 2026 08:48:39 -0400
X-MC-Unique: ssURRzHlOVaftoPjlKK7Ag-1
X-Mimecast-MFC-AGG-ID: ssURRzHlOVaftoPjlKK7Ag_1785761318
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47f90dbaf84so3161268f8f.1
        for <virtio-fs@lists.linux.dev>; Mon, 03 Aug 2026 05:48:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785761318; x=1786366118;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EylLULFFNIyW9QFwnCcRwYfOQ+N8tY2o7WCX2WWXMfM=;
        b=fueeJTnERTGrFC6Bqyp1Z9zKRLohYHdNCS1KlgP70vnyh+X3OIVOVdjdUFOkonuu/M
         fsUQtvoJ+UiLBWOXT3ndugZjZv+o8/I6O4F5BOkXsbZ+sm8kb/0grh4V1YIh8S0z8A6z
         5/y1yRvH/vdd7sU+b+jF9d4NQIhBNAVQwXMUC9EM9IDDrsExZf8w17LC/KHjA3q5/2Qs
         i6diRe3kKvoVdKEdaqXXiXu3zmj8zQkHxZjulKpiZVVS8NDHCDRoJ4w7hPpqO9AqZLT9
         0vGa2TSCIn59nIert8JR4N6tO4Z8MQhUl9aiAtuAzy9QEwchjc15EJNUPiA3VQ6aTWXI
         ecZQ==
X-Forwarded-Encrypted: i=1; AHgh+RpU/STeLy4XkfwsqOndEFaXrw2iva97WTIlVh9PjnFFoIKpqMIANoZFaBDVu5ck0GTDvY6K7zprfNE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx62vgYcno2UhjL2vfuUzBuCA10AfZpA39s10h9xGr/WaEmEj79
	h5+VNSbEia379W/6ESeLgCNQzd0L5PGHS48ufqnS7gClHXFIrwakreNJ9cLFtfkN+wbp7+eWYkU
	GF4Ks/oL13SrDXhjN4f17EPZUh975HV3VDr1iFdJi5CdtjV3C9TDqOEBn/iLaOg==
X-Gm-Gg: AR+sD10qe/lR0fupECvWmKL0/TgYdhPpx9fSGlw9TrghzQfbd6kTVYmdeIASQvlxDVX
	Jq+CIzeY8/b7/gnGuJeN+C44oMvz66Htc+14TKpXQtpAZuQzjUvsrOLf+xHxZRcjkhrZMJHCqSH
	/Gu8zNqxb45Pa0mn4jR+CC+zeMVBSZt5dEzfJ785GnOPGxLxSKel7O0e8ti8JxCOUd6Zw/TNziY
	j+RzF24BUIi6J7VBop6e1TrLpGo6pupFBaXcGuP2a/wI4SLd5hT3dJiFZc0BC+AU5XunqWYcGHU
	7pi7yEdMdbacWprkWups6eYpi+IxFZdHsFDXvW58FWb6dE6Bwylu0EFPRjx17muW+kjFHWy547+
	Stc4ZMnz2Fj1glzjAs6pSx1OcXmbTcL7fWg+7ABOP6jA8cG3RFwtidDCR4NCTtwG8JA12/92o5O
	Rg8de7AMPVFkdcvXXvRUj6jMpskaRZfQ==
X-Received: by 2002:a05:6000:2c10:b0:47f:7e7d:eb0 with SMTP id ffacd0b85a97d-47fd72a8788mr24185964f8f.19.1785761317868;
        Mon, 03 Aug 2026 05:48:37 -0700 (PDT)
X-Received: by 2002:a05:6000:2c10:b0:47f:7e7d:eb0 with SMTP id ffacd0b85a97d-47fd72a8788mr24185894f8f.19.1785761317540;
        Mon, 03 Aug 2026 05:48:37 -0700 (PDT)
Received: from ?IPV6:2003:cf:d73d:549a:e584:7c7b:2611:32a1? (p200300cfd73d549ae5847c7b261132a1.dip0.t-ipconnect.de. [2003:cf:d73d:549a:e584:7c7b:2611:32a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd4068fb7sm33919027f8f.0.2026.08.03.05.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 05:48:36 -0700 (PDT)
Message-ID: <3fa5a8c6-a803-4b28-a45c-26a71dd99b7d@redhat.com>
Date: Mon, 3 Aug 2026 14:48:34 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 09/15] hw/virtio/vhost-shadow-virtqueue: specified
 vring placement
To: Connor Kite <connorkite@gmail.com>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 Haixu Cui <quic_haixcui@quicinc.com>, Raphael Norwitz <rnorwitz@nvidia.com>,
 Kevin Wolf <kwolf@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
 Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org,
 virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Alyssa Ross <hi@alyssa.is>,
 Demi Marie Obenour <demiobenour@gmail.com>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-9-6b97c439eb28@gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-9-6b97c439eb28@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: spOM-D4TDEGjjH3ywZXcediaYMK0Mlb9_jnO7dG01sU_1785761318
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.07.26 00:30, Connor Kite wrote:
> By default svq vrings are placed in an anonymous memory map. As svqs
> will be leveraged to enable memory isolation in vhost-user, it is useful
> to be able to place the vrings in a shared isolation memory region.
>
> Adds the option to specify vring placement by providing a vring base
> address before starting the svq.
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-shadow-virtqueue.c | 22 +++++++++++++++-------
>   hw/virtio/vhost-shadow-virtqueue.h |  3 +++
>   2 files changed, 18 insertions(+), 7 deletions(-)

I would go beyond Stefan and say that I do really ask for explicit 
bounds checking on the area.

Besides that, `vhost_svq_stop()` still always calls `munmap()` on `desc` 
and `used` and that must absolutely not be done in case a fixed location 
was provided.

Also, it would be nicer to have a function to set the base address 
instead of having to modify the svq object directly.

Hanna

