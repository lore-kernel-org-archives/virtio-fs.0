Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A72E3CF63
	for <virtio-fs@lists.linux.dev>; Fri,  1 Mar 2024 20:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709323516; cv=none; b=t6AvL/T9LbB/LYnU0+hhLNmdJtyd7qlUH8CT0xa7FHLZBNYw1AXDx8A7GhGUlnDVx+8aH5efRKdzLM/iNBYq+deamFJ4BvWLv2/HVuIrWMKYHvd9oE8xfw37KBzU9bi1ytkVgLoAInqjIZzhor+fbySaZAlHrDCRu1OloQqEj5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709323516; c=relaxed/simple;
	bh=/OExgQ3ETnDw0+1EAeRSbwZcdzHtS+V3Ry79GjcpPDE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ck7yBNHCBMCpfF5C7z1B143feH2G6kPNTFw1CPWQKil0whfoGP4AJzBLn/TasAu+HgPnl1gW9RKoO6Eau+j/4dl6ySHg+apIjA0iIZJzdaPROgsAsUWeO1MtIDIxQSqJrnKcHJx2Jym6vt/2tYYwoAjafnmngoETwfpdHrzw4hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ara279lQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ara279lQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709323513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K8ROXt87b41leJzrs1qawudk/3ANLOKhm3rIOBD7Src=;
	b=ara279lQQOOse5725gIRULWLlS06uKlOXQTPVXG4P47g1wIl/KoJ1S4jPLUpxrDXxPURej
	G5LC0GkpYB1PBkDJwbat+WxXcJdWIXOj0mcGwP6J6zCMxfRNfWQwuVIXw3Y2ZsB3dD3mzY
	xxKx3krtfLUCyGVx12uQYpd4WCDEs10=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247-lF6lmTwENkOsOf3iUGmSNA-1; Fri, 01 Mar 2024 15:05:10 -0500
X-MC-Unique: lF6lmTwENkOsOf3iUGmSNA-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-dc6b267bf11so3103591276.2
        for <virtio-fs@lists.linux.dev>; Fri, 01 Mar 2024 12:05:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709323509; x=1709928309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K8ROXt87b41leJzrs1qawudk/3ANLOKhm3rIOBD7Src=;
        b=cuCzAIeweEaoM6PD7V+Rw9KjrVdzfKbHmtJBZpFdgqIK3UYL070HXUHq+a9fFA6HFq
         iCDXfSXss+ReE/iFy7Jh2GIz+VgEpJtMoIAKS++fZ9rHVp1FdZUYBxBfrnth9pJuN4k1
         l0f6rh9ISpfVRxPOrH5BqiVeiDGCgDDKTsN/3vpDdtXvHdmT2+3tv0rIO3p2TvH5hc1N
         SZNkwX9CHwzpJU7cJZp/D6Iko0/c9rS0k6CKNIUCCGl8NIu+LdYPHWaCiODPjojk4+gp
         S3znZJNA8YeEMrx6UgxHmx2UkDEflxUM8sy/oCReVtQ4O42mIsN1cWZeQh4a1SWiMYpj
         8Tnw==
X-Forwarded-Encrypted: i=1; AJvYcCVimT30HC2Dm3q0JCVXg57453s5y9zhztWrHt5U27CcbvfKulldryEJdOmPqUtZCTUF8m4R6x8mqrs8JVX9njlbudusWxUSnJma
X-Gm-Message-State: AOJu0YyrALrfk1RKNIDxW3Z7iNy/inpTQA52tuoR94YVZdodaKGEi1SK
	890IjVOIjAof5rUBzJ3UH4zKUkhqVlAVD68ETSAWEgG3S1olfl3ozkt0LyfbfS885DX/EBq/wtz
	Dui0+ERvFIE/krnmL1OYZks+ECHVokzcSs8TnhpVYe7ngGO77DUaleNoc+dA1Ceq2pKSzDoTaQk
	KTKQ5aAWy3FUvxOPjZxioQUVujisJ9N+je
X-Received: by 2002:a25:d092:0:b0:dcd:a28e:e5e0 with SMTP id h140-20020a25d092000000b00dcda28ee5e0mr2451345ybg.25.1709323509330;
        Fri, 01 Mar 2024 12:05:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE5TcnCVv6iSZnCkGwsdCpzXD9prVZ0M6KM4DYmuVzRCgZBCAOHCwn7854IQHOU8gcLVdj6jPCYMzve35ofmOU=
X-Received: by 2002:a25:d092:0:b0:dcd:a28e:e5e0 with SMTP id
 h140-20020a25d092000000b00dcda28ee5e0mr2451321ybg.25.1709323509061; Fri, 01
 Mar 2024 12:05:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240301134330.4191007-1-jonah.palmer@oracle.com> <20240301134330.4191007-8-jonah.palmer@oracle.com>
