Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9614D2C189
	for <virtio-fs@lists.linux.dev>; Thu,  4 Apr 2024 11:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712230601; cv=none; b=P4eJy7wnjQW2Hf0df6E5A3xPlVzadQvNLTrTG3DK0h4bOw/1SXAYnQ2XJUeMwa3kZhyGtEYhNsUCVFkFPHypUEnYaDL25cBnMdEgYmUleSGkOR0zLa008pn5pqS23R438YnR8cmebeTiNKTmWuQLrkD+P06BLfOJU3oeuvFPQ4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712230601; c=relaxed/simple;
	bh=NGjUsHfHbX+gQj1NQLQkc7kKnvUMJjFMb4Z9VtiNFQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SJvlBwxth2Rh3rmr6kCkovs1IegaF7Hg9pMjVLWnrOGIAzMBkq80S5Vttw5uxv0n2caPDPshva1z5adFnarlRmv2V/L2RfpGhUEBLzU90g7ev53+XgKYTEa6W6hLn6E6alssYeqSeYwijpLyR8RXHlMc/uvPpeX5JDrl+oDH6IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d0IefuUg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d0IefuUg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712230598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RNMoQEQsCVQ9u9TBUjJgMO33xcoOLuAj1qtb8Gwf8Uc=;
	b=d0IefuUgD5KaZzHU4S8BQKglEHC5WmjD6wXr0ieHG+4vmE28TbB18mc+aUaC6T3UsfdjX+
	AqUOaeeN/SXDwYm86L+mfc0xOwcjTXR0EpYiS/Z4I7a0uPIxqKjEZbNdCK5rghxMemQzKb
	TBv87wTtMuf6Gx4Wk3NZJp4SYC11ldM=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-evMG9fm1M7urorKPLseRnw-1; Thu, 04 Apr 2024 07:36:35 -0400
X-MC-Unique: evMG9fm1M7urorKPLseRnw-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-dcc05887ee9so1332710276.1
        for <virtio-fs@lists.linux.dev>; Thu, 04 Apr 2024 04:36:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712230594; x=1712835394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RNMoQEQsCVQ9u9TBUjJgMO33xcoOLuAj1qtb8Gwf8Uc=;
        b=D8gLuFBXN9qOILtwQz9+7fDphjAF/G1DOuqu4y3oIrfQQv+IwHDua+hSvhvDcUwRyb
         rGKfdkXW1+yq0DAkblrBqm1eOnvhycwSlmbudPhpxvD2rl7wYukis5UzaM9Dm2YJmkT6
         kWxDcrZK7ZZf3z91TScGhiFz7XXIR3ZAhugYEE4V6zSwE70NPaCvA6+A6zip9OPx+m9n
         mDZVe54WX2RTc+Jyg8YvZRWfVUR7EEcBOEcsOxePP6sC735Eeg3jTwQnhGZOIeEUDPu2
         aOfbcgSIrFnndcjYcHG4eiLCaGramRxInbVKnMIvV8P0uh27V1NfeRqcD8wK8L8uZx0o
         TtuA==
X-Forwarded-Encrypted: i=1; AJvYcCWFA5yBnYy53PDvDJpvX+sQt+Oll6+ZigSo+D9CLQ/6xi/kSTd+4vEJHYgbfCn8ITSByT0ft0N3UcVPcRKdXz5+Yvau2tEzXL/Q
X-Gm-Message-State: AOJu0YxmOFBkuXI+nknSrTdUTPTzTeI89R4p+MApcXhXKnuXDIXI8mi4
	e6iFuTWLJzohoRA4D6griUOvMSXRHcWCYHlsOX9EL2ZSPZ0+OZimN/10VYW2tKNRBnAthpQWQUo
	rqpYzvxclggD6rtIgW2EjGULzU5JghOaMRFuO3ygAdoH+w+5R0xZJwiMcrRz2cPubkntg6C8JEa
	jsMO+D0Rwifc0kNV2iFmDRpJvH4OXegw05
X-Received: by 2002:a25:8f89:0:b0:dd1:48cf:5c8 with SMTP id u9-20020a258f89000000b00dd148cf05c8mr2199538ybl.2.1712230594534;
        Thu, 04 Apr 2024 04:36:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfh0RuuGQrzpIEzwd0eFur/V5dVErXs+fFlCtdZBmyHK3U8/n+f+7xsZxheDWy/WdVW7oQfO4gbZgGUlvbhrg=
