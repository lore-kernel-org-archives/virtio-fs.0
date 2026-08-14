Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E462E3FE
	for <virtio-fs@lists.linux.dev>; Fri, 14 Aug 2026 00:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786665789; cv=pass; b=pgmgnotZSi7Tg1rQTiR4irYzs95QRhymQdwq/cm0UixNtIbuuhz5HS7dmJnMiKXnumcwYtlUkoL+57p+q26bAzjNWhLQWWcvDwi3a6/LUqhdZKF3iFNgGtu+tZjmWUehPs1FXwA2f+uY1l3/Vx9AEV13vTx4uwhLw/FIN3nb28I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786665789; c=relaxed/simple;
	bh=hVSmJ7ixw5jelhvD/tTPYisI93matCzolYUmEWW8XMo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sGzHN1sBVkpQUiLGLR5/H4cAgKbFya3rAqmh7psU4QyU1ufrG9m0+JF6lQn1C57SE2sLK6cCIqbWHYQAenpGuuhGvfT4ZeDU8zCTea6X7Bed+mDDW/95UNvt30b11C06jL7C1Sv86uXKx5euW2oCrJq8vEmORK0yHenxydqmlWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LroOByzA; arc=pass smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LroOByzA"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e85499ffbso38089085a.0
        for <virtio-fs@lists.linux.dev>; Thu, 13 Aug 2026 17:03:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786665786; cv=none;
        d=google.com; s=arc-20260327;
        b=czcRGY9K5uD41HneVoEG2GjH41PnE7nQkdRmBHS3JkGYA/ln0e+zX1RWxIAutXxdi8
         f8btN0FRNR1z/qIemU6sk+DzSLR019J9CuzS7BBXd3G8JkPZ72PMvthIZKJkP3S4N0yF
         xd7ZpVNmtom7b1PsESqzjlia7A9DIu/jKK4VmHk9DV1t895MDoXxcxQ7b+PUAd4lWbXq
         iZyQtKuZK4+miqAay12uSMHcBPQ1bIi5VhV8kKoE7HO5erAP4xyTszsYDyH9nwJIvX85
         X2Lnn9pHIB8niTK5DoZOs2WUDfAZ+PiFD2t1KKfqvVQGGFcz/1JbBrrCVXTacRiNh0pV
         W+dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=u7OtRASg8DB2m86V8Edb6D9/poU/y5LEwaT9mbL/IAQ=;
        fh=mZX63Bco6ZH/ScYNojUQ/1cSvY2ED0zONS3wvnjR7R8=;
        b=d/YreflMC9SfxsDn71MurJmtNQfCbAT4XzoqeHvGtusdxC+mxUkkGTu9U152mxXjEK
         fNJBTfdAJIII9fZ96+yYIqB9DRNnJk04A1Nj2GQSJlnBKhwm4iibC3a2SyNhra87M7Ma
         G+h2bR+jXQhX/mPyEuQ1+0nlKD+5EQ6rrmPrzRqlwclQfCeim7lzNwpNdY+YAdLJnrxt
         zTELW2Cihry6VCsZ1GlQ5Ho6h5rN13VGuI0vW6FSoskzywTtAXicLZR9FAffVNQ28Jln
         YHkHUPizJoAx70mB1DDufLYCek+ja8vhN7HgGb6jxZ3PDuhqxiNDqZB6O/PXUfIi0+Bq
         dr1g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786665786; x=1787270586; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u7OtRASg8DB2m86V8Edb6D9/poU/y5LEwaT9mbL/IAQ=;
        b=LroOByzA+HocOhYVuhx/71KLASFwy5MOJvaoDUUvbXbtcrbtPkc2hdSEnhnmuR8C+7
         3ERPacGAYe4u6LBHmRApwqg4qjWrKw97cVM4XAAcB63GzvUjGT4xt0bQgMvjuDmN0xq5
         qaPtYup/adD6o8K2xfFCL5edFIohalvKtHH6/EMGIWFOt0yJRJZuhA9NjD1bhEsuuPX0
         ORrQpJVu6kJDjZow+8UYHW3zRsi2F5JmErTZ1/ShOnyHv/6zHvzYYGguyr5LOLn25gPG
         kNae00QNMGSJvqNJ+bQYQmMVzrDhl8lF6M/7nv7fy4xxFFoJsDODxJIuXlRf86BC/hF3
         sWSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786665786; x=1787270586;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u7OtRASg8DB2m86V8Edb6D9/poU/y5LEwaT9mbL/IAQ=;
        b=n8gRi7jvqZHaYrwdKRaaAJakdnN2HE7/WVyCnrx7XMGVWWWMGV454NEG7urdD0mlJG
         dsZXQnNdvfD61HNmhAeS0cG+8xRhWlI48pMTHeMTj83l+HZhdUz1m7sjt4o1BykpOst4
         hiL7Ds1yYygkrsSQ2YmoNkOw6qQkGdInug8PW9NN/2I25374AP5IBI1i7DttQqUrRNtr
         i4wPywTTeq+8wX9EYJTuozU7v/Ze2PqEDTA045mzs+QwDIYffWTf6RhOYjwnqB6IrY4U
         pVt03vd6q0TtrzDxv0Zud3V29wN3+/eXIbushWLVSehT9mKs3t5WUWQMNqzOWYdhBJiN
         wvvg==
