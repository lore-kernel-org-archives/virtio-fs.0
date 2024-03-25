Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8170C1773A
	for <virtio-fs@lists.linux.dev>; Mon, 25 Mar 2024 19:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711395944; cv=none; b=XmHlUdWpkoO2lutMLlDPStvJnVdIpWEhgQ5fVh3ffmj9KDfzJ+Bn3nXPr//fhHQ5EPBsvb0Qkmj/NrEB0P5rKXuyHIEin2PoMtZaooPQkZ/sA5i7Y+DxCC8pi5oG+BEBRw7gLbbsj8P8ncN1cMNvDTz5H9xA/i1TxkHAQizn1WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711395944; c=relaxed/simple;
	bh=22i5ZG7pMaHTF3OlABXxhgcMfC215hnGDv0J8HS42iI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NNAConvyU2uezFVDcL6DKar7ybzo0jEYtPL9ZQkJNjCmZlAYs3kL5RBjuzf0WhaNrE7EQPZkzBu0em8Te54VsBiO5JV4VsxPMejfFGp0EsjZrJmuixOFQFoFzRtyIIB0g+nIca227hV5Rrzpl/41+M9Tcah3gDA/18XIZSc3yd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=agl4Gy0f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="agl4Gy0f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711395941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BkjbOC3e5yjGrlLycluLDv5UIRagOwuahNqZT0KUM8o=;
	b=agl4Gy0fUGSpRsLTqBQ9MpkSKMCO1hwgiszsYJpJYd89xDYAHECqYIacWRfqDzng+gpSJO
	w2T6M3WHBoKJE/0eMfQuxOfI0lnkHgFq4L/+w17UrPsJSlQGa136NoonzBqMg3+AAb8PGz
	9yPqOzcRgrXRKHtU4R7vGNXm88fncSQ=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-REBacdLJO5-hq1JSZDTnGA-1; Mon, 25 Mar 2024 15:45:39 -0400
X-MC-Unique: REBacdLJO5-hq1JSZDTnGA-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-60cd62fa1f9so74170267b3.0
        for <virtio-fs@lists.linux.dev>; Mon, 25 Mar 2024 12:45:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711395939; x=1712000739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BkjbOC3e5yjGrlLycluLDv5UIRagOwuahNqZT0KUM8o=;
        b=IbxTkc7ikklUHDbcmBl6wWndmnCq5h5ojaE2jphBTY417f8+1CDmgyXxjxIVa1SwNf
         g93w6Kl3iCRjZ4NgJ5ibE5euL5aYh2ysK5uDo7XyniDn6U6swcQOxZ5Ef2IV13LH9o3o
         vFtOHA4+tRN+8eITx7BhBkSoQVKYgIHOAAL9m2zKNNLC/s1iIYnh9uwby34bQGIlob1s
         UHKWOzfIDWTOP8zUaGXDgbAxAXIKjO7poVxtX3cYdvxi11ZZK118eDGfgblbsk7E2QjW
         Bu0KK4EK+NvPM6i1FML0BLXFwAcUrbhHa+5PKSIi9vLWpRLGucJj2P9BdxGvgVPC+N2/
         fsyA==
X-Forwarded-Encrypted: i=1; AJvYcCWXZkVyN0f/gdbT0wabyQ//WOs+y4mUz0AyRK2P5mpEHBRMYVnHZDv1d9zuXKaJZf6YWyKCDlRJNcY0Er18sHKrTCHpwAIEKKxn
X-Gm-Message-State: AOJu0YxL/VfGrY1/tRjpbAKwYRagbsE96iHkgmDaHP2i2A4WNw5uOuMf
	VeepFWR+a6BOzi/ASANbZ9v7M0GvHEwYA1HyJAbrV95w71awJVvF5Qk8Vjjp6Z39HyZaowJte6a
	kHUkC92JOO4HgtP8cMQC+5FqN7edOL+Y/k58Zfyzl0pwDLdPrPoMm4Kw0Pl1rY86W9EQfJuLfJv
	+2fK185riJHpKan7C4jjCTy9Sbc4WA40vT
X-Received: by 2002:a25:5f4d:0:b0:dcc:4cdc:e98f with SMTP id h13-20020a255f4d000000b00dcc4cdce98fmr891460ybm.34.1711395939215;
        Mon, 25 Mar 2024 12:45:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDb6+SV6io+W96mu2pR+cO1LRFTuR/i/4swc7cLmCE2ASTM48a5NwRdrWj0NOry29qbdnivFtnxIlv2ZKagZ4=
