Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F949199B4
	for <virtio-fs@lists.linux.dev>; Sat, 16 Mar 2024 15:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710603966; cv=none; b=M98y6Ikv/tcoP2iZac+w1NV5S+xunDQV70Lml8NQP72/hFV0ezG/pSXT+6gpCYtIzoyE1uGCnRuBG2HBeLZxdNrxfiYpmi/6cfVIUOlTXLd6qwb8E4F63NeVy/XVwCjL4iM89KobJ42KJwlVfcYedC8Ks5G9LlVzofdkA/5dI/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710603966; c=relaxed/simple;
	bh=N0DCWcNRMhdWeeXRY/LLePOQXDMxa4pkgfogoHvlOTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=duD1kFblYJqL7gRgec90DS1bCTFCw1a33AUnFvYYe4q5IrGUbWtxwRo9mwMmxGtBIBhdNZ61NGsWNPSz/UhMFHQE2Vb8rJME7PjXtZUjzRt9R+ulEM0sKwuipr7iyqoZNc3DAy00Q9YBr0hYgsI38JIXoMAPGOQ5FeDz6Y8gQI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b=LL8PyfB6; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b="LL8PyfB6"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4140aadfe2eso132975e9.1
        for <virtio-fs@lists.linux.dev>; Sat, 16 Mar 2024 08:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20230601.gappssmtp.com; s=20230601; t=1710603959; x=1711208759; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a9gA9pAkbYWZhIoKitajuYItNdVaHTbx3SAp1P6Gr9c=;
        b=LL8PyfB6QENw0/utD3ftLDL5FKrCWLDpMofhUihha8sXz+lT/eXwJv1SxEoBBQ0yfT
         +zOUfUfoF54EImrHgNd5n4gdHHAP450hYd/cFc5GKOvWR423zpJ9oKquTOgPxpeOnao/
         vgmy9KyUQT7+pdPCJODJRVlsuD1oZ6lY+vWpRhcbVw7BgOc2gPeFwgm6hwV6crJriUU7
         YToWT5mtPe2CnAT1fFxGVMP2+ykiI2+0ude6T6AMmmldhTU9TGGfHiI10WibSUXb5kNe
         dRj/UQTnpJzDVQYqSWc8eAdrCMKraNBbFT6picbnncJHk6iUOaZ1HGTDwFBniDzZJvMv
         Lsaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710603959; x=1711208759;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9gA9pAkbYWZhIoKitajuYItNdVaHTbx3SAp1P6Gr9c=;
        b=tm4U8ksReiDRE74nviCzuwRSh3ZfgLpT60hTejCM6wM6rGvHF1qdIgNcG9IxM/3Dyo
         CNT9Xc9YwsJU20HCoLlJoTFd3IWgfv6lS+ZHaPJkASyogTaA5CziLPIUPwUt4Ptt7HL2
         oNLiQY1aDd0IrJ70+qX6sCHWT4qybgyDAXb3Vaa/uhKs1Z7cqgLovvgVJKn+XV0F5J/e
         DW+eZJxSSE8dzhGSHp9rSbS803WD/b5lGiYmNssUDC54626slLuklFltrozjV05ICUR7
         lQ6eVOKT+GW1hL9XCl4T+/lH0DjZz/ax10ahUeY2I+4SR7eXobvOvOPq01P5hI1nVyeI
         CqBA==
X-Forwarded-Encrypted: i=1; AJvYcCWKWvdNQOdd/TT1YvhzuOgYo/qcjwZN9sbQh60gLCotnpKj8yC4k4d085WEBh+hzH7G1ZP5CZe/SOXt7TbmjuaIQgNbs294p7Gt
X-Gm-Message-State: AOJu0YwU0ZPbgR1NfZt2hoGlfVZtNH+oQhzzbW2tvTKG8TSItLqZ9IUQ
	UukbrCCKIXjP83PkAm6PHiNQXj2h8w4MElADu8HlZoEUHfagh04j3Oj4/i+3jEc=
