Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836093F8D4
	for <virtio-fs@lists.linux.dev>; Mon, 25 Mar 2024 20:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711398850; cv=none; b=bCh2z8f4IiH5Ef/9nZTsOhTOGDjrqf+fkzuY6yQgdZrC4by3G1Dwjz+VgH9ck0XiH22Gjx5qFxnJy6bIdeRdW6mTeKG/zowXPKen/qixQteu7OCr8F44GHmKSftToLcnJNcV+olfBBFZSn82Zs86/yAj9DeRYEPPn0cNFoIDhFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711398850; c=relaxed/simple;
	bh=wNi3tXS1EnWqAlD40AI9IuOGj8jys/pRaZbG9spLRJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WKiAlqKHNMEkdH+q0GqvWarrFdQqrvlDDg5/WC5vLViszI3GPSM5bb2FmBmGbyueefGlWCuQ29SCOMKp31HjTc3oO3l8X7mXqyRMlSzb63j+TLvqzPDOzM6M1U1OGo0zi6PP+B3Irgguu4G/3HQWV5itvxkuQZkspxwQHrwrozU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MUVspfgx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MUVspfgx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711398847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5tzuFPaHvsZc25QPW/SL91F0zTlppGECPFJlKiJ6cdM=;
	b=MUVspfgxKiMx3Bz9pnuZelnCcVBkIAWmswi3OrxJMICzqlwzJV6TKQYQm7kQ6ixod2EgRw
	VraqELjxmJgobO13Jgx+kSnXi5hHMGyTN8VrKG+jNL4zKHJmzpD7lhuE8NqRCTtsZ0bhxl
	z9cXI0TgZV3fH7SN9HcWKKVGAOGa96k=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-oSnVYATtOHmARF2EiwcrNA-1; Mon, 25 Mar 2024 16:34:04 -0400
X-MC-Unique: oSnVYATtOHmARF2EiwcrNA-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-609fe93b5cfso71360347b3.0
        for <virtio-fs@lists.linux.dev>; Mon, 25 Mar 2024 13:34:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711398843; x=1712003643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5tzuFPaHvsZc25QPW/SL91F0zTlppGECPFJlKiJ6cdM=;
        b=eomJfhmgwJRkWkwp7uYWCg5gpkHRC0tkTZWGC2wrv6d/yEkCpfiszRapkkzEMTRQRx
         5XpW9FQxxZ9yt/rkBAIHz77TaH14dB4uqr+BjiOlMki+JVneRHi/0rZfRYfjo0z6ASvN
         xfw0DB7aDMLCBsp1p+5o5la83MoZb/DN+xMYpEncWk8MAR21MG4CbOA3kXx2dySy8Okm
         4A7vvedUyBJnaN5lMFgI2Y+tIMw0Hq2uSvnrOrWgYatjR1Q6VzHVDB//NgidiltIwETK
         goZbYuchwRniUQ9H5xhICZBTO+ofFXpJx7OiEjylEfdJS6MDNIDG3hwz5TK3AYnykZMd
         SCrw==
X-Forwarded-Encrypted: i=1; AJvYcCUyOgjAZICJ/Dk0yYOaP+mSNjE2U5r5/l7AXeg28x99k2P6ir8bF2l4kFHWAlAfs7idkbKT2R7XGsD9HkcushwZyf4BusXX60Yv
X-Gm-Message-State: AOJu0YzHKJcwwpKi6zmiaT5Iw7lKGyr9uMTynorSh74MmYwTtWN7VZFK
	xIeCygkxeRBx5bxgDd3lcu6ondvvTi8vjHiXkQcKNTfCWKj52LqQtU5rfXWqL/D1qNEsDvbBfxb
	r4y7Urp23BbJUrMfgI8dkUG1WsxEuOZLP9WPNyLvtmgLLEaiBaKrPUFQfzNwIS6JF8b7fWg0JGD
	WiS+KeZWZy/rjMSdYoDl2hlZrNIRC/Ht1B
X-Received: by 2002:a25:abc5:0:b0:dc6:9b89:3f75 with SMTP id v63-20020a25abc5000000b00dc69b893f75mr2163989ybi.40.1711398843329;
        Mon, 25 Mar 2024 13:34:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6eyCDCsYV6gJV3rqqUqYmsBorEm1W/MGpPmZLZ1JXHreAXhrB1dQN5vdXyfMEMBtJtLs4p3Sx0M6l8v/hzFI=
