Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FBD7082D
	for <virtio-fs@lists.linux.dev>; Tue, 24 Mar 2026 15:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774365008; cv=none; b=FBlXP9d5oHgWuWUiNM+SNgyGLMCLwxiuaua67r1egrtuwEA+Opn4pwRxKLCBV5+DkQ6c6LFjhm+3QIxJn6iJoPTweB2aEX+xHrqkO+FXBbP/8chkfSgfzV/Xwz5jUxuSE/m5W0qWlGcIUWOpxrWV9BRZwjrV0OKuaRUSRhhOMO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774365008; c=relaxed/simple;
	bh=lQQV7eObJKUIj1X1i/MRq00/p9Li+D508s5K2zzK2MM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pMNWHpDQOZnq8xuVyWMs9Ml+Vthrh+9npdE7dC4eCitaxLk9WmhcsChMjaIPWTEiwMqVQU9bWevLLkyUiAgJnkzmAGjxfh62tia7cUGuzhgYE69MnGTRxTaGIcy+CUNgLlTemXjqLMEJa0gpP00FQktBR+hyCxmXuKT+morLFBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=Z2EtYo0x; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="Z2EtYo0x"
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:fa2:0:640:41ee:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 90DF280765;
	Tue, 24 Mar 2026 18:09:57 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:46c::1:35] (unknown [2a02:6bf:8080:46c::1:35])
	by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id s9V1AO0Aq8c0-HzkvMfr0;
	Tue, 24 Mar 2026 18:09:57 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1774364997;
	bh=5xLTA+UEADKvxsr2P1ihdURInult42bmMBZiH7Rjw1M=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=Z2EtYo0xvT6FbRkg1eUbQHBfEtv6n9I0ejX3CU+B4TiMxYJxczTvQ/dpDARRFcQJt
	 Ow7M6DHYyEWmFQ65uFeSzbGyWz5HERi5T9S0SuMEPBWbHFn82mDTaomCkK5anJfYtN
	 Sl33/K162uqsF7204N9R0WZPcmcr0YCQH0B1VUBA=
Authentication-Results: mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <7610d8a3-f6a4-4b68-90f3-ac22ff049d94@yandex-team.ru>
Date: Tue, 24 Mar 2026 18:09:54 +0300
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] vhost-user: add skip_drain param to
 do_vhost_virtqueue_stop
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>, qemu-devel@nongnu.org
Cc: virtio-fs@lists.linux.dev, zhenwei pi <zhenwei.pi@linux.dev>,
 Hanna Reitz <hreitz@redhat.com>,
 "yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
 "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 Raphael Norwitz <rnorwitz@nvidia.com>, Milan Zamazal <mzamazal@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Jason Wang <jasowang@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-block@nongnu.org, Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Fam Zheng <fam@euphon.net>,
 Kevin Wolf <kwolf@redhat.com>
References: <20260311084728.751169-1-dtalexundeer@yandex-team.ru>
 <20260311084728.751169-3-dtalexundeer@yandex-team.ru>
Content-Language: en-US
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
In-Reply-To: <20260311084728.751169-3-dtalexundeer@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.03.26 11:47, Alexandr Moshkov wrote:
> Will be used in future commit for adding this param to GET_VRING_BASE
> 
> Signed-off-by: Alexandr Moshkov<dtalexundeer@yandex-team.ru>

Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>

-- 
Best regards,
Vladimir
