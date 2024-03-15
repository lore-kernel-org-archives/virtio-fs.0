Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFAD17BBF
	for <virtio-fs@lists.linux.dev>; Fri, 15 Mar 2024 09:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710494678; cv=none; b=lG9EKnaWQJIDbmhEtM4rcpCnVoiTWp6CCBoAxHpaQ0vDLa7fTTyq3sUUBj+4qozTMVWPUp7x+V4AazAONJqdLiqVWp+gBj8Sci0h8zjk32cR3KSdppsdUKWlNB0rWCNOFEg0ZMXMs/R2VXMeGax1Nz7gGUioDcdJXc0Plt3ojD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710494678; c=relaxed/simple;
	bh=ll5VF2BEfciF2iZDJoYhXCUD6s2TT1ZZB4wDKShTzK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KGnD80xmbQLGKZ4vslf4hDUWFqBR9EVDFRaT0Js943l8ByyKcQVPe9f8UmCs0z8ooVRwzrFP3l9Y7jV2nQ+u1p+BnKcz7AStCWJPfD9hJ9mcEwBgPdHWglN77vYgx/HF/qdjwvxCHcdGDShnIF6YvIYtAe1KsqDkE9fpn4GCA2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aruVsjWA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aruVsjWA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710494674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mWzTJtK5+qwiIRrpV+ZanjEQ9IkwPbwutzuOE5g2BG0=;
	b=aruVsjWAi25i8lZWlRNrRTUf0XwVmomaNUjytORVSiZMg6OauoKZTY9GrzEbYyJY5Qs0OL
	+JKnk8jwpLhlugUq62w4plyozHA5nrvjPWZqAONt7MUkNMzbB1G/95XSzdtXk7O4iUQ+og
	5URaG+z8HMWDmxm+p0uxE4J/XlbZ+I8=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-BkYaAmEWPx-5mnnKmMSs3w-1; Fri, 15 Mar 2024 05:24:32 -0400
X-MC-Unique: BkYaAmEWPx-5mnnKmMSs3w-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-dc64e0fc7c8so2522403276.2
        for <virtio-fs@lists.linux.dev>; Fri, 15 Mar 2024 02:24:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710494672; x=1711099472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mWzTJtK5+qwiIRrpV+ZanjEQ9IkwPbwutzuOE5g2BG0=;
        b=ZIL62gGjM0nfGF5jhRogXneJRqqWHvV0oO56InrQBmfpOGLzrvVh75kg9Nd5CHkc5M
         c/LtOBtLVOcYUgGOMrxNNTnaMrXjt/PfMOVkZYZ91cg0sZhy6MaTmLxqD23vYDs0DUCu
         HdTvvDkJj+30nV+5k6sOMiGqVM/ZOxZJ54MnUOvhg7IVQI8Sc7f8cYretQjJeyWWKmQ0
         lny1qOPvn7g607idDwpgGQ79hZbgU8JSKerMoWz7iszCSpsWo1SdDGzbjCKU5EEfuHco
         TXKzVuNMBlUQ7CbaZV1nRenh67Kl0cgDPhxbw/dPSoZsAW/o7KOLXqKzH7njPGQk5BqU
         XKpg==
X-Forwarded-Encrypted: i=1; AJvYcCXKojfmFHWdd4Hjde48YMNhx0yxVWBUcUWC7GNJp4DB5LEPp4LQ0I541XI6q1PVc8vTV6GCZ001rr2JISR89n0G98fyssa+6/RT
X-Gm-Message-State: AOJu0Yw2z48BLxfxDaRi7/6/5dn73gPgd2OAdY4fiOPRkJfZ8pU2m/HW
	c1gW+wT1/3gWMY+aBaMbntAtrbibV+3NVwwvdhvC0mB2UP831plUk7Dp0XIpiHmWr6plWA9D7CV
	txJ8KscUPOYJEbsV5dPlUTjIQFH3RMBBWdnOK+MRZ7NRYvVJgsY9VB2Gz4asMHZj8lSFdrYA+14
	W1LCCugfZ9SPmA9coFU2yUp7ngu+szOVMb
X-Received: by 2002:a25:eb07:0:b0:dcc:623d:e475 with SMTP id d7-20020a25eb07000000b00dcc623de475mr3744498ybs.30.1710494672199;
        Fri, 15 Mar 2024 02:24:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAMFLYeYRO6dzL578Qnc5UDUuZtDFEe6QCt4Jg5JydcsCCCJqhcPyRq/IswfdyKddF3Sl7XTZbhMNwEPCDfPQ=
