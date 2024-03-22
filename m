Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859393EA6F
	for <virtio-fs@lists.linux.dev>; Fri, 22 Mar 2024 10:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711104411; cv=none; b=jpqsI2CSmxxJYIQUqdvNBpR7fmN1JlMw5mo0U6g5wx5yRYks25To4StZhQW410YIp3B5QKT/VrJXm2CrFgrjMcOkfAK0MhiLfWUmbNMRS2G882QBFZMQf0EOA5Mlf7UPSpSNgk9GarHj8+tF80HrioFX1Bom5GEUq4qiTq4GJk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711104411; c=relaxed/simple;
	bh=pP2S+53U1mj7IRGYY2ENSGlj+1EXehsQnt7r7C8Du3c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MZcCVdhRZb7wZWCYN/RoY2zW48lMCYWehIi/80RgUSDLCfzA3T1n3nnihJhwEKGQP1IcmGJsC62ENMVtIsFZ1NDoFONuPXgpVY1cMzLzKijHMwRBUJx/KH0nbsuIKywSJcbB9J5KozWUSNBeWPW2LQiXwYe1r+gT6sKBLKEOit8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NjoynEZ8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NjoynEZ8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711104408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NXBVMEl+yr8B/V45S2vmEezcNU1jZzl9rRvfSfEDrKk=;
	b=NjoynEZ8pbna4i6gxrRi9VQyeyTUSK0eRev1Jq8d9fl4t9a7jMxvGYXyCL7QP4uuncZxkf
	DJ8PVErpWQ/lQJwCVqNKZp/9kEQTQo/OAHAyO+tAcSCvers7xJ1M72H3PGn1nYs/82wYJE
	VDqqvDVsSduGD8paoAhjn4dTsSK1Pk0=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-COXK3OP-NI6_7OFYweQghA-1; Fri, 22 Mar 2024 06:46:44 -0400
X-MC-Unique: COXK3OP-NI6_7OFYweQghA-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-dd8e82dd47eso2822209276.2
        for <virtio-fs@lists.linux.dev>; Fri, 22 Mar 2024 03:46:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711104404; x=1711709204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NXBVMEl+yr8B/V45S2vmEezcNU1jZzl9rRvfSfEDrKk=;
        b=mdp3xZe6zHXkyW0QRxQ5txh4iMVP5Fo0cSuoFZdMYalSkA275iwp5V2yb6kMepD13A
         4W4Iqd0EFuf+q7ltWS0BkcrWI1T7YlgiyxtHWmtHX+itkyIDhWLI9r0dMI++yoMKzcz3
         Z8HqUuxI2i9yvDAyi9aHKeNRUVEYWqcLmzsE0qXUC3cBuytrTpwP/rMYNEYx3kpYNfC3
         j6StyuMFTWxLcbJOXi/HStbl8YOU+OBQb5wxtAsVsS3z77Zjs8Whi/Evm6W1ahW5xAq8
         7dlv6vVj99a8TfuxHBU+J5mbPHjDlE0Gyml0+jhusWELLvX8OLXdtLe6cPedBqyurfno
         YnKw==
X-Forwarded-Encrypted: i=1; AJvYcCXl17gNoo9ExO4PvDJiGHlqZIUUn7DoK58eVwTC/MH7y5/GW6zYjDJWUUxVGFzTKIJJfol3Yt4GllEQgEcjVJb1Ty2KR5Um8SRj
X-Gm-Message-State: AOJu0YyNomifpukmI7/l2anA55B95ad6C17l/69aPG1zklIu4huBsGTs
	hlNgdvw9SWZNQHpADructWipFeWrOFe0dUJeNoy8wfwjw2GFrSYI96TEEOS89yp7hQXgquSdcJp
	c2no5qY6zzQpiKVIHEHl/9oFXQuSjoTehGXtalwGdwA9U8OpIFlZzKiYZKRVHiG3x4NImE2dO+Z
	jEwNPTAOdtkwmrB7T8TYlUCp80TkjVGvu9
X-Received: by 2002:a25:9341:0:b0:db5:50ea:d304 with SMTP id g1-20020a259341000000b00db550ead304mr1614839ybo.34.1711104403732;
        Fri, 22 Mar 2024 03:46:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTcw9m52uQHhVzSdcw4E1rvQ2l5P2tTIXeS24Vy1cJzcZntUDX+L244XEM/y8DDeR6TGTaFFu3qj44oGkOU1A=
