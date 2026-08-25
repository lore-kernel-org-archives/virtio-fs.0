Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB37481FA3
	for <virtio-fs@lists.linux.dev>; Tue, 25 Aug 2026 14:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787668464; cv=none; b=TQyYVabRLK8KBFliCfvIK+2czDyiM+PloIAnjWplHKDfPBB/9CopSs+ypcTmZ+/n9zsnC2ozCKAZMT+aMQgFTZBb/6GWZsO/eoobfkSCd+DinCAtv/7AKF1k9VlsqzNjbkXrcdhiJ7IwGkVjB8bVP5prSfagBA2of2q6f0SZW1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787668464; c=relaxed/simple;
	bh=TScNTUnJxMGKhkEHrYt79CQOI0NXUFtBtwOEfiDUAvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sxMzvU6X9dDWvKonhH8fyEu/9e4Q2zir9PHo004Xhe21itJIz114/psqbBxb94bhhnAuheJcE9Es3vVbittZ+KQ2dKiOCU2kIi6MMNQoTWLc7K0UrYNAI5w83NBIsB+IgE2b/Paq4Lr6zW9rEdrPHAWX9B1zpos5DX5ggRYYg3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gkg+0xfJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gkg+0xfJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787668460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mRS1M079aVQ1wayfOBvHmhC7RJRc/sVSNLYCJe4AUKM=;
	b=gkg+0xfJXv8jbUAN06Hf5cb/A4LCPD8FLKYuEjgD4eZZz14ee4DRL1nKFxFMZN1Ik1iie9
	zwuXKkHBgfyofROpAv3MbQeF1sKFZ7h4Ro1hvOItWG3NnHm9VQ1gMXDmLiG3bX2szdqabH
	1l1O2RIoQEAW3hjBQtDunQqcyr+pxO0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-SlIrfCX7PFmSKI-eAWqyrQ-1; Tue, 25 Aug 2026 10:34:18 -0400
X-MC-Unique: SlIrfCX7PFmSKI-eAWqyrQ-1
X-Mimecast-MFC-AGG-ID: SlIrfCX7PFmSKI-eAWqyrQ_1787668458
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c20e5890680so243711966b.1
        for <virtio-fs@lists.linux.dev>; Tue, 25 Aug 2026 07:34:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787668457; x=1788273257;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mRS1M079aVQ1wayfOBvHmhC7RJRc/sVSNLYCJe4AUKM=;
        b=s3AdP+agADpD/5vNHiYOKGFIQ4+HfCD0y8thsds/ams+3SzQxPcGo9X8N+mZG4UUzc
         v4bzd4IL1UpfsV/TaBZ04d/0a+O9JvIIWXRI8s5PKG0q7UBb0UuyPf/dTSjfTw75JtUp
         1WDguKD3M+gBewprmx/Yab94WSlPsSZxTKf2VUUFR/3pVRzb0iO2KD/hGHNNLuYNbWYq
         PfrkTQuUDfCyQ9t11l9MamEtObG6b4Feyfalg5GUjLkULtUBdmOrMWmUGOLg7DzplDLL
         Tzkt4ezQi69rBrqzWFJtYtExcTv43xBDRwJAbq/0tXBEWzTro9bIH0I4gJ5IlyOIfj9j
         qsGA==
X-Forwarded-Encrypted: i=1; AHgh+Rqp5+ZjnHA05yDozphcFVFNN8SbgxxmafwpTxKZcLk7pfr/mwOdxoUfh41i/KdXu0Pd/4zWwGZ8hJ4=@lists.linux.dev
X-Gm-Message-State: AFuF++ld7qdEVUGdX6l8icXnbXsoQ5/WtJqdjpi/1Ohk2WJjt8SnKITk
	XX+jucRhoyVZ0wegT0E56RtnPVJuogH1bpuj4nA/kIH5GoGKLNJbXsNBZvCJMYYSyE+JuQYiKvs
	6I+56DCpmjZGVbjiJ8ML6gCTDwckdjgniaV22TTzMYFFs+rAyfVWIWkDdbZ0n/A==
X-Gm-Gg: AR+sD11sAdx1dKhCEQ2YjaCi7jDN7StbZqhEO24iN1wGIQcfTIya5l3NDo0JHjb3k/O
	Vd6hzNTEHNOGGjm6hV/KzhL8GM1E0ezVNtjcWvwIuatYbdLXd6om28oGxJ9GpprPseUB15jznLD
	P6N0v/gAHE2MCdghETvtOSVSlq5QIjxIwsl+C8VPWCvFFjhmU2ZaiX2i90btQEEDDXhNqAYLfla
	mVxNOjO0PKZYHAChpkaDGBbTGHqtC8Rr1eBRfw6sITeyULgJFMbJF1Fsbwahf/Ob+D0nVTbZB8x
	lEidL5UK3PcEC19AMJtGcGZRyUYuX/1oCdxmq9K9irHiy1ZByesG8YbqRXt/niccHcXXIappOaA
	hoogzO7DLK72ApkP9+1IqvnOl6k3eZyw6oLPyfLa8aR0CVhxI5jtmZSLmVR5L9Fr27jzGSVEEGz
	vTwM67p+XJkods42kDGV5nDCVwoosPXA==