X-Received: by 2002:a25:5f4d:0:b0:dcc:4cdc:e98f with SMTP id
 h13-20020a255f4d000000b00dcc4cdce98fmr891444ybm.34.1711395938889; Mon, 25 Mar
 2024 12:45:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240321155717.1392787-1-jonah.palmer@oracle.com>
 <20240321155717.1392787-5-jonah.palmer@oracle.com> <CAJaqyWedsT+0DT-SCAH7SMFnuWHazTsbe1kNC+PENDSxvu3W0A@mail.gmail.com>
 <b12559db-fc07-4fec-92d3-0e492ae34947@oracle.com>
In-Reply-To: <b12559db-fc07-4fec-92d3-0e492ae34947@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 25 Mar 2024 20:45:02 +0100
Message-ID: <CAJaqyWczEvk20c=SOpdoOZczjaM142vAVeceADcuQeLrHi5vSw@mail.gmail.com>
Subject: Re: [RFC 4/8] virtio: Implement in-order handling for virtio devices
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

On Mon, Mar 25, 2024 at 6:35=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
>
>
> On 3/22/24 6:46 AM, Eugenio Perez Martin wrote:
> > On Thu, Mar 21, 2024 at 4:57=E2=80=AFPM Jonah Palmer <jonah.palmer@orac=
le.com> wrote:
> >>
> >> Implements in-order handling for most virtio devices using the
> >> VIRTIO_F_IN_ORDER transport feature, specifically those who call
> >> virtqueue_push to push their used elements onto the used ring.
> >>
> >> The logic behind this implementation is as follows:
> >>
> >> 1.) virtqueue_pop always enqueues VirtQueueElements in-order.
> >>
> >> virtqueue_pop always retrieves one or more buffer descriptors in-order
> >> from the available ring and converts them into a VirtQueueElement. Thi=
s
> >> means that the order in which VirtQueueElements are enqueued are
> >> in-order by default.
> >>
> >> By virtue, as VirtQueueElements are created, we can assign a sequentia=
l
> >> key value to them. This preserves the order of buffers that have been
> >> made available to the device by the driver.
> >>
> >> As VirtQueueElements are assigned a key value, the current sequence
> >> number is incremented.
> >>
> >> 2.) Requests can be completed out-of-order.
> >>
> >> While most devices complete requests in the same order that they were
> >> enqueued by default, some devices don't (e.g. virtio-blk). The goal of
> >> this out-of-order handling is to reduce the impact of devices that
> >> process elements in-order by default while also guaranteeing complianc=
e
> >> with the VIRTIO_F_IN_ORDER feature.
> >>
> >> Below is the logic behind handling completed requests (which may or ma=
y
> >> not be in-order).
> >>
> >> 3.) Does the incoming used VirtQueueElement preserve the correct order=
?
> >>
> >> In other words, is the sequence number (key) assigned to the
> >> VirtQueueElement the expected number that would preserve the original
> >> order?
> >>
> >> 3a.)
> >> If it does... immediately push the used element onto the used ring.
> >> Then increment the next expected sequence number and check to see if
> >> any previous out-of-order VirtQueueElements stored on the hash table
> >> has a key that matches this next expected sequence number.
> >>
> >> For each VirtQueueElement found on the hash table with a matching key:
> >> push the element on the used ring, remove the key-value pair from the
> >> hash table, and then increment the next expected sequence number. Repe=
at
> >> this process until we're unable to find an element with a matching key=
.
> >>
> >> Note that if the device uses batching (e.g. virtio-net), then we skip
> >> the virtqueue_flush call and let the device call it themselves.
> >>
> >> 3b.)
> >> If it does not... stash the VirtQueueElement, along with relevant data=
,
> >> as a InOrderVQElement on the hash table. The key used is the order_key
> >> that was assigned when the VirtQueueElement was created.
> >>
> >> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> >> ---
> >>   hw/virtio/virtio.c         | 70 ++++++++++++++++++++++++++++++++++++=
--
> >>   include/hw/virtio/virtio.h |  8 +++++
> >>   2 files changed, 76 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> >> index 40124545d6..40e4377f1e 100644
> >> --- a/hw/virtio/virtio.c
> >> +++ b/hw/virtio/virtio.c
> >> @@ -992,12 +992,56 @@ void virtqueue_flush(VirtQueue *vq, unsigned int=
 count)
