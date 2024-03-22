Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CE317552
	for <virtio-fs@lists.linux.dev>; Fri, 22 Mar 2024 10:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711104507; cv=none; b=TsaT9JXqlte6shtuv1UEMKwnFKVgRb1qQJPwn7q392FU9aK1OxyEUr63aoyRELV6R6kb3OhlmA9SyHAp2qtQsKF19I5G2OMUmGVaOKSDDyvTVfy2EfKuQsDMdZ760qbhroMp2inmdR/nLgDe2YM/Re5cLt4WLZg+w/+X+molH7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711104507; c=relaxed/simple;
	bh=MUVaFGQErTPFd07biuIripr7YLa9Q6C2/HJuCa6K9Nk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EIb+J3BcqC769tUsuuJmCT3r85v4ViQKxj76sDzxS1FAZzFegze6riHIgvgnBees4OLvTK3m3s7Tr7iiD/uMqnxi2QRBzr2pAO8pfEhSNKxG86fEvAdmn+dC9uQOo3XhDgCOZXZnVaH9YzU518GfrnjscIfOKvkhGyIp9hYegqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WJ9A7Yih; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WJ9A7Yih"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711104504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9CJYsnhAl8UY2RPXfcbetaDbP2VSkH6ediVBvyZl/oI=;
	b=WJ9A7YihLGwt2vFR7/bWjryeIqKBzCDW4AzDNfHnZ4PuOYY0h/GapvmLxeWt/xrFCP812M
	URGc4nJQXn7frtFNF74cRRfqUwxi/fKKmU/pfVwI+cBHIkN09fzQDQMu5Le71YEWhS4ZuW
	UZOP2J++GQURV29culNt/4uNYVcSZ4U=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-uoe0J0AuPceNHBI_tlZVsQ-1; Fri, 22 Mar 2024 06:48:23 -0400
X-MC-Unique: uoe0J0AuPceNHBI_tlZVsQ-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-dd0ae66422fso3859136276.0
        for <virtio-fs@lists.linux.dev>; Fri, 22 Mar 2024 03:48:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711104502; x=1711709302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9CJYsnhAl8UY2RPXfcbetaDbP2VSkH6ediVBvyZl/oI=;
        b=OOcv5cF2D5pqJ+XTmHpbx9JvQzTrwLMh/8Igdk9TYNlw1p9BB5QERXi9pFw1EBYBG6
         Aki1s25FTn0ys/Pqp4sDN0nCO2jEP5F6pplWGdtyv2XFSTCI1Mr8+Fobf1yFt0JViW6+
         7GTZyZ6CWeHDyLkD30kGWxkExs4ymrqUB9yFUdm7/sZY2boRypl/Fu1o8ShR4tyq1JDr
         jlP8mH4aNRDCiyrHbiS4R3Y7sC2qMWBs69l68now2dc/b8/QGbYG42UtyMJ/K3pBpw9y
         BydoYCKme+FGllsJMhqEGv2dIPNd9j81CljPn2ldvGx5Ou7y4TKDKTJa9OOnHBUKn8Lq
         jO2g==
X-Forwarded-Encrypted: i=1; AJvYcCXGTivskZyr2d/5zg15zHYqSVQiYEneTiCv5NexQVecd94ypjQmcuxeOT+EeyIeJ+lAzFpLxSfACGTzhx84Ry16XvAZj65Cm/9z
X-Gm-Message-State: AOJu0YyNzBKT3MoFEPODGwVOBpeh+MCUe7QXTN4oN1+Rp3NiiZ7ckpB1
	fzDHpBtRljo2dpnLc4GVS3wuY+MXncGtX5/Vnz1Jhr8jBb/5WPSE/n8ozfqUkzqx/hIcCmox7vJ
	Q0EZlAlkbP/X6uEu0EUSdkNI2rrHqr1hlbra2oabQN3ymbb5pbGlFmCytwaV1CyeKZMSB9OTReB
	FQqtEXoTlZty9SG5Sr8Cgb/DGR6z4QNkiz
X-Received: by 2002:a25:ab09:0:b0:dcd:b806:7446 with SMTP id u9-20020a25ab09000000b00dcdb8067446mr940535ybi.1.1711104502532;
        Fri, 22 Mar 2024 03:48:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfZyAKvutxjWCIs+Th3hwaOESysJOUIhpwxG0X4ClKckVHXaKMnfdVLLSnvVVaawv7VteEJUvPEiKiVHsZqjc=
X-Received: by 2002:a25:ab09:0:b0:dcd:b806:7446 with SMTP id
 u9-20020a25ab09000000b00dcdb8067446mr940509ybi.1.1711104502282; Fri, 22 Mar
 2024 03:48:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240321155717.1392787-1-jonah.palmer@oracle.com> <20240321155717.1392787-8-jonah.palmer@oracle.com>
In-Reply-To: <20240321155717.1392787-8-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 22 Mar 2024 11:47:46 +0100
Message-ID: <CAJaqyWe=cn79VGbtGGdy9vJs0pCs_Q3cWQ5snofOUN_97_YgKw@mail.gmail.com>
Subject: Re: [RFC 7/8] vhost/vhost-user: Add VIRTIO_F_IN_ORDER to vhost
 feature bits
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net, 
	kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, 
	fam@euphon.net, stefanha@redhat.com, qemu-block@nongnu.org, 
	schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev, 
	si-wei.liu@oracle.com, boris.ostrovsky@oracle.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2024 at 4:57=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