X-Received: by 2002:a25:eb07:0:b0:dcc:623d:e475 with SMTP id
 d7-20020a25eb07000000b00dcc623de475mr3744481ybs.30.1710494671889; Fri, 15 Mar
 2024 02:24:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240313115412.3334962-1-jonah.palmer@oracle.com>
 <20240313115412.3334962-2-jonah.palmer@oracle.com> <CACGkMEv6bRgrV_nvZK5Tb89CvTP5Kpyj4+na4Q9F=xBOJ6=8sw@mail.gmail.com>
 <b0e4a124-cced-4cbc-9f89-b8967f5a0b2c@oracle.com> <CAJaqyWcmzuY5R8hC-zwp_mEK40sYgwHU0vhewKziQLsY2EnpLg@mail.gmail.com>
 <f173f397-965f-43f9-9ce0-b417e86d6935@oracle.com> <CAJaqyWfspBXGw0WE2=HBuZiBJjyWTrMm2jyB4e0mP9UkixS4Mg@mail.gmail.com>
 <8b87682b-f22f-461e-bca7-1c80a6b9c760@oracle.com>
In-Reply-To: <8b87682b-f22f-461e-bca7-1c80a6b9c760@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 15 Mar 2024 10:23:55 +0100
Message-ID: <CAJaqyWdcnoTLrpEXeq8HxwbxxNxNvF2_Db9PwkaixdTU6tNcBQ@mail.gmail.com>
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

On Thu, Mar 14, 2024 at 9:24=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
>
>
> On 3/14/24 3:05 PM, Eugenio Perez Martin wrote:
> > On Thu, Mar 14, 2024 at 5:06=E2=80=AFPM Jonah Palmer <jonah.palmer@orac=
le.com> wrote:
> >>
> >>
> >>
> >> On 3/14/24 10:55 AM, Eugenio Perez Martin wrote:
> >>> On Thu, Mar 14, 2024 at 1:16=E2=80=AFPM Jonah Palmer <jonah.palmer@or=
acle.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 3/13/24 11:01 PM, Jason Wang wrote:
> >>>>> On Wed, Mar 13, 2024 at 7:55=E2=80=AFPM Jonah Palmer <jonah.palmer@=
oracle.com> wrote:
> >>>>>>
> >>>>>> Add support to virtio-pci devices for handling the extra data sent
> >>>>>> from the driver to the device when the VIRTIO_F_NOTIFICATION_DATA
> >>>>>> transport feature has been negotiated.
> >>>>>>
> >>>>>> The extra data that's passed to the virtio-pci device when this
> >>>>>> feature is enabled varies depending on the device's virtqueue
> >>>>>> layout.
> >>>>>>
> >>>>>> In a split virtqueue layout, this data includes:
> >>>>>>     - upper 16 bits: shadow_avail_idx
> >>>>>>     - lower 16 bits: virtqueue index
> >>>>>>
> >>>>>> In a packed virtqueue layout, this data includes:
> >>>>>>     - upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
> >>>>>>     - lower 16 bits: virtqueue index
> >>>>>>
> >>>>>> Tested-by: Lei Yang <leiyang@redhat.com>
> >>>>>> Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >>>>>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> >>>>>> ---
> >>>>>>     hw/virtio/virtio-pci.c     | 10 +++++++---
> >>>>>>     hw/virtio/virtio.c         | 18 ++++++++++++++++++
> >>>>>>     include/hw/virtio/virtio.h |  1 +
> >>>>>>     3 files changed, 26 insertions(+), 3 deletions(-)
> >>>>>>
> >>>>>> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> >>>>>> index cb6940fc0e..0f5c3c3b2f 100644
> >>>>>> --- a/hw/virtio/virtio-pci.c
> >>>>>> +++ b/hw/virtio/virtio-pci.c
> >>>>>> @@ -384,7 +384,7 @@ static void virtio_ioport_write(void *opaque, =
uint32_t addr, uint32_t val)
> >>>>>>     {
> >>>>>>         VirtIOPCIProxy *proxy =3D opaque;
> >>>>>>         VirtIODevice *vdev =3D virtio_bus_get_device(&proxy->bus);
> >>>>>> -    uint16_t vector;
> >>>>>> +    uint16_t vector, vq_idx;
> >>>>>>         hwaddr pa;
> >>>>>>
> >>>>>>         switch (addr) {
> >>>>>> @@ -408,8 +408,12 @@ static void virtio_ioport_write(void *opaque,=
 uint32_t addr, uint32_t val)
> >>>>>>                 vdev->queue_sel =3D val;
> >>>>>>             break;
> >>>>>>         case VIRTIO_PCI_QUEUE_NOTIFY:
> >>>>>> -        if (val < VIRTIO_QUEUE_MAX) {
> >>>>>> -            virtio_queue_notify(vdev, val);
> >>>>>> +        vq_idx =3D val;
> >>>>>> +        if (vq_idx < VIRTIO_QUEUE_MAX) {
> >>>>>> +            if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATI=
ON_DATA)) {
> >>>>>> +                virtio_queue_set_shadow_avail_data(vdev, val);
> >>>>>> +            }
> >>>>>> +            virtio_queue_notify(vdev, vq_idx);
> >>>>>>             }
> >>>>>>             break;
> >>>>>>         case VIRTIO_PCI_STATUS:
> >>>>>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> >>>>>> index d229755eae..bcb9e09df0 100644
> >>>>>> --- a/hw/virtio/virtio.c
> >>>>>> +++ b/hw/virtio/virtio.c
> >>>>>> @@ -2255,6 +2255,24 @@ void virtio_queue_set_align(VirtIODevice *v=
dev, int n, int align)
> >>>>>>         }
> >>>>>>     }
> >>>>>>
> >>>>>> +void virtio_queue_set_shadow_avail_data(VirtIODevice *vdev, uint3=
2_t data)
> >>>
> >>> Maybe I didn't explain well, but I think it is better to pass directl=
y
> >>> idx to a VirtQueue *. That way only the caller needs to check for a
> >>> valid vq idx, and (my understanding is) the virtio.c interface is
> >>> migrating to VirtQueue * use anyway.
> >>>
> >>
> >> Oh, are you saying to just pass in a VirtQueue *vq instead of
> >> VirtIODevice *vdev and get rid of the vq->vring.desc check in the func=
tion?
> >>
> >
> > No, that needs to be kept. I meant the access to vdev->vq[i] without
> > checking for a valid i.
> >
>
> Ahh okay I see what you mean. But I thought the following was checking
> for a valid VQ index:
>
> if (vq_idx < VIRTIO_QUEUE_MAX)
>

