Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F695ED8
	for <virtio-fs@lists.linux.dev>; Tue, 16 Apr 2024 00:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713228480; cv=none; b=P0fU8O46dmGQ3Kqk+sB4svw+7jbnyTWNChO1F36rKGujGI7zJs+w48zGjApuAwgURm7O6TjkF9/iB8kSWsUaZD4EQ3OQZNqE9+WakL217LJjrkps5ostU4ICnigDhM27BsZzDKWga3vE5giQK5sdRzCS4pSlroTWw6zUDb4krMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713228480; c=relaxed/simple;
	bh=byCP/FDg3cxi3Q9avxehHBL47kJoTd6F79Ew7XP5zhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HocZYhrDqGBIxVFGqJNmG++oLS7Tyaha0E6xS1U8aCKyC/EUcj92vUBP/uI2bl6dJ6fqy3WYDCXiBC7pubh4qTmEkTPSzAnc0WW5fi8uirc8ZXF4Jx9dFRLOrUacEouWPvwTXhGPfH3FjyfD3kZh91Zhw7wB8csom4YM3e8+bJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WCRWsmYj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WCRWsmYj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713228477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=997gQ0EC64A1IFQr7b9ClHckWVuOZOzu8dRw7fYVG2c=;
	b=WCRWsmYjm12O9ry1G7muS29RY043E3rwgwPhSzVoUXSJt6flpCKVZA/AubKJ5PE22fNy4k
	NXTMw+83M2wdcIR7mnrhSNJgUsbh9RZ/FEiylZGSVzr70ZLPO+GdJul7toC0iXeA2UCk/v
	Li22qPaqACk/Oj9HT0Ou0Jf65VJwifY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-XLM3CahdPBuv8HJ4J-obKg-1; Mon, 15 Apr 2024 20:47:56 -0400
X-MC-Unique: XLM3CahdPBuv8HJ4J-obKg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a54c11dccf1so78443766b.0
        for <virtio-fs@lists.linux.dev>; Mon, 15 Apr 2024 17:47:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713228475; x=1713833275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=997gQ0EC64A1IFQr7b9ClHckWVuOZOzu8dRw7fYVG2c=;
        b=POp5boJ0j4dJsTvWpRwDXiJs4SlHfLEVUtB1o63OuoSN2ud9xnz29//79vMwkDHFs3
         elhc4a4LTGi0u6+tS4T5u2z0m471tewe6WMcmh+/SrOTqEg+X+XuxzrJ0GobgZ7o4f0Y
         2+gVrlvFlGXar3wKvdaBPEZ/DZPgdWFfMZXeqRBsWnNMnLGnV7zGDEoG1XnOcL5u4mbD
         Zw/6BwQSr7f9VZQhQz+jTTFnddsXqh84Qk7K3EiIMVtjM76mC+ITcOz8bx3EXvaJIhe8
         d08e/lYmmg79kMrbDtNoHY3TWsn3a44sQ6/KD7ZqGSQ509l8Pf3FDiInPqgbA5DkioJW
         xH7A==
X-Forwarded-Encrypted: i=1; AJvYcCVahn20K0ZXExxB6JfF9hxKl+1EYFoIGy0vNAnu0gLyvkY+1PPnoWcNg6YWRtlrMd3bRpxe75o0chVzlaQxW7UYz+3+6Igcf/jp
X-Gm-Message-State: AOJu0Yyjbo3Ocv5Zs174LIQ684slnT+8dpVOnPnXSMCHUrO56+lRnh2J
	Sw//skskgtEyzapxXQ2LJU1y3tgpamQMqDW/VnhVFePZEwkN3TvUkfaxLcBj16eiFwtBA0M17gU
	YZR2V33Mb/yObllSuUTygq6YS5c0NdJsLH+fkBuRyEgzTOQbsxacY2WsZG8AUViIhCxXgeynjYu
	jO+cHQ5S2TXA+iSSr6h52YKu6qQF233/9b
X-Received: by 2002:a17:907:972a:b0:a51:827d:c99b with SMTP id jg42-20020a170907972a00b00a51827dc99bmr9051232ejc.14.1713228475033;
        Mon, 15 Apr 2024 17:47:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpeVQr9oYRUmNPe4+JyA6CSwp2Lae4DDkx8dqE5KYybKeOsdpAWhFNCR2NnUP093EGYCi3/FSTR5igpSY95Bk=
