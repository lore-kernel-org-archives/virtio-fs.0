Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F169812E47
	for <virtio-fs@lists.linux.dev>; Mon, 25 Mar 2024 19:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711393997; cv=none; b=jXCEykKfWdugp2RpK840sv2opGeg7/muZtEeKbUfGva+Mx9jIkbmJr2z6KAZB16VXw3CB2HB0K6gIU/lgFQrDDKFZlD7A32wMt9DIRyPu2URoc7S+yr09yoMQY8ISTcXoE0uLMQUuCxzL4TIZl/7khg95a5GB9+VQs7Wa1HvFOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711393997; c=relaxed/simple;
	bh=ITPYdHXWkx9+mSHvRhd2UilXvoVp8UgQ6eXqMeryNw0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C+dZmsPgm/pBY6WXbYGakqJWNQZG7BirxnniCK1S1RQ3JM8M7t2gxBQGNB1vAXEDsGnr2JWwIF9iP7a0+9Gc3Co93TQsK6kxYsMifLoTAQ/QCao6yfsMF886CK2xkjsvEI46ThUyormSPJzVrlDNEEwTVbmt8t9nfR712LyMjFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gc7LsMPL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gc7LsMPL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711393994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z0oaGtLwvaJUP5Gd1Zr0Uu7Z4hDcKfa0UJ+Nmhxot/I=;
	b=Gc7LsMPLya8AKhYACS1UKjOmY2572Iy2cDuvjIaues5wVqwRtbOICXg2YaXWWnLqnBQgBQ
	HvYteupoCtUjkrVbvG+HlXGfUddfGVLGTtsC/lKqk8CgMyiEXz1DltXC0vvS+ID/+gOrxH
	un3tqhPuBMoFRAugtfgcBFcrUmXlqcE=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-sm69h04WOTGzdUgoQ9P9zg-1; Mon, 25 Mar 2024 15:13:13 -0400
X-MC-Unique: sm69h04WOTGzdUgoQ9P9zg-1
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-dce775fa8adso8807900276.1
        for <virtio-fs@lists.linux.dev>; Mon, 25 Mar 2024 12:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711393993; x=1711998793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z0oaGtLwvaJUP5Gd1Zr0Uu7Z4hDcKfa0UJ+Nmhxot/I=;
        b=wzD15KX+H+rc4MWAYgdUSkpJ4Irh54F1aiNPZvNqqv84fepFNpoP+LYkftfpspCwfk
         RuhJNMEcuH15vgF9HT5wmDq4MZ100nf5ZzGCkC6sOP/v+216uZX7HB9BWJCCBdlHzRYL
         35m/KhWGZO3D7Xn2xJTTMilvBko+Qi9lU5ImHDpeZg8xzUt0iX8qdtWFxDJCk1UdODSW
         P07OCv7+ROferFcXWM+/4RzablH+T+vUkn70vAjTsmWDANX9LMm14+GPqdMAGgQzLTR9
         p6N0iA5yYicpYaZWeEprhrVXhukxAxfxZiydUTOm3UX+huSlkbOIBWTID+bPVvsp7E+5
         bJ8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWUyxsMEHphRjhKJR17oiBkiKbAC9/8aGQ17Ch9M1G/K9A1pv+s5c4PdJW16AFJkwDEpmwoRues41rcqhWtLXZMc8yKUiefCyV2
X-Gm-Message-State: AOJu0YwRkHyROsqJjp0IZgLoAHiFewtEa6wed+/zkd5B9yoi5ex8SM4q
	tPQTTL/oizJKufsRkw2Z/WII6fy0uxscRyDosKwxljyvnt0F+xmROqr3nLyZsr0Qcrl5FbY4QJN
	i0A5M3Bpo84V3bOW7PNbFmNGXpHxoZLRrdO3UvvUIMTpJfnxaHe6b4jX/Gqv5Nr4Fan90krCiQU
	UhXYkdyjTyVO84XuW3Uj3Kj3EUa2E9LnHr
