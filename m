Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021A120DF7
	for <virtio-fs@lists.linux.dev>; Wed, 22 May 2024 16:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716394065; cv=none; b=Z1HwdgzbopOInieJ3gFpad2C4kVICYifh6tyHS6Ok6FXHR0soNwZdZILJUz19qYuSs6T4FvW5SnfF+AW7lYGaBHcrPaXqpDKcW/aJk4eNFp7RNpHvTjs8l2NDiuVA4H1/bw7lp4/RsDLAzMPGGZs2LsgP+i6Cf0z2cL28dGXLN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716394065; c=relaxed/simple;
	bh=OnCAmkW5lhWWm44QjwL3986wGNHV4wUdBJozTJnECiI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TibE0wOeBJn6XXwmu5VIiZrVAih5e6iwFoZ9o/ClAt2jlSCyo3w3mLW0g5FwfXonTGBlf2qVAj22PZKOLSxovD/qIEuMrAy9Cq716ccqMN4WT8yl7CQPK2x8F9zLJxw40ORc7nk/v/CzKipJGBiRDrBgPqBfRUVKA8AmQskPEM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LGe2SqQP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LGe2SqQP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716394062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zFilv3pbs+35EgsHoQGw65hmxQaAATuFuNpim+MUR0g=;
	b=LGe2SqQPdeomLpLX4g6p60U4ikHVmw7KiZGCP/8F6LUfD200tYm9dNI/aXQ2FPrt+KEUF6
	9TnUD78hCTqrRu/rLq/2VJNbvs/+e7nkrdhau6CJC9nlT4pG5+Ye22xblWDz06tQIofaOh
	8KSGGsjm45Je02bzsAlTy8pZRAhTzWQ=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-9qTUFrO3OhmOXxek_n0MNw-1; Wed, 22 May 2024 12:07:41 -0400
X-MC-Unique: 9qTUFrO3OhmOXxek_n0MNw-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-df4d82f868bso2799434276.3
        for <virtio-fs@lists.linux.dev>; Wed, 22 May 2024 09:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716394061; x=1716998861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zFilv3pbs+35EgsHoQGw65hmxQaAATuFuNpim+MUR0g=;
        b=fijUQO9S/FTl+81kw2Mi7tTogm3BztumqEYmDMRDji9sRQ/T038zc3cSn+m0kOqTHL
         GckelktrVhgbSpcLrcKnlXOzbgP2geJa7kdCknnWUfLRSQJ07OXfI/jqIaE3Hiesxhu5
         ae+uE1o8/K5W4Z/nrv1uMmx9hX5gHAwlQnzw4T9bvhxV78IDR2g84v6yOvHFcVVmL4Bb
         drmGEYpDhIfi16aquTDBQZn6dLxLytaoNLJyjqqvBYVIoAZBcRqMWNVxlXE8EUiou6+b
         4QT1viSc6g+wZKM0QjWiN19CH90eGzWQ/R9UA8FaH1i5tim76iSa+cRqwehjzEzB3uNa
         VPKA==
X-Forwarded-Encrypted: i=1; AJvYcCV7lpP6Xvf8P5Z1P8SOJqJPwBjxQHLU4ggZbf1EG+CSWLQRtU8wPIonz8zixZjD77qSTkGX9GowKlT5lx9JuIzzQ866m6Zvn/aA
X-Gm-Message-State: AOJu0YzqnudpP7XJ0c5e0p86ihaJ8ivwWhAlRrciSVT8TAF0MVTuKvp5
	3hOOdU/vHPPDXpQnSnv91IbGLvlBfFWhGXjK55wsJw+g2+amS2QlXtYB4DLFNNL+s3fKY2MMDpx
	kChSP7xDzYZBSH0/5TwRBp/HPasbO56yiCRvczY+cvZuakvcKrX0xIW4qou8NfbHmbPvAKMlTq5
	TeXZcRP9Mo2kDy8UP53J7sbMNURr6MXcf8
