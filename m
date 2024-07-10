Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB28194AEF
	for <virtio-fs@lists.linux.dev>; Wed, 10 Jul 2024 16:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720628237; cv=none; b=Cl5CuHE0PgVVZjyOUHmAmDp15Kz3g39VLZlZrhTTyWy6rp8KIq8noJ2w8HGDDJ3RIkuvHUPNIHDAzP1qV3bdpLDqAl5T0m0sFrzztHJBm7ezl3k5sUfnjbJC89VicKRq+aG8mhdFZ5YHEUHggVFHTRSLQcyi4p/XRZSDyiaJCC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720628237; c=relaxed/simple;
	bh=8r4hvBHzY4HxeBwLHp09xxTM1xW0wrjbAvNhxHLfLb0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hOrOJI/CZvPeunA3hW3vT/8O8UjK2mEU7paJLurGZ4HnJJ//+iTX7+KS2JFGl2CWB0iruPUzhynypq4NjlMbIxP5XBBH7XUTAKkGZPM0+wfP8zdt7H8Ha++C4kFI6bdg150BVmi22wmajdvLUOwKlvkFFdwApbNBZrCnFuYuUVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GiEfTCw1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GiEfTCw1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720628234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RN+Cyaod45FRM4pbFQEXu+jCysRMbqUsAMGmsZni5WE=;
	b=GiEfTCw1uwpaX5lI5V1Hp1Qhp+otu65EgD2CXVVllpxi81+fotwWiWnDNzUgit12bHBDmL
	+n2SzfAWRgLVsKYVjX6wZAqf1oH9cdahPZNYfk1iQlqEinoQ7OplkNiA4i2u8sjTGoL8Ol
	JFQAf+WX6uRM97DzhZpidV9FzbFGtHE=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-8sKxoYlzNcab0zpgPOJJKw-1; Wed, 10 Jul 2024 12:17:13 -0400
X-MC-Unique: 8sKxoYlzNcab0zpgPOJJKw-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-654d96c2bb5so69034067b3.2
        for <virtio-fs@lists.linux.dev>; Wed, 10 Jul 2024 09:17:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720628232; x=1721233032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RN+Cyaod45FRM4pbFQEXu+jCysRMbqUsAMGmsZni5WE=;
        b=JzET58P+E2A2L398UAc/jqindiUTQztQvguQIsocR94Xu/kzfsjpxvqG37H7mEydaQ
         4nJ3ClJA3Zwm41qIFpt0cbPaSOLTZHA3sqIo3FnRbfkmPS+KA/8J8JTg7/hL5HsadZT+
         R/OJb8cSNFxvLXSDCTSO4ZYgHjlN2EmgOpU/DfaxySwq8ATOw1GlaL1DOIu30SVH1g4R
         lSJvU5aKw4tpFv1Iu10TZvfcQetWIJ79n8Bf3/KjWUY/KKrPEGBejX7tsj5A1VNW9vRD
         LoRzPDdkaRyOhgE6P8EbEr9gD/PrkyMlOTv76AdYG8+2FrnmSINYV8eYb+5XlbeGte1G
         yD2w==
X-Forwarded-Encrypted: i=1; AJvYcCUgHEHqz5BBfORRuypIlfG6GJhEAdOtg/bFKmOj+TGNC3ZV/hzQDSfIhKoteE/eEMlw0JQTQIwzRLjfyzRPBl2MEQhtwHkGH8Ek
X-Gm-Message-State: AOJu0YyQPkoUw57ugIqr4luH5wjHDSw18ZuBJ6HBX2GYpp8TahgzmokG
	IM/yxOpjqmbTMTyM0sRssC9QxKq4sPESFfsGoTdv/9LH9lxSes7iofKOUkbrn4WtMJ+KzfIxIzO
	5uvhSFw++fWjwJ/49VkhXF8LdbdzEXIehKHFrzWEusyXRtUg8NZ1wN2l5la6EvjJM9VeyKYaxwb
	h+zLayZ9H56gJpaLW5EQ3k8d0oknHCyfdh
X-Received: by 2002:a81:5b42:0:b0:64a:6eda:fc60 with SMTP id 00721157ae682-658ee69ac4cmr68719287b3.4.1720628232330;
        Wed, 10 Jul 2024 09:17:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEx96Zdg0x9PwmiJz7fW1Yj/5iewtu0Rawq71SJ5g0w/ZxTyxwG3nC+/ch8ExvdfAmm4qFIsLa85dROMUHl0LI=
X-Received: by 2002:a81:5b42:0:b0:64a:6eda:fc60 with SMTP id
 00721157ae682-658ee69ac4cmr68718837b3.4.1720628231788; Wed, 10 Jul 2024
 09:17:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240710125522.4168043-1-jonah.palmer@oracle.com> <20240710125522.4168043-5-jonah.palmer@oracle.com>
In-Reply-To: <20240710125522.4168043-5-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 10 Jul 2024 18:16:35 +0200
Message-ID: <CAJaqyWfRCAif9ou9XMCbDaKWPqt9msB7QbdbSGVkqTJv8O_McQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] virtio: virtqueue_ordered_flush -
 VIRTIO_F_IN_ORDER support
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

