Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCAC12E1F1
	for <virtio-fs@lists.linux.dev>; Wed, 22 May 2024 15:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716392696; cv=none; b=Tha3emRHwPXte8iz5RhK1Bq9gB8jXv8Tf8H57OkGj1mkiz40tVRigmwnwoY9QmMrjMLvAr+n536E5706HgRm0d6ZP4rg14vraFla8HmNJK8FRY/zjp9NV7hloWhXJIlNhjxJceYT3FLZMcg9aVMJPAHK/ce8j76L1AqNeQm6XVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716392696; c=relaxed/simple;
	bh=vAbe2Pd3WPHMOmcOixE6BccKoesmeZ2Oo2Sz4ZXsTjM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=czBrrThCJsoa63fdnO87EtrQs/xC5gxk9FEXbl2bbw/+V+BhMpm1P1mTfsrYvkOSsNcuEsZBsfyNlPfKXLmMvdzQxLTXY/ZFXR415ctrrj7/cAAxdIcRCPBbs0ESRf5iek1kSfdiROJMofP8wgp1hpzkMM1oO4riWtBsOurqv30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Np18YXgi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Np18YXgi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716392693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6P5g06foTQHjIehNHQM0fLSeQ/78hvsOX+fFXtL4ybc=;
	b=Np18YXgi3V+3Ys3Y74u5L0KqGNVzEI0df3vJp8q3VTzJhJfIHn6TWwS/4RNvaRntYQ69xk
	MAVxcO2r5fwO5xGBf2WaiMsIU0Tq3k6Wu/14g0aUKOCmZawnWi8QSTgg7T0fJqqTyQoIIV
	0rQoBaJbylcbjaWmcyQ36yl9A2zoflQ=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-5DVjZCYPNQa_iAd2kL-MOQ-1; Wed, 22 May 2024 11:44:52 -0400
X-MC-Unique: 5DVjZCYPNQa_iAd2kL-MOQ-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-61b028ae5easo220176807b3.3
        for <virtio-fs@lists.linux.dev>; Wed, 22 May 2024 08:44:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716392691; x=1716997491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6P5g06foTQHjIehNHQM0fLSeQ/78hvsOX+fFXtL4ybc=;
        b=Ybb9jEzNw6bK+rU8EmFM1Nk7+qZbfGGmRnovUniPzAkJ7isXAqas7i6/nO16GJ0Pyj
         erNKun+cPbfnFqjAKE+OMXCick9mjZbHGUiSwodWU5YzpfpQNleCJdBj+ytJpHT9Xy5o
         0UxyYVERakF2HXgE5etG1PTrgo9sWh+OVeCNbMKc/mHMkM9xpeyEsNpggGMW95lDTeGH
         y8ncqj33xF/4Hw6WTIHzgXUmZhn/lwzJm86CHaPTHhsz5h8ohOGzS+SoWbJkIK9Fko+H
         r/5PWIlX9FLukoteHE3jWIFAOTcvFF7aHNg3wFeHyD140bJ6+19u4ZqrJ+L2KNsIx1x5
         J3JQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5ig+RHOb2TzLQYoEVUzuMcDOghJCa1TVDZDlnzUTATfK3ywtfpglfM3xShTHWzOvSUPV6DvgHU1Ik4/wZQHJ98S6HqUFyTlcv
X-Gm-Message-State: AOJu0Yxe6P+KclXjCE+ilnAHWOv+j6usS4HfFvBYG10CJljwdXS+PvxZ
	mNwmR1LrmvrwZ05fRlMpRGA6Eb/BMWdUMvf90CbZS6m40ZKYMo8e37Oxxj8GxPguXFMl+7yaE/j
	h+hFvGS/x9cq/6JL0aRB3AIXiexuIPDSiti/BIQiP9hvhGKAZTRMGpH5PrjPtvgOlxKIeBNsVUF
	FYzfX3jSCP6tsHaeYil+IWAhNQ+NZEI7Qy
X-Received: by 2002:a25:6843:0:b0:dc7:4806:4fb with SMTP id 3f1490d57ef6-df4e0a76659mr2797631276.8.1716392691678;
        Wed, 22 May 2024 08:44:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbMedPNBn/CdrAhJfvuumyMZqeSpkXqnuyBvbq0qsNWe5w6TS655ubpXFTN0aChcHkZySoGR8+1cN2s45uJD4=
X-Received: by 2002:a25:6843:0:b0:dc7:4806:4fb with SMTP id
 3f1490d57ef6-df4e0a76659mr2797597276.8.1716392691341; Wed, 22 May 2024
 08:44:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240520130048.1483177-1-jonah.palmer@oracle.com> <20240520130048.1483177-2-jonah.palmer@oracle.com>
In-Reply-To: <20240520130048.1483177-2-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 22 May 2024 17:44:14 +0200
Message-ID: <CAJaqyWcTh9YPMyitxoOZTxTjKishHCcNSz8wm1B2FRG4YdYGFg@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] virtio: Add bool to VirtQueueElement
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net, 
	kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, 
	fam@euphon.net, stefanha@redhat.com, qemu-block@nongnu.org, 
	schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev, 
	si-wei.liu@oracle.com, boris.ostrovsky@oracle.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 20, 2024 at 3:01=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
> Add the boolean 'in_order_filled' member to the VirtQueueElement structur=
e.
> The use of this boolean will signify whether the element has been process=
ed
> and is ready to be flushed (so long as the element is in-order). This
> boolean is used to support the VIRTIO_F_IN_ORDER feature.
>
> Tested-by: Lei Yang <leiyang@redhat.com>

The code has changed from the version that Lei tested, so we should
drop this tag until he re-test again.

Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  include/hw/virtio/virtio.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index 7d5ffdc145..88e70c1ae1 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -69,6 +69,8 @@ typedef struct VirtQueueElement
>      unsigned int ndescs;
>      unsigned int out_num;
>      unsigned int in_num;
> +    /* Element has been processed (VIRTIO_F_IN_ORDER) */
> +    bool in_order_filled;
>      hwaddr *in_addr;
>      hwaddr *out_addr;
>      struct iovec *in_sg;
> --
> 2.39.3
>

