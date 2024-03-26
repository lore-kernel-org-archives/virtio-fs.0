Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03BF84FDA
	for <virtio-fs@lists.linux.dev>; Tue, 26 Mar 2024 18:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711478104; cv=none; b=JtgsbZwzsuEcL/Nz6z/hPO+7CREjuP4hD/anTa89Tc6j5z5/t9XkIEjJupY1JdQraixW6YtDhLy/Buo95lPWn7MGxZcQdpPHfHtY25TJwP944K1nHQqImT22qWqfnVBRZJ1/wzE1no5f5svxiwAnoGIfSLNW0Misu0aOgGlRqVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711478104; c=relaxed/simple;
	bh=VAiwbK4d8rxqjIpM14DcOLqYxBKUkDZnjTSvaClOkcc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TwY8eFdTVehNj2Celk6K1oybBHR5mDCtWi0pkGrAoaD5hQyqyiWI5Cgm2roeQWNbQCAHLOAMbLwShpuaH6DQuhIOXyb1CX9JNf9jd8CkEdZ+k41HbdSihiG3xvZOT2Z0JVc3A2X7Ji3Bq2wlhaGgGYPVbD1rhvzvrgbd5DrDp08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XceOmfHw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XceOmfHw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711478101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BeSS/LogriZZgAw8uFQQ2VhJw4xwK+MsVAvD+ATqdNU=;
	b=XceOmfHwbMvcE+Rbz5zxzh0Qq83qlaZI46GyLEwVFeFGKvTzrWKhgYZsMQ8eTlqpJ+9QP0
	6S3SijHIwosNbBa8Eut9rnB3fwHUJgPLQBFWTrwyQim5Xb3rsGhF7daKS4RD556OID0zJ/
	P8ddfbMQ0vcaN9hLpGJH6PO5HJg7Rhk=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-sKe57eycN1man64TQGr2WQ-1; Tue, 26 Mar 2024 14:35:00 -0400
X-MC-Unique: sKe57eycN1man64TQGr2WQ-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-610b96c8ca2so93878067b3.2
        for <virtio-fs@lists.linux.dev>; Tue, 26 Mar 2024 11:35:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711478099; x=1712082899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BeSS/LogriZZgAw8uFQQ2VhJw4xwK+MsVAvD+ATqdNU=;
        b=jMHh830bne+d1uagaS6B9YRky0wEOniuO7wsKUmmkBlDt95IkEpSKl/Ul2fsw6mdvu
         XscktD6H7ieLPo5UZTN4UC7lVIJ66Spz8ipfLaQE/5J5/AotUI33G5HUaE4pgqp+uFue
         h4+pU6fNgHJ2Zq6TWq2ZtTl1OLX3D/5DmeZDffqM/pGRYvwqVYyFhy8mOy/EnycsT04j
         MveRCSk48COpIznEeI4iUmWcERoD3X46njpRyQGcrn9QGVoEA4Xeo1wwqCAZWCIPKPys
         HWqSNqDFEbJ2XMZnU83ycXkIJ6XeYYblIqJVE4DwuM4tdjHgIpciq8ZIUqbXH2WvmmPT
         NGMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkp3qqZ0Qlhy9RtrAzf8o9ipwkKHYWu6BZf+xx86W4M7JsGY5kmf9m9IGReLlw5tuERgXd68+XBebszmTV5b8P+wLNgEWnmXAX
X-Gm-Message-State: AOJu0Yzpja3T82o8msxvQPQvfEkTD4YRlYymoRfY+/79DVL7wp6krjf9
	rYFSj77FhOtf/p3VSVFJg/+Bm1tK6xX46CWtqVHgJMVsVlnoU4oM05vxZJeacEXwU9czDuUvLb/
	8F2Iqemns+5TSXv/Yk+RCmjAPU/R8+mfAbmkjN6GAnAPNGIXiNkvNHrvc7sj9o1SGMK29bjgJRG
	yQEU495liyTiKCgimrd3UkWXyEnzX+dLrF
X-Received: by 2002:a25:3002:0:b0:dcc:6d85:586a with SMTP id w2-20020a253002000000b00dcc6d85586amr536318ybw.49.1711478099420;
        Tue, 26 Mar 2024 11:34:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJbaxh77aZdTKEgpqx/W8Q/xOjOHGMOTMnbdWa/JN9uMD0UjmpNnL6LbrQQDWsXRFJ9zEgRiDGaw65IuyEcYg=
