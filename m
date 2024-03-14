Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD1841207
	for <virtio-fs@lists.linux.dev>; Thu, 14 Mar 2024 19:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710443193; cv=none; b=hg20+gSRNJvRed8LCre2bgdkeGHbdP+hAlYPpriYiHKiZ56pbLTF+KeXx2tDp6RTtiCUcSN73L31PB9+1524Yl+Eu1PrPUfUqwaMNDViJ1yFpAtn0ggvDb0QHGrIxWt8PDdiAPfDffEE0zUB02pfOiMxZ+SOpiS8TswmZeDvw18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710443193; c=relaxed/simple;
	bh=51L57G1kn7Wsa+kjSLg6g4R8pPRnb66zmkzUdKC5cSM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QTjOqdfOwLoonaaX+cfKLAgtaAwtUUNrwv3yABe4+Z9wwn6MfsO0iqESizCMjIkyFZecyRLmEBcMvnxrDRSLAIhiJ+lhHD2YX5TMVUyRZzjosqA9rDLx9TeUvvX1ovjShedWMpj+f+1C6YzFIzcBcLJ0kd+5zOOuLZvqHNPRXl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J9vrr5Kl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J9vrr5Kl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710443190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hjirL1/LjRJi2Fqm5GZDwwtcfSDmr/yBx4cC7oZq5g0=;
	b=J9vrr5KlODxwWlBnEUCAJHWhoPsk6l5DXZMM44fmOyHIL+aM5k4+2jk5c499gfEvX/oBAW
	wKLqqkVya8Ag7XCmT5/8UBdychh3DqTrYsdIlBFhaHQpFdI7J2/e+eU6L9nDFoMtQuQxDr
	Sx25E3G6LxUyL9lX9PsspOl8EepSM5o=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-650-wFjnO3a2XcbUcNO6WQ-1; Thu, 14 Mar 2024 15:06:28 -0400
X-MC-Unique: 650-wFjnO3a2XcbUcNO6WQ-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-60a54004e9fso25366447b3.3
        for <virtio-fs@lists.linux.dev>; Thu, 14 Mar 2024 12:06:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710443188; x=1711047988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hjirL1/LjRJi2Fqm5GZDwwtcfSDmr/yBx4cC7oZq5g0=;
        b=J3UXrvwPY9o4Y+FFTGm3h33haS3QtMN5Q3OYK//P3ybnkjWesueyMVkfIyalbLprfV
         ZTLH55o/m9eMWTRCBnh/OL5XNAVIMsrzUDoNei64SKfQpCH3xlh9H6qWZXr6+K+bhLvP
         Y2ZFWz5l/wevUUQIOL4mni39JPSx73SHpvlkfH3bi+cXq6GayrJUWuQK6+14WEVhKsQ1
         qT/8sl32O+G4Y49bbf4t5E76l28PC6a+pAqTVvEuJnemGB9eXqwS7y9MsOCCAV7trwT7
         X7UUZ0n4FXyFhKYzPEMrZh4WFmRAA5WwF7N9YH9mIBO0ClHaM3hJoCZbfOLJUx+2pVSL
         bTdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWm5s2UoPih0hy9DBXASAM21yA4CPfOrS2PxE4uQT5tCc8Qiem3Yyt7JNo/uUC8+2g6WljhXKK1eTo2etnsj6MnYed70Fv1MLjs
X-Gm-Message-State: AOJu0Yw1x3bmaVMA/4TNrY8+CYq1j0PQ9zY/08/advQr1fehuXEkzLJF
	1W+MPtSDT01+MVGDP71mdA4Hn4cHZ5mf/tepKCJ4AJBZmczGTXz2fdA4LL7VeGlmqUbCDNE9fAf
	B5Xu48xvKE8ctaPAXvaYsyyL0c549+uGapNXlAJTSuDI0N7X05Ux/9Vh7bgbfVlkRl1vffiyIJj
	LPf53ENmeDvbHGOTzmp1Gl8BtoIBHeDH7U
X-Received: by 2002:a81:9c53:0:b0:60a:a73:9516 with SMTP id n19-20020a819c53000000b0060a0a739516mr2388726ywa.47.1710443188042;
        Thu, 14 Mar 2024 12:06:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGylYrFCxeZlV3nrP6xZzh4yZUM+eQbBH7v9bTyUxXA5rBJhh3olPEO845D6EGxADRMTO6Kj92yx9pgthzBLKw=
