Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B174388E75
	for <virtio-fs@lists.linux.dev>; Tue,  3 Mar 2026 08:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772527523; cv=none; b=KO7ChutUG0uctEK9VsjDGoZRslXP0jJ9zQLrQeXEc5qrMvGxm5Mh02L1QXUvS4+qcuDrpHuu1lb/CRBpGnIZTORWK7Qn6ptkgDchXsIXKdjm2zR7tiMw1V/NACOPIK3sQzN7bWSMt8w0IvjwPNhLw/ikA9hbqyXYyxut76kQnSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772527523; c=relaxed/simple;
	bh=rMnL4MFjahoB+iNkk+tBwdJ2rPhVqGmxq21W+J1OKLk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uL7kS9snE7BtZUwYCNFer3KtMKeT9MLPtCJQuVC9+7cqlYOJ0cFKEWcE5ASTDuPz71Wfe/rfMZdDvpBDbrB2+1PEiMUc4EmKMWz8C+dLuKjzYg6w45on/hBaxAxLctkWFz/wxrPfWhOefOd1bseHDhokublIrkSN1kU9mvMCyl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=BQocEVor; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="BQocEVor"
Received: from mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net [IPv6:2a02:6b8:c37:8aa5:0:640:e6ae:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 0E67C807BE;
	Tue, 03 Mar 2026 11:45:10 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:d82::1:b] (unknown [2a02:6bf:8080:d82::1:b])
	by mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 6jieV00Ag8c0-KfxgldtG;
	Tue, 03 Mar 2026 11:45:09 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1772527509;
	bh=NvQ34poYzdQskGMUHMFU+EJW3oMU8eYoGNq/ZT7RaPI=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=BQocEVorc8+8BHtNjaDNag3BmJxc8TuZY8BrRuNeFrU+49XMZYoEB1SKhTZvHL7Xf
	 pgyds2mznDBVBPr35sUpWgxfTeCA4fhvDcl/zy1wBZyd1XnS3q+iQlRobc+kiI4IY+
	 Yd8xTzy84oR9Cdu1lTSHyqUo2wAL8d2h0vriZfAY=
Authentication-Results: mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <d16021a0-3994-4ab7-9de4-2eb7a8eed30b@yandex-team.ru>
Date: Tue, 3 Mar 2026 11:45:06 +0300
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] vhost-user: add skip_drain param to GET_VRING_BASE
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>,
 Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, Raphael Norwitz <rnorwitz@nvidia.com>,
 virtio-fs@lists.linux.dev, Milan Zamazal <mzamazal@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 zhenwei pi <zhenwei.pi@linux.dev>, "Gonglei (Arei)"
 <arei.gonglei@huawei.com>, Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Stefano Garzarella
 <sgarzare@redhat.com>, Fam Zheng <fam@euphon.net>, qemu-block@nongnu.org
References: <20260224075055.863068-1-dtalexundeer@yandex-team.ru>
 <20260224075055.863068-3-dtalexundeer@yandex-team.ru>
 <20260301233406.GA8465@fedora>
 <121fea54-0041-4004-aa4f-3a402da8169e@yandex-team.ru>
Content-Language: en-US
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
In-Reply-To: <121fea54-0041-4004-aa4f-3a402da8169e@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02.03.26 10:12, Alexandr Moshkov wrote:
> It seemed to me to be the more correct solution, because it took a little time for someone

Moreover, it's not yet released.

-- 
Best regards,
Vladimir
