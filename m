Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B5C59B79
	for <virtio-fs@lists.linux.dev>; Fri,  8 Mar 2024 19:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709925577; cv=none; b=YNCNVQzA8sDEJEy2ss2GsLe737thHmLBlhZkRVCySwqzSUJFzztjNvaAEqnGqK60+wtr0mcNuXD7ZubQTmrk9PF/xed+VYmyZ8D7av486BIKaW1FkBRnALf4ViuttmdbskfT6YRcaJmDvazmYMpqHUrVhlt73ttj80L4deetBfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709925577; c=relaxed/simple;
	bh=9JoS55lD/ctpuUIppar8N819eVBvHkWLRv6KmhVcZQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=YlxDc5yW5F++teE8sqm4wYWxE3XOT095zCExPmKILsUJvHPB3uy9klFc+PuG2LB3eXkI0Mlhtn50fWj6iddf9R+15qglgGhM9a11sUPpFZ5TZnKhpSYL11XKCo3hzQrFQ8k2qR7Xf26Y6zElg7XP8CuNPnsRUUEzXzV8S6b8OLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZwSf70Sa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZwSf70Sa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709925574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ENLq0lAriYS+/yBGKq8tFVwidQtrEgyQ9rmcXEyDDsc=;
	b=ZwSf70SaEK2RoAtDLgSNEJI3qJB2DnUGpIB3zoVkxv59Jsonrylv8O7krF4DtLMmPv6Yxn
	4aamACiXZ8bEAb0Rrkv/mQE+VtHv2GWnjC0B/XNIlz6W7KSGWPoWNpfy64yM06ouPiO+7E
	9vWH0cVOBuVniVSssFHVG3AP0CqFd40=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589--p0I9hrjPpeC1SaBuJpLYQ-1; Fri, 08 Mar 2024 14:19:32 -0500
X-MC-Unique: -p0I9hrjPpeC1SaBuJpLYQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40e53200380so15038755e9.3
        for <virtio-fs@lists.linux.dev>; Fri, 08 Mar 2024 11:19:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709925571; x=1710530371;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ENLq0lAriYS+/yBGKq8tFVwidQtrEgyQ9rmcXEyDDsc=;
        b=hpLVGLf6q/tJmrzm6y33qsDvHfncKxAN5UZWwUUnjs8M1kDWEP2Iv90B+TLZ9oGDmO
         GmMoJPMIAqtr6bdm55qg+Hb4Cl5imXya7Z6Tq5LtNhoz+4Zz1GLnefCU8pSODXh3uiO1
         ag9RxN1XjfBtbJfoWi5L64ytbVilQjvw5l9mN4bpj3Z/R4dcTWilvnXWoSF0UfQpR5qo
         QQ6T3lQDBFXU/r83iq88r6cIrRIjzSfWJU1a2JamUb78G8y5BF8udnY7wMEYjU1Fou21
         97+i5IY5BELaKsz6Oj/18h0rFijImtp91m4MqQqaESdxIsl9MIczLPknkzvBkvCt5EcH
         egdg==
X-Forwarded-Encrypted: i=1; AJvYcCX0xn3pOMB62HHLSU4s8SfZYmfUZqcmwj5AcOjXlVGyD7GmAsYY99etc7rn5JcM4Z2EIbowUC0YU400cfxS/xdnUF/YWvqm16Xb
X-Gm-Message-State: AOJu0Yy3ShS4ag8kQLyNG7sfOXKjMCSeJRIpe7YbmyTSkhtqOnKJcbIu
	uOz9RhI3+HlgG7OriIgm5UVAvs0zoFl/56uXw0vaOVkJ7yqir6xq703HMaGiVBO4myQmn/kWe4F
	tdXdw+IHFP8p/rUjhZH/aV4xjigICweH5R6J85akdJPPzUrVV9QrGP/Ftjg==
X-Received: by 2002:a05:600c:1c9f:b0:412:fbc0:506b with SMTP id k31-20020a05600c1c9f00b00412fbc0506bmr130633wms.32.1709925571563;
        Fri, 08 Mar 2024 11:19:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG5p+6M8boh6PzuCEFRByiS7kWJB6JIGmQwlV1+hHB5AXDS8qX6MwUlZvJwcU1LR5ZED0Y80g==
X-Received: by 2002:a05:600c:1c9f:b0:412:fbc0:506b with SMTP id k31-20020a05600c1c9f00b00412fbc0506bmr130608wms.32.1709925570980;
        Fri, 08 Mar 2024 11:19:30 -0800 (PST)
Received: from redhat.com ([2a06:c701:73cd:f300:bc74:daca:b316:492a])
        by smtp.gmail.com with ESMTPSA id j27-20020a05600c1c1b00b00412f83e0c11sm6739431wms.22.2024.03.08.11.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 11:19:30 -0800 (PST)
