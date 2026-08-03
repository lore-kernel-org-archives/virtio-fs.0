Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EA3436BFE
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 19:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785785509; cv=pass; b=Q+tUcISvCLTPijdpK0TJmWWPkvdCuS2i7Y+d9f/MB/fXC1d+CMTFncgtx1vAJmiDwf2/55qVgEIzQtBV5l15ao06ZEF89xCMcWkjMiAFievBgkIE+oTxzssjYnl6wmnI3jZ5DUsW0YKT/eBZp61AcxvgQMxLyPZ/SqDNYBtUUPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785785509; c=relaxed/simple;
	bh=VtVE4LCWMgW51okMBDbPQTy1PkmzVB+pQ/taQuKWnzc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CKjegQXMzaScPssEPLfmdeesIe6R3LwTmR8wAA573ewhikCkb7PVPuFsjidFxjK6MHP63M/ZVULtgxcy5TyVpibfx3Vzuh2N2KEk/6szhH14tgkmIIKDkYVZqKPJBDl7GEAY7oldf08Eih4VF4g6oLEOt07opJTNVOmg/MkOv5U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rrFqfJil; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rrFqfJil"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5276d598b96so18130291cf.3
        for <virtio-fs@lists.linux.dev>; Mon, 03 Aug 2026 12:31:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785785507; cv=none;
        d=google.com; s=arc-20260327;
        b=HofrxgSYFWjCP4Psky3+bwQCapnfE8ZZAwPLoh7f6B2baaPVd6xqvIu9dQgypw3KXi
         IwzIvH+3JGxRkQqH+sPnz8AUsI4oEIPitn8HDSa4pBPgMQDI4rIzs/sia3Dwlu9c2dI+
         dfJieQoBdSHaSo/MRZ0dAobWbcCnCPGXE7MbXHlcA3FZ6ehRBYQqGB8nKo5BspPZiCcx
         JYHUxoHZuCtCIzweFzXCY8iaUxLpQnWGShJXXQgkLcHdSt5uHQ4ksGR8PAn6DtlMM33B
         oe/mfF9A6G899ESCzbUXGr1XCvJZP5o0hXLpqcO+gZjyJKGCj3vpIup1pIecB9qDX6nB
         B13A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=reTpUjcJUOBcUsyKejOdhRFAmR5n8lMWUzjI4+Z01tU=;
        fh=d3BogjwYiOh44bT8vVMMEIcLfXkHHHbPPTM700Rmz34=;
        b=WRQsrVzQG3La8p3RIJcpx83WMvHfXPHo8yHssaEthM9HLxrkctCOSHgvE3ZIJuS0wX
         /hYJ1yIHCtXmnyMAzRTbxwcCJ0qkOW+NQciwYAaSdjpj7rhVOrXPpKq19kw4bPQEAcLw
         sDrkl7DBpFGkkoUG6l5bf1P81WrhMPxGxoRuhpuGtTf0wG5YXdJpCGEmUmYukVAQoBfN
         VYIFYxsxnNH21gah4JTKvkq7/eHSA+ZyLuOAbu+J97P7fF5uqAcqMN6QJWAiflRNoyor
         SdhauUoZc+qFtNL3MZJ4iMEa+WL80vXghBjc4fiqKIOMdZqGs3NgcHSlHatMoH8X8BCv
         kJzA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785785507; x=1786390307; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=reTpUjcJUOBcUsyKejOdhRFAmR5n8lMWUzjI4+Z01tU=;
        b=rrFqfJilVWqMtJODAgH+efMQFljVYLrdTh1DzuS4AUA8XpWXR4+082sMBL3gTtZl3r
         NK9NFDlo+6Va0tm1CMcjEDFyM3oiGNiEVnDLyqa+Ui1aDxJStiAEQDu4DFud9bBVWZKK
         b3UVwodS1smI8Poz379nxa6tavf5P1XJE3F69TFZ4pgWiWyS+t+nBbGItMfR6rKLktmv
         xhqcq8ZDGGsd9bAlIQFAfqoFG23J82sOOfur888bhTFV2jTBVocY3Ydywe1Yq172MC4Y
         SAeITLq0kcGlhX3ClIECBX7/LxYV4Gh178NdilW+1tnQTbxhF1q50LMv8JnkJAZRYKbo
         Xx9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785785507; x=1786390307;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=reTpUjcJUOBcUsyKejOdhRFAmR5n8lMWUzjI4+Z01tU=;
        b=RIps44pB/XCfzujLDrXhLBwcUGJaEm1DHFUrkGQsVYoMB7OKHVZlSM/n4uFI93iw6g
         p3d2ZkiI85CqcyUIshEB8oz4mGn9ocukvvYsk7M2552kZVCWLMm+CswPmlSe0HInFCpm
         2i7kCg7pBZMq0WFIz7c7zfEC0oy0Au5EdDEGfEjYnPS578awftxKFglpFt+28u4THO/P
         cIn05XzgT3VCzDqCIeGyEXSAXr5fWKL+kepJzNkenwx9AQCcrDt7PuLhsJ6ZBd+KRGOd
         axcuGLKI0tkzcJJt7cI4YkIqsxY0IsDDKY+RAh2bAc/pbR3vH9I22WlSZYblDJK/RzDp
         bKLA==
