Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9366343F09A
	for <virtio-fs@lists.linux.dev>; Wed, 29 Jul 2026 09:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785316455; cv=none; b=cnu0FjuuFmox1bsBDG90h8XeCZT6McWNpNKS5L7PHFaCfYMvo5bPuneExr7NwgDuLRPhuOi/twPSBVjcYxXsl1SKSIIDXa9gvN7KAyQ8/5DTs3VWm1emNLLcG3o+3kCrOfkWjEBAxPkGeTkPJb6QsxIz5mA1mBszVsjCGB+BE7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785316455; c=relaxed/simple;
	bh=aJO1eR1sLfrJsfgri43IHMDoP/+8DH6rA6Y2T/1xbqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=NVWTA4R6si/vcaLCAKaktlzq4itMJZH0RypFcoYb6HCvh5fiKenQ/Q1rqCVa8DFTIYfm5dvJuwu59cxWktMbomXRcvApsxs8CSqVFUnZ77q53Sqm93yxoka9ZaxoZIHNfPzUgSt/VWVjhVAnzdVu9tq+3mXZ8DUa+AcGvzfDuk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aVrGEgMR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aVrGEgMR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785316452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A9YdTDuVo8niT4qO7Mio/qjBuUTTJsiTpbi84Q7pNsA=;
	b=aVrGEgMRfcuNq2O0qpO/OnfEm4oOcMcggV0x/cypT22ZcEddVPiulqWMSRhlQS3Os2nN+u
	6OhDtCvcXUV4qpXaH/s4+4hWeaGgaCuToh5/fWa4hOJtGAeVZRBM6Bekg36kOs2AFg/X5R
	DwlGoto5J1iwg43nCxOaLcJbHTTThT0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-rMxbv_W6NVe6XXNGdCy3uw-1; Wed, 29 Jul 2026 05:14:10 -0400
X-MC-Unique: rMxbv_W6NVe6XXNGdCy3uw-1
X-Mimecast-MFC-AGG-ID: rMxbv_W6NVe6XXNGdCy3uw_1785316450
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso6025905e9.2
        for <virtio-fs@lists.linux.dev>; Wed, 29 Jul 2026 02:14:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785316449; x=1785921249;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=A9YdTDuVo8niT4qO7Mio/qjBuUTTJsiTpbi84Q7pNsA=;
        b=sldjV5qRzBcmiQEyywlpaUD0bqWppqCSyY6k3TzKXKB61yORgKSOGDPK5MkflIpZhs
         5hKsWcNp+K7B5XlmwTBleZg49fLYzxPvcIsEpfQ2qV+j2x35tyqRYGlQSPYZ4ghDjwfr
         qpIFBx7ctdKmeENgSyuH10DfDUJe9OxQdfjB7g7w95OCS6+Bfx5JUoZuXBJMbWseOusB
         KwncSt22lnqcbPlDZ//zCnPA0LxmIze1IHNpEF6i0dcav5fUvV97CtjE382JxPwGcVbL
         oiczFSjiodsZ8AECoFVxij7VbVoyQl/phe4OwftYXrtUbRpwn+7F32ICTbThIB2Z3Lb9
         p4dA==
X-Forwarded-Encrypted: i=1; AHgh+RpHaoRjFxHsCMM4mV/iZFz3ysSAdlES8sciOV0UJ57gvH1MoCzkpsUC7yCcLNyplmdU2pjf1mzinDQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2HQzSD67CFbmXNmAzVF/exmEByHjyw+He+3eex115PeckYXEr
	JGu+O6l0BmeGkHAFnueiDDRX540f3BPwcs0iVBXdl1OR4FyjgnnAJs4vMW04AXqJlwXUBjN49FH
	QABjl9LW61X9d/wgGGkPgPpcjZSr/SHgQ3C+ZSW33tpdpwh8wrdtuZYW6cVpDGQ==
X-Gm-Gg: AR+sD13t4i27O9GeH2Xk+m7L+Ur1K03EKzZ0CmfWldYV98qJv3maOfUSzCRrSxfLB4n
	o9LPgDcjiURw0llmcCCwTavuzM+YstyELCed5cFfjMd7b0wESxnYeaKXuVptfe9khknkGFrbn6k
	t69GfQG8k+E0oNGwqjgcjlMtnEVhvICAu8J9Oo+k+2HZc0xvpZk+a2K8Uan2bVvGDigSp7w3Xmr
	RFcjRp0JDUA7ftWUh3EMsNcuNUfDMI6vUy0RIDcFiCHxP7M4g0RbSPWdqd6jcFAJv15fzO10mcG
	FEWluj59WY/9CqGRTu+l5sZhOBwpisjMPYlPTyIuLGG5cruRP8UoTo/3uviuE+0obYLKLAz3lJV
	XqCmEGFbJS7BLHtB1yZ6fRTM=
X-Received: by 2002:a05:600c:c162:b0:495:7285:a498 with SMTP id 5b1f17b1804b1-496c656540fmr66209445e9.18.1785316449385;
        Wed, 29 Jul 2026 02:14:09 -0700 (PDT)
