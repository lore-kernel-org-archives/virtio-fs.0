Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD6817597
	for <virtio-fs@lists.linux.dev>; Mon, 22 Jul 2024 11:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721647912; cv=none; b=j/DKUZGSLE8WWUw2FYW4RKNrPgbFiwKOm5BRW0sJ+WPhCu+/r8zzdb9Ws6NtUqdxYD0AOuCXdAcBgq9WzRPlrPyJOtED/q4cqQtExIY2T7h2DFJi8RV9/Iy1GMYf8FI99rL0Hocj2adJBqv1E0kWowVm4PfbMteJCp+PbJ3cAmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721647912; c=relaxed/simple;
	bh=egzurD/aOvrR3oNAPDuR+tJW53sZkPYate0ltZlSEc0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=htsroFviPpSkhmJvSGhpr7qYUXaICyMCaQBymjKdKTOpLC30P0QVratbCBvdFq0HzATdodWiYwyoemo01f614GaeD7D2k8s65RsB/sDXUVu98QOl4pSSji2HL6q9TxbJrichP4LiusOr1Qb/s7LfyH+nVZDTUauNbnXWfWUcXfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aHnPNNdo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aHnPNNdo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721647908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gyPEZosLEJoPzw9jwU4q2rXpE+iQ8AW2A91E1ZFe2VA=;
	b=aHnPNNdoUGfK3YxP20iCPcZ8fXyLHJ8stl4P7vsSHuGs7T3cR2Lr+SXCOe7e2rglhXhXFR
	+dEatEWMBP/Kzw7p8uVnanjbahRbQw3L0Lr8EG0mpKfkIbHR9dlNDklo+O+xAQyGBWEFml
	8ojN65dpm+TbQULnUJzuyMW5o+8S/EQ=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-ckZHnKjONkSf2ouIs1-hfw-1; Mon, 22 Jul 2024 07:31:47 -0400
X-MC-Unique: ckZHnKjONkSf2ouIs1-hfw-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-6506bfeaf64so114129957b3.1
        for <virtio-fs@lists.linux.dev>; Mon, 22 Jul 2024 04:31:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721647907; x=1722252707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gyPEZosLEJoPzw9jwU4q2rXpE+iQ8AW2A91E1ZFe2VA=;
        b=P8y0an84+CYRxkSuQuf7xnjs8jSTrMuPgDaelvrMYH5kLCr0ff6mHO8Wi3UmSb/3wI
         yyG3CMUJ7i0cROAc2yIXbcxsC2RVGHbCDFmFdcPABRU1LqWfcEWMA6Exvj87T/kFNFIR
         zQrZSmb6A16pI/72JIwaj8M5VHJHx03H8QLmO8bUCrXQQ+ZFmUs57RF9Vow7PVDR+QcI
         3+SXjPSAP4qQ+gCPgJqcwFFNwoQvVoaoaryW6eoRbcBevU+p1dCXdFkTNtUs8Rg1gP8h
         Jk9Zvl11d/YZp6ATkAXKiQpCclt71fumbrm3wR2wC0p/5Ue3nmIaXZ6PlhnBTNdc9OT4
         bLDw==
X-Forwarded-Encrypted: i=1; AJvYcCWFulNe/YMBVUstLgAaDwy+wmOpc2PwGTDl3NimXfFBnAEKqOKPNS7JnklDVrlf9qzeLwgzel7bvVLuGNATv/8y7r+sBWU/QI4h
X-Gm-Message-State: AOJu0YzUzuM/ra2JP1wOrZS571w2QrUHuh0e9xRQsOP/Jj19JapPwtAi
	SeQ9gB2Fn6QnqSj9qv7cpjySCQp2vz5i/wUozKMF7H39qjeCwFr4RkddJ7k9CSAXUg4h+ltRay+
	iacipubp9rF5BqU6S9FDagu6LKcsd3Nb4c5S2h7v9jTprzNt8yORfkdtBnANSzJEysnPESkKVox
	o6JofO2W0i4Et3ckEvmM6knhSZMm6QFHZT