Right, but then the (potentially multiple) callers are responsible to
check for that. If we accept a VirtQueue *, it is assumed it is valid
already.

> Of course the virtio device may not have up to VIRTIO_QUEUE_MAX
> virtqueues, so maybe we should be checking for validity like this?
>
> if (vdev->vq[i].vring.num =3D=3D 0)
>

Actually yes, if you're going to send a new version I think checking
against num is better. Good find!

> Or was there something else you had in mind? Apologies for the confusion.
>

No worries, virtio.c is full of checks like that :).

Thanks!

> > You can get the VirtQueue in the caller with virtio_get_queue. Which
> > also does not check for a valid index, but that way is clearer the
> > caller needs to check it.
> >
>
> Roger, I'll use this instead for clarity.
>
> > As a side note, the check for desc !=3D 0 is widespread in QEMU but the
> > driver may use 0 address for desc, so it's not 100% valid. But to
> > change that now requires a deeper change out of the scope of this
> > series, so let's keep it for now :).
> >
> > Thanks! >
>
> I'll add it to the todo list =3D]
>
> >>>>>> +{
> >>>>>> +    /* Lower 16 bits is the virtqueue index */
> >>>>>> +    uint16_t i =3D data;
> >>>>>> +    VirtQueue *vq =3D &vdev->vq[i];
> >>>>>> +
> >>>>>> +    if (!vq->vring.desc) {
> >>>>>> +        return;
> >>>>>> +    }
> >>>>>> +
> >>>>>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
> >>>>>> +        vq->shadow_avail_wrap_counter =3D (data >> 31) & 0x1;
> >>>>>> +        vq->shadow_avail_idx =3D (data >> 16) & 0x7FFF;
> >>>>>> +    } else {
> >>>>>> +        vq->shadow_avail_idx =3D (data >> 16);
> >>>>>
> >>>>> Do we need to do a sanity check for this value?
> >>>>>
> >>>>> Thanks
> >>>>>
> >>>>
> >>>> It can't hurt, right? What kind of check did you have in mind?
> >>>>
> >>>> if (vq->shadow_avail_idx >=3D vq->vring.num)
> >>>>
> >>>
> >>> I'm a little bit lost too. shadow_avail_idx can take all uint16_t
> >>> values. Maybe you meant checking for a valid vq index, Jason?
> >>>
> >>> Thanks!
> >>>
> >>>> Or something else?
> >>>>
> >>>>>> +    }
> >>>>>> +}
> >>>>>> +
> >>>>>>     static void virtio_queue_notify_vq(VirtQueue *vq)
> >>>>>>     {
> >>>>>>         if (vq->vring.desc && vq->handle_output) {
> >>>>>> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio=
.h
> >>>>>> index c8f72850bc..53915947a7 100644
> >>>>>> --- a/include/hw/virtio/virtio.h
> >>>>>> +++ b/include/hw/virtio/virtio.h
> >>>>>> @@ -335,6 +335,7 @@ void virtio_queue_update_rings(VirtIODevice *v=
dev, int n);
> >>>>>>     void virtio_init_region_cache(VirtIODevice *vdev, int n);
> >>>>>>     void virtio_queue_set_align(VirtIODevice *vdev, int n, int ali=
gn);
> >>>>>>     void virtio_queue_notify(VirtIODevice *vdev, int n);
> >>>>>> +void virtio_queue_set_shadow_avail_data(VirtIODevice *vdev, uint3=
2_t data);
> >>>>>>     uint16_t virtio_queue_vector(VirtIODevice *vdev, int n);
> >>>>>>     void virtio_queue_set_vector(VirtIODevice *vdev, int n, uint16=
_t vector);
> >>>>>>     int virtio_queue_set_host_notifier_mr(VirtIODevice *vdev, int =
n,
> >>>>>> --
> >>>>>> 2.39.3
> >>>>>>
> >>>>>
> >>>>
> >>>
> >>
> >
>

