Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CD742A17D
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 20:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785789175; cv=pass; b=h4D5irhDJzOKUJ+UlQQTABZxU1tsWkeljy5CGMkUp79VjR5NO2U9pcVcKGYoy2J3wMMZ/1sfCueNux3ny6pVJ/YDrD60gymoj6zWLGP7NgeQbdEAuBx/S7umZ1cJYAj0j5H0zcylFM8WKjD6L/eY2pfRP4a1qrBxV/KaFDPhiHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785789175; c=relaxed/simple;
	bh=r0I90h3lL7jXiiUxa9hONJ+SIJN0Lo+ePF8bMe0foqU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aOihmU0AIcLcRxBF/nb4Om1z4RSbiQ42KyhaP+SL+Ax0TLlCIy37tJpPb1QdzgSHKf3f/s/okL45hMmSVuf097oezPSZj5mahFknGCiYGf8EiGVY5YW06zx7tsCKzEMm6V9W9z8CxWxb+D+l+Cg8U9bMXQnlt91Rp75oDY87tOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MYA2Nb8R; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MYA2Nb8R"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c0c45c580so23090661cf.0
        for <virtio-fs@lists.linux.dev>; Mon, 03 Aug 2026 13:32:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785789173; cv=none;
        d=google.com; s=arc-20260327;
        b=HGXt021IFBc583BhSs8Bz9tyc3lV9plDzJLZEsEMGuZYmZ4qby3D0eQkVByvKiw/Av
         meIMBv4FTC4yPt9030LFewJV2bgsP4ItWELh2Fhtc4qAxw4ps7ozYSg0SQ5Dd5JRyol2
         bKrMF47JnSF+IZYxPdohXyvsyE65r3/1zIPXFp7jPgaiQ3DaYNBjEvGth0F/8EmeyZ1O
         N9l/hup2taqROBCZkXkzzb12bhG+0jrFmPPI91jE8kOxTWadbBxL84FwE2HQ/MWreEuX
         7ALa3W6+yDmVWu4gYP777wcdBAVe2DYHWT0SUQdf4ryXVdxtx7zVTGguXzbQOz4T1S5h
         VT2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hCwtTTt4p/er8EyO83nYLEPRBSYBVwZi0eOgwfYj6sM=;
        fh=IBDk+xnwfj9ize1CWK25B6JN2JNK/fwwtDMxASPykBw=;
        b=SlLjw6yvTwX4o++LUSSvHfIgMs8a2RF5yF5sC9l5PHHsnjZwrzB/ULbTwrQKInR7CL
         NCB1tM1YDLMu5vpiaJNzDWajSU4XTIp0F+oZV3V2xouj6YyPlsICSmNjUJkamzPPo5Z6
         0S1VK6dM6VN2TWFxDLdAhZdINgny4lnf4ujLlRBjb19hivFSdm28f1ImGEvF/xuDmc+H
         RotEX1zj1M3FJiGanEVcMl91nmt0u7AaKoB7X9UPYcLkfWVMOevBXsu4Kc4DVwHaWvAG
         NpHYMC2w5Vpzw7kYSCulJJHxBYWfFDMKJG55ESji63suFP8lBNM4WzI9nW5wDJ/xDPqy
         jXGg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785789173; x=1786393973; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hCwtTTt4p/er8EyO83nYLEPRBSYBVwZi0eOgwfYj6sM=;
        b=MYA2Nb8R2McNtyTLEBspSlL2x/P6hDdNtZmiN0QBds7ylbSIzyE+7ZB6cRC3SMBxaS
         hq1SbP+nFSiH3RWKqmcIN7IiGEXT+i3cHg5VROLo/jlETUltzuaU2LWXniMkAurkSOFV
         MGUoL6T7uFoiZvABM7h+RnYzItTA1cYULXx/0U9ZChQlxqrJmn9eRVOEs2lAvcsI1Ov2
         CgDb9s+LSfIZGC8H2Vtt1wSLb/E2S/jh40kR/5L+K0RbQ7gnIhgVJuj9CHv1ijugwW2v
         sIte/Pi6tEmXez8LstRrYniPoxDlhRt/+TUVcWSScUwJq8gYB40rEXpYnnmfxwizh2eK
         62wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785789173; x=1786393973;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hCwtTTt4p/er8EyO83nYLEPRBSYBVwZi0eOgwfYj6sM=;
        b=bU8dVSO02NeNLyGq0kbd3VEyrMZrpesgi6ma0WrpbBy0PZ3+G3FE8zDltoEthGdXYy
         YVoEU+TG3RdQGicX8J9m6aNmiSrCSMEEejFUJGQRcGrUJkGM+RoaQHfnwNzFoQ1ViaAi
         ViK3Pn5n3p+UgQUVNoLQqAwmnSUrtScsYGk4TusNAtFjNcQUPMH8CdM513R59nJpa/4y
         Kau4/16T+G3Lpw/CUnC4Bih3l6J9COE8s6hlRksUGPgoF8UJLZ5TJclZYmZNBQTgWfbF
         VvjVb8IW/FmoplmDm9Z0uJeKtuujrfFOe0l6+lQmUlQmRp/Sr8Ne5dcjtETBwhU0rX0O
         9Oqg==
