Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBB846548
	for <virtio-fs@lists.linux.dev>; Tue,  5 Mar 2024 08:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709625960; cv=none; b=f5B2nQGRQS2so+plkrxKiYo6in2Du1WqZXajwEkrJtFS57Fi4liePyZQyp4t6lvM7ILpwwLy3Reb2jNiHVUoh4IPCzDWIJXkghPGh27518Tm8TJ4s3fZKwl4noTzgidhgdC45AKdoHoXRWrsze5wsEnzl/U3W/C8g4DgLpNaA5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709625960; c=relaxed/simple;
	bh=bbP/4o8uyig553JjN+bfDGjaTm9ULs2WKtEhTHV7SE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KoadQFamXjh+z6Uue3F8eW8LuVf4MFAJuSJL4N0JjaJ/wVVnEqrW7La6ngIjAp0Z0Zn0Mkyo6p1iSKSQcyb+JIK6ITQasN+8MCWBlJoqLhIx523EEqQBoJHlXHmKXdEfYrzwJ7H302Y+gd9gPwM0WYumSrBoKjSTKlLUdBbRkAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GVc0utb7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GVc0utb7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709625957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WqG4t5jEKWuqlYHjQa0n5u6ujhVRAoNrr7gCNFvqV8E=;
	b=GVc0utb7jrm5SrH2TLcdQRn+XkmuHDnLQU8lIPuAwdgg6u0Dbp1RP5pM15whUVCs3y+QM4
	1Z449sMLIFW1zQffClSVRNQbHFZp8iJt6nZSFzpdilQA0V0farqolXqbqXEKOF5Q1IMYfH
	lkP7zssFfGCTUII+N2c50A3gtesx/uc=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-16t8xczMO8qPTKJy6h1Qiw-1; Tue, 05 Mar 2024 03:05:55 -0500
X-MC-Unique: 16t8xczMO8qPTKJy6h1Qiw-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-609a1063919so9263247b3.0
        for <virtio-fs@lists.linux.dev>; Tue, 05 Mar 2024 00:05:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709625955; x=1710230755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WqG4t5jEKWuqlYHjQa0n5u6ujhVRAoNrr7gCNFvqV8E=;
        b=oCkHi+lk79K4VveROR1TQ356yfndbFd9A+7/iu2yj/a8Ed+WGfgdiagJJ4G24KlP3o
         syp/zYr46vbO/DBQCboZmRNgahqP83Aq5PGKBmzBC2FYdL2lSn0uoIM0ByUgMtPRXEe7
         CsGM2Ef10v1gKITUJoUswTs+T/Yx1DbzvV0j33FSL+NMBVXSVEtIY6/CgyEjB8sfJfds
         CC7y1A2GJE0XC9kKYpYEXwthaS3gEXS2dm3Zt63ziTO11nDUeH1Wa7B0N6kvkt8kft0A
         KVtqa2R0MnM6MyzHTamypnmfJgXXv0jn09pebZmfjBnc+YeAUt4h1bGwJiDD25uOR75n
         1xbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJvKOwQtALVbrApPuWVDaJRPhfulbFEf5AqMQq8OZaL0jMrIvvuCb4eCZ8jk0ai3I7vAhy5y2Wip8Wl8aJ4BOZLtScfFzBz9Ne
X-Gm-Message-State: AOJu0YwSwaL3jFRB7zHR1L5RzNKf6YLWSFSGZphIwhSo1TyoK7mKBR+I
	6Ve8Bf5GsYs2PqQgZITQAU+S7CoLOZugwErKT5/bZGJ5x7NzfEXgPyID6lNy6gX6dAlvYxKbO+B
	LTLCz7iiwAnKVF3IRS9B+3qGLKqkAMz0+aldPgOj2aRlLwlJMTd8naIdZ1fVnl1WvkGmgkVGCHr
	SkxQ8kdsFonXucoMvTyHwDSxQ1InkRCvOE
X-Received: by 2002:a81:4f58:0:b0:609:96e0:b191 with SMTP id d85-20020a814f58000000b0060996e0b191mr7210485ywb.17.1709625955286;
        Tue, 05 Mar 2024 00:05:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFsoFYaCvZ1T1aCReurs8/n2Kt66niavd9yP1e0ww8HRM62uCWfAFc8mvHF4fb4zbBadCq163C5R69yn7j2LgE=
X-Received: by 2002:a81:4f58:0:b0:609:96e0:b191 with SMTP id
 d85-20020a814f58000000b0060996e0b191mr7210463ywb.17.1709625955020; Tue, 05
 Mar 2024 00:05:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304194612.611660-1-jonah.palmer@oracle.com> <20240304194612.611660-4-jonah.palmer@oracle.com>
In-Reply-To: <20240304194612.611660-4-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 5 Mar 2024 09:05:19 +0100
Message-ID: <CAJaqyWfRNP1eDfFwNwRmv4tvJeY=7dt8Om+Lv_rpmMy4XPEsaQ@mail.gmail.com>
Subject: Re: [PATCH v1 3/8] virtio-mmio: Handle extra notification data
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
> Add support to virtio-mmio devices for handling the extra data sent from
> the driver to the device when the VIRTIO_F_NOTIFICATION_DATA transport
> feature has been negotiated.
>
> The extra data that's passed to the virtio-mmio device when this feature
> is enabled varies depending on the device's virtqueue layout.
>
> The data passed to the virtio-mmio device is in the same format as the
> data passed to virtio-pci devices.
>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  hw/virtio/virtio-mmio.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/hw/virtio/virtio-mmio.c b/hw/virtio/virtio-mmio.c
> index 22f9fbcf5a..f99d5851a2 100644
> --- a/hw/virtio/virtio-mmio.c
> +++ b/hw/virtio/virtio-mmio.c
> @@ -248,6 +248,7 @@ static void virtio_mmio_write(void *opaque, hwaddr of=
fset, uint64_t value,
>  {
>      VirtIOMMIOProxy *proxy =3D (VirtIOMMIOProxy *)opaque;
>      VirtIODevice *vdev =3D virtio_bus_get_device(&proxy->bus);
> +    uint16_t vq_idx;
>
>      trace_virtio_mmio_write_offset(offset, value);
>
> @@ -407,8 +408,12 @@ static void virtio_mmio_write(void *opaque, hwaddr o=
ffset, uint64_t value,
>          }
>          break;
>      case VIRTIO_MMIO_QUEUE_NOTIFY:
> -        if (value < VIRTIO_QUEUE_MAX) {
> -            virtio_queue_notify(vdev, value);
> +        vq_idx =3D value;
> +        if (vq_idx < VIRTIO_QUEUE_MAX) {
> +            if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA=
)) {
> +                virtio_queue_set_shadow_avail_data(vdev, value);
> +            }
> +            virtio_queue_notify(vdev, vq_idx);
>          }
>          break;
>      case VIRTIO_MMIO_INTERRUPT_ACK:
> --
> 2.39.3
>