Date: Fri, 8 Mar 2024 14:19:27 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: Eugenio Perez Martin <eperezma@redhat.com>, qemu-devel@nongnu.org,
	jasowang@redhat.com, si-wei.liu@oracle.com,
	boris.ostrovsky@oracle.com, raphael@enfabrica.net, kwolf@redhat.com,
	hreitz@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
	farman@linux.ibm.com, thuth@redhat.com,
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
	cohuck@redhat.com, pbonzini@redhat.com, fam@euphon.net,
	stefanha@redhat.com, qemu-block@nongnu.org, qemu-s390x@nongnu.org,
	virtio-fs@lists.linux.dev
Subject: Re: [PATCH v1 2/8] virtio-pci: Lock ioeventfd state with
 VIRTIO_F_NOTIFICATION_DATA
Message-ID: <20240308141907-mutt-send-email-mst@kernel.org>
References: <20240304194612.611660-1-jonah.palmer@oracle.com>
 <20240304194612.611660-3-jonah.palmer@oracle.com>
 <20240308115951-mutt-send-email-mst@kernel.org>
 <CAJaqyWcRDjSXbgxMHbdPy_YO4boQthu_4_9zKYX3S5t-G1ju2g@mail.gmail.com>
 <bf6e9625-0fc3-4bbb-9e36-fe6571aca8cb@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <bf6e9625-0fc3-4bbb-9e36-fe6571aca8cb@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Mar 08, 2024 at 12:45:13PM -0500, Jonah Palmer wrote:
> 
> 
> On 3/8/24 12:36 PM, Eugenio Perez Martin wrote:
> > On Fri, Mar 8, 2024 at 6: 01 PM Michael S. Tsirkin <mst@ redhat. com>
> > wrote: > > On Mon, Mar 04, 2024 at 02: 46: 06PM -0500, Jonah Palmer
> > wrote: > > Prevent ioeventfd from being enabled/disabled when a
> > virtio-pci > > device
> > ZjQcmQRYFpfptBannerStart
> > This Message Is From an External Sender
> > This message came from outside your organization.
> > Report Suspicious
> > <https://us-phishalarm-ewt.proofpoint.com/EWT/v1/ACWV5N9M2RV99hQ!Op20OCZE8kFi__wOXJ_Z0URZ2e_9fdaYz2tejZvKqiDgOm6ijq_imUptzxsrej_4riwCrBGeKmQ9VKXqnbV1ujbfiOV5-E2e1s3pKqpqUL-gRIuMQLDLygRD1hoX3Q$>
> > ZjQcmQRYFpfptBannerEnd
> > 
> > On Fri, Mar 8, 2024 at 6:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > 
> > > On Mon, Mar 04, 2024 at 02:46:06PM -0500, Jonah Palmer wrote:
> > > > Prevent ioeventfd from being enabled/disabled when a virtio-pci
> > > > device has negotiated the VIRTIO_F_NOTIFICATION_DATA transport
> > > > feature.
> > > >
> > > > Due to ioeventfd not being able to carry the extra data associated with
> > > > this feature, the ioeventfd should be left in a disabled state for
> > > > emulated virtio-pci devices using this feature.
> > > >
> > > > Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
> > > > Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> > > 
> > > I thought hard about this. I propose that for now,
> > > instead of disabling ioevetfd silently we error out unless
> > > user disabled it for us.
> > > WDYT?
> > > 
> > 
> > Yes, error is a better plan than silently disabling it. In the
> > (unlikely?) case we are able to make notification data work with
> > eventfd in the future, it makes the change more evident.
> > 
> 
> Will do in v2. I assume we'll also make this the case for virtio-mmio and
> virtio-ccw?

Guess so. Pls note freeze is imminent.
> > > 
> > > > ---
> > > >  hw/virtio/virtio-pci.c | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> > > > index d12edc567f..287b8f7720 100644
> > > > --- a/hw/virtio/virtio-pci.c
> > > > +++ b/hw/virtio/virtio-pci.c
> > > > @@ -417,13 +417,15 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
> > > >          }
> > > >          break;
> > > >      case VIRTIO_PCI_STATUS:
> > > > -        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK)) {
> > > > +        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK) &&
> > > > +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
> > > >              virtio_pci_stop_ioeventfd(proxy);
> > > >          }
> > > >
> > > >          virtio_set_status(vdev, val & 0xFF);
> > > >
> > > > -        if (val & VIRTIO_CONFIG_S_DRIVER_OK) {
> > > > +        if ((val & VIRTIO_CONFIG_S_DRIVER_OK) &&
> > > > +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
> > > >              virtio_pci_start_ioeventfd(proxy);
> > > >          }
> > > >
> > > > --
> > > > 2.39.3
> > > 
> > 

