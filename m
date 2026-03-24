Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C29405AB2
	for <virtio-fs@lists.linux.dev>; Tue, 24 Mar 2026 15:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774364978; cv=none; b=Cc3Bj/AAl4vVKEW5r/mW0CerOyzgwZSIjFFJ/670Vy5UeIiN+gn/k4UEadhEg3XLKluRBhYas+XV0QUab6gEfk507gBlsE5fzXT4ulQZ9JRn3k2Pd6MksvsSQNGqH2s/c3M8g9y5qIYzTAEHdno4MSdIrST/sMXBAWoDoyNy5Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774364978; c=relaxed/simple;
	bh=wXRybVL2gW625AOEXqwM66l9edDAA5kpogQuDC4xLvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MNkZ8B2JMHJAr3K5QnOn+vLSVuZOkddVQvfbKUYrCEgIcuKW/Nrs954R0ECZ+awoW5oflF8qZ7I3lII8Uu670hDjSoG+dn2Vzzl8r0mpoEx8hv16DpZsAiPNjcR07w8koT9gYaNsU8GoJWjXfsDcmZNr8q+MISf4wv/3aQ5onEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=BWhYYd+7; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="BWhYYd+7"
Received: from mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:94a9:0:640:a3fa:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 28EA2808BB;
	Tue, 24 Mar 2026 18:09:25 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:46c::1:35] (unknown [2a02:6bf:8080:46c::1:35])
	by mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id M9VkXN0AYGk0-9GFcaTDs;
	Tue, 24 Mar 2026 18:09:24 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1774364964;
	bh=d4Igsfv4es+Y+pAjOwNhvMTRh0MCSjv/75osresmPTE=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=BWhYYd+7+WRntWC2GlaXcwpvz56JkgPege9J6tp+WH3Xc+CwYbMQQQxZZUbi1X/W0
	 D4ZRrMCA5TyV6eL1D/Sg2wY1TrxdvLR6io62IID/5diOZOiLPsMPosnLve5Nh1U09/
	 wxW/GhilTTEMf4jVShGQOV1tiK9TXiUjc2uMY8Fo=
Authentication-Results: mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <cbfbb464-cc7a-4753-9e4f-4dc6bda30b69@yandex-team.ru>
Date: Tue, 24 Mar 2026 18:09:22 +0300
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] vhost-user.rst: fix typo
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
 <20260311084728.751169-2-dtalexundeer@yandex-team.ru>
Content-Language: en-US
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
In-Reply-To: <20260311084728.751169-2-dtalexundeer@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.03.26 11:47, Alexandr Moshkov wrote:
> Signed-off-by: Alexandr Moshkov<dtalexundeer@yandex-team.ru>

Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>

(and you forget r-b by Stefan)

-- 
Best regards,
Vladimir
