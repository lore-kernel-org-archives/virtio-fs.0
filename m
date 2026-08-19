Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B510A3E0241
	for <virtio-fs@lists.linux.dev>; Wed, 19 Aug 2026 07:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787125080; cv=none; b=Ng0ZemR1qIPcT6kjtFAOGFAAXTx9MMNSpMZftlxlzP04YLNT4872Y/Ii1CyWdGbf/g4mIrcp8n3pb4TigmntoWE3de0BRbSUaT9vyAJ1TPb4T2UzKGjaTFbcLLPMFHFKzRYsb6A6TFPx2iygvy/KsadBZI+Izj6WTLkT+8yqF4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787125080; c=relaxed/simple;
	bh=icUnnMehqi2zZI3vyyQBTbn/9/wZluttgrNCCImy8M0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=o2fEOewKs9+H9BstDzqNIzbwxLisvBHkf2OsNb3jZSVQDXy9lcaZBRg52HIp1i/ql5h9/8K88GOw6cOLRuZ24MVYKTtqUmiaQnvv6djNLOUysRKQ+HCbXTrhyYVs1na3CzSuB+ALaopa8UvGgt7oXJd5S82uclIByMFBBXv4A14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=aA2wn88C; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="aA2wn88C"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 67J7bBFU038431
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 19 Aug 2026 16:37:11 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=X1iSANv2Xzab9E3KKwdI5DVTvak0itj8YdYNdoklMbo=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1787125031; v=1;
        b=aA2wn88CdjlxUOmM8KC9jZf1OI4TWJj6A0qHuc4i61M6mmXa1xFNXvFaVdF/Vhbb
         0dFybuIHjZc4R7m1Y6NqDhHxU+BcYnSlEHEWMhITVkAXUjtVBPqTLpXNlfXVwfe3
         9ccpptVxByblDdtKDgMdOJqDG4v4/4pWUpaYVHkNJvJu0iWCasVbxI5iAu8w9dXl
         x+srEDDd8s27xWFRvrCqXY9XvLwKcPv+4rWLNIQZiKk3hS+gU+k6b2p+2zDk8IS+
         sdEyyCihtPq2ohA6Gw3BZT9ZCB028gInoCH4Ihq6wyuZPhfdBrRnd/i99e6Sc1sK
         7FHBv39KVqaCc9ybLjT8vA==
Message-ID: <751864f4-83b3-47ae-bf02-ca18f300728a@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 19 Aug 2026 16:37:10 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: Re: [PATCH RFC v2 10/13] hw/virtio/vhost-user: handle data movement
 with shadow vqs
To: Connor Kite <connorkite@gmail.com>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
        Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Milan Zamazal <mzamazal@redhat.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org,
        virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        zhenwei pi <zhenwei.pi@linux.dev>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
        Jason Wang <jasowangio@gmail.com>, Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>,
        Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>,
        20260817233147.2867623-1-connorkite@gmail.com
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
 <20260817-vhost-user-isolated-memory-v2-10-948aae960abb@gmail.com>
