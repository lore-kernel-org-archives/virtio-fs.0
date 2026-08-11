Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F813002D1
	for <virtio-fs@lists.linux.dev>; Tue, 11 Aug 2026 06:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786429738; cv=pass; b=tpZ6dGERV19NgP/ZIYWb0j7Cq5f1DPjGTvnGpbHRrwHEAYXImmFb4/OH4UgSHmNMXP3VeA2zUPr2+aya2OBld3qDT3pZxsalAQVL0dYdOqdawtQrJRnrio+XdV3ASxYJ1M2sukqIUx7hjL9F7AWgcjHbAC+Znq/0VYPOmXtlJP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786429738; c=relaxed/simple;
	bh=hacj+/fZxvJAmK6F60ANwraxhDl20/2cjrnhnnmJf2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UsN34SXXI/vKYC9h2Un19mMryWO7QY6fs+xyXwUplkxR2vSq0f731XkzoT1Cua0oWQuIb/S+SiurWfoqALp0fT4t0WRlYQfLddse/U7WQHZ6t8KiHYhNBR8kK1AJAr8idDsMql6IIXVxBg6RAYiYsEA6Dk137gmeNwIMl10vG28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZlEvaboH; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZlEvaboH"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c5382806fso29486561cf.2
        for <virtio-fs@lists.linux.dev>; Mon, 10 Aug 2026 23:28:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786429736; cv=none;
        d=google.com; s=arc-20260327;
        b=CR6TM00+iAT0uZjiE/VcUmy+pLWKcpZOxRavYdUM5v0CAXu6Fif+kC20WjB1fE4fQH
         zl3Ll+WGg1Hu4gETbp0PqQbdpGnUHDEa4/j0y7VendQDu3qo6WhYFhhZKi1AFKiwT7ca
         gFj5ajWFdSbr8GcgDBgKonJU8RuwXJoaPVRBMMS7qn7Nz5T36HqXonhQOQB4eiVGw0Ua
         rRCZW+as6hLRcUDTSlrQnLVQ2xBIbrow1s+o/9fBAx+M5Q50jcT8UMKOTlK34DQG9fss
         AFk8PtlRB5sR/0DzcxHKvzznUHtmV9ae0GNiDv2DSb1aLtoYsOAiJBGnGwn7bsJnH7Kw
         IcBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q55nAj0wvf6AevCEGFeSNE9kkBxxi2Gq440bDilNO00=;
        fh=kJWr70pPfQDSkgtgfeClCyeGxNd5qW53nUqUam0eEjQ=;
        b=H/fFqvoOrQ8WPOfoibyuP/9knx08DTh7pcwNXXG2hA9G4qv2v9T+7/Az/Bxd+vyiJe
         G08yLsX5anX5eDtJvhGicpMp8eQGtq8UXU23sVReBDlWyUoNAOly2e2BOiCdKaWoU3wS
         0rhk3IjFuDz8fRJZKP3mw/rl/69JkZJsajlfRkEbZSDUANSOeCtIhLJkYDfSzWHb2xDS
         SL+hqbLkRc6LDL3oODvz/9gEi42+MYx0RVZYq1atTsMNaHEQM5B0eWuQXqnDd9bawlSF
         0bDvC+GaMIW4tfKWXcMnoDBf7AUe8cCpy2X7pElokWG6q8Ku++5TAcLzo43jz9RS7WbN
         GdPg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786429736; x=1787034536; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q55nAj0wvf6AevCEGFeSNE9kkBxxi2Gq440bDilNO00=;
        b=ZlEvaboHYn7zdfEAE/LbxMj0cg1Jq8fAj1jnCOXaxxFV+iJAI7Q/oNNyLG81fdlpC2
         EOb+mwbLMSPs3aWyhGI0plQwxMWYqAO9ff5On1KSttPo0rytareoEEK635kKrAqOt7z7
         AQFzJ7SR9pOP+xts5riK2DBLo4AdOxP9BKtDUFRwBv7UJfGXSUlOF6xSlsUCkmdb26XJ
         oNaWQUjPaeMFZaYddYzGHzEyniPhrQmLAa95kj6tssF/2jJzSVomUm+Q9EQiQC9fqCMM
         eYd24yivuD775qvpKpL4sOl973XX5kNZ8iSWhf4ycsv3O7rNh5N09u+B7q2BaWoPGY9t
         7+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786429736; x=1787034536;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q55nAj0wvf6AevCEGFeSNE9kkBxxi2Gq440bDilNO00=;
        b=VCWVqvu6e80g7V/yQV3r9sgMt0dIhlZp1p+dL8usS3TsSuzjFNpxBM7+Q+0H5KNr1Z
         BLc+6u5YWBdnNxPbOVO8S09qkTljYF5YR1iAxlQw1PdLPKn6rIGzyuDn6ybfbXNA9tQq
         xC9CagwnMrfDi2roluoqehosgCM55ic2/e4uMrLgxzSEDqPtagcQdswZqygRXeunV4+E
         z4Ek23gRCPaNs8k4ouhs0QqIr4ILkwDf27zdt0DnGtiRwOPwyrU24UldXq/OfPvKFhex
         lBZx7ieB9Nj1cMxkRyNibskic1FTxzhMTF1iiaXpA3gES3eFQ1nORBe1oAJxBGKc/XyD
         tg2Q==