> >>       }
> >>   }
> >>
> >> +void virtqueue_order_element(VirtQueue *vq, const VirtQueueElement *e=
lem,
> >> +                             unsigned int len, unsigned int idx,
> >> +                             unsigned int count)
> >> +{
> >> +    InOrderVQElement *in_order_elem;
> >> +
> >> +    if (elem->order_key =3D=3D vq->current_order_idx) {
> >> +        /* Element is in-order, push to used ring */
> >> +        virtqueue_fill(vq, elem, len, idx);
> >> +
> >> +        /* Batching? Don't flush */
> >> +        if (count) {
> >> +            virtqueue_flush(vq, count);
> >
> > The "count" parameter is the number of heads used, but here you're
> > only using one head (elem). Same with the other virtqueue_flush in the
> > function.
> >
>
> True. This acts more as a flag than an actual count since, unless we're
> batching (which in the current setup, the device would explicitly call
> virtqueue_flush separately), this value will be either 0 or 1.
>

If possible, I think it is better to keep consistent with the current
API: fill+flush for batching, push for a single shot.

> > Also, this function sometimes replaces virtqueue_fill and other
> > replaces virtqueue_fill + virtqueue_flush (both examples in patch
> > 6/8). I have the impression the series would be simpler if
> > virtqueue_order_element is a static function just handling the
> > virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER) path of
> > virtqueue_fill, so the caller does not need to know if the in_order
> > feature is on or off.
> >
>
> Originally I wanted this function to replace virtqueue_fill +
> virtqueue_flush but after looking at virtio_net_receive_rcu and
> vhost_svq_flush, where multiple virtqueue_fill's can be called before a
> single virtqueue_flush, I added this 'if (count)' conditional to handle
> both cases.
>
> I did consider virtqueue_order_element just handling the virtqueue_fill
> path but then I wasn't sure how to handle calling virtqueue_flush when
> retrieving out-of-order data from the hash table.
>
> For example, devices that call virtqueue_push would call virtqueue_fill
> and then virtqueue_flush afterwards. In the scenario where, say, elem1
> was found out of order and put into the hash table, and then elem0 comes
> along. For elem0 we'd call virtqueue_fill and then we should call
> virtqueue_flush to keep the order going. Then we'd find elem1 and do the
> same. I have trouble seeing how we could properly call virtqueue_flush
> after finding out-of-order elements (that are now ready to be placed on
> the used ring in-order) in the hash table.
>

I see, that's a good point indeed. The way I thought, it is a no-op in
that case, and the later virtqueue_flush needs to check if it has
pending buffers to use.

The next question is what to do with the virtqueue_fill idx and
virtqueue_flush count parameters. More on that in the cover letter, as
the discussion goes that direction there.

> >> +        }
> >> +
> >> +        /* Increment next expected order, search for more in-order el=
ements */
> >> +        while ((in_order_elem =3D g_hash_table_lookup(vq->in_order_ht=
,
> >> +                        GUINT_TO_POINTER(++vq->current_order_idx))) !=
=3D NULL) {
> >> +            /* Found in-order element, push to used ring */
> >> +            virtqueue_fill(vq, in_order_elem->elem, in_order_elem->le=
n,
> >> +                           in_order_elem->idx);
> >> +
> >> +            /* Batching? Don't flush */
> >> +            if (count) {
> >> +                virtqueue_flush(vq, in_order_elem->count);
> >> +            }
> >> +
> >> +            /* Remove key-value pair from hash table */
> >> +            g_hash_table_remove(vq->in_order_ht,
> >> +                                GUINT_TO_POINTER(vq->current_order_id=
x));
> >> +        }
> >> +    } else {
> >> +        /* Element is out-of-order, stash in hash table */
> >> +        in_order_elem =3D virtqueue_alloc_in_order_element(elem, len,=
 idx,
> >> +                                                         count);
> >> +        g_hash_table_insert(vq->in_order_ht, GUINT_TO_POINTER(elem->o=
rder_key),
> >> +                            in_order_elem);
> >> +    }
> >> +}
> >> +
> >>   void virtqueue_push(VirtQueue *vq, const VirtQueueElement *elem,
> >>                       unsigned int len)
> >>   {
> >>       RCU_READ_LOCK_GUARD();
> >> -    virtqueue_fill(vq, elem, len, 0);
> >> -    virtqueue_flush(vq, 1);
> >> +    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
> >> +        virtqueue_order_element(vq, elem, len, 0, 1);
> >> +    } else {
> >> +        virtqueue_fill(vq, elem, len, 0);
> >> +        virtqueue_flush(vq, 1);
> >> +    }
> >>   }
> >>
> >>   /* Called within rcu_read_lock().  */
> >> @@ -1478,6 +1522,18 @@ void virtqueue_map(VirtIODevice *vdev, VirtQueu=
eElement *elem)
> >>                                                                       =
    false);