X-Received: by 2002:a25:8f89:0:b0:dd1:48cf:5c8 with SMTP id
 u9-20020a258f89000000b00dd148cf05c8mr2199518ybl.2.1712230594190; Thu, 04 Apr
 2024 04:36:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240328162203.3775114-1-jonah.palmer@oracle.com>
 <20240328162203.3775114-2-jonah.palmer@oracle.com> <CAJaqyWdyZdu48+cZ2umafLRi9NTz3YHxSxmyq6SD9d4noTR2jQ@mail.gmail.com>
 <768ffc05-333a-4f00-9944-940bcaca59fd@oracle.com>
In-Reply-To: <768ffc05-333a-4f00-9944-940bcaca59fd@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 4 Apr 2024 13:35:58 +0200
Message-ID: <CAJaqyWe3bw6WML9MLEhnpNuWL0_HUQJ4WrSyr1jnGHs6Jwn0-Q@mail.gmail.com>
Subject: Re: [RFC v2 1/5] virtio: Initialize sequence variables
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

On Wed, Apr 3, 2024 at 6:51=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.co=
m> wrote:
>
>
>
> On 4/3/24 6:18 AM, Eugenio Perez Martin wrote:
> > On Thu, Mar 28, 2024 at 5:22=E2=80=AFPM Jonah Palmer <jonah.palmer@orac=
le.com> wrote:
> >>
> >> Initialize sequence variables for VirtQueue and VirtQueueElement
> >> structures. A VirtQueue's sequence variables are initialized when a
> >> VirtQueue is being created or reset. A VirtQueueElement's sequence
> >> variable is initialized when a VirtQueueElement is being initialized.
> >> These variables will be used to support the VIRTIO_F_IN_ORDER feature.
> >>
> >> A VirtQueue's used_seq_idx represents the next expected index in a
> >> sequence of VirtQueueElements to be processed (put on the used ring).
> >> The next VirtQueueElement added to the used ring must match this
> >> sequence number before additional elements can be safely added to the
> >> used ring. It's also particularly useful for helping find the number o=
f
> >> new elements added to the used ring.
> >>
> >> A VirtQueue's current_seq_idx represents the current sequence index.
> >> This value is essentially a counter where the value is assigned to a n=
ew
> >> VirtQueueElement and then incremented. Given its uint16_t type, this
> >> sequence number can be between 0 and 65,535.
> >>
> >> A VirtQueueElement's seq_idx represents the sequence number assigned t=
o
> >> the VirtQueueElement when it was created. This value must match with t=
he
> >> VirtQueue's used_seq_idx before the element can be put on the used rin=
g
> >> by the device.
> >>
> >> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> >> ---
> >>   hw/virtio/virtio.c         | 18 ++++++++++++++++++
> >>   include/hw/virtio/virtio.h |  1 +
> >>   2 files changed, 19 insertions(+)
> >>
> >> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> >> index fb6b4ccd83..069d96df99 100644
> >> --- a/hw/virtio/virtio.c
> >> +++ b/hw/virtio/virtio.c
> >> @@ -132,6 +132,10 @@ struct VirtQueue
> >>       uint16_t used_idx;
> >>       bool used_wrap_counter;
> >>
> >> +    /* In-Order sequence indices */
> >> +    uint16_t used_seq_idx;
> >> +    uint16_t current_seq_idx;
> >> +
> >
> > I'm having a hard time understanding the difference between these and
> > last_avail_idx and used_idx. It seems to me if we replace them
> > everything will work? What am I missing?
> >
>
> For used_seq_idx, it does work like used_idx except the difference is
> when their values get updated, specifically for the split VQ case.
>
> As you know, for the split VQ case, the used_idx is updated during
> virtqueue_split_flush. However, imagine a batch of elements coming in
> where virtqueue_split_fill is called multiple times before
> virtqueue_split_flush. We want to make sure we write these elements to
> the used ring in-order and we'll know its order based on used_seq_idx.
>
> Alternatively, I thought about replicating the logic for the packed VQ
> case (where this used_seq_idx isn't used) where we start looking at
> vq->used_elems[vq->used_idx] and iterate through until we find a used
> element, but I wasn't sure how to handle the case where elements get
> used (written to the used ring) and new elements get put in used_elems
> before the used_idx is updated. Since this search would require us to
> always start at index vq->used_idx.
>
> For example, say, of three elements getting filled (elem0 - elem2),
> elem1 and elem0 come back first (vq->used_idx =3D 0):
>
> elem1 - not in-order
> elem0 - in-order, vq->used_elems[vq->used_idx + 1] (elem1) also now
>          in-order, write elem0 and elem1 to used ring, mark elements as
>          used
>
> Then elem2 comes back, but vq->used_idx is still 0, so how do we know to
> ignore the used elements at vq->used_idx (elem0) and vq->used_idx + 1
> (elem1) and iterate to vq->used_idx + 2 (elem2)?
>
> Hmm... now that I'm thinking about it, maybe for the split VQ case we
> could continue looking through the vq->used_elems array until we find an
> unused element... but then again how would we (1) know if the element is
> in-order and (2) know when to stop searching?
>

Ok I think I understand the problem now. It is aggravated if we add
chained descriptors to the mix.

We know that the order of used descriptors must be the exact same as
the order they were made available, leaving out in order batching.
What if vq->used_elems at virtqueue_pop and then virtqueue_push just
marks them as used somehow? Two booleans (or flag) would do for a
first iteration.

If we go with this approach I think used_elems should be renamed actually.

> In any case, the use of this variable could be seen as an optimization
> as its value will tell us where to start looking in vq->used_elems
> instead of always starting at vq->used_idx.
>
> If this is like a one-shot scenario where one element gets written and
> then flushed after, then yes in this case used_seq_idx =3D=3D used_idx.
>
> ------
>
> For current_seq_idx, this is pretty much just a counter. Every new
> VirtQueueElement created from virtqueue_pop is given a number and the
> counter is incremented. Like grabbing a ticket number and waiting for
> your number to be called. The next person to grab a ticket number will
> be your number + 1.
>

So it's like last_avail_idx, isn't it?

> Let me know if I'm making any sense. Thanks :)
>
> Jonah
>
> >>       /* Last used index value we have signalled on */
> >>       uint16_t signalled_used;
> >>
> >> @@ -1621,6 +1625,11 @@ static void *virtqueue_split_pop(VirtQueue *vq,=
 size_t sz)
> >>           elem->in_sg[i] =3D iov[out_num + i];
> >>       }
> >>
> >> +    /* Assign sequence index for in-order processing */
> >> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
> >> +        elem->seq_idx =3D vq->current_seq_idx++;
> >> +    }
> >> +
> >>       vq->inuse++;
> >>
> >>       trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
> >> @@ -1760,6 +1769,11 @@ static void *virtqueue_packed_pop(VirtQueue *vq=
, size_t sz)
> >>       vq->shadow_avail_idx =3D vq->last_avail_idx;
> >>       vq->shadow_avail_wrap_counter =3D vq->last_avail_wrap_counter;
> >>
> >> +    /* Assign sequence index for in-order processing */
> >> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
> >> +        elem->seq_idx =3D vq->current_seq_idx++;
> >> +    }
> >> +
> >>       trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
> >>   done:
> >>       address_space_cache_destroy(&indirect_desc_cache);
> >> @@ -2087,6 +2101,8 @@ static void __virtio_queue_reset(VirtIODevice *v=
dev, uint32_t i)
> >>       vdev->vq[i].notification =3D true;
> >>       vdev->vq[i].vring.num =3D vdev->vq[i].vring.num_default;
> >>       vdev->vq[i].inuse =3D 0;
> >> +    vdev->vq[i].used_seq_idx =3D 0;
> >> +    vdev->vq[i].current_seq_idx =3D 0;
> >>       virtio_virtqueue_reset_region_cache(&vdev->vq[i]);
> >>   }
> >>
> >> @@ -2334,6 +2350,8 @@ VirtQueue *virtio_add_queue(VirtIODevice *vdev, =
int queue_size,
> >>       vdev->vq[i].vring.align =3D VIRTIO_PCI_VRING_ALIGN;
> >>       vdev->vq[i].handle_output =3D handle_output;
> >>       vdev->vq[i].used_elems =3D g_new0(VirtQueueElement, queue_size);
> >> +    vdev->vq[i].used_seq_idx =3D 0;
> >> +    vdev->vq[i].current_seq_idx =3D 0;
> >>
> >>       return &vdev->vq[i];
> >>   }
> >> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> >> index b3c74a1bca..910b2a3427 100644
> >> --- a/include/hw/virtio/virtio.h
> >> +++ b/include/hw/virtio/virtio.h
> >> @@ -75,6 +75,7 @@ typedef struct VirtQueueElement
> >>       hwaddr *out_addr;
> >>       struct iovec *in_sg;
> >>       struct iovec *out_sg;
> >> +    uint16_t seq_idx;
> >>   } VirtQueueElement;
> >>
> >>   #define VIRTIO_QUEUE_MAX 1024
> >> --
> >> 2.39.3
> >>
> >
>

