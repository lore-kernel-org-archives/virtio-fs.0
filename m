Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02490213254
	for <virtio-fs@lists.linux.dev>; Fri, 28 Aug 2026 12:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787919932; cv=none; b=LHzY3LxLFOTKuryf0JziunZ/h2TFHaOLrLSAbGbjjTV4j3SWDOMcg007pLJMJAmIhOohSZQJeMmXd5+64YiiOvuf79jxYHVmA+XSzyrOwG8kvohJe2AInG8tZVwu0cq0JHbSje3brNqL/9wNNhWX/jQfVltCiYakfaoffW3YTVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787919932; c=relaxed/simple;
	bh=ruyutU3/rouWxlVPC5URCYeRv5htC4isZbFpcdv1ZyQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nxGv6Q1/zeuMlK2ZVLvoQqTU7Yu5+ngtWvWz/+BFujMQKVotL9krPRAREAcrO8ol3QezmG7i7vXO0BW4a+vM9uDPaOi1x4j0VnEpUWmI3QsIsJqeJoiQFbqWjXrSms47QsNs7CWD5HCbnofEmRXbCieqDrGYn0/ZdGb0l2gbbhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZZou42d0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZZou42d0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787919918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j0tMs94sb+aFfcub2Wo5fCNJJlmTEWWroFUOWHWnK2I=;
	b=ZZou42d0p1eYVRd0zm0KLRMZNlCY/5ZWVKgu603ZoYajQNVK7Uu7v08aze954R2EsjP/YH
	USROfuEnFH0gncl4wetWitMcTE5kEJy4ooIaf+FZ9J7ln2WSAIqYUsmH4UUHiNiO7UnTcI
	+BFYESTj7T+mv74xI4MDNwHbgUzxVlM=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-xCBEinVtMtWS1db3u19E9Q-1; Fri, 28 Aug 2026 08:25:15 -0400
X-MC-Unique: xCBEinVtMtWS1db3u19E9Q-1
X-Mimecast-MFC-AGG-ID: xCBEinVtMtWS1db3u19E9Q_1787919914
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-85da2b96c35so16429437b3.2
        for <virtio-fs@lists.linux.dev>; Fri, 28 Aug 2026 05:25:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787919914; x=1788524714;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j0tMs94sb+aFfcub2Wo5fCNJJlmTEWWroFUOWHWnK2I=;
        b=An63bgeObld6TObrajfciZs8ukwywXMusqBJYa/kEoPP9GrKfTVVFV/b/PQfrdV3Ge
         /84vqw/qqJxvy6VyvobBZtQTVd6EHzC1OZ8msQvg+oqnWqU0wTC6wXliPFKHaVwg1CQX
         ZAMv8F5Sgaq0+2mYPS6I+QLdV+AevxEPAiu8yokYa0LJzO8HZXt7wHJ24UtSVpTBqj9k
         qjYyszG9XAVvyj/wiCE6CuNhIKXAz4rK/IXCaf/Pk8gct6rHq44z916tqrQgdNCY4tgn
         /MlJL+8LwOw2o8vScraOHyIuCU8VvsilILYmQorkdjJXsRQ0HHhN+FPhxz6+J09vNIet
         1MDg==
X-Forwarded-Encrypted: i=1; AKwUvBy3J4u3g6taAk37TWiYwcw7NYV0G+QbBQ6xpjMA6ZKIRnLrtQFA1c7ZomvRCvp2CoTVLmpHWMbzHas=@lists.linux.dev
X-Gm-Message-State: AFuF++kueeYo0hx5sOfLqy40fR2eIicil3tJ7rsQ1VoOGISLF2k4lgOC
	RYq/3OLW5jlCj9sDgG6/pVbNvH9dqxRoQrDN+oOEXddMflOoZMRenS2X5KBy1MC6VqXtV9Fn49u
	WN/7MNKxRHQdbws1loiu6mgZH6qpohgBleGT7lsFp6kgw2u4eJOG1SRlA8oV0X5BZzf7zr/mL/P
	MpYifB469bhB05MrTx5SEKTXFLmjzsQjauKQJu
X-Gm-Gg: AYBFou1iKTJdyjWTZn1+6kPU80/71rR/gnWJbMgiNM111oSTzedw4ovjIQmYI4VTfNZ
	lqiLqfy2KvqJsB9D9tULOSzwqz/V8sBVgHZn9eQz2ZgetlNN7kXGaGtWVL9tzYiQJv0N98fwb2m
	u62wNexpoQCHuIIXsAS/3eOfEqsXtrDkVakwKy3LuyR4Iima1HIctkB8uzimWMS8KSMty/nzjzY
	G4+IQ3/QqwK6B6BHLaDPgfI46CAerveA4GqRRMDcEUr78WpDTUFbzfPeOY=
