Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A46F372ED0
	for <virtio-fs@lists.linux.dev>; Fri, 31 Jul 2026 08:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785488398; cv=pass; b=NF/5DKseh+rd0e4dfMmCaofkgvqPMp8lljNewu+8xuJ+5CUYZyAmdP+CZ1Ok2sE92otMMMLi5cPiNcQczjCdmc1O6lcofA7YvgQUhzzP57s1ZtwPFWw4IVhZMqYXh6SDwnXHvDyFRbQfgNngcYhD0wAaZBc1lBIS2BJZnLbsDUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785488398; c=relaxed/simple;
	bh=IsydLot76w3eidElrGPmDpd4sMHiEGvBOFtffxfRRVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nYP/5UWO4UIAAqo75UYnq3gArzMcEMn9yGCJuTFPv5CR6j6x23aq84vCw54JMhJ5xU1uyhR12kDH+0/siEb4vbcRsk70pjb73Ou5FgB2KxFyMo/Vy5iNCHoQve9eWuQtJ9DQKxmyB0P5t2YPFOfJPEdyx5PoPT4PtJ3+kvly+mM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wdd4LUg3; arc=pass smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wdd4LUg3"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-80c5cb9a888so8058317b3.3
        for <virtio-fs@lists.linux.dev>; Fri, 31 Jul 2026 01:59:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785488396; cv=none;
        d=google.com; s=arc-20260327;
        b=k6LNiI+t7Xf8U4zbezBibxpeQtjQtPWcChk/UvkZ9e2gD1rIWGoDNLOJuphFoIjquY
         OW0YuuzuTwL9iDkbk4d2RkZawMCPN2ivvj+LxLoT5+KQqq1Z2PoK7MKENK9IPKKBAQXe
         /q2hEBX6LJ4IWs6we25jxaFJ00N1P7rv5hi9HFv54txeN7TGXldfK30Dwk+t/U5iAkqF
         zLwtgpiBlz6C4JrH8LjVWlkol4Xs6kzq4FMkXNF5h9jzCk/QZ2pOuWLOBbR1BIS3yuXf
         +jQorl/E30NK2iJyOINkRNSUqz+l1OdUemhDpxZmG6r4uha5q6lvaSbNEfNc/BRaqizP
         xvQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IsydLot76w3eidElrGPmDpd4sMHiEGvBOFtffxfRRVk=;
        fh=uyOTeMDI6SNaXZnzWbn05GFzP0KDw+3k1EQVgoFr+TQ=;
        b=PxVTzUGDGKZUzQI5keCbdYUtih+WZRnQ6pqvJWjOiS+D6F6+oAQWTHIbvt16qeZRVx
         ykcGHsACfl9F3lhnaZXuj6AH0fbJeu/g53HVl6cP5o377hwWhg58uhxi5pSI2u9kY6Ja
         yDmkJGJLlUlu0LSY938u6EEi3Sysra8orKyiod/NahcybAAbwJwUAfuVJyl6+NZKShLW
         X/F+JvKkBZpfDb0sbwC31ynXrPHx26vaqV1LSIgmO+b47J9noyCfhJzer1ayNowKsg38
         86BMNn6IAByWoIMWNrxLKPRRurQnmQUnHIcddzy/L6oNknumWPvxp3AqzTCAIF3u8Qdt
         kVMg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1785488396; x=1786093196; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IsydLot76w3eidElrGPmDpd4sMHiEGvBOFtffxfRRVk=;
        b=wdd4LUg3zeCpRe/U3D6dIU9RkMlFXa2Q1MXTcJZxjbRZKjxJ8bdwXjhmCecqub94um
         6X7pFwTbi/D0coT7n7x7RSDm2+b6yrS+IQbCd3+nEloLsf9uxJn1Etvj72nGyOCabwIz
         5vJMIaI05gzlVsdaEcAVAlyH8nU/HzxT52msD+VFPButIocbh6DkMALEOxJvjiIpaEH5
         1zcomVxp7/WtAvgunDo4QbRBNuIfq4ckHr2jv581z2lOg3DoMf9m33aA6VKsx4JxIpmS
         bpgePlgbZUC3kJx3oNA7biCPKsGA7yacBJrbd8qunarmTTVxr9yBbwDA3vbvdkvZF71G
         +ccg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785488396; x=1786093196;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IsydLot76w3eidElrGPmDpd4sMHiEGvBOFtffxfRRVk=;
        b=o+bnudTMDrw295LOMUeZwJz+23dZKqIJuuBxfpybp7K7cIzGHfSqnAuyXyyiBP2uD6
         saiuBcgs7PhUaslZYmC8yXZuWWOPFxBI6y6E4zj6vjaLs89KduyeLlmv4dG2nEh/qlLX
         bCR92urD23A/5aa4SXEvleb6mVwFinZY8ObhH5ZPDmydfjFQH5AyG9CUqIzVL2e552nM
         BA1Q3qCNT5WULwaz868NQFGdrb52jEk+p4kRCezcxiCIPSfTBRM3iE7N50J62dB54b0o
         yQlVvvKsZzZ6Psr4Q+jWpZ4HdX2DNUoCR43CEpuJJ0iHvFVw5Jnr+5vPaz6AflZK60Ks
         dV3A==
