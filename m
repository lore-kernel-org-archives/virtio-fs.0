Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC3A13BAC2
	for <virtio-fs@lists.linux.dev>; Thu,  9 May 2024 13:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715260444; cv=none; b=pQjCW8GW2Gc8s/IW32S1L5enl//avKySNuhodBnK3m6G1ferz8vcQml7ER30p2lLeL7yDm2LLyHL5zc+6Zp3FU3M78KD+iybQ8H9oaJ8reIDwuPQLNyeLs4FqQCpxb3sYUgdwGH16bWIkX+nIa5rlsLzJp+ehhgM4csFk0glQTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715260444; c=relaxed/simple;
	bh=YklrTqV5E5t5UHpAOcBXYwPOq24bAzLLkDUOIZ0u5F0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ahVFIJbhh4aLHHc1FYFOYMhePYbLCVr2nH1n/58yeBF0LMNL6CNlQhSqC7YtL0q1FwHfjtR/WhUf79CrmDPeLDmnqlg+DEweSLc2OrMQ4Tp7P3dh/OVcZA529I5Ql2Qxm6ffBzqLXNDiNvrdzwNGz+70Z+zrlSfuFniBPcSFK0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ipcvhU6U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ipcvhU6U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715260441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vo0rdvNCtADGJUOZEToQ/LD1I8me2EZpGdoGQrmHLOg=;
	b=ipcvhU6USExTXxJ+OKBhl4LISZlaMIXeo9ZhEwS/La2hUF5Dz3unGiEbUE1J3r2qYeCxhN
	gNywkl8q40TxVyym08K6NkclMJ582rM94ZqkRzW+oniMZoL/zXrFRLhFYXcMguQTsh5rPd
	oRm+v4JFgee8gNG1ieR/3tCl2UH+FlM=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-qtSx0jmENWSq17DdULtCnQ-1; Thu, 09 May 2024 09:13:58 -0400
X-MC-Unique: qtSx0jmENWSq17DdULtCnQ-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-de54ccab44aso1539482276.3
        for <virtio-fs@lists.linux.dev>; Thu, 09 May 2024 06:13:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715260437; x=1715865237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vo0rdvNCtADGJUOZEToQ/LD1I8me2EZpGdoGQrmHLOg=;
        b=RKzCEEqGnXL/xo9SyaO/j88vpDdVGptXgHa4ENgyybwiF2C2AjqU2n0FncNdniOJfB
         8Uod4XbfhhGkvq6Bktu2EVPvP0QE9haJCvjHs71gBQBGicN6gIfQr7wxifbvAaTH7xkD
         dp+/wsWtndm/Aleyk4LxkvGUGtXy5Zj4mziGhAvceXtCaM6NYo5W8mAEiEx3NbTrx1rm
         UGDFluLFTIiGw8RO2vK80gtAflNsB51sDSR34pNFkFNHUE3sXhTIZzL2w7JMfn04ty4v
         w0IRmitjcQLzUJBvVAy9rb0Pc4Ll//QQ1tlMh51pMXRsCnHdSkZLFQtwAKi8z2xwMDsi
         XQRw==
X-Forwarded-Encrypted: i=1; AJvYcCXe+SVIGwV/KKregot3qX4UivMA8gJhbCPQ7K3AuUgoU4BUvMLzY+gDWsL/EeRtmIdEQI+ZYe99uPh9K09FKHAG5xrleXyBIQx3
X-Gm-Message-State: AOJu0Yw+LNZDnwkq4XoyfJ8SK2yZxvCoKe65/0EGMOM1NQb2VjED8nan
	0lCL2/usIgWzmfNIu2uxP3Bm4H/kHRh70fUaGI2higQS7EG6fP9IPruKwdak52QllAdupYL68eN
	RUUK7dcRoX3e29dLjRXIAqP1M8HoUZ5dxUxBk4depHpl5uZrSRKOsaUhFiNQil0Rdc0UzGshtRA
	DbGGg70agSIbCmRR5uh6U+pfbBqrGEouRx
X-Received: by 2002:a25:8151:0:b0:deb:c936:abf6 with SMTP id 3f1490d57ef6-debc936af36mr3725921276.24.1715260437475;
        Thu, 09 May 2024 06:13:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGONfrpqmIcMELAUBDnfsvHxU0WLuUoopLIbdS4VMP4j2x+TBBXXj08cQmBmG2QaWU1aSnr9k6nKk09ob4wT48=
X-Received: by 2002:a25:8151:0:b0:deb:c936:abf6 with SMTP id
 3f1490d57ef6-debc936af36mr3725843276.24.1715260435683; Thu, 09 May 2024
 06:13:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240506150428.1203387-1-jonah.palmer@oracle.com> <20240506150428.1203387-3-jonah.palmer@oracle.com>
In-Reply-To: <20240506150428.1203387-3-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 9 May 2024 15:13:19 +0200
Message-ID: <CAJaqyWeASizkBEmef4Yo7Mv0hF2zKe2p627G4ZEgVG0kMkCCOg@mail.gmail.com>
Subject: Re: [PATCH 2/6] virtio: virtqueue_pop - VIRTIO_F_IN_ORDER support
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

On Mon, May 6, 2024 at 5:06=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.co=
m> wrote:
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
> index 893a072c9d..e6eb1bb453 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -1506,7 +1506,7 @@ static void *virtqueue_alloc_element(size_t sz, uns=
igned out_num, unsigned in_nu
>
>  static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
>  {
> -    unsigned int i, head, max;
> +    unsigned int i, j, head, max;
>      VRingMemoryRegionCaches *caches;
>      MemoryRegionCache indirect_desc_cache;
>      MemoryRegionCache *desc_cache;
> @@ -1539,6 +1539,8 @@ static void *virtqueue_split_pop(VirtQueue *vq, siz=
e_t sz)
>          goto done;
>      }
>
> +    j =3D vq->last_avail_idx;
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
> +        vq->used_elems[j].index =3D elem->index;
> +        vq->used_elems[j].len =3D elem->len;
> +        vq->used_elems[j].ndescs =3D elem->ndescs;
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

I suggest using a consistent style between packed and split: Either
always use vq->last_avail_idx or j. If you use j, please rename to
something more related to the usage, as j is usually for iterations.

In my opinion I think vq->last_avail_idx is better.


>      vq->last_avail_idx +=3D elem->ndescs;
>      vq->inuse +=3D elem->ndescs;
>
> --
> 2.39.3
>