X-Forwarded-Encrypted: i=1; AHgh+RrAChAoNQZmBB1P5IpkKpDduSZXpCmaGVBdZc/gFQ+ki+TEPz75Vuthk+r5RQml86M5RF8mde2LRio=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFALeVWY5CC634OWYCw+fcSszKINBzegTD0VN7xiZt6sJGBHbM
	8OtpfSTBdaynp36JGVp3R6LgV1z5xRc8pfJYl9QRkRRnSSFRTXgVZrf3vngBs5la4EoLWWukuWU
	8bqmRS88QdyWBkGasVHIW0Ct32zb9ZpQ=
X-Gm-Gg: AR+sD11DOcnSiuLF5LDuSgPfPkn1/dAiz4ekXPqhc9RKCK3uu1Kyd3TF4R6fYpiE9UX
	BRIbXNe6MZzPWOkJGBKLhLBdYlOsaWA/9Yimgb7tg0Cg4O8iIp5TkK7p7A5VPorTKFhlj8yXtHw
	0OQgHXGoxPx05uKu6+DecsTImpmFOf2qERIoxOF3KsSZh7eJMU8bhkUunJjqB6MrDQybyuQXzni
	RjW3lHHJBETboxkJziJgMk9STLtMMi8U3+0e9pGW2Hh0LC/6C29rT2duJ1fbuUoMKdqXWK4eW8I
	ofiAjBAi1fxaB4lmAYdCjmbchA5EokP/tVpSETFXRc1IezwWWMZh0Ef6H4eZGjDib5Q2QR5eBHi
	gag==
X-Received: by 2002:a05:622a:4d4c:b0:51b:fd82:22dd with SMTP id
 d75a77b69052e-52d853621dcmr25554081cf.15.1786665786564; Thu, 13 Aug 2026
 17:03:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-14-6b97c439eb28@gmail.com> <31183362-f4b6-4afd-8c6d-2e1b5db35225@redhat.com>
In-Reply-To: <31183362-f4b6-4afd-8c6d-2e1b5db35225@redhat.com>
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 13 Aug 2026 17:02:55 -0700
X-Gm-Features: AUfX_mz22qa9zpcH9_K3CSX5pHnkrpyDOp-6UI8yg-Y10S5wzIgI8sUoiiq6vKQ
Message-ID: <CA+spn3rAetqaW7YEL2cyAW8PY6wUJZaBEN6ce8LP0SU4W70xvQ@mail.gmail.com>
Subject: Re: [PATCH RFC 14/15] hw/virtio/vhost-user: handle data movement with
 shadow vqs
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

On Mon, Aug 3, 2026 at 7:10=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
> On 24.07.26 00:30, Connor Kite wrote:
> > - Add start logic for shadow virtqueues, which sets vring addresses.
> > - Update logic for sending vring addresses to backend to point
> >    to the shadow vrings when isolation mode is active.
> > - Implement handlers for intercepted avail and used descriptors. These
> >    handlers copy buffer contents between bounce buffers in the isolatio=
n
> >    region and the buffers made available by the guest
> > - Implement logic to stop svqs
> >
> > Signed-off-by: Connor Kite <connorkite@gmail.com>
> > ---
> >   hw/virtio/vhost-user.c | 167 ++++++++++++++++++++++++++++++++++++++++=
++++++++-
> >   1 file changed, 166 insertions(+), 1 deletion(-)
>
> In general, I find it strange to use two completely separate data
> structures for the address translation in either direction (avail/used).
> I suppose we could have a map of in-flight translations, adding entries
> in avail, and looking for them in used, removing them from the map.
>
> I mean, sure, right now, we can calculate the addresses, because we
> =E2=80=9Cduplicate=E2=80=9D the whole range of guest memory for each devi=
ce, but that is
> clearly a waste and it would be better to use a smaller size in the
> future; and then each request will need to allocate from that smaller
> device memory, get a random address, and that will need such a map for
> tracking.
>

