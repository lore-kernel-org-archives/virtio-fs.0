Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A084237713
	for <virtio-fs@lists.linux.dev>; Mon, 13 Apr 2026 11:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776079224; cv=none; b=tNSTRg9d1c84CDMl+Du5AsiYrX6svE3/jPmaiaR0hkx8Gbozd4mByJpEwaoVtNbgZXrYngOlaYsqN6vNfraX/GujGpkqjVgrX7HYV5d7JQllUlwqqLLeT7iCLylo1OAE/LryjI2ohYYOmEnhhMYIBdxFcvLn8MFy0EG/qwlRFUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776079224; c=relaxed/simple;
	bh=+kelARibGoaG7pNmf+vIEaDe7fiA//nvJoye/UyH7Ec=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=hbHcFvIIujguCY/AIerblH6AERmAFP2qAmffsl7pW91flDRi0lH1YMr79wO7GVhTlsJMkB7x6t56XT0q4bJUVeqJTvoHSho4r0FpcXJCotL9oNOr/roWeJKegXIW07Y8FmqgA7mK5ACTtAQcMzibQMDteYN7kwlFKOUFGywBcTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=le5oPwQr; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="le5oPwQr"
Received: from mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:bf1f:0:640:c739:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id A52DA804EA;
	Mon, 13 Apr 2026 14:20:11 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:54f::1:13] (unknown [2a02:6bf:8080:54f::1:13])
	by mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id oJICOn1LU4Y0-U7bmOuBO;
	Mon, 13 Apr 2026 14:20:10 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1776079210;
	bh=1KGcvsOadFFT00/9xt9/mnJNPu4iayUn1BL143n1vkI=;
	h=In-Reply-To:Cc:Date:References:To:From:Subject:Message-ID;
	b=le5oPwQrf3tD6mFxKa6k2CNJsQopC/rRhClGqAnxoO8QuxX5RwZCPnKv9/oe+EslO
	 5mDUO6Wx627SwviKC1dLxq7PKQtRKvexyY2VejvCiq6mSLWtHzvHCIKC1Tx5fzQ5Lj
	 6m32C6koYJxHBWc49jWZvRZSA6BiMuM12Ay26+Lc=
Authentication-Results: mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <f74da296-2ec7-46dc-8ca4-c60b646b2aee@yandex-team.ru>
Date: Mon, 13 Apr 2026 16:19:50 +0500
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
Content-Language: en-US
In-Reply-To: <250aad49-9494-47d3-b0e1-2e4eec490ca3@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Greetings! Gentle ping

On 4/6/26 14:51, Alexandr Moshkov wrote:
> Ping :)
>
> On 3/30/26 14:52, Alexandr Moshkov wrote:
>> v2 -> v3:
>> - fix complile problems
>> - add assert check in do_vhost_virtio_stop
>> - make inflight-migration property mutable
>>
>> v1 -> v2:
>> - reorganize commits: make refactor commits first, then core semantic 
>> change
>> - add additional pre_save check for inflight migration possibility
>>
>> ---
>>
>> This is a small continuation of my series about inflight migration 
>> for vhost-user-blk.
>>
>> This series is designed to solve the problem of compatibility with 
>> older versions of qemu, where this feature has not yet been 
>> introduced (for example, if we want to downgrade versions due to some 
>> problems).
>>
>> In the current version for vhost-user-blk, this feature is enabled 
>> using the parameter and further migration of the inflight region will 
>> depend on whether the vhost-user has accepted the new protocol 
>> feature or not. This creates an inconvenient dependency, because 
>> there is no way to disable this feature without reconnecting to the 
>> backend.
>> This series slightly changes the semantics of the introduced protocol 
>> feature VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. Enabling this 
>> feature adds a new parameter for GET_VRING_BASE message - skip_drain, 
>> which allows to control drain in-flight requests on the backend.
>>
>> Thus, user can enable or disable inflight-migration param for 
>> vhost-user-blk to maintain compatibility with older versions of QEMU.
>>
>> Alexandr Moshkov (5):
>>    vhost-user.rst: fix typo
>>    vhost-user-blk: make inflight-migration prop mutable
>>    vhost-user: add skip_drain param to do_vhost_virtqueue_stop
>>    vhost-user-blk: move inflight_needed higher
>>    vhost-user: add skip_drain param to GET_VRING_BASE
>>
>>   backends/cryptodev-vhost.c     |  2 +-
>>   backends/vhost-user.c          |  2 +-
>>   docs/interop/vhost-user.rst    |  8 +++----
>>   hw/block/vhost-user-blk.c      | 43 +++++++++++++++++++++++++++-------
>>   hw/net/vhost_net.c             |  9 +++----
>>   hw/scsi/vhost-scsi-common.c    |  2 +-
>>   hw/virtio/vdpa-dev.c           |  2 +-
>>   hw/virtio/vhost-user-base.c    |  2 +-
>>   hw/virtio/vhost-user-fs.c      |  2 +-
>>   hw/virtio/vhost-user-scmi.c    |  2 +-
>>   hw/virtio/vhost-user.c         |  3 +--
>>   hw/virtio/vhost-vsock-common.c |  2 +-
>>   hw/virtio/vhost.c              | 29 ++++++++++++++++-------
>>   include/hw/virtio/vhost-user.h |  1 -
>>   include/hw/virtio/vhost.h      |  7 ++++--
>>   15 files changed, 76 insertions(+), 40 deletions(-)
>>
