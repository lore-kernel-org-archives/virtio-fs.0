Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D13335E952
	for <virtio-fs@lists.linux.dev>; Tue, 25 Aug 2026 14:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787668622; cv=none; b=fMmWT9pG9ewRWjSWZMkHgOb0EZbWY4n94Mj+H+42CyquSYogDOiVs07PIHDBvWu2iMpoE+O368LBw/POarPFjjREEIpcykx3U9WkklqUrGzZSXrxViJIWqWlSwO9Z0elhZAz6cECf/GFNs8Ver5aMlcXSLIzMlWDTmHP4IJ2cEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787668622; c=relaxed/simple;
	bh=QMscUfZFYYvadyN5InWBtMxOhZR1S356FL3S9AC9wO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QqlZiMul7cmu3s5CdW0miTXnWS1wpSnIENl5ooJAXMq7jtadiMWFug5mjFv/I0qhagYuPxatsb05V3TdlVru9kX80kf9VIesHmPbnn5Drk4W77P8CZoeXVuyLL2DNmx+j6O4+WiyyhEANRt80cSfZO7QHlnYQx5D4NqNDp8vHLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZPxEG3vp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZPxEG3vp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787668619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Y6U34bGx3veeh8PYVBNu/tfNq9cvpQ+I7J9hPo13VE=;
	b=ZPxEG3vpt3LksOCcXgc7kPqWcLL3gFQSvsmPKXLa2+7aulHTOaC0LvukXcOiqCEb8WUOCI
	Cv2RKfL/wCYQEHD/cpdIRCTX5xrWsfioC1qiE6XJ7rsUJBjO81IZhXtrqk/qcck0hmIHLV
	aEZ4+NAVGZMtUW6DM/U7lh0d3wS4IOk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-_0puW1M8O92afKLLwLsnIg-1; Tue, 25 Aug 2026 10:36:58 -0400
X-MC-Unique: _0puW1M8O92afKLLwLsnIg-1
X-Mimecast-MFC-AGG-ID: _0puW1M8O92afKLLwLsnIg_1787668617
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-69c20d1d150so4034416a12.0
        for <virtio-fs@lists.linux.dev>; Tue, 25 Aug 2026 07:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787668617; x=1788273417;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4Y6U34bGx3veeh8PYVBNu/tfNq9cvpQ+I7J9hPo13VE=;
        b=tNUOQThqDnjIxzuSwGAkPDOdL8d6r1220NvT+OlvWTGhBB9aQABpLjVi70WyhrAxbK
         Z/FPvqHXmq2lPBnVT2bcJO5tD8bAnjA/+0mRz5r3yTbK5nDez4NRJOikNs7ulGv+wJPQ
         QMnHUrZhivnBTYnQ9/EeyGkWth0tP/51SPnAHTjG/p4CS6HQaPaHQTRb/zsbF1pYy2PZ
         1W1tA2f5VGiTOgjSCmK1Mg6WylLhW6LUme/uJCkx4egSX4hK630Lmf59gI1X3Dnlplo+
         s/AVmA8A2+ogiQAwjmRxjEEJyvBUX9qWN5QSyYT1kcpFfdlOF/NcmGlnRJZZhmTSE2ny
         3WhQ==
X-Forwarded-Encrypted: i=1; AHgh+RomNRNs6E58IlFHqSYBpM8HTFlIS+IzkAsGKlWwA2PQrI0mddQ5nyUTDnBN6pa0lFZgChCpMyzO1k0=@lists.linux.dev
X-Gm-Message-State: AFuF++mgrDV5q7x70Ia3tJIjn/0AeZG5W6ZvoQSugTcWoueLRPn1VyEM
	0j4A6j9HpaoB0fZ0QhbVbikkMJp9iKMoW9FoxBeO/UnaCD+cu8uTKqPrqNPTYwwNwvQCldKJju7
	ftE488tHtgZLlQezODqzLNMfuPW4CGRDIuro76k5eNf0h2a4FobZtjvWO6AetVg==
