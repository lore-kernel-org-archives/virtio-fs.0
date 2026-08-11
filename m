Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490EB3C1D57
	for <virtio-fs@lists.linux.dev>; Tue, 11 Aug 2026 06:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786429732; cv=pass; b=bgCJY49XuSYrLhhLjkSh4aI9O8PJaD2byCQfTm6kwcOMN6KCDv3hrO9CdIydFjSzMyiVqUispWOw/i2t6abviXOXJHsbMNv+7mvsqwRTeR1PzdgTt2UKa+DlPyB2db0v+x+SCSML93N9OEsavBemkpbuvISl0noKbVddVeUgJtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786429732; c=relaxed/simple;
	bh=UkV0HbJ6jZdCfg/HxDWdz234vVFXU4X4eH3eWzp9yM8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gYVYQv22IuXRpX/ykMhziuQaS/1P4oEcrfoJlvWuLFVZUQw+6MWrMLlNWEv0xs4gqT+aEMhAcfYAfFtaQxjFG8CMT8AlqSBHhBHHXbeeYktp6gJ0YSqPGReZEq1YD33b2glbIzisMyFzS8HYvdlq7vxwSGBrQgaRV2vCHlhIh/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gsBMARb9; arc=pass smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gsBMARb9"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-930f4e5eed1so19598285a.2
        for <virtio-fs@lists.linux.dev>; Mon, 10 Aug 2026 23:28:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786429730; cv=none;
        d=google.com; s=arc-20260327;
        b=VhSBhF2naptWyiHlvGlQpo51gwslaGppmdr5+Z62/F4wWO3Zy1SKMthAlqOZrQULRf
         SAMbaZNDcmjWDPLBy42znkymdm9ETgw0Onw3LzorgRAjIPi2mjOsq1oJ7iB3CGdDgPG3
         iTaM38CStzOQPeiBKgIw2wJ51qMrHCi9ciNfXc4mAtTdtwl38FSob/Lkvkcd2KaeNU5k
         sDddXUTR6lEeMTQsKzN43rdjZTBUaxUxgrbGPTLMZCQRQDBe3wc1oVMHsg7TO8LZsIUX
         1KFLEwvJ+ohUn2iNWEvDRx4hcEbGIjsBSigIvav4MIRwxFjcFsllX6ot7BnR5urKfoPt
         L6Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qk+rCaZz7kJBNbLgETOFxIZK9svgbPsa00ch9b+croA=;
        fh=lZgEF08Magxbmh8K67mOBO4BMKqqJBwQjZlFrScHm5I=;
        b=fKhjWFgTDfjHdZmRsm+vmyg9n2lzkCmdWXCbt/e80xjYaJ/VJUrp8hAOSEMxzV0REj
         Z3j4861JRnEcJqiV1rey92NJdtzikQg8t03nAbKTiwu18Nayzeb8Nobqdu5UM1jDlcom
         RcWK8ZvKWxhe8BYUu61bZeQemkOpUwVPEqoM/uf2tsqZMIsfERHI6HaVA0y5uIxi0Kks
         a0KelP/QfjrsjUU70M3uRQWilR+aWqe1E36al5RBnZKLEI+X4v/WXxXBnuWOL6BZDlzJ
         cCV7c3L3hBCso1mY97oQZqbSnKeGN+OBCxA5NKJCkkaKc45S7zBeDnHLC/Dx1z1PODi6
         BVYw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786429730; x=1787034530; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qk+rCaZz7kJBNbLgETOFxIZK9svgbPsa00ch9b+croA=;
        b=gsBMARb96dYgtB0x2Z+tSBHTxjFvv3UUMVtRZsZe9UdhRa/m8tCDnkZGoj/fmv2moR
         LFOgA5fzgDAR90lLw9FOgWTeuL+/HT1I83G5sTAu9sExcfAHk7aQWk5FL73Pe/y+CVsb
         H30+eD+Gj9NBD+vkiYvMpaTcMc0MaqwTxKgnJSVLo+HRS+HacL2Y3QV6efojMNU82LSr
         ohQZbWiv/kjCYUYsaf+G5XNlgsOzLHmFdgms+6z/HY5q5islNWvWjP1PXLXdd8fMTUPW
         Gs+HJ63uaInUQgY1XydKGOm0TwLdSuggnmI0sgXHQyGfsncxnc7J6VsufIpz4LOaz6zR
         C9kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786429730; x=1787034530;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qk+rCaZz7kJBNbLgETOFxIZK9svgbPsa00ch9b+croA=;
        b=rhHVasiTF59DxVazLTpA7Fll4Okc3fYwpZ9eXUuAqdaJkYL7RbSP2YQiDWu9HOQLs3
         OXGbPKkW0PcC3L+LT+FiWTQrBD8veppBb3qBHGIhZn5WF5Fw8ZqktVpuH/D7jkMa3xu3
         7Fj4um6U8URMAiuMaZM440lauc+LALjFUwkgmESgocs/n6IPP/LBPBA98dwZHuIkrpjK
         eBGNc1ARzPpU/B4krDCfK89kbYQ5RXT2TyQLSRPLXX9stw6PT5Z26Z1aej7q8zEDjmvb
         sg0BQb5QVWMEJXtRs3r+h4J4MzdNZ8MaGTq7Vde5je62n9AHe7dhnkmUMY9zKuWuZL+u
         IEMA==
