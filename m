Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6416C7EEE1
	for <virtio-fs@lists.linux.dev>; Tue,  5 Mar 2024 08:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709625933; cv=none; b=supaVRsJpZt6WFyOG/f1TzWCmEFROwpv/rPYvDwr9/40H8Dyd9hanvc5UsxGHv9B+9oaodoZvBMZDkBVsS/80WVRyZ7wMRS0WQSXsgowNT07mva/TxoXQ4mTjKkv/xs5o+g6VHEWX7BlACsyXWdCTlt7QsrrzS19TtUTeSFVMqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709625933; c=relaxed/simple;
	bh=Duhr2gAEEmKEnQkzqCftyqBs6He9qzZ1BFj0CrEeTYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L3RN8O+V5J/Xu+/Q1KInW0EaN8V/KMYV/HyPsgouwZfTA/4i1nPusoSNIAuRDlG72+mbbOsv1hQWcmzwfJTbqNn6AnZp9ht4eylqwe8fMfDXLC71RFfEmeKJ6qLvzn00WBCpIdzIdWlsgtNiW7Mzf3XJUMKZUBWdzxy+IEGlaLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ag5+cxs9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ag5+cxs9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709625929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kD497RezhP4vTgtcu4VeuKKr+RMuIVXyas22WS8OZL0=;
	b=ag5+cxs9MOtWdkQLppLtH6LaPYW68FGcnuZOQ+kURNIbFGLYz5SRfJpMf9Xv3WmglOF3dC
	Y565aneLv8kHyk6FcBbP1vPU9ajl1B6ts3eeXcpxzNXV7vWsCRAZjXNkNMIm/K8rMk1fFn
	8KA+Edr+sXQUjzf/+6l2LDkYwtu99sE=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468--Ax9wyNsMCGnCn0dtyC9fg-1; Tue, 05 Mar 2024 03:05:28 -0500
X-MC-Unique: -Ax9wyNsMCGnCn0dtyC9fg-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-dc3645a6790so788385276.0
        for <virtio-fs@lists.linux.dev>; Tue, 05 Mar 2024 00:05:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709625927; x=1710230727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kD497RezhP4vTgtcu4VeuKKr+RMuIVXyas22WS8OZL0=;
        b=Ea8dWr2QANZVRb9jMzg755Mk59VAZZm9QrWRw2l5NVNCia5iZm0v0e4/AvgR/h6huh
         WStJpeP9KZEj8qGN2GiLLFn+fMCdqc3n9AUK4VwpZ1Mf2brpDTtSOlzly1hzOZy2uDBA
         6bq6IGljEaEtUfJ5E62rB+xa3KyEjRMBotjV5yRHsBq+kCDDeWAZ9dgJNK9OMBeH8RfB
         0s9ej67MQZvoaW9ER3GWFRA1Cs+xco9dN/FRK7Hh0qitZRLEaTbe7qeIYedGeN96yR96
         a4Po2F0c8Yn7JCF9VOG+K3jsTKTgJoYU0RreJ2/ohIEXoqidiLVcCRJQGj4PB9A+23LP
         wRjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXS7ndbu9JBoMgsCoUNbLgCyPJRaJgPFGRk8LHbohaCLSEJUxe817hTwvqf37B53W2qPv5K1bbFkUUptaZNf59WjGFrIB2vlPen
X-Gm-Message-State: AOJu0YxX2DncW75GqezjnyzlNLgRzhJWpcVUSCKcdaQEkWNXAv9rsINP
	AuCEz0HKmiVj77b3dw/KA1nWBZKs9vhLlcj9sdNWm5qBVczqjlM/9ZYXVf7HHX9we1RprpU02FX
	numafq5UJRvVdRwodsqcFmpButapoG7FJICRefrfSTrdv2c70vahsgBvgQ+CUDa2tF+8PEEFiYn
	rCkrMR+rD0lhJQiNN4h0Z8Faxcar8ljztB
