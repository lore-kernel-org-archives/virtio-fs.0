Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137394A08
	for <virtio-fs@lists.linux.dev>; Thu, 14 Mar 2024 03:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710385299; cv=none; b=S2VZI5fqazEIXA2gKRvjJKd0ohdvf91gQ7eJ5Sex4weimnofQtbO2WGmzh8/vwz6oBHF0GkIcyEz47MVVj2dR/y3aCXsfkYg9tfjmqS1dzzrjN9c/s3qXIXuH9zbmC4HIAAkmX/T8LLLbqyXZapDSOxxnZDMiZdUgTNV9/uqBLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710385299; c=relaxed/simple;
	bh=iPlgQlWQy9tpwRqRxNgqHKTSwUJUVQ37nEQwJPFWD3c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WrMgATkhGLOVXyPrIIqjOygeEjQgTqIjjtXgJWnd1DsdNeSIXxRPmww5Ug87pnCdMGm0htBFeij3OdlOT+znNxi/5/sIH0cQX8b1d0OYOHkBm+pqPa8s6cgcJyOUL8tNdbcgFKFNDqtruwM1jX+XQjsA3+JWtmz0Zx8ta1CuUIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GNsjuiXN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GNsjuiXN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710385295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4SOKo7gSNU602nFk1+k9VeTLNQiU9gHlsuWUyDr9MMI=;
	b=GNsjuiXNYrppWO4kjRIVM/t6NQQYmUwPIrxPHqyT46S6uu2XDm25D5tWPKevu75mdRLFJM
	VcMkTCOOr9sxuJOI82qhZgnL7c0cE41zp26J7hT1DfEkK99PtrXRRM+wwq7AiFB3wWzTvB
	+mWQyfgT3eGKKbYh0FHUFoRb+/lel3E=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-dugYY-eWNECYwBezTy9a7g-1; Wed, 13 Mar 2024 23:01:34 -0400
X-MC-Unique: dugYY-eWNECYwBezTy9a7g-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6e44fd078bdso442698b3a.2
        for <virtio-fs@lists.linux.dev>; Wed, 13 Mar 2024 20:01:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710385293; x=1710990093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4SOKo7gSNU602nFk1+k9VeTLNQiU9gHlsuWUyDr9MMI=;
        b=DL3/CJwTIqMaM03Mwxi/E4maexPMXWorLLYUO0RU77cqvaMWqV0JOb9Vff0shfCV2b
         Tl/qHQSeeKUALgLWmlAVE2LBYj95wIXGpqfs+Xc5Ce7AJGZz0YNjqbnflVETV8WyX5xE
         qAGq+4t01OXdEivd0Izl8rd0isB9CcYc0sZNSM8L3BfiBTd+/oOELnoYGl/8Er7w52aD
         Z7R4bjYFzU+laIYBA0fKiQZTnnRZv2Uv6JNCMHi8bvpC+03yWDNKwN3zBS0eGNHCaO3r
         1v+ZJ8/6E1uvGtzvyyxrNTLyTnpuyzLPV9SbiDRf4Ig3xiuVrxCDh/TUlrnw7HAmTNZx
         lZhg==
X-Forwarded-Encrypted: i=1; AJvYcCUmb++xKG1vlpivu/0RYBw5oZvFYBFwDlQZuTF1ry9J6YmPF03PxRklQrMrD4gAvNZrnEt2PN+Y8BtjE3T3wyllLFFD647BATp/
X-Gm-Message-State: AOJu0YyPEPaiWFlYkyxD1htXAuAswMK2k85tBckbV4MGFsVpKIU0cnu4
	UY4LKh4DwPGa2JcfL3Oby4hu3K1/+DZsEZtBPy98lt+zRBJ7ayWYPQf9s6OGKWx7g0luZSaDx0x
	URCpAdap6tOqPt8KlXeSNkxel4oIT84ikz2yFzmRXK4Vz0krCf69BKVzbeRNGd81o1mPIRJLwup
	kaUvMRfR+UJlM3ETQAYzyu0/beAQI9DZKb
X-Received: by 2002:a05:6a20:12c6:b0:1a2:b33b:d6e0 with SMTP id v6-20020a056a2012c600b001a2b33bd6e0mr859813pzg.59.1710385292989;
        Wed, 13 Mar 2024 20:01:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1/7yW6FNWoH6DWORiitPMckMj5Sn+Ax3K5+xgpg8KJ1iyz/qiC1MXMJFFxloe95qQBU8Aae8QWixuknvh8lI=
X-Received: by 2002:a05:6a20:12c6:b0:1a2:b33b:d6e0 with SMTP id
 v6-20020a056a2012c600b001a2b33bd6e0mr859777pzg.59.1710385292653; Wed, 13 Mar
 2024 20:01:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240313115412.3334962-1-jonah.palmer@oracle.com> <20240313115412.3334962-2-jonah.palmer@oracle.com>
In-Reply-To: <20240313115412.3334962-2-jonah.palmer@oracle.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 14 Mar 2024 11:01:21 +0800
Message-ID: <CACGkMEv6bRgrV_nvZK5Tb89CvTP5Kpyj4+na4Q9F=xBOJ6=8sw@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] virtio/virtio-pci: Handle extra notification data
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, eperezma@redhat.com, 
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

On Wed, Mar 13, 2024 at 7:55=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
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
> Tested-by: Lei Yang <leiyang@redhat.com>
> Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  hw/virtio/virtio-pci.c     | 10 +++++++---
>  hw/virtio/virtio.c         | 18 ++++++++++++++++++
>  include/hw/virtio/virtio.h |  1 +
>  3 files changed, 26 insertions(+), 3 deletions(-)
>
> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> index cb6940fc0e..0f5c3c3b2f 100644
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

Do we need to do a sanity check for this value?

Thanks

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

