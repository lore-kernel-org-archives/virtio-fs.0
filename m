Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5545D3B780
	for <virtio-fs@lists.linux.dev>; Fri,  1 Mar 2024 19:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709322967; cv=none; b=q10ZxZUPqJMguDf3Q+fKFDiqyR/J0c1jRAVU84NAnhZpark11UREbHWG6yTEug0OImJBmuU1rcilpO86yv32pcf6t7kKooPW57AEqmrJlQEC8h6zCl7jZE3OGNYybTx3WSxy34czxAAqI7kO59OMOU9VgMUSSJv05PvC43iPsSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709322967; c=relaxed/simple;
	bh=RNlOdaxaHzhdqCVlYPn6leku4YBouN95NKQ0I/VJ6kU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jiL7nt3dJfrGjTRZZtH+xs4WxidMIyixkSvj4WQpojALTF6UL0SawDARsY/DRAxRKouet7+AjDhW5wTFQe9FNs8nRVkcQpF78FoQOh+raciqlMe0z7tlvhiRI1me1eV0/7cAIgdXwMB3Ss/96+3i12Nr7Rw1elNkPs/hczZPKPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U104OR0D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U104OR0D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709322964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ZgEUSl+vA32O0vfl5TXIfza33OQsWq0SSwjuxnNZMc=;
	b=U104OR0Db9Tj73D/K/nDrr7X/LgMwpXXHeU7Xhn+NPnPHgPkxYEI2W6cVmuFovG2aMoUct
	n8l2lfbCw6mEjbDIYSoql5m7imb4LGDv8LwuztZGIT0GDEK87ymOzEHoTldN7X+xNpDTjg
	DFFL8Um1HYfV8Tm4wDOHL+vcQfvsTj8=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-S90Rh3dBMceR4WEDtLUBYA-1; Fri, 01 Mar 2024 14:56:02 -0500
X-MC-Unique: S90Rh3dBMceR4WEDtLUBYA-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-dc6b26845cdso3886058276.3
        for <virtio-fs@lists.linux.dev>; Fri, 01 Mar 2024 11:56:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709322962; x=1709927762;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ZgEUSl+vA32O0vfl5TXIfza33OQsWq0SSwjuxnNZMc=;
        b=rEgJfGOUT/BE41Cy9c8LnruoI8RA28RCO3fh73mCWLyEAyGC0bRh9IRa1JNfyLVQBm
         w74+AvHD1qWTG4nDO7JLlXBmHxS9xXWQobNU1uVz/x+r5TlVdAx6145xOh24Isi++BcA
         g9H8B+qvwhJScZyFoD+eWFc0Po8CAYZatVxNRQ6YBUQeMk2kO1yS42E2B8tnDyelJMVc
         CvnYQguHkoZtQGOUBoQTl7iNolBSr5sg3I0WSIyYHbiKlNX+COftumKJ+7m6VjDrcVYB
         zDRo4tzLROrwl+VHequLq8Oj9VBjVVSyFv2N3uz5CWg3gOP2YKy8pIP9yldeQhRQl/Xy
         N1bw==
X-Forwarded-Encrypted: i=1; AJvYcCVG4+ygouSksSvRUgoEN4sYB1SiFgW0ys2Yb36YhHKBM0fJyUeMOji3+RBL3iIGBiYmhinbDlfwR1moAdOQSIkHy8m2xNkhd8cG
X-Gm-Message-State: AOJu0YyoV8cFns9D+QCQYDMzfc7jtxX9ouUweVz0KR9Mb7nM2ygxjj6Z
	ax9HkzxzKKYj3WCTyJrD1SCHPZhnjvjwuXUFh0riXw3Hg9ZsOa/LyoEqYWZ7YSWa/v2JTOay0hu
	9tYjTgzWwSVIwYJ6bC8ed67ymMHuu7mvHPWCoFrK2vlucu5xk3FkRqY1fjXomRM3W+AyNQCM0Z0
	HGJ7jOzvS3V5Xq6/rfcfR3vqe52AjnzVGS
