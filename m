Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0523A8E9
	for <virtio-fs@lists.linux.dev>; Fri,  1 Mar 2024 19:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709321524; cv=none; b=kS2SOTqmbm8ehi/fmIdHGWh5D6IqtW9GjpwfKDU2MPYPE7z2ltGlpHRSb8ntUXYHQQyOxTqPfWNnTuIa03o4AFx5n27H/g/80Vj4VYuwsix+zDYXXiELwvx7svnNRfxpjjSPgspxqlZAfiqY4acYr+1rKBztqoihK4lgYsjsKcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709321524; c=relaxed/simple;
	bh=y3/V7sIqeBgtjaHmJOitzIaYWPg7oBzgt0a2AzpfeaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AJYCaQklWeTsfwQMxEl0DVaQ9vKH7wUX3jM8Ng2p6+mOAzCO1Cfo+KsqqesHSkyQmEuSczRBUwyURiSOfu52rJTz+YEhdpR8eKmNXZV14eWJL7fsSwZritIqmQcp3A8qAgzQ4bY9AUDhVaBYZ2gxvNutL5X2EXx57VMy/qeg/uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OywPNA3e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OywPNA3e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709321521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D2AmXII77jNqUvmjWyATnisJCLHyvN5Kwvzt1RUVOHg=;
	b=OywPNA3eRtyvxPTji5OYs3T3D9GCapgWb0PWGNuTGbe15Vf1v7owhECWNaVPkxWSjqpevq
	fc50nJIKMYqYxpXbd07l1y/ee53065WidU2llQX2cjORcEcUlTETJ1Cuepned9rjW0zBcS
	QbX+heD0c4evNuI0m7TcTlWyBTniPEc=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-IIHnYIlfMvS_5bB4ln7Gug-1; Fri, 01 Mar 2024 14:32:00 -0500
X-MC-Unique: IIHnYIlfMvS_5bB4ln7Gug-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-dcd94cc48a1so3901446276.3
        for <virtio-fs@lists.linux.dev>; Fri, 01 Mar 2024 11:32:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709321519; x=1709926319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D2AmXII77jNqUvmjWyATnisJCLHyvN5Kwvzt1RUVOHg=;
        b=n53i0UYfMgaehmFFuq75429ZjKQY8Jk39ozws6utFUN7Jllcgyhew5RFosOq6G2VRL
         tnnV3RaCtC+1jgKy9p8PpJJllTzFIsIuNX6JxAvGTq6n6jCjuDqkJKd7AQgcUikcK1/z
         PAVIHPBnwzOMaab1L0GW8ts1T/2BqS1Q2oEvKf2x7GWucoYbY9yW5e8MN6O0eSFQjbE3
         IDEzQQ9XukyuthBmYqYq0Lm3uJ+LH3TbyEE3qT1a+3M0NVrksvRNYVOCBRPZmXxusDJ/
         4bUBZZ9T86SaiZvCZUmrg47KGw6EMOJwM3GAn2CT9bhJXZb7kr8MNaCJ0BStPYhxreH0
         bdAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUN/+t6MvNBTHNi3GAdga9VixGtAGVnKECGi5jv7wAUPIL6/GArlcgYNFEMsdVceD0Bp32eN17HqRHv+fPKzlb7ozQmJg793RL9
X-Gm-Message-State: AOJu0YxLK8aBHxvMix23SJ/yvWW5ht+6G0btZjyMxkro7n1c9fxoEdbO
	njmHUKwfwFfSnf6VFywWDUeBasZPTTu4DD16LTnfN2McrZTQRzltkcMg4Hon0kP3LDq5bwVGKGr
	q+UdPsJ2w8Cb6nJhWz0aowYEAaGfOCSQiUZUSBgBVepajEF9yXkmdDBffBrOVBSyzUOqWlWXGBn
	svtMXaFxZPniVUYY4QV1sBgrVbLTLaD8HA
X-Received: by 2002:a25:abc4:0:b0:dc7:45c6:f8bc with SMTP id v62-20020a25abc4000000b00dc745c6f8bcmr2571497ybi.4.1709321519509;
        Fri, 01 Mar 2024 11:31:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5F+BZNJSiDCBsIjhAtf1esGIqLuxYnCLfS5a70lozFfHDjjLiLmcIVXBOx0BShPYyeoli6wVJyUR/CMVLI34=
X-Received: by 2002:a25:abc4:0:b0:dc7:45c6:f8bc with SMTP id
 v62-20020a25abc4000000b00dc745c6f8bcmr2571467ybi.4.1709321519234; Fri, 01 Mar
 2024 11:31:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240301134330.4191007-1-jonah.palmer@oracle.com> <20240301134330.4191007-2-jonah.palmer@oracle.com>
In-Reply-To: <20240301134330.4191007-2-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 1 Mar 2024 20:31:23 +0100
Message-ID: <CAJaqyWdokP3yqbP8wPfgttFyFWfy1O3ST4jUQmiJ+n-xkrp_Zg@mail.gmail.com>
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

Nitpick, but since vq_idx is already a uint16_t the & 0xFFFF is not
needed. I think it's cleaner just to call virtio_set_notification data
in the has_feature(...) condition, but I'm happy with this too.

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
> +
> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
> +        vq->last_avail_wrap_counter =3D (data >> 31) & 0x1;
> +        vq->last_avail_idx =3D (data >> 16) & 0x7FFF;
> +    } else {
> +        vq->last_avail_idx =3D (data >> 16) & 0xFFFF;
> +    }

It should not set last_avail_idx, only shadow_avail_idx. Otherwise,
QEMU can only see the descriptors placed after the notification.

Or am I missing something?

In that regard, I would call this function
"virtqueue_set_shadow_avail_idx". But I'm very bad at naming :).

The rest looks good to me.

Thanks!

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

