Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C093F99E3
	for <virtio-fs@lists.linux.dev>; Tue, 25 Aug 2026 14:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787668000; cv=none; b=gRR+Pq3LIaCWWO/eUHq31mwlmWNQ56Uux7PcUQwIHgxEfZeVFRtCHq9T6Wzr0Xe+AwUU4FscSIJn9DdtdQ24eNTXtMfde6AVPo0qkMloH1vpMz8B2vZc/gVYxR9AuFnEMvl7atywD5QrQ9cotkWqghXM13fjA8VfWVdL0zTbo0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787668000; c=relaxed/simple;
	bh=0eBpDptt86gW9SK1W75SdUfBg+etL6JYH+K18x10+ms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u6qjyfTGvwjBuj/TR3/bL+08GrTQo1RDK6uqyJQFqvC7YyFVFScdctsePSbn0Ve3W/AS5hCrzGjZ72TjiLeRr3aqYa173naHzNKj/Rimpx2QY8Li33CdYCMX2wvAjkjyxgTb5QmfO9TFt++x8ZV2NEfa34iztdOtZ0sXwIL9PH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gc15e4qe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gc15e4qe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787667997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eBjcdBfvoewouVOB1p8YoexCwmn0WGX7vbnG4qWEdCg=;
	b=Gc15e4qesSHOtpTFULmilNM+YAxdTuFnTN12ollJ6GWuZJ8pF5g4VYCiaMN+bl9BJ7AXV8
	WZffaTf5on/giR3XtEBWuKvzkMvNEd+7oH2yBs0ubzsxVFA/kRx+Xgi/tLPw5gFW2Ldd4t
	69eB/SoAcaFh1CdN5avDwSLRGgI1zGs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-UHTPOKAPNL6vpWK32mUdhA-1; Tue, 25 Aug 2026 10:26:35 -0400
X-MC-Unique: UHTPOKAPNL6vpWK32mUdhA-1
X-Mimecast-MFC-AGG-ID: UHTPOKAPNL6vpWK32mUdhA_1787667994
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-698b899b53cso4296759a12.3
        for <virtio-fs@lists.linux.dev>; Tue, 25 Aug 2026 07:26:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787667994; x=1788272794;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eBjcdBfvoewouVOB1p8YoexCwmn0WGX7vbnG4qWEdCg=;
        b=LyRFNnOFp+bnWyJQbO4cmdCBr5AzWqeD0nPraec4eHXjXLTwvNIKlYG1mL2aZQ3wC8
         onm33fMXV3eZPfix9PwuloYm3Qe4uDdjN1nFucjpU0KnO7raTFox9AlVzN7IKbyWYa2r
         AQgtP9GNVsapZesuDOgIMbY40rBW3YPJ4XHJEyLCHzb0WP4a23qGEEdvaIXSLzE8Oz5b
         qetbSXbQvnpcMhPMHRgM66iJe8Sft0tW3D/eMkB41t35MKgq2RudTaQjBK3yC3QPfiH1
         BpY+sp9Sva3RGFqu+77MoGh+jMB4j+YzhiKQNueGrJsCOG4Pb0mnIAlKIeJRc2lqxQ1E
         Caug==
X-Forwarded-Encrypted: i=1; AHgh+RoDTmGrXPuYs9OpDpJi1CzfGfs0arTvJM3hKbM+sd0y2XHahWUJrcxw7392LsAtVxutYQ1VnGiGK8I=@lists.linux.dev
X-Gm-Message-State: AFuF++kzbcwS+Rsefh3ewCIzQQsSSDA1kWt8X2H0hLeHPYSOMMznWcqc
	a/9Nr+sI892f9JcolNscNKUbM//AaH8cr1uKaWkx5Ts08/v/fICxAyng3oCMQ3LARasrDqShFns
	Oks6y0kLaItCPr+OaHpHChEjirXbH3j4fASaekm/fnYvN1zT1OTVtesgndcjHvw==
X-Gm-Gg: AR+sD10Z5U+/qBT0+P9Xrw1Pz4ixMNYdJdxvmhFrIx8TIsxDzOJ5FHf4CS9s/cJNJzm
	DJXiy3sfPBo0mjwcpoJJGsmMnUb9aNIa+UGpeMmXhMh3wRUnJcBGMJXFxCxadenIrWWAcuxhqog
	hFsrJ2eai4Qvh240PzHwFgGT5A5w8yyFobQ92jnuiNbp7iG6ic7ZWekfq5SC4w19QLQX0rD7Evp
	8UeAAnyZAYU1wMTSTg84/xV32bT9Mlj7pkkikedIWPY3zdnCG+3+I8IrlfMqD42e2x/Spe0pnO0
	5wS7e4eK5ZCh6zic1oBP4NEF5NE9xIcfLwpFTAuY9qqaTCmx0P+arF1Vmi5tVC76b7X8mXBMnnF
	RJyqNcqliMAizUm8kn9p6hj0jG6RNgZWIDGPKR96OPCnaxxZAfI9cGiLIG/HwoZ53MXQ10RU8uO
	lu+LSsGaO9McrQNJTAe/QulKwfmIwENQ==