X-Gm-Gg: AR+sD13DZShZQy1zwHpHcwPTGi8it07YJjiNqCLDPPYRC0+N0CLwqaSuQD05e4bi7cJ
	ipj7gEdbghxci+bf4hvDiyoxdL5cCYjqtUn1UdiecZCv93JPFPdEfLc0FXe3cGnzxrtztBq4Hwg
	StJbKYS8jXEow2SGSZvaJdWNb6UZFbZpQ7E9fSCXr8zTllvGDDXE3s6/oXEwsIeOzDI8limj7FH
	IQFILRa9vPp/1ExNmOHiruWxur0r330QFe49JU9Ry94Rv051vhOxbWW8sYYLCox4JTA9JNZ/LmV
	8p5ny7G3eFHTi+ZMfDrYUFuOb1yQUTcqMbi+97f/AmV2xNKU7NRUZXv7/iTXMn3SblsA05pX9Ky
	SAejd+nSGP2GtSWpitZmhzA4Ze/Pn3unloPfzIUmAPk/8KUNyE3QKC1jlFfdEiijh6+k52Qk4Qz
	hRo6+97sy6EL6wuENsEyEY7xV7gr3OSg==
X-Received: by 2002:a05:6402:2411:b0:6a3:fee5:adcf with SMTP id 4fb4d7f45d1cf-6a5c409f463mr9032309a12.1.1787668617185;
        Tue, 25 Aug 2026 07:36:57 -0700 (PDT)
X-Received: by 2002:a05:6402:2411:b0:6a3:fee5:adcf with SMTP id 4fb4d7f45d1cf-6a5c409f463mr9032231a12.1.1787668616631;
        Tue, 25 Aug 2026 07:36:56 -0700 (PDT)
