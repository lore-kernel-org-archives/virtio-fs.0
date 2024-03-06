Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F01171BB
	for <virtio-fs@lists.linux.dev>; Wed,  6 Mar 2024 07:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709710451; cv=none; b=hSa0mHYUOOjTTBCGldTFK4U6iVq8V8CKsZ97+rDTuFs/QnC6zvf510MsVgDsKpBU1uYOpGcoMwwwQ30RUbeL91haZyIlvEHZ59D8MBto9IJzcINq4I9UaSJm7Z/ec6L5u7qVgEfIxNGsMYxUunbuD0B082+IXiXnyUF5H9EoWOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709710451; c=relaxed/simple;
	bh=ZIccWYoH/O3+cGB+xpoCtOpte289VdygUyIjMf/r9xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=dG5msXcwzhpx8+9RK6yK+YFDNU4DHehDaWRGYjTi5A5G+pyNfAzT6xldUaa5t48Y5/NeNbPzpSoOJcuLeJJVqbk9JO0/YabaZ3mRlxhkwaPd0jozoDlgatUw/S1V4tse4lPzsmaL9DpxZG9Wpms8MefSyDvopJf4s/TklDZXJPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fLP44gTf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fLP44gTf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709710448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yy49i5Xj3EUwTsmXyabM8hcAjOz2YG0lxCiaC6/VxsY=;
	b=fLP44gTfavbhy/+/RTBLEOXNOSS2zMfbT4hicklLu4pj5Qb4yD2R8x0Rov+o1CLHPirTRH
	y1cAXkuAPQrLNdxmDLr4OvXRBRBqe1yrRKltDHRRwmuFY1frtY+09ov/a6VB2A3rNTjPaj
	SL+ymIOFp6JQEkq8iFSZOaBjgExgC6s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-iCpnrCXXOAO5A3z1Bs4WJQ-1; Wed, 06 Mar 2024 02:34:06 -0500
X-MC-Unique: iCpnrCXXOAO5A3z1Bs4WJQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4129b426bdaso42293385e9.0
        for <virtio-fs@lists.linux.dev>; Tue, 05 Mar 2024 23:34:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709710446; x=1710315246;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yy49i5Xj3EUwTsmXyabM8hcAjOz2YG0lxCiaC6/VxsY=;
        b=waz/YjywVFu0oV6e2vsBE5PQxlJmUopiomtRfNAzuc7t+RlsIRzopxY+zB5sheqLet
         XNMnVWLYmdYj/po9L8p4kmDjvDE101rwX428kaQNFLb27DcpSnNXRclQ/x5pQ0wDw8oD
         ODmDtoZRrc0gWAgSpXlLBHgi58zM0iKahfuafvTl9P+cH0VobW/gJxFD7vAQZYGvcw4R
         ZidHR5SRNRQYj3sAqzM9xsqz+PJkpicGkh5/NNCLVXGccskKA25gvxZ3czJ9Xo1mGacD
         ZYuwGvJR8Q5l4aFOZan8P20ViyB3CXVnD8WQDd1IvMiUgYIe20pAJX+mLZGxrGBdfyeP
         q/jQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJMgShtqvp75TTNZgiYV6+0rsCUo1gYzXvTErlO+PpxuuD+vgz9a5m9zQmzxepBYA9bHw1dL6+eCDvz2MYgfyoBFC1pThN045m
X-Gm-Message-State: AOJu0YyHrqikAxfloHvLiqkb1DgA4yISEnZN9I3qvTg8axkqIaE6hPe6
	4yglv+yrMnFhvFHGse8k8IITF8YDnr9dV57O0A3cAmmOjCAA9AmsGrhrwjoCsREMFwBOHvUH4Nz
	kKXHWHhYIw042Ow1tyb8Ajn2RAQ8858Y7PC7AC5lKpZtYrOMvF1arf53vnw==
X-Received: by 2002:a05:600c:1d16:b0:412:b2fe:6e46 with SMTP id l22-20020a05600c1d1600b00412b2fe6e46mr9383996wms.27.1709710445677;
        Tue, 05 Mar 2024 23:34:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEjX6LQmRlN+VclGnIdPOs3sbAWM4s1HefaMvv67PxSRsmMdUm5tVwl+gXGE85WA2+gNv9o5g==
X-Received: by 2002:a05:600c:1d16:b0:412:b2fe:6e46 with SMTP id l22-20020a05600c1d1600b00412b2fe6e46mr9383960wms.27.1709710444979;
        Tue, 05 Mar 2024 23:34:04 -0800 (PST)
Received: from redhat.com ([2a02:14f:1ef:f330:b8:b56b:3f3d:2015])
        by smtp.gmail.com with ESMTPSA id g11-20020a05600c4ecb00b00412e293bee9sm9274933wmq.38.2024.03.05.23.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 23:34:04 -0800 (PST)
