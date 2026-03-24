Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9289C405ADB
	for <virtio-fs@lists.linux.dev>; Tue, 24 Mar 2026 15:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774365957; cv=none; b=f6pddiL7CJdcqfIgfe9AiwxjrSWGI//omH05vGcAcT7yMoVniD8J8UNEQDpYkBef7cvGtg3z4JDh3Dky3KQKuwB5P1pmLjZJnpSb44Ze+rcwQtRtCAWbrvQVc3WOWVru+JSvPLMKV24eJFcJKNeqJFirSnwdFG/bu7UvQcuR6qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774365957; c=relaxed/simple;
	bh=0etydkVqfi2QIy2YtrWnUku7eYUetopsFwRMyGgtoCQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YVY6KjzXegctJoRrO55BJKAMNmIUfZgEFG0xBy7h06sHZeuPEdE2DpfHgumM+cIlIJXVO+U7cChJo4+blAlESDPQplcdFJ+Hsc03/1o4AsdnlCoMy0m5MPBr36eiykSk4Csj5/oHl2VWmvu78MaS++MXUOImKirMbUUzrU4UJC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=aixvlvPp; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="aixvlvPp"
Received: from mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:bf1f:0:640:c739:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 5A7D8806F9;
	Tue, 24 Mar 2026 18:25:50 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:46c::1:35] (unknown [2a02:6bf:8080:46c::1:35])
	by mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id lPV2SM0AT4Y0-P6gEYhK5;
	Tue, 24 Mar 2026 18:25:49 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1774365949;
	bh=8Q9hzLTv5KTWtrM9Y/3cmomsR9TE92suTczGS/fRjHQ=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=aixvlvPpF4FODQQ518jEPyZ9HhCV8F5JJohiM4UQmPTKnK/LhkBDqKrjRLRpFznig
	 CwwhLmanJe0AkBn8iJE9+kiaG35/vbeJktqU8IebIeCW6xvi7xnvR8BGNcHEg5XGe4
	 NvPdTwTz4pmzLNcFhzePAsnhFklI+IzIqHiqhozw=
Authentication-Results: mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <6c478bcc-dfc9-4d29-a92e-db0ec974b8db@yandex-team.ru>
Date: Tue, 24 Mar 2026 18:25:47 +0300
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] vhost-user: add skip_drain param to GET_VRING_BASE
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
 <20260311084728.751169-5-dtalexundeer@yandex-team.ru>
Content-Language: en-US
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
In-Reply-To: <20260311084728.751169-5-dtalexundeer@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.03.26 11:47, Alexandr Moshkov wrote:
> In case of migration of QEMU from the new version (where the
> inllight-migration parameter is present), to the old one (where it is
> absent) there is no way to disable this feature on the backend during
> runtime.
> 
> This commit slightly changes the semantics of the protocol feature
> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. Enabling this feature
> adds a new parameter for GET_VRING_BASE, which allows to control the
> drain in-flight requests on the backend.
> Thus, QEMU will be able to turn this feature on GET_VRING_BASE off and
> on anytime.
> 
> In vhost-user-blk use inflight_migration param to enable skip_drain to
> suspend in-flight I/O requests, and then migrate them throught inflight
> subsection.
> 
> Also now QEMU will always try to setup
> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT protocol featrue with
> backend. This will allow to use skip_drain parameter on GET_VRING_BASE
> message.
> 
> Signed-off-by: Alexandr Moshkov<dtalexundeer@yandex-team.ru>

Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>


Is it too late for 11.0, to fix protocol disadvantage we've added?

Or could it be fixed in 11.1?


-- 
Best regards,
Vladimir