X-Forwarded-Encrypted: i=1; AHgh+Ro3aUagntd4VlkutV3drhq2t/HAirDylMYUnATTNiADPruWn6Poy2ZBOZLut/Kfx/lp1v6LEMewiqo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyhJ1GxXtgvrFKjpEQSBdnYqyuROhApZmh6a+6S+hPFid2exTM1
	XwdfquXvzuE7ukiS8lluRqYz7DowpFdtrg7/8xWNmxzEIHt2fX3qUFemjL5ga4ejGGBHXlvGuBZ
	vv6IojqoqojnDy+gHR4RENoOCELRMGRfjDAtSeT+rNA==
X-Gm-Gg: AR+sD136+8ks3KqBcvMHjVaAqPPg7VsAwXW8XSZFvC5K7vpfXHJLkPNRuU7saJNOifK
	hEKf4bt8M+84KlYNOMGv534C/GpGibMTuuxRCinrshpqHr3xNCF0P1tbkD1iash5DO9dDJrTNv3
	ea8XWAx5s6v/RhQpUr7vwUUNSukkaeZPCyfufTIW0Ivqk8JlHKFPbrTQs+VqOplc0f6EOHwjTPi
	YKqlQUoNDtFXkUqD9xwg1DOaQISRuhylqpvUtOCONeuMWs4BaCLRJH/cA2Z7uvoGM3YFN+OEH/D
	Rfh4nSpkIZvA6JdX4/xNEd11jcrXqKLE6yxlpxar3Jq25HJeS38dAIueroY0ClniQlgIxSoYcP4
	IfXn3djG0tWb4GIK72ZrtcBG2RfSE6io6VrzOa7o=
X-Received: by 2002:a05:690c:4807:b0:80c:76fd:f732 with SMTP id
 00721157ae682-81fcc026845mr7407087b3.26.1785488396054; Fri, 31 Jul 2026
 01:59:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260730205846.19479-1-stefanha@redhat.com> <20260730205846.19479-2-stefanha@redhat.com>
 <eef9784f-5e68-4f1a-ba12-85ad4128116d@oss.qualcomm.com>
In-Reply-To: <eef9784f-5e68-4f1a-ba12-85ad4128116d@oss.qualcomm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 31 Jul 2026 09:59:44 +0100
X-Gm-Features: AUfX_mwgJ7FMSI5Sa--UvMnht7cK8I1xFB-yWuZ909qxzFa9jyxO6z7tQ5Cx9hI
Message-ID: <CAFEAcA-3zzanALJtPpOnd6iiVsgz9f9Ek5EHtQqQC5-6=0XogA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] virtio: make virtio_add_queue() queue_size an
 unsigned int
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@oss.qualcomm.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, 
	Kevin Wolf <kwolf@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	virtio-fs@lists.linux.dev, Hanna Reitz <hreitz@redhat.com>, 
	Gerd Hoffmann <kraxel@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Christian Schoenebeck <qemu_oss@crudebyte.com>, Dmitry Osipenko <dmitry.osipenko@collabora.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Dorjoy Chowdhury <dorjoychy111@gmail.com>, 
	"Gonglei (Arei)" <arei.gonglei@huawei.com>, Alexander Graf <graf@amazon.com>, 
	Laurent Vivier <lvivier@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, qemu-block@nongnu.org, 
	Greg Kurz <groug@kaod.org>, Raphael Norwitz <rnorwitz@nvidia.com>, Eric Auger <eric.auger@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Kuan-Wei Chiu <visitorckw@gmail.com>, Amit Shah <amit@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 31 Jul 2026 at 09:35, Philippe Mathieu-Daud=C3=A9
<philmd@oss.qualcomm.com> wrote:
>
> Hi Stefan,
>
> On 30/7/26 22:58, Stefan Hajnoczi wrote:
> > virtio_add_queue()'s queue_size argument is a signed int. The
> > vdev->vq[i].vring.num and num_default fields are already declared as
> > unsigned int, so change the virtio_add_queue() argument's type for
> > consistency.
> >
> > A note on consistency: the VIRTIO specification defines queue size as a=
n
> > unsigned 16-bit value.
>
> Why not use uint16_t then?

That's a bit awkward sometimes for a function like this that
is doing a bounds-check on the value. If a caller passes it an
argument that is a bigger type, then this function sees only
the lower 16 bits, and it might pass the bounds check, but
then the caller thinks the queue size is larger than this
layer of code thinks it is.

As a concrete example, the virtio-scsi callsite passes in
a value that is a uint32_t value settable by the user via
a QOM property, and it relies on this function to do the
upper bounds check for it.

-- PMM
