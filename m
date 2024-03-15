Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E772C4C9F
	for <virtio-fs@lists.linux.dev>; Fri, 15 Mar 2024 18:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710527504; cv=none; b=Mpgu9eOz82oeu7KjI4DkBIk56kO6XiQxbpyFN+0lf7HKCzPV+2I8I4KVp7f5Zl3eUl256nGho7qk4j2Umo8oDMMUf651F8ZIe9Y6qmASZRPoEiV4QOwc4AKt/yRxus4wYGs1mmS13+dNLbKvVWVejgPN1v3r5PIXVBeVLPxvczw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710527504; c=relaxed/simple;
	bh=fimrtwacWt/MCqQMEsehz+mdpUYNz+aKoTPRArJaVE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M8xpQJXUyO0jTCvNDsZbldeSD4bqBNTmNATnlyr6YDT56j2Fk5GbHQwocFxaRx3qseh7e/6ByOLxihbcUkZ9M/R1YUf6G0y332YMl4JVsbyMWPHWTXqbG2til44XlnQiZ3Pretsj0fp4nNl24Nxy7Z0m5WucOlq6tnup7U3d2Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fGA102P+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fGA102P+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710527501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hjx4Rrg70XBuLeYQ4AUmFuQiPZnIhoQh27ELHtxKxS0=;
	b=fGA102P+S6ePdx7GeUq1LbmSL5ZkmU+8zuwM/rO07ORau8/tA9zarT+nDD+Ybow5dnQImJ
	iEnWGf4d3CstM06jC6hY4825A5GWG+dosiuo6nm/dabcFAFchVfox4iQZsVBvoLQXJDd7H
	nS2wfmfyuZCRBUAhdlymwmSkhEJf1wE=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-sSMjEAyNPQWa_pJr_5FOKw-1; Fri, 15 Mar 2024 14:31:40 -0400
X-MC-Unique: sSMjEAyNPQWa_pJr_5FOKw-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-60a0a5bf550so44596977b3.3
        for <virtio-fs@lists.linux.dev>; Fri, 15 Mar 2024 11:31:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710527500; x=1711132300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hjx4Rrg70XBuLeYQ4AUmFuQiPZnIhoQh27ELHtxKxS0=;
        b=vw9O8IHdE11DnppEcosa43MWpujzPlsSwbjSMjv86fZMBgHYdss+UzvCJNHuh+FJ4J
         YdBGO/cFfO7Y7oER+dBoh69W35S6McfHyn2J1dnukq9CpYcPv/C1obbqmxgzdL2NU4tX
         ip9HjUYGJRvs1Yc3iAf9WkveRf/Rpp318H7jvdqr5bOSDeRK9gyzt6AFLBRMHS7LbGl0
         WGw03e4q/8PguxWjJmktDfKiv/XI/pqSea/YorPE8Tjkwp+zdh3GsgcZ0PW3mMK2OMCh
         kbJ/p9h2t6gwsxA6LdcyJNY7qYHwxxxFaKbVH8vQC+epZZo8U1J9im9fRRVb9P1fhHqc
         F9ig==
X-Forwarded-Encrypted: i=1; AJvYcCV6z1b8VuAKVHzPWXQrRVrGcMEqzlzWzCAN6PJdjVim0vJBl8fqnJSGVnbYSqz8vnl6UgLZWNH1H7SDgXQ3J5iCZ0NebOzUaWWk
X-Gm-Message-State: AOJu0Yw4+/lQj6QwzvaUSDYey7XDApZrCPAYtIoxWmhmU8bxnwPyJnfD
	qUspkAxAH8U5cFiQwV/YSek9wfsG7LinFeztmZnwuliEF7phaYXtJqWeTz0eFCw+uFNGqo4eYOT
	3Uzs5Q8fhEaBS3SLh+R3NxRd1urrIZvHD9I8I32HbPyFmwspFmwpmyQa30+i/SucVwExJaO6fsh
	mr6+F5dL9rrSuEbZRc/LSrgLY/437tYOmn
X-Received: by 2002:a05:6902:50a:b0:dcc:7b05:4cbb with SMTP id x10-20020a056902050a00b00dcc7b054cbbmr5524008ybs.31.1710527500028;
        Fri, 15 Mar 2024 11:31:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZBXOjxYoNfGn+FnC5zJ8C3qwLXw5PYWx8+dV/4CMQ+HCEG7xCjKyGwRyHc2QN3L9ez/67GP5HOtSJe8ZeFi4=
