Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD9835A3A4
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 12:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760196; cv=none; b=qMDhPwgRSMbcldbAKMXefeEIXtR7GzTu8IVaH6ZCWOGT2y6OiyPkZdl9ffwjLvUZSHUxRvGqkBjQnq+cvVcQC7WYvgJCRa07EFtlDxuqO5b6tWrJbAlZymowILSKUVTCriOAeXG5UiRnljIwlh+dWTk8OGLOZovyorS25Hga95E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760196; c=relaxed/simple;
	bh=lSPimwub1BUNX8ekPHpF6/X9gF/Zn7VNiS2r4+GBB28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uh4b9ITsGU6fZ9NxUMByNEX2/oFD4LoUvpH/1G3rsReyGhtID0M5oV+99mlCxvqCk40HN70pQvPDa4JhXlKrwhYJ3xXZdOTM8EmbUOkmSxvNB7H9FSKyPK1vV8dI+BtNPp4fYtp3fdqOSWkbyT8jytEU9w40AYj7GQc38owf+cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DJBr2bqa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DJBr2bqa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785760194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TmN2Y/7ZeBKHjtIw5m996fudj11ti+C+v1YnO949IzM=;
	b=DJBr2bqaTKk05MDzD04ihIyCY5Q9mF3ML3rAFgPJjKGOeqo6b4qk31CJdwoTFg7PvUdbeq
	Dl+OZUnhaRdkUTcngDkawDTsPcKZ81P80UJGkHaxjtyEB8epxnU+LSoeHnyoYoL1TXZ/DQ
	YwfCZSP5qx9Z7zvI8x1PM4YMQkRlwv4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537--lZFXy90PFu7fFq-bnsprQ-1; Mon, 03 Aug 2026 08:29:43 -0400
X-MC-Unique: -lZFXy90PFu7fFq-bnsprQ-1
X-Mimecast-MFC-AGG-ID: -lZFXy90PFu7fFq-bnsprQ_1785760182
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-492488f8583so20066025e9.2
        for <virtio-fs@lists.linux.dev>; Mon, 03 Aug 2026 05:29:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785760182; x=1786364982;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TmN2Y/7ZeBKHjtIw5m996fudj11ti+C+v1YnO949IzM=;
        b=AnR/BmeHHDcV/Jd/FG8s7tFggeKzfiZ7tL7ri5wgpO0yphbskHn3XppZYEXRSRw2Qn
         ggsdyDatwe2yBpOJfDwd4xqTskNEA+bvmuUMD+U2GXserGQmNIvr+3H6ZnNySJRiEzO8
         Ch6zgRMMhvMv6t3Zwyp/5Q/a04MtVCRyO7k4RUbl543fB5+g3cxan0VOtSXkJdWofikZ
         ydR6IZixQKIawDgGwNX8wdwC3OWcWYD2zzFxrrpWqRP6rIuLA3zV6GGMMRnV0MFoKWWw
         Mecqlmo0Qsu9ReWGdCuD/NziIxeGJRQRDGhaQ1F2bJr1EMsO2TKnLNfOvEg/LNtdy1Hl
         WUFA==
X-Forwarded-Encrypted: i=1; AHgh+Ro7TLiqLk6hc6tqM9kpjEitATJTmLJNi2RZgu+8cv/8yLd2eKljDMfnhCokmj5QhhL2uFbxTBeDkYs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyyCrl/skhOWUwLEb6RcvWl+fVSCr0xAUAB0eyPi0845QRBxdb7
	hQn/9xLET6GiRM6EeboXU9sBpPf9jNpUTOqUPU9aKvKsgiin7T8shMcxKX+NdIBaKYwo3lj0DVp
	aGlNWvuFiMf8VchuIFyR5X+ofv5IC4oL99YuUJNNxXte7XZnIQQF65sxjgryX8A==
X-Gm-Gg: AR+sD10V2g3rluvocSK2hjb+YdGSxIp0jpfcs9oHodN1eI/aKVerTHLFlxrWw5Zusue
	Pt/NIZRSvOr0igWLfif9Sq1o6RjI8taNQbvkiSwRt6QLiSziNZ9SspDS5ESAfK9U7TIt0gB0cID
	4f/ziUiK+yK4JMaVpy8b89mu+w2mCaL4WQneWN0i030j5NK+FR3GI0ZJBABTbRfqnmE4KtbdQ74
	UIU08021xllcb9dU3hw56WsZKA81FE7FwxMb5MOF5lRwUqtUm3ME8COayaxBNMpchsn8dasIYQ1
	UVBn/0+V/AavD5LY+6PQjEmXKXP6IgtKXkcKlYomhrx5JTji9Ik5cJaYA4VmbrIPlEMdiGr8NR5
	BNv/gy2MoBLcs3VFYvJLeo7nMJLRHow7jqP74pf1e1zU3zgyyjBWJHjBLH6EcOUkZNDr1jUkw6O
	UAUuhBWLdSGPcLbSAv0MFNcVb07zWaIA==
