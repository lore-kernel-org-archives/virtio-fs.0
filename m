Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B45A3FB96
	for <virtio-fs@lists.linux.dev>; Wed, 22 May 2024 15:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716392771; cv=none; b=ROtU1kZ7DMuqAxjSi791DHI/XUsq01JLOBwVrrkAFCvLbOReobyO2ps+OJgSprJ4ZplIZxnGvtk7vVs4biYs6LNCgRFQe3sL0rj0TWLR7zFf1tZlmJbnBCeIa0fnTx8whpQRxD7GSuqEE8TNbfC2HuP7SOtaF02aew0710MNf90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716392771; c=relaxed/simple;
	bh=JADkpMP7QlcwBGjjog2sfRVqS8qGCZhOZYFtXiOIRJI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hmgOHN160z5YpOM334YoTFvbIeZ3ROyRphtrkJ8pyNvLlEbQj8v5JQq75hPKQAO70jB0xhw1bd3lAzXn2/hecp7PiX/qs6AGH0ti6MNBDZ1c3BLPvj79Xa9xp+OYqZyAUwbuQItLjkNZhKoXn9WynKHtf6q/oIYUw2/IQmvousk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AIOUvoZv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AIOUvoZv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716392769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dohSD+xMyXX8VQW8PMZIyNH8UCTgtLWA68tTvl5P8RA=;
	b=AIOUvoZv2i9Q473lEBYLFyvXE2NItadXWH3US3NjcxMAVV4EHWdKUNXjASwXuHgcCW4j7U
	7/6ZYT4h1JsKzymUKjNhYlB8FbVH6jSjXtYK/mvdrEfMkmIAvZM8XePzl5n0gMKIzTcmLz
	qHe2awv4oLH5rk5ypBmCm0xO0omNZtU=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-899cLtVuNdqWKbsByWNYZg-1; Wed, 22 May 2024 11:46:07 -0400
X-MC-Unique: 899cLtVuNdqWKbsByWNYZg-1
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-dee902341c0so16140109276.3
        for <virtio-fs@lists.linux.dev>; Wed, 22 May 2024 08:46:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716392767; x=1716997567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dohSD+xMyXX8VQW8PMZIyNH8UCTgtLWA68tTvl5P8RA=;
        b=lTCBk3h1oKDKDxFbPrWbxQmuQfaC7EkbB3APFRB7joVTYjNb/l8j9JbORNZ8yPrAoI
         K682RKcZA2QF00KS+a6EZStMSi7Z61zbwjo8xrQ3PyCRJKHjW+Pm6NoiRlNNahkML2Kc
         4V3W7wwWacoAc4vchfIBkRon9iramK6u7fsNO234Ol3zn43kp3E0Qar5s7pxuRGNyXfE
         ApcC8mj4gTZ3Avj5IRW7sdeb3wq6kWXkzLQw2Yf1JlHJsmRODVjAxz4/JGIkrdE04rS5
         3FPbkzFUfocEHzdR/cM3y37U9ufbynOE336QwDnSKL8Vw7AgUDLhVXvN61G7/MDaGQkS
         CPPA==
X-Forwarded-Encrypted: i=1; AJvYcCW5dpbsitOpU5VDA/kYFQBhObudUum0q0px5QTRuDNLM8H0dw+9CNvcd53aE7DdQPUxqlHj5+pjgDHYEseQqdojH6ymAFsXCZwB
X-Gm-Message-State: AOJu0YwetSZbTTFQYstYW0TABkx4qAz3GfigCEsl1ECBbNvY6/wHhBBl
	wVeZqqDAogHlE3NED2qV+ooaoBaB6IuaZG5DrvSFDj0SZGn3UKppE5vgoZ/rWZBLgd+kYv6tPX0
	GNw+rnusnDdG2vm9CfRQ9ESciX9k6Vc5txgJN970xCiwL2wWSyogvQErSmujoWtdG38ci+y0+go
	iR7F92/sH/UUIdlE4xDDMxkBEzeH4eFPiM