X-Received: by 2002:a25:950:0:b0:dd0:bb7c:3f40 with SMTP id u16-20020a250950000000b00dd0bb7c3f40mr338047ybm.39.1709625927438;
        Tue, 05 Mar 2024 00:05:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHsPIHfm8Aklf2IkhUfnQFfP+m0vX60rwQba2+NGaq0VoCW3ftftWbe66UIRvg8mVsszix75owzRUQDEeU7Cjo=
X-Received: by 2002:a25:950:0:b0:dd0:bb7c:3f40 with SMTP id
 u16-20020a250950000000b00dd0bb7c3f40mr338041ybm.39.1709625927204; Tue, 05 Mar
 2024 00:05:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304194612.611660-1-jonah.palmer@oracle.com> <20240304194612.611660-2-jonah.palmer@oracle.com>
In-Reply-To: <20240304194612.611660-2-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 5 Mar 2024 09:04:51 +0100
Message-ID: <CAJaqyWe8WZEvWkS90gR=FrENV4eBYkOfZKpMrCCc_7BnpnzUZw@mail.gmail.com>
Subject: Re: [PATCH v1 1/8] virtio/virtio-pci: Handle extra notification data
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

On Mon, Mar 4, 2024 at 8:46=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.co=
m> wrote:
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
>  hw/virtio/virtio-pci.c     | 10 +++++++---
>  hw/virtio/virtio.c         | 18 ++++++++++++++++++
>  include/hw/virtio/virtio.h |  1 +
>  3 files changed, 26 insertions(+), 3 deletions(-)
>
> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> index 1a7039fb0c..d12edc567f 100644
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
> @@ -408,8 +408,12 @@ static void virtio_ioport_write(void *opaque, uint32=
_t addr, uint32_t val)
>              vdev->queue_sel =3D val;
>          break;
>      case VIRTIO_PCI_QUEUE_NOTIFY:
> -        if (val < VIRTIO_QUEUE_MAX) {
> -            virtio_queue_notify(vdev, val);
> +        vq_idx =3D val;
> +        if (vq_idx < VIRTIO_QUEUE_MAX) {
> +            if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA=
)) {
> +                virtio_queue_set_shadow_avail_data(vdev, val);
> +            }
> +            virtio_queue_notify(vdev, vq_idx);
>          }
>          break;
>      case VIRTIO_PCI_STATUS:
> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> index d229755eae..bcb9e09df0 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -2255,6 +2255,24 @@ void virtio_queue_set_align(VirtIODevice *vdev, in=
t n, int align)
>      }
>  }
>
> +void virtio_queue_set_shadow_avail_data(VirtIODevice *vdev, uint32_t dat=
a)
> +{
> +    /* Lower 16 bits is the virtqueue index */
> +    uint16_t i =3D data;
> +    VirtQueue *vq =3D &vdev->vq[i];
> +
> +    if (!vq->vring.desc) {
> +        return;
> +    }
> +
> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
> +        vq->shadow_avail_wrap_counter =3D (data >> 31) & 0x1;
> +        vq->shadow_avail_idx =3D (data >> 16) & 0x7FFF;
> +    } else {
> +        vq->shadow_avail_idx =3D (data >> 16);
> +    }
> +}
> +
>  static void virtio_queue_notify_vq(VirtQueue *vq)
>  {
>      if (vq->vring.desc && vq->handle_output) {
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index c8f72850bc..53915947a7 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -335,6 +335,7 @@ void virtio_queue_update_rings(VirtIODevice *vdev, in=
t n);
>  void virtio_init_region_cache(VirtIODevice *vdev, int n);
>  void virtio_queue_set_align(VirtIODevice *vdev, int n, int align);
>  void virtio_queue_notify(VirtIODevice *vdev, int n);
> +void virtio_queue_set_shadow_avail_data(VirtIODevice *vdev, uint32_t dat=
a);
>  uint16_t virtio_queue_vector(VirtIODevice *vdev, int n);
>  void virtio_queue_set_vector(VirtIODevice *vdev, int n, uint16_t vector)=
;
>  int virtio_queue_set_host_notifier_mr(VirtIODevice *vdev, int n,
> --
> 2.39.3
>

