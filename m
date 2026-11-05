Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793888987;
	b=g/lS0c+oMOfGpaKr8amsuM1cw6iPCL9yz9HG6j0xOjz6o7ceKMly3n05W2Ry4BK2MjsL
	 lugq4u9fFSoQnM8L9TXIX69eGlT2wwDMYsQVvHWW1FE8BpE4VuYwQyHG+NcfZ6X1Fi9mr
	 FmHXlhT1x7hhtn76cr0T8X3D71CVqy2dM6KuLt9aViKQt+bIb8sH+1WmzX7HGYpQn8U8C
	 Ic10My+hnh7/Y2ErPwTPyafuEcAGoWlrcts/2VilyOTXZe2AhXlqrtDkXJwUhpBJRN1Q3
	 O+zqm01iduzW/xhhZg5gztjIVC+cQADqzF7o3eADXU7KgHO8S9VdoeXYQH++HEwF1JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793888987;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:In-Reply-To:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=pjtj63fo+s61GN+f9LF+Yf7YLV6I3/P5rwrY4Pl9Izk=;
	b=sOl8/f4NaXRk9xMxvjFWwlhzFLg2CCbx3ttGvXXMeyy0QwfRsmKLWsYefvu+2oqFIHYZ
	 cxtxpAyXol+0mXKwWQRfcq9SLkNTYX3aHsq0AmAUpGacMmsqS0NBPdtRlhhXGlI00JLSM
	 iMHnSk/aCNYmjxds3rrY9yGB7wAJztqbeWByCBddHPxte5XdeicfHHoBASkKErhz0HBRv
	 yQIJWYN0WGWQuC1bxT0fJi0cetJKsxD+HHBxLelcVOIvYv/oIHf+lMTGF1jXcgmU1mqN1
	 EKaCtb2oWP53IuR0/S3Q7WRU8oWmoYNTwtWa1kRetj70HLBHMmr3Gq2dfvshTfYkFmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DqfCaRY+;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6CC606A329
	for <virtio-fs@lists.linux.dev>; Thu,  5 Nov 2026 14:29:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C6CC606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DqfCaRY+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793888985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pjtj63fo+s61GN+f9LF+Yf7YLV6I3/P5rwrY4Pl9Izk=;
	b=DqfCaRY+D9ZlOKyiBjSs+8USD6qmzGUl+tkXo2zI802HzpfbNBIqwCpMl/LWjehCST4aRc
	Q8LLVOCA84msskgbemLrmf1aXpYQRLXSmlI6WdQn7MuFQY7wJgTy3uQ3EFDvFN0mD2XK6t
	EHt9c9OVPBm3EyHZ7WqYWlghR1iw6wM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-229GSJshMmObBbyfeag7Vg-1; Thu, 05 Nov 2026 09:29:44 -0500
X-MC-Unique: 229GSJshMmObBbyfeag7Vg-1
X-Mimecast-MFC-AGG-ID: 229GSJshMmObBbyfeag7Vg_1793888983
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a2063be13dso22155495e9.3
        for <virtio-fs@lists.linux.dev>; Thu, 05 Nov 2026 06:29:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793888983; x=1794493783;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pjtj63fo+s61GN+f9LF+Yf7YLV6I3/P5rwrY4Pl9Izk=;
        b=g3NgXhNL3JDAF1pvXsgsE7F9VgBjhAWF5QGYiWb3tHC3ivuZbdTPpo1Iuqd0Slh9S6
         gnG2k4NcrAyd3MJTEcfl5vDoLBjr9G+TCQFEf7YSle7v0a8C7qKvuEKVBDmQD9lYZL2X
         wnUPCwQSl6GQ3z83c6ucnddKqr/sQgEGCbkhUciXjY7xw/wJ2NHAENg8LAisHRbOCOUg
         G3q9Vjq3X0/5nYXENBSF4xs16usvKUULexXnd+NcmNPvUBKFNPqNRvXZd63HbrddjmFI
         qYWir3v6G/m2FsDn+PCVU1PSMLNg7cpjPKIOLhzatz58dwk7ZwSo/pfwsSFBAbTOjxMs
         QHXg==
X-Forwarded-Encrypted: i=1; AKwUvBwA3tAZnWhCMczAJj/aySgG0qPxV2JSmBgb3GSKHMIIml7ndzOTQotclCxEdcG9NnGOjM9W4NM10ME=@lists.linux.dev
X-Gm-Message-State: APuU4Z8MOGy5NZwib+ZcKThbxuLEQ6xa1EUedjr42JjkAUfPWULAea9d
	5kCp6kkg2x8SfDNfV62/lNBGrdaCwcPPsKHCodq4JISqwobEUqTm1mMQpkKO4kQKg1mckPNPZdH
	DRUYE4rhZK4MlBGRnwBFrpYd1MSDbNWM5xhbTZdRQeFTmDwzX0cY6dwzIp1ZLjw==
