Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95403403B18
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 13:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763535; cv=none; b=Ylu7ijsCG4K0doIAPG79DZqLlCVJKxyX/KQnkg6PKTM2fc3QKV7EFBr4CzUXLT9Ahc19RazdPY+jHxMr3Jmm5hUrgq2I7jKCHVTwV35BTuNQs7TZTzcl03M630KTWVIFsg/FleYF7eFZVSY+KXcdzJwIEbHJIRXOmiXuRRS04Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763535; c=relaxed/simple;
	bh=YNyNLbc5Bgbd/oiI8jH3lJ29thhISsanmooNsji3yFE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LEzz6/F/s8EPK/KwXO9e1jj7LbgIfnryOFfLzmAELBesy8ti7oM4qoHviGjAgTc0XQvEZL5U5Vqf/X3v5k+8kMhKCmn+hUE8X2UrAVfmCJNftz8ySCkhkij6FPPPSCCFXdsyfvZ197+1/R6n5Ul8fYKCbiEC83v3QU15u/ycVeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NhXNYAIx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NhXNYAIx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785763526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rOX8diclUwjuyBFzboDXYdU0h5J72iNEgPdSzXC3oyI=;
	b=NhXNYAIxNSR2OhBzgcyK8h2l1mrq+eqXTi/DkS4XAfHlF0p21/XCZ5fBTJBYLiiRicA5cT
	yXy2p3r3X215ldHyuH0hkiXiHd24vqP7iKBRjBtHyg55CW4x8fSK52GcHD1H9xvW2U0L+K
	Y5quIx460gk4RDpVxDxl5TvaUJ/qChM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-H4U-hk2LP96lthA37YXL6Q-1; Mon, 03 Aug 2026 09:25:25 -0400
X-MC-Unique: H4U-hk2LP96lthA37YXL6Q-1
X-Mimecast-MFC-AGG-ID: H4U-hk2LP96lthA37YXL6Q_1785763524
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49545071724so22118275e9.0
        for <virtio-fs@lists.linux.dev>; Mon, 03 Aug 2026 06:25:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785763524; x=1786368324;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rOX8diclUwjuyBFzboDXYdU0h5J72iNEgPdSzXC3oyI=;
        b=eKJ7mqomdFEsQ7ICx89j6q67frNzmt7ivd9Ig9JDGv4xSqNDy1AmYOsdd+CoJj9/sY
         DvEvoVYnaQQPzw0FaSqGvdn3kwIeTT4B59LE6oFD9N0/tRKm89BEgquMUdCz78b+YlSc
         Rdmsw/c5ESGOFBeYd0ycVesxrA2jPLKTDD+uDZepm8l3dsYq9yiNmujLogffx8M0L1iP
         Uh2xZ9B87gLKyv19yIUP4Sow9B6HnP2QYR5JikGuoEtYgtktwYSixcqpO6ZPZeaRunIC
         LkRfqKy1GSgG4hmuN36eGCNKadA1lz4Z5ETuWRlSPwQDuJKmR8zLPinNuLIqfb0kg2WW
         lH0g==
X-Forwarded-Encrypted: i=1; AHgh+RpMpBXUr9TttRd7uqsP2VLTKkSL4ShNPpR9ZVNfnPQuKgBolPgKay0oFFxq7zgHE0t2rCSCS/h2AQ4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxotx8mixeJcpmdDtb2SADAjqvkLPzkrVKR0RgUsIe0T4sJ7baw
	LWio8hIWWbkcmA6CsNGnb0+Fx+pHnyayw7dJj5Q2sbesai5jtycrMamk1L4t5pIp1Sa/Z+zXnZJ
	00dgNpUmgbKH9V766SHDVO/nqZTUIE0JgxrSFDdkEB1JE8XvcELWcvZVDmpqeFg==