X-Received: by 2002:a05:6902:50a:b0:dcc:7b05:4cbb with SMTP id
 x10-20020a056902050a00b00dcc7b054cbbmr5523984ybs.31.1710527499666; Fri, 15
 Mar 2024 11:31:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240315165557.26942-1-jonah.palmer@oracle.com> <20240315165557.26942-2-jonah.palmer@oracle.com>
In-Reply-To: <20240315165557.26942-2-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 15 Mar 2024 19:31:03 +0100
Message-ID: <CAJaqyWdB-GV95sWqPbqxveg4DMS4Onyoe-n64ijNBUy1P2JAow@mail.gmail.com>
Subject: Re: [PATCH v3 for 9.1 1/6] virtio/virtio-pci: Handle extra
 notification data
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, jasowang@redhat.com, 
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

On Fri, Mar 15, 2024 at 5:57=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
> Add support to virtio-pci devices for handling the extra data sent
> from the driver to the device when the VIRTIO_F_NOTIFICATION_DATA
> transport feature has been negotiated.
>
> The extra data that's passed to the virtio-pci device when this
> feature is enabled varies depending on the device's virtqueue
> layout.
>
> In a split virtqueue layout, this data includes:
>  - upper 16 bits: shadow_avail_idx
>  - lower 16 bits: virtqueue index
>
> In a packed virtqueue layout, this data includes:
>  - upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
>  - lower 16 bits: virtqueue index
>

Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Thanks!

> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  hw/virtio/virtio-pci.c     | 11 ++++++++---
>  hw/virtio/virtio.c         | 18 ++++++++++++++++++
>  include/hw/virtio/virtio.h |  2 ++
>  3 files changed, 28 insertions(+), 3 deletions(-)
>
> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> index cb6940fc0e..f3e0a08f53 100644
> --- a/hw/virtio/virtio-pci.c
> +++ b/hw/virtio/virtio-pci.c
> @@ -384,7 +384,7 @@ static void virtio_ioport_write(void *opaque, uint32_=
t addr, uint32_t val)
>  {
>      VirtIOPCIProxy *proxy =3D opaque;
>      VirtIODevice *vdev =3D virtio_bus_get_device(&proxy->bus);
> -    uint16_t vector;
> +    uint16_t vector, vq_idx;
>      hwaddr pa;
>
>      switch (addr) {
> @@ -408,8 +408,13 @@ static void virtio_ioport_write(void *opaque, uint32=
_t addr, uint32_t val)
>              vdev->queue_sel =3D val;
>          break;
>      case VIRTIO_PCI_QUEUE_NOTIFY:
> -        if (val < VIRTIO_QUEUE_MAX) {
> -            virtio_queue_notify(vdev, val);
> +        vq_idx =3D val;
> +        if (vq_idx < VIRTIO_QUEUE_MAX && virtio_queue_get_num(vdev, vq_i=
dx)) {
> +            if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA=
)) {
> +                virtio_queue_set_shadow_avail_idx(virtio_get_queue(vdev,=
 vq_idx),
> +                                                  val >> 16);
> +            }
> +            virtio_queue_notify(vdev, vq_idx);
>          }
>          break;
>      case VIRTIO_PCI_STATUS:
> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> index d229755eae..463426ca92 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -2255,6 +2255,24 @@ void virtio_queue_set_align(VirtIODevice *vdev, in=
t n, int align)
>      }
>  }
>
> +void virtio_queue_set_shadow_avail_idx(VirtQueue *vq, uint16_t shadow_av=
ail_idx)
> +{
> +    if (!vq->vring.desc) {
> +        return;
> +    }
> +
> +    /*
> +     * 16-bit data for packed VQs include 1-bit wrap counter and
> +     * 15-bit shadow_avail_idx.
> +     */
> +    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
> +        vq->shadow_avail_wrap_counter =3D (shadow_avail_idx >> 15) & 0x1=
;
> +        vq->shadow_avail_idx =3D shadow_avail_idx & 0x7FFF;
> +    } else {
> +        vq->shadow_avail_idx =3D shadow_avail_idx;
> +    }
> +}
> +
>  static void virtio_queue_notify_vq(VirtQueue *vq)
>  {
>      if (vq->vring.desc && vq->handle_output) {
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index c8f72850bc..cdd4f86b61 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -306,6 +306,8 @@ int virtio_queue_ready(VirtQueue *vq);
>
>  int virtio_queue_empty(VirtQueue *vq);
>
> +void virtio_queue_set_shadow_avail_idx(VirtQueue *vq, uint16_t idx);
> +
>  /* Host binding interface.  */
>
>  uint32_t virtio_config_readb(VirtIODevice *vdev, uint32_t addr);
> --
> 2.39.3
>