X-Received: by 2002:a25:abc5:0:b0:dc6:9b89:3f75 with SMTP id
 v63-20020a25abc5000000b00dc69b893f75mr2163975ybi.40.1711398843016; Mon, 25
 Mar 2024 13:34:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240321155717.1392787-1-jonah.palmer@oracle.com>
 <CAJaqyWf-oS_Y7EgO7DrVxMj5Roe=yjbbU3tka=Yj3St1ALCvnw@mail.gmail.com> <5b8494df-c15c-4d18-ad4a-74b5584429ce@oracle.com>
In-Reply-To: <5b8494df-c15c-4d18-ad4a-74b5584429ce@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 25 Mar 2024 21:33:26 +0100
Message-ID: <CAJaqyWesW0w=X-okVFAt9Fpy+PybVgq6XSAh=gaej1ozQR+3wg@mail.gmail.com>
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

On Mon, Mar 25, 2024 at 5:52=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
>
>
> On 3/22/24 7:18 AM, Eugenio Perez Martin wrote:
> > On Thu, Mar 21, 2024 at 4:57=E2=80=AFPM Jonah Palmer <jonah.palmer@orac=
le.com> wrote:
> >>
> >> The goal of these patches is to add support to a variety of virtio and
> >> vhost devices for the VIRTIO_F_IN_ORDER transport feature. This featur=
e
> >> indicates that all buffers are used by the device in the same order in
> >> which they were made available by the driver.
> >>
> >> These patches attempt to implement a generalized, non-device-specific
> >> solution to support this feature.
> >>
> >> The core feature behind this solution is a buffer mechanism in the for=
m
> >> of GLib's GHashTable. The decision behind using a hash table was to
> >> leverage their ability for quick lookup, insertion, and removal
> >> operations. Given that our keys are simply numbers of an ordered
> >> sequence, a hash table seemed like the best choice for a buffer
> >> mechanism.
> >>
> >> ---------------------
> >>
> >> The strategy behind this implementation is as follows:
> >>
> >> We know that buffers that are popped from the available ring and enque=
ued
> >> for further processing will always done in the same order in which the=
y
> >> were made available by the driver. Given this, we can note their order
> >> by assigning the resulting VirtQueueElement a key. This key is a numbe=
r
> >> in a sequence that represents the order in which they were popped from
> >> the available ring, relative to the other VirtQueueElements.
> >>
> >> For example, given 3 "elements" that were popped from the available
> >> ring, we assign a key value to them which represents their order (elem=
0
> >> is popped first, then elem1, then lastly elem2):
> >>
> >>       elem2   --  elem1   --  elem0   ---> Enqueue for processing
> >>      (key: 2)    (key: 1)    (key: 0)
> >>
> >> Then these elements are enqueued for further processing by the host.
> >>
> >> While most devices will return these completed elements in the same
> >> order in which they were enqueued, some devices may not (e.g.
> >> virtio-blk). To guarantee that these elements are put on the used ring
> >> in the same order in which they were enqueued, we can use a buffering
> >> mechanism that keeps track of the next expected sequence number of an
> >> element.
> >>
> >> In other words, if the completed element does not have a key value tha=
t
> >> matches the next expected sequence number, then we know this element i=
s
> >> not in-order and we must stash it away in a hash table until an order
> >> can be made. The element's key value is used as the key for placing it
> >> in the hash table.
> >>
> >> If the completed element has a key value that matches the next expecte=
d
> >> sequence number, then we know this element is in-order and we can push
> >> it on the used ring. Then we increment the next expected sequence numb=
er
> >> and check if the hash table contains an element at this key location.
> >>
> >> If so, we retrieve this element, push it to the used ring, delete the
> >> key-value pair from the hash table, increment the next expected sequen=
ce
> >> number, and check the hash table again for an element at this new key
> >> location. This process is repeated until we're unable to find an eleme=
nt
> >> in the hash table to continue the order.
> >>
> >> So, for example, say the 3 elements we enqueued were completed in the
> >> following order: elem1, elem2, elem0. The next expected sequence numbe=
r
> >> is 0:
> >>
> >>      exp-seq-num =3D 0:
> >>
> >>       elem1   --> elem1.key =3D=3D exp-seq-num ? --> No, stash it
> >>      (key: 1)                                         |
> >>                                                       |
> >>                                                       v
> >>                                                 =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>                                                 |key: 1 - elem1|
> >>                                                 =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>      ---------------------
> >>      exp-seq-num =3D 0:
> >>
> >>       elem2   --> elem2.key =3D=3D exp-seq-num ? --> No, stash it
> >>      (key: 2)                                         |
> >>                                                       |
> >>                                                       v
> >>                                                 =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>                                                 |key: 1 - elem1|
> >>                                                 |--------------|
> >>                                                 |key: 2 - elem2|
> >>                                                 =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>      ---------------------
> >>      exp-seq-num =3D 0:
> >>
> >>       elem0   --> elem0.key =3D=3D exp-seq-num ? --> Yes, push to used=
 ring