X-Forwarded-Encrypted: i=1; AHgh+RqwkOmjrKKtxjwCO46IFimoV3/gHMnpAfUgsW6OlU/8To72C7EwzVyz7uoX4ss3bQ5zp8+0au1ydtI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwbVjbJ9DWUMnhIr1Mw4UGaBclTKpj9pxXkIGqoR+qY3fEjGPyl
	DHWD2wMhZcPeEs65PT6A369l1uPSP97IMwCcJ35YXeFuLgGMqIUjt+9lYlf+c/o7uBaeiKvM4Ci
	PNNMIgFG4PwW2AIoF9w5d5SPCFgEYtps=
X-Gm-Gg: AR+sD10X2kZhMH7Q/XkKjsEdfJ2SgC5sKtRKLWdU0dhwRyDNueJpHQkq8p+FuVbPxm2
	zfRDks+TJSecooHMipp89Tv2bTzc847BxSPMeVXFz8mxYoaZVasiQu0zDxGRhObsrGMHfJAODZM
	Hw5ZI2OsNcmY62jKZv5DfpEdREeDDEFNcYhfbRRJf2hV8ajn7qNOWwOqbg+kg9yD5bV2wqRJurh
	TSWxJ5D+lBlT0Yh+GPNBzekWPhQ65xKPwPNGorNlcQcUIXCBJ5tGw+fnXbnTDUYSWpYH8K+LhGs
	YQhnLH0c8bPJ2ZHXlVOVEn3F0xCJuDJm0xp0ZI+ap2fNreSozw4Z3OrCO7y09wa5Sv7AkIgaizr
	DNeg=
X-Received: by 2002:ac8:5cc1:0:b0:51c:2068:a9f8 with SMTP id
 d75a77b69052e-52d5849587emr8908861cf.5.1786429736098; Mon, 10 Aug 2026
 23:28:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-14-6b97c439eb28@gmail.com> <20260728205728.GL371693@fedora>