In-Reply-To: <20240301134330.4191007-8-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 1 Mar 2024 21:04:33 +0100
Message-ID: <CAJaqyWfUk4m6pJGmGN9A5k7Eqb=eDjVk26udo_hanCOv9FjHEw@mail.gmail.com>
Subject: Re: [RFC 7/8] vhost/vhost-user: Add VIRTIO_F_NOTIFICATION_DATA to
 vhost feature bits
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
> Add support for the VIRTIO_F_NOTIFICATION_DATA feature across a variety
> of vhost devices.
>
> The inclusion of VIRTIO_F_NOTIFICATION_DATA in the feature bits arrays
> for these devices ensures that the backend is capable of offering and
> providing support for this feature, and that it can be disabled if the
> backend does not support it.
>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  hw/block/vhost-user-blk.c    | 1 +
>  hw/net/vhost_net.c           | 2 ++
>  hw/scsi/vhost-scsi.c         | 1 +
>  hw/scsi/vhost-user-scsi.c    | 1 +
>  hw/virtio/vhost-user-fs.c    | 2 +-
>  hw/virtio/vhost-user-vsock.c | 1 +
>  net/vhost-vdpa.c             | 1 +
>  7 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> index 6a856ad51a..983c0657da 100644
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -51,6 +51,7 @@ static const int user_feature_bits[] =3D {
>      VIRTIO_F_RING_PACKED,
>      VIRTIO_F_IOMMU_PLATFORM,
>      VIRTIO_F_RING_RESET,
> +    VIRTIO_F_NOTIFICATION_DATA,
>      VHOST_INVALID_FEATURE_BIT
>  };
>
> diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
> index e8e1661646..bb1f975b39 100644
> --- a/hw/net/vhost_net.c
> +++ b/hw/net/vhost_net.c
> @@ -48,6 +48,7 @@ static const int kernel_feature_bits[] =3D {
>      VIRTIO_F_IOMMU_PLATFORM,
>      VIRTIO_F_RING_PACKED,
>      VIRTIO_F_RING_RESET,
> +    VIRTIO_F_NOTIFICATION_DATA,
>      VIRTIO_NET_F_HASH_REPORT,
>      VHOST_INVALID_FEATURE_BIT
>  };
> @@ -55,6 +56,7 @@ static const int kernel_feature_bits[] =3D {
>  /* Features supported by others. */
>  static const int user_feature_bits[] =3D {
>      VIRTIO_F_NOTIFY_ON_EMPTY,
> +    VIRTIO_F_NOTIFICATION_DATA,
>      VIRTIO_RING_F_INDIRECT_DESC,
>      VIRTIO_RING_F_EVENT_IDX,
>

vdpa_feature_bits also needs this feature bit added.

Apart from that,

Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
> index 58a00336c2..b8048f18e9 100644
> --- a/hw/scsi/vhost-scsi.c
> +++ b/hw/scsi/vhost-scsi.c
> @@ -38,6 +38,7 @@ static const int kernel_feature_bits[] =3D {
>      VIRTIO_RING_F_EVENT_IDX,
>      VIRTIO_SCSI_F_HOTPLUG,
>      VIRTIO_F_RING_RESET,
> +    VIRTIO_F_NOTIFICATION_DATA,
>      VHOST_INVALID_FEATURE_BIT
>  };
>
> diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
> index a63b1f4948..0b050805a8 100644
> --- a/hw/scsi/vhost-user-scsi.c
> +++ b/hw/scsi/vhost-user-scsi.c
> @@ -36,6 +36,7 @@ static const int user_feature_bits[] =3D {
>      VIRTIO_RING_F_EVENT_IDX,
>      VIRTIO_SCSI_F_HOTPLUG,
>      VIRTIO_F_RING_RESET,
> +    VIRTIO_F_NOTIFICATION_DATA,
>      VHOST_INVALID_FEATURE_BIT
>  };
>
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index cca2cd41be..ae48cc1c96 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -33,7 +33,7 @@ static const int user_feature_bits[] =3D {
>      VIRTIO_F_RING_PACKED,
>      VIRTIO_F_IOMMU_PLATFORM,
>      VIRTIO_F_RING_RESET,
> -
> +    VIRTIO_F_NOTIFICATION_DATA,
>      VHOST_INVALID_FEATURE_BIT
>  };
>
> diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
> index 9431b9792c..802b44a07d 100644
> --- a/hw/virtio/vhost-user-vsock.c
> +++ b/hw/virtio/vhost-user-vsock.c
> @@ -21,6 +21,7 @@ static const int user_feature_bits[] =3D {
>      VIRTIO_RING_F_INDIRECT_DESC,
>      VIRTIO_RING_F_EVENT_IDX,
>      VIRTIO_F_NOTIFY_ON_EMPTY,
> +    VIRTIO_F_NOTIFICATION_DATA,
>      VHOST_INVALID_FEATURE_BIT
>  };
>
> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> index 3726ee5d67..2827d29ce7 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -62,6 +62,7 @@ const int vdpa_feature_bits[] =3D {
>      VIRTIO_F_RING_PACKED,
>      VIRTIO_F_RING_RESET,
>      VIRTIO_F_VERSION_1,
> +    VIRTIO_F_NOTIFICATION_DATA,
>      VIRTIO_NET_F_CSUM,
>      VIRTIO_NET_F_CTRL_GUEST_OFFLOADS,
>      VIRTIO_NET_F_CTRL_MAC_ADDR,
> --
> 2.39.3
>

