Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D621139AF1
	for <virtio-fs@lists.linux.dev>; Mon,  4 Mar 2024 17:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709573116; cv=none; b=nRI8zAd75W6DxoiVeXTTljQ3N7OchizHDeGNmKNThsPqKVt/DcDvKnD6V/XIIWUqfHHCCC/AZCH8937saOg2w39i7ESWNvJqaU34pdwcpNlNWa1ecQjUJK+oaVT8paX/wJnM2rINcu9AydBAjIPRfG7Z/zMLXrf9cewTxeQR8N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709573116; c=relaxed/simple;
	bh=Ya6LKfjzm9XsvcpnFKuZjJevb81/mv3zL+LK+vNLYng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sLWHwQIfC7ecRjIgv6jvCe9GuHJjQcAJ5rfhPH1LQb+FU5Flk3XpQMVe3UsjeLTTmK3CYEpTHWsitG3WILY1LKJwKf2CY6NtbecjB9I7ud9prAUNqf4hUPJ8Z/cOBNl73Dh3MB5DTltMYAW1e+2xc4eCPZVZmsaH8ElZZPFt4+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HUf2Nwzu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HUf2Nwzu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709573113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LaweyTroA2VnJXi7StgwRI1QNvEzqGs11NoMDW9yOr8=;
	b=HUf2Nwzu6dyY+iKubjuUYYVpu+trwoMHwbwYxKXsjWEu+Du5WkM8sJN181iGITYhk3NdEd
	GydREu24TTYLKe/8Fykqqu23swxecGzmgmeAplHQNzWOw8wf+hCos7luvkRbHk7t/lZQB4
	Poc5YsqYmzSYW46+tN6/gXt3I1zCha8=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-91NEB5TENnKsIlir7k3Qag-1; Mon, 04 Mar 2024 12:25:12 -0500
X-MC-Unique: 91NEB5TENnKsIlir7k3Qag-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-dc6b5d1899eso7934409276.0
        for <virtio-fs@lists.linux.dev>; Mon, 04 Mar 2024 09:25:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709573112; x=1710177912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LaweyTroA2VnJXi7StgwRI1QNvEzqGs11NoMDW9yOr8=;
        b=iOFZ3B1q66ry8YFYRZANvHYoJmZzuiVb44wIRMjKLenLUrubDSNt+JWweWz7zvYbn3
         CbgMzgfaioaqPx1owSf7HcLrHgMkfn8zQ/zv7rjEPR1A9VN67iNVJbOUVj95nQeoccHJ
         C0m5iLJXaj46QDPLAGVXk21jEqvkcSybFhABud08B7p0nXvZT2RRZ/UQIcPe3I/hgqi5
         y5Uo/NpzZmcDAtglqJcuVmNKM42GEXDZflCwjinOvAF/Vkd/Ul4pZ1vZYfvVy1UCAlOq
         gZEPWen+MYy+n5daULVO3oaQj9tDvw9aZ0DF22bNMVVi4cf1pHdTycHUJAN78vyDHQwu
         Eo3w==
X-Forwarded-Encrypted: i=1; AJvYcCULJAhf7mO/bDrkMCG0XosXR8xJDrewT7f6I1Jg3wTfKuayMV6UgdDMEx39996FxdRY1hcZUgNZbryKPmxgM32IWk7aQBCdZprb
X-Gm-Message-State: AOJu0YwHBqQ9tiY9+xlNKWll8KdlgLAX97ttUPJGLm9+LLfR5zj7+hId
	iFuELt72hgOIF12jXAwJQ5lW57JRUxzMBCwVzAjqqIPrOVXQ+mRLFBnJ0e2j6UXPnuhrvT+sYXv
	cb8Z5KVxtcHwMYkC36WOR7Fx3sajFZZ7i/gh/lHQ2jA2CAlVYgjZJMZ6GKOqES1vdVNko7jZRSW
	mTJCnfNnfOjBG0qUgIf8HPfQwJ6hxuxYvC
X-Received: by 2002:a25:903:0:b0:dc2:3a05:489 with SMTP id 3-20020a250903000000b00dc23a050489mr129835ybj.14.1709573111701;
        Mon, 04 Mar 2024 09:25:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEfociF5Qvz73m+6ENb5dn65k6dyE5og73b1/Zs8ESjiBs9FcHO39zlmih2LYsKafT9+MMb/HNyZ39dTUqy5E8=