X-Gm-Gg: AR+sD13DmWRtyYSUEYB8sJIeLT+BJma/NvvjyFghy/ZeuUkMZMbYjNktv+4isvPNI9m
	6AAavKq5KlJT9KOXiBb34lw9JDUcEom+a+i3qNgwB77m7bxsl4sZ0FCsMRukpNGSJVRmrLJnmo9
	Z/FXmfA/OAVnIksDV9+BthCSMBeABIWjKWRFDCM9OZHaJoPByw65OS82VbsjJN75sKRM+J56r45
	kLlQpr26A9xXsbaVLmDmfRxyZ+tL/SnXSQOvatqOwYZ10SwY4ZzNpzvDgL00Y5af81jhdH6+R5o
	oqJNdRHdIQ54DXKKO6nwjAYL28d7g2SW86uCbZBSSgyZ/GtCzSIarTfG/1NwtmJBfNhkOBcdSWq
	aZfmTPDBaeDwaG9yfYi8v7VpXDEGz03xtXU1WJ7giEXspmzWATTucDb5A/OGWE+oOdtay5nGs/l
	AMpAotbucxzZPCLJn4eAeTIwBTPpkuAQ==
X-Received: by 2002:a05:600c:19cf:b0:495:7a04:b006 with SMTP id 5b1f17b1804b1-4980c66b572mr209023805e9.8.1785763524123;
        Mon, 03 Aug 2026 06:25:24 -0700 (PDT)
X-Received: by 2002:a05:600c:19cf:b0:495:7a04:b006 with SMTP id 5b1f17b1804b1-4980c66b572mr209022325e9.8.1785763523478;
        Mon, 03 Aug 2026 06:25:23 -0700 (PDT)