X-Forwarded-Encrypted: i=1; AHgh+Rq4ygKF9TwGOGcv6ALQK1yHutkfI1UbMqRbCfBkm3z1YBQwUAKFy09PyAb0AAAxyYlyKYyQvUBF+Nk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyqDXUmvg8NldXHtIdy7yDZQLpUaecoDpTa22+H2FQPF8OuZbzX
	XCkwiclNmBu1IWhKakciLPouYXrWs+TUaS0Htxh31NNmpJzI9vwXgafJCVQF/nAElOZPjjSdIrq
	8kY5GYenC7d/o8VFo6Ii1LsZgx3f3Xb8=
X-Gm-Gg: AR+sD10BytH1Ggq+xndd8cwgV17XNTraVnOE4MT2wDCBGpQ5WIegqgBpX/eOXeWqmTL
	rv4l9wGdmRvwOUjAFyM+rmcXewywjYFy0nP2VH3OgfJrnbO6o2ZWU2RFWpIX5e3R0NaiKz5GYN9
	Vgl0OFnafbbjrCNY/xVFnlUYMGTVxQtZC5S5tECc0jQ3HatEKiDoML8HKYDJCd9vX0DuxNbt2b1
	Wu1A69fNr4KcqAsBCK5E6t8EJkbXOglngdDux1cjBPCVwE9XiNji0DKM43FBN7OU9Q61wxL4c+b
	wBvAzMqlSuMeOygzteSGly7/smAgf4rbv4Myotgrd1vX2BYkq9Er3idT5srsjuFM/ZS3Pk6+Qao
	/0kk=
X-Received: by 2002:a05:620a:d85:b0:92e:8a84:7041 with SMTP id
 af79cd13be357-936a8e6cae7mr73114885a.8.1786429729981; Mon, 10 Aug 2026
 23:28:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-14-6b97c439eb28@gmail.com> <f3ff63d6-6e88-4c82-9455-ca250aa42170@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <f3ff63d6-6e88-4c82-9455-ca250aa42170@rsg.ci.i.u-tokyo.ac.jp>
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 10 Aug 2026 23:28:37 -0700
X-Gm-Features: AUfX_mzPDsezATrFYKlhOp6dhdhhkEzRtL-sBWPEdLTmR2c4JyFU57etfo2dkd4
Message-ID: <CA+spn3qLUh2CWoKMDV=jQrughZmZ9DgBE+gidbn1xmTxCqpNsQ@mail.gmail.com>
Subject: Re: [PATCH RFC 14/15] hw/virtio/vhost-user: handle data movement with
 shadow vqs
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

On Fri, Jul 24, 2026 at 8:20=E2=80=AFAM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
>
> This copies data in the reversed direction.
>

Good catch!  This will be fixed going forward.

...


> > +    DMAMap needle;
> > +    hwaddr *iova_base;
>
> Please make it void *.
>

Got it!

