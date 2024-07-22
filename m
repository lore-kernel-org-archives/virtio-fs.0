Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DA116B399
	for <virtio-fs@lists.linux.dev>; Mon, 22 Jul 2024 11:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721646714; cv=none; b=Hq1K07zO/ekn9dHjLjQh1kj7jzGU6/I9ZRIGs/yGTzVrT7fPbQB+hKaE6EkAc9ExOT5urYwVj/PMSFudjX398r2WtCHU8NVXkf7FW2ur4stYGiXebd6H9IquGmEZRFCqohp0kcMigPHV9hk31Itza2EjjiV8vXF4rcSmQJaNT0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721646714; c=relaxed/simple;
	bh=kqNKznNA8jTtY2CmxJKY8GMNSqyARZIoTJ6t1KjkNqo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g8X0vgXENHLPp44pTgdtHYxzmsodB/UwwAM24n7BICo2CzFlz12X6rCh0n2LWOnZ//O/BqdfEC0WTKX66fNidQoBHDEZPLUNDYec+HwWTtWnZC2tBD5zHe9cC4cB/RponKMQzuXhG+RU+7bCNbveDE8L1qgz+0U9jedJ9eb/Xmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=akl3lEb2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="akl3lEb2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721646711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MB8xb3cQYchdpKTNa/Pfy7T0uzEe3LRRpxdyzALN0mw=;
	b=akl3lEb2O2jwaQoKyE2JqDv3y4W+rffT2fR9wOpgBf/A0W6MfCPN4lmFNfFKPtci9G41QC
	CWA4OuQgJfZUzz4J961VMs7njBlHqfrZG1ldoSwrAIRYR3REEx9MqyJMM8rqyEcZ3L+u6j
	Xvmvwo0YWPfHuRWdfZlfBydovjcECY8=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-SvOmyhv8OQybFmHXOqm5sQ-1; Mon, 22 Jul 2024 07:11:50 -0400
X-MC-Unique: SvOmyhv8OQybFmHXOqm5sQ-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-650b621f4cdso122365607b3.1
        for <virtio-fs@lists.linux.dev>; Mon, 22 Jul 2024 04:11:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721646709; x=1722251509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MB8xb3cQYchdpKTNa/Pfy7T0uzEe3LRRpxdyzALN0mw=;
        b=arwgglfmb++dFpeceGJt0uFaQPx3vZs6QzzIajtt7aSNlBOK//Ih52FAldfBXJgDXw
         iRoqBgPiPTmmv0Bx48K1Y/vWH95PlUMszysahv4tSoqfJ3p1MtaHnT1AIl8yTF0Sx9Xt
         JIgx+u9jIB2GRNsN3ZFkSwAiRTdoJM3fGX5yEs2Mrvh8hqfBayJHUzYzUI6lCjwC3wGJ
         zXywjrIMC0kpeM/iI4mTNfUTeIy4r4P+iU8SmYOZ9Q5XyIoAt+zKeprS+e+z1sTHE8+e
         8a2HQBNabD84lr6gXAviv98TGrk6Ubn6++BhFWFs4aqSMTJU2/g2fktnz7KJvUqAP7Cj
         Jkuw==
X-Forwarded-Encrypted: i=1; AJvYcCXXqwauyMOZ3O4yZAsfju3tKAwtuJcAQVTA8NdMGbtiQ6sodcHAvgygApzwuK7teAIlNsz+i1/E1xW2kz/3RgossCqp/IWxxdqw
X-Gm-Message-State: AOJu0Yz0tsgtY+jU8347Mp4iBgeLulUuYmy08CzSBiU46EE+h6i8m78r
	AXscYgP/SQQ7mjg3xGGw3E3lZNryuUrbJLwraoJkqyo17EwM9BkkhR6W2/y44GfuCuffOizUes0
	vyWsZeywRXJ8H5UE1OT7EN9f/8cYHt2mA5cgXS+r4oi3atxMfo1qQNCj/8xnMmB/s5UQRr7EygL
	WcA+sPbAcyjNx8o5usrAoDuET0XTbPBQfr
X-Received: by 2002:a05:690c:460c:b0:65f:645a:b3c4 with SMTP id 00721157ae682-66ada52c0ebmr68654047b3.32.1721646709002;
        Mon, 22 Jul 2024 04:11:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMwjxAdgWyzGQMKzT0m9Vw43++FUzxhNdxmx1F4qwoHQD+8GrTCN7F5ma7W16soDFk2v4D45bg++t/gTB14u4=
X-Received: by 2002:a05:690c:460c:b0:65f:645a:b3c4 with SMTP id
 00721157ae682-66ada52c0ebmr68653797b3.32.1721646708274; Mon, 22 Jul 2024
 04:11:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240710125522.4168043-1-jonah.palmer@oracle.com>
 <20240710125522.4168043-7-jonah.palmer@oracle.com> <20240720151557-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240720151557-mutt-send-email-mst@kernel.org>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 22 Jul 2024 13:11:09 +0200
Message-ID: <CAJaqyWesMrixZo+duwLqNUq311QpCvFJOWob8nnprYeK47T44g@mail.gmail.com>
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

On Sat, Jul 20, 2024 at 9:16=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Wed, Jul 10, 2024 at 08:55:19AM -0400, Jonah Palmer wrote:
> > Extend the virtio device property definitions to include the
> > VIRTIO_F_IN_ORDER feature.
> >
> > The default state of this feature is disabled, allowing it to be
> > explicitly enabled where it's supported.
> >
> > Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>
>
> Given release is close, it's likely wise.
> However, I think we should flip the default in the future
> release.
>

Should we post a new version with v9.2 tag enabling it?

> > ---
> >  include/hw/virtio/virtio.h | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> > index fdc827f82e..d2a1938757 100644
> > --- a/include/hw/virtio/virtio.h
> > +++ b/include/hw/virtio/virtio.h
> > @@ -373,7 +373,9 @@ typedef struct VirtIORNGConf VirtIORNGConf;
> >      DEFINE_PROP_BIT64("packed", _state, _field, \
> >                        VIRTIO_F_RING_PACKED, false), \
> >      DEFINE_PROP_BIT64("queue_reset", _state, _field, \
> > -                      VIRTIO_F_RING_RESET, true)
> > +                      VIRTIO_F_RING_RESET, true), \
> > +    DEFINE_PROP_BIT64("in_order", _state, _field, \
> > +                      VIRTIO_F_IN_ORDER, false)
> >
> >  hwaddr virtio_queue_get_desc_addr(VirtIODevice *vdev, int n);
> >  bool virtio_queue_enabled_legacy(VirtIODevice *vdev, int n);
> > --
> > 2.43.5
>