> >>   }
> >>
> >> +void *virtqueue_alloc_in_order_element(const VirtQueueElement *elem,
> >> +                                       unsigned int len, unsigned int=
 idx,
> >> +                                       unsigned int count)
> >> +{
> >> +    InOrderVQElement *in_order_elem =3D g_malloc(sizeof(InOrderVQElem=
ent));
> >> +    in_order_elem->elem =3D elem;
> >> +    in_order_elem->len =3D len;
> >> +    in_order_elem->idx =3D idx;
> >> +    in_order_elem->count =3D count;
> >> +    return in_order_elem;
> >> +}
> >> +
> >>   static void *virtqueue_alloc_element(size_t sz, unsigned out_num, un=
signed in_num)
> >>   {
> >>       VirtQueueElement *elem;
> >> @@ -1626,6 +1682,11 @@ static void *virtqueue_split_pop(VirtQueue *vq,=
 size_t sz)
> >>           elem->in_sg[i] =3D iov[out_num + i];
> >>       }
> >>
> >> +    /* Assign key for in-order processing */
> >> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
> >> +        elem->order_key =3D vq->current_order_key++;
> >
> > Since you're adding this in both split_pop and packed_pop, why not add
> > it in virtqueue_pop?
> >
>
> I wanted to add this order_key to the VirtQueueElement after it was
> created. I suppose I could do this directly in virtqueue_alloc_element
> but I'd have to add another parameter to it, which might be unnecessary
> given it'd only be applicable for this specific in_order feature.
>
> I also suppose I could just capture the VirtQueueElement being returned
> from virtqueue_packed_pop/virtqueue_split_pop and make the assignment
> there, but it felt out of place to do it in virtqueue_pop.
>

I see. I keep finding it simpler to do the assignment in one point
only, as it is not a specific split / packed operation. But let's see.

Thanks!

> >> +    }
> >> +
> >>       vq->inuse++;
> >>
> >>       trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
> >> @@ -1762,6 +1823,11 @@ static void *virtqueue_packed_pop(VirtQueue *vq=
, size_t sz)
> >>           vq->last_avail_wrap_counter ^=3D 1;
> >>       }
> >>
> >> +    /* Assign key for in-order processing */
> >> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
> >> +        elem->order_key =3D vq->current_order_key++;
> >> +    }
> >> +
> >>       vq->shadow_avail_idx =3D vq->last_avail_idx;
> >>       vq->shadow_avail_wrap_counter =3D vq->last_avail_wrap_counter;
> >>
> >> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> >> index f83d7e1fee..eeeda397a9 100644
> >> --- a/include/hw/virtio/virtio.h
> >> +++ b/include/hw/virtio/virtio.h
> >> @@ -275,6 +275,14 @@ void virtio_del_queue(VirtIODevice *vdev, int n);
> >>
> >>   void virtio_delete_queue(VirtQueue *vq);
> >>
> >> +void *virtqueue_alloc_in_order_element(const VirtQueueElement *elem,
> >> +                                       unsigned int len, unsigned int=
 idx,
> >> +                                       unsigned int count);
> >> +
> >> +void virtqueue_order_element(VirtQueue *vq, const VirtQueueElement *e=
lem,
> >> +                             unsigned int len, unsigned int idx,
> >> +                             unsigned int count);
> >> +
> >>   void virtqueue_push(VirtQueue *vq, const VirtQueueElement *elem,
> >>                       unsigned int len);
> >>   void virtqueue_flush(VirtQueue *vq, unsigned int count);
> >> --
> >> 2.39.3
> >>
> >
>