> > +
> > +    for (int i =3D 0; i < elem->out_num; i++) {
> > +        needle.translated_addr =3D elem->out_addr[i];
> > +        needle.size =3D elem->out_sg[i].iov_len - 1;
> > +        map =3D vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
>
> An error check is missing here. This translation does not seem to
> support IOMMU.
>

I have added in the error check.

Looking at vhost-vdpa, there is an
error when IOMMU is enabled at the same time as shadow virtqueues.
I'll need to dig into what, if any, work is needed to make svqs compatible
with IOMMU enabled.  For now, I can implement a similar check in
vhost_user_dev_start to that in vhost-vdpa.

> > +        offset =3D needle.translated_addr - map->translated_addr;
> > +        iova_base =3D (void *)(map->iova + offset);
> > +
> > +        elem->out_sg[i].iov_base =3D iova_base;
>
> elem->out_sg shouldn't be overwritten since virtqueue_unpop() will use
> it to unmap the element.
>
> > +        memcpy(iova_base, elem->out_sg[i].iov_base, needle.size + 1);
>
> This memcpy() is no-op. elem->out_sg[i].iov_base is already set to
> iova_base, so it's copying from iova_base to iova_base.
>

Roger!  There were a number of unnecessary adjustments to elem in
both handlers which should now be fixed.  As the IOVA and hva of the
isolation region are no longer the same (see Patch 11), there are some
additional changes required here, but the memcpy issues should also
be fixed for the next rev.

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
> > +    }
> > +
> > +    vhost_svq_add(svq, elem->out_sg, elem->out_num, elem->out_addr,
> > +                  elem->in_sg, elem->in_num, elem->in_addr, elem);
>
> An error is ignored here too.
>

This is added now.

> > +
> > +    return 0;
> > +}
> > +
> > +

...

> > +    for (int i =3D 0; i < u->shadow_vqs->len; i++) {
> > +        VirtQueue *vq =3D virtio_get_queue(dev->vdev, dev->vq_index + =
i);
> > +        VhostShadowVirtqueue *svq =3D g_ptr_array_index(u->shadow_vqs,=
 i);
> > +        svq->base_addr =3D (hwaddr *) vring_base;
> > +        vhost_svq_start(svq, dev->vdev, vq, u->iso_iova_tree);
>
> Calling vhost_svq_start() here overwrites the shadow vring index
> configured in vhost_virtqueue_start().
>

I might not understand what you are referring to here. If I understand
correctly,
vhost_virtqueue_start() does not touch any shadow vring indexes, so I
don't think
vhost_svq_start() could overwrite something configured there.

However, I see that the assignment to addr.index followed by
vhost_user_set_vring_addr
might create a disconnect between the vq index and that sent to the
backend.  It's possible
my ordering is just right as is, but I will confirm by assigning
virtio_get_queue_index(vq) to
addr.index

> > +
> > +        struct vhost_vring_addr addr =3D {
> > +            .index =3D dev->vq_index + i,
> > +            .desc_user_addr =3D vring_base,
> > +            .avail_user_addr =3D vring_base + sizeof(vring_desc_t) *
> > +                svq->vring.num,
>
> This assumes the ring is split, but VIRTIO_F_RING_PACKED is not rejected.
>

Currently, shadow virtqueue does not support packed vrings, so I can't here=
.  It
is a good idea to add a check and reject VIRTIO_F_RING_PACKED.

> > +            .used_user_addr =3D vring_base + vhost_svq_driver_area_siz=
e(svq)
> > +        };
> > +
> > +        vhost_user_set_vring_addr(dev, &addr);
>
>
> The initial ring startup is ordered incorrectly. Generic startup
> suppresses SET_VRING_ADDR, installs SET_VRING_KICK, and injects a kick;
> only the later backend-start hook creates the shadow ring and sends its
> address. SET_VRING_KICK starts the ring, so the backend can process
> before receiving valid addresses. The late SET_VRING_ADDR result is also
> ignored.

I think to avoid this issue, I need to assign svq vring locations when the =
mem
table is getting set, rather than on device start, as the svq
implementation seems to
expect.

It is likely that the isolation mode implementation will end up moving
up to vhost rather than
vhost-user.  If that's the case, some of the complexity around
tracking order of operations should
be simplified.

Best,
Connor