X-Forwarded-Encrypted: i=1; AHgh+RoxGr8nlAtFmHKsWgqbWk3gH0W0Mq4I21Ugp82d2YELjbqd5yDGou9jdY3MN7tzTEpeQFhVNFWRZwA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2h43FDtr5OPoxYAi/mWhlTxJuHXwaE46KPBCwBkTgt8tmZBYI
	9qExuDeWUE5K2ZOhZ4HNO1URlPuYtb3D7KksDRxy7iSr4wY2xBgPshC9aURz0sR1U1AReeL8ITz
	oJZHcADdNgiJ4xrCOGdRX65Sq2jyzzF4=
X-Gm-Gg: AR+sD12cPYaYESgkovECtHwkpLzGD5RqXP1eiN76SvO6C3CMnqr4xJRzjtfpOLiOEhj
	QBDPqoh5tQ5W/cj08GXHN/XKAzET3jxF02x8Wcu51D2lrRbZpZphKHkN9qna3h+lqTESP8Qj+CQ
	4jFwkI/klUAOKaYXblIl4tw/sc9waJyCwuc77iMuXg5LQjQglvElTJOKVnclX2cVvS4826xQosr
	hxUvhoGd/wt85bBIFf8EcdqjfcsDJWl+Dw/n+OqnFB0wbfW/I6tmD/oh0xmSjutnVvZ6f3OXQnb
	0yH1OueUF3zkFId/4B8XD9jxd42jCq4nbv2QUu1XNAMA5InzqaLgDSlBL3wKV3rz8VtcXC37lmN
	3
X-Received: by 2002:a05:622a:410d:b0:528:162e:29d3 with SMTP id
 d75a77b69052e-52b5686829emr249348801cf.32.1785789173039; Mon, 03 Aug 2026
 13:32:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-2-6b97c439eb28@gmail.com> <eb1d8424-206a-47f5-9ad5-a833a56bb3f3@redhat.com>
In-Reply-To: <eb1d8424-206a-47f5-9ad5-a833a56bb3f3@redhat.com>
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 3 Aug 2026 13:32:39 -0700
X-Gm-Features: AUfX_mxADHRsqJpTjVeUC1ttkitQKMfWB-ffhp4OzB1p5Jw_h04dsthg77bcW3Y
Message-ID: <CA+spn3pLkHn_Wk+-xa-k2PKXdDSa-S9c1Dd94t=Kj5tajPyzSA@mail.gmail.com>
Subject: Re: [PATCH RFC 02/15] vhost-user: Add memory-isolation qdev property
 to vhost-user devices
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 3, 2026 at 5:21=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
> Should `vhost_user_vga_inst_initfn()` set up an alias for
> "memory-isolation", like it does for "chardev" now?
>

I am not 100% sure but I can test to see.  If an alias is needed, I suspect
that would also apply to vhost-user-gpu-pci, right?

>
> There are four lines in here that the checkpatch script notes to be over
> 80 characters in length, so they should be broken up.
>

Got it.  This will be fixed for the next rev.

> [...]
>
> > diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
> > index 90bd2903db..d2a74a2860 100644
> > --- a/hw/virtio/vhost-user-base.c
> > +++ b/hw/virtio/vhost-user-base.c
> > @@ -409,7 +409,8 @@ static void vub_device_unrealize(DeviceState *dev)
> >
> >   /*Define common qdev properties.  Inherited by all children*/
> >   static const Property vub_properties[] =3D {
> > -    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev)
> > +    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
> > +    DEFINE_PROP_BOOL("memory-isolation", VHostUserBase, memory_isolati=
on, false)
>
> Nitpick: I would add a comma here. (This hunk shows specifically why
> it=E2=80=99s a good idea: So that future additions don=E2=80=99t have to =
change the line
> to add the comma.)
>

Ah, I was wondering why I was seeing so many hanging commas .  That makes s=
ense.
I will add the comma in.