X-Google-Smtp-Source: AGHT+IFbL4Jarq6zMgJpaIjJ0+QKwEPuFFx5dnUVw6RP/Q1oZlB6JSXt2hOuQBXOBZts1pLmOFkVJg==
X-Received: by 2002:a05:600c:1546:b0:413:fd44:4f02 with SMTP id f6-20020a05600c154600b00413fd444f02mr4572071wmg.40.1710603959387;
        Sat, 16 Mar 2024 08:45:59 -0700 (PDT)
Received: from localhost ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id p18-20020a05600c359200b00413eac2e806sm9228303wmq.29.2024.03.16.08.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Mar 2024 08:45:58 -0700 (PDT)
Date: Sat, 16 Mar 2024 16:45:56 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, jasowang@redhat.com,
	eperezma@redhat.com, si-wei.liu@oracle.com,
	boris.ostrovsky@oracle.com, raphael@enfabrica.net, kwolf@redhat.com,
	hreitz@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
	farman@linux.ibm.com, thuth@redhat.com,
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
	cohuck@redhat.com, pbonzini@redhat.com, fam@euphon.net,
	stefanha@redhat.com, qemu-block@nongnu.org, qemu-s390x@nongnu.org,
	leiyang@redhat.com, schalla@marvell.com, vattunuru@marvell.com,
	jerinj@marvell.com, dtatulea@nvidia.com, virtio-fs@lists.linux.dev
Subject: Re: [PATCH v3 for 9.1 0/6] virtio, vhost: Add
 VIRTIO_F_NOTIFICATION_DATA support
Message-ID: <ZfW-tO4zXeAWDgFg@nanopsycho>
References: <20240315165557.26942-1-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240315165557.26942-1-jonah.palmer@oracle.com>

Fri, Mar 15, 2024 at 05:55:51PM CET, jonah.palmer@oracle.com wrote:
>The goal of these patches are to add support to a variety of virtio and
>vhost devices for the VIRTIO_F_NOTIFICATION_DATA transport feature. This
>feature indicates that a driver will pass extra data (instead of just a
>virtqueue's index) when notifying the corresponding device.
>
>The data passed in by the driver when this feature is enabled varies in
>format depending on if the device is using a split or packed virtqueue
>layout:
>
> Split VQ
>  - Upper 16 bits: shadow_avail_idx
>  - Lower 16 bits: virtqueue index
>
> Packed VQ
>  - Upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
>  - Lower 16 bits: virtqueue index
>
>Also, due to the limitations of ioeventfd not being able to carry the
>extra provided by the driver, having both VIRTIO_F_NOTIFICATION_DATA
>feature and ioeventfd enabled is a functional mismatch. The user must
>explicitly disable ioeventfd for the device in the Qemu arguments when
>using this feature, else the device will fail to complete realization.
>
>For example, a device must explicitly enable notification_data as well
>as disable ioeventfd:
>
>    -device virtio-scsi-pci,...,ioeventfd=off,notification_data=on
>
>A significant aspect of this effort has been to maintain compatibility
>across different backends. As such, the feature is offered by backend
>devices only when supported, with fallback mechanisms where backend
>support is absent.
>
>v3: Validate VQ idx via. virtio_queue_get_num() (pci, mmio, ccw)
>    Rename virtio_queue_set_shadow_avail_data
>    Only pass in upper 16 bits of 32-bit extra data (was redundant)
>    Make notification compatibility check function static
>    Drop tags on patches 1/6, 3/6, and 4/6
>
>v2: Don't disable ioeventfd by default, user must disable it
>    Drop tags on patch 2/6
>
>Jonah Palmer (6):
>  virtio/virtio-pci: Handle extra notification data
>  virtio: Prevent creation of device using notification-data with ioeventfd
>  virtio-mmio: Handle extra notification data
>  virtio-ccw: Handle extra notification data
>  vhost/vhost-user: Add VIRTIO_F_NOTIFICATION_DATA to vhost feature bits
>  virtio: Add VIRTIO_F_NOTIFICATION_DATA property definition

Jonah, do you have kernel patches to add this feature as well?

Thanks!