X-Received: by 2002:a17:907:972a:b0:a51:827d:c99b with SMTP id
 jg42-20020a170907972a00b00a51827dc99bmr9051211ejc.14.1713228474641; Mon, 15
 Apr 2024 17:47:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240408153408.3527586-1-jonah.palmer@oracle.com>
In-Reply-To: <20240408153408.3527586-1-jonah.palmer@oracle.com>
From: Lei Yang <leiyang@redhat.com>
Date: Tue, 16 Apr 2024 08:47:17 +0800
Message-ID: <CAPpAL=yBZqQuRbv6W_7o11+KgMyLHfqix2AyA8By7f7oZvgB4Q@mail.gmail.com>
Subject: Re: [RFC v3 0/6] virtio,vhost: Add VIRTIO_F_IN_ORDER support
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net, 
	kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, 
	fam@euphon.net, eperezma@redhat.com, stefanha@redhat.com, 
	qemu-block@nongnu.org, schalla@marvell.com, virtio-fs@lists.linux.dev, 
	si-wei.liu@oracle.com, boris.ostrovsky@oracle.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

QE tested this series with packed=3Don/off, in_order=3Dtrue and vhost=3Doff
under regression tests, everything are works fine.

Tested-by: Lei Yang <leiyang@redhat.com>

On Mon, Apr 8, 2024 at 11:34=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
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
> of a VirtQueue's used_elems VirtQueueElement array. This allows devices
> who always use buffers in-order by default to have a minimal overhead
> impact. Devices that may not always use buffers in-order likely will
> experience a performance hit. How large that performance hit is will
> depend on how frequent elements are completed out-of-order.
>
> A VirtQueue whose device who uses this feature will use its used_elems
> VirtQueueElement array to hold used VirtQueueElements. The index that
> used elements are placed in used_elems is the same index on the
> used/descriptor ring that would satisfy the in-order requirement. In
> other words, used elements are placed in their in-order locations on
> used_elems and are only written to the used/descriptor ring once the
> elements on used_elems are able to continue their expected order.
>
> To differentiate between a "used" and "unused" element on the used_elems
> array (a "used" element being an element that has returned from
> processing and an "unused" element being an element that has not yet
> been processed), we added a boolean 'filled' member to the
> VirtQueueElement struct. This flag is set to true when the element comes
> back from processing (virtqueue_ordered_fill) and then set back to false
> once it's been written to the used/descriptor ring
> (virtqueue_ordered_flush).
>
> ---
> v3: Add elements to used_elems during virtqueue_split/packed_pop
>     Replace current_seq_idx usage with vq->last_avail_idx
>     Remove used_seq_idx, leverage used_idx and last_avail_idx for
>     searching used_elems
>     Remove seq_idx in VirtQueueElement
>     Add boolean to VirtQueueElement to signal element status
>     Add virtqueue_ordered_fill/flush functions for ordering
>
> v2: Use a VirtQueue's used_elems array as a buffer mechanism
>
> v1: Implement custom GLib GHashTable as a buffer mechanism
>
> Jonah Palmer (6):
>   virtio: Add bool to VirtQueueElement
>   virtio: virtqueue_pop - VIRTIO_F_IN_ORDER support
>   virtio: virtqueue_ordered_fill - VIRTIO_F_IN_ORDER support
>   virtio: virtqueue_ordered_flush - VIRTIO_F_IN_ORDER support
>   vhost,vhost-user: Add VIRTIO_F_IN_ORDER to vhost feature bits
>   virtio: Add VIRTIO_F_IN_ORDER property definition
>
>  hw/block/vhost-user-blk.c    |   1 +
>  hw/net/vhost_net.c           |   2 +
>  hw/scsi/vhost-scsi.c         |   1 +
>  hw/scsi/vhost-user-scsi.c    |   1 +
>  hw/virtio/vhost-user-fs.c    |   1 +
>  hw/virtio/vhost-user-vsock.c |   1 +
>  hw/virtio/virtio.c           | 118 ++++++++++++++++++++++++++++++++++-
>  include/hw/virtio/virtio.h   |   5 +-
>  net/vhost-vdpa.c             |   1 +
>  9 files changed, 127 insertions(+), 4 deletions(-)
>
> --
> 2.39.3
>

