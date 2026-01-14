Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8186280CD5
	for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 19:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768418134; cv=none; b=XqBpZRiukABCyDXjRGizJlZUKHHrrFZgcbdDo9ZKp0qMYTbK9/7gh8zN9w0KWJaCFK5sRpX6UWjLAoLA8sKkGIPih/PE/ROvGARgXFnOtlpXw1NB4gy6Kxk8C6JbCkRJ8HazJzybyBmoNF12Xu50OFlomPWxW3ggvzBvm3Xl3Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768418134; c=relaxed/simple;
	bh=x19bFf6CBnnt49hPE5pf2Y96k3XTEty9dtM4LUxIh3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=n8ilUIhtyzvuBTec2nITgUtp/94tzzUx9sbXtDtPECnLIMGfjv7L7uTneOeSahd2h5QbUSpdkAyJqP/PkxSHaiIo1Ui/kti1ejTuBBHAi8vJTSmhSqLLLzQdYOEhF5OViXqYf0HyRjNMKyKOXR+E7P9bVX1bH9RWIzvnA1vUKGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kvw+N5xV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kvw+N5xV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768418131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fGwiQyMImMK5t0E73Nd6t81Pb4HhuJdGOtopX5erycw=;
	b=Kvw+N5xVw/tAGNhNA33GwihZRNV6UsCAXZ2qR3LS5eljReDCDnbh4ZC4dah8yhwFDzjfao
	Y5p8TaUIcHfMtBxIBmQeO4FeEtKvLQIyudNRJ9TJukebDT/vi69KceNcaWMLVSv+vJJo48
	LeZoQYeQvmZ/LNmnC/MSPgiZW/zUp/c=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-Wq4lQc4FNNq-X1ZOcJzSaw-1; Wed, 14 Jan 2026 14:15:30 -0500
X-MC-Unique: Wq4lQc4FNNq-X1ZOcJzSaw-1
X-Mimecast-MFC-AGG-ID: Wq4lQc4FNNq-X1ZOcJzSaw_1768418130
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b19a112b75so39276485a.1
        for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 11:15:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768418130; x=1769022930;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fGwiQyMImMK5t0E73Nd6t81Pb4HhuJdGOtopX5erycw=;
        b=ecTk2iojZSLtsx9UQnbmEdBaKLEFM5kN3NnUVIRKP67QdAdEV9vE5EFUC3PJ2OhJrs
         IIBzKlAkgcv0MTAkARmNRN67Pr3bazD+huI4kbfZmtSR3BZAdrAt+OXpbYZOcytV4/gL
         xGI35hWcqfHM1MiTlxd5cZ38r5ZfxTXFPfJjmGi8nHCQ/0UCp5us780YhS9/EJEgLDDP
         y46MjScDYyTFvDKVL/M5z4uORwQUI/eFxf3IEI+f+Rk6N8a6Lnr5yXScHYfyHAR/ZpYD
         pPfU4pmOaPvQyPOg8k4jOFYMB3lEsN9mir5FcRMJVuB9gGxrjoGB7S/lSaxVgDo6T5QW
         LMUw==
X-Forwarded-Encrypted: i=1; AJvYcCUwYtZ3NWQOAA67+wgTQwaE6Kav3boIJ68skwpYcC5bY/jzlV85lKnxsdYVxpPX1tEX2JCjGQ3hfvA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy33jYZwZnzHEq7+RDyr3TEDeWBtiBSBbx8VKbBqcnhGBKpHLAV
	7AFnMQKmdJ6YkMxxiH/cBWd9NmMivZ0wMU8cFPeVy55mwzLLR6sn2F8ysurPUzZTWk8giFIkxi1
	C0KHB9QBze9TnFnZjKuELYkM4KHmV3FXjAF4Ur8VUdHe1NcWQem3ntB38Swsv0g==
X-Gm-Gg: AY/fxX7n/uJ1blJQAqOblWg777gwNHtyqERmOahejFoxHReqUrEe7EtGXSH1+2lrzWT
	jay1GvD0U4U8mZH5zh1/LmAEaALX61ag/CDcWinW3L699GyKiEzuJrtyOrdSHdKyspMAbaVtkmR
	sRwDYLhUdRSeALSX/KeVlmnoZmGVyZaV5ejo0rsWC1tSNZNgBFiwY3mhXD2wnALpnPnpJy2KAhs
	/PNrarNXXo4GTPShsfFzjEczRFkxa45TBq+iQ0nlGa7wStkcGT9tOJS5GBio0hP56QoeRkbq+wp
	w8vR4hgcXkaKCPc7/4mdxFidcY+DnnyZllI9m+T/Vy872YkjCCtcVp2uwsKVSioRIpvKZFaoOkN
	8h8k=
X-Received: by 2002:a05:620a:2544:b0:8b2:64b1:692c with SMTP id af79cd13be357-8c5316a3e7amr451782985a.29.1768418130036;
        Wed, 14 Jan 2026 11:15:30 -0800 (PST)
X-Received: by 2002:a05:620a:2544:b0:8b2:64b1:692c with SMTP id af79cd13be357-8c5316a3e7amr451776785a.29.1768418129383;
        Wed, 14 Jan 2026 11:15:29 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c530a6c843sm233589185a.6.2026.01.14.11.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 11:15:28 -0800 (PST)
