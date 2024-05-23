Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7891E1C3E
	for <virtio-fs@lists.linux.dev>; Thu, 23 May 2024 10:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716461321; cv=none; b=cpxSsTNMDajxDVZmTSPiiWsIjxdwgRokva7JZsHz3ZGXAePM+xp2rMS/gYKBh3RRY/1bgR0yKypZde7cPtPaOCRpyWCumeNy7NvV9530eRvicHrLO1AZkM/9knKFb6QD/mEez2WOb4IoIkQcJ8bfabg12RuHVBuRgHV7tWo3k5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716461321; c=relaxed/simple;
	bh=M35iix6HeLNqFiqYHTxQfqCysWtlceufGaKFWzar1JI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dJ2SzLZh6oD7F1THPN4JTtexCb+WgctLFVyNGwuDX3bTjM+rQwl2OJ07M5SYt6uMOKIyU+WaIyi28es4Qm/9rb5rNKFA6eskvgltrb4pjVNv8ZpuJJ/bLZU39q+cyjMPkbskb/ZhV+o4vj+vtZaRCb9P9Dqvr/CgCGrhx31sFo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KAQPljWE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KAQPljWE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716461318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LsKlGJYohu5RsJn846NAapVIb9h8a0Dbbqc6cKw84wI=;
	b=KAQPljWEAQQMixGESlCDZvMF2EQ+zK9/RZsLISfCxmxFqApnzQIis5Qnkg6zZqm1lJlFL4
	+PzF2TUFDY68sRZxIFfhC1VEKhF+sxMVU/zDdqqGgKkyqqVNA9O99Xu2n7WIOxb5YQp5FG
	eaj1ScN4RB5sFp+mDToFCDhMZnqZn/c=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-UewIBisLMnKhTDBYlE1Iaw-1; Thu, 23 May 2024 06:48:35 -0400
X-MC-Unique: UewIBisLMnKhTDBYlE1Iaw-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-df4e4d71754so3150052276.0
        for <virtio-fs@lists.linux.dev>; Thu, 23 May 2024 03:48:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716461314; x=1717066114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LsKlGJYohu5RsJn846NAapVIb9h8a0Dbbqc6cKw84wI=;
        b=ThPcrn1ppfCcdgolof8isuvBvqqgFyN+iBWdYfJ5K+Mt4YPRD7Aa2Exq2LOsVdHj0a
         5UQVcN57K8In4bswmWmme0MZYYj70v22Gn1DRejngioEnpimNw/uU9LQgn2D7cvVlnEH
         Fnt9NF+a+l7hSCHcVjWGxs4CtvMhj15RerMt69eqBVz78XFK69jc3gSFiZv8cBxDaaBm
         cHV0CDDy4SGAJB9qd0S3zAQflBjzAjMBIhcE7SqbUfUoHtNl7arneT4ybpn7vOiXADT6
         g/joWi6x3xSw0zqgZDBisvxckQ3iGpv+4Scskys7STMnJ3880+/++Vf8vejy39+Foqzw
         nHLw==
X-Forwarded-Encrypted: i=1; AJvYcCXxD5ggdP5BUHjFf5YGWLPiGUJonAM2l/hBxP3rkmo0M2fbapPukWJWaZqAybWEO1QafTm7H4LnWG8RmtEwS7DTqv49p9/7NM/H
X-Gm-Message-State: AOJu0YxhWM73kmC7ox5KQTNt+JL8TogFG2WIVivMoYWvE4xAEuuiyGrr
	DUo0Xx+dsYDBPAiIcHpPXUX5hEXONSZXSxENB/Tk+xvqYxIkfWvDEQ+GkAEloadgQOKcDScTa6e
	hB3eEA7QD49GtQ+u7N4taP9i/xhInCApJAWNxyWPObCS4LKR/Ue0RBo/ZgIv9mFIuXLD1pf0+ye
	XCtIxIcGCEiDKV2VvqO1mgbnnQN3oISYWQ
X-Received: by 2002:a25:b285:0:b0:df4:db71:c666 with SMTP id 3f1490d57ef6-df4e0d31cc6mr5276834276.38.1716461314643;
        Thu, 23 May 2024 03:48:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/68hVrVD2BM9Yb1HLGkfr7uikTT5HtvWhioQpaVyU14Ct4yXIqFd5ViowehU+j3JqsmHPEsRzrumUBsYOvzM=
X-Received: by 2002:a25:b285:0:b0:df4:db71:c666 with SMTP id
 3f1490d57ef6-df4e0d31cc6mr5276823276.38.1716461314333; Thu, 23 May 2024
 03:48:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240520130048.1483177-1-jonah.palmer@oracle.com>
 <20240520130048.1483177-4-jonah.palmer@oracle.com> <CAJaqyWdxt+cPNR=unm6P1cGCKV=LwhuMYdVeQLbWF6wYLBLWKg@mail.gmail.com>
 <5469bc3f-7fb5-4fcf-ad9c-6467aba635b9@oracle.com>
In-Reply-To: <5469bc3f-7fb5-4fcf-ad9c-6467aba635b9@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 23 May 2024 12:47:58 +0200
Message-ID: <CAJaqyWe1ozf867a7tnSKjkijnHtT+5i7y8p9zvtTXqgZNk74aA@mail.gmail.com>
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

