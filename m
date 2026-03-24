Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDFD4035C6
	for <virtio-fs@lists.linux.dev>; Tue, 24 Mar 2026 15:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774365044; cv=none; b=ZIaXtLoZcoilQEWHqxEkR3Eeo4Z0bpnQr3glMGcoLw4KHmdxl660JX2V+R8kt58LIyvAKpUn31ThD7iAv/buOmPQnx+KvA7oIwoJrjpZ4Z9ZO4r7qIqeQ7TZ4QfCivKtShuenhL6WOe10uW+T9aEaRkZYqtL8kZyBE/XhDXwP0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774365044; c=relaxed/simple;
	bh=VkkKEOWqjSCBPID2IegBi4imLDaV7hE+gY6W1Rg/iuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FuP5Wi6FbFFLVZeOa9NHzpJ1vz0B3pIXQ9t+6/DSMd/kJOkD+sbSortBhd8cpxXJAa4dRVXDLlniema3pLdh5yY+6TD1sYHNa8sLyERy1vtxd0qPXdUNq7V1Ico9OVm/U0H79EEs2yxy5f/U0UG5vc1ULn3zq6nuCFCK532z+14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=KcvD/eYL; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="KcvD/eYL"
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 67520C0213;
	Tue, 24 Mar 2026 18:10:35 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:46c::1:35] (unknown [2a02:6bf:8080:46c::1:35])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id XAVWnN0Am8c0-AGFGZt1g;
	Tue, 24 Mar 2026 18:10:34 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1774365034;
	bh=Wd27rvDAn7VnUebYXvticlxReM/MOvVNBaeUT6huU5c=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=KcvD/eYL68+myMlPiuGu52+/6U8iVovFUosjoH2JhioxCUts2XjJDAUssOzguBCT1
	 IpEqAKo1GY1PMazdyXd/pzwGXjHiI6EeL3MRQ7RjfHdSfbr4yzo8nq2hLFrN/noF2W
	 A3Okc9FffTD4yMW//Dvn1iKascb2+BVtBdtch4Ek=
Authentication-Results: mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <7316cea8-de57-423c-b617-05298a322534@yandex-team.ru>
Date: Tue, 24 Mar 2026 18:10:32 +0300
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] vhost-user-blk: move inflight_needed higher
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
 <20260311084728.751169-4-dtalexundeer@yandex-team.ru>
Content-Language: en-US
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
In-Reply-To: <20260311084728.751169-4-dtalexundeer@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.03.26 11:47, Alexandr Moshkov wrote:
> Will be used in future commits for adding skip_drain param
> 
> Signed-off-by: Alexandr Moshkov<dtalexundeer@yandex-team.ru>

Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>

-- 
Best regards,
Vladimir
