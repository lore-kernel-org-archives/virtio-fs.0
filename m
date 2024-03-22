Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899BE3EA71
	for <virtio-fs@lists.linux.dev>; Fri, 22 Mar 2024 11:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711106363; cv=none; b=N9wQtvBTcg3kx7Jplb6pE2FSgFNeGGuTwnj3e4+ff4cP3G98xI38F1o7aj88lS3AHCRu3VkncIiX1mBV1NS1LSEG2qhznGHk4M7xrXiHb5dFSo8LRo2xHbFgPT2zwHKVohJpBuzHfEzUbhSyoDSY6UpnLZXLJoCbsMiFM3ucng0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711106363; c=relaxed/simple;
	bh=vmvB/qJBic1UYTDbHZIOnFF/DUVUjfT8v1+dhlTjKkg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IjzzUjG2pj3S95kj2KAjhAz4yMo2rFWRzFhnl9du7xRfXwezJn1KjxkBGbBtzW/UydLJE5IH1quC0KxBKPWbNRjbO2f34T/hO683m8fU5JVNOtt7ow0cTR5jkGlg+7BmPcQ4xZYUIVnQ9lq3+9FF97PTSZYpl4Bh6Y8VW5LX1gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ry7O1CZD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ry7O1CZD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711106360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2NPRkQs9P20xfCEmvDDjRK8efgav0YfluddXA9YKjd0=;
	b=Ry7O1CZDy7rjIslmW2yhEzdJxBD7sykLwI72H9glAy8gUyvpIYVBUdfes969l0zE2r8/T7
	e9U3vgdra3AKmdOm/1cz4aoaCemGt1jQBuSBC6kcK5kBBiWWEvR+rWQ0EjFmtrWD/AnsDx
	2vRzi5BNr8H0VkzzAgL53pLSRTNHKfc=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-agqvMY6wMKSx6UX4IWbvjQ-1; Fri, 22 Mar 2024 07:19:18 -0400
X-MC-Unique: agqvMY6wMKSx6UX4IWbvjQ-1
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-dc3645a6790so3267347276.0
        for <virtio-fs@lists.linux.dev>; Fri, 22 Mar 2024 04:19:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711106358; x=1711711158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2NPRkQs9P20xfCEmvDDjRK8efgav0YfluddXA9YKjd0=;
        b=F88szc9vgRE/h9OxCR14EWimJbiG3mswtuwJQZ5UMBqCEJpe6N3oPv0Ec/ifQ3CbWt
         g3DbIlS8CYx8RJokMo666t37VavChUwZg1SUZSgmD4eEVLN2hU4NDQ8z3nYvR0MvfbNn
         /JJ8fqrWvaq7dmEoSY/zSuZpCYPjzupyOjANRg1Tux9DIebXebgRbZ52zPe21FPFLgoW
         tp3SDdf+nP05LjUWQuYeBYr0OVYR9AdGo4SGOKTBFl2uLcRJhhzYR9mTtNZmmnrFTtyU
         saPTDi69gSutN9e5IWSkeMurJolx3HWUW6zqTNe3I4OWTUngBzBt44XAeVAFxPmNEWhh
         D5uA==
X-Forwarded-Encrypted: i=1; AJvYcCV/e7Maz15Ut9fh95L/8Ob8ZaT656yR1r5e4BFCoFk313EFbp15BE1PSIO+/tEAlXewgqdRk3bknFM4acYlCsZSJGGe3VPA/aVF
X-Gm-Message-State: AOJu0YyZvkDEIGB6N1vishsPzmgcvWFjcKg0FdabJv1wYiWXNf00j3TJ
	Ls2tmC3gWT4nkyPuAe+6ilEfFBGDLYRmdDC6mKw6JzOO7D+plYDcmeP8gLP/prj1K56gM2i9URP
	rY00EquZ1B4x21Nov0yiwgaxYUl5QzZ3I5smoBwiszxpkIODsZZt0wtkTNc+BPrmtri2HcnF5CO
	clzfW9aYEKbSNV+dQa++5kgzQqX0Z+qror
X-Received: by 2002:a25:ef12:0:b0:dc7:5018:4022 with SMTP id g18-20020a25ef12000000b00dc750184022mr1865839ybd.44.1711106358096;
        Fri, 22 Mar 2024 04:19:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRzZ+/ts7hQaW+mk7dMf4N/NkJb62jnsp8qLzYXE3arEAofDVT4M+SEDYtvfXn3kMKEcG6A0HSNN9iRHqQPGw=
X-Received: by 2002:a25:ef12:0:b0:dc7:5018:4022 with SMTP id
 g18-20020a25ef12000000b00dc750184022mr1865814ybd.44.1711106357812; Fri, 22
 Mar 2024 04:19:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240321155717.1392787-1-jonah.palmer@oracle.com>
In-Reply-To: <20240321155717.1392787-1-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 22 Mar 2024 12:18:41 +0100
Message-ID: <CAJaqyWf-oS_Y7EgO7DrVxMj5Roe=yjbbU3tka=Yj3St1ALCvnw@mail.gmail.com>
Subject: Re: [RFC 0/8] virtio,vhost: Add VIRTIO_F_IN_ORDER support
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

