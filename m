Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2D01BDCD
	for <virtio-fs@lists.linux.dev>; Wed,  6 Mar 2024 05:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709703243; cv=none; b=seKl6roCClKOfVFVQz/SSYgPPsR5FqYXAWo/M2wc5h0MfZZXpqDfgJYxDN6spf14QxrkOcZAYzClgRTl4m+tUtNcuVIq8djjzuQgyJwvzPgImrKKpmCbUYgB+aEaJR7S3+ra6AVbJ/rynNKmMzXwt0gaEdxnFoawfLMIPXXdN/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709703243; c=relaxed/simple;
	bh=HuqTPKHcZPL82ywGBwgz1swbQ5gH7CYrLARCj+OVS9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t/VGJBSO4gKnIjZ8NGuQ2c3ljJmL4UbsSuy4K3d58ziZtDtWs1OpJeFBB6ooiHrg35CPQAlakamEWNutszgCjiUw8aU/v9jEG39dTR7hPUeI3NKt2GLZ8qOgkG8FhOZT29smowsvZsZyli0E2KxhXaX8HlYYDPJbiPiYG5DRQ9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dfeN0xdB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dfeN0xdB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709703240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+jRY4LIfjrPdAXEdTkFyXRjOdZ0+3Sq/cJmK6iyjR/o=;
	b=dfeN0xdB5CkYv/OjJNY6H5iwDNH/E7xJwcHFzwXC/maIf4iILDP4NgxifGLIuOHQ0/YjwA
	sBUBEWnZRyNt2756KTRf5jhqzrOZ67c9+B7gYzPRmI6cfjqTlFwDCa6G9PdnxykREr0iTo
	hFHbkZ6mZXAonyd+6w/gYszwq5/Aw54=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-LdBOpYamM12KroSEjdIEZg-1; Wed, 06 Mar 2024 00:33:57 -0500
X-MC-Unique: LdBOpYamM12KroSEjdIEZg-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5ce63e72bc3so5946085a12.0
        for <virtio-fs@lists.linux.dev>; Tue, 05 Mar 2024 21:33:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709703236; x=1710308036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+jRY4LIfjrPdAXEdTkFyXRjOdZ0+3Sq/cJmK6iyjR/o=;
        b=PUZx5kXVoZqO88s0Fu4sGEko3etW3f5siRTVq2R4utgyOvdbx8SZqfXmMLP4uTL9gA
         mvBwHoU0ilwtJeQJ6/eoFU31EJ+YneCoVNhYWzDDMq1cph5+r1vrRuv+lAeWG++d/mE4
         xFc8dGbaw5hxl3PWzFV+R7MiYXmnlfBI11ea1zhaQY/qvchi9pIBkEPYYnz9n76555Xu
         BCkr+IxxQtwmQ/QwXoc3uzU87UVXsnUBQR8LiLakJM08ECX73K/KWKSQvyCeXj+pPvnq
         pTH6UafFQEJYrl5mUpbVOCPKQVPW9USqMDk3q8boHGysZxRo8JMrsYVmKHuQXEJ8PxKn
         oeAg==
X-Forwarded-Encrypted: i=1; AJvYcCX4TVRar7kN3NO8i7D4OFCTeAHFHRU1qUf6zyYa4nbeeeGSBYnH0GHL+yO3gXeM6iOI50nS4TDToKcln8hDWaYbzAgjqDYHMm65
X-Gm-Message-State: AOJu0Yx3b+iasnHuFIGrEke6HXZVeTOntkyROxDprhHbL1DZKnm2vFMK
	eCcFhF4BshXJG8h2OVqVO2sMIHbDLNlt9RV6c9uOJJiN5EolseAszKumGlHN8BrenSlZ45J4Nl4
	QpKP6kvBAuRWOYAND15+bex5AHmiTT3ewiQXxjf4PZD+KG2e4RrzS3gFSQNF20yzsdT5WK73aWq
	Cv7S+qRCctw1mWaKb/53sXhXowt6mWV6sh
