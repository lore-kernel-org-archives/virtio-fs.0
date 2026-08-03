Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0746F32AAA0
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 12:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760939; cv=none; b=esf63Vccgd0Cd2RZ0lCVlK05+XwCjKmOP0clQA5FBbrORWNMkZ7ir2MMe/kQkCjL5Q0SB3yIIgEl+ZB9b11UM/MHbw0BGKtU7IwC+UKfeMkbDIyOYhdcTJNPkQlkRT12HcH9BkKmIJnpnJFvkNiMvCFxqtljlRUks64xH14THOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760939; c=relaxed/simple;
	bh=BWneUHTTrzx8HgQQXIvwBY4qBT+6AoTsJm994F6Wh2A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sBTFkW6sAXdQZIS/xoXmLxbHqPRSB7H4+wcPvbU75xCJRwkCnNhpgOJGcU5dRKWlTNeXYcah3zHawL1On20e+eUzUQ72UOyxR4eJr9a7NGZXBh3rGbHjoANTbVt9i5TTT8hcVrn1PNgQCcjFhDsoViUSHDrwukYckrfz5kywLCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BT4ILBPS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BT4ILBPS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785760937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MD5L2RI6FXBTDArIKOWoWQi83VBLigF6a+njSU+nb0s=;
	b=BT4ILBPSOhGJRIZCWDuiGnSNgmyzTdC2ixoaM+Dbw2fhC+IM0LEvKWvL0VQPEkQoLp7JfG
	C0rCuL6kGa7QYkNqXIiYM1h0rXYa69CmGall0hXz3FW2ENf4dceYqYbBBrwxG4Acp3jFXD
	vpmWinKXLkqoJG/8zEjejXVcySPOn8Y=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-_6m0GKQNN4WF3gheWgDpGw-1; Mon, 03 Aug 2026 08:42:03 -0400
X-MC-Unique: _6m0GKQNN4WF3gheWgDpGw-1
X-Mimecast-MFC-AGG-ID: _6m0GKQNN4WF3gheWgDpGw_1785760922
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5aeb72bda2aso1797829e87.2
        for <virtio-fs@lists.linux.dev>; Mon, 03 Aug 2026 05:42:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785760922; x=1786365722;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MD5L2RI6FXBTDArIKOWoWQi83VBLigF6a+njSU+nb0s=;
        b=aJGvH7ti73qa+BDRC4YDYfmihdQJWn9jy2pbVcvn1VLC0qGD5cFQynh3PJlN0ScCjX
         +Jtq6B4DI8B1LLQCCKs8NPBUDU3ljic9oyvTjKgybIudynCq3TfReZ0qjFeenysLy/A0
         rSfiHQLU60WaYlavJX33ohn4shCVDeAYlUv11gnFOeyS0WQZMsLu6ujUIkxkQmO/4Vhu
         qQByDr9YeDq/vcDjl0llxVeYFTP+VpBmAjjpAEaveYQFZhNvQpI6qZWW+BjKD9f1jgGO
         rAyqMJ0B41nYE3nr80QC4kJctCGjTpzge4Q1NPXE8tJRhzTLLI/EVy9ljGeEq6rSBTZm
         ZGBw==
X-Forwarded-Encrypted: i=1; AHgh+Rr51SAq+QWereZtXSJ5uGq6AWIUi/2QF/Upx6AHqO7q742lXokSXWCjot95owrbNbAttv7UZ59Udg0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHyOjYHwebWK+Am3j3tMN2DN4M0evjVleU24RYkJQhYuIL1I3U
	glLksh843wamfh/yF+DYLmYTJpOYjDAuVQMCqgdxC0YAMOyI7fwFflN53Ojb2SRStHi+ojA3BZc
	3eZPRQXnnUebegI8wWkQ8+IGQ0u3edCUfPOpTzYR6EYSCbtXbhLYKsYB644bpqw==
X-Gm-Gg: AR+sD12oIePn3i3wCULC4s7ZEDNcZ9AKD6AMg0Yjd+U3k6EyfMoKCDuSe3CSPDlmmkH
	H18/29uhgF3GI+N42sPVoIlhDuhR9OFMZCbwdsdSQaWOmzw3ic+1pWt6BfwshHUJ7P1ezZ9EQNa
	b2qSpTVuCA+/gEYreVqQhyzCKCyLZ8j81XSJWECjINZR+ScM666FRWF53IbFWeSXfn5SJI2V/5t
	f8jBEzF4XSndTmeKtjCmejYZfSzT0p92NPEIVmvBrB8XtywLOZxP2IW0VdsYqS8fTMWWlQji9+R
	KnToijC0BZFERJVW8jD2+Fpi08N//AY03j8wGcNvNBULNs1xddfRYdYCLpbNloa0wkji2TWiN13
	ZQeLrb/uKTOtdNv2xuxQQ88rVrsU4YoJehGXBjo1pCL8TebIlYNzuVZbhGUmlAUC3MmvfvynxEA
	xiMQeVbRhr1LCYFysDiPdQrrefEbvmew==
X-Received: by 2002:ac2:4c53:0:b0:5b2:e956:b459 with SMTP id 2adb3069b0e04-5b2e956b575mr1077193e87.12.1785760922318;
        Mon, 03 Aug 2026 05:42:02 -0700 (PDT)
X-Received: by 2002:ac2:4c53:0:b0:5b2:e956:b459 with SMTP id 2adb3069b0e04-5b2e956b575mr1077168e87.12.1785760921925;
        Mon, 03 Aug 2026 05:42:01 -0700 (PDT)
Received: from ?IPV6:2003:cf:d73d:549a:e584:7c7b:2611:32a1? (p200300cfd73d549ae5847c7b261132a1.dip0.t-ipconnect.de. [2003:cf:d73d:549a:e584:7c7b:2611:32a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e245653csm2066246e87.72.2026.08.03.05.41.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 05:42:01 -0700 (PDT)
Message-ID: <39200a6f-8241-4033-ba7a-5c9bbbdc8ff1@redhat.com>
Date: Mon, 3 Aug 2026 14:41:57 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 08/15] hw/virtio/vhost-shadow-virtqueue: used handler
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
 <20260723-vhost-user-isolated-memory-v1-8-6b97c439eb28@gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-8-6b97c439eb28@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4HUZto-IqRK3sPux7ATQsfGKSM-ENQRJ2qCoYZlUa-w_1785760922
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 24.07.26 00:30, Connor Kite wrote:
> Adds a handler callback to shadow virtqueues in order to enable
> non-default processing of used vring elements from the device.
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-shadow-virtqueue.c |  4 ++++
>   hw/virtio/vhost-shadow-virtqueue.h | 14 ++++++++++++++
>   2 files changed, 18 insertions(+)

The avail handler replaces `vhost_svq_add_element()`. I find it a bit 
unintuitive that this handler does not replace `virtqueue_fill()`, i.e. 
that it is not a “mirror” of the avail handler; that the avail handler 
actually handles avail elements, whereas the used handler is “just” a 
callback on each used element. Was that intentional? (If so, I think the 
comment should be explicit about this choice.)

Hanna

