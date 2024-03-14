Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13A470CDE
	for <virtio-fs@lists.linux.dev>; Thu, 14 Mar 2024 14:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710428155; cv=none; b=mdSSXwgfaj/Uy4MR+ufuoXHC7S6+CePqAIcOYU6VNYk58tFR6Uq/uoGwr7voTpTb/dWqTGrLiNMfQcan9wW3RX04CliTPIYm7v9q1yUp2481cUY9ow1+WLS8p0p17TK+x0OBpxbXzM2zKs5fd/cYaAGq8eZbcThPtY7xA9uBtMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710428155; c=relaxed/simple;
	bh=Sh0QtfphFc1chorsmzdT0B7USAqj0clPXSZAq9uwtAM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OKw5Fm+29gciYa0GdmAZDYYkjzmnA09PP8P2YmswotlNLB2Bu24XRxwZmiRIWgIevDNOwef8Ixo+Iy0ANCqN3XU+RVrgxwZb3Ijedg9yyECTcszjbOavSSEXcMkVraLFTBj6MI3T9kYfsrU/ZShwz0T89Z+oTnbz8ONCUq0lVvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xqs0MJVo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xqs0MJVo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710428151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fSMLfDG4VeMZCthGc79Fntkf0/HoTmUlrk/uagO1Z1E=;
	b=Xqs0MJVoL3d/m37Hw/wwOGbUuZhnuM/cDKfhKYt21VNhxVIla01t+QTOUUtTlAeYxYaoRe
	DxQwUu5ClHhmCkl12ydxXs4PCX1cYjAtGznauh5MX2nRpi7qCo5RLBpxstyDSzfU+/aBeP
	mb3xhRZeOhOUBK+trPeO5prWC8QWWAA=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-9DIQkKWINLCvOKSHaXoa4w-1; Thu, 14 Mar 2024 10:55:50 -0400
X-MC-Unique: 9DIQkKWINLCvOKSHaXoa4w-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-dc74ac7d015so1109913276.0
        for <virtio-fs@lists.linux.dev>; Thu, 14 Mar 2024 07:55:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710428150; x=1711032950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fSMLfDG4VeMZCthGc79Fntkf0/HoTmUlrk/uagO1Z1E=;
        b=CtyKeD4uowbZ/q+umX9z+oZ0bBw8Df0izT4N2fSW78aijkkv+YuHM33d3pRwqBlkdg
         udXK8Er1Uc/ZKDNGbV0zUZdN53hBHir/28DcFPX9s0GzkcdQBFc9wjFnkYZ3FOsSHKMM
         eol2PqWkagKAbDWpP75GVsh+TMHyOsdJ7qFqvvsRjNmLYSCyTJTS36+0KlftM1YeAyng
         aV38+t6bscrQssPI8COEIIQuMvJdG4vrZaZ4ttVBW+HDfu38hu4mW2PyZhXAalssL39U
         uWUo8Kp8V7RdOXkLeSvM4iiL2H+xDxhvQEm2MWXmiYLAMQaOmPCKcOSGjDxhW+88VIqH
         cT0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUnBOihJpcZ21qVMYMBcqAMdHcjDxLBjUIMZlGzlmgMGFRWDdpur/K+G3CueBwN232b0wE9+cMmoDYUfL9jKExAsWencKBPN79G
X-Gm-Message-State: AOJu0YwJ5nTHSO5adJa1gZ/Pqy7fsnbulaCR4BG5BhZ3DUh972Lhen2R
	h/6H9BD3AF79qYqDERI5rAENxS4kLrUVX9r15Yy369SczF4tqViz7L2OHDsn8KFaB5PgzrQOmt2
	4aAO/9DO11T4G5ruCz2zqrhrXKoo/7bu1FbKohHruITNHZCzI2KB/QD+yIrNOVbxTTLOwxtZXdw
	2LblL4/scCCXAt6RB6NeKt/XlkPts1Fm7nT6RCfWNw
X-Received: by 2002:a25:ef49:0:b0:dcf:2cfe:c82e with SMTP id w9-20020a25ef49000000b00dcf2cfec82emr2088890ybm.55.1710428150021;
        Thu, 14 Mar 2024 07:55:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEO+C19NHczw78koKdxn35FiZkSA/rnbsEfcPiyp904M912CAJ8aQXqGGuNjPhxlUByyKIeZb18nvXumRu/e6c=
X-Received: by 2002:a25:ef49:0:b0:dcf:2cfe:c82e with SMTP id
 w9-20020a25ef49000000b00dcf2cfec82emr2088852ybm.55.1710428149733; Thu, 14 Mar
 2024 07:55:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240313115412.3334962-1-jonah.palmer@oracle.com>
 <20240313115412.3334962-2-jonah.palmer@oracle.com> <CACGkMEv6bRgrV_nvZK5Tb89CvTP5Kpyj4+na4Q9F=xBOJ6=8sw@mail.gmail.com>
 <b0e4a124-cced-4cbc-9f89-b8967f5a0b2c@oracle.com>