X-Received: by 2002:a25:903:0:b0:dc2:3a05:489 with SMTP id 3-20020a250903000000b00dc23a050489mr129805ybj.14.1709573111408;
 Mon, 04 Mar 2024 09:25:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240301134330.4191007-1-jonah.palmer@oracle.com>
 <20240301134330.4191007-2-jonah.palmer@oracle.com> <CAJaqyWdokP3yqbP8wPfgttFyFWfy1O3ST4jUQmiJ+n-xkrp_Zg@mail.gmail.com>
 <964078ad-35de-4687-86e4-e3bc059481b0@oracle.com>
In-Reply-To: <964078ad-35de-4687-86e4-e3bc059481b0@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 4 Mar 2024 18:24:35 +0100
Message-ID: <CAJaqyWcnfhRA=xXHxdgF-u8gxJEAt7FQFryCrwj52N+4aLPbUQ@mail.gmail.com>
Subject: Re: [RFC 1/8] virtio/virtio-pci: Handle extra notification data
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, jasowang@redhat.com, 
	si-wei.liu@oracle.com, boris.ostrovsky@oracle.com, raphael@enfabrica.net, 
	kwolf@redhat.com, hreitz@redhat.com, pasic@linux.ibm.com, 
	borntraeger@linux.ibm.com, farman@linux.ibm.com, thuth@redhat.com, 
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com, 
	cohuck@redhat.com, pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com, 
	qemu-block@nongnu.org, qemu-s390x@nongnu.org, virtio-fs@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 4, 2024 at 6:09=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.co=
m> wrote:
>
>
>
> On 3/1/24 2:31 PM, Eugenio Perez Martin wrote:
> > On Fri, Mar 1, 2024 at 2:44=E2=80=AFPM Jonah Palmer <jonah.palmer@oracl=
e.com> wrote:
> >>
> >> Add support to virtio-pci devices for handling the extra data sent
> >> from the driver to the device when the VIRTIO_F_NOTIFICATION_DATA
> >> transport feature has been negotiated.
> >>
> >> The extra data that's passed to the virtio-pci device when this
> >> feature is enabled varies depending on the device's virtqueue
> >> layout.
> >>
> >> In a split virtqueue layout, this data includes:
> >>   - upper 16 bits: last_avail_idx
> >>   - lower 16 bits: virtqueue index
> >>
> >> In a packed virtqueue layout, this data includes:
> >>   - upper 16 bits: 1-bit wrap counter & 15-bit last_avail_idx
> >>   - lower 16 bits: virtqueue index
> >>
> >> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> >> ---
> >>   hw/virtio/virtio-pci.c     | 13 ++++++++++---
> >>   hw/virtio/virtio.c         | 13 +++++++++++++
> >>   include/hw/virtio/virtio.h |  1 +
> >>   3 files changed, 24 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> >> index 1a7039fb0c..c7c577b177 100644
> >> --- a/hw/virtio/virtio-pci.c
> >> +++ b/hw/virtio/virtio-pci.c
> >> @@ -384,7 +384,7 @@ static void virtio_ioport_write(void *opaque, uint=
32_t addr, uint32_t val)
> >>   {
> >>       VirtIOPCIProxy *proxy =3D opaque;
> >>       VirtIODevice *vdev =3D virtio_bus_get_device(&proxy->bus);
> >> -    uint16_t vector;
> >> +    uint16_t vector, vq_idx;
> >>       hwaddr pa;
> >>
> >>       switch (addr) {
> >> @@ -408,8 +408,15 @@ static void virtio_ioport_write(void *opaque, uin=
t32_t addr, uint32_t val)
> >>               vdev->queue_sel =3D val;
> >>           break;
> >>       case VIRTIO_PCI_QUEUE_NOTIFY:
> >> -        if (val < VIRTIO_QUEUE_MAX) {
> >> -            virtio_queue_notify(vdev, val);
> >> +        if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)=
) {
> >> +            vq_idx =3D val & 0xFFFF;
> >
> > Nitpick, but since vq_idx is already a uint16_t the & 0xFFFF is not
> > needed.
>
> Ah okay. I wasn't sure if it was worthwhile to keep the '& 0xFFFF' in or
> not for the sake of clarity and good practice. In that case I could just
> do away with vq_idx here and use explicit casting on 'val'.
>
> > I think it's cleaner just to call virtio_set_notification data
> > in the has_feature(...) condition, but I'm happy with this too.
>
> Do you mean something like:
>
> if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA) &&
>      virtio_set_notification_data(vdev, vq_idx, val)) {
>      ...
> }
>