> >>      (key: 0)
> >>
> >>      exp-seq-num =3D 1:
> >>
> >>      lookup(table, exp-seq-num) !=3D NULL ? --> Yes, push to used ring=
,
> >>                                               remove elem from table
> >>                                                       |
> >>                                                       v
> >>                                                 =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>                                                 |key: 2 - elem2|
> >>                                                 =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >>      exp-seq-num =3D 2:
> >>
> >>      lookup(table, exp-seq-num) !=3D NULL ? --> Yes, push to used ring=
,
> >>                                               remove elem from table
> >>                                                       |
> >>                                                       v
> >>                                                 =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>                                                 |   *empty*    |
> >>                                                 =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >>      exp-seq-num =3D 3:
> >>
> >>      lookup(table, exp-seq-num) !=3D NULL ? --> No, done
> >>      ---------------------
> >>
> >
> > I think to use a hashtable to handle this has an important drawback:
> > it hurts performance on the devices that are using right in-order
> > because of hash calculus, to benefit devices that are using it badly
> > by using descriptors out of order. We should use data structs that are
> > as free as possible for the first, and we don't care to worse the
> > experience of the devices that enable in_order and they shouldn't.
> >
>
> Right, because if descriptors are coming in in-order, we still search
> the (empty) hash table.
>
> Hmm... what if we introduced a flag to see if we actually should bother
> searching the hash table? That way we avoid the cost of searching when
> we really don't need to.
>
> > So I suggest reusing vq->used_elems array vq. At each used descriptor
> > written in the used ring, you know the next head is elem->index +
> > elem->ndescs, so you can check if that element has been filled or not.
> > If used, it needs to be flushed too. If not used, just return.
> >
> > Of course virtqueue_flush also needs to take this into account.
> >
> > What do you think, does it make sense to you?
> >
>
> I'm having a bit of trouble understanding the suggestion here. Would you
> mind elaborating a bit more for me on this?
>
> For example, say elem0, elem1, and elem2 were enqueued in-order (elem0
> being first, elem2 last) and then elem2 finishes first, elem1 second,
> and elem0 third. Given that these elements finish out-of-order, how
> would you handle these out-of-order elements using your suggestion?
>

virtqueue_fill is called first with elem2. So vq->used_elems[2 %
vq->num] is filled with the needed information of the descriptor:
index, len and ndescs. idx function parameter is ignored.

Optionally, virtqueue_push is called. It checks if
vq->used_elems[vq->used_idx] is valid. valid can be elem->in_num +
elem->out_num > 0, and reset them on every used ring write. If it is
not valid, this is a no-op. Currently, it is not valid.

Same process for elem1.

virtqueue_fill is the same for elem0. But now virtqueue_flush gets
interesting, as it detects vq->used_elems[0] is used. It scans for the
first not-used element, and it finds it is vq->used_elems[3]. So it
needs to write an used elem with id =3D 2 and the corresponding length.

Maybe it is interesting to implement ways to improve the look for the
last used descriptor, but if any I'd go for a bitmap and always on top
of the basis series.

The algorithm has not been tested, so maybe I've missed something.

Thanks!

> Thanks :)
>
> > Thanks!
> >
> >
> >> Jonah Palmer (8):
> >>    virtio: Define InOrderVQElement
> >>    virtio: Create/destroy/reset VirtQueue In-Order hash table
> >>    virtio: Define order variables
> >>    virtio: Implement in-order handling for virtio devices
> >>    virtio-net: in-order handling
> >>    vhost-svq: in-order handling
> >>    vhost/vhost-user: Add VIRTIO_F_IN_ORDER to vhost feature bits
> >>    virtio: Add VIRTIO_F_IN_ORDER property definition
> >>
> >>   hw/block/vhost-user-blk.c          |   1 +
> >>   hw/net/vhost_net.c                 |   2 +
> >>   hw/net/virtio-net.c                |   6 +-
> >>   hw/scsi/vhost-scsi.c               |   1 +
> >>   hw/scsi/vhost-user-scsi.c          |   1 +
> >>   hw/virtio/vhost-shadow-virtqueue.c |  15 ++++-
> >>   hw/virtio/vhost-user-fs.c          |   1 +
> >>   hw/virtio/vhost-user-vsock.c       |   1 +
> >>   hw/virtio/virtio.c                 | 103 +++++++++++++++++++++++++++=
+-
> >>   include/hw/virtio/virtio.h         |  20 +++++-
> >>   net/vhost-vdpa.c                   |   1 +
> >>   11 files changed, 145 insertions(+), 7 deletions(-)
> >>
> >> --
> >> 2.39.3
> >>
> >
>