X-Received: by 2002:a25:3002:0:b0:dcc:6d85:586a with SMTP id
 w2-20020a253002000000b00dcc6d85586amr536298ybw.49.1711478099043; Tue, 26 Mar
 2024 11:34:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240321155717.1392787-1-jonah.palmer@oracle.com>
 <CAJaqyWf-oS_Y7EgO7DrVxMj5Roe=yjbbU3tka=Yj3St1ALCvnw@mail.gmail.com>
 <5b8494df-c15c-4d18-ad4a-74b5584429ce@oracle.com> <CAJaqyWesW0w=X-okVFAt9Fpy+PybVgq6XSAh=gaej1ozQR+3wg@mail.gmail.com>
 <d435919b-ec5e-41d5-8bbc-354d027f67d0@oracle.com>
In-Reply-To: <d435919b-ec5e-41d5-8bbc-354d027f67d0@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 26 Mar 2024 19:34:22 +0100
Message-ID: <CAJaqyWcHokNf97uwE0=S56CK9cBpB54sF8cdW7+BhFc5VzBRUQ@mail.gmail.com>
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

On Tue, Mar 26, 2024 at 5:49=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
>
>
> On 3/25/24 4:33 PM, Eugenio Perez Martin wrote:
> > On Mon, Mar 25, 2024 at 5:52=E2=80=AFPM Jonah Palmer <jonah.palmer@orac=
le.com> wrote:
> >>
> >>
> >>
> >> On 3/22/24 7:18 AM, Eugenio Perez Martin wrote:
> >>> On Thu, Mar 21, 2024 at 4:57=E2=80=AFPM Jonah Palmer <jonah.palmer@or=
acle.com> wrote:
> >>>>
> >>>> The goal of these patches is to add support to a variety of virtio a=
nd
> >>>> vhost devices for the VIRTIO_F_IN_ORDER transport feature. This feat=
ure
> >>>> indicates that all buffers are used by the device in the same order =
in
> >>>> which they were made available by the driver.
> >>>>
> >>>> These patches attempt to implement a generalized, non-device-specifi=
c
> >>>> solution to support this feature.
> >>>>
> >>>> The core feature behind this solution is a buffer mechanism in the f=
orm
> >>>> of GLib's GHashTable. The decision behind using a hash table was to
> >>>> leverage their ability for quick lookup, insertion, and removal
> >>>> operations. Given that our keys are simply numbers of an ordered
> >>>> sequence, a hash table seemed like the best choice for a buffer
> >>>> mechanism.
> >>>>
> >>>> ---------------------
> >>>>
> >>>> The strategy behind this implementation is as follows:
> >>>>
> >>>> We know that buffers that are popped from the available ring and enq=
ueued
> >>>> for further processing will always done in the same order in which t=
hey
> >>>> were made available by the driver. Given this, we can note their ord=
er
> >>>> by assigning the resulting VirtQueueElement a key. This key is a num=
ber
> >>>> in a sequence that represents the order in which they were popped fr=
om
> >>>> the available ring, relative to the other VirtQueueElements.
> >>>>
> >>>> For example, given 3 "elements" that were popped from the available
> >>>> ring, we assign a key value to them which represents their order (el=
em0
> >>>> is popped first, then elem1, then lastly elem2):
> >>>>
> >>>>        elem2   --  elem1   --  elem0   ---> Enqueue for processing
> >>>>       (key: 2)    (key: 1)    (key: 0)
> >>>>
> >>>> Then these elements are enqueued for further processing by the host.
> >>>>
> >>>> While most devices will return these completed elements in the same
> >>>> order in which they were enqueued, some devices may not (e.g.
> >>>> virtio-blk). To guarantee that these elements are put on the used ri=
ng
> >>>> in the same order in which they were enqueued, we can use a bufferin=
g
> >>>> mechanism that keeps track of the next expected sequence number of a=
n
> >>>> element.
> >>>>
> >>>> In other words, if the completed element does not have a key value t=
hat
> >>>> matches the next expected sequence number, then we know this element=
 is
