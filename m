Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AB317A2FB
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 13:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785765156; cv=none; b=BgCRzkR85FE1RlVIq0pIp/dmfwK9uAvaBIY7JBsVvW/8T8svXSJAjv6DziMTCSelfQEinxewog2IlWBhtWZw+IACgP/xmSuzJ+7FBFeO7XJpPHB2asPyBNPVsnkYdwwlcwDha+rwi/6QeqS7RA9OWm5ply0Fu5UoME0vnMHn0fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785765156; c=relaxed/simple;
	bh=8LrjLHOuFXdWXF5yiXI7/eAi1UqV18NGLHiscgYWXPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pf9p7jb/tF4ZwEU6FTQ2f7VeQr/qD0ZtWi32q8+nQV/8c/uOnH850fmdjhZDgXeu9HhgR4b3fF0eizBmx0Om8FrKZWPwYtAU+qHpBMQLNpp+EdKFAXlRtKKAMiBRmB/99X6MEFeWVCcyMaKhvrDMMaFiXw3Lt8zuMA9ej1uxKW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W55vyWJI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W55vyWJI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785765153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YhLYm6/n2jN0v9pCPmHKplzUn4bx523AS/gbNEErh4I=;
	b=W55vyWJI5vocmfA/v6t6uOxGRZj6ieSN0B7qNMhExKCYNOEcrQYj1sHhzxRjrVs6bG5jHJ
	j3d9F2zy51mDtUr6ode7AvTfxPCF3Jxc3z97QBT8spj9twhRVEh/NACVBMEHfd42PGvp6Z
	HOvYkNWf3GLKgosEUe5SRV8fxZ1fmSk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-0NdNP9l6Ms-7r5mJ1-v1WA-1; Mon, 03 Aug 2026 09:52:32 -0400
X-MC-Unique: 0NdNP9l6Ms-7r5mJ1-v1WA-1
X-Mimecast-MFC-AGG-ID: 0NdNP9l6Ms-7r5mJ1-v1WA_1785765151
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47f90dbaf84so3208002f8f.1
        for <virtio-fs@lists.linux.dev>; Mon, 03 Aug 2026 06:52:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785765151; x=1786369951;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YhLYm6/n2jN0v9pCPmHKplzUn4bx523AS/gbNEErh4I=;
        b=CSqym4piWcN8i7TEgqRAAkbhHm4wF9OQ4S/sUUR2BEP4XjG1KHHTDi8Fw/DwSuJrwr
         YeesCfwTNU8E0HFoSZ5wQNmPNZmV1BG9jfhYAHrMk5HX58PDgsK805yrcbmFUdPnip/E
         BIPE5aOTwULPzBWxZ4hotCKFCfHDw5D4Ed+woVnLVY7xpGL+TJSQY7UgT2VhRNqdVJG9
         UfPdvCJ5pSyKEQTdNk3hIIOILlWjZ3vnZC2v2828Ngr8Xinb/ov8TTvd17teZa+68LmP
         d6/Sxp/jGDDpIMqxNHkqNk7MJNDOAoC9ebrqaTSxutVu/QH9NIKmc4giLvvINYzVtr4c
         rBRQ==
X-Forwarded-Encrypted: i=1; AHgh+RpMVSiM2xk6a7Ashy+ghzlsGfcZfy8aRLs9Z/bepl7cdTKxURH6axtEHg6PWrki40gbLT8/NpmqwbM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzqwv5iJkCFdy32SUZCt7LR2wGxbMKBxfdiLhPmXgZMCDgX2lq8
	ycvi28K13zEj44C2b1EVxaPpJmMe95LGPtglLUX+r03oN0L6xuB8Ppa+CO8TIb67pFP54yHthwl
	Y4TxcfqapK08SDR69LPY1J957+TiYxKSIB2QA+2cYo2SEl80hOT1DUyGm8ilqPA==
X-Gm-Gg: AR+sD12osZgvj/k9Ubktn/9lrOpzh3/1NKJNP8slCrDoUg7bqo7FX7n1Nar3yGvF4Pb
	P8NiqvnXz71mKPy28wFaN2mlIbnYfqUYCfrL1UNyU/GvMvOLnNH3YDpzSm10R7vYM/oTgy3sFSZ
	sMBQtTMRwxlWhp7tlnqKvQ5+PZmM6GeQi5y03NolE/Uvf4aGlikPztP/pg10BBYMdB22dtXiYww
	lkTJBV5Q7bMznwxIqAr1SaAthVKHIMeKaKTY1HbWxP5yOAtMG5yc6ZIOKBxCMmcDhU8oQapFMKm
	a8PtI4uQEhs7dntCPGijuABMU7mu9NTjgc8/g2jsDYadlUJf0ujAAMWvmDBRbgZxUJmyqpva8n4
	fchbiHJJLri/uGzZx875XXASPG7u9C7aX0mMb6MmZwPfdtm2lB1Ad716N537nsafmXU/kOKAI52
	QEuqwst+yJYHVYWVtvr6IMZ/zFZsPNZQ==
X-Received: by 2002:a05:6000:1a88:b0:47f:9486:810b with SMTP id ffacd0b85a97d-47fd729e718mr24219693f8f.7.1785765151233;
        Mon, 03 Aug 2026 06:52:31 -0700 (PDT)
X-Received: by 2002:a05:6000:1a88:b0:47f:9486:810b with SMTP id ffacd0b85a97d-47fd729e718mr24219640f8f.7.1785765150764;
        Mon, 03 Aug 2026 06:52:30 -0700 (PDT)