X-Received: by 2002:a05:6402:3805:b0:6a3:87b7:b5a9 with SMTP id 4fb4d7f45d1cf-6a5c412fd8emr9529016a12.12.1787667993906;
        Tue, 25 Aug 2026 07:26:33 -0700 (PDT)
X-Received: by 2002:a05:6402:3805:b0:6a3:87b7:b5a9 with SMTP id 4fb4d7f45d1cf-6a5c412fd8emr9528927a12.12.1787667993410;
        Tue, 25 Aug 2026 07:26:33 -0700 (PDT)
Received: from ?IPV6:2003:cf:d70a:12bf:c327:80a0:6d65:31e3? (p200300cfd70a12bfc32780a06d6531e3.dip0.t-ipconnect.de. [2003:cf:d70a:12bf:c327:80a0:6d65:31e3])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a59e1d741asm14271081a12.27.2026.08.25.07.26.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 07:26:32 -0700 (PDT)
Message-ID: <5d91e894-c54e-4dc5-bb3f-463c14b6fda0@redhat.com>
Date: Tue, 25 Aug 2026 16:26:29 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 05/13] hw/virtio/vhost-shadow-virtqueue: specified
 vring placement
To: Connor Kite <connorkite@gmail.com>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>,
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
 Demi Marie Obenour <demiobenour@gmail.com>,
 20260817233147.2867623-1-connorkite@gmail.com
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
 <20260817-vhost-user-isolated-memory-v2-5-948aae960abb@gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-5-948aae960abb@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ty-IDblLxToW-_1nznFbGBpMvvenkTJigymV-9TMAh4_1787667994
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18.08.26 07:12, Connor Kite wrote:
> By default svq vrings are placed in an anonymous memory map. As svqs
> will be leveraged to enable memory isolation in vhost-user, it is useful
> to be able to place the vrings in a shared isolation memory region.
>
> Adds the option to specify vring placement by providing a vring base
> address before starting the svq.
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-shadow-virtqueue.c | 69 ++++++++++++++++++++++++++++++++------
>   hw/virtio/vhost-shadow-virtqueue.h |  8 ++++-
>   2 files changed, 66 insertions(+), 11 deletions(-)
>
> diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
> index 496e7e58a3..f54a61439a 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.c
> +++ b/hw/virtio/vhost-shadow-virtqueue.c
> @@ -812,6 +812,13 @@ size_t vhost_svq_device_area_size(const VhostShadowVirtqueue *svq)
>       return ROUND_UP(used_size, qemu_real_host_page_size());
>   }
>   
> +size_t vhost_svq_vring_total_size(VirtIODevice *vdev, VirtQueue *vq)

If this function is not used in this patch, it probably should not be 
introduced here.