> >>>> not in-order and we must stash it away in a hash table until an orde=
r
> >>>> can be made. The element's key value is used as the key for placing =
it
> >>>> in the hash table.
> >>>>
> >>>> If the completed element has a key value that matches the next expec=
ted
> >>>> sequence number, then we know this element is in-order and we can pu=
sh
> >>>> it on the used ring. Then we increment the next expected sequence nu=
mber
> >>>> and check if the hash table contains an element at this key location=
.
> >>>>
> >>>> If so, we retrieve this element, push it to the used ring, delete th=
e
> >>>> key-value pair from the hash table, increment the next expected sequ=
ence
> >>>> number, and check the hash table again for an element at this new ke=
y
> >>>> location. This process is repeated until we're unable to find an ele=
ment
> >>>> in the hash table to continue the order.
> >>>>
> >>>> So, for example, say the 3 elements we enqueued were completed in th=
e
> >>>> following order: elem1, elem2, elem0. The next expected sequence num=
ber
> >>>> is 0:
> >>>>
> >>>>       exp-seq-num =3D 0:
> >>>>
> >>>>        elem1   --> elem1.key =3D=3D exp-seq-num ? --> No, stash it
> >>>>       (key: 1)                                         |
> >>>>                                                        |
> >>>>                                                        v
> >>>>                                                  =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>                                                  |key: 1 - elem1|
> >>>>                                                  =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>       ---------------------
> >>>>       exp-seq-num =3D 0:
> >>>>
> >>>>        elem2   --> elem2.key =3D=3D exp-seq-num ? --> No, stash it
> >>>>       (key: 2)                                         |
> >>>>                                                        |
> >>>>                                                        v
> >>>>                                                  =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>                                                  |key: 1 - elem1|
> >>>>                                                  |--------------|
> >>>>                                                  |key: 2 - elem2|
> >>>>                                                  =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>       ---------------------
> >>>>       exp-seq-num =3D 0:
> >>>>
> >>>>        elem0   --> elem0.key =3D=3D exp-seq-num ? --> Yes, push to u=
sed ring
> >>>>       (key: 0)
> >>>>
> >>>>       exp-seq-num =3D 1:
> >>>>
> >>>>       lookup(table, exp-seq-num) !=3D NULL ? --> Yes, push to used r=
ing,
> >>>>                                                remove elem from tabl=
e
> >>>>                                                        |
> >>>>                                                        v
> >>>>                                                  =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>                                                  |key: 2 - elem2|
> >>>>                                                  =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>
> >>>>       exp-seq-num =3D 2:
> >>>>
> >>>>       lookup(table, exp-seq-num) !=3D NULL ? --> Yes, push to used r=
ing,
> >>>>                                                remove elem from tabl=
e
> >>>>                                                        |
> >>>>                                                        v
> >>>>                                                  =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>                                                  |   *empty*    |
> >>>>                                                  =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>
> >>>>       exp-seq-num =3D 3:
> >>>>
> >>>>       lookup(table, exp-seq-num) !=3D NULL ? --> No, done
> >>>>       ---------------------
> >>>>
> >>>
> >>> I think to use a hashtable to handle this has an important drawback:
> >>> it hurts performance on the devices that are using right in-order
> >>> because of hash calculus, to benefit devices that are using it badly
> >>> by using descriptors out of order. We should use data structs that ar=
e
> >>> as free as possible for the first, and we don't care to worse the
> >>> experience of the devices that enable in_order and they shouldn't.
> >>>
> >>
> >> Right, because if descriptors are coming in in-order, we still search
> >> the (empty) hash table.
> >>
> >> Hmm... what if we introduced a flag to see if we actually should bothe=
r
> >> searching the hash table? That way we avoid the cost of searching when
> >> we really don't need to.
> >>
> >>> So I suggest reusing vq->used_elems array vq. At each used descriptor
> >>> written in the used ring, you know the next head is elem->index +
> >>> elem->ndescs, so you can check if that element has been filled or not=
.
> >>> If used, it needs to be flushed too. If not used, just return.
> >>>
> >>> Of course virtqueue_flush also needs to take this into account.
> >>>
> >>> What do you think, does it make sense to you?
> >>>
> >>
> >> I'm having a bit of trouble understanding the suggestion here. Would y=
ou
> >> mind elaborating a bit more for me on this?
> >>
> >> For example, say elem0, elem1, and elem2 were enqueued in-order (elem0
> >> being first, elem2 last) and then elem2 finishes first, elem1 second,
> >> and elem0 third. Given that these elements finish out-of-order, how
> >> would you handle these out-of-order elements using your suggestion?
> >>
> >
> > virtqueue_fill is called first with elem2. So vq->used_elems[2 %
> > vq->num] is filled with the needed information of the descriptor:
> > index, len and ndescs. idx function parameter is ignored.
> >
> > Optionally, virtqueue_push is called. It checks if
> > vq->used_elems[vq->used_idx] is valid. valid can be elem->in_num +
> > elem->out_num > 0, and reset them on every used ring write. If it is
> > not valid, this is a no-op. Currently, it is not valid.
> >
> > Same process for elem1.
> >
> > virtqueue_fill is the same for elem0. But now virtqueue_flush gets
> > interesting, as it detects vq->used_elems[0] is used. It scans for the
> > first not-used element, and it finds it is vq->used_elems[3]. So it
> > needs to write an used elem with id =3D 2 and the corresponding length.
> >
> > Maybe it is interesting to implement ways to improve the look for the
> > last used descriptor, but if any I'd go for a bitmap and always on top
> > of the basis series.
> >
> > The algorithm has not been tested, so maybe I've missed something.
> >
> > Thanks!
> >
>
> Thank you for taking the time to clarify for this for me, I appreciate it=
.
>
> I spent some time yesterday and this morning working this over in my
> head. I believe I understand what you're trying to do here and it makes
> more sense than employing a data structure like a hash table for this
> kind of job. However, I have a few questions regarding this implementatio=
n.
>
> So, one question is on the reuse of the VirtQueue's used_elems array.
> Wont reusing this array cause issues with packed VQ operations, since it
> also uses this array? If we want to stick with using this array
> specifically, perhaps we may need to rewrite its logic if the device has
> negotiated the in_order feature? E.g.
>
> virtqueue_packed_flush (...) {
>     if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER) {
>        // new logic
>     } else {
>       // current logic
>     }
> }
> -----------
>

