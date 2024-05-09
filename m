Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F3115B130
	for <virtio-fs@lists.linux.dev>; Thu,  9 May 2024 14:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715263751; cv=none; b=mGVCXnFpLJ9CBP2RHGJnhs07aQFGtAkHrJspjc+SHIZVsHN6dSh1G/GO9YLpdkL9lSZCEGNmdEzwvSie5LJ3bu/E4C0/YpX1f8WX2HX5yH33TaxF3QjuQLm/qdj4XT60xrJEByItfdUnpilLS2w3DkIMbo60rmeQGczgkFMorPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715263751; c=relaxed/simple;
	bh=Sf1lGVGiqfyKedPbm9DmNDdV2veeaCv/biQ/vLOpcuQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sLrb+5aj07UcrAXvPchU7nMSuIkBOx8pspd2HZ87Bxf8Iqe/LnNTQF4FTE6o0pjlNEQKt812P3Log5kI94pdpCjMcznphXqgT3hjBdulZmC139cL6I1Mtc7Svz7GHADO3OlufIA2W6pvmaOIPw2oSSr6c/RE50jewKUOse5zxRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iAtcE+pk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iAtcE+pk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715263748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QcDlEInEE+lxtzTRhb2xwAAma+0g1x25vdI1AGC9KKA=;
	b=iAtcE+pkLh/r9kAtV1Dd68ALTgipFLpJa55qDDptRzG+PdMZcJ85seMHHYy2cIIsTUZmCn
	GGLd4As7eNMAU8jQur2jYXyGE3VfrI1d957IQVa3upIamVzcAYgADQ87YRjJ0kJ0XmT/O2
	J3lkVrbDqxfRhVvy3KCkAMfHPfc7ehw=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-Gf1WeXqLOum5SB04fH5MLQ-1; Thu, 09 May 2024 10:09:07 -0400
X-MC-Unique: Gf1WeXqLOum5SB04fH5MLQ-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-61dfa4090c1so12620667b3.3
        for <virtio-fs@lists.linux.dev>; Thu, 09 May 2024 07:09:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715263747; x=1715868547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QcDlEInEE+lxtzTRhb2xwAAma+0g1x25vdI1AGC9KKA=;
        b=PIhBQxkHLyyA5YHeafN25mNIESrWaTHTyyHNScBv0UQDopXBxm0wj2Bv2oDQ0KDAT+
         zToZTzCJyB9Izl74S+0qy0mPH+2jG0GHCRXUEfRAcUbcfFBoFfSWazOr5kG0wizuG8AJ
         bxDvSyJcVAUmIcoGLa1rcX7uyXcAk15AZPSVN79J8PDkPteKigShemscpFFq1R7fzvyv
         XR0bYgHJH38spW4A8Z452K9By2tFWDqbSVs+4I1pbm8/kGyCQF6R5YIw+8yfOp2L17Mu
         Mqsd/M/WK7VjVB6HUa26RsRC/x3FR/aYuFcBjk9yivM2z3U2C7117NHc6zwThAFkMBy5
         UpSg==
X-Forwarded-Encrypted: i=1; AJvYcCVBYOxxMPsKi0TXLAY23TznMLdyifXJHgkTl6VkKQ09jQ1SMfdFl6CA3JoRSE2zinVhMHPuGDIbUWuXHSHfa/LO8IISsmqwU7uL
X-Gm-Message-State: AOJu0YwpSO56dZVoxGrH0cosaO/6XhTL8cYSIln2qHh0hc2JYH9Ez7Eg
	M7i18pWz6csFl0njYPfA1dDBkNE0Y69UxMJ+TspOAZj9whVownFQE8wEMTM5H8pOU7wJu0ZDnfr
	Xw3UfB5qeEaf3gsZDQuBp7hKjMTmaAavVgisHH4Nu6QeZvoFomCgElmtZiByDHUMx1lmjtWqjyO
	mjIAA2GByyQe1gBzSVdckcsgoR1iuv2tfp