X-Gm-Gg: AYBFou1nOZ57WSM6bAKD+6ChHr5OTrRu8i48ioJMO0k42mJmrQe2XN/8cJDvFCuiFWB
	PckS6WQxx+r6lF8X+K+K4JkjURtKMClAkOESlDczZ8qgOqyntYR3jzPRIKnGJ0hplnU4OUVErgj
	nR92zwAwzgg6oSJK7Y692sj/iW3ldfxmGQfCf0paokikK/Fj7yvilyPgr9+alysngaSvSirvQLN
	vbshvdyVeXIMi8SCZgYtmct+FZ2SVO+e33UuZNE3YYELCV6Qa8yiqeC15+QSsoc9sBYB/eQqjxU
	QPTnOetFt19k+Ke6yssK0eiQ33DBZSKzQr8RIzbYHq3WfSIcx/m1KdqDeJwey/n1zfAgqFNPzXZ
	KqKChoiac6whA7234FiNpW5eEq9pEx04ExDtvPqStpoDZ5jGP
X-Received: by 2002:a05:600c:4454:b0:4a3:5a7b:6002 with SMTP id 5b1f17b1804b1-4ac17d19777mr413960915e9.28.1793888982793;
        Thu, 05 Nov 2026 06:29:42 -0800 (PST)
X-Received: by 2002:a05:600c:4454:b0:4a3:5a7b:6002 with SMTP id 5b1f17b1804b1-4ac17d19777mr413960505e9.28.1793888982262;
        Thu, 05 Nov 2026 06:29:42 -0800 (PST)
Received: from sgarzare-redhat ([94.32.51.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56e2ae72dsm118795875e9.3.2026.11.05.06.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 06:29:41 -0800 (PST)
Date: Thu, 5 Nov 2026 15:29:27 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Cc: qemu-devel@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, 
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>, "Dr . David Alan Gilbert" <dgilbert@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@lists.linux.dev
Subject: Re: [PATCH] vhost-user-fs: fix virtqueue array leak on realize
 failure
Message-ID: <auyR97ogGdws_udv@sgarzare-redhat>
References: <20261104080939.439160-1-dtalexundeer@yandex-team.ru>
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Post: <mailto:virtio-fs@lists.linux.dev>
List-Help: <mailto:virtio-fs+help@lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
List-Owner: <mailto:virtio-fs+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261104080939.439160-1-dtalexundeer@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zXCv5WUU00WhGR6QSEj7kGQTOk3DDVcMg7TRTckn1-0_1793888983
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Wed, Nov 04, 2026 at 01:09:39PM +0500, Alexandr Moshkov wrote:
>On failure, vhost_dev_init() clears vhost_dev, so the error path frees
>NULL instead of the virtqueue array. Save the pointer locally and use
>it to free the array on failure.
>
>Fixes: 98fc1ada4cf7 ("virtio: add vhost-user-fs base device")
>Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
>---
> hw/virtio/vhost-user-fs.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
>index 0d8842817a..9b33fe13bb 100644
>--- a/hw/virtio/vhost-user-fs.c
>+++ b/hw/virtio/vhost-user-fs.c
>@@ -198,6 +198,7 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
> {
>     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
>     VHostUserFS *fs = VHOST_USER_FS(dev);
>+    struct vhost_virtqueue *vhost_vqs;
>     unsigned int i;
>     size_t len;
>     int ret;
>@@ -255,7 +256,8 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
>
>     /* 1 high prio queue, plus the number configured */
>     fs->vhost_dev.nvqs = 1 + fs->conf.num_request_queues;
>-    fs->vhost_dev.vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
>+    vhost_vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);

While checking if others users of vhost_dev_init() have the same issues, 
I discovered that most of them store it in the parent structure (the 
equivalent of VHostUserFS). Then looking at VHostUserFS I discovered 
that we already have the vhost_vqs field there since the beginning, but 
we never used it, so what about using that one here and in 
vuf_device_unrealize() ?

Thanks,
Stefano

>+    fs->vhost_dev.vqs = vhost_vqs;
>     ret = vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
>                          VHOST_BACKEND_TYPE_USER, 0, errp);
>     if (ret < 0) {
>@@ -272,7 +274,7 @@ err_virtio:
>     }
>     g_free(fs->req_vqs);
>     virtio_cleanup(vdev);
>-    g_free(fs->vhost_dev.vqs);
>+    g_free(vhost_vqs);
> }
>
> static void vuf_device_unrealize(DeviceState *dev)
>-- 
>2.34.1
>

