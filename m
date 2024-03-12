Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD25378286
	for <virtio-fs@lists.linux.dev>; Tue, 12 Mar 2024 14:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710255518; cv=none; b=AoSJ67GXoVi/4Z08ZNTvR2Z57Z+KrxsyR0mefwRso4k/nsK/8hUdGeUtW6mLO3MJITiOa2zcGChm3wztpOrQnT677CUenXXyv8cdzSt0XhspURpyYJvric02It8DyiQF9ItSgKNn2IASM2QOPin2q6YPUBb1wSbNitVMqU7Pqhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710255518; c=relaxed/simple;
	bh=OleKom0q0lNJc+EN707T3kiKzXEQfepG1Csgl2o9d5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=hhN+mcRx4TpSofmc7rOfQf2OOhi6dJ/UFyZ4zdjH1o2nlEgENtoZytMKFnJjsdobb/VHGJ5SHSGdqDkhOEMFUPqNcOvrmUwXbgp5W8DpynUMnKACtBf36ym+4gbsinnGq1XCJch/WFBLwOBb3PSVEg7Ri9Di7ZQM1IKR+f3XVlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hty+Ez/E; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hty+Ez/E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710255515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i0gbQwhqZ9wZ5egl+qhYP/z049ASJoJ8DUDeDqmDK78=;
	b=hty+Ez/EiIS3/DN8P+q0WwS3jx6ynd4Rt2prs5uAUFx37AmpdOe4mnBYRNNYZhYY0j4qP1
	IQd/aHPRLpF4UObGiZfSI3CKOaQkkp4HoDwE/ufjbE9DVwRg4aFQUKx71RrrC1ZWSVQG4g
	CAshQzozzkpodxjw/UyevzwKVX9QSB8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-mZ0z0Mw7M2CCi3jeVidIxQ-1; Tue, 12 Mar 2024 10:58:27 -0400
X-MC-Unique: mZ0z0Mw7M2CCi3jeVidIxQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-33e7a004058so2548012f8f.2
        for <virtio-fs@lists.linux.dev>; Tue, 12 Mar 2024 07:58:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710255506; x=1710860306;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i0gbQwhqZ9wZ5egl+qhYP/z049ASJoJ8DUDeDqmDK78=;
        b=RKtb/E4nJeJjbHhioUlGSZv6TOsnv+rqS451eksQDAAI8rNhCyvrc67IWpFTKmu5m5
         T1lOr6g5A74tlmJ3qx18tuiybMnphmW2NYcVmLvAhA3sQdsjk+YKzX+0i3PlKaKqBanS
         DVjBfarYCVv+nCo6e8s1QYT7PbMzRxfH2LAMWKfPZjo7Hbdb588VNIJM2jzJbwO4uY/l
         ziLnbbA7LxCDFuIGyMuCzNNRYMpJHZUnyWRJmLEWi/GcvwbsOmkbKLTvPL1FcPm6D8Mh
         xu2vLWjWspQJrrRCv826CB4OLP2FFWaxtF1F8JYo/AzkD28aNOSx5zGLaw8cUrwLK8DU
         RQQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeeuAuCyj2/Q0XoXIyOFQPm2Aa7NjkSW76SMXuYikO8ujdz4dhYxrcDyuI7JNk2iPR0e9EIEeXgD9yxxnxc07fy4fAwbyqFSjN
X-Gm-Message-State: AOJu0YzjcKOo7URDGFsM44THLo8mG1bWiT/2c8n9FnDnmxYSGI1VPndk
	yizqLPlnqj7eC56FSoWIUQ9l9KIcNOYRF5vFhRAAT6rGwruzJ3aDgVKnBiC1m4Q6/UYT/SD4M40
	LfrT5TY/SeR4kdX383cWhDU153v08laCyjMmPWiIX53zhLKxmCy7ekJfkRw==
X-Received: by 2002:a05:600c:1d83:b0:413:25cc:296b with SMTP id p3-20020a05600c1d8300b0041325cc296bmr6721435wms.7.1710255505854;
        Tue, 12 Mar 2024 07:58:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnfJbNrmWMPAz1s26dAbwYRQEVFi+gBaefk5vjVkNMnfm/To3zr21TrDUjve7CpJdVkakKJw==