X-Received: by 2002:a5b:64c:0:b0:dda:a4ba:2a5 with SMTP id 3f1490d57ef6-debb9dd94c2mr5756718276.63.1715263746633;
        Thu, 09 May 2024 07:09:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFplgAc9BugENhNfTYu2SQLewArgeXQNAEFenvlIUMcnDEn0GNuPrsjJ/+qLHk5ljL1f3/RBixyjp8XvDXCiaQ=
X-Received: by 2002:a5b:64c:0:b0:dda:a4ba:2a5 with SMTP id 3f1490d57ef6-debb9dd94c2mr5756693276.63.1715263746265;
 Thu, 09 May 2024 07:09:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240506150428.1203387-1-jonah.palmer@oracle.com> <20240506150428.1203387-4-jonah.palmer@oracle.com>
In-Reply-To: <20240506150428.1203387-4-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 9 May 2024 16:08:29 +0200
Message-ID: <CAJaqyWcTSQ4hyzfYRENE93GnHMhgvY4X_gz3ydnpYUMz1_J8aA@mail.gmail.com>
Subject: Re: [PATCH 3/6] virtio: virtqueue_ordered_fill - VIRTIO_F_IN_ORDER support
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

On Mon, May 6, 2024 at 5:05=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.co=
m> wrote:
>
> Add VIRTIO_F_IN_ORDER feature support for virtqueue_fill operations.
>
> The goal of the virtqueue_fill operation when the VIRTIO_F_IN_ORDER
> feature has been negotiated is to search for this now-used element,
> set its length, and mark the element as filled in the VirtQueue's
> used_elems array.
>
> By marking the element as filled, it will indicate that this element is
> ready to be flushed, so long as the element is in-order.
>
> Tested-by: Lei Yang <leiyang@redhat.com>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  hw/virtio/virtio.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> index e6eb1bb453..064046b5e2 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -873,6 +873,28 @@ static void virtqueue_packed_fill(VirtQueue *vq, con=
st VirtQueueElement *elem,
>      vq->used_elems[idx].ndescs =3D elem->ndescs;
>  }
>
> +static void virtqueue_ordered_fill(VirtQueue *vq, const VirtQueueElement=
 *elem,
> +                                   unsigned int len)
> +{
> +    unsigned int i =3D vq->used_idx;
> +
> +    /* Search for element in vq->used_elems */
> +    while (i !=3D vq->last_avail_idx) {
> +        /* Found element, set length and mark as filled */
> +        if (vq->used_elems[i].index =3D=3D elem->index) {
> +            vq->used_elems[i].len =3D len;
> +            vq->used_elems[i].filled =3D true;
> +            break;
> +        }
> +
> +        i +=3D vq->used_elems[i].ndescs;
> +
> +        if (i >=3D vq->vring.num) {
> +            i -=3D vq->vring.num;
> +        }
> +    }

This has a subtle problem: ndescs and elems->id are controlled by the
guest, so it could make QEMU to loop forever looking for the right
descriptor. For each iteration, the code must control that the
variable "i" will be different for the next iteration, and that there
will be no more than vq->last_avail_idx - vq->used_idx iterations.

Apart of that, I think it makes more sense to split the logical
sections of the function this way:
/* declarations */
i =3D vq->used_idx

/* Search for element in vq->used_elems */
while (vq->used_elems[i].index !=3D elem->index &&
vq->used_elems[i].index i !=3D vq->last_avail_idx && ...) {
...
}

/* Set length and mark as filled */
vq->used_elems[i].len =3D len;
vq->used_elems[i].filled =3D true;
---

But I'm ok either way.

> +}
> +
>  static void virtqueue_packed_fill_desc(VirtQueue *vq,
>                                         const VirtQueueElement *elem,
>                                         unsigned int idx,
> @@ -923,7 +945,9 @@ void virtqueue_fill(VirtQueue *vq, const VirtQueueEle=
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