Content-Language: en-US
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-10-948aae960abb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2026/08/18 14:12, Connor Kite wrote:
> - Add start logic for shadow virtqueues, which sets vring addresses.
> - Update logic for sending vring addresses to backend to point
>    to the shadow vrings when isolation mode is active.
> - Implement handlers for intercepted avail and used descriptors. These
>    handlers copy buffer contents between bounce buffers in the isolation
>    region and the buffers made available by the guest
> - Implement logic to stop svqs
> 
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-shadow-virtqueue.c |   2 +-
>   hw/virtio/vhost-shadow-virtqueue.h |   1 +
>   hw/virtio/vhost-user.c             | 292 ++++++++++++++++++++++++++++++++++++-
>   3 files changed, 286 insertions(+), 9 deletions(-)
> 
> diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
> index f54a61439a..80b0828d7c 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.c
> +++ b/hw/virtio/vhost-shadow-virtqueue.c
> @@ -350,7 +350,7 @@ int vhost_svq_add(VhostShadowVirtqueue *svq, const struct iovec *out_sg,
>   }
>   
>   /* Convenience wrapper to add a guest's element to SVQ */
> -static int vhost_svq_add_element(VhostShadowVirtqueue *svq,
> +int vhost_svq_add_element(VhostShadowVirtqueue *svq,
>                                    VirtQueueElement *elem)
>   {
>       return vhost_svq_add(svq, elem->out_sg, elem->out_num, elem->out_addr,
> diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-virtqueue.h
> index 1e0cc9e5e4..10a8db6c39 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.h
> +++ b/hw/virtio/vhost-shadow-virtqueue.h
> @@ -183,6 +183,7 @@ VhostShadowVirtqueue *vhost_svq_new(const VhostShadowVirtqueueOps *ops,
>   
>   void vhost_svq_free(gpointer vq);
>   void vhost_svq_set_base_addr(VhostShadowVirtqueue *svq, void *addr);
> +int vhost_svq_add_element(VhostShadowVirtqueue *svq, VirtQueueElement *elem);
>   
>   G_DEFINE_AUTOPTR_CLEANUP_FUNC(VhostShadowVirtqueue, vhost_svq_free);
>   
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index ace328f5eb..ca3aaf7a07 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -1364,6 +1364,231 @@ static int init_isolation_regions(struct vhost_dev *dev,
>       return 0;
>   }
>   
> +static inline int vhost_user_get_reg_idx(struct vhost_dev *dev, hwaddr gpa)
> +{
> +    int i;
> +    struct vhost_memory_region *reg;
> +
> +    for (i = 0; i < dev->mem->nregions; i++) {
> +        reg = dev->mem->regions + i;
> +
> +        if (gpa >= reg->guest_phys_addr &&
> +            reg->guest_phys_addr + reg->memory_size > gpa) {
> +            return i;
> +        }
> +    }
> +
> +    return -1;
> +}
> +
> +static int vhost_user_svq_handle_used(VhostShadowVirtqueue *svq,
> +                                      VirtQueueElement *elem,
> +                                      void *opaque)> +{
> +    uint64_t offset;
> +    void *dst;
> +    void *src;
> +    size_t len, rem;
> +    void *reg_last_addr;
> +    void *reg_first_addr;
> +    struct vhost_dev *dev = opaque;
> +    struct vhost_user *u = dev->opaque;
> +    void *shmem_addr = u->iso_mem_ctx.shared_mem_addr;
> +    size_t shmem_size = u->iso_mem_ctx.size;
> +    const DMAMap *map;
> +    DMAMap needle;
> +    int reg_idx;
> +
> +    for (int i = 0; i < elem->in_num; i++) {

vhost_svq_flush() has the len parameter, but this callback does not take 
it, and consequently copies every writable iovec in full, which may not 
be ideal.

> +        needle.translated_addr = elem->in_addr[i];
> +        needle.size = elem->in_sg[i].iov_len - 1;
> +        map = vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
> +
> +        if (!map) {
> +            return -EFAULT;
> +        }
> +
> +        offset = needle.translated_addr - map->translated_addr;
> +        src = (void *)int128_get64(int128_add(int128_make64(map->iova +
> +                       offset), u->iso_mem_ctx.iso_iova_offset));
> +        dst = elem->in_sg[i].iov_base;
> +        len = elem->in_sg[i].iov_len;
> +
> +        /* Confirm that buffer range is fully within iso region */
> +        if ((uint64_t)src + len - 1 > (uint64_t)shmem_addr + shmem_size - 1 ||
> +            (uint64_t)src + len <= (uint64_t)src ||
> +            (uint64_t)src < (uint64_t)shmem_addr) {
> +
> +            return -EFAULT;
> +        }
> +
> +        reg_idx = vhost_user_get_reg_idx(dev, needle.translated_addr);
> +        if (reg_idx < 0) {
> +            return -EFAULT;
> +        }
> +
> +        reg_first_addr = (void *)dev->mem->regions[reg_idx].userspace_addr;
> +        reg_last_addr = (void *)(dev->mem->regions[reg_idx].userspace_addr +
> +                        dev->mem->regions[reg_idx].memory_size - 1);
> +
> +        /* Confirm that hva from elem matches expected vhost memory region */
> +        if (dst < reg_first_addr || dst > reg_last_addr) {
> +            return -EFAULT;
> +        }
> +
> +        /*
> +         * copy buffer contents from shared memory into guest memory. If
> +         * the buffer extends across region boundaries, it must be split and
> +         * copied to the correct regions.
> +         */
> +        while ((uint64_t)reg_last_addr - (uint64_t)dst + 1 < len) {
> +            rem = ((uint64_t)dst + len - 1) - (uint64_t)reg_last_addr;
> +            len -= rem;
> +            memcpy(dst, src, len);
> +
> +            reg_idx++;
> +            if (reg_idx >= dev->mem->nregions) {
> +                return -EFAULT;
> +            }
> +
> +            src = (void *)((uint64_t)src + len);
> +            dst = (void *)dev->mem->regions[reg_idx].userspace_addr;
> +            len = rem;
> +            reg_first_addr = (void *)dev->mem->regions[reg_idx].userspace_addr;
> +            reg_last_addr = (void *)(dev->mem->regions[reg_idx].userspace_addr +
> +                            dev->mem->regions[reg_idx].memory_size - 1);
> +        }
> +
> +        memcpy(dst, src, len);
> +    }
> +
> +    return 0;
> +}
> +
> +static int vhost_user_svq_handle_avail(VhostShadowVirtqueue *svq,
> +                                       VirtQueueElement *elem,
> +                                       void *opaque)
> +{
> +    hwaddr offset;
> +    const DMAMap *map;
> +    DMAMap needle;
> +    void *dst;
> +    void *src;
> +    void *reg_first_addr;
> +    void *reg_last_addr;
> +    size_t len, rem;
> +    struct vhost_dev *dev = opaque;
> +    struct vhost_user *u = dev->opaque;
> +    void *shmem_addr = u->iso_mem_ctx.shared_mem_addr;
> +    size_t shmem_size = u->iso_mem_ctx.size;
> +    int reg_idx;
> +
> +    for (int i = 0; i < elem->out_num; i++) {
> +        needle.translated_addr = elem->out_addr[i];
> +        needle.size = elem->out_sg[i].iov_len - 1;
> +        map = vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
> +
> +        if (!map) {
> +            return -EFAULT;
> +        }
> +
> +        offset = needle.translated_addr - map->translated_addr;
> +        dst = (void *)int128_get64(int128_add(int128_make64(map->iova +
> +                       offset), u->iso_mem_ctx.iso_iova_offset));
> +        src = elem->out_sg[i].iov_base;
> +        len = elem->out_sg[i].iov_len;
> +
> +        /* Confirm that buffer range is fully within iso region */
> +        if ((uint64_t)dst + len - 1 > (uint64_t)shmem_addr + shmem_size - 1 ||
> +            (uint64_t)dst + len <= (uint64_t)dst ||
> +            (uint64_t)dst < (uint64_t)shmem_addr) {
> +
> +            return -EFAULT;
> +        }
> +
> +        reg_idx = vhost_user_get_reg_idx(dev, needle.translated_addr);
> +        if (reg_idx < 0) {
> +            return -EFAULT;
> +        }
> +
> +        reg_first_addr = (void *)dev->mem->regions[reg_idx].userspace_addr;
> +        reg_last_addr = (void *)(dev->mem->regions[reg_idx].userspace_addr +
> +                        dev->mem->regions[reg_idx].memory_size - 1);
> +
> +        /* Confirm that hva from elem matches expected vhost memory region */
> +        if (src < reg_first_addr || src > reg_last_addr) {
> +            return -EFAULT;
> +        }
> +
> +        /*
> +         * copy buffer contents from guest memory into shared memory. If
> +         * the buffer extends across region boundaries, it must be split and
> +         * copied from the correct regions.
> +         */
> +        while ((uint64_t)reg_last_addr - (uint64_t)src + 1 < len) {
> +            rem = ((uint64_t)src + len - 1) - (uint64_t)reg_last_addr;
> +            len -= rem;
> +            memcpy(dst, src, len);
> +
> +            reg_idx++;
> +            if (reg_idx >= dev->mem->nregions) {
> +                return -EFAULT;
> +            }
> +
> +            dst = (void *)((uint64_t)dst + len);
> +            src = (void *)dev->mem->regions[reg_idx].userspace_addr;
> +            len = rem;
> +
> +            reg_first_addr = (void *)dev->mem->regions[reg_idx].userspace_addr;
> +            reg_last_addr = (void *)(dev->mem->regions[reg_idx].userspace_addr +
> +                            dev->mem->regions[reg_idx].memory_size - 1);
> +        }
> +
> +        memcpy(dst, src, len);
> +    }
> +
> +    vhost_svq_add_element(svq, elem);
> +
> +    return 0;

This dismisses the return value of vhost_svq_add_element() and disables 
the handling of -ENOSPC in the caller, vhost_handle_guest_kick().

> +}
> +
> +static int vhost_user_get_vq_index(struct vhost_dev *dev, int idx)
> +{
> +    assert(idx >= dev->vq_index && idx < dev->vq_index + dev->nvqs);
> +
> +    return idx;
> +}
> +
> +static int vhost_user_svqs_vring_map(struct vhost_dev *dev)
> +{
> +    int ret;
> +    struct vhost_user *u = dev->opaque;
> +    void *vring_base = u->iso_mem_ctx.vring_hva_addr;
> +    uint64_t vring_last = (uint64_t)vring_base +
> +                          u->iso_mem_ctx.vring_region_size - 1;
> +
> +    for (int i = 0; i < u->iso_mem_ctx.shadow_vqs->len; i++) {
> +        vhost_user_get_vq_index(dev, dev->vq_index + i); /* bounds checking */
> +
> +        VirtQueue *vq = virtio_get_queue(dev->vdev, dev->vq_index + i);
> +        VhostShadowVirtqueue *svq =
> +            g_ptr_array_index(u->iso_mem_ctx.shadow_vqs, i);
> +
> +        assert((uint64_t)vring_base +
> +               vhost_svq_vring_total_size(dev->vdev, vq) - 1 <= vring_last);
> +
> +        vhost_svq_set_base_addr(svq, vring_base);
> +        ret = vhost_svq_start(svq, dev->vdev, vq, u->iso_mem_ctx.tree);
> +        if (ret < 0) {
> +            return ret;
> +        }
> +        vring_base = (void *)((uint64_t)vring_base +
> +                     vhost_svq_vring_total_size(dev->vdev, vq));
> +    }
> +
> +    return 0;
> +}
> +
>   static int vhost_user_set_mem_table(struct vhost_dev *dev,
>                                       struct vhost_memory *mem)
>   {
> @@ -1407,6 +1632,11 @@ static int vhost_user_set_mem_table(struct vhost_dev *dev,
>               return ret;
>           }
>   
> +        ret = vhost_user_svqs_vring_map(dev);
> +        if (ret < 0) {
> +            return ret;
> +        }
> +

This leads to vhost_svq_start() calls, that runs: 
event_notifier_set_handler(&svq->hdev_call, vhost_svq_handle_call)

However, svq->hdev_call may not be properly initialized because 
init_isolation_regions() above here calls cleanup_isolation_regions(), 
and that may have cleaned up svq->hdev_call.

>           ret = vhost_user_write(dev, &msg, fds, fd_num);
>           if (ret < 0) {
>               return ret;
> @@ -1763,13 +1993,6 @@ static int vhost_set_vring_file(struct vhost_dev *dev,
>       return 0;
>   }
>   
> -static int vhost_user_get_vq_index(struct vhost_dev *dev, int idx)
> -{
> -    assert(idx >= dev->vq_index && idx < dev->vq_index + dev->nvqs);
> -
> -    return idx;
> -}
> -
>   static int vhost_user_set_vring_kick(struct vhost_dev *dev,
>                                        struct vhost_vring_file *file)
>   {
> @@ -1875,6 +2098,8 @@ static int vhost_user_set_vring_err(struct vhost_dev *dev,
>   static int vhost_user_set_vring_addr(struct vhost_dev *dev,
>                                        struct vhost_vring_addr *addr)
>   {
> +    struct vhost_user *u = dev->opaque;
> +    ptrdiff_t offset = u->iso_mem_ctx.iso_iova_offset;
>       VhostUserMsg msg = {
>           .hdr.request = VHOST_USER_SET_VRING_ADDR,
>           .hdr.flags = VHOST_USER_VERSION,
> @@ -1882,6 +2107,25 @@ static int vhost_user_set_vring_addr(struct vhost_dev *dev,
>           .hdr.size = sizeof(msg.payload.addr),
>       };
>   
> +    if (u->user->memory_isolation) {
> +        int svq_idx;
> +        VhostShadowVirtqueue *svq;
> +        struct vhost_vring_addr svq_addr;
> +
> +        vhost_user_get_vq_index(dev, addr->index); /* bounds checking */
> +        svq_idx = addr->index - dev->vq_index;
> +        svq = g_ptr_array_index(u->iso_mem_ctx.shadow_vqs,
> +                                                      svq_idx);
> +
> +        svq_addr.avail_user_addr = (uint64_t)(uintptr_t)svq->vring.avail -
> +                                   offset;
> +        svq_addr.desc_user_addr = (uint64_t)(uintptr_t)svq->vring.desc - offset;
> +        svq_addr.used_user_addr = (uint64_t)(uintptr_t)svq->vring.used - offset;
> +        svq_addr.index = addr->index;
> +
> +        msg.payload.addr = svq_addr;

flags and log_guest_addr of svq_addr are left uninitialized and written 
to the backend. The current compiler’s optional stack-zeroing flag masks 
this locally, but supported older compilers need explicit initialization.

> +    }
> +
>       /*
>        * wait for a reply if logging is enabled to make sure
>        * backend is actually logging changes
> @@ -2857,13 +3101,18 @@ static int vhost_user_postcopy_notifier(NotifierWithReturn *notifier,
>       return 0;
>   }
>   
> +static const VhostShadowVirtqueueOps vhost_user_svq_ops = {
> +    .avail_handler = vhost_user_svq_handle_avail,
> +    .used_callback = vhost_user_svq_handle_used
> +};
> +
>   static void vhost_user_init_svq(struct vhost_dev *dev, struct vhost_user *u)
>   {
>       /*Modified from vhost-vdpa*/
>       u->iso_mem_ctx.shadow_vqs = g_ptr_array_new_full(dev->nvqs, vhost_svq_free);
>       for (int i = 0; i < dev->nvqs; i++) {
>           VhostShadowVirtqueue *svq;
> -        svq = vhost_svq_new(NULL, NULL);
> +        svq = vhost_svq_new(&vhost_user_svq_ops, dev);
>           g_ptr_array_add(u->iso_mem_ctx.shadow_vqs, svq);
>       }
>   }
> @@ -3562,8 +3811,35 @@ void vhost_user_async_close(DeviceState *d,
>       }
>   }
>   
> +static void vhost_user_svqs_stop(struct vhost_dev *dev)
> +{
> +    struct vhost_user *u = dev->opaque;

Please add a blank line after declaration for consistency.

> +    for (int i = 0; i < u->iso_mem_ctx.shadow_vqs->len; i++) {
> +        vhost_svq_stop(g_ptr_array_index(u->iso_mem_ctx.shadow_vqs, i));
> +    }
> +}
> +
>   static int vhost_user_dev_start(struct vhost_dev *dev, bool started)
>   {
> +    struct vhost_user *u = dev->opaque;
> +    if (u->user->memory_isolation) {
> +        if (vhost_dev_has_iommu(dev)) {
> +            error_report("Memory isolation is not supported with IOMMU enabled."
> +                         "Please disable one and try again");
> +            return -1;
> +        }
> +
> +        if (virtio_vdev_has_feature(dev->vdev, VIRTIO_F_RING_PACKED)) {
> +            error_report("Memory isolation is not supported with packed"
> +                         "vrings.  Please use split vrings");
> +            return -1;
> +        }
> +
> +        if (!started) {
> +            vhost_user_svqs_stop(dev);
> +        }
> +    }
> +

do_vhost_dev_stop() calls vhost_user_dev_start(false) before disabling 
backend vrings, and vhost_user_dev_start(false) leads to 
vhost_user_svqs_stop() here. The backend can still access those rings 
concurrently, and process requests vhost_user_svqs_stop() returned to 
the guest with virtqueue_unpop().

vhost-vdpa enforces the correct ordering by calling vhost_vdpa_suspend() 
before vhost_vdpa_svqs_stop().

Regards,
Akihiko Odaki

>       if (!vhost_user_has_protocol_feature(dev, VHOST_USER_PROTOCOL_F_STATUS)) {
>           return 0;
>       }
> 

