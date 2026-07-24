Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450C233F590
	for <virtio-fs@lists.linux.dev>; Fri, 24 Jul 2026 15:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784906756; cv=none; b=ILLmgRJaZNN5g+dSFKky/PX3w7Qke3pkrvIIy2Cxe4xLsS1/x3mBo6co+fBHE12IrlFLReH9JsigUtCXu5jiw4fvakgv8xsJy/EflYCumTY7e3AZJN/im2InSigjOn0aYC4B/IdpR/u432U5yyCvGfrVzU0IMsiHTx5s9gIP4qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784906756; c=relaxed/simple;
	bh=xiuopCt5TRjWcCR4G8sH/ZaU9xMoEmzSNHfACUKyLY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MwK55taf+4WesvJEvWldaXWSAJ40GjvLT7iHuXt9dIVG7i2Gl+rfSHhBhxM4WB3LNEilHvlH34TjnhHqtSCb0LLDtA8Gq0sIuWvXpHO8mH4Kz01cCHiyazRahMVYZbdlNzVddw+FnXPySwS7uXMqoP2SSfqKH/uLwyHKVYMp4g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=OOZpcYtZ; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="OOZpcYtZ"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66OFKKNe024502
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 25 Jul 2026 00:20:20 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=v9jb6MXjdqiitUs9vf7WlucRR0zCjgf/OJRk0j6f00M=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1784906420; v=1;
        b=OOZpcYtZonav/f+jUmPa7zJX9Pk1rkxj0nfLqJTH0+nzQE+ZU4MiVB/XEH1Z5l6A
         z0UfkbV0Wizx8fvk3S4mMkAcX5vXbtTyqM9xIGgqjA3zNlIZK6iRHvq5pOp9eTEb
         o5XvGfN7LxEjOobhpGGAN/jmghoCgaqgh+/RJMB28GDz5IVFXvyV9dIUNl8YG6+X
         rZyrcMB2UJbJIsi4OCOAaxOLmYO+FAh/Qhenv1bmnOiIqPAmNpM/COvpSs14/QDn
         1tw1+n0YIRuz8g1iu7D+EbUuL2F/XrawM/m61B4VSpg6csT1x2L0mKoc/q/ZKYRq
         vt38dzN0XW3EuJRlMayrWw==
Message-ID: <f3ff63d6-6e88-4c82-9455-ca250aa42170@rsg.ci.i.u-tokyo.ac.jp>
Date: Sat, 25 Jul 2026 00:20:20 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 14/15] hw/virtio/vhost-user: handle data movement with
 shadow vqs
