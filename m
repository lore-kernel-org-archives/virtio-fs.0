Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1498744369
	for <virtio-fs@lists.linux.dev>; Mon, 11 Mar 2024 15:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710172039; cv=none; b=PTmJpYHMUQVnqPWKONGSMBtf17S5HVcmqBhl8LX9io4Vte6TfuWa5Pk71jnuoyeuIS69qYBcVf8t7uQP9lnemkhT6MmOlYpDww2zfN8LwIEeooitoRxhtylqFeSP0N/ma11Iplq19rerTNrSIXe6oP5dQd9lFIPyju+tZQ+JISM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710172039; c=relaxed/simple;
	bh=+nwQXLIyVHJbfnbXxAZkI1XLbVicArFEUYHVKNe44Go=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ZEyD65nk1aDBn/0rqFSR8CvHDOL+I+og3SDVfCP3n3dG805i5U/LYG6uQG/l+GY5xyTUzPJISllf2MGYWBj8ARkNt3e4HP4TtYcSX50Nu7aDfAG3RLp+/KGN6FqcPVgofvjbz1EY92Gr89kI/RCUXJmJQTkqi3bCHSNvaVM/uxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ELABB0Bd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ELABB0Bd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710172037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WjmQZzDFACeoU2oayorDV0oWe9R9owuxVswF22wwuD8=;
	b=ELABB0BdnzQ403xh0OcgN7owg3DRO6QFOy7/UQnZfh5Ky8TDHEbr3cYFmLdDUBBxoLSAmQ
	cB242guo/v9crBCseipbz2DmeQxRUTLQYhmSwEoQo1mRnEmC5bER4FACtSAweCeOYjRAuL
	BloRmSbpb8vyufphnzMLonOBtFLA03U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-Qiu2nAvcM6KVX-rQcnctBQ-1; Mon, 11 Mar 2024 11:47:15 -0400
X-MC-Unique: Qiu2nAvcM6KVX-rQcnctBQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33e6fd52037so2432558f8f.0
        for <virtio-fs@lists.linux.dev>; Mon, 11 Mar 2024 08:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710172034; x=1710776834;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WjmQZzDFACeoU2oayorDV0oWe9R9owuxVswF22wwuD8=;
        b=Eii4hTAGgbwGH8mQstUA0nx2DCiRQG5j/3uUMCbic4Y8T5k7ykg9slxw8rWYgzkXPn
         vg6lgUoLuSxi6eV+pywyOVSKLJMDCM2g83xrFRHxkq5Zrw9Uj+8C834lyfd/Z03Q3pkZ
         xcdZoCtPNJA+j8nFLREqFl6At9K1XWuPbGKwHBet8DYAZtUFzhG6Oyw0CBS7sZU+XhhW
         8gqeyajQwFl6KpW5XXQwBzVXe+J4hdwC/+TENqt9NjSC7+5h87Qnf2h/MeHwcl6dAb4Z
         ksd29QxETrtk9jfGDnrg3VS7Tt7qayszZnCCNNktHMko9B1ELxC9OuH5V9agZ8BbvhJy
         V8IQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqFFOccwrQG4fGtDxCtMvgRvqz/bZlJsqMNlYWwWsBp3nc/7KLWDiP7JOQ6VHEa+0TrN0D42N2BTbd38w6JQLLKrW3DW4MVe43
X-Gm-Message-State: AOJu0Ywaygd/jLai/DraURxqB1bHILEjc2blw05jegpVWmuYjvMMnZsC
	HJWSpnxhAOIkK7J+Wz9iGyGaBJNIJ7goTAIiq0YGePl2gmWAWEfe2wjESHKpxzDvq7X6qGxFugb
	3qnHFQcLZFYZpBYoThrxqz6MMf2l74cEDJcY+QlXsiSzfoDgKKzLU+48mYA==
X-Received: by 2002:a05:600c:5011:b0:413:2bcf:de2c with SMTP id n17-20020a05600c501100b004132bcfde2cmr1676871wmr.9.1710172034399;
        Mon, 11 Mar 2024 08:47:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjtKXfByZD0Wjo8MO3ViqbZqdmvZNzLButYRAZlxc7X86skDZ2T6f5EBgwbnH1y98ekwc/1w==
X-Received: by 2002:a05:600c:5011:b0:413:2bcf:de2c with SMTP id n17-20020a05600c501100b004132bcfde2cmr1676847wmr.9.1710172033837;
        Mon, 11 Mar 2024 08:47:13 -0700 (PDT)
Received: from redhat.com ([2.52.134.16])
        by smtp.gmail.com with ESMTPSA id iv17-20020a05600c549100b00413160baa9bsm13204524wmb.10.2024.03.11.08.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 08:47:13 -0700 (PDT)