Received: from ?IPV6:2003:cf:d73d:549a:e584:7c7b:2611:32a1? (p200300cfd73d549ae5847c7b261132a1.dip0.t-ipconnect.de. [2003:cf:d73d:549a:e584:7c7b:2611:32a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b59a5bsm219618935e9.3.2026.08.03.06.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 06:25:22 -0700 (PDT)
Message-ID: <b6bc052c-1bf5-449b-85d0-e1c4624a5d99@redhat.com>
Date: Mon, 3 Aug 2026 15:25:19 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 11/15] hw/virtio/vhost-user: create isolation region
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
 <20260723-vhost-user-isolated-memory-v1-11-6b97c439eb28@gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-11-6b97c439eb28@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: y7fzr6J_fUT0A7sxAyCzbsYet-IUQwYvLI-_ec-fMq8_1785763524
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 24.07.26 00:30, Connor Kite wrote:
> If memory isolation mode is active for the vhost-user device adds
> features to:
> - Gather the size required for bounce buffers and vrings in shared
>    isolation region
> - Allocate the required space in an anonymous file
> - Create a vhost-iova-tree with space to map entire isolation region
> - Map guest memory regions and shared vrings into the tree
> - Release these resources upon backend cleanup
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-user.c | 129 +++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 129 insertions(+)
>
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index f296b63fb9..710cf966f8 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -18,6 +18,7 @@
>   #include "hw/virtio/vhost-backend.h"
>   #include "hw/virtio/virtio.h"
>   #include "hw/virtio/virtio-net.h"
> +#include "hw/virtio/vhost-iova-tree.h"
>   #include "chardev/char-fe.h"
>   #include "io/channel-socket.h"
>   #include "system/kvm.h"
> @@ -25,6 +26,7 @@
>   #include "qemu/main-loop.h"
>   #include "qemu/uuid.h"
>   #include "qemu/sockets.h"
> +#include "qemu/memfd.h"
>   #include "system/runstate.h"
>   #include "system/cryptodev.h"
>   #include "migration/postcopy-ram.h"
> @@ -320,6 +322,13 @@ static VhostUserMsg m __attribute__ ((unused));
>   /* The version of the protocol we support */
>   #define VHOST_USER_VERSION    (0x1)
>   
> +typedef struct IsolationRegion {
> +    uint64_t base_addr;
> +    uint64_t vring_base_addr;
> +    uint64_t size;
> +    int iso_fd;
> +} IsolationRegion;
> +

Going beyond Stefan, I would say please document each field with a 
proper doc comment, and ideally the whole struct, too.

>   struct vhost_user {
>       struct vhost_dev *dev;
>       /* Shared between vhost devs of the same virtio device */
> @@ -353,6 +362,10 @@ struct vhost_user {
>        * by the backend (see @features).
>        */
>       uint64_t protocol_features;
> +
> +    /* Isolated memory data*/

In general: Please put spaces after the leading /* and before the 
trailing */.

> +    struct IsolationRegion iso_memory;
> +    VhostIOVATree *iso_iova_tree;

Patch 13 adds more variables to this, so I think it may make sense to 
have a dedicated struct for these fields.

>   };
>   
>   struct scrub_regions {
> @@ -1109,6 +1122,121 @@ static int vhost_user_set_mem_table_postcopy(struct vhost_dev *dev,
>       return 0;
>   }
>   
> +/* TODO: Is there any notifier cleanup required here?*/
> +static void cleanup_isolation_regions(struct vhost_dev *dev)
> +{
> +    struct vhost_user *u = dev->opaque;
> +    if (u->iso_memory.base_addr) {
> +        vhost_iova_tree_delete(u->iso_iova_tree);
> +        u->iso_iova_tree = NULL;
> +        memset(&u->iso_memory, 0, sizeof(IsolationRegion));
> +        qemu_memfd_free((gpointer) u->iso_memory.base_addr, u->iso_memory.size,
> +                         u->iso_memory.iso_fd);

As Akihiko said, the memset() should come after this, and also...

> +        u->iso_memory.base_addr = 0;

...this is just a subset of the memset().

> +    }
> +}
> +
> +__attribute__((unused))
> +static int init_isolation_regions(struct vhost_dev *dev,
> +                                  VhostUserMsg *msg,
> +                                  int *fds, size_t *fd_num)
> +{
> +    Error *err = NULL;
> +    struct vhost_user *u = dev->opaque;
> +    uint32_t nregions = dev->mem->nregions;
> +    uint64_t buffer_reg_size = 0;
> +    DMAMap newEntry = {
> +        .perm = IOMMU_RW
> +    };
> +    g_autoptr(GArray) buffer_regions =
> +        g_array_new(FALSE, TRUE, sizeof(DMAMap));
> +
> +    msg->hdr.request = VHOST_USER_SET_MEM_TABLE;
> +
> +    /* In case of reset, clear old regions*/
> +    if (u->iso_memory.base_addr != 0) {
> +        cleanup_isolation_regions(dev);
> +        vhost_iova_tree_delete(u->iso_iova_tree);
> +    }

(What Akihiko said)

> +
> +    /* Gather information for bounce buffers to be mapped */
> +    for (int i = 0; i < nregions; i++) {
> +        struct vhost_memory_region *dev_region = &dev->mem->regions[i];
> +        hwaddr size = ROUND_UP(dev_region->memory_size,
> +                      qemu_real_host_page_size());
> +        newEntry.translated_addr = dev_region->guest_phys_addr;
> +        newEntry.size = size - 1;
> +        buffer_reg_size += size;
> +        g_array_append_val(buffer_regions, newEntry);
> +    }
> +
> +    int num;
> +    size_t desc_size;
> +    size_t avail_size;
> +    size_t driver_area_size;
> +    size_t device_area_size;
> +    size_t total_vring_size = 0;
> +    size_t total_mmap_size;

Please do not mix variable declarations and normal code (style.rst calls 
it “Mixed declarations”).

> +
> +    /* Get space required for all vrings */
> +    for (int j = 0; j < dev->nvqs; j++) {

Why j here and i above and below?

> +        num = virtio_queue_get_num(dev->vdev, dev->vq_index + j);
> +        desc_size = sizeof(vring_desc_t) * num;
> +        avail_size = offsetof(vring_avail_t, ring[num]) +
> +                        sizeof(uint16_t);
> +        driver_area_size = ROUND_UP(desc_size + avail_size,
> +                            qemu_real_host_page_size());
> +        device_area_size = ROUND_UP(offsetof(vring_used_t, ring[num]) +
> +                                    sizeof(uint16_t),
> +                                    qemu_real_host_page_size());
> +        total_vring_size += driver_area_size + device_area_size;
> +    }
> +
> +    total_mmap_size = buffer_reg_size + total_vring_size;
> +
> +    /* Allocate and map an anonymous file to hold the isolation region */
> +    u->iso_memory.base_addr = (uint64_t) qemu_memfd_alloc("iso_r",
> +                              total_mmap_size,
> +                              F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL_SEAL,
> +                              &u->iso_memory.iso_fd, &err);
> +    u->iso_memory.size = total_mmap_size;
> +
> +    if (err) {
> +        error_report_err(err);
> +        cleanup_isolation_regions(dev);
> +        return -1;
> +    }
> +
> +    uint64_t last_addr = int128_get64(int128_add(u->iso_memory.base_addr,
> +                                                 total_mmap_size - 1));

I would like a comment why you went for a 128-bit operation here. I 
assume it is because it checks for overflow, turning overflow into an 
assertion failure, and it can be assumed `qemu_memfd_alloc()` must 
naturally return a pointer such that adding the length of the allocated 
area to it (minus one) will never overflow?

The question is, do we even need to check for overflow then. Not that I 
mind it, in principle, I just find it non-obvious. (The more obvious 
check (imho) would be to just do a 64-bit operation and then 
assert(last_addr >= u->iso_memory.base_addr).)

> +
> +    /*
> +     * Instantiates iova tree sized to map bounce buffers and vrings to the
> +     * isolation region in host va.
> +     */
> +    u->iso_iova_tree = vhost_iova_tree_new(u->iso_memory.base_addr, last_addr);
> +
> +    assert(&u->iso_memory.iso_fd >= 0);
> +    DMAMap *map;
> +    DMAMap vring_map = {
> +        .perm = IOMMU_RW,
> +        .size = total_vring_size - 1,
> +        /*vrings are allocated on tree first, so will be assigned base addr*/
> +        .translated_addr = u->iso_memory.base_addr
> +    };
> +
> +    vhost_iova_tree_map_alloc(u->iso_iova_tree, &vring_map,
> +                              vring_map.translated_addr);
> +    u->iso_memory.vring_base_addr = vring_map.iova;
> +    for (int i = 0; i < buffer_regions->len; i++) {
> +        map = &g_array_index(buffer_regions, DMAMap, i);

God, I *really*, *really* hate this, and find it really disgusting that 
the documentation actually recommends doing this (`&g_array_index()`) 
instead of just offering a separate macro to get a reference.

And existing qemu code does it all over the place, too.

So I cannot really fault you for it.

Still. Too ugly for me to keep completely silent about it.

</rant>

Hanna

> +        vhost_iova_tree_map_alloc_gpa(u->iso_iova_tree, map,
> +                                      map->translated_addr);
> +    }
> +
> +    return 0;
> +}
> +
>   static int vhost_user_set_mem_table(struct vhost_dev *dev,
>                                       struct vhost_memory *mem)
>   {
> @@ -2681,6 +2809,7 @@ static int vhost_user_backend_cleanup(struct vhost_dev *dev)
>       g_free(u->region_rb_offset);
>       u->region_rb_offset = NULL;
>       u->region_rb_len = 0;
> +    cleanup_isolation_regions(dev);
>       g_free(u);
>       dev->opaque = 0;
>   
>