X-Received: by 2002:a5b:b49:0:b0:de4:634c:b2fb with SMTP id 3f1490d57ef6-df4e0bcafd3mr2574613276.35.1716394060657;
        Wed, 22 May 2024 09:07:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZPsKGZkaK960aVcenANeqiEnBLvDfmpByfzVmheFQ1GplmSFQisKMFeZnFzQL6u/071hTioI1SkQfCR3LqGk=
X-Received: by 2002:a5b:b49:0:b0:de4:634c:b2fb with SMTP id
 3f1490d57ef6-df4e0bcafd3mr2574581276.35.1716394060278; Wed, 22 May 2024
 09:07:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240520130048.1483177-1-jonah.palmer@oracle.com> <20240520130048.1483177-4-jonah.palmer@oracle.com>
In-Reply-To: <20240520130048.1483177-4-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 22 May 2024 18:07:04 +0200
Message-ID: <CAJaqyWdxt+cPNR=unm6P1cGCKV=LwhuMYdVeQLbWF6wYLBLWKg@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] virtio: virtqueue_ordered_fill - VIRTIO_F_IN_ORDER support
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
> Add VIRTIO_F_IN_ORDER feature support for the virtqueue_fill operation.
>
> The goal of the virtqueue_ordered_fill operation when the
> VIRTIO_F_IN_ORDER feature has been negotiated is to search for this
> now-used element, set its length, and mark the element as filled in
> the VirtQueue's used_elems array.
>
> By marking the element as filled, it will indicate that this element has
> been processed and is ready to be flushed, so long as the element is
> in-order.
>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  hw/virtio/virtio.c | 36 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
>
> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> index 7456d61bc8..01b6b32460 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -873,6 +873,38 @@ static void virtqueue_packed_fill(VirtQueue *vq, con=
st VirtQueueElement *elem,
>      vq->used_elems[idx].ndescs =3D elem->ndescs;
>  }
>
> +static void virtqueue_ordered_fill(VirtQueue *vq, const VirtQueueElement=
 *elem,
> +                                   unsigned int len)
> +{
> +    unsigned int i, steps, max_steps;
> +
> +    i =3D vq->used_idx;
> +    steps =3D 0;
> +    /*
> +     * We shouldn't need to increase 'i' by more than the distance
> +     * between used_idx and last_avail_idx.
> +     */
> +    max_steps =3D (vq->last_avail_idx + vq->vring.num - vq->used_idx)
> +                % vq->vring.num;

I may be missing something, but (+vq->vring.num) is redundant if we (%
vq->vring.num), isn't it?

> +
> +    /* Search for element in vq->used_elems */
> +    while (steps <=3D max_steps) {
> +        /* Found element, set length and mark as filled */
> +        if (vq->used_elems[i].index =3D=3D elem->index) {
> +            vq->used_elems[i].len =3D len;
> +            vq->used_elems[i].in_order_filled =3D true;
> +            break;
> +        }
> +
> +        i +=3D vq->used_elems[i].ndescs;
> +        steps +=3D vq->used_elems[i].ndescs;
> +
> +        if (i >=3D vq->vring.num) {
> +            i -=3D vq->vring.num;
> +        }
> +    }
> +}
> +

Let's report an error if we finish the loop. I think:
qemu_log_mask(LOG_GUEST_ERROR,
              "%s: %s cannot fill buffer id %u\n",
              __func__, vdev->name, elem->index);

(or similar) should do.

apart form that,

Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

>  static void virtqueue_packed_fill_desc(VirtQueue *vq,
>                                         const VirtQueueElement *elem,
>                                         unsigned int idx,
> @@ -923,7 +955,9 @@ void virtqueue_fill(VirtQueue *vq, const VirtQueueEle=
ment *elem,
>          return;
>      }
>
> -    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
> +    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
> +        virtqueue_ordered_fill(vq, elem, len);
> +    } else if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) =
{
>          virtqueue_packed_fill(vq, elem, len, idx);
>      } else {
>          virtqueue_split_fill(vq, elem, len, idx);
> --
> 2.39.3
>