Date: Mon, 11 Mar 2024 11:47:08 -0400
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
Message-ID: <20240311114638-mutt-send-email-mst@kernel.org>
References: <20240304194612.611660-1-jonah.palmer@oracle.com>
 <20240304194612.611660-3-jonah.palmer@oracle.com>
 <20240308115951-mutt-send-email-mst@kernel.org>
 <CAJaqyWcRDjSXbgxMHbdPy_YO4boQthu_4_9zKYX3S5t-G1ju2g@mail.gmail.com>
 <bf6e9625-0fc3-4bbb-9e36-fe6571aca8cb@oracle.com>
 <20240308141907-mutt-send-email-mst@kernel.org>
 <fc09c190-ff37-47a0-96a2-6b364e04d334@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <fc09c190-ff37-47a0-96a2-6b364e04d334@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Mar 11, 2024 at 10:53:25AM -0400, Jonah Palmer wrote:
> 
> 
> On 3/8/24 2:19 PM, Michael S. Tsirkin wrote:
> > On Fri, Mar 08, 2024 at 12:45:13PM -0500, Jonah Palmer wrote:
> > > 
> > > 
> > > On 3/8/24 12:36 PM, Eugenio Perez Martin wrote:
> > > > On Fri, Mar 8, 2024 at 6: 01 PM Michael S. Tsirkin <mst@ redhat. com>
> > > > wrote: > > On Mon, Mar 04, 2024 at 02: 46: 06PM -0500, Jonah Palmer
> > > > wrote: > > Prevent ioeventfd from being enabled/disabled when a
> > > > virtio-pci > > device
> > > > ZjQcmQRYFpfptBannerStart
> > > > This Message Is From an External Sender
> > > > This message came from outside your organization.
> > > > Report Suspicious
> > > > <https://us-phishalarm-ewt.proofpoint.com/EWT/v1/ACWV5N9M2RV99hQ!Op20OCZE8kFi__wOXJ_Z0URZ2e_9fdaYz2tejZvKqiDgOm6ijq_imUptzxsrej_4riwCrBGeKmQ9VKXqnbV1ujbfiOV5-E2e1s3pKqpqUL-gRIuMQLDLygRD1hoX3Q$>
> > > > ZjQcmQRYFpfptBannerEnd
> > > > 
> > > > On Fri, Mar 8, 2024 at 6:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > 
> > > > > On Mon, Mar 04, 2024 at 02:46:06PM -0500, Jonah Palmer wrote:
> > > > > > Prevent ioeventfd from being enabled/disabled when a virtio-pci
> > > > > > device has negotiated the VIRTIO_F_NOTIFICATION_DATA transport
> > > > > > feature.
> > > > > > 
> > > > > > Due to ioeventfd not being able to carry the extra data associated with
> > > > > > this feature, the ioeventfd should be left in a disabled state for
> > > > > > emulated virtio-pci devices using this feature.
> > > > > > 
> > > > > > Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
> > > > > > Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> > > > > 
> > > > > I thought hard about this. I propose that for now,
> > > > > instead of disabling ioevetfd silently we error out unless
> > > > > user disabled it for us.
> > > > > WDYT?
> > > > > 
> > > > 
> > > > Yes, error is a better plan than silently disabling it. In the
> > > > (unlikely?) case we are able to make notification data work with
> > > > eventfd in the future, it makes the change more evident.
> > > > 
> > > 
> > > Will do in v2. I assume we'll also make this the case for virtio-mmio and
> > > virtio-ccw?
> > 
> > Guess so. Pls note freeze is imminent.
> 
> Got it. Also, would you mind elaborating a bit more on "error out"? E.g. do
> we want to prevent the Qemu from starting at all if a device is attempting
> to use both VIRTIO_F_NOTIFICATION_DATA and ioeventfd? Or do you mean
> something like still keep ioeventfd disabled but also log an error message
> unless it was explicitly disabled by the user?


my preference would be to block device instance from being created.

> > > > > 
> > > > > > ---
> > > > > >   hw/virtio/virtio-pci.c | 6 ++++--
> > > > > >   1 file changed, 4 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> > > > > > index d12edc567f..287b8f7720 100644
> > > > > > --- a/hw/virtio/virtio-pci.c
> > > > > > +++ b/hw/virtio/virtio-pci.c
> > > > > > @@ -417,13 +417,15 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
> > > > > >           }
> > > > > >           break;
> > > > > >       case VIRTIO_PCI_STATUS:
> > > > > > -        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK)) {
> > > > > > +        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK) &&
> > > > > > +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
> > > > > >               virtio_pci_stop_ioeventfd(proxy);
> > > > > >           }
> > > > > > 
> > > > > >           virtio_set_status(vdev, val & 0xFF);
> > > > > > 
> > > > > > -        if (val & VIRTIO_CONFIG_S_DRIVER_OK) {
> > > > > > +        if ((val & VIRTIO_CONFIG_S_DRIVER_OK) &&
> > > > > > +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
> > > > > >               virtio_pci_start_ioeventfd(proxy);
> > > > > >           }
> > > > > > 
> > > > > > --
> > > > > > 2.39.3
> > > > > 
> > > > 
> > 