X-Received: by 2002:a81:9c53:0:b0:60a:a73:9516 with SMTP id
 n19-20020a819c53000000b0060a0a739516mr2388706ywa.47.1710443187726; Thu, 14
 Mar 2024 12:06:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240313115412.3334962-1-jonah.palmer@oracle.com>
 <20240313115412.3334962-2-jonah.palmer@oracle.com> <CACGkMEv6bRgrV_nvZK5Tb89CvTP5Kpyj4+na4Q9F=xBOJ6=8sw@mail.gmail.com>
 <b0e4a124-cced-4cbc-9f89-b8967f5a0b2c@oracle.com> <CAJaqyWcmzuY5R8hC-zwp_mEK40sYgwHU0vhewKziQLsY2EnpLg@mail.gmail.com>
 <f173f397-965f-43f9-9ce0-b417e86d6935@oracle.com>
In-Reply-To: <f173f397-965f-43f9-9ce0-b417e86d6935@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 14 Mar 2024 20:05:51 +0100
Message-ID: <CAJaqyWfspBXGw0WE2=HBuZiBJjyWTrMm2jyB4e0mP9UkixS4Mg@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] virtio/virtio-pci: Handle extra notification data
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org, mst@redhat.com, 
	si-wei.liu@oracle.com, boris.ostrovsky@oracle.com, raphael@enfabrica.net, 
	kwolf@redhat.com, hreitz@redhat.com, pasic@linux.ibm.com, 
	borntraeger@linux.ibm.com, farman@linux.ibm.com, thuth@redhat.com, 
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com, 
	cohuck@redhat.com, pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com, 
	qemu-block@nongnu.org, qemu-s390x@nongnu.org, leiyang@redhat.com, 
	schalla@marvell.com, vattunuru@marvell.com, jerinj@marvell.com, 
	dtatulea@nvidia.com, virtio-fs@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2024 at 5:06=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
>
>
> On 3/14/24 10:55 AM, Eugenio Perez Martin wrote:
> > On Thu, Mar 14, 2024 at 1:16=E2=80=AFPM Jonah Palmer <jonah.palmer@orac=
le.com> wrote:
> >>
> >>
> >>
> >> On 3/13/24 11:01 PM, Jason Wang wrote:
> >>> On Wed, Mar 13, 2024 at 7:55=E2=80=AFPM Jonah Palmer <jonah.palmer@or=
acle.com> wrote:
> >>>>
> >>>> Add support to virtio-pci devices for handling the extra data sent
> >>>> from the driver to the device when the VIRTIO_F_NOTIFICATION_DATA
> >>>> transport feature has been negotiated.
> >>>>
> >>>> The extra data that's passed to the virtio-pci device when this
> >>>> feature is enabled varies depending on the device's virtqueue
> >>>> layout.
> >>>>
> >>>> In a split virtqueue layout, this data includes:
> >>>>    - upper 16 bits: shadow_avail_idx
> >>>>    - lower 16 bits: virtqueue index
> >>>>
> >>>> In a packed virtqueue layout, this data includes:
> >>>>    - upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
> >>>>    - lower 16 bits: virtqueue index
> >>>>
> >>>> Tested-by: Lei Yang <leiyang@redhat.com>
> >>>> Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >>>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> >>>> ---
> >>>>    hw/virtio/virtio-pci.c     | 10 +++++++---
> >>>>    hw/virtio/virtio.c         | 18 ++++++++++++++++++
> >>>>    include/hw/virtio/virtio.h |  1 +
> >>>>    3 files changed, 26 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> >>>> index cb6940fc0e..0f5c3c3b2f 100644
> >>>> --- a/hw/virtio/virtio-pci.c
> >>>> +++ b/hw/virtio/virtio-pci.c
> >>>> @@ -384,7 +384,7 @@ static void virtio_ioport_write(void *opaque, ui=
nt32_t addr, uint32_t val)
> >>>>    {
> >>>>        VirtIOPCIProxy *proxy =3D opaque;
> >>>>        VirtIODevice *vdev =3D virtio_bus_get_device(&proxy->bus);
> >>>> -    uint16_t vector;
> >>>> +    uint16_t vector, vq_idx;
> >>>>        hwaddr pa;
> >>>>
> >>>>        switch (addr) {
> >>>> @@ -408,8 +408,12 @@ static void virtio_ioport_write(void *opaque, u=
int32_t addr, uint32_t val)
> >>>>                vdev->queue_sel =3D val;
> >>>>            break;
> >>>>        case VIRTIO_PCI_QUEUE_NOTIFY:
> >>>> -        if (val < VIRTIO_QUEUE_MAX) {
> >>>> -            virtio_queue_notify(vdev, val);
> >>>> +        vq_idx =3D val;
> >>>> +        if (vq_idx < VIRTIO_QUEUE_MAX) {
> >>>> +            if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION=
_DATA)) {
> >>>> +                virtio_queue_set_shadow_avail_data(vdev, val);
> >>>> +            }
> >>>> +            virtio_queue_notify(vdev, vq_idx);
> >>>>            }
> >>>>            break;
> >>>>        case VIRTIO_PCI_STATUS:
> >>>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> >>>> index d229755eae..bcb9e09df0 100644
> >>>> --- a/hw/virtio/virtio.c
> >>>> +++ b/hw/virtio/virtio.c
> >>>> @@ -2255,6 +2255,24 @@ void virtio_queue_set_align(VirtIODevice *vde=
v, int n, int align)
> >>>>        }
> >>>>    }
> >>>>
> >>>> +void virtio_queue_set_shadow_avail_data(VirtIODevice *vdev, uint32_=
t data)
> >
> > Maybe I didn't explain well, but I think it is better to pass directly
> > idx to a VirtQueue *. That way only the caller needs to check for a
> > valid vq idx, and (my understanding is) the virtio.c interface is
> > migrating to VirtQueue * use anyway.
> >
>
> Oh, are you saying to just pass in a VirtQueue *vq instead of
> VirtIODevice *vdev and get rid of the vq->vring.desc check in the functio=
n?
>