X-Received: by 2002:a05:6a20:9381:b0:1a1:4d8b:73ce with SMTP id x1-20020a056a20938100b001a14d8b73cemr4088522pzh.18.1709703236254;
        Tue, 05 Mar 2024 21:33:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFc9YubHmxLH2HgvNsaW29Pgi7ZOeVeII/wN72253bi/8jTx93xeFrQDmOaVi8CGLMc8Qkt7RZCXSHTxCZaNU4=
X-Received: by 2002:a05:6a20:9381:b0:1a1:4d8b:73ce with SMTP id
 x1-20020a056a20938100b001a14d8b73cemr4088513pzh.18.1709703235945; Tue, 05 Mar
 2024 21:33:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304194612.611660-1-jonah.palmer@oracle.com>
In-Reply-To: <20240304194612.611660-1-jonah.palmer@oracle.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 6 Mar 2024 13:33:44 +0800
Message-ID: <CACGkMEtoA3SN9e9WnNpFyR32rkf_pWUNj-6uj2TZBzjB0E+3SQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] virtio,vhost: Add VIRTIO_F_NOTIFICATION_DATA support
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, eperezma@redhat.com, 
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

On Tue, Mar 5, 2024 at 3:46=E2=80=AFAM Jonah Palmer <jonah.palmer@oracle.co=
m> wrote:
>
> The goal of these patches are to add support to a variety of virtio and
> vhost devices for the VIRTIO_F_NOTIFICATION_DATA transport feature. This
> feature indicates that a driver will pass extra data (instead of just a
> virtqueue's index) when notifying the corresponding device.
>
> The data passed in by the driver when this feature is enabled varies in
> format depending on if the device is using a split or packed virtqueue
> layout:
>
>  Split VQ
>   - Upper 16 bits: shadow_avail_idx
>   - Lower 16 bits: virtqueue index
>
>  Packed VQ
>   - Upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
>   - Lower 16 bits: virtqueue index
>
> Also, due to the limitations of ioeventfd not being able to carry the
> extra provided by the driver, ioeventfd is left disabled for any devices
> using this feature.

Is there any method to overcome this? This might help for vhost.

Thanks

>
> A significant aspect of this effort has been to maintain compatibility
> across different backends. As such, the feature is offered by backend
> devices only when supported, with fallback mechanisms where backend
> support is absent.
>
> Jonah Palmer (8):
>   virtio/virtio-pci: Handle extra notification data
>   virtio-pci: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
>   virtio-mmio: Handle extra notification data
>   virtio-mmio: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
>   virtio-ccw: Handle extra notification data
>   virtio-ccw: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
>   vhost/vhost-user: Add VIRTIO_F_NOTIFICATION_DATA to vhost feature bits
>   virtio: Add VIRTIO_F_NOTIFICATION_DATA property definition
>
>  hw/block/vhost-user-blk.c    |  1 +
>  hw/net/vhost_net.c           |  2 ++
>  hw/s390x/s390-virtio-ccw.c   | 16 ++++++++++++----
>  hw/s390x/virtio-ccw.c        |  6 ++++--
>  hw/scsi/vhost-scsi.c         |  1 +
>  hw/scsi/vhost-user-scsi.c    |  1 +
>  hw/virtio/vhost-user-fs.c    |  2 +-
>  hw/virtio/vhost-user-vsock.c |  1 +
>  hw/virtio/virtio-mmio.c      | 15 +++++++++++----
>  hw/virtio/virtio-pci.c       | 16 +++++++++++-----
>  hw/virtio/virtio.c           | 18 ++++++++++++++++++
>  include/hw/virtio/virtio.h   |  5 ++++-
>  net/vhost-vdpa.c             |  1 +
>  13 files changed, 68 insertions(+), 17 deletions(-)
>
> --
> 2.39.3
>

