Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFA4171BB
	for <virtio-fs@lists.linux.dev>; Wed,  6 Mar 2024 07:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709708894; cv=none; b=Gkyy84IN7GrZVK5TNgcp0akXMw8vPlod7voko93GnPp2urhYxIfdOGrBrAupKNBtqJDwj654kNDIA9O8d2fmMyXwys6hzbmSnc7lD1r64JyEA+JVVKNFYvnKWVP5PVHg4JFMUzjNGgQ6CYSOW+DlR0vqgfPo6OtQE3ksdhbyQXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709708894; c=relaxed/simple;
	bh=q390PEVxV64hhoXRjHxOj0xn/zxaE41s3qG6OEftaAI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BE6lVhynA9CgOV2WTOyxD0QOEgzEchZFPIr+2h9rNUA47HErBDbV0lG79ZqzXXtBrYyOVM48Qx2FFMoo9p5MaImVQwYFzFhG6wDX0SBnanT/fn7qUjM90r5l6Hyue5zCaQikEwg/R3YFV5Zo7nrY+FXvRxdSw6XhQXBzDcE4KlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OhuqxjLK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OhuqxjLK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709708891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Bg+9nnBnQiKUhfPvTXxHylY5Z2AaFb8qG98b0TNEv8=;
	b=OhuqxjLKlejqb/024CWWjrCrFLPr+K8oWf0KGAb/1zGr3B2rpinEE0FlsqGLjtEtaz//Dc
	/siNsfxQDbAiylOz+01zKaWOLQwp3nMXVFiUAYO/voig34/Zqedceal7lYQWPNCsu7kVeA
	sfIIZFrmZ4RC9g3tbigePFzkLLgUqtY=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-E8sU3gB0N1O6Ty-cVf-39g-1; Wed, 06 Mar 2024 02:08:08 -0500
X-MC-Unique: E8sU3gB0N1O6Ty-cVf-39g-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-dc6b26eef6cso8966413276.3
        for <virtio-fs@lists.linux.dev>; Tue, 05 Mar 2024 23:08:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709708887; x=1710313687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Bg+9nnBnQiKUhfPvTXxHylY5Z2AaFb8qG98b0TNEv8=;
        b=ri6wxw4sB4ne3DzSATvyh0u41U3Ck6ql1V60kjYXjkHf0TcO9OYnhsi+DOdunjtT1A
         991Lyt+Xj1JSPG4BQ5IAiEVZ8KKpz4J/tSXxvBF6NvxnvxqiHvFwRQas7fKPHn38NxhM
         hUJS60FxktDqXxgDIGShp41tUD1yUIsV63Eqk12Lla2I7RPmuSSUXRkkwHdU5zRALxF+
         6wNuDI5X1r2t15HiEcf4acTCIxMxso4ehl2A1mslAStoJmBhMEs2IylUZFmdV5w0xY0K
         ewpOtaL+pt3gjnVpiiT36O7Xivo0a/HIjNck02XZMmS5rI4W9nicEkSZCmCZgeCCb5BT
         sbaw==
X-Forwarded-Encrypted: i=1; AJvYcCUnEte/BvcU+dxv5lakTNimczIB7WOKti/H872AV6+zX883rAghnaA06KRt4G4bvV2qYsN5LcBSXDs9YDlnXEg84EnnNt//3DjQ
X-Gm-Message-State: AOJu0YynUL4RMw8WDJ7cSkb0te85FuydKERTdYlhivcT2RuhC8ayYxN8
	uogWfJ4unUYpwSrQ+52qUz8PyWm8X0ajmV2OmQ6FFlzj15TD/797j02st2zhkPaPwG1yU6kii1W
	QV7HjqKPelO9lmSOhWTZuIwCJ9qinNwJMU0e/7F/MCkxS5hOMWYmOzBWIcYp0OOq/ev6736v50D
	VK2zh280JWLgmQbNm2XqDtxpntihskntvV
X-Received: by 2002:a5b:8c1:0:b0:dcb:effc:47e5 with SMTP id w1-20020a5b08c1000000b00dcbeffc47e5mr12915537ybq.40.1709708887435;
        Tue, 05 Mar 2024 23:08:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFMWaVYkacC6lidYWtTzztgN5S8Cz7zoQPfPQlfnE3TRyu8QU9qfiMTicWHaN9f+E5Y/Q7o3Yj3qfrkDfK5CgE=