Received: from ?IPV6:2003:cf:d70a:12bf:c327:80a0:6d65:31e3? (p200300cfd70a12bfc32780a06d6531e3.dip0.t-ipconnect.de. [2003:cf:d70a:12bf:c327:80a0:6d65:31e3])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a5de8d21f8sm27422a12.11.2026.08.25.07.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 07:36:55 -0700 (PDT)
Message-ID: <f543b2a9-46ed-4dcc-ba3c-650c2a7ca10d@redhat.com>
Date: Tue, 25 Aug 2026 16:36:53 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 08/13] hw/virtio/vhost-user: send isolation regions
 to device
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
 <20260817-vhost-user-isolated-memory-v2-8-948aae960abb@gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-8-948aae960abb@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JwdHgTyF7JlxUUo9thzSuFB_O8qWe0MeuxC26ovOjtk_1787668617
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18.08.26 07:12, Connor Kite wrote:
> Adds features to fill a vhost_user_set_mem_table message with the
> addresses of isolation memory regions corresponding to bounce buffers
> and vrings.
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-user.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 117 insertions(+), 1 deletion(-)
>
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index 7e9233e174..e1e5cba53d 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -1140,7 +1140,77 @@ static void cleanup_isolation_regions(struct vhost_dev *dev)
>       }
>   }
>   
> -__attribute__((unused))
> +typedef struct {
> +    VhostUserMsg *msg;
> +    struct vhost_user *u;
> +    int *fds;
> +    size_t fds_size;
> +    uint64_t vring_iova;
> +    size_t vring_size;
> +    bool vring_node_visited;
> +    size_t *idx;
> +} IOVATreeTraversalArgs;
> +
> +static gboolean vhost_user_fill_msg_reg_from_tree(gpointer key,
> +                                                  gpointer value,
> +                                                  gpointer data)
> +{
> +    IOVATreeTraversalArgs *args = data;
> +    struct vhost_user *u;
> +    VhostUserMsg *msg = args->msg;
> +    DMAMap *map = key;
> +    uint64_t offset;
> +
> +    assert(args && key && value);
> +    if (!args->vring_node_visited) {
> +        args->vring_node_visited = true;
> +        return false;
> +    }
> +
> +    u = args->u;
> +    assert(*args->idx < args->fds_size);
> +
> +    args->fds[*args->idx] = args->u->iso_mem_ctx.fd;
> +
> +    /*
> +     * If the number of regions is fixed, it would be wasteful to use one for
> +     * only the vrings. The first vhost_iova_tree element is always
> +     * reserved for the vrings, so we can simply combine the first and second
> +     * elements, which are contiguous in IOVA space, when sending regions to
> +     * the backend.
> +     */

I am not sure it makes sense to optimize here if it makes the code more 
complicated and the eventual goal would rather be to have a dedicated 
memory area for the device I/O memory rather than a full mirror of guest 
memory. Specifically because that full mirror already is quite wasteful, 
so… it was my understanding that the full mirror is mostly for testing 
anyway.

Hanna

> +    if (*args->idx == 0) {
> +        offset = u->iso_mem_ctx.vring_hva_addr - u->iso_mem_ctx.shared_mem_addr;
> +        msg->payload.memory.regions[*args->idx].userspace_addr =
> +            args->vring_iova;
> +        /*
> +         * The size from the iova tree is inclusive, so 1 is added to it.
> +         * args->vring_size is exclusive, so no addition is required.
> +         */
> +        msg->payload.memory.regions[*args->idx].memory_size =
> +            args->vring_size + map->size + 1;
> +        msg->payload.memory.regions[*args->idx].guest_phys_addr =
> +            args->vring_iova;
> +        msg->payload.memory.regions[*args->idx].mmap_offset = offset;
> +    } else {
> +        /* Use 128 bit operation in unlikely case of negative iso_iova_offset */
> +        offset = int128_get64(int128_add(int128_make64(map->iova),
> +                                        u->iso_mem_ctx.iso_iova_offset)) -
> +                (uint64_t)u->iso_mem_ctx.shared_mem_addr;
> +
> +        msg->payload.memory.regions[*args->idx].userspace_addr = map->iova;
> +        msg->payload.memory.regions[*args->idx].memory_size = map->size + 1;
> +        msg->payload.memory.regions[*args->idx].guest_phys_addr = map->iova;
> +        msg->payload.memory.regions[*args->idx].mmap_offset = offset;
> +    }
> +
> +    assert(offset + msg->payload.memory.regions[*args->idx].memory_size <=
> +        u->iso_mem_ctx.size);
> +    (*args->idx)++;
> +
> +    return false;
> +}
> +
>   static int init_isolation_regions(struct vhost_dev *dev,
>                                     VhostUserMsg *msg,
>                                     int *fds, size_t *fd_num)
> @@ -1159,6 +1229,7 @@ static int init_isolation_regions(struct vhost_dev *dev,
>       DMAMap *map;
>       DMAMap vring_map;
>       int r;
> +    IOVATreeTraversalArgs trav_args;
>   
>       msg->hdr.request = VHOST_USER_SET_MEM_TABLE;
>   
> @@ -1244,6 +1315,27 @@ static int init_isolation_regions(struct vhost_dev *dev,
>           }
>       }
>   
> +    *fd_num = 0;
> +    trav_args.idx = fd_num;
> +    trav_args.fds = fds;
> +    trav_args.msg = msg;
> +    trav_args.u = u;
> +    trav_args.vring_iova = vring_map.iova;
> +    trav_args.vring_size = total_vring_size;
> +    trav_args.fds_size = nregions;
> +    trav_args.vring_node_visited = false;
> +
> +    vhost_iova_tree_foreach(u->iso_mem_ctx.tree,
> +                            vhost_user_fill_msg_reg_from_tree, &trav_args);
> +
> +    msg->payload.memory.nregions = *fd_num;
> +
> +    assert(*fd_num == nregions);
> +
> +    msg->hdr.size = sizeof(msg->payload.memory.nregions);
> +    msg->hdr.size += sizeof(msg->payload.memory.padding);
> +    msg->hdr.size += *fd_num * sizeof(VhostUserMemoryRegion);
> +
>       return 0;
>   }
>   
> @@ -1251,6 +1343,7 @@ static int vhost_user_set_mem_table(struct vhost_dev *dev,
>                                       struct vhost_memory *mem)
>   {
>       struct vhost_user *u = dev->opaque;
> +    bool memory_isolation = u->user->memory_isolation;
>       int fds[VHOST_MEMORY_BASELINE_NREGIONS];
>       size_t fd_num = 0;
>       bool do_postcopy = u->postcopy_listen && u->postcopy_fd.handler;
> @@ -1262,6 +1355,11 @@ static int vhost_user_set_mem_table(struct vhost_dev *dev,
>       int ret;
>   
>       if (do_postcopy) {
> +        /* Postcopy is not supported with memory isolation yet */
> +        if (memory_isolation) {
> +            return -1;
> +        }
> +
>           /*
>            * Postcopy has enough differences that it's best done in it's own
>            * version
> @@ -1278,6 +1376,24 @@ static int vhost_user_set_mem_table(struct vhost_dev *dev,
>           msg.hdr.flags |= VHOST_USER_NEED_REPLY_MASK;
>       }
>   
> +    if (memory_isolation) {
> +        ret = init_isolation_regions(dev, &msg, fds, &fd_num);
> +        if (ret < 0) {
> +            return ret;
> +        }
> +
> +        ret = vhost_user_write(dev, &msg, fds, fd_num);
> +        if (ret < 0) {
> +            return ret;
> +        }
> +
> +        if (reply_supported) {
> +            return process_message_reply(dev, &msg);
> +        }
> +
> +        return 0;
> +    }
> +
>       if (config_mem_slots) {
>           ret = vhost_user_add_remove_regions(dev, &msg, reply_supported, false);
>           if (ret < 0) {
>