That's right.

> Regarding this paragraph:
>
> "virtqueue_fill is called first with elem2. So vq->used_elems[2 %
> vq->num] is filled with the needed information of the descriptor:
> index, len and ndescs. idx function parameter is ignored."
>
> This looks exactly like virtqueue_packed_fill except for the idx
> parameter we'd pass in (sequence_num % vq->vring.num).
>
> In any case, regardless of whether this element being passed in is
> considered to be in-order or not, we still add this element to
> vq->used_elems in virtqueue_fill. Ok, got it.
>
> Then you say "Optionally, virtqueue_push is called". I assume by
> "optionally" you mean we need to know if this is a single-shot operation
> or a batched operation. A single-shot operation would call for
> virtqueue_push whereas a batched operation would just use
> virtqueue_fill. If this is what you meant by that then ok, I understand
> that too.
>

Totally correct.

> However, I think before we start considering whether or not we need to
> call virtqueue_push or continue with virtqueue_fill, we first should
> know whether or not this element is in-order. And I think to do that we
> should use the check you mentioned:
>
> if (vq->used_elems[vq->used_idx].in_num +
> vq->used_elems[vq->used_idx].out_num > 0)
>
> or perhaps:
>
> if (vq->used_elems[vq->used_idx] !=3D NULL)
>
> If the element is found not to be in-order, I assume we return and we
> are done with the handling of this element for now.
>
> Now my confusion with this part comes from calling virtqueue_push inside
> of the virtqueue_fill function. Wouldn't calling virtqueue_push inside
> of virtqueue_fill present some kind of recursive execution path? Unless
> I'm missing something here, this probably isn't something we need to do,
> right?

Maybe I explained something wrong, but virtqueue_fill should not call
virtqueue_push. It's up to the caller (virtio-net, virtio-blk, etc) to
call one or another. Can you elaborate?

> -----------
>
> Lastly, when execution reaches virtqueue_flush, what would define an
> element as unused? Perhaps...
>
> if (vq->used_elems[i] =3D=3D NULL)
>

used_elems is not an array of pointers but an array of
VirtQueueElement so we cannot do this way.

> or
>
> if (vq->used_elems[i].in_num + vq->used_elems[i].out_num > 0)
>

Right, I propose to reset both in_num =3D out_num =3D 0.

Thanks!

> Thanks Eugenio!
>
> >> Thanks :)
> >>
> >>> Thanks!
> >>>
> >>>
> >>>> Jonah Palmer (8):
> >>>>     virtio: Define InOrderVQElement
> >>>>     virtio: Create/destroy/reset VirtQueue In-Order hash table
> >>>>     virtio: Define order variables
> >>>>     virtio: Implement in-order handling for virtio devices
> >>>>     virtio-net: in-order handling
> >>>>     vhost-svq: in-order handling
> >>>>     vhost/vhost-user: Add VIRTIO_F_IN_ORDER to vhost feature bits
> >>>>     virtio: Add VIRTIO_F_IN_ORDER property definition
> >>>>
> >>>>    hw/block/vhost-user-blk.c          |   1 +
> >>>>    hw/net/vhost_net.c                 |   2 +
> >>>>    hw/net/virtio-net.c                |   6 +-
> >>>>    hw/scsi/vhost-scsi.c               |   1 +
> >>>>    hw/scsi/vhost-user-scsi.c          |   1 +
> >>>>    hw/virtio/vhost-shadow-virtqueue.c |  15 ++++-
> >>>>    hw/virtio/vhost-user-fs.c          |   1 +
> >>>>    hw/virtio/vhost-user-vsock.c       |   1 +
> >>>>    hw/virtio/virtio.c                 | 103 ++++++++++++++++++++++++=
++++-
> >>>>    include/hw/virtio/virtio.h         |  20 +++++-
> >>>>    net/vhost-vdpa.c                   |   1 +
> >>>>    11 files changed, 145 insertions(+), 7 deletions(-)
> >>>>
> >>>> --
> >>>> 2.39.3
> >>>>
> >>>
> >>
> >
>