X-Received: by 2002:a05:600c:1d83:b0:413:25cc:296b with SMTP id p3-20020a05600c1d8300b0041325cc296bmr6721397wms.7.1710255505359;
        Tue, 12 Mar 2024 07:58:25 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f0:532c:5ae4:fce6:76e1:fa1a])
        by smtp.gmail.com with ESMTPSA id m7-20020a05600c4f4700b0041315f221c7sm12558503wmq.16.2024.03.12.07.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 07:58:24 -0700 (PDT)
Date: Tue, 12 Mar 2024 10:58:18 -0400
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
Message-ID: <20240312105706-mutt-send-email-mst@kernel.org>
References: <20240304194612.611660-1-jonah.palmer@oracle.com>
 <20240304194612.611660-3-jonah.palmer@oracle.com>
 <20240308115951-mutt-send-email-mst@kernel.org>
 <CAJaqyWcRDjSXbgxMHbdPy_YO4boQthu_4_9zKYX3S5t-G1ju2g@mail.gmail.com>
 <bf6e9625-0fc3-4bbb-9e36-fe6571aca8cb@oracle.com>
 <20240308141907-mutt-send-email-mst@kernel.org>
 <fc09c190-ff37-47a0-96a2-6b364e04d334@oracle.com>
 <20240311114638-mutt-send-email-mst@kernel.org>
 <c7a91e57-04eb-4ed1-8bb4-1d1b05894c8a@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c7a91e57-04eb-4ed1-8bb4-1d1b05894c8a@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Mar 12, 2024 at 10:33:51AM -0400, Jonah Palmer wrote:
> 
> 
> On 3/11/24 11:47 AM, Michael S. Tsirkin wrote:
> > On Mon, Mar 11, 2024 at 10:53:25AM -0400, Jonah Palmer wrote:
> > > 
> > > 
> > > On 3/8/24 2:19 PM, Michael S. Tsirkin wrote:
> > > > On Fri, Mar 08, 2024 at 12:45:13PM -0500, Jonah Palmer wrote:
> > > > > 
> > > > > 
> > > > > On 3/8/24 12:36 PM, Eugenio Perez Martin wrote:
> > > > > > On Fri, Mar 8, 2024 at 6: 01 PM Michael S. Tsirkin <mst@ redhat. com>
> > > > > > wrote: > > On Mon, Mar 04, 2024 at 02: 46: 06PM -0500, Jonah Palmer
> > > > > > wrote: > > Prevent ioeventfd from being enabled/disabled when a
> > > > > > virtio-pci > > device
> > > > > > ZjQcmQRYFpfptBannerStart
> > > > > > This Message Is From an External Sender
> > > > > > This message came from outside your organization.
> > > > > > Report Suspicious
> > > > > > <https://us-phishalarm-ewt.proofpoint.com/EWT/v1/ACWV5N9M2RV99hQ!Op20OCZE8kFi__wOXJ_Z0URZ2e_9fdaYz2tejZvKqiDgOm6ijq_imUptzxsrej_4riwCrBGeKmQ9VKXqnbV1ujbfiOV5-E2e1s3pKqpqUL-gRIuMQLDLygRD1hoX3Q$>
> > > > > > ZjQcmQRYFpfptBannerEnd
> > > > > > 
> > > > > > On Fri, Mar 8, 2024 at 6:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > 
> > > > > > > On Mon, Mar 04, 2024 at 02:46:06PM -0500, Jonah Palmer wrote:
> > > > > > > > Prevent ioeventfd from being enabled/disabled when a virtio-pci
> > > > > > > > device has negotiated the VIRTIO_F_NOTIFICATION_DATA transport
> > > > > > > > feature.
> > > > > > > > 
> > > > > > > > Due to ioeventfd not being able to carry the extra data associated with
> > > > > > > > this feature, the ioeventfd should be left in a disabled state for
> > > > > > > > emulated virtio-pci devices using this feature.
> > > > > > > > 
> > > > > > > > Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
> > > > > > > > Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> > > > > > > 
> > > > > > > I thought hard about this. I propose that for now,
> > > > > > > instead of disabling ioevetfd silently we error out unless
> > > > > > > user disabled it for us.
> > > > > > > WDYT?
> > > > > > > 
> > > > > > 
> > > > > > Yes, error is a better plan than silently disabling it. In the
> > > > > > (unlikely?) case we are able to make notification data work with
> > > > > > eventfd in the future, it makes the change more evident.
> > > > > > 
> > > > > 
> > > > > Will do in v2. I assume we'll also make this the case for virtio-mmio and
> > > > > virtio-ccw?
> > > > 
> > > > Guess so. Pls note freeze is imminent.
> > > 
> > > Got it. Also, would you mind elaborating a bit more on "error out"? E.g. do
> > > we want to prevent the Qemu from starting at all if a device is attempting
> > > to use both VIRTIO_F_NOTIFICATION_DATA and ioeventfd? Or do you mean
> > > something like still keep ioeventfd disabled but also log an error message
> > > unless it was explicitly disabled by the user?
> > 
> > 
> > my preference would be to block device instance from being created.
> > 
> 
> I could very well be missing something here, but I was looking to see how I
> could block the device from being created (realized) given the functional
> mismatch between negotiating the VIRTIO_F_NOTIFICATION_DATA feature and
> ioeventfd being enabled.
> 
> However, I realized that feature negotiation only happens after the virtio
> device has been realized and it's one of the last steps before the device
> becomes fully operational. In other words, we don't know if the guest
> (driver) also supports this feature until the feature negotiation phase,
> which is after realization.
> 
> So, during realization (e.g. virtio_device_realize), we know if the virtio
> device (1) intends to negotiate the VIRTIO_F_NOTIFICATION_DATA feature and
> (2) has enabled ioeventfd, however, we don't know if the driver will
> actually support this notification data feature.
> 
> Given this, we could block the device from being created if the device is
> *intending* to use the notification data feature along with ioeventfd, but
> this seems premature since we don't know if the feature will actually be
> successfully negotiated.