X-Received: by 2002:a25:9341:0:b0:db5:50ea:d304 with SMTP id
 g1-20020a259341000000b00db550ead304mr1614811ybo.34.1711104403412; Fri, 22 Mar
 2024 03:46:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240321155717.1392787-1-jonah.palmer@oracle.com> <20240321155717.1392787-5-jonah.palmer@oracle.com>
In-Reply-To: <20240321155717.1392787-5-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 22 Mar 2024 11:46:07 +0100
Message-ID: <CAJaqyWedsT+0DT-SCAH7SMFnuWHazTsbe1kNC+PENDSxvu3W0A@mail.gmail.com>
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

On Thu, Mar 21, 2024 at 4:57=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
> Implements in-order handling for most virtio devices using the
> VIRTIO_F_IN_ORDER transport feature, specifically those who call
> virtqueue_push to push their used elements onto the used ring.
>
> The logic behind this implementation is as follows:
>
> 1.) virtqueue_pop always enqueues VirtQueueElements in-order.
>
> virtqueue_pop always retrieves one or more buffer descriptors in-order
> from the available ring and converts them into a VirtQueueElement. This
> means that the order in which VirtQueueElements are enqueued are
> in-order by default.
>
> By virtue, as VirtQueueElements are created, we can assign a sequential
> key value to them. This preserves the order of buffers that have been
> made available to the device by the driver.
>
> As VirtQueueElements are assigned a key value, the current sequence
> number is incremented.
>
> 2.) Requests can be completed out-of-order.
>
> While most devices complete requests in the same order that they were
> enqueued by default, some devices don't (e.g. virtio-blk). The goal of
> this out-of-order handling is to reduce the impact of devices that
> process elements in-order by default while also guaranteeing compliance
> with the VIRTIO_F_IN_ORDER feature.
>
> Below is the logic behind handling completed requests (which may or may
> not be in-order).
>
> 3.) Does the incoming used VirtQueueElement preserve the correct order?
>
> In other words, is the sequence number (key) assigned to the
> VirtQueueElement the expected number that would preserve the original
> order?
>
> 3a.)
> If it does... immediately push the used element onto the used ring.
> Then increment the next expected sequence number and check to see if
> any previous out-of-order VirtQueueElements stored on the hash table
> has a key that matches this next expected sequence number.
>
> For each VirtQueueElement found on the hash table with a matching key:
> push the element on the used ring, remove the key-value pair from the
> hash table, and then increment the next expected sequence number. Repeat
> this process until we're unable to find an element with a matching key.
>
> Note that if the device uses batching (e.g. virtio-net), then we skip
> the virtqueue_flush call and let the device call it themselves.
>
> 3b.)
> If it does not... stash the VirtQueueElement, along with relevant data,
> as a InOrderVQElement on the hash table. The key used is the order_key
> that was assigned when the VirtQueueElement was created.
>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  hw/virtio/virtio.c         | 70 ++++++++++++++++++++++++++++++++++++--
>  include/hw/virtio/virtio.h |  8 +++++
>  2 files changed, 76 insertions(+), 2 deletions(-)
>
> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> index 40124545d6..40e4377f1e 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -992,12 +992,56 @@ void virtqueue_flush(VirtQueue *vq, unsigned int co=
unt)
>      }
>  }
>
> +void virtqueue_order_element(VirtQueue *vq, const VirtQueueElement *elem=
,
> +                             unsigned int len, unsigned int idx,
> +                             unsigned int count)
> +{
> +    InOrderVQElement *in_order_elem;
> +
> +    if (elem->order_key =3D=3D vq->current_order_idx) {
> +        /* Element is in-order, push to used ring */
> +        virtqueue_fill(vq, elem, len, idx);
> +
> +        /* Batching? Don't flush */
> +        if (count) {
> +            virtqueue_flush(vq, count);

The "count" parameter is the number of heads used, but here you're
only using one head (elem). Same with the other virtqueue_flush in the
function.

Also, this function sometimes replaces virtqueue_fill and other
replaces virtqueue_fill + virtqueue_flush (both examples in patch
6/8). I have the impression the series would be simpler if
virtqueue_order_element is a static function just handling the
virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER) path of
virtqueue_fill, so the caller does not need to know if the in_order
feature is on or off.

> +        }
> +
> +        /* Increment next expected order, search for more in-order eleme=
nts */
> +        while ((in_order_elem =3D g_hash_table_lookup(vq->in_order_ht,
> +                        GUINT_TO_POINTER(++vq->current_order_idx))) !=3D=
 NULL) {
> +            /* Found in-order element, push to used ring */
> +            virtqueue_fill(vq, in_order_elem->elem, in_order_elem->len,
> +                           in_order_elem->idx);
> +
> +            /* Batching? Don't flush */
> +            if (count) {
> +                virtqueue_flush(vq, in_order_elem->count);
> +            }
> +
> +            /* Remove key-value pair from hash table */
> +            g_hash_table_remove(vq->in_order_ht,
> +                                GUINT_TO_POINTER(vq->current_order_idx))=
;
> +        }
> +    } else {
> +        /* Element is out-of-order, stash in hash table */
> +        in_order_elem =3D virtqueue_alloc_in_order_element(elem, len, id=
x,
> +                                                         count);
> +        g_hash_table_insert(vq->in_order_ht, GUINT_TO_POINTER(elem->orde=
r_key),
> +                            in_order_elem);
> +    }
> +}
> +
>  void virtqueue_push(VirtQueue *vq, const VirtQueueElement *elem,
>                      unsigned int len)
>  {
>      RCU_READ_LOCK_GUARD();
> -    virtqueue_fill(vq, elem, len, 0);
> -    virtqueue_flush(vq, 1);
> +    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
> +        virtqueue_order_element(vq, elem, len, 0, 1);
> +    } else {
> +        virtqueue_fill(vq, elem, len, 0);
> +        virtqueue_flush(vq, 1);
> +    }
>  }
>
>  /* Called within rcu_read_lock().  */
> @@ -1478,6 +1522,18 @@ void virtqueue_map(VirtIODevice *vdev, VirtQueueEl=
ement *elem)
>                                                                          =
false);
>  }
>
> +void *virtqueue_alloc_in_order_element(const VirtQueueElement *elem,
> +                                       unsigned int len, unsigned int id=
x,
> +                                       unsigned int count)
> +{
> +    InOrderVQElement *in_order_elem =3D g_malloc(sizeof(InOrderVQElement=
));
> +    in_order_elem->elem =3D elem;
> +    in_order_elem->len =3D len;
> +    in_order_elem->idx =3D idx;
> +    in_order_elem->count =3D count;
> +    return in_order_elem;
> +}
> +
>  static void *virtqueue_alloc_element(size_t sz, unsigned out_num, unsign=
ed in_num)
>  {
>      VirtQueueElement *elem;
> @@ -1626,6 +1682,11 @@ static void *virtqueue_split_pop(VirtQueue *vq, si=
ze_t sz)
>          elem->in_sg[i] =3D iov[out_num + i];
>      }
>
> +    /* Assign key for in-order processing */
> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
> +        elem->order_key =3D vq->current_order_key++;