On Thu, May 23, 2024 at 12:30=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.=
com> wrote:
>
>
>
> On 5/22/24 12:07 PM, Eugenio Perez Martin wrote:
> > On Mon, May 20, 2024 at 3:01=E2=80=AFPM Jonah Palmer <jonah.palmer@orac=
le.com> wrote:
> >>
> >> Add VIRTIO_F_IN_ORDER feature support for the virtqueue_fill operation=
.
> >>
> >> The goal of the virtqueue_ordered_fill operation when the
> >> VIRTIO_F_IN_ORDER feature has been negotiated is to search for this
> >> now-used element, set its length, and mark the element as filled in
> >> the VirtQueue's used_elems array.
> >>
> >> By marking the element as filled, it will indicate that this element h=
as
> >> been processed and is ready to be flushed, so long as the element is
> >> in-order.
> >>
> >> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> >> ---
> >>   hw/virtio/virtio.c | 36 +++++++++++++++++++++++++++++++++++-
> >>   1 file changed, 35 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> >> index 7456d61bc8..01b6b32460 100644
> >> --- a/hw/virtio/virtio.c
> >> +++ b/hw/virtio/virtio.c
> >> @@ -873,6 +873,38 @@ static void virtqueue_packed_fill(VirtQueue *vq, =
const VirtQueueElement *elem,
> >>       vq->used_elems[idx].ndescs =3D elem->ndescs;
> >>   }
> >>
> >> +static void virtqueue_ordered_fill(VirtQueue *vq, const VirtQueueElem=
ent *elem,
> >> +                                   unsigned int len)
> >> +{
> >> +    unsigned int i, steps, max_steps;
> >> +
> >> +    i =3D vq->used_idx;
> >> +    steps =3D 0;
> >> +    /*
> >> +     * We shouldn't need to increase 'i' by more than the distance
> >> +     * between used_idx and last_avail_idx.
> >> +     */
> >> +    max_steps =3D (vq->last_avail_idx + vq->vring.num - vq->used_idx)
> >> +                % vq->vring.num;
> >
> > I may be missing something, but (+vq->vring.num) is redundant if we (%
> > vq->vring.num), isn't it?
> >
>
> It ensures the result is always non-negative (e.g. when
> vq->last_avail_idx < vq->used_idx).
>
> I wasn't sure how different platforms or compilers would handle
> something like -5 % 10, so to be safe I included the '+ vq->vring.num'.
>
> For example, on my system, in test.c;
>
>     #include <stdio.h>
>
>     int main() {
>         unsigned int result =3D -5 % 10;
>         printf("Result of -5 %% 10 is: %d\n", result);
>         return 0;
>     }
>
> # gcc -o test test.c
>
> # ./test
> Result of -5 % 10 is: -5
>

I think the modulo is being done in signed ints in your test, and then
converting a signed int to an unsigned int. Like result =3D (-5 % 10).

The unsigned wrap is always defined in C, and vq->last_avail_idx and
vq->used_idx are both unsigned. Here is a closer test:
int main(void) {
    unsigned int a =3D -5, b =3D 2;
    unsigned int result =3D (b-a) % 10;
    printf("Result of -5 %% 10 is: %u\n", result);
    return 0;
}

But it is a good catch for signed ints for sure :).

Thanks!

> >> +
> >> +    /* Search for element in vq->used_elems */
> >> +    while (steps <=3D max_steps) {
> >> +        /* Found element, set length and mark as filled */
> >> +        if (vq->used_elems[i].index =3D=3D elem->index) {
> >> +            vq->used_elems[i].len =3D len;
> >> +            vq->used_elems[i].in_order_filled =3D true;
> >> +            break;
> >> +        }
> >> +
> >> +        i +=3D vq->used_elems[i].ndescs;
> >> +        steps +=3D vq->used_elems[i].ndescs;
> >> +
> >> +        if (i >=3D vq->vring.num) {
> >> +            i -=3D vq->vring.num;
> >> +        }
> >> +    }
> >> +}
> >> +
> >
> > Let's report an error if we finish the loop. I think:
> > qemu_log_mask(LOG_GUEST_ERROR,
> >                "%s: %s cannot fill buffer id %u\n",
> >                __func__, vdev->name, elem->index);
> >
> > (or similar) should do.
> >
> > apart form that,
> >
> > Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >
>
> Gotcha. Will add this in v3.
>
> Thank you Eugenio!
>
> >>   static void virtqueue_packed_fill_desc(VirtQueue *vq,
> >>                                          const VirtQueueElement *elem,
> >>                                          unsigned int idx,
> >> @@ -923,7 +955,9 @@ void virtqueue_fill(VirtQueue *vq, const VirtQueue=
Element *elem,
> >>           return;
> >>       }
> >>
> >> -    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
> >> +    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
> >> +        virtqueue_ordered_fill(vq, elem, len);
> >> +    } else if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED=
)) {
> >>           virtqueue_packed_fill(vq, elem, len, idx);
> >>       } else {
> >>           virtqueue_split_fill(vq, elem, len, idx);
> >> --
> >> 2.39.3
> >>
> >
>