Sorry I was not clear, I meant just to take out the common code of the
conditionals:
vq_idx =3D val;
if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA) {
    virtio_set_notification_data(vdev, val);
}

> Though I'm not sure what would then go in the body of this conditional,
> especially if I did something like:
>
> case VIRTIO_PCI_QUEUE_NOTIFY:
>      if ((uint16_t)val < VIRTIO_QUEUE_MAX) {
>          if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA) &&
>              virtio_set_notification_data(vdev, val)) {
>              // Not sure what to put here other than a no-op
>          }
>
>          virtio_queue_notify(vdev, (uint16_t)val);
>      }
>      break;
>
> But I'm not sure if you'd prefer this explicit casting of 'val' over
> implicit casting like:
>
> uint16_t vq_idx =3D val;
>
> >
> >> +            virtio_set_notification_data(vdev, vq_idx, val);
> >> +        } else {
> >> +            vq_idx =3D val;
> >> +        }
> >> +
> >> +        if (vq_idx < VIRTIO_QUEUE_MAX) {
> >> +            virtio_queue_notify(vdev, vq_idx);
> >>           }
> >>           break;
> >>       case VIRTIO_PCI_STATUS:
> >> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> >> index d229755eae..a61f69b7fd 100644
> >> --- a/hw/virtio/virtio.c
> >> +++ b/hw/virtio/virtio.c
> >> @@ -2052,6 +2052,19 @@ int virtio_set_status(VirtIODevice *vdev, uint8=
_t val)
> >>       return 0;
> >>   }
> >>
> >> +void virtio_set_notification_data(VirtIODevice *vdev, uint16_t i, uin=
t32_t data)
> >> +{
> >> +    VirtQueue *vq =3D &vdev->vq[i];
> >> +
> >> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
> >> +        vq->last_avail_wrap_counter =3D (data >> 31) & 0x1;
> >> +        vq->last_avail_idx =3D (data >> 16) & 0x7FFF;
> >> +    } else {
> >> +        vq->last_avail_idx =3D (data >> 16) & 0xFFFF;
> >> +    }
> >
> > It should not set last_avail_idx, only shadow_avail_idx. Otherwise,
> > QEMU can only see the descriptors placed after the notification.
> >
> > Or am I missing something?
> >
> > In that regard, I would call this function
> > "virtqueue_set_shadow_avail_idx". But I'm very bad at naming :).
>
> Ah that's right. This would make Qemu skip processing descriptors that
> might've been made available before the notification but after the
> host's last check of last_avail_idx. In other words, ignoring available
> descriptors that were placed before the notification but not yet
> processed. Good catch, thank you!
>
> So, for the packed VQ layout, we'll still want to save the wrap counter
> but for the shadow_avail_idx, right? E.g.
>
> if (virtio_vdev_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
>      vq->shadow_avail_wrap_counter =3D (data >> 31) & 0x1;
>      vq->shadow_avail_idx =3D (data >> 16) & 0x7FFF;
> } else {
>      vq->shadow_avail_idx =3D (data >> 16);
> }
>

Right, I was not clear enough again :). You probably have guessed
already but not modifying avail_wrap_counter would make QEMu to read
the wrong index too.

Thanks!

> >
> > The rest looks good to me.
> >
> > Thanks!
> >
> >> +    vq->shadow_avail_idx =3D vq->last_avail_idx;
> >> +}
> >> +
> >>   static enum virtio_device_endian virtio_default_endian(void)
> >>   {
> >>       if (target_words_bigendian()) {
> >> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> >> index c8f72850bc..c92d8afc42 100644
> >> --- a/include/hw/virtio/virtio.h
> >> +++ b/include/hw/virtio/virtio.h
> >> @@ -345,6 +345,7 @@ void virtio_queue_reset(VirtIODevice *vdev, uint32=
_t queue_index);
> >>   void virtio_queue_enable(VirtIODevice *vdev, uint32_t queue_index);
> >>   void virtio_update_irq(VirtIODevice *vdev);
> >>   int virtio_set_features(VirtIODevice *vdev, uint64_t val);
> >> +void virtio_set_notification_data(VirtIODevice *vdev, uint16_t i, uin=
t32_t data);
> >>
> >>   /* Base devices.  */
> >>   typedef struct VirtIOBlkConf VirtIOBlkConf;
> >> --
> >> 2.39.3
> >>
> >
>

