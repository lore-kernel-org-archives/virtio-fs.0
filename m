Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83E5313E01
	for <virtio-fs@lists.linux.dev>; Mon,  6 Apr 2026 09:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775469191; cv=none; b=GMymL82kgGJdhEId5J4cdTCxZUYLLr+hq1jQjsNzMV4Lmam4wEvKQcTjmOC9DM4Jj9QpqycxWUUhxpbJape7poJwmrHea3WmMoZ9NJ33ls1ecfy8c92ziuBNjlrwB+HCdQQPwzXLLvmiZT4qomvvv+Cj2GwA0qIRnjncJlihw6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775469191; c=relaxed/simple;
	bh=DGvwMOf6SgmbuuVr7MniUWO6Fvia1XXptNfgd7Ndcho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tseSPv6QSTzxbJOKXoHw2cY3jlJoqLhvyprnXJQOReWq8EDBCDX+2KCtjQPDpQizi/kKJiWu0jJmJKRe2m/5ueJlQzNy+r7IeFeUPPHlDkw2sjG6zS4QZ0wFEPdljCLi5oM3lFZtdiOb77AVS7SJcaylmkLtWJ2+JnE5sLiy6QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=SeYzyGW9; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="SeYzyGW9"
Received: from mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net [IPv6:2a02:6b8:c08:7605:0:640:8d9a:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 4E77E80632;
	Mon, 06 Apr 2026 12:51:27 +0300 (MSK)
Received: from [IPV6:2a02:6bf:803e:400:4f77:70a0:e2de:cae6] (unknown [2a02:6bf:803e:400:4f77:70a0:e2de:cae6])
	by mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id Npc8pe1K4eA0-Hz54dl3X;
	Mon, 06 Apr 2026 12:51:26 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1775469086;
	bh=Vw2y0jsc+BCixb/Wn6lFRJq4eTDaxiSplH1YrdvIHdA=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=SeYzyGW9iXivpwrtRv9D6dzl4Fuz8qumVJqMcSd99JR5p1bUQ1iJxbOy0fHZrIhnn
	 FnVnmiOjHAHDekuAsyxiDxqpu82zSdktpg7GnK6CqBa6HzbSefu/qo5RBwyaBW/Nz5
	 8pk7ZCmIzObA6izWsWUw9ADfYHb9KRlJ/9q+Bkpg=
Authentication-Results: mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <250aad49-9494-47d3-b0e1-2e4eec490ca3@yandex-team.ru>
Date: Mon, 6 Apr 2026 14:51:23 +0500
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] vhost-user-blk: fix compatibility with older qemu
 versions
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
Content-Language: en-US
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
In-Reply-To: <20260330095226.158386-1-dtalexundeer@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Ping :)

On 3/30/26 14:52, Alexandr Moshkov wrote:
> v2 -> v3:
> - fix complile problems
> - add assert check in do_vhost_virtio_stop
> - make inflight-migration property mutable
>
> v1 -> v2:
> - reorganize commits: make refactor commits first, then core semantic change
> - add additional pre_save check for inflight migration possibility
>
> ---
>
> This is a small continuation of my series about inflight migration for vhost-user-blk.
>
> This series is designed to solve the problem of compatibility with older versions of qemu, where this feature has not yet been introduced (for example, if we want to downgrade versions due to some problems).
>
> In the current version for vhost-user-blk, this feature is enabled using the parameter and further migration of the inflight region will depend on whether the vhost-user has accepted the new protocol feature or not. This creates an inconvenient dependency, because there is no way to disable this feature without reconnecting to the backend.
> This series slightly changes the semantics of the introduced protocol feature VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. Enabling this feature adds a new parameter for GET_VRING_BASE message - skip_drain, which allows to control drain in-flight requests on the backend.
>
> Thus, user can enable or disable inflight-migration param for vhost-user-blk to maintain compatibility with older versions of QEMU.
>
> Alexandr Moshkov (5):
>    vhost-user.rst: fix typo
>    vhost-user-blk: make inflight-migration prop mutable
>    vhost-user: add skip_drain param to do_vhost_virtqueue_stop
>    vhost-user-blk: move inflight_needed higher
>    vhost-user: add skip_drain param to GET_VRING_BASE
>
>   backends/cryptodev-vhost.c     |  2 +-
>   backends/vhost-user.c          |  2 +-
>   docs/interop/vhost-user.rst    |  8 +++----
>   hw/block/vhost-user-blk.c      | 43 +++++++++++++++++++++++++++-------
>   hw/net/vhost_net.c             |  9 +++----
>   hw/scsi/vhost-scsi-common.c    |  2 +-
>   hw/virtio/vdpa-dev.c           |  2 +-
>   hw/virtio/vhost-user-base.c    |  2 +-
>   hw/virtio/vhost-user-fs.c      |  2 +-
>   hw/virtio/vhost-user-scmi.c    |  2 +-
>   hw/virtio/vhost-user.c         |  3 +--
>   hw/virtio/vhost-vsock-common.c |  2 +-
>   hw/virtio/vhost.c              | 29 ++++++++++++++++-------
>   include/hw/virtio/vhost-user.h |  1 -
>   include/hw/virtio/vhost.h      |  7 ++++--
>   15 files changed, 76 insertions(+), 40 deletions(-)
>