X-Received: by 2002:a05:690c:385:b0:64b:52e8:4ae3 with SMTP id 00721157ae682-66a634572c5mr112037687b3.3.1721647907177;
        Mon, 22 Jul 2024 04:31:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQTQYr8zUa+IMGMvfMYbjNUGaKxvIuGajLpSouFkn/6/PO5nx2TymcbwT6V7lNoEbakc2GJnKCtEa3UBrp3gE=
X-Received: by 2002:a05:690c:385:b0:64b:52e8:4ae3 with SMTP id
 00721157ae682-66a634572c5mr112037517b3.3.1721647906931; Mon, 22 Jul 2024
 04:31:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240710125522.4168043-1-jonah.palmer@oracle.com>
 <20240710125522.4168043-7-jonah.palmer@oracle.com> <20240720151557-mutt-send-email-mst@kernel.org>
 <CAJaqyWesMrixZo+duwLqNUq311QpCvFJOWob8nnprYeK47T44g@mail.gmail.com>
In-Reply-To: <CAJaqyWesMrixZo+duwLqNUq311QpCvFJOWob8nnprYeK47T44g@mail.gmail.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 22 Jul 2024 13:31:09 +0200
Message-ID: <CAJaqyWdU901wG=b1joD+ZH=sUOLzvwOJAYwCS=9PfWhsATAZkA@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] virtio: Add VIRTIO_F_IN_ORDER property definition
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jonah Palmer <jonah.palmer@oracle.com>, qemu-devel@nongnu.org, raphael@enfabrica.net, 
	kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, 
	fam@euphon.net, stefanha@redhat.com, qemu-block@nongnu.org, 
	schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev, 
	si-wei.liu@oracle.com, boris.ostrovsky@oracle.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 22, 2024 at 1:11=E2=80=AFPM Eugenio Perez Martin
<eperezma@redhat.com> wrote:
>
> On Sat, Jul 20, 2024 at 9:16=E2=80=AFPM Michael S. Tsirkin <mst@redhat.co=
m> wrote:
> >
> > On Wed, Jul 10, 2024 at 08:55:19AM -0400, Jonah Palmer wrote:
> > > Extend the virtio device property definitions to include the
> > > VIRTIO_F_IN_ORDER feature.
> > >
> > > The default state of this feature is disabled, allowing it to be
> > > explicitly enabled where it's supported.
> > >
> > > Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> >
> >
> > Given release is close, it's likely wise.
> > However, I think we should flip the default in the future
> > release.
> >
>
> Should we post a new version with v9.2 tag enabling it?
>

Sorry, actually I think this needs some more thought. Maybe in_order
hurts the performance of devices that are usually out of order, like
blk. Should we enable only for virtio-net and let each device code
decide?

> > > ---
> > >  include/hw/virtio/virtio.h | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> > > index fdc827f82e..d2a1938757 100644
> > > --- a/include/hw/virtio/virtio.h
> > > +++ b/include/hw/virtio/virtio.h
> > > @@ -373,7 +373,9 @@ typedef struct VirtIORNGConf VirtIORNGConf;
> > >      DEFINE_PROP_BIT64("packed", _state, _field, \
> > >                        VIRTIO_F_RING_PACKED, false), \
> > >      DEFINE_PROP_BIT64("queue_reset", _state, _field, \
> > > -                      VIRTIO_F_RING_RESET, true)
> > > +                      VIRTIO_F_RING_RESET, true), \
> > > +    DEFINE_PROP_BIT64("in_order", _state, _field, \
> > > +                      VIRTIO_F_IN_ORDER, false)
> > >
> > >  hwaddr virtio_queue_get_desc_addr(VirtIODevice *vdev, int n);
> > >  bool virtio_queue_enabled_legacy(VirtIODevice *vdev, int n);
> > > --
> > > 2.43.5
> >