In-Reply-To: <20260728205728.GL371693@fedora>
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 10 Aug 2026 23:28:45 -0700
X-Gm-Features: AUfX_mzDej6OfzJGyINW_W_w6Z7pGsHtQUxPBWQtT9pRtZeJZNjLDViu7ukeDnU
Message-ID: <CA+spn3qnRrEYLzMS+MRPg0c1UYisp68fFXp-GQzs_chKSr6XeA@mail.gmail.com>
Subject: Re: [PATCH RFC 14/15] hw/virtio/vhost-user: handle data movement with
 shadow vqs
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Milan Zamazal <mzamazal@redhat.com>, Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 1:57=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.co=
m> wrote:
>
> > +
> > +    for (int i =3D 0; i < elem->out_num; i++) {
> > +        needle.translated_addr =3D elem->out_addr[i];
> > +        needle.size =3D elem->out_sg[i].iov_len - 1;
> > +        map =3D vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
>
> Mapping failure must be handled.
>

Got it!  This will be fixed.

> > +        offset =3D needle.translated_addr - map->translated_addr;
> > +        iova_base =3D (void *)(map->iova + offset);
> > +
> > +        elem->out_sg[i].iov_base =3D iova_base;
> > +        memcpy(iova_base, elem->out_sg[i].iov_base, needle.size + 1);
>
> iova_base is an iova, not QEMU memory (HVA). Memcpy cannot be used with
> IOVAs. The address of the mapped shared memory is needed as the
> destination instead.
>

This is a relic of how the IOVA space was originally really just the
hva of the shared
memory.   However, as you noted, that wasn't great for security.  Now that =
those
address spaces are separate, the call is adjusted.

> > +    }
> > +
> > +    for (int i =3D 0; i < elem->in_num; i++) {
> > +        needle.translated_addr =3D elem->in_addr[i];
> > +        needle.size =3D elem->in_sg[i].iov_len - 1;
> > +        map =3D vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
>
> Mapping failure must be handled.
>

Fixed as above!

> > +        offset =3D needle.translated_addr - map->translated_addr;
> > +        iova_base =3D (void *)(map->iova + offset);
> > +
> > +        elem->in_sg[i].iov_base =3D iova_base;
> > +        memcpy(iova_base, elem->in_sg[i].iov_base, needle.size + 1);
>
> No memcpy is necessary before vhost_svq_add() since this is data that
> will be read from the device upon I/O completion.
>

Copy! It is removed.

> > +    }
>
> elem->out_sg[] and elem->in_sg[] are modified in this function. Have we
> lost the original I/O buffer memory address from the guest virtqueue?
> This is a problem because they will be needed when completing the
> request.
>

I don't believe they were lost.  I had complimentary operations on elem
in the two handlers.  However, my thought that these needed to be adjusted
was incorrect, so address fields in elem are no longer modified in either
handler.

...

> >
> > +    if (u->user->memory_isolation) {
> > +        if (!u->svqs_allocated) {
> > +            return 0;
> > +        }
>
> Is the idea that this returns silently when called before
> vhost_user_dev_start()? State make code harder to understand. It would
> be cleaner to set up the vring addresses without relying on
> svqs_allocated. What is the reason for deferring the vring address
> setup to vhost_user_dev_start()?
>

The current implementation follows a similar order of operations as
vhost-vdpa, in which vhost_svq_start is called by vhost_dev_start.
vhost_svq_start is where vrings get assigned their locations, so there
is no valid address to send before then.

As we discussed offline, this could potentially be fixed by calling
vhost_svq_start when the mem table is being set, though this
complexity among others is a good reason to move implementation
of the isolation mode up to vhost.

...

> >
> > +static bool vhost_user_svqs_start(struct vhost_dev *dev)
> > +{
> > +    struct vhost_user *u =3D dev->opaque;
> > +    uint64_t vring_base =3D u->iso_memory.vring_base_addr;
> > +    u->svqs_allocated =3D true;
>
> Where is this field cleared to false on reset?
>

Nowhere originally, but I have added it in vhost_user_svqs_stop.

> > +
> > +    for (int i =3D 0; i < u->shadow_vqs->len; i++) {
> > +        VirtQueue *vq =3D virtio_get_queue(dev->vdev, dev->vq_index + =
i);
> > +        VhostShadowVirtqueue *svq =3D g_ptr_array_index(u->shadow_vqs,=
 i);
> > +        svq->base_addr =3D (hwaddr *) vring_base;
>
> Does this support multiple virtqueues, it looks like they will all use
> the same base_addr?
>

It does!  vring_base is incremented after the assignment is made
for each svq.  Having said that, I don't think this works with virtio-net
where the device is implemented as multiple vhost-devs.  Since
multiple vhost-devs would need to share the iso memory, I will need
to adjust the vring assignment accordingly.

> > +        vhost_svq_start(svq, dev->vdev, vq, u->iso_iova_tree);
> > +
> > +        struct vhost_vring_addr addr =3D {
> > +            .index =3D dev->vq_index + i,
> > +            .desc_user_addr =3D vring_base,
> > +            .avail_user_addr =3D vring_base + sizeof(vring_desc_t) *
> > +                svq->vring.num,
> > +            .used_user_addr =3D vring_base + vhost_svq_driver_area_siz=
e(svq)
> > +        };
> > +
> > +        vhost_user_set_vring_addr(dev, &addr);
>
> Also mentioned above in vhost_user_set_vring_addr():
>
> Sending a vhost-user message here is strange since that should already
> be done by vhost.c:vhost_virtqueue_start() ->
> vhost_user_set_vring_addr().
>

Same response as above.