X-Received: by 2002:a5b:8c1:0:b0:dcb:effc:47e5 with SMTP id
 w1-20020a5b08c1000000b00dcbeffc47e5mr12915529ybq.40.1709708887176; Tue, 05
 Mar 2024 23:08:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304194612.611660-1-jonah.palmer@oracle.com> <CACGkMEtoA3SN9e9WnNpFyR32rkf_pWUNj-6uj2TZBzjB0E+3SQ@mail.gmail.com>
In-Reply-To: <CACGkMEtoA3SN9e9WnNpFyR32rkf_pWUNj-6uj2TZBzjB0E+3SQ@mail.gmail.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 6 Mar 2024 08:07:31 +0100
Message-ID: <CAJaqyWdAFTkjGBJBmxvmTZT8UUiH86UGgE74X_bcq22nd-WwHA@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] virtio,vhost: Add VIRTIO_F_NOTIFICATION_DATA support
To: Jason Wang <jasowang@redhat.com>
Cc: Jonah Palmer <jonah.palmer@oracle.com>, qemu-devel@nongnu.org, mst@redhat.com, 
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

On Wed, Mar 6, 2024 at 6:34=E2=80=AFAM Jason Wang <jasowang@redhat.com> wro=
te:
>
> On Tue, Mar 5, 2024 at 3:46=E2=80=AFAM Jonah Palmer <jonah.palmer@oracle.=
com> wrote:
> >
> > The goal of these patches are to add support to a variety of virtio and
> > vhost devices for the VIRTIO_F_NOTIFICATION_DATA transport feature. Thi=
s
> > feature indicates that a driver will pass extra data (instead of just a
> > virtqueue's index) when notifying the corresponding device.
> >
> > The data passed in by the driver when this feature is enabled varies in
> > format depending on if the device is using a split or packed virtqueue
> > layout:
> >
> >  Split VQ
> >   - Upper 16 bits: shadow_avail_idx
> >   - Lower 16 bits: virtqueue index
> >
> >  Packed VQ
> >   - Upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
> >   - Lower 16 bits: virtqueue index
> >
> > Also, due to the limitations of ioeventfd not being able to carry the
> > extra provided by the driver, ioeventfd is left disabled for any device=
s
> > using this feature.
>
> Is there any method to overcome this? This might help for vhost.
>

As a half-baked idea, read(2)ing an eventfd descriptor returns an
8-byte integer already. The returned value of read depends on eventfd
flags, but both have to do with the number of writes of the other end.

My proposal is to replace this value with the last value written by
the guest, so we can extract the virtio notification data from there.
The behavior of read is similar to not-EFD_SEMAPHORE, reading a value
and then blocking if read again without writes. The behavior of KVM
writes is different, as it is not a counter anymore.

Thanks!

> Thanks
>
> >
> > A significant aspect of this effort has been to maintain compatibility
> > across different backends. As such, the feature is offered by backend
> > devices only when supported, with fallback mechanisms where backend
> > support is absent.
> >
> > Jonah Palmer (8):
> >   virtio/virtio-pci: Handle extra notification data
> >   virtio-pci: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
> >   virtio-mmio: Handle extra notification data
> >   virtio-mmio: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
> >   virtio-ccw: Handle extra notification data
> >   virtio-ccw: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
> >   vhost/vhost-user: Add VIRTIO_F_NOTIFICATION_DATA to vhost feature bit=
s
> >   virtio: Add VIRTIO_F_NOTIFICATION_DATA property definition
> >
> >  hw/block/vhost-user-blk.c    |  1 +
> >  hw/net/vhost_net.c           |  2 ++
> >  hw/s390x/s390-virtio-ccw.c   | 16 ++++++++++++----
> >  hw/s390x/virtio-ccw.c        |  6 ++++--
> >  hw/scsi/vhost-scsi.c         |  1 +
> >  hw/scsi/vhost-user-scsi.c    |  1 +
> >  hw/virtio/vhost-user-fs.c    |  2 +-
> >  hw/virtio/vhost-user-vsock.c |  1 +
> >  hw/virtio/virtio-mmio.c      | 15 +++++++++++----
> >  hw/virtio/virtio-pci.c       | 16 +++++++++++-----
> >  hw/virtio/virtio.c           | 18 ++++++++++++++++++
> >  include/hw/virtio/virtio.h   |  5 ++++-
> >  net/vhost-vdpa.c             |  1 +
> >  13 files changed, 68 insertions(+), 17 deletions(-)
> >
> > --
> > 2.39.3
> >
>

