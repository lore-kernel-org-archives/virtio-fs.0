Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3D837883B
	for <virtio-fs@lists.linux.dev>; Thu,  5 Mar 2026 09:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772702895; cv=none; b=ZU3YJoeZNBLfHF6mueUYlh/ikoYyE4HtxOn8ECZR53twqn11bHCf/ZKjE6haIOeIe+BjFd/a173cIsaLhQ3sYd65lE+L8bC96J9wi5OgJA1iq/FGfg9vT1O/SGXVt7UtPoxfi2yKY+5RoZcdWtoc643ZDxkZfvsA3+45o1tHApY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772702895; c=relaxed/simple;
	bh=ZNIa/S11i9MbhlssHiRcQ0E71rWBjOFsWAQAkYNXobs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nkdUVESjjCPXuLO+tEmpRcfMVr/I71n2l5zC1y4IQyi0zb9slCZ0xLRRrEJbxLialEjogzcA/xGx/3lBbTffTfpwsxZpSvAbxplumAVpW8cinxNXXKGl/5LDb+JrglmhHhTMl3dYe3SBlB99qyVSg7972KDYPHxLtQHIIZX7UD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=O+XYr/RX; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="O+XYr/RX"
Received: from mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:bf1f:0:640:c739:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 954F7C01AC;
	Thu, 05 Mar 2026 12:26:38 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:b93::1:1] (unknown [2a02:6bf:8080:b93::1:1])
	by mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id ZQlrnH0AmSw0-5Lhw77OP;
	Thu, 05 Mar 2026 12:26:37 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1772702798;
	bh=6ZPxBKZaYSYXP8qbttxkhUqsn/AfmNkW+VFAuugal2Q=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=O+XYr/RXCw5EUBA/XsVrudGcRrkscavtCqJQr1Igul1U8EkFflrIXcP9JOPX2XQpP
	 lYbbwg7H39yA/gtLmT/kC4736oGU/B8bjkl8wveBgZSkUEuL4moURH28WxqV+l2mpi
	 P8JZTzbLLizltvO6JF/YoRLLDpTT4/1QEmP9H0HY=
Authentication-Results: mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <6f641e2c-f645-4f0b-9953-c4c14b83bc42@yandex-team.ru>
Date: Thu, 5 Mar 2026 12:26:35 +0300
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] vhost-user: add skip_drain param to GET_VRING_BASE
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>, qemu-devel@nongnu.org
Cc: Raphael Norwitz <rnorwitz@nvidia.com>, virtio-fs@lists.linux.dev,
 Milan Zamazal <mzamazal@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 zhenwei pi <zhenwei.pi@linux.dev>, "Gonglei (Arei)"
 <arei.gonglei@huawei.com>, Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Stefano Garzarella
 <sgarzare@redhat.com>, Fam Zheng <fam@euphon.net>, qemu-block@nongnu.org
References: <20260224075055.863068-1-dtalexundeer@yandex-team.ru>
 <20260224075055.863068-3-dtalexundeer@yandex-team.ru>
Content-Language: en-US
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
In-Reply-To: <20260224075055.863068-3-dtalexundeer@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.02.26 10:50, Alexandr Moshkov wrote:
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
> Signed-off-by: Alexandr Moshkov<dtalexundeer@yandex-team.ru>

Let's split this commit, at least into two:

1. add additional vhost_dev_stop() parameter (most of this commit)

2. breaking changes for (not yet released) vhost-user protocol extension

-- 
Best regards,
Vladimir