X-Forwarded-Encrypted: i=1; AHgh+RqmVNOelZz9RzEhMy7Kvtzk7OSt2Z5aHZr41TR83CpT7EbGSfQYhk9XJjibQvK3/hAHNaeqeaYDmjg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxMp5PknrNq003cvzyOLSMjRT5jt4hea/BtMdsxbvmm0K9/r4O2
	7V8okA+NRbhUONDRPmqPcJJ/M1pqGtC7U3VhToJzqlODLhjU1QhANliHaanK4MspN+Y72uAVnaV
	w5WvHSn3sOfSSG6Jvg3stLjan5VY22f8=
X-Gm-Gg: AR+sD11cP2oVAurTu8nR8F9RNAny0cBo2xYvhkCLt3Kmk0uxgqC7YNDVI2zS8Pg1miS
	t5Kj4SJmtKKuKCLHx5hqTyBH+QU72U006VRxxwanMzQF/Fz6tmfu7214ytw5qHPcygIkL7efK94
	Q6DTGUPsQ37fu6kzGoUxv4yu+i/GHVTe4eFJO6R/T8zunERpRUIg389ZVqWhKze2o3o8HfuWRMo
	S7gKjNjm3F1Ej6WnYo1frrW8H3exsxHMI5bD1vcHdahWMT5IN/FEmeJ82eH2elDi4kaPQCCr/+H
	Xxowt1O+5t7Ayv3XYawZAe4prrgSA+ZJmmQTR5885CH/j5imnW9j4RPXxCoJcUBID1u8XnNIj/s
	9
X-Received: by 2002:ac8:5ad5:0:b0:51c:2554:a8f5 with SMTP id
 d75a77b69052e-52b56813005mr228935771cf.36.1785785506969; Mon, 03 Aug 2026
 12:31:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-11-6b97c439eb28@gmail.com> <b6bc052c-1bf5-449b-85d0-e1c4624a5d99@redhat.com>
In-Reply-To: <b6bc052c-1bf5-449b-85d0-e1c4624a5d99@redhat.com>
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 3 Aug 2026 12:31:35 -0700
X-Gm-Features: AUfX_mwStaeATOZ2UGNu4P-9Q3C3gPXR9qo0n3vpFD4fsPxrpxYjrIQqimituZo
Message-ID: <CA+spn3r9X4WST1c4LYS63xN0EFogkD1dJ6P4omk7ndMDeF9D5Q@mail.gmail.com>
Subject: Re: [PATCH RFC 11/15] hw/virtio/vhost-user: create isolation region
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Haixu Cui <quic_haixcui@quicinc.com>, 
	Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
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