Date: Wed, 6 Mar 2024 02:33:58 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>,
	Jonah Palmer <jonah.palmer@oracle.com>, qemu-devel@nongnu.org,
	si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
	raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
	pasic@linux.ibm.com, borntraeger@linux.ibm.com,
	farman@linux.ibm.com, thuth@redhat.com,
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
	cohuck@redhat.com, pbonzini@redhat.com, fam@euphon.net,
	stefanha@redhat.com, qemu-block@nongnu.org, qemu-s390x@nongnu.org,
	virtio-fs@lists.linux.dev
Subject: Re: [PATCH v1 0/8] virtio,vhost: Add VIRTIO_F_NOTIFICATION_DATA
 support
Message-ID: <20240306023143-mutt-send-email-mst@kernel.org>
References: <20240304194612.611660-1-jonah.palmer@oracle.com>
 <CACGkMEtoA3SN9e9WnNpFyR32rkf_pWUNj-6uj2TZBzjB0E+3SQ@mail.gmail.com>
 <CAJaqyWdAFTkjGBJBmxvmTZT8UUiH86UGgE74X_bcq22nd-WwHA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAJaqyWdAFTkjGBJBmxvmTZT8UUiH86UGgE74X_bcq22nd-WwHA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Mar 06, 2024 at 08:07:31AM +0100, Eugenio Perez Martin wrote:
> On Wed, Mar 6, 2024 at 6:34 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Tue, Mar 5, 2024 at 3:46 AM Jonah Palmer <jonah.palmer@oracle.com> wrote:
> > >
> > > The goal of these patches are to add support to a variety of virtio and
> > > vhost devices for the VIRTIO_F_NOTIFICATION_DATA transport feature. This
> > > feature indicates that a driver will pass extra data (instead of just a
> > > virtqueue's index) when notifying the corresponding device.
> > >
> > > The data passed in by the driver when this feature is enabled varies in
> > > format depending on if the device is using a split or packed virtqueue
> > > layout:
> > >
> > >  Split VQ
> > >   - Upper 16 bits: shadow_avail_idx
> > >   - Lower 16 bits: virtqueue index
> > >
> > >  Packed VQ
> > >   - Upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
> > >   - Lower 16 bits: virtqueue index
> > >
> > > Also, due to the limitations of ioeventfd not being able to carry the
> > > extra provided by the driver, ioeventfd is left disabled for any devices
> > > using this feature.
> >
> > Is there any method to overcome this? This might help for vhost.
> >
> 
> As a half-baked idea, read(2)ing an eventfd descriptor returns an
> 8-byte integer already. The returned value of read depends on eventfd
> flags, but both have to do with the number of writes of the other end.
> 
> My proposal is to replace this value with the last value written by
> the guest, so we can extract the virtio notification data from there.
> The behavior of read is similar to not-EFD_SEMAPHORE, reading a value
> and then blocking if read again without writes. The behavior of KVM
> writes is different, as it is not a counter anymore.
> 
> Thanks!


I doubt you will be able to support this in ioeventfd...
But vhost does not really need the value at all.
So why mask out ioeventfd with vhost?
vhost-vdpa is probably the only one that might need it...



> > Thanks
> >
> > >
> > > A significant aspect of this effort has been to maintain compatibility
> > > across different backends. As such, the feature is offered by backend
> > > devices only when supported, with fallback mechanisms where backend
> > > support is absent.
> > >
> > > Jonah Palmer (8):
> > >   virtio/virtio-pci: Handle extra notification data
> > >   virtio-pci: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
> > >   virtio-mmio: Handle extra notification data
> > >   virtio-mmio: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
> > >   virtio-ccw: Handle extra notification data
> > >   virtio-ccw: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
> > >   vhost/vhost-user: Add VIRTIO_F_NOTIFICATION_DATA to vhost feature bits
> > >   virtio: Add VIRTIO_F_NOTIFICATION_DATA property definition
> > >
> > >  hw/block/vhost-user-blk.c    |  1 +
> > >  hw/net/vhost_net.c           |  2 ++
> > >  hw/s390x/s390-virtio-ccw.c   | 16 ++++++++++++----
> > >  hw/s390x/virtio-ccw.c        |  6 ++++--
> > >  hw/scsi/vhost-scsi.c         |  1 +
> > >  hw/scsi/vhost-user-scsi.c    |  1 +
> > >  hw/virtio/vhost-user-fs.c    |  2 +-
> > >  hw/virtio/vhost-user-vsock.c |  1 +
> > >  hw/virtio/virtio-mmio.c      | 15 +++++++++++----
> > >  hw/virtio/virtio-pci.c       | 16 +++++++++++-----
> > >  hw/virtio/virtio.c           | 18 ++++++++++++++++++
> > >  include/hw/virtio/virtio.h   |  5 ++++-
> > >  net/vhost-vdpa.c             |  1 +
> > >  13 files changed, 68 insertions(+), 17 deletions(-)
> > >
> > > --
> > > 2.39.3
> > >
> >

