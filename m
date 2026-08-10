Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1647430CFD
	for <virtio-fs@lists.linux.dev>; Mon, 10 Aug 2026 17:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786383625; cv=pass; b=uT+kCLVibw2L6j2ztzB4x6sUkdv10Kvqd/yL3aXXxkh2qlGlMdeY2TUj7TIG+blClStqCdTHWE0wMntnAYgUIIpu43gaN7YBMVOHoW3Rp9Va8mxCrBtCTLZ/B42KFrTzbCJSYnyDKfMOkT44DNaCagg7tJx7cLoxsdX0OEU9kg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786383625; c=relaxed/simple;
	bh=TNO8th/GDX1Gf9WK/6J8uXsFeOsJ9XQ2yiBWsQA3pFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eRLhGf4htS2J+p+tdGCBGDM+rubD/Rtw55ouiyEsqAHbiZScrb5kmA9/Pz+BkSi9oMZxAtPE4XR/yQm1xhPj1RmuGFeqUyOzmQMzVtzk5wOGz5TAaKrJazNGVLmwrsej4ean40rKaiZcm/guT2TTkkXUAWGRpGhDQCUh3NeJSRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V5G1D7KJ; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V5G1D7KJ"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c2a818fc4so14414701cf.2
        for <virtio-fs@lists.linux.dev>; Mon, 10 Aug 2026 10:40:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786383623; cv=none;
        d=google.com; s=arc-20260327;
        b=o743PPs1WFyvYvlf2AHFIXVQDbO131J62jIRrTnc29O9nRNyaaO0CsGboZZWMoFBgw
         qw6e6fxbwuCk9dxg8MhPycV9dqxbFiTum6y2748K/beoUJJLEwmTy/LzvHzkG2S9pJvd
         m51PNsykA2xB8CBDsRdKrUN4Q+V10piOReZqd9ZuDqFGn26+rYHX0prffcogRf5BK8as
         WC6HIAAtCtObAFweOt6nuWuRyH0zeA7u4Mdgwr5udrzzHMleaAf3rT7PQxBKXQdWCKPD
         DfV3m+x0cirjy1X7Q2pYo+DslQGfPj3XKG4xJDrzdfpNJ30w/X9EqVrHFWxf/sKcslCw
         K29g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4VRVcnSjXVFXdVAazlE8sSb9dzgpF3MwZeuxJIwQG7E=;
        fh=ybYdPpG2yTVonBXIog1sr91OfcAXObhQgNW04HYbIgU=;
        b=XFawHpUdf68s8kQ9C0O1ZVzhmUJrhbLKX/zcy0ML1jPIMsgmNNiVYS7Raiu/xmzzdd
         bj2xQXM8O5MqhVfPgZjIZIwKyogpIykgT1Bgg/jZ5CEITm3GB8uXjONluRVOyLuZUgov
         D24Nl1hQBEQJieR7KQCDowF8i4Potzs8OFPlUEEnhQANnTjWnIoS47b9+/crGSpL7F4U
         oOvxVp3sKi4T8hoBzRb7wQYxvdHCGk1feaHn/+3FYeIunw9Pw5gz3f4kH18oaRaSTuDB
         rHi4EVxvNkgM4FiP72YRxuYk4NyjrYzd20Qs4ttcs3mIU2bAysH4SvpNL57YsuCUzhdw
         0qFA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786383623; x=1786988423; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4VRVcnSjXVFXdVAazlE8sSb9dzgpF3MwZeuxJIwQG7E=;
        b=V5G1D7KJQ2/3rHdwwYOeX0YLSmvQjuS7Zmiq1YsrU5cNZNca5ZwiKMMD5Quy8PM7CA
         iPNCig9eEeIKgcph5EHYerVB9v0vGUvLIrfQAU368VrRQs5PZrrRl/0AFHFunpDInMKQ
         cM7k2vhzo6fc5HyO1ZasfChzWHRHPqoYgTzLyBmpO7yyJ/Zrdsda9TohkqTSipY9uBo/
         6Kchb2KoSXdu+/M2eKvZpndiTVB9odnA4BE3E70uvzcbFI/FmTO/xLujEbrC8YFngyRH
         tvOVFvlSLYKOZyZsaIhuUVO4qsWPwntURvjJjOWXjuOctPgeiOjDqLGwM58P29HNtX37
         5EJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786383623; x=1786988423;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4VRVcnSjXVFXdVAazlE8sSb9dzgpF3MwZeuxJIwQG7E=;
        b=dmvB4V3e4kf/ThgRHzewkfnB+QwXOauY94VZq+Wjc8WUXRtxX3+kbU31KvM5lUY/Gu
         dk8+jnQZqyR6izLXZbSTtddEEUjG3Efr9NK06qSNr8tXxqFyj+8X4f2xXVfUQUJWEBG+
         BK72QrCMV0ZMuLX/S09mnDMD+sjghV3X1tKy4OspB+eldCheeoeUlQEYQMKGvEQiI+nt
         MFmWbHGP/Zq+ccIVaruC0G+BbYFgjyiz/xoZ68fw6Av7WJlbhZW6N1iFJobsijHLhlgu
         NxdUFxdn9UiTKMasJiBiigcJi8j+3XQnLRtzwXZai7C3OmUrjqXQpxUeCcfv648wMpfE
         kRHg==
