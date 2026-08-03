Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1626041A794
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 13:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764796; cv=none; b=ZQ5FchqQ38rCiTf0bFIiMg7idyR2rlcHNfg/ytsADR2QVEzhnMOa82OJiuARIDX+bUmJkivLFFN5VYS080+R7hD72vGXFNaw7T2fSn38hJBASAlhfGEgLT2mIF3jBaIEh+ing1kCAmD8w/8+h1EK3PG37GYOOO+IMRcocYRZOTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764796; c=relaxed/simple;
	bh=FFavu82yxRHQZ6dV2LkuUVnzt7+h65qA5QZAYpKhB6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ek28Z331TjgFcmHVposV32nr8lPH0BBcjCtrKGtxBxWUxxogdNmPIC6JOOqZEBzLu3HEOBLkl6GoU05BKS1K+8q5Fo7/5XeK2ja+8Xe6MEgNGfx7LjSHuVts+5edPGy2NyDeyzSDnilsMhW+Ox4ufOI4ecAObAym3B4UHuMSe88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S0N8OXEO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S0N8OXEO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785764793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=clQ8oxgBiu9V0p8RvuISxI5zCabsH/c0QTq//4l9q1A=;
	b=S0N8OXEOOPRN9TglZ9i8efRwELJrca/HrRQhRW6BObJll3xna9P7jzQnoKB49N4EMX9zV2
	K2onrGYe3vrzt4yInnU2jOgncQpcFuF5wvDoyDbyXScdeDMlfO0cseibZZrcK1fYK3YYXa
	58SCNdcb5yaSAaEhhLTEc2lCPLb4QAQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-xuQHE4RDOlizDI4kSR3ntQ-1; Mon, 03 Aug 2026 09:46:25 -0400
X-MC-Unique: xuQHE4RDOlizDI4kSR3ntQ-1
X-Mimecast-MFC-AGG-ID: xuQHE4RDOlizDI4kSR3ntQ_1785764784
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4957287363bso13838565e9.0
        for <virtio-fs@lists.linux.dev>; Mon, 03 Aug 2026 06:46:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785764784; x=1786369584;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=clQ8oxgBiu9V0p8RvuISxI5zCabsH/c0QTq//4l9q1A=;
        b=kgdc6kiawJhNe4Ut28yjvqHQox2HGZD94kFLSAzwMe0Eoo8L/YaVhqgvyumV2VqqA+
         Bxjbm3/Kw3+aGcmZEkfRo3PrF5goBmQ4uvmQV8NWkPR+R7osRR3lSBpV98cHf9yWPglI
         vOwLVGoY6ERbXlYdGZzidEj1n7ICUs/AftzinNTohFOGJOTbLe5FOL821xAbD0Fk3XUH
         ombx4L10mNO6dJSeDDlazJW8aL5oA4CC0E7h4POggWxo5EggyUJbvYQtq3dViUpYJ9V+
         MMIGd7VtX2ZS9XZ62xqBdS4OJiOO3knRnaHnJGdaTwiB7iOeX+zkX97/OmnmFT8M4ImX
         jZrA==
X-Forwarded-Encrypted: i=1; AHgh+RoK4M3rW+5QRjIzcUPaurrXaZp4gLBbJiosnVh+taL/HSmCnhVrP5OoEnzlXb6E9LBKs0WigtMHenw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxc2D8HHirpgGUnJOMUFaCG/seEJBW61qhApMsXwAzV5HjZoU2w
	jifmEmNa9tjtAwQpmgSmqVbupDfWS2gY41slCI0UZzL2yq8uYB98dacfitcNcjVbvn0h5tD3Yfy
	0aO0bZTcfk7REFZcwQVeDqI64zGyByrHPwsz+wUPa/rIsRquLohvSj8pzQBOcug==
X-Gm-Gg: AR+sD10TiIGQmPHzVZEmQWUvBSl640UykQorOpNtXWHR2vEy+QwsaPJBMQI+BFJj2Lr
	SZZQEIcz3rTGIaznkCe0HTBIyoUE4Hzhbj0TTKgq3TSLGCTDkgQYzEh0PwXNoza9W3wOaQKawZM
	rKg2VAvtSsBidwQk4wu+9Q9ECh7F1M+d6rCMsjzoTXfyvQi5lkQxMxC0JgQooW1x4lgKO1zxIvH
	CIts1zxVBNGsszNW2HH7bwyyAFB9eXWg68FSmpnwHl8Mk9UHWmIDEXL30sK/dwyfmK3btbZukpR
	17zYobV0lUiKOxnjtJsUSfC6FyP1RN4pPfnktt4Xk5OgwYqVJ6ptWHYWIxp0fjsSX8b2B01Qfgi
	PSFElknCHtggj0QUAaCcGHq+DkX4iPgSnuC65ByC1GrOJL4gYq1Z1I9edHw5fTnaLMTC1EwSce9
	pQUC/TMbjMOMMzra4pnVdMVX0ArDJNMg==
X-Received: by 2002:a05:600c:628d:b0:490:e5c1:b8bf with SMTP id 5b1f17b1804b1-4980c64e4c8mr238637055e9.13.1785764784487;
        Mon, 03 Aug 2026 06:46:24 -0700 (PDT)
X-Received: by 2002:a05:600c:628d:b0:490:e5c1:b8bf with SMTP id 5b1f17b1804b1-4980c64e4c8mr238636115e9.13.1785764784079;
        Mon, 03 Aug 2026 06:46:24 -0700 (PDT)