No, that needs to be kept. I meant the access to vdev->vq[i] without
checking for a valid i.

You can get the VirtQueue in the caller with virtio_get_queue. Which
also does not check for a valid index, but that way is clearer the
caller needs to check it.

As a side note, the check for desc !=3D 0 is widespread in QEMU but the
driver may use 0 address for desc, so it's not 100% valid. But to
change that now requires a deeper change out of the scope of this
series, so let's keep it for now :).

Thanks!

> >>>> +{
> >>>> +    /* Lower 16 bits is the virtqueue index */
> >>>> +    uint16_t i =3D data;
> >>>> +    VirtQueue *vq =3D &vdev->vq[i];
> >>>> +
> >>>> +    if (!vq->vring.desc) {
> >>>> +        return;
> >>>> +    }
> >>>> +
> >>>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
> >>>> +        vq->shadow_avail_wrap_counter =3D (data >> 31) & 0x1;
> >>>> +        vq->shadow_avail_idx =3D (data >> 16) & 0x7FFF;
> >>>> +    } else {
> >>>> +        vq->shadow_avail_idx =3D (data >> 16);
> >>>
> >>> Do we need to do a sanity check for this value?
> >>>
> >>> Thanks
> >>>
> >>
> >> It can't hurt, right? What kind of check did you have in mind?
> >>
> >> if (vq->shadow_avail_idx >=3D vq->vring.num)
> >>
> >
> > I'm a little bit lost too. shadow_avail_idx can take all uint16_t
> > values. Maybe you meant checking for a valid vq index, Jason?
> >
> > Thanks!
> >
> >> Or something else?
> >>
> >>>> +    }
> >>>> +}
> >>>> +
> >>>>    static void virtio_queue_notify_vq(VirtQueue *vq)
> >>>>    {
> >>>>        if (vq->vring.desc && vq->handle_output) {
> >>>> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> >>>> index c8f72850bc..53915947a7 100644
> >>>> --- a/include/hw/virtio/virtio.h
> >>>> +++ b/include/hw/virtio/virtio.h
> >>>> @@ -335,6 +335,7 @@ void virtio_queue_update_rings(VirtIODevice *vde=
v, int n);
> >>>>    void virtio_init_region_cache(VirtIODevice *vdev, int n);
> >>>>    void virtio_queue_set_align(VirtIODevice *vdev, int n, int align)=
;
> >>>>    void virtio_queue_notify(VirtIODevice *vdev, int n);
> >>>> +void virtio_queue_set_shadow_avail_data(VirtIODevice *vdev, uint32_=
t data);
> >>>>    uint16_t virtio_queue_vector(VirtIODevice *vdev, int n);
> >>>>    void virtio_queue_set_vector(VirtIODevice *vdev, int n, uint16_t =
vector);
> >>>>    int virtio_queue_set_host_notifier_mr(VirtIODevice *vdev, int n,
> >>>> --
> >>>> 2.39.3
> >>>>
> >>>
> >>
> >
>