To: Connor Kite <connorkite@gmail.com>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
        Haixu Cui <quic_haixcui@quicinc.com>,
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
        Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-14-6b97c439eb28@gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-14-6b97c439eb28@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/07/24 7:30, Connor Kite wrote:
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
>   hw/virtio/vhost-user.c | 167 ++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 166 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index 75858289a2..e65f877f9a 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -1299,6 +1299,97 @@ static int init_isolation_regions(struct vhost_dev *dev,
>       return 0;
>   }
>   
> +static int vhost_user_memory_lookup(struct vhost_dev *dev, hwaddr gpa,
> +                                    hwaddr *hva)
> +{
> +    int i;
> +    hwaddr offset;
> +
> +    for (i = 0; i < dev->mem->nregions; i++) {
> +        struct vhost_memory_region *reg = dev->mem->regions + i;
> +
> +        if (gpa >= reg->guest_phys_addr &&
> +            reg->guest_phys_addr + reg->memory_size > gpa) {
> +            offset = gpa - reg->guest_phys_addr;
> +            *hva = reg->userspace_addr + offset;
> +            return 0;
> +        }
> +    }
> +
> +    return -EFAULT;
> +}
> +
> +static int vhost_user_svq_handle_used(VhostShadowVirtqueue *svq,
> +                                      VirtQueueElement *elem,
> +                                      void *opaque)
> +{
> +    hwaddr hva;
> +    int r;
> +    struct vhost_dev *dev = opaque;
> +
> +    for (int i = 0; i < elem->in_num; i++) {
> +        r = vhost_user_memory_lookup(dev, elem->in_addr[i], &hva);
> +        if (r < 0) {
> +            return r;
> +        }
> +
> +        memcpy((void *) hva, elem->in_sg[i].iov_base, elem->in_sg[i].iov_len);
> +        elem->in_sg[i].iov_base = (void *) hva;
> +    }
> +
> +    for (int i = 0; i < elem->out_num; i++) {
> +        r = vhost_user_memory_lookup(dev, elem->out_addr[i], &hva);
> +        if (r < 0) {
> +            return r;
> +        }
> +
> +        memcpy((void *) hva, elem->out_sg[i].iov_base, elem->out_sg[i].iov_len);
> +        elem->out_sg[i].iov_base = (void *) hva;
> +    }

This copies data in the reversed direction.

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
> +    hwaddr *iova_base;

Please make it void *.

> +
> +    for (int i = 0; i < elem->out_num; i++) {
> +        needle.translated_addr = elem->out_addr[i];
> +        needle.size = elem->out_sg[i].iov_len - 1;
> +        map = vhost_iova_tree_find_gpa(svq->iova_tree, &needle);

An error check is missing here. This translation does not seem to 
support IOMMU.

> +        offset = needle.translated_addr - map->translated_addr;
> +        iova_base = (void *)(map->iova + offset);
> +
> +        elem->out_sg[i].iov_base = iova_base;

elem->out_sg shouldn't be overwritten since virtqueue_unpop() will use 
it to unmap the element.

> +        memcpy(iova_base, elem->out_sg[i].iov_base, needle.size + 1);

This memcpy() is no-op. elem->out_sg[i].iov_base is already set to 
iova_base, so it's copying from iova_base to iova_base.

> +    }
> +
> +    for (int i = 0; i < elem->in_num; i++) {
> +        needle.translated_addr = elem->in_addr[i];
> +        needle.size = elem->in_sg[i].iov_len - 1;
> +        map = vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
> +        offset = needle.translated_addr - map->translated_addr;
> +        iova_base = (void *)(map->iova + offset);
> +
> +        elem->in_sg[i].iov_base = iova_base;
> +        memcpy(iova_base, elem->in_sg[i].iov_base, needle.size + 1);
> +    }
> +
> +    vhost_svq_add(svq, elem->out_sg, elem->out_num, elem->out_addr,
> +                  elem->in_sg, elem->in_num, elem->in_addr, elem);

An error is ignored here too.

> +
> +    return 0;
> +}
> +
> +
> +
> +
>   static int vhost_user_set_mem_table(struct vhost_dev *dev,
>                                       struct vhost_memory *mem)
>   {
> @@ -1772,6 +1863,8 @@ static int vhost_user_set_vring_err(struct vhost_dev *dev,
>   static int vhost_user_set_vring_addr(struct vhost_dev *dev,
>                                        struct vhost_vring_addr *addr)
>   {
> +    struct vhost_user *u = dev->opaque;
> +
>       VhostUserMsg msg = {
>           .hdr.request = VHOST_USER_SET_VRING_ADDR,
>           .hdr.flags = VHOST_USER_VERSION,
> @@ -1779,6 +1872,25 @@ static int vhost_user_set_vring_addr(struct vhost_dev *dev,
>           .hdr.size = sizeof(msg.payload.addr),
>       };
>   
> +    if (u->user->memory_isolation) {
> +        if (!u->svqs_allocated) {
> +            return 0;
> +        }
> +
> +        int svq_idx = addr->index - dev->vq_index;
> +        VhostShadowVirtqueue *svq = g_ptr_array_index(u->shadow_vqs,
> +                                                      svq_idx);
> +
> +        struct vhost_vring_addr svq_addr = {
> +            .avail_user_addr = (uint64_t)(uintptr_t)svq->vring.avail,
> +            .desc_user_addr = (uint64_t)(uintptr_t)svq->vring.desc,
> +            .used_user_addr = (uint64_t)(uintptr_t)svq->vring.used,
> +            .index = addr->index,
> +        };
> +
> +        msg.payload.addr = svq_addr;
> +    }
> +
>       /*
>        * wait for a reply if logging is enabled to make sure
>        * backend is actually logging changes
> @@ -2754,13 +2866,18 @@ static int vhost_user_postcopy_notifier(NotifierWithReturn *notifier,
>       return 0;
>   }
>   
> +static const VhostShadowVirtqueueOps vhost_user_svq_ops = {
> +    .avail_handler = vhost_user_svq_handle_avail,
> +    .used_handler = vhost_user_svq_handle_used
> +};
> +
>   static void vhost_user_init_svq(struct vhost_dev *dev, struct vhost_user *u)
>   {
>       /*Modified from vhost-vdpa*/
>       u->shadow_vqs = g_ptr_array_new_full(dev->nvqs, vhost_svq_free);
>       for (int i = 0; i < dev->nvqs; i++) {
>           VhostShadowVirtqueue *svq;
> -        svq = vhost_svq_new(NULL, NULL);
> +        svq = vhost_svq_new(&vhost_user_svq_ops, dev);
>           g_ptr_array_add(u->shadow_vqs, svq);
>       }
>   }
> @@ -3466,8 +3583,56 @@ void vhost_user_async_close(DeviceState *d,
>       }
>   }
>   
> +static bool vhost_user_svqs_start(struct vhost_dev *dev)
> +{
> +    struct vhost_user *u = dev->opaque;
> +    uint64_t vring_base = u->iso_memory.vring_base_addr;
> +    u->svqs_allocated = true;
> +
> +    for (int i = 0; i < u->shadow_vqs->len; i++) {
> +        VirtQueue *vq = virtio_get_queue(dev->vdev, dev->vq_index + i);
> +        VhostShadowVirtqueue *svq = g_ptr_array_index(u->shadow_vqs, i);
> +        svq->base_addr = (hwaddr *) vring_base;
> +        vhost_svq_start(svq, dev->vdev, vq, u->iso_iova_tree);

Calling vhost_svq_start() here overwrites the shadow vring index 
configured in vhost_virtqueue_start().

> +
> +        struct vhost_vring_addr addr = {
> +            .index = dev->vq_index + i,
> +            .desc_user_addr = vring_base,
> +            .avail_user_addr = vring_base + sizeof(vring_desc_t) *
> +                svq->vring.num,

This assumes the ring is split, but VIRTIO_F_RING_PACKED is not rejected.

> +            .used_user_addr = vring_base + vhost_svq_driver_area_size(svq)
> +        };
> +
> +        vhost_user_set_vring_addr(dev, &addr);


The initial ring startup is ordered incorrectly. Generic startup 
suppresses SET_VRING_ADDR, installs SET_VRING_KICK, and injects a kick; 
only the later backend-start hook creates the shadow ring and sends its 
address. SET_VRING_KICK starts the ring, so the backend can process 
before receiving valid addresses. The late SET_VRING_ADDR result is also 
ignored.

Regards,
Akihiko Odaki

> +
> +        vring_base += vhost_svq_device_area_size(svq) +
> +                      vhost_svq_driver_area_size(svq);
> +    }
> +
> +    return false;
> +}
> +
> +static void vhost_user_svqs_stop(struct vhost_dev *dev)
> +{
> +    struct vhost_user *u = dev->opaque;
> +
> +    for (int i = 0; i < u->shadow_vqs->len; i++) {
> +        vhost_svq_stop(g_ptr_array_index(u->shadow_vqs, i));
> +    }
> +}
> +
> +
>   static int vhost_user_dev_start(struct vhost_dev *dev, bool started)
>   {
> +    struct vhost_user *u = dev->opaque;
> +    if (u->user->memory_isolation) {
> +        if (started) {
> +            vhost_user_svqs_start(dev);
> +        } else {
> +            vhost_user_svqs_stop(dev);
> +        }
> +    }
> +
>       if (!vhost_user_has_protocol_feature(dev, VHOST_USER_PROTOCOL_F_STATUS)) {
>           return 0;
>       }
> 

