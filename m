Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A3C2D0C84
	for <virtio-fs@lists.linux.dev>; Mon,  4 May 2026 06:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777877785; cv=none; b=lK9ncoe6VMPc1or/1k9Q/f03Fo+TyaJRr/tfBaV0mvhKkgMm/o20sunjMiRn5GYUXaAjftxGrpTg4O1twpPX+dua+PhEdBRvZdA6VnuOf+ln4fMfHp0fZHR3oUX/1RMZiCeuKsE//p/ixvXUO9VpVDH/N9qtRSQA6Uug2XE2/V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777877785; c=relaxed/simple;
	bh=/2XxZIZ/r8KdHjV76OiIeTEtwvvFT3V9FAfsK0FPDI8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=hRs21jtlc1mJ8SivWvomwPV0mvZhBGzqcdhjnhlf9dNjgdpA9M/xaENqokRq6dfdYIjzxU0E2zPp6souVZ/LJHejiuZ8yKQ9DKyV36IqJYFXQ8kS0n73MFEpGeZns+oxrAYY80/XZoK7Sxbj0LGANrfXrn4V/YbT2uraZNpHVik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=FB6IQ/Ee; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="FB6IQ/Ee"
Received: from mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:bf1f:0:640:c739:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 970678065B;
	Mon, 04 May 2026 09:56:11 +0300 (MSK)
Received: from [IPV6:2a02:6bf:803e:400:d600:d90c:cd5e:5e86] (unknown [2a02:6bf:803e:400:d600:d90c:cd5e:5e86])
	by mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (smtpcorp) with ESMTPSA id 7uYwjA1MACg0-AVBqHM9I;
	Mon, 04 May 2026 09:56:10 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1777877770;
	bh=jkgu9N0mNLW6MJdDs8iN0awIQ6XcKC2pPGX9+4cPcZI=;
	h=In-Reply-To:Cc:Date:References:To:From:Subject:Message-ID;
	b=FB6IQ/EejOLDggc+IyTW8qeuCyK8beb+S/ruVNIa4jVOEZK78ZSazXxZ21raBgOdY
	 Tz00YnCpB+m5FnvE8gwjb5OBLYH0uydH2cs/GBTX9tx1aNSlhcZqeA6flL54rUcONG
	 k3NP6dTPn6uRh1btrvegq9F1DhFb1jksmwjuuaQI=
Authentication-Results: mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <165fbcde-75ac-47d8-a2d8-5abb75f71478@yandex-team.ru>
Date: Mon, 4 May 2026 11:56:07 +0500
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] vhost-user-blk: fix compatibility with older qemu
 versions
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Milan Zamazal <mzamazal@redhat.com>, Raphael Norwitz <rnorwitz@nvidia.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jason Wang <jasowang@redhat.com>,
 qemu-block@nongnu.org, Fam Zheng <fam@euphon.net>,
 zhenwei pi <zhenwei.pi@linux.dev>, Hanna Reitz <hreitz@redhat.com>,
 virtio-fs@lists.linux.dev, Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, "yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
 Kevin Wolf <kwolf@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
References: <20260330095226.158386-1-dtalexundeer@yandex-team.ru>
 <250aad49-9494-47d3-b0e1-2e4eec490ca3@yandex-team.ru>
 <6b959317-6690-4978-87e6-e959dca6649b@yandex-team.ru>
Content-Language: en-US
In-Reply-To: <6b959317-6690-4978-87e6-e959dca6649b@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Ping :)

On 4/20/26 16:11, Alexandr Moshkov wrote:
> Hello! Another gentle ping :)
>
> On 4/6/26 14:51, Alexandr Moshkov wrote:
>> Ping :)
>>
>> On 3/30/26 14:52, Alexandr Moshkov wrote:
>>> v2 -> v3:
>>> - fix complile problems
>>> - add assert check in do_vhost_virtio_stop
>>> - make inflight-migration property mutable
>>>
>>> v1 -> v2:
>>> - reorganize commits: make refactor commits first, then core 
>>> semantic change
>>> - add additional pre_save check for inflight migration possibility
>>>
>>> ---
>>>
>>> This is a small continuation of my series about inflight migration 
>>> for vhost-user-blk.
>>>
>>> This series is designed to solve the problem of compatibility with 
>>> older versions of qemu, where this feature has not yet been 
>>> introduced (for example, if we want to downgrade versions due to 
>>> some problems).
>>>
>>> In the current version for vhost-user-blk, this feature is enabled 
>>> using the parameter and further migration of the inflight region 
>>> will depend on whether the vhost-user has accepted the new protocol 
>>> feature or not. This creates an inconvenient dependency, because 
>>> there is no way to disable this feature without reconnecting to the 
>>> backend.
>>> This series slightly changes the semantics of the introduced 
>>> protocol feature VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. 
>>> Enabling this feature adds a new parameter for GET_VRING_BASE 
>>> message - skip_drain, which allows to control drain in-flight 
>>> requests on the backend.
>>>
>>> Thus, user can enable or disable inflight-migration param for 
>>> vhost-user-blk to maintain compatibility with older versions of QEMU.
>>>
>>> Alexandr Moshkov (5):
>>>    vhost-user.rst: fix typo
>>>    vhost-user-blk: make inflight-migration prop mutable
>>>    vhost-user: add skip_drain param to do_vhost_virtqueue_stop
>>>    vhost-user-blk: move inflight_needed higher
>>>    vhost-user: add skip_drain param to GET_VRING_BASE
>>>
>>>   backends/cryptodev-vhost.c     |  2 +-
>>>   backends/vhost-user.c          |  2 +-
>>>   docs/interop/vhost-user.rst    |  8 +++----
>>>   hw/block/vhost-user-blk.c      | 43 
>>> +++++++++++++++++++++++++++-------
>>>   hw/net/vhost_net.c             |  9 +++----
>>>   hw/scsi/vhost-scsi-common.c    |  2 +-
>>>   hw/virtio/vdpa-dev.c           |  2 +-
>>>   hw/virtio/vhost-user-base.c    |  2 +-
>>>   hw/virtio/vhost-user-fs.c      |  2 +-
>>>   hw/virtio/vhost-user-scmi.c    |  2 +-
>>>   hw/virtio/vhost-user.c         |  3 +--
>>>   hw/virtio/vhost-vsock-common.c |  2 +-
>>>   hw/virtio/vhost.c              | 29 ++++++++++++++++-------
>>>   include/hw/virtio/vhost-user.h |  1 -
>>>   include/hw/virtio/vhost.h      |  7 ++++--
>>>   15 files changed, 76 insertions(+), 40 deletions(-)
>>>
