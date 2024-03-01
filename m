Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A915E3AC16
	for <virtio-fs@lists.linux.dev>; Fri,  1 Mar 2024 20:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709323553; cv=none; b=nvxQb1CzxW/jVKZTCWU9Bf6PF+mV4X8HJLnKwIAN9KNANQo4T1RwvsclXo3rBBhXMk+wEe4iabGH15mnUMXTJfzIrOOKb3+5l8riAuygE9GwoEyrNhD6VXuAMwgBJiV8+eRZKeeeErQlvSVew7eTl5R/nUgwCtPRaC4dLER3+ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709323553; c=relaxed/simple;
	bh=p7iS+7Q0NpbjkwdCHh1TJIlefxnelnrj0dHgLAGiBF8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J4CB+IED6BHtd0ZF2eFmd7jcevHPVRQcFnfMmvFCYfOLyG6Oq627fLLPwlHRnmtarW0KT9LPknZSizKGNQx47Oi8LaJKgVNd0UQtRLjTkGvQAlfa0ygzto+wHVMaQ+4ni5S3jW4+WyA2z/B0oc5KzyjGRua72CnaIozauxshIhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YRkd3NXx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YRkd3NXx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709323550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0k1fdxRndW6WC9hnwpKSKEP8NpQ5ahA5LhfJu/UmZgI=;
	b=YRkd3NXxsgp/lvyj+LljoxJRzeDmjriqq7j8beTp6R5yZO81NH11E6/3UTcEIKenKacDY6
	Lon9Qy0LZq54WdJvoii4cAvcPC2501uwbSru67JPMMQrqpM3EnIX+8yKZZUeQfWI8VXXcQ
	0Daxbs+1saSBjnxn07rLHKy4EZQxajQ=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625--2IbHFSdOjaJjWNSOBzlEw-1; Fri, 01 Mar 2024 15:05:48 -0500
X-MC-Unique: -2IbHFSdOjaJjWNSOBzlEw-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-dc6b269686aso3722664276.1
        for <virtio-fs@lists.linux.dev>; Fri, 01 Mar 2024 12:05:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709323548; x=1709928348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0k1fdxRndW6WC9hnwpKSKEP8NpQ5ahA5LhfJu/UmZgI=;
        b=hDrNZM0qXCWzf8ehA/J5I4K+jyrImRI9nE3un6DxWBhfv7ekKfNwT7P/u3XzObXHuu
         niiQzZ3ZvnT6UwDVYwaI6hswLPmdH/RLucuyLjJ8f93RC+Gpi1/v5VVMKvj0eNorKFO+
         xHEwBIZBB06p1yPox6xME7GOtDSmrWZrCu2UQjPvOjKz+sb1xC676puklNO/GNlQOCcc
         KaiMcOv+E03QVpsK/5yZTudZnikLyxC/UQh7hgqRjV2XeoPhwUVaCqgwZj7AQjx4MFO/
         5wptxYmHMF7zesW6BzAnMoEyNORPKLx6G6ZAqwZDPaVB5Fz7LJlhXuuZCp0psxidLg+g
         uzoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcw453+OKQYUvrGY33xmez/QNcLus+1nF+pzkwG+4oWZi0LGnkB5bOScp/mAt4nPpALcUcaXfxDihSvIeKJ0KZt/uC8+Rd4CQK
X-Gm-Message-State: AOJu0Yw/6s7aKDIJIz4QzjhQ7CP+mI+CCMPE5ftE9kEzRuq0lyzDB3as
	iS5fWVj7ulYufMgag0pWJQwF/5LYn7sq6KjXQI4gMv3aorhShS/NaNPd5LY0tNnA24WVg3cwrwj
	AmI3eDzmU+BF8YnWj3EQd2m+nEQH42Ej2fb0OayB08+DNonZgSiksOAZNRbT1NG167uZd/VDRtE
	imTqceuyaNHF03RBm4J/MIisRua8w91i/q
X-Received: by 2002:a25:9745:0:b0:dcd:3663:b5e5 with SMTP id h5-20020a259745000000b00dcd3663b5e5mr2335750ybo.25.1709323547888;
        Fri, 01 Mar 2024 12:05:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG+1J8CIrLVnCpOEnOKyL5JwwC+uAVHVjmjxs+speuALEy6QlX/n95Cutd7uqUX6W05k8ndzfNg4uW7CPBiNdU=
X-Received: by 2002:a25:9745:0:b0:dcd:3663:b5e5 with SMTP id
 h5-20020a259745000000b00dcd3663b5e5mr2335735ybo.25.1709323547659; Fri, 01 Mar
 2024 12:05:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240301134330.4191007-1-jonah.palmer@oracle.com> <20240301134330.4191007-9-jonah.palmer@oracle.com>
In-Reply-To: <20240301134330.4191007-9-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 1 Mar 2024 21:05:11 +0100
Message-ID: <CAJaqyWcEvYJm0WSZtVd5qj-eLRwT00DbUGjnb6J63snRvpH2og@mail.gmail.com>
Subject: Re: [RFC 8/8] virtio: Add VIRTIO_F_NOTIFICATION_DATA property definition
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
> Extend the virtio device property definitions to include the
> VIRTIO_F_NOTIFICATION_DATA feature.
>
> The default state of this feature is disabled, allowing it to be
> explicitly enabled where it's supported.
>

Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Thanks!

> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  include/hw/virtio/virtio.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index c92d8afc42..5772737dde 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -369,7 +369,9 @@ typedef struct VirtIORNGConf VirtIORNGConf;
>      DEFINE_PROP_BIT64("packed", _state, _field, \
>                        VIRTIO_F_RING_PACKED, false), \
>      DEFINE_PROP_BIT64("queue_reset", _state, _field, \
> -                      VIRTIO_F_RING_RESET, true)
> +                      VIRTIO_F_RING_RESET, true), \
> +    DEFINE_PROP_BIT64("notification_data", _state, _field, \
> +                      VIRTIO_F_NOTIFICATION_DATA, false)
>
>  hwaddr virtio_queue_get_desc_addr(VirtIODevice *vdev, int n);
>  bool virtio_queue_enabled_legacy(VirtIODevice *vdev, int n);
> --
> 2.39.3
>