In-Reply-To: <b0e4a124-cced-4cbc-9f89-b8967f5a0b2c@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 14 Mar 2024 15:55:13 +0100
Message-ID: <CAJaqyWcmzuY5R8hC-zwp_mEK40sYgwHU0vhewKziQLsY2EnpLg@mail.gmail.com>
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

On Thu, Mar 14, 2024 at 1:16=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
>
>
> On 3/13/24 11:01 PM, Jason Wang wrote:
> > On Wed, Mar 13, 2024 at 7:55=E2=80=AFPM Jonah Palmer <jonah.palmer@orac=
le.com> wrote:
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
> >>   - upper 16 bits: shadow_avail_idx
> >>   - lower 16 bits: virtqueue index
> >>
> >> In a packed virtqueue layout, this data includes:
> >>   - upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
> >>   - lower 16 bits: virtqueue index
> >>
> >> Tested-by: Lei Yang <leiyang@redhat.com>
> >> Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> >> ---
> >>   hw/virtio/virtio-pci.c     | 10 +++++++---
> >>   hw/virtio/virtio.c         | 18 ++++++++++++++++++
> >>   include/hw/virtio/virtio.h |  1 +
> >>   3 files changed, 26 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> >> index cb6940fc0e..0f5c3c3b2f 100644
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
> >> @@ -408,8 +408,12 @@ static void virtio_ioport_write(void *opaque, uin=
t32_t addr, uint32_t val)
> >>               vdev->queue_sel =3D val;
> >>           break;
> >>       case VIRTIO_PCI_QUEUE_NOTIFY:
> >> -        if (val < VIRTIO_QUEUE_MAX) {
> >> -            virtio_queue_notify(vdev, val);
> >> +        vq_idx =3D val;
> >> +        if (vq_idx < VIRTIO_QUEUE_MAX) {
> >> +            if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_D=
ATA)) {
> >> +                virtio_queue_set_shadow_avail_data(vdev, val);
> >> +            }
> >> +            virtio_queue_notify(vdev, vq_idx);
> >>           }
> >>           break;
> >>       case VIRTIO_PCI_STATUS:
> >> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> >> index d229755eae..bcb9e09df0 100644
> >> --- a/hw/virtio/virtio.c
> >> +++ b/hw/virtio/virtio.c
> >> @@ -2255,6 +2255,24 @@ void virtio_queue_set_align(VirtIODevice *vdev,=
 int n, int align)
> >>       }
> >>   }
> >>
> >> +void virtio_queue_set_shadow_avail_data(VirtIODevice *vdev, uint32_t =
data)

Maybe I didn't explain well, but I think it is better to pass directly
idx to a VirtQueue *. That way only the caller needs to check for a
valid vq idx, and (my understanding is) the virtio.c interface is
migrating to VirtQueue * use anyway.

> >> +{
> >> +    /* Lower 16 bits is the virtqueue index */
> >> +    uint16_t i =3D data;
> >> +    VirtQueue *vq =3D &vdev->vq[i];
> >> +
> >> +    if (!vq->vring.desc) {
> >> +        return;
> >> +    }
> >> +
> >> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
> >> +        vq->shadow_avail_wrap_counter =3D (data >> 31) & 0x1;
> >> +        vq->shadow_avail_idx =3D (data >> 16) & 0x7FFF;
> >> +    } else {
> >> +        vq->shadow_avail_idx =3D (data >> 16);
> >
> > Do we need to do a sanity check for this value?
> >
> > Thanks
> >
>
> It can't hurt, right? What kind of check did you have in mind?
>
> if (vq->shadow_avail_idx >=3D vq->vring.num)
>

I'm a little bit lost too. shadow_avail_idx can take all uint16_t
values. Maybe you meant checking for a valid vq index, Jason?

Thanks!

> Or something else?
>
> >> +    }
> >> +}
> >> +
> >>   static void virtio_queue_notify_vq(VirtQueue *vq)
> >>   {
> >>       if (vq->vring.desc && vq->handle_output) {
> >> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> >> index c8f72850bc..53915947a7 100644
> >> --- a/include/hw/virtio/virtio.h
> >> +++ b/include/hw/virtio/virtio.h
> >> @@ -335,6 +335,7 @@ void virtio_queue_update_rings(VirtIODevice *vdev,=
 int n);
> >>   void virtio_init_region_cache(VirtIODevice *vdev, int n);
> >>   void virtio_queue_set_align(VirtIODevice *vdev, int n, int align);
> >>   void virtio_queue_notify(VirtIODevice *vdev, int n);
> >> +void virtio_queue_set_shadow_avail_data(VirtIODevice *vdev, uint32_t =
data);
> >>   uint16_t virtio_queue_vector(VirtIODevice *vdev, int n);
> >>   void virtio_queue_set_vector(VirtIODevice *vdev, int n, uint16_t vec=
tor);
> >>   int virtio_queue_set_host_notifier_mr(VirtIODevice *vdev, int n,
> >> --
> >> 2.39.3
> >>
> >
>