Received: from ?IPV6:2003:cf:d73d:549a:e584:7c7b:2611:32a1? (p200300cfd73d549ae5847c7b261132a1.dip0.t-ipconnect.de. [2003:cf:d73d:549a:e584:7c7b:2611:32a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd458ab61sm33894944f8f.25.2026.08.03.06.52.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 06:52:30 -0700 (PDT)
Message-ID: <13594665-16ec-47e5-9075-f7bd5552b0a3@redhat.com>
Date: Mon, 3 Aug 2026 15:52:28 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 13/15] hw/virtio/vhost-user: add shadow virtqueues and
 eventfd intercepts
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
 <20260723-vhost-user-isolated-memory-v1-13-6b97c439eb28@gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-13-6b97c439eb28@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NfAO2VBC3JiuASrRpn2IIfiGMIRjnasUhDIt167PGf0_1785765151
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.07.26 00:30, Connor Kite wrote:
> Adds shadow virtqueues that will eventually be used to transfer data
> between device and host via bounce buffers when isolation mode is
> active.  The svqs are initalized, and eventfd assignments are
> intercepted so that notifications come to svqs first before
> the guest or backend receive them.
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-user.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 54 insertions(+)
>
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index acabfb7f1c..75858289a2 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -18,6 +18,7 @@
>   #include "hw/virtio/vhost-backend.h"
>   #include "hw/virtio/virtio.h"
>   #include "hw/virtio/virtio-net.h"
> +#include "hw/virtio/vhost-shadow-virtqueue.h"
>   #include "hw/virtio/vhost-iova-tree.h"
>   #include "chardev/char-fe.h"
>   #include "io/channel-socket.h"
> @@ -365,7 +366,9 @@ struct vhost_user {
>   
>       /* Isolated memory data*/
>       struct IsolationRegion iso_memory;
> +    GPtrArray *shadow_vqs;
>       VhostIOVATree *iso_iova_tree;
> +    bool svqs_allocated;
>   };
>   
>   struct scrub_regions {
> @@ -1693,6 +1696,24 @@ static int vhost_set_vring_file(struct vhost_dev *dev,
>   static int vhost_user_set_vring_kick(struct vhost_dev *dev,
>                                        struct vhost_vring_file *file)
>   {
> +    struct vhost_user *u = dev->opaque;
> +    int svq_idx = file->index - dev->vq_index;
> +    if (u->user->memory_isolation) {
> +        VhostShadowVirtqueue *svq = g_ptr_array_index(u->shadow_vqs,
> +                                                      svq_idx);

Bounds checking via `vhost_user_get_vq_index()` would be nice. (Same below.)

> +        vhost_svq_set_svq_kick_fd(svq, file->fd);
> +
> +        if (svq->hdev_kick.initialized == false) {
> +            int r = event_notifier_init(&svq->hdev_kick, 0);
> +            if (r) {
> +                error_report("Failed to create kick event notifier");
> +                return r;
> +            }
> +        }
> +
> +        file->fd = event_notifier_get_fd(&svq->hdev_kick);

What if `file->fd` was -1, i.e. `VHOST_FILE_UNBIND`? Should we put a 
real FD here then or just continue with -1?

> +    }
> +
>       int ret = vhost_set_vring_file(dev, VHOST_USER_SET_VRING_KICK, file);
>       if (ret < 0) {
>           return ret;
> @@ -1721,6 +1742,24 @@ static int vhost_user_set_vring_kick(struct vhost_dev *dev,
>   static int vhost_user_set_vring_call(struct vhost_dev *dev,
>                                        struct vhost_vring_file *file)
>   {
> +    struct vhost_user *u = dev->opaque;
> +    int svq_idx = file->index - dev->vq_index;
> +    if (u->user->memory_isolation) {
> +        VhostShadowVirtqueue *svq = g_ptr_array_index(u->shadow_vqs,
> +                                                      svq_idx);
> +        vhost_svq_set_svq_call_fd(svq, file->fd);
> +
> +        if (svq->hdev_call.initialized == false) {
> +            int r = event_notifier_init(&svq->hdev_call, 0);

Do we need to check if the call event FD is already active?

> +            if (r) {
> +                error_report("Failed to create call event notifier");
> +                return r;
> +            }
> +        }
> +
> +        file->fd = event_notifier_get_fd(&svq->hdev_call);
> +    }
> +
>       return vhost_set_vring_file(dev, VHOST_USER_SET_VRING_CALL, file);
>   }
>   
> @@ -2715,6 +2754,17 @@ static int vhost_user_postcopy_notifier(NotifierWithReturn *notifier,
>       return 0;
>   }
>   
> +static void vhost_user_init_svq(struct vhost_dev *dev, struct vhost_user *u)
> +{
> +    /*Modified from vhost-vdpa*/
> +    u->shadow_vqs = g_ptr_array_new_full(dev->nvqs, vhost_svq_free);
> +    for (int i = 0; i < dev->nvqs; i++) {
> +        VhostShadowVirtqueue *svq;
> +        svq = vhost_svq_new(NULL, NULL);

Patch 15 adds clean-up for this; I would squash it into here, as far as 
possible. Ideally, a patch series can be stopped at any step and not 
break anything, so if an allocation is added, the accompanying freeing 
should come with it.

Hanna

> +        g_ptr_array_add(u->shadow_vqs, svq);
> +    }
> +}
> +
>   static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
>                                      Error **errp)
>   {
> @@ -2859,6 +2909,10 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
>       u->postcopy_notifier.notify = vhost_user_postcopy_notifier;
>       postcopy_add_notifier(&u->postcopy_notifier);
>   
> +    if (vus->memory_isolation) {
> +        vhost_user_init_svq(dev, u);
> +    }
> +
>       return 0;
>   }
>   
>

