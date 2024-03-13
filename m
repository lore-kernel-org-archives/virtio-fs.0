Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D405E4A11
	for <virtio-fs@lists.linux.dev>; Wed, 13 Mar 2024 14:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710340572; cv=none; b=LKT9CgJYPT2DEUObEP0S0HpHBxOQzD5L5eK2/DVTmg7Pc8rhzYql23biCTNVXPBa3MYxc+oWshbhuRNUx+R0G92cK3rSt58T0ZkETy6LR6WaO4W5iSBTI6ncy1iA2lCQ+ybFJNc2u12Uz+vXdPK1vBIKp5IZ13vAc0xVeBLkNP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710340572; c=relaxed/simple;
	bh=ZKuhyKhVlNHltMHhnD1/lSwDyM8bYiVAY6AGfAA/IO0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U3sHXtzhd7B8xSu7yzIq/dnwIbVzMplXXtUJv071M7BzR5QVoEyQnubnJ0HCEK7OwiNi6KP1z1eT9KPqF7Oxo20O+Z1JPkCxEUMLOVAvZSehWadPllb0Wpy+DRioJoLENTa1O3J3Nmn7CuRwGg2FXo7us0j5oecMzI27H8JVTWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aV+L8KJ1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aV+L8KJ1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710340569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=miS+0oKJrZZnKQmGEWQSW2jhvP7iN2gpZqqKFDF7Roo=;
	b=aV+L8KJ13t2i5kTA/Hdk0OqiaAwa90KR8ydbdlW02+xf4bX+lCEeTUYTzFhUVHLZUtu67a
	ny+i7pewCqJ8g/O9GGzguYUAVU3CgcLs/0M1w9Ma5f1r2fIOL5O1NiOQNqLR5PuHv3+FFT
	w3iVNDa4t1EF/syQGd9hkV+gJ2Qs6dY=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-slzEGoRnPh630arDmLscmQ-1; Wed, 13 Mar 2024 10:36:08 -0400
X-MC-Unique: slzEGoRnPh630arDmLscmQ-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-60a5374f3bcso18160527b3.0
        for <virtio-fs@lists.linux.dev>; Wed, 13 Mar 2024 07:36:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710340567; x=1710945367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=miS+0oKJrZZnKQmGEWQSW2jhvP7iN2gpZqqKFDF7Roo=;
        b=lFJ0OHaPVYM7ODc2IQR+21xjMBxDYgRWmPqG//9dosD0TXNrS2120F0QllsVn2o2bg
         QeRKtY7+UJngZDXOaZrAW4qhnouSxZSn70+j6MGIhNSBI4X1JdrDVgCDjNXQXLC9F3lM
         MJJSmaf0ML6NP9o1+IjxUxp9QKkUWCHk5GvDY9wuvzOAupGoZYSTwV1XkuC0XxADg5Xd
         thmedn00xSOn68pgMb0e2eFZQgl9ffxOFQvsNVQ1yVzCzL8aHb33CRi9QqVDUmKfIISD
         gDmqkTAbTaJa50q1HG5PIUYYipPT3jWrdZRHGtEYUiY2kM0uJn3BMlWmyf+3B4nSkie3
         daCw==
X-Forwarded-Encrypted: i=1; AJvYcCU3B0mlPycSOBQIaKKnwIsFlS/G4WRVftzal9x+QjTwD9VvFeTcESvkt5gSUAsmIB1IGKwwLs0DrQoPxlpv7hO7CS7GcndQx4yW
X-Gm-Message-State: AOJu0YzOVk84WCm5uFqORLK36IRyGOjRSboH30VRAbQmBXwxszlW75MQ
	nwBejA2VhLEgC2YfzLz4Bt529cBYi0lzKMDktwZe7E+sv1E31IWp1BXT3h7auEhizfonYYJVFe0
	E3spbXOi3S3WPpynOf9vRu1eH09hu4BUo2IEd3iskHGWC5XY/LG+V7UwhXBkKDg/aIj4RY/mTSH
	QBY4P9wEpLtRDlaFmETY0PGk9fpDlqroHI