X-Received: by 2002:a17:907:b041:20b0:c25:541:fd3a with SMTP id a640c23a62f3a-c250542017fmr179143266b.7.1787668457441;
        Tue, 25 Aug 2026 07:34:17 -0700 (PDT)
X-Received: by 2002:a17:907:b041:20b0:c25:541:fd3a with SMTP id a640c23a62f3a-c250542017fmr179134466b.7.1787668456792;
        Tue, 25 Aug 2026 07:34:16 -0700 (PDT)
Received: from ?IPV6:2003:cf:d70a:12bf:c327:80a0:6d65:31e3? (p200300cfd70a12bfc32780a06d6531e3.dip0.t-ipconnect.de. [2003:cf:d70a:12bf:c327:80a0:6d65:31e3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2496866c4csm1962624066b.54.2026.08.25.07.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 07:34:16 -0700 (PDT)
Message-ID: <747e251a-3bfe-4d22-8541-7631de19ea51@redhat.com>
Date: Tue, 25 Aug 2026 16:34:11 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 07/13] hw/virtio/vhost-user: create isolation
 region
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
 <20260817-vhost-user-isolated-memory-v2-7-948aae960abb@gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-7-948aae960abb@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BJ7f1LagQxwLGzId-4RoAm3l7nZfrRxoS3oLWa3Dp_I_1787668458
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18.08.26 07:12, Connor Kite wrote:
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
>   hw/virtio/vhost-user.c | 136 +++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 136 insertions(+)

qemu does not compile with this patch applied because the 
"hw/virtio/vhost-shadow-virtqueue.h" include is missing.

> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index 1c003e4d9d..7e9233e174 100644
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
> @@ -320,6 +322,17 @@ static VhostUserMsg m __attribute__ ((unused));
>   /* The version of the protocol we support */
>   #define VHOST_USER_VERSION    (0x1)
>   
> +/* Memory region shared with back-end when memory-isolation is active */
> +typedef struct {
> +    void *shared_mem_addr; /* mapped shared memory */
> +    VhostIOVATree *tree; /* controls mapping of regions into IOVA space */
> +    void *vring_hva_addr; /* beginning of vring region in shared memory */
> +    size_t vring_region_size; /* amount of shared memory reserved for vrings */
> +    size_t size; /* size of the mapped shared memory */
> +    int fd; /* descriptor of anonymous file backing shared iso region */
> +    Int128 iso_iova_offset; /* translation from IOVA to hva of iso region */
> +} IsolationModeCtx;

Can you put the comments above each field instead of inline?

> +
>   struct vhost_user {
>       struct vhost_dev *dev;
>       /* Shared between vhost devs of the same virtio device */
> @@ -353,6 +366,9 @@ struct vhost_user {
>        * by the backend (see @features).
>        */
>       uint64_t protocol_features;
> +
> +    /* Data specfic to isolated memory mode */
> +    IsolationModeCtx iso_mem_ctx;
>   };
>   
>   struct scrub_regions {
> @@ -1112,6 +1128,125 @@ static int vhost_user_set_mem_table_postcopy(struct vhost_dev *dev,
>       return 0;
>   }
>   
> +static void cleanup_isolation_regions(struct vhost_dev *dev)
> +{
> +    struct vhost_user *u = dev->opaque;
> +    if (u->iso_mem_ctx.shared_mem_addr) {
> +        vhost_iova_tree_delete(u->iso_mem_ctx.tree);
> +        qemu_memfd_free(u->iso_mem_ctx.shared_mem_addr,
> +                        u->iso_mem_ctx.size,
> +                        u->iso_mem_ctx.fd);
> +        memset(&u->iso_mem_ctx, 0, sizeof(IsolationModeCtx));
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
> +

I don’t really feel like this empty line helps readability as it seems 
arbitrarily placed.

> +    g_autofree DMAMap *buffer_regions = g_new0(DMAMap, nregions);
> +    size_t buffer_reg_size = 0;
> +    size_t total_vring_size = 0;
> +    size_t total_mmap_size;
> +    char *reg_name;
> +    uint64_t first_IOVA_addr;
> +    uint64_t last_IOVA_addr;
> +    DMAMap *map;
> +    DMAMap vring_map;
> +    int r;
> +
> +    msg->hdr.request = VHOST_USER_SET_MEM_TABLE;
> +
> +    /* In case of reset, clear old regions */
> +    cleanup_isolation_regions(dev);
> +
> +    /* Gather information for bounce buffers to be mapped */
> +    for (u_int32_t i = 0; i < nregions; i++) {

uint32_t please, not u_int32_t.

> +        hwaddr size = ROUND_UP(dev->mem->regions[i].memory_size,
> +                      qemu_real_host_page_size());
> +        buffer_regions[i].size = size - 1;
> +        buffer_regions[i].perm = IOMMU_RW;
> +
> +        buffer_reg_size += size;
> +    }
> +
> +    /* Get space required for all vrings */
> +    for (int i = 0; i < dev->nvqs; i++) {
> +        VirtQueue *vq = virtio_get_queue(dev->vdev, dev->vq_index + i);
> +        total_vring_size += vhost_svq_vring_total_size(dev->vdev, vq);
> +    }
> +
> +    total_mmap_size = buffer_reg_size + total_vring_size;
> +    u->iso_mem_ctx.size = total_mmap_size;
> +
> +    /* Allocate and map an anonymous file to hold the isolation region */
> +    reg_name = g_strconcat("iso_mem_", dev->vdev->name, NULL);
> +    u->iso_mem_ctx.shared_mem_addr = qemu_memfd_alloc(reg_name,
> +                                     total_mmap_size,
> +                                     F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL_SEAL,
> +                                     &u->iso_mem_ctx.fd, &err);
> +
> +    assert(u->iso_mem_ctx.fd >= 0);

Does it make sense to check that before we took a look (via `err`) 
whether the function even succeeded?

> +    g_free(reg_name);
> +
> +    if (err) {
> +        error_report_err(err);
> +        cleanup_isolation_regions(dev);
> +        return -1;

Are you sure you can run cleanup_isolation_regions() if 
qemu_memfd_alloc() left some fields in basically undefined state?

General note: We usually use `goto fail` and `fail:` patterns in qemu 
for common clean-up paths (in this case cleanup_isolation_regions()).

> +    }
> +
> +    /* vhost-iova-tree enforces non-zero lower address */
> +    first_IOVA_addr = qemu_real_host_page_size();
> +    last_IOVA_addr = first_IOVA_addr + total_mmap_size - 1;
> +    assert(last_IOVA_addr > first_IOVA_addr);
> +
> +    /* Use 128-bit operation in case of large negative offset */

Yeah, as discussed (last week and with Akihiko on this thread), I think 
all 128-bit operations can be replaced by `uintptr_t` operation with its 
well-defined two's complement overflow/representation.

Hanna

> +    u->iso_mem_ctx.iso_iova_offset =
> +        int128_sub(int128_make64((uint64_t)u->iso_mem_ctx.shared_mem_addr),
> +        int128_make64(first_IOVA_addr));
> +
> +    /*
> +     * Instantiates iova tree sized to map bounce buffers and vrings to the
> +     * isolation region in host va.
> +     */
> +    u->iso_mem_ctx.tree =
> +        vhost_iova_tree_new(first_IOVA_addr, last_IOVA_addr);
> +
> +    /* Map vrings into IOVA tree */
> +    vring_map.perm = IOMMU_RW;
> +    vring_map.size = total_vring_size - 1;
> +    r = vhost_iova_tree_map_alloc(u->iso_mem_ctx.tree, &vring_map,
> +                                  (hwaddr)u->iso_mem_ctx.shared_mem_addr);
> +
> +    if (r != IOVA_OK) {
> +        cleanup_isolation_regions(dev);
> +        return r;
> +    }
> +
> +    u->iso_mem_ctx.vring_hva_addr = (void *)int128_get64(
> +                                    int128_add(int128_make64(vring_map.iova),
> +                                               u->iso_mem_ctx.iso_iova_offset));
> +    u->iso_mem_ctx.vring_region_size = total_vring_size;
> +
> +    for (int i = 0; i < nregions; i++) {
> +        map = &buffer_regions[i];
> +        r = vhost_iova_tree_map_alloc_gpa(u->iso_mem_ctx.tree, map,
> +                                          dev->mem->regions[i].guest_phys_addr);
> +
> +        if (r != IOVA_OK) {
> +            cleanup_isolation_regions(dev);
> +            return r;
> +        }
> +    }
> +
> +    return 0;
> +}
> +
>   static int vhost_user_set_mem_table(struct vhost_dev *dev,
>                                       struct vhost_memory *mem)
>   {
> @@ -2684,6 +2819,7 @@ static int vhost_user_backend_cleanup(struct vhost_dev *dev)
>       g_free(u->region_rb_offset);
>       u->region_rb_offset = NULL;
>       u->region_rb_len = 0;
> +    cleanup_isolation_regions(dev);
>       g_free(u);
>       dev->opaque = 0;
>   
>