X-Forwarded-Encrypted: i=1; AHgh+RpQZaGoN4j03rKmjysWZq66JJYUEkw1+fCwVGv82cUKrRfXiC/cjOfPumhvUZ7mrpL54+MnjaaMgmM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPWWaNuoNuuzzvruadNNqJNEt6iTysbsbbQ23C18ll8Zvv1TAG
	PMmWQgS3uA8D5iyIg4KakAODDJm1JNJ+GL/bZhRgn6DbV8pECZzSVtv3lsOCXoOWDxJVtEy0rxZ
	KOIfsdNa0/8YpmGMO1wjSkWyZUzRP9rc=
X-Gm-Gg: AR+sD10+5KDYiVZqLYEk/8Co9LwcWqiil0IAQ3+L1szWA4V5zcn/w9txyUs1t3uNxLW
	qcgdt4NaOclMVakmdHN8n33D1t+5xzv437R8jjnBNyN+bslgx08wo04D6dscQwqXrNBjgH3mHN/
	rY91HW1iWvLTiFKcr/L8L/p+iAAMM1PZkrOuthiQO8WPhxY60jKR7xXYX9wRh9n9N6joPhSoGvu
	BW8/cto60q6bSwf7LxZCRC3zkJ3et1gQu/tAYFvRFjmV3ztQonq12buWRWh6lpN3PcyKrAsjKUd
	jpChTvtuxwEZKhLybL6WuV5178klwI0Bo5qRIlXMPZL/g+VY4FGVEwqmwDV9RxSInLjz4L6iUrZ
	KiZU=
X-Received: by 2002:a05:622a:1f0e:b0:52d:3352:f7bc with SMTP id
 d75a77b69052e-52d4c10b1e8mr49431031cf.31.1786383622642; Mon, 10 Aug 2026
 10:40:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-12-6b97c439eb28@gmail.com> <a0580312-28d3-4cac-82d3-20b211b7038a@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <a0580312-28d3-4cac-82d3-20b211b7038a@rsg.ci.i.u-tokyo.ac.jp>
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 10 Aug 2026 10:40:11 -0700
X-Gm-Features: AUfX_mxQEGdT82tzfpSVrvBIL_n_fDSDSbqK1kIfamClOik3sgzrKM5i0N_LQ0g
Message-ID: <CA+spn3q7z8aPzLPMr1RtSzni4mM_16G=zGKytqC741iHE=dQkA@mail.gmail.com>
Subject: Re: [PATCH RFC 12/15] hw/virtio/vhost-user: send isolation regions to device
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 24, 2026 at 6:33=E2=80=AFAM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> > +static gboolean vhost_user_iova_tree_traverse_funct(gpointer key,
> > +                                                    gpointer value,
> > +                                                    gpointer data)
>
> It is a bit odd naming. Functions usually do not have "funct" or similar
> suffixes.
>

I was mostly trying to convey that this was getting registered as a callbac=
k
to be called on each node of the iova_tree.  For more clarity, I am renamin=
g it
vhost_user_iova_tree_fill_msg_reg.

> > +{
> > +    struct iova_tree_traversal_args *args =3D data;
> > +    struct vhost_memory_region msg_region;
> > +    VhostUserMemoryRegion region_buffer;
> > +    DMAMap *map =3D key;
> > +    args->fds[*args->fd_num] =3D args->u->iso_memory.iso_fd;
>
> This may overrun the buffer because *args->fd_num is not checked as done
> in vhost_user_fill_set_mem_table_msg() for the non-isolation case.

Got it!  I have added a check here.

...

> >       int fds[VHOST_MEMORY_BASELINE_NREGIONS];
>
> This needs one more element for vring.
>

Good catch.  Fixed!

> >       size_t fd_num =3D 0;
> >       bool do_postcopy =3D u->postcopy_listen && u->postcopy_fd.handler=
;
> > @@ -1268,6 +1328,24 @@ static int vhost_user_set_mem_table(struct vhost=
_dev *dev,
> >           msg.hdr.flags |=3D VHOST_USER_NEED_REPLY_MASK;
> >       }
> >
> > +    if (memory_isolation) {
> > +        ret =3D init_isolation_regions(dev, &msg, fds, &fd_num);
> > +        if (ret < 0) {
> > +            return ret;
> > +        }
> > +
> > +        ret =3D vhost_user_write(dev, &msg, fds, fd_num);
> > +        if (ret < 0) {
> > +            return ret;
> > +        }
> > +
> > +        if (reply_supported) {
> > +            return process_message_reply(dev, &msg);
> > +        }
> > +
> > +        return 0;
> > +    }
> > +
>
> This does not cover the postcopy path.
>
> It also allocates memory that is never sent for vq_index !=3D 0. The
> isolation regions need to be shared by all vqs. Please see
> vhost_user_write() for the context.
>
> Regards,
> Akihiko Odaki
>
> >       if (config_mem_slots) {
> >           ret =3D vhost_user_add_remove_regions(dev, &msg, reply_suppor=
ted, false);
> >           if (ret < 0) {
> >
>

I am less familiar with postcopy, but I think it might make sense to
break out support
for that into a separate patch. For now, I will return -1 in the
postcopy path if isolation
is active.

I'll need to think about how to handle devices like virtio-net and
make some changes to
this and the previous patch so that:
1. I am not allocating a new shared region for each vhost_dev
2. The shared region has enough space for the svq vrings of all devices.