Yes this is the option I had in mind. Many devices with this feature
do not actually work if they do not get the extra data
so they fail FEATURES_OK, anyway.


> Another option might be check this during/immediately after feature
> negotiation, and then unrealize the device. However, I'm not sure if by this
> point it's "too late" to unrealize it.
> 
> There's also other options like defaulting to using notification data over
> ioeventfd (since a user would need to explicitly enable it, showing intent
> to actually use the feature), which is what we're doing now, except we could
> add some kind of warning message for the user. Another option could be
> setting the device to broken. However, these options don't align with your
> suggestion of removing the device completely.
> 
> Let me know how you'd like me to proceed with this. Thanks!
> 
> > > > > > > 
> > > > > > > > ---
> > > > > > > >    hw/virtio/virtio-pci.c | 6 ++++--
> > > > > > > >    1 file changed, 4 insertions(+), 2 deletions(-)
> > > > > > > > 
> > > > > > > > diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> > > > > > > > index d12edc567f..287b8f7720 100644
> > > > > > > > --- a/hw/virtio/virtio-pci.c
> > > > > > > > +++ b/hw/virtio/virtio-pci.c
> > > > > > > > @@ -417,13 +417,15 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
> > > > > > > >            }
> > > > > > > >            break;
> > > > > > > >        case VIRTIO_PCI_STATUS:
> > > > > > > > -        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK)) {
> > > > > > > > +        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK) &&
> > > > > > > > +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
> > > > > > > >                virtio_pci_stop_ioeventfd(proxy);
> > > > > > > >            }
> > > > > > > > 
> > > > > > > >            virtio_set_status(vdev, val & 0xFF);
> > > > > > > > 
> > > > > > > > -        if (val & VIRTIO_CONFIG_S_DRIVER_OK) {
> > > > > > > > +        if ((val & VIRTIO_CONFIG_S_DRIVER_OK) &&
> > > > > > > > +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
> > > > > > > >                virtio_pci_start_ioeventfd(proxy);
> > > > > > > >            }
> > > > > > > > 
> > > > > > > > --
> > > > > > > > 2.39.3
> > > > > > > 
> > > > > > 
> > > > 
> > 