X-Received: by 2002:a25:6ad6:0:b0:dcf:47b6:9155 with SMTP id f205-20020a256ad6000000b00dcf47b69155mr6008324ybc.54.1711393993120;
        Mon, 25 Mar 2024 12:13:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETgZqBtBhy4Cd6CP83C5BPHY+YtY9JiKvjBUSGVHCeY1ElaYJ436hT2pe8t461kBaFxUkuZruaWRfd30yCNw0=
X-Received: by 2002:a25:6ad6:0:b0:dcf:47b6:9155 with SMTP id
 f205-20020a256ad6000000b00dcf47b69155mr6008302ybc.54.1711393992762; Mon, 25
 Mar 2024 12:13:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240321155717.1392787-1-jonah.palmer@oracle.com>
 <20240321155717.1392787-2-jonah.palmer@oracle.com> <CAJaqyWdg5tg1XR43bHkMRnqvkTZVvrqXMKM__YD6t-xGBOXdYg@mail.gmail.com>
 <205047df-d581-4eb3-9a63-73b7f1754d01@oracle.com>
In-Reply-To: <205047df-d581-4eb3-9a63-73b7f1754d01@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 25 Mar 2024 20:12:36 +0100
Message-ID: <CAJaqyWcWQ6ZK7g8OT9uFXCYNuByw6hY7utUX_fPx=2dL+G7FNQ@mail.gmail.com>
Subject: Re: [RFC 1/8] virtio: Define InOrderVQElement
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

On Mon, Mar 25, 2024 at 6:08=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
>
>
> On 3/22/24 5:45 AM, Eugenio Perez Martin wrote:
> > On Thu, Mar 21, 2024 at 4:57=E2=80=AFPM Jonah Palmer <jonah.palmer@orac=
le.com> wrote:
> >>
> >> Define the InOrderVQElement structure for the VIRTIO_F_IN_ORDER
> >> transport feature implementation.
> >>
> >> The InOrderVQElement structure is used to encapsulate out-of-order
> >> VirtQueueElement data that was processed by the host. This data
> >> includes:
> >>   - The processed VirtQueueElement (elem)
> >>   - Length of data (len)
> >>   - VirtQueueElement array index (idx)
> >>   - Number of processed VirtQueueElements (count)
> >>
> >> InOrderVQElements will be stored in a buffering mechanism until an
> >> order can be achieved.
> >>
> >> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> >> ---
> >>   include/hw/virtio/virtio.h | 7 +++++++
> >>   1 file changed, 7 insertions(+)
> >>
> >> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> >> index b3c74a1bca..c8aa435a5e 100644
> >> --- a/include/hw/virtio/virtio.h
> >> +++ b/include/hw/virtio/virtio.h
> >> @@ -77,6 +77,13 @@ typedef struct VirtQueueElement
> >>       struct iovec *out_sg;
> >>   } VirtQueueElement;
> >>
> >> +typedef struct InOrderVQElement {
> >> +    const VirtQueueElement *elem;
> >
> > Some subsystems allocate space for extra elements after
> > VirtQueueElement, like VirtIOBlockReq. You can request virtqueue_pop
> > to allocate this extra space by its second argument. Would it work for
> > this?
> >
>
> I don't see why not. Although this may not be necessary due to me
> missing a key aspect mentioned in your comment below.
>
> >> +    unsigned int len;
> >> +    unsigned int idx;
> >> +    unsigned int count;
> >
> > Now I don't get why these fields cannot be obtained from elem->(len,
> > index, ndescs) ?
> >
>
> Interesting. I didn't realize that these values are equivalent to a
> VirtQueueElement's len, index, and ndescs fields.
>
> Is this always true? Else I would've expected, for example,
> virtqueue_push to not need the 'unsigned int len' parameter if this
> information is already included via. the VirtQueueElement being passed in=
.
>

The code uses "len" to store the written length values of each used
descriptor between virtqueue_fill and virtqueue_flush. But not all
devices use these separately, only the ones that batches: virtio-net
and SVQ.

A smarter / less simpler implementation of virtqueue_push could
certainly avoid storing elem->len. But the performance gain is
probably tiny, and the code complexity grows.

> >> +} InOrderVQElement;
> >> +
> >>   #define VIRTIO_QUEUE_MAX 1024
> >>
> >>   #define VIRTIO_NO_VECTOR 0xffff
> >> --
> >> 2.39.3
> >>
> >
>