On Wed, Jul 10, 2024 at 2:56=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
> Add VIRTIO_F_IN_ORDER feature support for the virtqueue_flush operation.
>
> The goal of the virtqueue_ordered_flush operation when the
> VIRTIO_F_IN_ORDER feature has been negotiated is to write elements to
> the used/descriptor ring in-order and then update used_idx.
>
> The function iterates through the VirtQueueElement used_elems array
> in-order starting at vq->used_idx. If the element is valid (filled), the
> element is written to the used/descriptor ring. This process continues
> until we find an invalid (not filled) element.
>
> For packed VQs, the first entry (at vq->used_idx) is written to the
> descriptor ring last so the guest doesn't see any invalid descriptors.
>
> If any elements were written, the used_idx is updated.
>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> ---
> Several fixes here for the split VQ case:
> - Ensure all previous write operations to buffers are completed before
>   updating the used_idx (via smp_wmb()).
>
> - used_elems index 'i' should be incremented by the number of descriptors
>   in the current element we just processed, not by the running total of
>   descriptors already seen. This would've caused batched operations to
>   miss ordered elements when looping through the used_elems array.
>
> - Do not keep the VQ's used_idx bound between 0 and vring.num-1 when
>   setting it via vring_used_idx_set().
>
>   While the packed VQ case naturally keeps used_idx bound between 0 and
>   vring.num-1, the split VQ case cannot. This is because used_idx is
>   used to compare the current event index with the new and old used
>   indices to decide if a notification is necessary (see
>   virtio_split_should_notify()). This comparison expects used_idx to be
>   between 0 and 65535, not 0 and vring.num-1.
>
>  hw/virtio/virtio.c | 70 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 69 insertions(+), 1 deletion(-)
>
> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> index 0000a7b41c..b419d8d6e7 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -1023,6 +1023,72 @@ static void virtqueue_packed_flush(VirtQueue *vq, =
unsigned int count)
>      }
>  }
>
> +static void virtqueue_ordered_flush(VirtQueue *vq)
> +{
> +    unsigned int i =3D vq->used_idx % vq->vring.num;
> +    unsigned int ndescs =3D 0;
> +    uint16_t old =3D vq->used_idx;
> +    uint16_t new;
> +    bool packed;
> +    VRingUsedElem uelem;
> +
> +    packed =3D virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED);
> +
> +    if (packed) {
> +        if (unlikely(!vq->vring.desc)) {
> +            return;
> +        }
> +    } else if (unlikely(!vq->vring.used)) {
> +        return;
> +    }
> +
> +    /* First expected in-order element isn't ready, nothing to do */
> +    if (!vq->used_elems[i].in_order_filled) {
> +        return;
> +    }
> +
> +    /* Search for filled elements in-order */
> +    while (vq->used_elems[i].in_order_filled) {
> +        /*
> +         * First entry for packed VQs is written last so the guest
> +         * doesn't see invalid descriptors.
> +         */
> +        if (packed && i !=3D vq->used_idx) {
> +            virtqueue_packed_fill_desc(vq, &vq->used_elems[i], ndescs, f=
alse);
> +        } else if (!packed) {
> +            uelem.id =3D vq->used_elems[i].index;
> +            uelem.len =3D vq->used_elems[i].len;
> +            vring_used_write(vq, &uelem, i);
> +        }
> +
> +        vq->used_elems[i].in_order_filled =3D false;
> +        ndescs +=3D vq->used_elems[i].ndescs;
> +        i +=3D vq->used_elems[i].ndescs;
> +        if (i >=3D vq->vring.num) {
> +            i -=3D vq->vring.num;
> +        }
> +    }
> +
> +    if (packed) {
> +        virtqueue_packed_fill_desc(vq, &vq->used_elems[vq->used_idx], 0,=
 true);
> +        vq->used_idx +=3D ndescs;
> +        if (vq->used_idx >=3D vq->vring.num) {
> +            vq->used_idx -=3D vq->vring.num;
> +            vq->used_wrap_counter ^=3D 1;
> +            vq->signalled_used_valid =3D false;
> +        }
> +    } else {
> +        /* Make sure buffer is written before we update index. */
> +        smp_wmb();
> +        new =3D old + ndescs;
> +        vring_used_idx_set(vq, new);
> +        if (unlikely((int16_t)(new - vq->signalled_used) < (uint16_t)(ne=
w - old))) {
> +            vq->signalled_used_valid =3D false;
> +        }
> +    }
> +    vq->inuse -=3D ndescs;
> +}
> +
>  void virtqueue_flush(VirtQueue *vq, unsigned int count)
>  {
>      if (virtio_device_disabled(vq->vdev)) {
> @@ -1030,7 +1096,9 @@ void virtqueue_flush(VirtQueue *vq, unsigned int co=
unt)
>          return;
>      }
>
> -    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
> +    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
> +        virtqueue_ordered_flush(vq);
> +    } else if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) =
{
>          virtqueue_packed_flush(vq, count);
>      } else {
>          virtqueue_split_flush(vq, count);
> --
> 2.43.5
>