Definitely agreed that the mapping could be done smarter to avoid
allocating such
a large region.  I think this would a reasonable optimization for when
the project is
more mature.

For your first sentence, are you talking about the svq and vhost_iova_tree =
data
structures?
...

> > +static int vhost_user_svq_handle_used(VhostShadowVirtqueue *svq,
> > +                                      VirtQueueElement *elem,
> > +                                      void *opaque)
> > +{
> > +    hwaddr hva;
> > +    int r;
> > +    struct vhost_dev *dev =3D opaque;
> > +
> > +    for (int i =3D 0; i < elem->in_num; i++) {
> > +        r =3D vhost_user_memory_lookup(dev, elem->in_addr[i], &hva);
>
> This function only looks for the starting address, so it is not
> guaranteed that the whole buffer is within one memory region.
>

For the next rev, both handlers will be looking at whether the last address
in the buffer fits in a single memory memory region and will copy from/to
multiple memory regions if necessary.  See below

> > +        if (r < 0) {
> > +            return r;
> > +        }
> > +
> > +        memcpy((void *) hva, elem->in_sg[i].iov_base, elem->in_sg[i].i=
ov_len);
> > +        elem->in_sg[i].iov_base =3D (void *) hva;
> > +    }
> > +
> > +    for (int i =3D 0; i < elem->out_num; i++) {
> > +        r =3D vhost_user_memory_lookup(dev, elem->out_addr[i], &hva);
> > +        if (r < 0) {
> > +            return r;
> > +        }
> > +
> > +        memcpy((void *) hva, elem->out_sg[i].iov_base, elem->out_sg[i]=
.iov_len);
>
> I don=E2=80=99t think we need this `memcpy()` here, as the device may onl=
y write
> to IN buffers, not OUT buffers.
>

You are right! This is removed now.

> > +        elem->out_sg[i].iov_base =3D (void *) hva;
> > +    }
> > +
> > +    return 0;
> > +}
> > +
> > +static int vhost_user_svq_handle_avail(VhostShadowVirtqueue *svq,
> > +                                       VirtQueueElement *elem,
> > +                                       void *opaque)
> > +{
> > +    hwaddr offset;
> > +    const DMAMap *map;
> > +    DMAMap needle;
> > +    hwaddr *iova_base;
> > +
> > +    for (int i =3D 0; i < elem->out_num; i++) {
> > +        needle.translated_addr =3D elem->out_addr[i];
> > +        needle.size =3D elem->out_sg[i].iov_len - 1;
> > +        map =3D vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
>
> Is it guaranteed that the returned `map` will fully contain `needle`?
>

It is not guaranteed.  If the needle range covers multiple regions, the ret=
urned
map would only represent the lowest matching addresses. Care also needs to =
be
taken in copying back to buffers made available by the guest. While the IOV=
A and
iso region hva spaces are all allocated with no gaps, there is no
guarantee the guest
buffers reside in a single region.

The next version I have implemented copies to multiple regions if
necessary, and also uses bounds checking to confirm that:

    1. bounce buffers are fully encompassed by the isolation region
    2. hva addresses in the element actually back the gpa addresses in same

> > +        offset =3D needle.translated_addr - map->translated_addr;
> > +        iova_base =3D (void *)(map->iova + offset);
> > +
> > +        elem->out_sg[i].iov_base =3D iova_base;
> > +        memcpy(iova_base, elem->out_sg[i].iov_base, needle.size + 1);
> > +    }
> > +
> > +    for (int i =3D 0; i < elem->in_num; i++) {
> > +        needle.translated_addr =3D elem->in_addr[i];
> > +        needle.size =3D elem->in_sg[i].iov_len - 1;
> > +        map =3D vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
> > +        offset =3D needle.translated_addr - map->translated_addr;
> > +        iova_base =3D (void *)(map->iova + offset);
> > +
> > +        elem->in_sg[i].iov_base =3D iova_base;
> > +        memcpy(iova_base, elem->in_sg[i].iov_base, needle.size + 1);
>
> I don=E2=80=99t think we need this `memcpy()` here as the device is to st=
rictly
> write to IN buffers, not read from them.
>

You are correct.  This is removed now.

> > +    }
> > +
> > +    vhost_svq_add(svq, elem->out_sg, elem->out_num, elem->out_addr,
> > +                  elem->in_sg, elem->in_num, elem->in_addr, elem);
>
> Might make sense to make vhost_svq_add_element() public and use it here.
>

Done!  Definitely easier to read.  I guess this adds the overhead of anothe=
r
function call, but that's probably small relative to overhead due to the ex=
tra
interrupts and copying.  We could probably make use of "inline" if trying
to really optimize.

...

> > @@ -1779,6 +1872,25 @@ static int vhost_user_set_vring_addr(struct vhos=
t_dev *dev,
> >           .hdr.size =3D sizeof(msg.payload.addr),
> >       };
> >
> > +    if (u->user->memory_isolation) {
> > +        if (!u->svqs_allocated) {
> > +            return 0;
> > +        }
> > +
> > +        int svq_idx =3D addr->index - dev->vq_index;
> > +        VhostShadowVirtqueue *svq =3D g_ptr_array_index(u->shadow_vqs,
> > +                                                      svq_idx);
>
> Again, bounds checking via `vhost_user_get_vq_index()` would be good.
>

This will be added for next rev.

...

> >
> > +static bool vhost_user_svqs_start(struct vhost_dev *dev)
> > +{
> > +    struct vhost_user *u =3D dev->opaque;
> > +    uint64_t vring_base =3D u->iso_memory.vring_base_addr;
> > +    u->svqs_allocated =3D true;
>
> I don=E2=80=99t like setting this before it actually being the case very =
much. I
> understand that it is necessary for how you decided to set up
> `vhost_user_set_vring_addr()`, but there should at least be a comment
> (because reading this code, there is the obvious question: Why is this
> set when it is not true?); or the code should be different. I.e. having
> a `vhost_user_set_shadow_vring_addr()` function, maybe, which would not
> even take an `addr` argument and could be used both below and in
> `vhost_user_set_vring_addr()`.
>

svqs_allocated should be going away as svq vring addresses will get
mapped earlier
to intercept when vhost allocates vrings.

> > +
> > +    for (int i =3D 0; i < u->shadow_vqs->len; i++) {
> > +        VirtQueue *vq =3D virtio_get_queue(dev->vdev, dev->vq_index + =
i);
> > +        VhostShadowVirtqueue *svq =3D g_ptr_array_index(u->shadow_vqs,=
 i);
> > +        svq->base_addr =3D (hwaddr *) vring_base;
>
> I really do not like the lack of bounds checking here again. There
> should be something, somewhere (i.e. in the =E2=80=9CIsolated memory data=
=E2=80=9D
> portion, maybe in `struct IsolationRegion`), that tells how much memory
> has been allocated for the shadow virtqueues, and we need to check that
> we do not overflow.
>

Got it!  From now on, the total size of the vring allocation is
stored, and bounds
checking occurs as each svq's vrings are allocated.

> > +        vhost_svq_start(svq, dev->vdev, vq, u->iso_iova_tree);
> > +
> > +        struct vhost_vring_addr addr =3D {
> > +            .index =3D dev->vq_index + i,
> > +            .desc_user_addr =3D vring_base,
> > +            .avail_user_addr =3D vring_base + sizeof(vring_desc_t) *
> > +                svq->vring.num,
> > +            .used_user_addr =3D vring_base + vhost_svq_driver_area_siz=
e(svq)
>
> All values set here are effectively ignored, right? Because
> `vhost_user_set_vring_addr()` just overwrites them. (Having a
> `vhost_user_set_shadow_vring_addr()` could maybe save us from having to
> set this up.)
>
> Not that it=E2=80=99s currently wrong to set them this way, just asking.
>
> Hanna
>

You are right about overwriting the values.  I will remove those statements=
 from
vhost_user_svqs_start.
