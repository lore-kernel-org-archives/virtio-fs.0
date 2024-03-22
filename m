Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5AE7E6
	for <virtio-fs@lists.linux.dev>; Fri, 22 Mar 2024 10:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711104538; cv=none; b=qLjKimKOFl+VxRTmg+wbqfsqZJiNt6hCNxGaiQeUJdHdN7bdZU45/XecknxeyBOYRpZNT9CkSkEQ7q1tGN9OjaBZLLhpZX1FZ2pTp332PnQ/7NgdiY0F24PcH71OPdRd7trUsC7t3834LmlvUz7OfwI7wbv1Xy7MpsNhFE8lVyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711104538; c=relaxed/simple;
	bh=rlAfmkLGP5VeHKjztSrTHHFrx+kYG9jD0Z0o0ZKHoRA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gmT0Gv7faGitPNoNOE17CygZ6MqgIC8CN1Hs6tJA7Dj3ha1tyrabb/UCWRPuOsUEvIMb4xK3wV68ME3zK/TbFbiK1p5bnX73UODwYXZWE7sgGOs2fj9W8TlsBSjVWNZ2dlr4XTkzp4Hu1QJuVW8okD3FBSiIWyZ3SBHMpYcdDYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JX6akIOi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JX6akIOi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711104536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MAN1EYJQkPaJyw8u+zCNoGpDsR1Jprwp5JVYuSLRjA8=;
	b=JX6akIOiIJLrVNSi53QX6088K0MUiqMM+e88gyOYuZI4wE7mkr5dSBvOChZlU0LqZas9Kl
	fwarlvrwyxcJoRjQL/qRa1VwloUPVpCneWeNoJJAvOOn1hppL4G8XhlE5JW/aC3ApsC4sc
	70VsfoE5RyXufaa+dpWSw0dtbLR865Q=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-B5MODNpzNMSwBCqm6gRlyw-1; Fri, 22 Mar 2024 06:48:54 -0400
X-MC-Unique: B5MODNpzNMSwBCqm6gRlyw-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-60a0151f194so35895357b3.1
        for <virtio-fs@lists.linux.dev>; Fri, 22 Mar 2024 03:48:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711104534; x=1711709334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MAN1EYJQkPaJyw8u+zCNoGpDsR1Jprwp5JVYuSLRjA8=;
        b=MeZcvd9KyePQWPwZQPktEVh3v7+ATiuAdb537DEJ7ICTuXVdi620e0yMFrAl9AbrFs
         nLBWLgSMSiPFEuw0he6/SK2iOrryk5O29v1qrUd+mkKpw+LrgoMpZyPg6JtZE6XeAUd+
         pjV/BZm5HftSpuv+LC5LVvyWtvafahfe1/VvbvqPz1JA5Yp4Vt4e4gbDYKszeU01IyxV
         8skYg4VBpcasevKv5REial5Ev+hrkqlTKOwOOm9y39dOD8QpqVg69hl97DaQKDxRc9gu
         vCinUvEwEL+f4gqWlIUwROyrDMvBPqPygMJ5en5jQa7JZhyFCXzfYTvJ5b1WvhyT3fwK
         L3kQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNbTz+6AHM3I+s7tbr8z5HmXrfc2mY4o1mOikbTym5XtZnOMujREWxATpv8HwKuWHa5fHsKm0JkapJskrMKftmt2cuz5KqOXQy
X-Gm-Message-State: AOJu0Yx8UvWVOgvvDgzj7OfvgQijzbjADS5jLVudgJyIlpV+FyzA4M5n
	AE3vL97OOG/iKKxvwXi1vDwKGt01HeGt2wpq1j/zndAl/3PGHKp+dEjrpHNAztq/J3Rmb+LO/c7
	D1S9Qqvp5HDLyywsS82CP+/25ihKdTARLCi7rXicGNJRVtm4FNjZBV0kzgi6lMqEBbcFimyczhk
	iMawzAffng85/UaJpui7LQ9cu+zeuKbkeO
X-Received: by 2002:a25:e015:0:b0:dc7:1ab6:6aca with SMTP id x21-20020a25e015000000b00dc71ab66acamr1523376ybg.63.1711104533939;
        Fri, 22 Mar 2024 03:48:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENOTcSDqu6/rHbyyQbijhEsp8Y3Ytsxm0+NcuNuka+ggLItlGf0d6HEyqJ8s/Z7y53Aiq5FnSqKmugHdYUhMM=
X-Received: by 2002:a25:e015:0:b0:dc7:1ab6:6aca with SMTP id
 x21-20020a25e015000000b00dc71ab66acamr1523358ybg.63.1711104533717; Fri, 22
 Mar 2024 03:48:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240321155717.1392787-1-jonah.palmer@oracle.com> <20240321155717.1392787-9-jonah.palmer@oracle.com>
In-Reply-To: <20240321155717.1392787-9-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 22 Mar 2024 11:48:17 +0100
Message-ID: <CAJaqyWf=_7EPKdr81JTfk0s3OAaL5ZXTkRpzvjWac66uWyt7_g@mail.gmail.com>
Subject: Re: [RFC 8/8] virtio: Add VIRTIO_F_IN_ORDER property definition
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
> Extend the virtio device property definitions to include the
> VIRTIO_F_IN_ORDER feature.
>
> The default state of this feature is disabled, allowing it to be
> explicitly enabled where it's supported.
>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Thanks!

> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  include/hw/virtio/virtio.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index eeeda397a9..ffd78830a3 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -400,7 +400,9 @@ typedef struct VirtIORNGConf VirtIORNGConf;
>      DEFINE_PROP_BIT64("packed", _state, _field, \
>                        VIRTIO_F_RING_PACKED, false), \
>      DEFINE_PROP_BIT64("queue_reset", _state, _field, \
> -                      VIRTIO_F_RING_RESET, true)
> +                      VIRTIO_F_RING_RESET, true), \
> +    DEFINE_PROP_BIT64("in_order", _state, _field, \
> +                      VIRTIO_F_IN_ORDER, false)
>
>  hwaddr virtio_queue_get_desc_addr(VirtIODevice *vdev, int n);
>  bool virtio_queue_enabled_legacy(VirtIODevice *vdev, int n);
> --
> 2.39.3
>