X-Received: by 2002:a25:add5:0:b0:de0:de50:d6d4 with SMTP id 3f1490d57ef6-df4e0a6e798mr2683748276.8.1716392767241;
        Wed, 22 May 2024 08:46:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGjVEJ7I8YyfrTgHsOl3Et6/mGrY9eCItONq3gG92V0rIP1Z6NuZLnO4gcTlmJVyMvFE4mwGYr59PZjgbp9vHo=
X-Received: by 2002:a25:add5:0:b0:de0:de50:d6d4 with SMTP id
 3f1490d57ef6-df4e0a6e798mr2683635276.8.1716392765393; Wed, 22 May 2024
 08:46:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240520130048.1483177-1-jonah.palmer@oracle.com> <20240520130048.1483177-3-jonah.palmer@oracle.com>
In-Reply-To: <20240520130048.1483177-3-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 22 May 2024 17:45:29 +0200
Message-ID: <CAJaqyWePFXKm9qSjczbWyacadd7Cxv2NxEvM1qT=UYNi_VW7qg@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] virtio: virtqueue_pop - VIRTIO_F_IN_ORDER support
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

On Mon, May 20, 2024 at 3:01=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
> Add VIRTIO_F_IN_ORDER feature support in virtqueue_split_pop and
> virtqueue_packed_pop.
>
> VirtQueueElements popped from the available/descritpor ring are added to
> the VirtQueue's used_elems array in-order and in the same fashion as
> they would be added the used and descriptor rings, respectively.
>
> This will allow us to keep track of the current order, what elements
> have been written, as well as an element's essential data after being
> processed.
>
> Tested-by: Lei Yang <leiyang@redhat.com>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  hw/virtio/virtio.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> index 893a072c9d..7456d61bc8 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -1506,7 +1506,7 @@ static void *virtqueue_alloc_element(size_t sz, uns=
igned out_num, unsigned in_nu
>
>  static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
>  {
> -    unsigned int i, head, max;
> +    unsigned int i, head, max, prev_avail_idx;
>      VRingMemoryRegionCaches *caches;
>      MemoryRegionCache indirect_desc_cache;
>      MemoryRegionCache *desc_cache;
> @@ -1539,6 +1539,8 @@ static void *virtqueue_split_pop(VirtQueue *vq, siz=
e_t sz)
>          goto done;
>      }
>
> +    prev_avail_idx =3D vq->last_avail_idx;
> +
>      if (!virtqueue_get_head(vq, vq->last_avail_idx++, &head)) {
>          goto done;
>      }
> @@ -1630,6 +1632,12 @@ static void *virtqueue_split_pop(VirtQueue *vq, si=
ze_t sz)
>          elem->in_sg[i] =3D iov[out_num + i];
>      }
>
> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {

I think vq->last_avail_idx - 1 could be more clear here.

Either way,

Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> +        vq->used_elems[prev_avail_idx].index =3D elem->index;
> +        vq->used_elems[prev_avail_idx].len =3D elem->len;
> +        vq->used_elems[prev_avail_idx].ndescs =3D elem->ndescs;
> +    }
> +
>      vq->inuse++;
>
>      trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
> @@ -1758,6 +1766,13 @@ static void *virtqueue_packed_pop(VirtQueue *vq, s=
ize_t sz)
>
>      elem->index =3D id;
>      elem->ndescs =3D (desc_cache =3D=3D &indirect_desc_cache) ? 1 : elem=
_entries;
> +
> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
> +        vq->used_elems[vq->last_avail_idx].index =3D elem->index;
> +        vq->used_elems[vq->last_avail_idx].len =3D elem->len;
> +        vq->used_elems[vq->last_avail_idx].ndescs =3D elem->ndescs;
> +    }
> +
>      vq->last_avail_idx +=3D elem->ndescs;
>      vq->inuse +=3D elem->ndescs;
>
> --
> 2.39.3
>