On Thu, Mar 21, 2024 at 4:57=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
> The goal of these patches is to add support to a variety of virtio and
> vhost devices for the VIRTIO_F_IN_ORDER transport feature. This feature
> indicates that all buffers are used by the device in the same order in
> which they were made available by the driver.
>
> These patches attempt to implement a generalized, non-device-specific
> solution to support this feature.
>
> The core feature behind this solution is a buffer mechanism in the form
> of GLib's GHashTable. The decision behind using a hash table was to
> leverage their ability for quick lookup, insertion, and removal
> operations. Given that our keys are simply numbers of an ordered
> sequence, a hash table seemed like the best choice for a buffer
> mechanism.
>
> ---------------------
>
> The strategy behind this implementation is as follows:
>
> We know that buffers that are popped from the available ring and enqueued
> for further processing will always done in the same order in which they
> were made available by the driver. Given this, we can note their order
> by assigning the resulting VirtQueueElement a key. This key is a number
> in a sequence that represents the order in which they were popped from
> the available ring, relative to the other VirtQueueElements.
>
> For example, given 3 "elements" that were popped from the available
> ring, we assign a key value to them which represents their order (elem0
> is popped first, then elem1, then lastly elem2):
>
>      elem2   --  elem1   --  elem0   ---> Enqueue for processing
>     (key: 2)    (key: 1)    (key: 0)
>
> Then these elements are enqueued for further processing by the host.
>
> While most devices will return these completed elements in the same
> order in which they were enqueued, some devices may not (e.g.
> virtio-blk). To guarantee that these elements are put on the used ring
> in the same order in which they were enqueued, we can use a buffering
> mechanism that keeps track of the next expected sequence number of an
> element.
>
> In other words, if the completed element does not have a key value that
> matches the next expected sequence number, then we know this element is
> not in-order and we must stash it away in a hash table until an order
> can be made. The element's key value is used as the key for placing it
> in the hash table.
>
> If the completed element has a key value that matches the next expected
> sequence number, then we know this element is in-order and we can push
> it on the used ring. Then we increment the next expected sequence number
> and check if the hash table contains an element at this key location.
>
> If so, we retrieve this element, push it to the used ring, delete the
> key-value pair from the hash table, increment the next expected sequence
> number, and check the hash table again for an element at this new key
> location. This process is repeated until we're unable to find an element
> in the hash table to continue the order.
>
> So, for example, say the 3 elements we enqueued were completed in the
> following order: elem1, elem2, elem0. The next expected sequence number
> is 0:
>
>     exp-seq-num =3D 0:
>
>      elem1   --> elem1.key =3D=3D exp-seq-num ? --> No, stash it
>     (key: 1)                                         |
>                                                      |
>                                                      v
>                                                =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>                                                |key: 1 - elem1|
>                                                =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>     ---------------------
>     exp-seq-num =3D 0:
>
>      elem2   --> elem2.key =3D=3D exp-seq-num ? --> No, stash it
>     (key: 2)                                         |
>                                                      |
>                                                      v
>                                                =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>                                                |key: 1 - elem1|
>                                                |--------------|
>                                                |key: 2 - elem2|
>                                                =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>     ---------------------
>     exp-seq-num =3D 0:
>
>      elem0   --> elem0.key =3D=3D exp-seq-num ? --> Yes, push to used rin=
g
>     (key: 0)
>
>     exp-seq-num =3D 1:
>
>     lookup(table, exp-seq-num) !=3D NULL ? --> Yes, push to used ring,
>                                              remove elem from table
>                                                      |
>                                                      v
>                                                =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>                                                |key: 2 - elem2|
>                                                =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>
>     exp-seq-num =3D 2:
>
>     lookup(table, exp-seq-num) !=3D NULL ? --> Yes, push to used ring,
>                                              remove elem from table
>                                                      |
>                                                      v
>                                                =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>                                                |   *empty*    |
>                                                =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>
>     exp-seq-num =3D 3:
>
>     lookup(table, exp-seq-num) !=3D NULL ? --> No, done
>     ---------------------
>

I think to use a hashtable to handle this has an important drawback:
it hurts performance on the devices that are using right in-order
because of hash calculus, to benefit devices that are using it badly
by using descriptors out of order. We should use data structs that are
as free as possible for the first, and we don't care to worse the
experience of the devices that enable in_order and they shouldn't.

So I suggest reusing vq->used_elems array vq. At each used descriptor
written in the used ring, you know the next head is elem->index +
elem->ndescs, so you can check if that element has been filled or not.
If used, it needs to be flushed too. If not used, just return.

Of course virtqueue_flush also needs to take this into account.

What do you think, does it make sense to you?

Thanks!


> Jonah Palmer (8):
>   virtio: Define InOrderVQElement
>   virtio: Create/destroy/reset VirtQueue In-Order hash table
>   virtio: Define order variables
>   virtio: Implement in-order handling for virtio devices
>   virtio-net: in-order handling
>   vhost-svq: in-order handling
>   vhost/vhost-user: Add VIRTIO_F_IN_ORDER to vhost feature bits
>   virtio: Add VIRTIO_F_IN_ORDER property definition
>
>  hw/block/vhost-user-blk.c          |   1 +
>  hw/net/vhost_net.c                 |   2 +
>  hw/net/virtio-net.c                |   6 +-
>  hw/scsi/vhost-scsi.c               |   1 +
>  hw/scsi/vhost-user-scsi.c          |   1 +
>  hw/virtio/vhost-shadow-virtqueue.c |  15 ++++-
>  hw/virtio/vhost-user-fs.c          |   1 +
>  hw/virtio/vhost-user-vsock.c       |   1 +
>  hw/virtio/virtio.c                 | 103 ++++++++++++++++++++++++++++-
>  include/hw/virtio/virtio.h         |  20 +++++-
>  net/vhost-vdpa.c                   |   1 +
>  11 files changed, 145 insertions(+), 7 deletions(-)
>
> --
> 2.39.3
>