X-Received: by 2002:a05:600c:4fc5:b0:495:4e1d:82df with SMTP id 5b1f17b1804b1-4980f233e12mr221917075e9.10.1785760180150;
        Mon, 03 Aug 2026 05:29:40 -0700 (PDT)
X-Received: by 2002:a05:600c:4fc5:b0:495:4e1d:82df with SMTP id 5b1f17b1804b1-4980f233e12mr221915055e9.10.1785760179048;
        Mon, 03 Aug 2026 05:29:39 -0700 (PDT)
Received: from ?IPV6:2003:cf:d73d:549a:e584:7c7b:2611:32a1? (p200300cfd73d549ae5847c7b261132a1.dip0.t-ipconnect.de. [2003:cf:d73d:549a:e584:7c7b:2611:32a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b5f0c3sm205973705e9.5.2026.08.03.05.29.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 05:29:38 -0700 (PDT)
Message-ID: <e40ea812-8774-46c3-aee6-511c6fbd07cc@redhat.com>
Date: Mon, 3 Aug 2026 14:29:34 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 05/15] vhost-user: add memory_isolation to
 VhostUserState
To: Connor Kite <connorkite@gmail.com>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 Haixu Cui <quic_haixcui@quicinc.com>, Raphael Norwitz <rnorwitz@nvidia.com>,
 Kevin Wolf <kwolf@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
 Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org,
 virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Alyssa Ross <hi@alyssa.is>,
 Demi Marie Obenour <demiobenour@gmail.com>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-5-6b97c439eb28@gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-5-6b97c439eb28@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: e-t5mKPKseNu3oQKr9BPqUC2bnqGk6F5YXIA6vf1YJM_1785760182
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.07.26 00:30, Connor Kite wrote:
> Add a memory_isolation bool to the VhostUserState struct. This
> bool is set within vhost_user_init(), which takes a
> memory_isolation bool as an argument.
>
> Refactor all call locations of vhost_user_init to include the new
> argument.
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   backends/cryptodev-vhost-user.c     |  2 +-
>   backends/vhost-user.c               |  4 ++--
>   hw/block/vhost-user-blk.c           |  3 ++-
>   hw/display/vhost-user-gpu.c         |  3 ++-
>   hw/scsi/vhost-user-scsi.c           |  3 ++-
>   hw/virtio/vhost-stub.c              |  3 ++-
>   hw/virtio/vhost-user-base.c         |  3 ++-
>   hw/virtio/vhost-user-fs.c           |  3 ++-
>   hw/virtio/vhost-user-scmi.c         |  3 ++-
>   hw/virtio/vhost-user-vsock.c        |  3 ++-
>   hw/virtio/vhost-user.c              |  5 ++++-
>   include/hw/virtio/vhost-user.h      |  6 +++++-
>   include/system/vhost-user-backend.h |  3 ++-
>   net/passt.c                         | 13 ++++++++-----
>   net/vhost-user.c                    |  9 +++++----
>   15 files changed, 43 insertions(+), 23 deletions(-)

[...]

> diff --git a/net/passt.c b/net/passt.c
> index ce80186883..a3021f37ef 100644
> --- a/net/passt.c
> +++ b/net/passt.c

[...]

> @@ -735,14 +738,14 @@ int net_init_passt(const Netdev *netdev, const char *name,
>       s->pidfile = pidfile;
>   
>       if (netdev->u.passt.has_vhost_user && netdev->u.passt.vhost_user) {
> -        bool memory_isolation G_GNUC_UNUSED = false;
> +        bool memory_isolation = false;
>   
>           if (netdev->u.passt.has_memory_isolation &&
> -           netdev->u.passt.memory_isolation) {
> +            netdev->u.passt.memory_isolation) {
>               memory_isolation = true;
>           }

I think this part of the hunk should be squashed into HEAD^.

Hanna

> -        if (net_passt_vhost_user_init(s, errp) == -1) {
> +        if (net_passt_vhost_user_init(s, memory_isolation, errp) == -1) {
>               qemu_del_net_client(nc);
>               return -1;
>           }

