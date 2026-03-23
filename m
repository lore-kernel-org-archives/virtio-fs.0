Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40BF171CD
	for <virtio-fs@lists.linux.dev>; Mon, 23 Mar 2026 07:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774251703; cv=none; b=qu36Elur5xJtEG+FoZcjDTpovMAiOCqt5upqc5Mq13oYe4rOXCb9e72h6zSBEwY10jpZRXMpvUEsBc0BqamqGHo8CAJzrJwg/6IpAK8bXpa5KH+xniPTuWn5JL93jgPj2dgzlqI9lLNZYyOJJ5zfZBaBW3Xi4VxLO0pvPJ1T2VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774251703; c=relaxed/simple;
	bh=3jtwT2F2Ltr6Eq2SGOQVl/fLYelMJ05xYHPtP23k3q8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K5JsuzKk/G6UUZsGCoDrROrjnoOtdZ3OsHN5U8yUKtp7IZxD2T+t+olqa4RpqvgFVtY7f9XbTlY/E1cliSNTYV4QhcZlHd81xJJOTEDcHJ9F3EtMPV4URTPy8/6W7Or5lnpNOKTVU4zA/jq4ATEAppZc91qEjL8PLLG3nCt7Odk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=Vl6ABMXJ; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="Vl6ABMXJ"
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 1A800C015A;
	Mon, 23 Mar 2026 10:41:30 +0300 (MSK)
Received: from [IPV6:2a02:6bf:803e:400:96d8:c146:8b39:5d71] (unknown [2a02:6bf:803e:400:96d8:c146:8b39:5d71])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id QfMEt00AgmI0-dQqHGO8C;
	Mon, 23 Mar 2026 10:41:29 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1774251689;
	bh=EZm1NU2ucQ8gnEVcfRktWBEbQCWpytewWeeBhA/0LUg=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=Vl6ABMXJfQ2tun1+VXq+SkCENSX++x5tcvWJI3ZkMDFiXdQViYqkTXhKqqHuE3iZF
	 nQqRp7cEzqsDrz4y9nZ/bdqsQq7ADQa+LlO/bJ4/Z1SWTsDeWmtoldtAw5RL0kNcNG
	 Qj5x7Yhyqtzo3lmoBeBraj8ywuxKlaV0YNNmRB5c=
Authentication-Results: mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <964e04cf-d2bc-46b3-a3c2-d6eaf6cfecef@yandex-team.ru>
Date: Mon, 23 Mar 2026 12:41:26 +0500
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vhost-user-blk: fix compatibility with older qemu
 versions
To: qemu-devel@nongnu.org
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
Content-Language: en-US
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
In-Reply-To: <20260311084728.751169-1-dtalexundeer@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Ping)

On 3/11/26 13:47, Alexandr Moshkov wrote:
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
> Alexandr Moshkov (4):
>    vhost-user.rst: fix typo
>    vhost-user: add skip_drain param to do_vhost_virtqueue_stop
>    vhost-user-blk: move inflight_needed higher
>    vhost-user: add skip_drain param to GET_VRING_BASE
>
>   backends/cryptodev-vhost.c     |  2 +-
>   backends/vhost-user.c          |  2 +-
>   docs/interop/vhost-user.rst    |  8 +++-----
>   hw/block/vhost-user-blk.c      | 32 +++++++++++++++++++++++++-------
>   hw/net/vhost_net.c             |  9 +++++----
>   hw/scsi/vhost-scsi-common.c    |  2 +-
>   hw/virtio/vdpa-dev.c           |  2 +-
>   hw/virtio/vhost-user-base.c    |  2 +-
>   hw/virtio/vhost-user-fs.c      |  2 +-
>   hw/virtio/vhost-user-scmi.c    |  2 +-
>   hw/virtio/vhost-user.c         |  3 +--
>   hw/virtio/vhost-vsock-common.c |  2 +-
>   hw/virtio/vhost.c              | 24 +++++++++++++++---------
>   include/hw/virtio/vhost-user.h |  1 -
>   include/hw/virtio/vhost.h      |  7 +++++--
>   15 files changed, 62 insertions(+), 38 deletions(-)
>