Since you're adding this in both split_pop and packed_pop, why not add
it in virtqueue_pop?

> +    }
> +
>      vq->inuse++;
>
>      trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
> @@ -1762,6 +1823,11 @@ static void *virtqueue_packed_pop(VirtQueue *vq, s=
ize_t sz)
>          vq->last_avail_wrap_counter ^=3D 1;
>      }
>
> +    /* Assign key for in-order processing */
> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
> +        elem->order_key =3D vq->current_order_key++;
> +    }
> +
>      vq->shadow_avail_idx =3D vq->last_avail_idx;
>      vq->shadow_avail_wrap_counter =3D vq->last_avail_wrap_counter;
>
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index f83d7e1fee..eeeda397a9 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -275,6 +275,14 @@ void virtio_del_queue(VirtIODevice *vdev, int n);
>
>  void virtio_delete_queue(VirtQueue *vq);
>
> +void *virtqueue_alloc_in_order_element(const VirtQueueElement *elem,
> +                                       unsigned int len, unsigned int id=
x,
> +                                       unsigned int count);
> +
> +void virtqueue_order_element(VirtQueue *vq, const VirtQueueElement *elem=
,
> +                             unsigned int len, unsigned int idx,
> +                             unsigned int count);
> +
>  void virtqueue_push(VirtQueue *vq, const VirtQueueElement *elem,
>                      unsigned int len);
>  void virtqueue_flush(VirtQueue *vq, unsigned int count);
> --
> 2.39.3
>

