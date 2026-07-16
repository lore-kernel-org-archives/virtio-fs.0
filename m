Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6471C30B529
	for <virtio-fs@lists.linux.dev>; Thu, 16 Jul 2026 07:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784187175; cv=none; b=AR/eca4Td85AyEs/UAHUA+JpmZYhNiQf7DHbqpDt9wlFWROv9SEN9kjnK2sCv7T7d95ygerukWjn3OuftCFictZ/GAenJ/EfevJLeW2QT2AOAQjnDGt65GSuucxtj5Co8GyycewSoRYdvLDtQzapVgDW7RoZoy1fZ1kA9WxujAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784187175; c=relaxed/simple;
	bh=MiXtVJFZmqM8Rqv2g5UBUnVcq1Pv7McEVRVa19qM/i0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nG0p6L2w9Db5RLMJdr7fZhOauw+XdkUZTA+5lUXP+0yjrE+Jo1nF9BUL90KnDDXvpxIKoeHITpdnv30t9ySoDv7e+IyqpOo++Xr7aB3o7+IVsJCjwRVotkMlo8GttHcy1EtIAHoF7GXonEBRwnvU9gAvEwh/Lykvbv2TJLpSiek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=HjtEEEhp; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="HjtEEEhp"
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2d:3530:0:640:eca4:0])
	by forwardcorp1a.mail.yandex.net (postfix) with ESMTPS id 66695C0259;
	Thu, 16 Jul 2026 10:30:46 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:970::1:6] (unknown [2a02:6bf:8080:970::1:6])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp) with ESMTPSA id YULaLV4WUSw0-7sBf6Zkk;
	Thu, 16 Jul 2026 10:30:45 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1784187045;
	bh=ZFg/qd6R6/U3mMLtN/FJ1i1VrEJ10GQmBXSO2Hp8aK8=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=HjtEEEhpACqx09sga19+PX95qOK+Clpm8cPn5fqciplJkwdUwEvJOtwwC9JuCPE0J
	 +nEK0bHlamte7kAnnHBHoMTBRjV5Tz3h7o2EMd7Jc5B64XRCL+3L+RXlIYa4Rn5Bw1
	 i1WaWr3LJrKHVWQAs+x0YJcXHOnEvgvzSpEb/hTM=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <d95a174d-83ec-4bc0-ac5f-46628262bd0a@yandex-team.ru>
Date: Thu, 16 Jul 2026 12:30:33 +0500
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] vhost-user-blk: fix compatibility with older qemu
 versions
To: qemu-devel@nongnu.org
Cc: Jason Wang <jasowangio@gmail.com>, Milan Zamazal <mzamazal@redhat.com>,
 Hanna Reitz <hreitz@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Fam Zheng <fam@euphon.net>, zhenwei pi <zhenwei.pi@linux.dev>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
 virtio-fs@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
 "yc-core@yandex-team.ru" <yc-core@yandex-team.ru>, qemu-block@nongnu.org,
 Raphael Norwitz <rnorwitz@nvidia.com>,
 Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
References: <20260702091023.3306378-1-dtalexundeer@yandex-team.ru>
Content-Language: en-US
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
In-Reply-To: <20260702091023.3306378-1-dtalexundeer@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Ping :)

On 7/2/26 14:10, Alexandr Moshkov wrote:
> v3 -> v4:
> - add new protocol message GET_VRING_BASE_SKIP_DRAIN instead of parameter to GET_VRING_BASE message. This new message can be send instead of GET_VRING_BASE, allowing back-end to suspend inflight I/O immediately instead of waiting and completing them.
> - rebase to newer master
>
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
> This series add new protocol message - GET_VRING_BASE_SKIP_DRAIN. This new message can be send instead of GET_VRING_BASE, allowing back-end to suspend inflight I/O immediately instead of waiting and completing them. This new message can be used only with protocol feature VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT.
>
> Thus, now user can enable or disable inflight-migration param for vhost-user-blk to maintain compatibility with older versions of QEMU by using GET_VRING_BASE_SKIP_DRAIN or GET_VRING_BASE messages.
>
> Alexandr Moshkov (6):
>    vhost-user: add skip_drain param to do_vhost_virtqueue_stop
>    vhost-user: add GET_VRING_BASE_SKIP_DRAIN message
>    vhost-user: use skip_drain with GET_VRING_BASE_SKIP_DRAIN message
>    vhost-user-blk: make inflight-migration prop mutable
>    vhost-user-blk: move inflight_needed higher
>    vhost-user-blk: use GET_VRING_BASE_SKIP_DRAIN during inflight
>      migration
>
>   backends/cryptodev-vhost.c        |  2 +-
>   backends/vhost-user.c             |  2 +-
>   docs/interop/vhost-user.rst       | 38 ++++++++++++++++++---------
>   hw/block/vhost-user-blk.c         | 43 +++++++++++++++++++++++++------
>   hw/net/vhost_net.c                |  9 ++++---
>   hw/scsi/vhost-scsi-common.c       |  2 +-
>   hw/virtio/vdpa-dev.c              |  2 +-
>   hw/virtio/vhost-user-base.c       |  2 +-
>   hw/virtio/vhost-user-fs.c         |  2 +-
>   hw/virtio/vhost-user-scmi.c       |  2 +-
>   hw/virtio/vhost-user.c            | 40 +++++++++++++++++++++++-----
>   hw/virtio/vhost-vsock-common.c    |  2 +-
>   hw/virtio/vhost.c                 | 34 +++++++++++++++++-------
>   include/hw/virtio/vhost-backend.h |  1 +
>   include/hw/virtio/vhost-user.h    |  1 -
>   include/hw/virtio/vhost.h         |  7 +++--
>   16 files changed, 137 insertions(+), 52 deletions(-)
>