X-Received: by 2002:a05:690c:488a:b0:81f:3556:bc27 with SMTP id 00721157ae682-85d6e438b29mr28679527b3.27.1787919914342;
        Fri, 28 Aug 2026 05:25:14 -0700 (PDT)
X-Received: by 2002:a05:690c:488a:b0:81f:3556:bc27 with SMTP id
 00721157ae682-85d6e438b29mr28679147b3.27.1787919913708; Fri, 28 Aug 2026
 05:25:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com> <20260817-vhost-user-isolated-memory-v2-10-948aae960abb@gmail.com>
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-10-948aae960abb@gmail.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 28 Aug 2026 14:24:37 +0200
X-Gm-Features: AcwNN1Wjj8VMLhtz9l0Ffbk3zEITt7boXt6RDEeYK7jllTVfh-qHtJMSCvCGvJI
Message-ID: <CAJaqyWcLXE2ZKORTC=oBcfLQ1+oza2CvowSnfkpPqmBttHEThg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 10/13] hw/virtio/vhost-user: handle data movement
 with shadow vqs
To: Connor Kite <connorkite@gmail.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, Alyssa Ross <hi@alyssa.is>, 
	Demi Marie Obenour <demiobenour@gmail.com>, 20260817233147.2867623-1-connorkite@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YVSOwnbWPGBgm7f_rc8h88VQ706OFc4E-rBIiA4ttjo_1787919914
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 7:12=E2=80=AFAM Connor Kite <connorkite@gmail.com> =
wrote:
>
> - Add start logic for shadow virtqueues, which sets vring addresses.
> - Update logic for sending vring addresses to backend to point
>   to the shadow vrings when isolation mode is active.
> - Implement handlers for intercepted avail and used descriptors. These
>   handlers copy buffer contents between bounce buffers in the isolation
>   region and the buffers made available by the guest
> - Implement logic to stop svqs
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>  hw/virtio/vhost-shadow-virtqueue.c |   2 +-
>  hw/virtio/vhost-shadow-virtqueue.h |   1 +
>  hw/virtio/vhost-user.c             | 292 +++++++++++++++++++++++++++++++=
+++++-
>  3 files changed, 286 insertions(+), 9 deletions(-)
>
> diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-=
virtqueue.c
> index f54a61439a..80b0828d7c 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.c
> +++ b/hw/virtio/vhost-shadow-virtqueue.c
> @@ -350,7 +350,7 @@ int vhost_svq_add(VhostShadowVirtqueue *svq, const st=
ruct iovec *out_sg,
>  }
>
>  /* Convenience wrapper to add a guest's element to SVQ */
> -static int vhost_svq_add_element(VhostShadowVirtqueue *svq,
> +int vhost_svq_add_element(VhostShadowVirtqueue *svq,
>                                   VirtQueueElement *elem)
>  {
>      return vhost_svq_add(svq, elem->out_sg, elem->out_num, elem->out_add=
r,
> diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-=
virtqueue.h
> index 1e0cc9e5e4..10a8db6c39 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.h
> +++ b/hw/virtio/vhost-shadow-virtqueue.h
> @@ -183,6 +183,7 @@ VhostShadowVirtqueue *vhost_svq_new(const VhostShadow=
VirtqueueOps *ops,
>
>  void vhost_svq_free(gpointer vq);
>  void vhost_svq_set_base_addr(VhostShadowVirtqueue *svq, void *addr);
> +int vhost_svq_add_element(VhostShadowVirtqueue *svq, VirtQueueElement *e=
lem);
>
>  G_DEFINE_AUTOPTR_CLEANUP_FUNC(VhostShadowVirtqueue, vhost_svq_free);
>
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index ace328f5eb..ca3aaf7a07 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -1364,6 +1364,231 @@ static int init_isolation_regions(struct vhost_de=
v *dev,
>      return 0;
>  }
>
> +static inline int vhost_user_get_reg_idx(struct vhost_dev *dev, hwaddr g=
pa)
> +{
> +    int i;
> +    struct vhost_memory_region *reg;
> +
> +    for (i =3D 0; i < dev->mem->nregions; i++) {
> +        reg =3D dev->mem->regions + i;
> +
> +        if (gpa >=3D reg->guest_phys_addr &&
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
> +                                      void *opaque)
> +{
> +    uint64_t offset;
> +    void *dst;
> +    void *src;
> +    size_t len, rem;
> +    void *reg_last_addr;
> +    void *reg_first_addr;
> +    struct vhost_dev *dev =3D opaque;
> +    struct vhost_user *u =3D dev->opaque;
> +    void *shmem_addr =3D u->iso_mem_ctx.shared_mem_addr;
> +    size_t shmem_size =3D u->iso_mem_ctx.size;
> +    const DMAMap *map;
> +    DMAMap needle;
> +    int reg_idx;
> +
> +    for (int i =3D 0; i < elem->in_num; i++) {
> +        needle.translated_addr =3D elem->in_addr[i];
> +        needle.size =3D elem->in_sg[i].iov_len - 1;
> +        map =3D vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
> +
> +        if (!map) {
> +            return -EFAULT;
> +        }
> +
> +        offset =3D needle.translated_addr - map->translated_addr;
> +        src =3D (void *)int128_get64(int128_add(int128_make64(map->iova =
+
> +                       offset), u->iso_mem_ctx.iso_iova_offset));
> +        dst =3D elem->in_sg[i].iov_base;
> +        len =3D elem->in_sg[i].iov_len;
> +
> +        /* Confirm that buffer range is fully within iso region */
> +        if ((uint64_t)src + len - 1 > (uint64_t)shmem_addr + shmem_size =
- 1 ||
> +            (uint64_t)src + len <=3D (uint64_t)src ||
> +            (uint64_t)src < (uint64_t)shmem_addr) {
> +
> +            return -EFAULT;
> +        }
> +
> +        reg_idx =3D vhost_user_get_reg_idx(dev, needle.translated_addr);
> +        if (reg_idx < 0) {
> +            return -EFAULT;
> +        }
> +
> +        reg_first_addr =3D (void *)dev->mem->regions[reg_idx].userspace_=
addr;
> +        reg_last_addr =3D (void *)(dev->mem->regions[reg_idx].userspace_=
addr +
> +                        dev->mem->regions[reg_idx].memory_size - 1);
> +
> +        /* Confirm that hva from elem matches expected vhost memory regi=
on */
> +        if (dst < reg_first_addr || dst > reg_last_addr) {
> +            return -EFAULT;
> +        }
> +
> +        /*
> +         * copy buffer contents from shared memory into guest memory. If
> +         * the buffer extends across region boundaries, it must be split=
 and
> +         * copied to the correct regions.
> +         */
> +        while ((uint64_t)reg_last_addr - (uint64_t)dst + 1 < len) {
> +            rem =3D ((uint64_t)dst + len - 1) - (uint64_t)reg_last_addr;
> +            len -=3D rem;
> +            memcpy(dst, src, len);
> +
> +            reg_idx++;
> +            if (reg_idx >=3D dev->mem->nregions) {
> +                return -EFAULT;
> +            }
> +
> +            src =3D (void *)((uint64_t)src + len);
> +            dst =3D (void *)dev->mem->regions[reg_idx].userspace_addr;
> +            len =3D rem;
> +            reg_first_addr =3D (void *)dev->mem->regions[reg_idx].usersp=
ace_addr;
> +            reg_last_addr =3D (void *)(dev->mem->regions[reg_idx].usersp=
ace_addr +
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
> +    struct vhost_dev *dev =3D opaque;
> +    struct vhost_user *u =3D dev->opaque;
> +    void *shmem_addr =3D u->iso_mem_ctx.shared_mem_addr;
> +    size_t shmem_size =3D u->iso_mem_ctx.size;
> +    int reg_idx;
> +
> +    for (int i =3D 0; i < elem->out_num; i++) {
> +        needle.translated_addr =3D elem->out_addr[i];
> +        needle.size =3D elem->out_sg[i].iov_len - 1;
> +        map =3D vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
> +
> +        if (!map) {
> +            return -EFAULT;
> +        }
> +
> +        offset =3D needle.translated_addr - map->translated_addr;
> +        dst =3D (void *)int128_get64(int128_add(int128_make64(map->iova =
+
> +                       offset), u->iso_mem_ctx.iso_iova_offset));
> +        src =3D elem->out_sg[i].iov_base;
> +        len =3D elem->out_sg[i].iov_len;
> +
> +        /* Confirm that buffer range is fully within iso region */
> +        if ((uint64_t)dst + len - 1 > (uint64_t)shmem_addr + shmem_size =
- 1 ||
> +            (uint64_t)dst + len <=3D (uint64_t)dst ||
> +            (uint64_t)dst < (uint64_t)shmem_addr) {
> +
> +            return -EFAULT;
> +        }
> +
> +        reg_idx =3D vhost_user_get_reg_idx(dev, needle.translated_addr);
> +        if (reg_idx < 0) {
> +            return -EFAULT;
> +        }
> +
> +        reg_first_addr =3D (void *)dev->mem->regions[reg_idx].userspace_=
addr;
> +        reg_last_addr =3D (void *)(dev->mem->regions[reg_idx].userspace_=
addr +
> +                        dev->mem->regions[reg_idx].memory_size - 1);
> +
> +        /* Confirm that hva from elem matches expected vhost memory regi=
on */
> +        if (src < reg_first_addr || src > reg_last_addr) {
> +            return -EFAULT;
> +        }
> +
> +        /*
> +         * copy buffer contents from guest memory into shared memory. If
> +         * the buffer extends across region boundaries, it must be split=
 and
> +         * copied from the correct regions.
> +         */
> +        while ((uint64_t)reg_last_addr - (uint64_t)src + 1 < len) {
> +            rem =3D ((uint64_t)src + len - 1) - (uint64_t)reg_last_addr;
> +            len -=3D rem;
> +            memcpy(dst, src, len);
> +
> +            reg_idx++;
> +            if (reg_idx >=3D dev->mem->nregions) {
> +                return -EFAULT;
> +            }
> +
> +            dst =3D (void *)((uint64_t)dst + len);
> +            src =3D (void *)dev->mem->regions[reg_idx].userspace_addr;
> +            len =3D rem;
> +
> +            reg_first_addr =3D (void *)dev->mem->regions[reg_idx].usersp=
ace_addr;
> +            reg_last_addr =3D (void *)(dev->mem->regions[reg_idx].usersp=
ace_addr +
> +                            dev->mem->regions[reg_idx].memory_size - 1);
> +        }
> +
> +        memcpy(dst, src, len);
> +    }
> +
> +    vhost_svq_add_element(svq, elem);
> +
> +    return 0;
> +}

You can handle all buffer memcpy operations within the SVQ itself, and
the net CVQ could also reuse and benefit from this. Indirect
descriptor optimizations proposed in other threads can also benefit
from this. That would make the patches much simpler.

> +
> +static int vhost_user_get_vq_index(struct vhost_dev *dev, int idx)
> +{
> +    assert(idx >=3D dev->vq_index && idx < dev->vq_index + dev->nvqs);
> +
> +    return idx;
> +}
> +
> +static int vhost_user_svqs_vring_map(struct vhost_dev *dev)
> +{
> +    int ret;
> +    struct vhost_user *u =3D dev->opaque;
> +    void *vring_base =3D u->iso_mem_ctx.vring_hva_addr;
> +    uint64_t vring_last =3D (uint64_t)vring_base +
> +                          u->iso_mem_ctx.vring_region_size - 1;
> +
> +    for (int i =3D 0; i < u->iso_mem_ctx.shadow_vqs->len; i++) {
> +        vhost_user_get_vq_index(dev, dev->vq_index + i); /* bounds check=
ing */
> +
> +        VirtQueue *vq =3D virtio_get_queue(dev->vdev, dev->vq_index + i)=
;
> +        VhostShadowVirtqueue *svq =3D
> +            g_ptr_array_index(u->iso_mem_ctx.shadow_vqs, i);
> +
> +        assert((uint64_t)vring_base +
> +               vhost_svq_vring_total_size(dev->vdev, vq) - 1 <=3D vring_=
last);
> +
> +        vhost_svq_set_base_addr(svq, vring_base);
> +        ret =3D vhost_svq_start(svq, dev->vdev, vq, u->iso_mem_ctx.tree)=
;
> +        if (ret < 0) {
> +            return ret;
> +        }
> +        vring_base =3D (void *)((uint64_t)vring_base +
> +                     vhost_svq_vring_total_size(dev->vdev, vq));
> +    }
> +
> +    return 0;
> +}
> +
>  static int vhost_user_set_mem_table(struct vhost_dev *dev,
>                                      struct vhost_memory *mem)
>  {
> @@ -1407,6 +1632,11 @@ static int vhost_user_set_mem_table(struct vhost_d=
ev *dev,
>              return ret;
>          }
>
> +        ret =3D vhost_user_svqs_vring_map(dev);
> +        if (ret < 0) {
> +            return ret;
> +        }
> +
>          ret =3D vhost_user_write(dev, &msg, fds, fd_num);
>          if (ret < 0) {
>              return ret;
> @@ -1763,13 +1993,6 @@ static int vhost_set_vring_file(struct vhost_dev *=
dev,
>      return 0;
>  }
>
> -static int vhost_user_get_vq_index(struct vhost_dev *dev, int idx)
> -{
> -    assert(idx >=3D dev->vq_index && idx < dev->vq_index + dev->nvqs);
> -
> -    return idx;
> -}
> -
>  static int vhost_user_set_vring_kick(struct vhost_dev *dev,
>                                       struct vhost_vring_file *file)
>  {
> @@ -1875,6 +2098,8 @@ static int vhost_user_set_vring_err(struct vhost_de=
v *dev,
>  static int vhost_user_set_vring_addr(struct vhost_dev *dev,
>                                       struct vhost_vring_addr *addr)
>  {
> +    struct vhost_user *u =3D dev->opaque;
> +    ptrdiff_t offset =3D u->iso_mem_ctx.iso_iova_offset;
>      VhostUserMsg msg =3D {
>          .hdr.request =3D VHOST_USER_SET_VRING_ADDR,
>          .hdr.flags =3D VHOST_USER_VERSION,
> @@ -1882,6 +2107,25 @@ static int vhost_user_set_vring_addr(struct vhost_=
dev *dev,
>          .hdr.size =3D sizeof(msg.payload.addr),
>      };
>
> +    if (u->user->memory_isolation) {
> +        int svq_idx;
> +        VhostShadowVirtqueue *svq;
> +        struct vhost_vring_addr svq_addr;
> +
> +        vhost_user_get_vq_index(dev, addr->index); /* bounds checking */
> +        svq_idx =3D addr->index - dev->vq_index;
> +        svq =3D g_ptr_array_index(u->iso_mem_ctx.shadow_vqs,
> +                                                      svq_idx);
> +
> +        svq_addr.avail_user_addr =3D (uint64_t)(uintptr_t)svq->vring.ava=
il -
> +                                   offset;
> +        svq_addr.desc_user_addr =3D (uint64_t)(uintptr_t)svq->vring.desc=
 - offset;
> +        svq_addr.used_user_addr =3D (uint64_t)(uintptr_t)svq->vring.used=
 - offset;
> +        svq_addr.index =3D addr->index;
> +
> +        msg.payload.addr =3D svq_addr;
> +    }
> +
>      /*
>       * wait for a reply if logging is enabled to make sure
>       * backend is actually logging changes
> @@ -2857,13 +3101,18 @@ static int vhost_user_postcopy_notifier(NotifierW=
ithReturn *notifier,
>      return 0;
>  }
>
> +static const VhostShadowVirtqueueOps vhost_user_svq_ops =3D {
> +    .avail_handler =3D vhost_user_svq_handle_avail,
> +    .used_callback =3D vhost_user_svq_handle_used
> +};
> +
>  static void vhost_user_init_svq(struct vhost_dev *dev, struct vhost_user=
 *u)
>  {
>      /*Modified from vhost-vdpa*/
>      u->iso_mem_ctx.shadow_vqs =3D g_ptr_array_new_full(dev->nvqs, vhost_=
svq_free);
>      for (int i =3D 0; i < dev->nvqs; i++) {
>          VhostShadowVirtqueue *svq;
> -        svq =3D vhost_svq_new(NULL, NULL);
> +        svq =3D vhost_svq_new(&vhost_user_svq_ops, dev);
>          g_ptr_array_add(u->iso_mem_ctx.shadow_vqs, svq);
>      }
>  }
> @@ -3562,8 +3811,35 @@ void vhost_user_async_close(DeviceState *d,
>      }
>  }
>
> +static void vhost_user_svqs_stop(struct vhost_dev *dev)
> +{
> +    struct vhost_user *u =3D dev->opaque;
> +    for (int i =3D 0; i < u->iso_mem_ctx.shadow_vqs->len; i++) {
> +        vhost_svq_stop(g_ptr_array_index(u->iso_mem_ctx.shadow_vqs, i));
> +    }
> +}
> +
>  static int vhost_user_dev_start(struct vhost_dev *dev, bool started)
>  {
> +    struct vhost_user *u =3D dev->opaque;
> +    if (u->user->memory_isolation) {
> +        if (vhost_dev_has_iommu(dev)) {
> +            error_report("Memory isolation is not supported with IOMMU e=
nabled."
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
>      if (!vhost_user_has_protocol_feature(dev, VHOST_USER_PROTOCOL_F_STAT=
US)) {
>          return 0;
>      }
>
> --
> 2.43.0
>