X-Received: by 2002:a05:6902:160d:b0:dcf:56c3:336e with SMTP id bw13-20020a056902160d00b00dcf56c3336emr2623776ybb.35.1709322962335;
        Fri, 01 Mar 2024 11:56:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHR33GP+FLVobe0wk9rdfKD7F5RMkkGGg9c5hUkaINJh7qFO9yASe9sQ0+ij3PPzIDgpTfmDL6CZ81mnvt2lF8=
X-Received: by 2002:a05:6902:160d:b0:dcf:56c3:336e with SMTP id
 bw13-20020a056902160d00b00dcf56c3336emr2623751ybb.35.1709322962009; Fri, 01
 Mar 2024 11:56:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240301134330.4191007-1-jonah.palmer@oracle.com> <20240301134330.4191007-2-jonah.palmer@oracle.com>
In-Reply-To: <20240301134330.4191007-2-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 1 Mar 2024 20:55:25 +0100
Message-ID: <CAJaqyWd8WXtWyexk-oHxmAkgcG4pEawonqGHDhWwq1hb6+-_Og@mail.gmail.com>
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

On Fri, Mar 1, 2024 at 2:44=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.co=
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
>  - upper 16 bits: last_avail_idx
>  - lower 16 bits: virtqueue index
>
> In a packed virtqueue layout, this data includes:
>  - upper 16 bits: 1-bit wrap counter & 15-bit last_avail_idx
>  - lower 16 bits: virtqueue index
>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  hw/virtio/virtio-pci.c     | 13 ++++++++++---
>  hw/virtio/virtio.c         | 13 +++++++++++++
>  include/hw/virtio/virtio.h |  1 +
>  3 files changed, 24 insertions(+), 3 deletions(-)
>
> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> index 1a7039fb0c..c7c577b177 100644
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
> @@ -408,8 +408,15 @@ static void virtio_ioport_write(void *opaque, uint32=
_t addr, uint32_t val)
>              vdev->queue_sel =3D val;
>          break;
>      case VIRTIO_PCI_QUEUE_NOTIFY:
> -        if (val < VIRTIO_QUEUE_MAX) {
> -            virtio_queue_notify(vdev, val);
> +        if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
> +            vq_idx =3D val & 0xFFFF;
> +            virtio_set_notification_data(vdev, vq_idx, val);
> +        } else {
> +            vq_idx =3D val;
> +        }
> +
> +        if (vq_idx < VIRTIO_QUEUE_MAX) {
> +            virtio_queue_notify(vdev, vq_idx);
>          }
>          break;
>      case VIRTIO_PCI_STATUS:
> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> index d229755eae..a61f69b7fd 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -2052,6 +2052,19 @@ int virtio_set_status(VirtIODevice *vdev, uint8_t =
val)
>      return 0;
>  }
>
> +void virtio_set_notification_data(VirtIODevice *vdev, uint16_t i, uint32=
_t data)
> +{
> +    VirtQueue *vq =3D &vdev->vq[i];

Sorry I sent the previous mail too fast :).

i should also be checked against VIRTIO_QUEUE_MAX and vq->vring.desc
before continuing this function. Otherwise is an out of bound access.

> +
> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
> +        vq->last_avail_wrap_counter =3D (data >> 31) & 0x1;
> +        vq->last_avail_idx =3D (data >> 16) & 0x7FFF;
> +    } else {
> +        vq->last_avail_idx =3D (data >> 16) & 0xFFFF;
> +    }
> +    vq->shadow_avail_idx =3D vq->last_avail_idx;
> +}
> +
>  static enum virtio_device_endian virtio_default_endian(void)
>  {
>      if (target_words_bigendian()) {
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index c8f72850bc..c92d8afc42 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -345,6 +345,7 @@ void virtio_queue_reset(VirtIODevice *vdev, uint32_t =
queue_index);
>  void virtio_queue_enable(VirtIODevice *vdev, uint32_t queue_index);
>  void virtio_update_irq(VirtIODevice *vdev);
>  int virtio_set_features(VirtIODevice *vdev, uint64_t val);
> +void virtio_set_notification_data(VirtIODevice *vdev, uint16_t i, uint32=
_t data);
>
>  /* Base devices.  */
>  typedef struct VirtIOBlkConf VirtIOBlkConf;
> --
> 2.39.3
>