> +{
> +    VhostShadowVirtqueue svq;
> +    svq.vring.num = virtio_queue_get_num(vdev, virtio_get_queue_index(vq));
> +    return vhost_svq_driver_area_size(&svq) + vhost_svq_device_area_size(&svq);

I’m not 100 % happy about this (initializing a pseudo svq), might be 
better to make it so there are vhost_svq_driver/device_area_size() 
variants that take the num directly, and then have 
vhost_svq_driver/device_area_size() be wrappers around it, but, well. At 
least the implementations are right above it so one can verify that 
nothing else in VhostShadowVirtqueue is used. (It’s just that one should 
not *have* to verify.)

> +}
> +
>   /**
>    * Set a new file descriptor for the guest to kick the SVQ and notify for avail
>    *
> @@ -842,6 +849,19 @@ void vhost_svq_set_svq_kick_fd(VhostShadowVirtqueue *svq, int svq_kick_fd)
>       }
>   }
>   
> +/**
> + * Set vring base address if using fixed locations
> + *
> + * @svq: Shadow Virtqueue
> + * @addr: Points to new base address
> + */
> +
> + void vhost_svq_set_base_addr(VhostShadowVirtqueue *svq, void *addr)
> + {
> +    svq->base_addr = addr;
> + }
> +
> +
>   /**
>    * Start the shadow virtqueue operation.
>    *
> @@ -849,8 +869,10 @@ void vhost_svq_set_svq_kick_fd(VhostShadowVirtqueue *svq, int svq_kick_fd)
>    * @vdev: VirtIO device
>    * @vq: Virtqueue to shadow
>    * @iova_tree: Tree to perform descriptors translations
> + *
> + * Return 0 on success, -errno on failure
>    */
> -void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
> +int vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
>                        VirtQueue *vq, VhostIOVATree *iova_tree)
>   {
>       size_t desc_size;
> @@ -868,14 +890,27 @@ void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
>   
>       svq->vring.num = virtio_queue_get_num(vdev, virtio_get_queue_index(vq));
>       svq->num_free = svq->vring.num;
> -    svq->vring.desc = mmap(NULL, vhost_svq_driver_area_size(svq),
> -                           PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS,
> -                           -1, 0);
>       desc_size = sizeof(vring_desc_t) * svq->vring.num;
> -    svq->vring.avail = (void *)((char *)svq->vring.desc + desc_size);
> -    svq->vring.used = mmap(NULL, vhost_svq_device_area_size(svq),
> -                           PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS,
> -                           -1, 0);
> +    if (svq->base_addr == NULL) {
> +        svq->vring.desc = mmap(NULL, vhost_svq_driver_area_size(svq),
> +                            PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS,
> +                            -1, 0);
> +        svq->vring.avail = (void *)((char *)svq->vring.desc + desc_size);
> +        svq->vring.used = mmap(NULL, vhost_svq_device_area_size(svq),
> +                            PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS,
> +                            -1, 0);
> +    } else {
> +        svq->vring.desc = (void *)svq->base_addr;
> +        svq->vring.avail = (void *)((char *)svq->vring.desc + desc_size);
> +        svq->vring.used = (void *)((char *)svq->base_addr +
> +                          vhost_svq_driver_area_size(svq));
> +
> +        if ((uint64_t)svq->vring.used + vhost_svq_device_area_size(svq) - 1 <
> +           (uint64_t)svq->vring.desc) {
> +                error_report("Invalid shadow vring location");
> +                return -ENOMEM;
> +        }

Why does this check exist?

What needs to be done here is proper bounds checking. That either `.used 
+ device_area_size()` or `desc + vhost_svq_vring_total_size()` does not 
exceed the end of the memory region that has been allocated for the 
vrings. It is clear that such an allocation would never wrap around the 
end of memory because no allocation ever does.

> +    }
>       svq->desc_state = g_new0(SVQDescState, svq->vring.num);
>       if (virtio_vdev_has_feature(svq->vdev, VIRTIO_F_IN_ORDER)) {
>           svq->batch_last.id = VIRTIO_RING_NOT_IN_BATCH;
> @@ -884,6 +919,8 @@ void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
>               svq->desc_state[i].next = i + 1;
>           }
>       }
> +
> +    return 0;
>   }
>   
>   /**
> @@ -920,8 +957,19 @@ void vhost_svq_stop(VhostShadowVirtqueue *svq)
>       }
>       svq->vq = NULL;
>       g_free(svq->desc_state);
> -    munmap(svq->vring.desc, vhost_svq_driver_area_size(svq));
> -    munmap(svq->vring.used, vhost_svq_device_area_size(svq));
> +
> +    if (!svq->base_addr) {
> +        munmap(svq->vring.desc, vhost_svq_driver_area_size(svq));
> +        munmap(svq->vring.used, vhost_svq_device_area_size(svq));
> +    } else{
> +        if (svq->vring.desc) {
> +            memset(svq->vring.desc, 0, vhost_svq_driver_area_size(svq));
> +        }
> +        if (svq->vring.used) {
> +            memset(svq->vring.used, 0, vhost_svq_device_area_size(svq));
> +        }

Why the memset()?

Hanna

> +    }
> +
>       event_notifier_set_handler(&svq->hdev_call, NULL);
>   }
>   
> @@ -940,6 +988,7 @@ VhostShadowVirtqueue *vhost_svq_new(const VhostShadowVirtqueueOps *ops,
>       event_notifier_init_fd(&svq->svq_kick, VHOST_FILE_UNBIND);
>       svq->ops = ops;
>       svq->ops_opaque = ops_opaque;
> +    svq->base_addr = NULL;
>       return svq;
>   }
>   
> diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-virtqueue.h
> index fd68319fb7..1e0cc9e5e4 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.h
> +++ b/hw/virtio/vhost-shadow-virtqueue.h
> @@ -150,6 +150,9 @@ typedef struct VhostShadowVirtqueue {
>   
>       /* Size of SVQ vring free descriptors */
>       uint16_t num_free;
> +
> +    /* Location assigned to vrings if not in default anon memory map */
> +    void *base_addr;
>   } VhostShadowVirtqueue;
>   
>   bool vhost_svq_valid_features(uint64_t features, Error **errp);
> @@ -169,8 +172,9 @@ void vhost_svq_get_vring_addr(const VhostShadowVirtqueue *svq,
>                                 struct vhost_vring_addr *addr);
>   size_t vhost_svq_driver_area_size(const VhostShadowVirtqueue *svq);
>   size_t vhost_svq_device_area_size(const VhostShadowVirtqueue *svq);
> +size_t vhost_svq_vring_total_size(VirtIODevice *vdev, VirtQueue *vq);
>   
> -void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
> +int vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
>                        VirtQueue *vq, VhostIOVATree *iova_tree);
>   void vhost_svq_stop(VhostShadowVirtqueue *svq);
>   
> @@ -178,6 +182,8 @@ VhostShadowVirtqueue *vhost_svq_new(const VhostShadowVirtqueueOps *ops,
>                                       void *ops_opaque);
>   
>   void vhost_svq_free(gpointer vq);
> +void vhost_svq_set_base_addr(VhostShadowVirtqueue *svq, void *addr);
> +
>   G_DEFINE_AUTOPTR_CLEANUP_FUNC(VhostShadowVirtqueue, vhost_svq_free);
>   
>   #endif
>

