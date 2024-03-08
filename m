Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169FE28DA5
	for <virtio-fs@lists.linux.dev>; Fri,  8 Mar 2024 17:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709919448; cv=none; b=DvfvTXLwMA0hOF23cf8jKyrRL7U0xuEte19i7QoTqmy6s6dUc5m231klinqQzCrhIW1qPJdaRZ4xoPN3UW59seK4SREYhhV10CQMhihouWewsT2j6O1DM4QJE9C+QBvAsG5b03DYIF4qyC8T7EzWv7fLkv60/4yNXlSy55AjM3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709919448; c=relaxed/simple;
	bh=/EiWdDBpzPPVd65iKqdavGj3UcKZkqkSV5onTJYHBaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LyU8Rd74jNJO0F18kBp4aXisXDsn1Z2bJ+51Xo7Vpa0Hoj8D1vadQ/tdg+pwSrfmZfYWKPxTLRIvFit52CBn8UaYqXW74kTK/HSLaQpOUa6rE4pjg2wpJofk/6H5pSy2SnDqhSoJqpLLdeQ/UBd21IDTruoRuiWaw7wyln/WWv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MfiCesyo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MfiCesyo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709919446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JW5qJ1RyhGf6smEE2z4UNavrXoakDST/SzLv7Y+wScQ=;
	b=MfiCesyovCbFaJC4s6n5UeiJO4N8oesyYzITtrF6BsUhPwJbthGLORi+QLQVQBMJcCU33O
	HLd0YnCm3ITQtXuZl8CYqM7w2yDD0pR/dv3X1jxlQAZKjxteuhVHshtwmRC9CLw9/XcHxG
	SOBOAou/BOMO0r7tyW4V1iWUfd7PfuQ=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-y6vgwSwKPs26oSXWZ2FfsQ-1; Fri, 08 Mar 2024 12:37:24 -0500
X-MC-Unique: y6vgwSwKPs26oSXWZ2FfsQ-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-dcdc3db67f0so3805586276.1
        for <virtio-fs@lists.linux.dev>; Fri, 08 Mar 2024 09:37:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709919444; x=1710524244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JW5qJ1RyhGf6smEE2z4UNavrXoakDST/SzLv7Y+wScQ=;
        b=mB7gDhQeXKdJ0jHlW7Wdk2eqkZAQ5WbewhQyCEAIw7kP6nkkCLuswL7VVpuDiHgYkq
         8eIkVqPxsBKseVwMyWHXsVDaL0waNrGyn2Y6zDpbDUiFefGGXEKBBoimaUBQW0MgodeJ
         BV2t332bxcKRvXJZ3X5K6DXLef5fl0EnBGokQjiJ0jk5N3YmvOBDEFhZrXHbsG6mmDjS
         bPQW8sZoQ0Wl558yoWzIv5ik0HgqkY7CSk6Zq1qVTDcFLjFWZI07JFrDh9F/q4hl8MQs
         6FEBGCWC9rXV0V5FH4qp2Pw/qVB38Oi+T0vcwTOPi7cOHv/hSEu58mk4gHRGd5vApAmN
         0UWg==
X-Forwarded-Encrypted: i=1; AJvYcCUFfjhVueWLdLSvNSqmd9xSXoS7sKa2ztZ7ty22EkYSOqiX+6CbLXCsUc2pa4pl/qQ6i9spQo9iZ9V18Ko64Lo0HQvSmJzRAUSm
X-Gm-Message-State: AOJu0YynUp/fSFkSWA0ERECvmAxzYIktnb5ff7JDRYOUh5hYSzFhAPqq
	iI+RGTp+Cx8YHYeLQcJ8jv6c8B8I3w1V8iwG0MGef6gPgNIXxaK53Cl9+VaCChaTHRhBRzF+J87
	gKc/kaUh/Lkw55IW98G1UVgDhENRYNdjrPQwYjhX/+8rnAgQG6IGwO+tsD4qtROCx9IvsX0Cm1h
	GV3RPOTPMGq40wZN6A2POFGGEwP8yqE8Rq
X-Received: by 2002:a25:1089:0:b0:dc6:b1ab:b400 with SMTP id 131-20020a251089000000b00dc6b1abb400mr897793ybq.18.1709919444063;
        Fri, 08 Mar 2024 09:37:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGjxyo2NspjIhzdNdSOlqVIgd6XaLIsGI0IssTeiz3u0sZ8aRGWXv699Ktslb564MoaYd0X8iZFtE1CD5aWmXM=
X-Received: by 2002:a25:1089:0:b0:dc6:b1ab:b400 with SMTP id
 131-20020a251089000000b00dc6b1abb400mr897777ybq.18.1709919443836; Fri, 08 Mar
 2024 09:37:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304194612.611660-1-jonah.palmer@oracle.com>
 <20240304194612.611660-3-jonah.palmer@oracle.com> <20240308115951-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240308115951-mutt-send-email-mst@kernel.org>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 8 Mar 2024 18:36:47 +0100
Message-ID: <CAJaqyWcRDjSXbgxMHbdPy_YO4boQthu_4_9zKYX3S5t-G1ju2g@mail.gmail.com>
Subject: Re: [PATCH v1 2/8] virtio-pci: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jonah Palmer <jonah.palmer@oracle.com>, qemu-devel@nongnu.org, jasowang@redhat.com, 
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

On Fri, Mar 8, 2024 at 6:01=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> On Mon, Mar 04, 2024 at 02:46:06PM -0500, Jonah Palmer wrote:
> > Prevent ioeventfd from being enabled/disabled when a virtio-pci
> > device has negotiated the VIRTIO_F_NOTIFICATION_DATA transport
> > feature.
> >
> > Due to ioeventfd not being able to carry the extra data associated with
> > this feature, the ioeventfd should be left in a disabled state for
> > emulated virtio-pci devices using this feature.
> >
> > Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>
> I thought hard about this. I propose that for now,
> instead of disabling ioevetfd silently we error out unless
> user disabled it for us.
> WDYT?
>

Yes, error is a better plan than silently disabling it. In the
(unlikely?) case we are able to make notification data work with
eventfd in the future, it makes the change more evident.

>
> > ---
> >  hw/virtio/virtio-pci.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> > index d12edc567f..287b8f7720 100644
> > --- a/hw/virtio/virtio-pci.c
> > +++ b/hw/virtio/virtio-pci.c
> > @@ -417,13 +417,15 @@ static void virtio_ioport_write(void *opaque, uin=
t32_t addr, uint32_t val)
> >          }
> >          break;
> >      case VIRTIO_PCI_STATUS:
> > -        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK)) {
> > +        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK) &&
> > +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)=
) {
> >              virtio_pci_stop_ioeventfd(proxy);
> >          }
> >
> >          virtio_set_status(vdev, val & 0xFF);
> >
> > -        if (val & VIRTIO_CONFIG_S_DRIVER_OK) {
> > +        if ((val & VIRTIO_CONFIG_S_DRIVER_OK) &&
> > +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)=
) {
> >              virtio_pci_start_ioeventfd(proxy);
> >          }
> >
> > --
> > 2.39.3
>