X-Received: by 2002:a05:600c:c162:b0:495:7285:a498 with SMTP id 5b1f17b1804b1-496c656540fmr66208855e9.18.1785316448846;
        Wed, 29 Jul 2026 02:14:08 -0700 (PDT)
Received: from redhat.com (ppp-94-66-118-61.home.otenet.gr. [94.66.118.61])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49764d70042sm37506535e9.1.2026.07.29.02.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 02:14:08 -0700 (PDT)
Date: Wed, 29 Jul 2026 05:14:04 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Cc: qemu-devel@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Jason Wang <jasowang@redhat.com>, Fam Zheng <fam@euphon.net>,
	qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>,
	virtio-fs@lists.linux.dev, Kevin Wolf <kwolf@redhat.com>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Raphael Norwitz <rnorwitz@nvidia.com>
Subject: Re: [PATCH v5 0/6] vhost-user-blk: add compatibility with older qemu
 versions
Message-ID: <20260729050854-mutt-send-email-mst@kernel.org>
References: <20260728100841.3475774-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260728100841.3475774-1-dtalexundeer@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u5JygLFU2Kpkw4yVrIoAGxus-HK6F58eYF4xzEE4SRA_1785316450
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jul 28, 2026 at 03:08:35PM +0500, Alexandr Moshkov wrote:
> v4 -> v5:
> - introduce protocol feature VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN
>   to guard the new message, instead of reusing the existing
>   VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INLIFGHT. Update docs.
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
> This is v5 of the series previously sent as
> "[PATCH v4 0/6] vhost-user-blk: fix inflight migration compatibility".
> 
> This series extends the vhost-user-blk inflight migration feature
> introduced in QEMU 11.0 to address a runtime compatibility problem.
> 
> Currently, the inflight migration behaviour in vhost-user-blk is
> controlled by VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT, which is
> negotiated once at connection time. Once the feature is negotiated, the
> back-end always uses suspend semantics on GET_VRING_BASE — there is no
> way for the front-end to request normal drain behaviour on a per-call
> basis without reconnecting. This makes it impossible to disable
> inflight-migration at runtime, which is needed when, for example,
> migrating a VM to an older QEMU version that does not support the
> feature.


This part, I do not understand.

What exactly does "migrating" mean here? Live migration?
An older QEMU will presumably either negotiate or fail to negotiate
the bit.


> To solve this, the series introduces a new protocol message
> VHOST_USER_GET_VRING_BASE_SKIP_DRAIN (id=45) guarded by a new protocol
> feature VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN. The message is
> semantically identical to GET_VRING_BASE but explicitly instructs the
> back-end to suspend in-flight I/O immediately rather than draining it.
> This gives the front-end explicit per-call control: GET_VRING_BASE for
> normal operation, GET_VRING_BASE_SKIP_DRAIN during live migration.
> 
> In vhost-user-blk, GET_VRING_BASE_SKIP_DRAIN is sent only when
> inflight-migration is enabled and the device is stopping due to live
> migration (RUN_STATE_FINISH_MIGRATE). The inflight-migration property
> is also made mutable so it can be toggled via qom-set at runtime without
> reconnecting to the back-end.
> 
> Alexandr Moshkov (6):
>   vhost-user: add skip_drain param to do_vhost_virtqueue_stop
>   vhost-user: add GET_VRING_BASE_SKIP_DRAIN message
>   vhost-user: use skip_drain with GET_VRING_BASE_SKIP_DRAIN message
>   vhost-user-blk: make inflight-migration prop mutable
>   vhost-user-blk: move inflight_needed higher
>   vhost-user-blk: use GET_VRING_BASE_SKIP_DRAIN during inflight
>     migration
> 
>  backends/cryptodev-vhost.c        |  2 +-
>  backends/vhost-user.c             |  2 +-
>  docs/interop/vhost-user.rst       | 88 +++++++++++++++++++------------
>  hw/block/vhost-user-blk.c         | 43 ++++++++++++---
>  hw/net/vhost_net.c                |  9 ++--
>  hw/scsi/vhost-scsi-common.c       |  2 +-
>  hw/virtio/vdpa-dev.c              |  2 +-
>  hw/virtio/vhost-user-base.c       |  2 +-
>  hw/virtio/vhost-user-fs.c         |  2 +-
>  hw/virtio/vhost-user-scmi.c       |  2 +-
>  hw/virtio/vhost-user.c            | 47 ++++++++++++++---
>  hw/virtio/vhost-vsock-common.c    |  2 +-
>  hw/virtio/vhost.c                 | 34 ++++++++----
>  include/hw/virtio/vhost-backend.h |  1 +
>  include/hw/virtio/vhost-user.h    |  2 +-
>  include/hw/virtio/vhost.h         |  7 ++-
>  16 files changed, 172 insertions(+), 75 deletions(-)
> 
> -- 
> 2.34.1