Received: from ?IPV6:2003:cf:d73d:549a:e584:7c7b:2611:32a1? (p200300cfd73d549ae5847c7b261132a1.dip0.t-ipconnect.de. [2003:cf:d73d:549a:e584:7c7b:2611:32a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b917desm215979585e9.10.2026.08.03.06.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 06:46:23 -0700 (PDT)
Message-ID: <9478d870-641b-4f3c-a5da-9026a0ec137d@redhat.com>
Date: Mon, 3 Aug 2026 15:46:21 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 12/15] hw/virtio/vhost-user: send isolation regions to
 device
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
 <20260723-vhost-user-isolated-memory-v1-12-6b97c439eb28@gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-12-6b97c439eb28@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Lf_tHL03mrddvVvd4tR6Pno8EwCem8tBWDFv1rwX-h8_1785764784
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 24.07.26 00:30, Connor Kite wrote:
> Adds features to fill a vhost_user_set_mem_table message with the
> addresses of isolation memory regions corresponding to bounce buffers
> and vrings.
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-user.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 79 insertions(+), 1 deletion(-)
>
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index 710cf966f8..acabfb7f1c 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -625,6 +625,21 @@ static void vhost_user_fill_msg_region(struct vhost_dev *dev,
>       dst->mmap_offset = mmap_offset;
>   }
>   
> +static void vhost_user_fill_msg_region_iso(VhostUserMemoryRegion *dst,
> +                                           const struct vhost_user *u,
> +                                           const struct vhost_memory_region
> +                                           *iova_reg)
> +{
> +    assert(u != NULL && dst != NULL && iova_reg != NULL);
> +    uint64_t offset;
> +
> +    offset = iova_reg->userspace_addr - u->iso_memory.base_addr;
> +    dst->userspace_addr = iova_reg->userspace_addr;
> +    dst->memory_size = iova_reg->memory_size;
> +    dst->guest_phys_addr = iova_reg->userspace_addr;
> +    dst->mmap_offset = offset;
> +}
> +
>   static int vhost_user_fill_set_mem_table_msg(struct vhost_user *u,
>                                                struct vhost_dev *dev,
>                                                VhostUserMsg *msg,
> @@ -1136,7 +1151,33 @@ static void cleanup_isolation_regions(struct vhost_dev *dev)
>       }
>   }
>   
> -__attribute__((unused))
> +struct iova_tree_traversal_args {
> +    VhostUserMsg *msg;
> +    struct vhost_user *u;
> +    int *fds;
> +    size_t *fd_num;
> +};
> +
> +static gboolean vhost_user_iova_tree_traverse_funct(gpointer key,
> +                                                    gpointer value,
> +                                                    gpointer data)

This function name doesn’t really say what the function does, and more 
describes its type.

> +{
> +    struct iova_tree_traversal_args *args = data;
> +    struct vhost_memory_region msg_region;
> +    VhostUserMemoryRegion region_buffer;
> +    DMAMap *map = key;
> +    args->fds[*args->fd_num] = args->u->iso_memory.iso_fd;

Generally: I find it quite hard to read code where general statements 
come after a list of declarations without an empty line, especially if 
there is an empty line later. Visually, this last line to me looks like 
another variable declaration.

> +
> +    msg_region.guest_phys_addr = map->iova;
> +    msg_region.memory_size = map->size + 1;
> +    msg_region.userspace_addr = map->iova;
> +    vhost_user_fill_msg_region_iso(&region_buffer, args->u, &msg_region);
> +    args->msg->payload.memory.regions[*args->fd_num] = region_buffer;

Why does `vhost_user_fill_msg_region_iso()` exist when this is the only 
caller, and we could just fill `regions[i]` here directly?

> +    (*args->fd_num)++;

As noted by Akihiko, there needs to be some bounds checking. At least 
against `VHOST_MEMORY_BASELINE_NREGIONS`, but even better against the 
array size of `args->msg->payload.memory.regions` and the caller should 
pass the size of `fds[]` via `args`.

(And I’m also with Stefan, something with `index` would be better. Maybe 
`region_idx`.)

> +
> +    return false;
> +}
> +
>   static int init_isolation_regions(struct vhost_dev *dev,
>                                     VhostUserMsg *msg,
>                                     int *fds, size_t *fd_num)
> @@ -1234,6 +1275,24 @@ static int init_isolation_regions(struct vhost_dev *dev,
>                                         map->translated_addr);
>       }
>   
> +    struct iova_tree_traversal_args args = {
> +        .fd_num = fd_num,
> +        .fds = fds,
> +        .msg = msg,
> +        .u = u
> +    };

Personal preference: I would like `*fd_num = 0` somewhere here, or 
`assert(*fd_num == 0)` before the iteration. Yes, the caller initializes 
it to zero, but it is just not obvious here, and it seems necessary for 
correct semantics.

(And the open question whether `fd_num` should be renamed here, too, or 
can keep that name. Not sure.)

> +
> +    vhost_iova_tree_foreach(u->iso_iova_tree,
> +                            vhost_user_iova_tree_traverse_funct, &args);
> +
> +    msg->payload.memory.nregions = *fd_num;
> +
> +    assert(*fd_num != 0);

Am I wrong or should `*fd_num == nregions`? Is it possible that 
`*fd_num` is less because regions end up joined? Can you add a comment 
on when they would differ?

Hanna

> +
> +    msg->hdr.size = sizeof(msg->payload.memory.nregions);
> +    msg->hdr.size += sizeof(msg->payload.memory.padding);
> +    msg->hdr.size += *fd_num * sizeof(VhostUserMemoryRegion);
> +
>       return 0;
>   }

[...]