On Mon, Aug 3, 2026 at 6:25=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
> > +typedef struct IsolationRegion {
> > +    uint64_t base_addr;
> > +    uint64_t vring_base_addr;
> > +    uint64_t size;
> > +    int iso_fd;
> > +} IsolationRegion;
> > +
> Going beyond Stefan, I would say please document each field with a
> proper doc comment, and ideally the whole struct, too.
>

Roger.  I will comment all fields, except for perhaps size, which seems
self-explanatory.

...

> In general: Please put spaces after the leading /* and before the
> trailing */.
>

Roger!  I believe I have this in a few places and will correct.

...

>
> Patch 13 adds more variables to this, so I think it may make sense to
> have a dedicated struct for these fields.
>

I agree that some of these make sense to be consolidated. However,
I think I will keep the svq array outside of the struct as the svqs don't l=
ive
inside of the isolation region.

I guess the alternative would be to have an `isolation_mode_ctx`
type of struct to hold all of the above.

>
> As Akihiko said, the memset() should come after this, and also...
>
> > +        u->iso_memory.base_addr =3D 0;
>
> ...this is just a subset of the memset().
>

Yes, the cleanup was not fully baked ahead of the RFC post.
This is currently fixed on my end and will make it into the next
rev.

...

> > +    int num;
> > +    size_t desc_size;
> > +    size_t avail_size;
> > +    size_t driver_area_size;
> > +    size_t device_area_size;
> > +    size_t total_vring_size =3D 0;
> > +    size_t total_mmap_size;
>
> Please do not mix variable declarations and normal code (style.rst calls
> it =E2=80=9CMixed declarations=E2=80=9D).
>

Got it!  This will be fixed.

> > +
> > +    /* Get space required for all vrings */
> > +    for (int j =3D 0; j < dev->nvqs; j++) {
>
> Why j here and i above and below?
>

Most likely this was inside another loop on the initial implementation, and=
 the
iteration variable name was not changed when the outer loop was removed.
I will change this for next rev.

...

> > +
> > +    uint64_t last_addr =3D int128_get64(int128_add(u->iso_memory.base_=
addr,
> > +                                                 total_mmap_size - 1))=
;
>
> I would like a comment why you went for a 128-bit operation here. I
> assume it is because it checks for overflow, turning overflow into an
> assertion failure, and it can be assumed `qemu_memfd_alloc()` must
> naturally return a pointer such that adding the length of the allocated
> area to it (minus one) will never overflow?
>
> The question is, do we even need to check for overflow then. Not that I
> mind it, in principle, I just find it non-obvious. (The more obvious
> check (imho) would be to just do a 64-bit operation and then
> assert(last_addr >=3D u->iso_memory.base_addr).)
>

At the time I was concerned about potential overflow prior to application o=
f
the -1 operand in case the last memory location was at 0xFFFFFFFFFFFFFFFF.
However, in that case, the -1 would cause the value to wrap back around bef=
ore
any use of the value, so my concern was not needed.

There is a similar 128-bit op in the existing code in
vhost-shadow-virtqueue.c at
line 133.  To my eye, that might also be a good candidate for
simplification unless
I'm missing some other aspect of the use case.

...

> > +        map =3D &g_array_index(buffer_regions, DMAMap, i);
>
> God, I *really*, *really* hate this, and find it really disgusting that
> the documentation actually recommends doing this (`&g_array_index()`)
> instead of just offering a separate macro to get a reference.
>
> And existing qemu code does it all over the place, too.
>
> So I cannot really fault you for it.
>
> Still. Too ugly for me to keep completely silent about it.
>
> </rant>
>
> Hanna
>

Would you typically avoid using g_array / g_array_index?

Best,
Connor