Date: Wed, 14 Jan 2026 14:15:27 -0500
From: Peter Xu <peterx@redhat.com>
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Cc: qemu-devel@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Zhenwei Pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raphael Norwitz <raphael@enfabrica.net>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Stefan Hajnoczi <stefanha@redhat.com>, mzamazal@redhat.com,
	Fabiano Rosas <farosas@suse.de>, qemu-block@nongnu.org,
	virtio-fs@lists.linux.dev,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH v6 4/5] vhost: add vmstate for inflight region with inner
 buffer
Message-ID: <aWfrT6JOMm9MGoIw@x1.local>
References: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
 <20260113095813.134810-5-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260113095813.134810-5-dtalexundeer@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GaVD7UOuoJj-6vO5WT4X0UrZEQakzJ5Ofj82NczrPlA_1768418130
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Jan 13, 2026 at 02:58:17PM +0500, Alexandr Moshkov wrote:
> Prepare for future inflight region migration for vhost-user-blk.
> We need to migrate size, queue_size, and inner buffer.
> 
> So firstly it migrate size and queue_size fields, then allocate memory for buffer with
> migrated size, then migrate inner buffer itself.
> 
> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> ---
>  hw/virtio/vhost.c         | 57 +++++++++++++++++++++++++++++++++++++++
>  include/hw/virtio/vhost.h |  6 +++++
>  2 files changed, 63 insertions(+)
> 
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index c46203eb9c..f655c53b67 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -2028,6 +2028,63 @@ const VMStateDescription vmstate_backend_transfer_vhost_inflight = {
>      }
>  };
>  
> +static int vhost_inflight_buffer_pre_load(void *opaque, Error **errp)
> +{
> +    info_report("vhost_inflight_region_buffer_pre_load");
> +    struct vhost_inflight *inflight = opaque;
> +
> +    int fd = -1;
> +    void *addr = qemu_memfd_alloc("vhost-inflight", inflight->size,
> +                                  F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL_SEAL,
> +                                  &fd, errp);
> +    if (*errp) {
> +        return -ENOMEM;
> +    }
> +
> +    inflight->offset = 0;
> +    inflight->addr = addr;
> +    inflight->fd = fd;
> +
> +    return 0;
> +}
> +
> +const VMStateDescription vmstate_vhost_inflight_region_buffer = {
> +    .name = "vhost-inflight-region/buffer",
> +    .pre_load_errp = vhost_inflight_buffer_pre_load,
> +    .fields = (const VMStateField[]) {
> +        VMSTATE_VBUFFER_UINT64(addr, struct vhost_inflight, 0, NULL, size),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
> +static int vhost_inflight_region_post_load(void *opaque,
> +                                           int version_id,
> +                                           Error **errp)
> +{
> +    struct vhost_inflight *inflight = opaque;
> +
> +    if (inflight->addr == NULL) {

IIUC this can never happen because pre_load() must trigger before
post_load(), and when reaching post_load() it means pre_load() must have
succeeded..

So, IIUC we can drop this post_load() completely (or assert addr in
pre_load instead).

> +        error_setg(errp, "inflight buffer subsection has not been loaded");
> +        return -EINVAL;
> +    }
> +
> +    return 0;
> +}
> +
> +const VMStateDescription vmstate_vhost_inflight_region = {
> +    .name = "vhost-inflight-region",
> +    .post_load_errp = vhost_inflight_region_post_load,
> +    .fields = (const VMStateField[]) {
> +        VMSTATE_UINT64(size, struct vhost_inflight),
> +        VMSTATE_UINT16(queue_size, struct vhost_inflight),
> +        VMSTATE_END_OF_LIST()
> +    },
> +    .subsections = (const VMStateDescription * const []) {
> +        &vmstate_vhost_inflight_region_buffer,
> +        NULL
> +    }
> +};
> +
>  const VMStateDescription vmstate_vhost_virtqueue = {
>      .name = "vhost-virtqueue",
>      .fields = (const VMStateField[]) {
> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> index 13ca2c319f..dd552de91f 100644
> --- a/include/hw/virtio/vhost.h
> +++ b/include/hw/virtio/vhost.h
> @@ -596,6 +596,12 @@ extern const VMStateDescription vmstate_backend_transfer_vhost_inflight;
>                             vmstate_backend_transfer_vhost_inflight, \
>                             struct vhost_inflight)
>  
> +extern const VMStateDescription vmstate_vhost_inflight_region;
> +#define VMSTATE_VHOST_INFLIGHT_REGION(_field, _state) \
> +    VMSTATE_STRUCT_POINTER(_field, _state, \
> +                           vmstate_vhost_inflight_region, \
> +                           struct vhost_inflight)
> +
>  extern const VMStateDescription vmstate_vhost_dev;
>  #define VMSTATE_BACKEND_TRANSFER_VHOST(_field, _state) \
>      VMSTATE_STRUCT(_field, _state, 0, vmstate_vhost_dev, struct vhost_dev)
> -- 
> 2.34.1
> 

-- 
Peter Xu

