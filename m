Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38D13769EA
	for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 05:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786944603; cv=none; b=EGOiJvc7rsqzRgqWPPLisovbWasZx5zlJyQXs1+9KNy4YJhwQvq06a+zNwFetSCUKZ+8pUtAL1zKOoGAVYdTqhdlOlb0C1c5KHpYgFJHbNpB9gmz8Vb3myHix8QUHsDmCqQ+fhp9WTDId6XpbLdbW+epu/G80AF6l0iLnonGhpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786944603; c=relaxed/simple;
	bh=kTGYoy4iy2DS46bPosHBVud1vz2PyAgTDrUbUgyE7lk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V4DtsrnMGWRxIedEMVG1zR8IuZtH+hIf59RFDMvVNtU0T+/HEcbSzBvfY3HZz8krzZXuaFQVAKnPhyEqV9TSBHCmXPWyea718XO7xN25pBFlcqHzLgPT4Nw5vSkAa+1uzhlXybijdBtLveB5bSQYCFFeA7gyYHp4WjPh6k3cJ7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=zJCRxF79; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="zJCRxF79"
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2d:3530:0:640:eca4:0])
	by forwardcorp1a.mail.yandex.net (postfix) with ESMTPS id D58E4C04A2;
	Mon, 17 Aug 2026 08:29:55 +0300 (MSK)
Received: from [IPV6:2a02:6bf:803e:400:858:d814:19c7:79ca] (unknown [2a02:6bf:803e:400:858:d814:19c7:79ca])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp) with ESMTPSA id nTMCnA8aW8c0-cKeONhQM;
	Mon, 17 Aug 2026 08:29:55 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1786944595;
	bh=uak8v+oR1lACOzz5qOYMjrD0NnnFEPKnkFKzUNy8KQM=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=zJCRxF795D+pyOmzrDbOPhzokn04TXBYL+OXG95k1CWXuFDb6J9Zk8n14PLsIbGe0
	 298Ng9z/FsC0j0d/aFzmtTzuPbMc8xN5QkxeOjzbIwqLCDrP0jDTi0MGAAMT05+9Ao
	 yRAJ02zLvlRowYDw0/fos184t6a5sBNnr98HrKFI=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <c6841f52-4d74-4343-b958-067b110fb532@yandex-team.ru>
Date: Mon, 17 Aug 2026 10:29:49 +0500
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] vhost-user-blk: allow toggling inflight-migration
 at runtime
To: qemu-devel@nongnu.org
Cc: Stefano Garzarella <sgarzare@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, zhenwei pi <zhenwei.pi@linux.dev>,
 "Gonglei (Arei)" <arei.gonglei@huawei.com>, Jason Wang
 <jasowangio@gmail.com>, Kevin Wolf <kwolf@redhat.com>,
 Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
 Milan Zamazal <mzamazal@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-block@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Fam Zheng <fam@euphon.net>,
 virtio-fs@lists.linux.dev,
 Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>,
 Jason Wang <jasowang@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 "yc-core@yandex-team.ru" <yc-core@yandex-team.ru>
References: <20260803072853.2920007-1-dtalexundeer@yandex-team.ru>
Content-Language: en-US
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
In-Reply-To: <20260803072853.2920007-1-dtalexundeer@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greetings! Ping.

On 8/3/26 12:28, Alexandr Moshkov wrote:
> v5 -> v6:
> - block changing inflight-migration property while VM is not running
> - remove checking runstate in vhost_user_blk_stop() since it's not necessary
> - updated cover letter: changed subject and description to focus on
>    runtime toggling of inflight-migration rather than cross-version
>    migration compatibility
>
> v4 -> v5:
> - introduce protocol feature VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN
>    to guard the new message, instead of reusing the existing
>    VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INLIFGHT. Update docs.
> - improved commit messages.
>
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
> This is v6 of the series previously sent as:
> "[PATCH v5 0/6] vhost-user-blk: add compatibility with older qemu versions"
>
> This series allows the inflight-migration property of vhost-user-blk to
> be toggled at runtime via qom-set without restarting the VM or
> reconnecting to the back-end.
>
> Currently, the inflight migration behaviour is controlled by
> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT, which is negotiated once
> at connection time. Once negotiated, the back-end always uses suspend
> semantics on GET_VRING_BASE -- there is no way for the front-end to
> request normal drain behaviour on a per-call basis. This makes it
> impossible to disable inflight-migration at runtime.
>
> To solve this, the series introduces a new protocol message
> VHOST_USER_GET_VRING_BASE_SKIP_DRAIN (id=45) guarded by a new protocol
> feature VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN. The message
> instructs the back-end to suspend in-flight I/O immediately rather than
> draining it. This gives the front-end explicit per-call control:
> GET_VRING_BASE for normal drain, GET_VRING_BASE_SKIP_DRAIN when
> inflight-migration is enabled.
>
> In vhost-user-blk, GET_VRING_BASE_SKIP_DRAIN is sent whenever
> inflight-migration is on. The inflight-migration
> property can only be changed while the VM is running, so its value at
> stop time reliably reflects the user's intent.
>
> Alexandr Moshkov (6):
>    vhost-user: add skip_drain param to do_vhost_virtqueue_stop
>    vhost-user: add GET_VRING_BASE_SKIP_DRAIN message
>    vhost-user: use skip_drain with GET_VRING_BASE_SKIP_DRAIN message
>    vhost-user-blk: make inflight-migration prop mutable on running vm
>    vhost-user-blk: move inflight_needed higher
>    vhost-user-blk: use GET_VRING_BASE_SKIP_DRAIN when inflight-migration
>      is on
>
>   backends/cryptodev-vhost.c        |  2 +-
>   backends/vhost-user.c             |  2 +-
>   docs/interop/vhost-user.rst       | 88 +++++++++++++++++++------------
>   hw/block/vhost-user-blk.c         | 60 ++++++++++++++++++---
>   hw/net/vhost_net.c                |  9 ++--
>   hw/scsi/vhost-scsi-common.c       |  2 +-
>   hw/virtio/vdpa-dev.c              |  2 +-
>   hw/virtio/vhost-user-base.c       |  2 +-
>   hw/virtio/vhost-user-fs.c         |  2 +-
>   hw/virtio/vhost-user-scmi.c       |  2 +-
>   hw/virtio/vhost-user.c            | 47 ++++++++++++++---
>   hw/virtio/vhost-vsock-common.c    |  2 +-
>   hw/virtio/vhost.c                 | 34 ++++++++----
>   include/hw/virtio/vhost-backend.h |  1 +
>   include/hw/virtio/vhost-user.h    |  2 +-
>   include/hw/virtio/vhost.h         |  7 ++-
>   16 files changed, 189 insertions(+), 75 deletions(-)
>