> Add support for the VIRTIO_F_IN_ORDER feature across a variety of vhost
> devices.
>
> The inclusion of VIRTIO_F_IN_ORDER in the feature bits arrays for these
> devices ensures that the backend is capable of offering and providing
> support for this feature, and that it can be disabled if the backend
> does not support it.
>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Thanks!

> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  hw/block/vhost-user-blk.c    | 1 +
>  hw/net/vhost_net.c           | 2 ++
>  hw/scsi/vhost-scsi.c         | 1 +
>  hw/scsi/vhost-user-scsi.c    | 1 +
>  hw/virtio/vhost-user-fs.c    | 1 +
>  hw/virtio/vhost-user-vsock.c | 1 +
>  net/vhost-vdpa.c             | 1 +
>  7 files changed, 8 insertions(+)
>
> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> index 6a856ad51a..d176ed857e 100644
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -51,6 +51,7 @@ static const int user_feature_bits[] =3D {
>      VIRTIO_F_RING_PACKED,
>      VIRTIO_F_IOMMU_PLATFORM,
>      VIRTIO_F_RING_RESET,
> +    VIRTIO_F_IN_ORDER,
>      VHOST_INVALID_FEATURE_BIT
>  };
>
> diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
> index e8e1661646..33d1d4b9d3 100644
> --- a/hw/net/vhost_net.c
> +++ b/hw/net/vhost_net.c
> @@ -48,6 +48,7 @@ static const int kernel_feature_bits[] =3D {
>      VIRTIO_F_IOMMU_PLATFORM,
>      VIRTIO_F_RING_PACKED,
>      VIRTIO_F_RING_RESET,
> +    VIRTIO_F_IN_ORDER,
>      VIRTIO_NET_F_HASH_REPORT,
>      VHOST_INVALID_FEATURE_BIT
>  };
> @@ -76,6 +77,7 @@ static const int user_feature_bits[] =3D {
>      VIRTIO_F_IOMMU_PLATFORM,
>      VIRTIO_F_RING_PACKED,
>      VIRTIO_F_RING_RESET,
> +    VIRTIO_F_IN_ORDER,
>      VIRTIO_NET_F_RSS,
>      VIRTIO_NET_F_HASH_REPORT,
>      VIRTIO_NET_F_GUEST_USO4,
> diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
> index ae26bc19a4..40e7630191 100644
> --- a/hw/scsi/vhost-scsi.c
> +++ b/hw/scsi/vhost-scsi.c
> @@ -38,6 +38,7 @@ static const int kernel_feature_bits[] =3D {
>      VIRTIO_RING_F_EVENT_IDX,
>      VIRTIO_SCSI_F_HOTPLUG,
>      VIRTIO_F_RING_RESET,
> +    VIRTIO_F_IN_ORDER,
>      VHOST_INVALID_FEATURE_BIT
>  };
>
> diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
> index a63b1f4948..1d59951ab7 100644
> --- a/hw/scsi/vhost-user-scsi.c
> +++ b/hw/scsi/vhost-user-scsi.c
> @@ -36,6 +36,7 @@ static const int user_feature_bits[] =3D {
>      VIRTIO_RING_F_EVENT_IDX,
>      VIRTIO_SCSI_F_HOTPLUG,
>      VIRTIO_F_RING_RESET,
> +    VIRTIO_F_IN_ORDER,
>      VHOST_INVALID_FEATURE_BIT
>  };
>
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index cca2cd41be..9243dbb128 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -33,6 +33,7 @@ static const int user_feature_bits[] =3D {
>      VIRTIO_F_RING_PACKED,
>      VIRTIO_F_IOMMU_PLATFORM,
>      VIRTIO_F_RING_RESET,
> +    VIRTIO_F_IN_ORDER,
>
>      VHOST_INVALID_FEATURE_BIT
>  };
> diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
> index 9431b9792c..cc7e4e47b4 100644
> --- a/hw/virtio/vhost-user-vsock.c
> +++ b/hw/virtio/vhost-user-vsock.c
> @@ -21,6 +21,7 @@ static const int user_feature_bits[] =3D {
>      VIRTIO_RING_F_INDIRECT_DESC,
>      VIRTIO_RING_F_EVENT_IDX,
>      VIRTIO_F_NOTIFY_ON_EMPTY,
> +    VIRTIO_F_IN_ORDER,
>      VHOST_INVALID_FEATURE_BIT
>  };
>
> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> index 85e73dd6a7..ed3185acfa 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -62,6 +62,7 @@ const int vdpa_feature_bits[] =3D {
>      VIRTIO_F_RING_PACKED,
>      VIRTIO_F_RING_RESET,
>      VIRTIO_F_VERSION_1,
> +    VIRTIO_F_IN_ORDER,
>      VIRTIO_NET_F_CSUM,
>      VIRTIO_NET_F_CTRL_GUEST_OFFLOADS,
>      VIRTIO_NET_F_CTRL_MAC_ADDR,
> --
> 2.39.3
>