X-Received: by 2002:a05:6902:602:b0:dcd:aa92:ecae with SMTP id d2-20020a056902060200b00dcdaa92ecaemr2279491ybt.63.1710340567502;
        Wed, 13 Mar 2024 07:36:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXg8L1/H/y9NYwvhY+pmMn853I80LIY7IKUAYIYOyS/Je9dF+W22Frla3PfGKJ0YYW5gkn/9/ywlNa0gQ/mN0=
X-Received: by 2002:a05:6902:602:b0:dcd:aa92:ecae with SMTP id
 d2-20020a056902060200b00dcdaa92ecaemr2279464ybt.63.1710340567236; Wed, 13 Mar
 2024 07:36:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240313115412.3334962-1-jonah.palmer@oracle.com> <20240313115412.3334962-3-jonah.palmer@oracle.com>
In-Reply-To: <20240313115412.3334962-3-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 13 Mar 2024 15:35:31 +0100
Message-ID: <CAJaqyWfbsFO6W1aszyGJEFCdJRhHUvBmyH=NHdLGJWmVQH4G0Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] virtio: Prevent creation of device using
 notification-data with ioeventfd
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, jasowang@redhat.com, 
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

On Wed, Mar 13, 2024 at 12:55=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.=
com> wrote:
>
> Prevent the realization of a virtio device that attempts to use the
> VIRTIO_F_NOTIFICATION_DATA transport feature without disabling
> ioeventfd.
>
> Due to ioeventfd not being able to carry the extra data associated with
> this feature, having both enabled is a functional mismatch and therefore
> Qemu should not continue the device's realization process.
>
> Although the device does not yet know if the feature will be
> successfully negotiated, many devices using this feature wont actually
> work without this extra data and would fail FEATURES_OK anyway.
>
> If ioeventfd is able to work with the extra notification data in the
> future, this compatibility check can be removed.
>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  hw/virtio/virtio.c         | 22 ++++++++++++++++++++++
>  include/hw/virtio/virtio.h |  2 ++
>  2 files changed, 24 insertions(+)
>
> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> index bcb9e09df0..d0a433b465 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -2971,6 +2971,20 @@ int virtio_set_features(VirtIODevice *vdev, uint64=
_t val)
>      return ret;
>  }
>
> +void virtio_device_check_notification_compatibility(VirtIODevice *vdev,
> +                                                    Error **errp)
> +{
> +    VirtioBusState *bus =3D VIRTIO_BUS(qdev_get_parent_bus(DEVICE(vdev))=
);
> +    VirtioBusClass *k =3D VIRTIO_BUS_GET_CLASS(bus);
> +    DeviceState *proxy =3D DEVICE(BUS(bus)->parent);
> +
> +    if (virtio_host_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA) &&
> +        k->ioeventfd_enabled(proxy)) {
> +        error_setg(errp,
> +                   "notification_data=3Don without ioeventfd=3Doff is no=
t supported");
> +    }
> +}
> +
>  size_t virtio_get_config_size(const VirtIOConfigSizeParams *params,
>                                uint64_t host_features)
>  {
> @@ -3731,6 +3745,14 @@ static void virtio_device_realize(DeviceState *dev=
, Error **errp)
>          }
>      }
>
> +    /* Devices should not use both ioeventfd and notification data featu=
re */
> +    virtio_device_check_notification_compatibility(vdev, &err);
> +    if (err !=3D NULL) {
> +        error_propagate(errp, err);
> +        vdc->unrealize(dev);
> +        return;
> +    }
> +
>      virtio_bus_device_plugged(vdev, &err);
>      if (err !=3D NULL) {
>          error_propagate(errp, err);
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index 53915947a7..e0325d84d0 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -346,6 +346,8 @@ void virtio_queue_reset(VirtIODevice *vdev, uint32_t =
queue_index);
>  void virtio_queue_enable(VirtIODevice *vdev, uint32_t queue_index);
>  void virtio_update_irq(VirtIODevice *vdev);
>  int virtio_set_features(VirtIODevice *vdev, uint64_t val);
> +void virtio_device_check_notification_compatibility(VirtIODevice *vdev,
> +                                                    Error **errp);

Why not make it static?

>
>  /* Base devices.  */
>  typedef struct VirtIOBlkConf VirtIOBlkConf;
> --
> 2.39.3
>

