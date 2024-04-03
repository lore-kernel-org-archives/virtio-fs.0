Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC5D135A6D
	for <virtio-fs@lists.linux.dev>; Wed,  3 Apr 2024 10:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712139575; cv=none; b=eECMXa/SgcpGZhaWP7tEs9J/3fPq6EGdAwFG7kqXzOBOnvO6B4DoNb58ljHa2VwCkhYVk+Xu22oQiUTzr7+NU52SI6KL8F6vUCGhj4wYqlRVcnaSPuCKvHjYrmp7ggQWUgKwKBWyZ7WGtITa3YSyCxg5fBqOg2yAiY9p3/Qtd9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712139575; c=relaxed/simple;
	bh=kiXjTDWuqFfg06UzfBaD0dMyPaBpxmDPf7jFRtxs1l4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gRMZi/h3imSAiNC3TFowyEdOR2fyC9M8hAvkMFJH5fZhqscrypz08FXRN17NzlQVrP8idZfAXqr/WFUVngn+Ih6EKgxnKBm16mDAKUjuXn/LBUIVbAf3NVDaDlJgEN2hCbJDSplnmJJyFy2BoemVqC7D7CacWCe89ADGOhl9FZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iTB+qM0l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iTB+qM0l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712139572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iMLbgUGtw/LVyRlI2BcEZJWtW3QAwcebOn57SCM4cv8=;
	b=iTB+qM0lpOro0SQup+awtXhyMA2zWsD89iZBvqGEQbUyfuIsNV276dCWfi2rvsrk/eTPEE
	mZ3+IMWxK38zfZgVYcO+FwkigG6i9l06Igu2f0ZDqScVTSJV2XMeKn6AV5zhmeh5fYpIT8
	//RHmW2C1XWdoNt5P/WHBqgV9K4LksQ=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-6vc2C015OtausFcL-J8RSw-1; Wed, 03 Apr 2024 06:19:31 -0400
X-MC-Unique: 6vc2C015OtausFcL-J8RSw-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-dc74ac7d015so7187864276.0
        for <virtio-fs@lists.linux.dev>; Wed, 03 Apr 2024 03:19:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712139571; x=1712744371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iMLbgUGtw/LVyRlI2BcEZJWtW3QAwcebOn57SCM4cv8=;
        b=NdiKyZryKWU4+SYGGkxUwjTpUj0cop43O3BEAyh+yRx8LS22zY25COD6PFAQYNhPHR
         Hl602zQIlC9cFmOydz2FkYybDOtcncauIyr6ogisVkXaOy87UqxuIqDnA+EuiSbuPGFm
         Dfxu9t4L2y5OQa9YyWOQxkMjAWgiPkkRJtHEg7vPvonfYd7BmLh2Pxb47U/8CSAKZglo
         1QXauH+2m4fE6ij4zrSWd4lJBZgv+EEG+IEKeVXgMTN7Fgqq5O5IdMdOqdiJX/mti+3T
         iuKcRgUMGDUU+MS2xxrqOqmw2tm6tSm758U8GNHj7M1ZBFCYISFjV0DYPmfAQbGQeYy8
         U2Cg==
X-Forwarded-Encrypted: i=1; AJvYcCUrlutyl/npHtXLIRkhjIhkbu3yf6wEdyloDZe69nzeUBauQDwLhVYttUUmfqF3Knm0Dul76VBfQ5rNK7C/uW6CyNFOXw/dS0KK
X-Gm-Message-State: AOJu0YyZGcLe0y9uZo/RAEncWMXNB7vqrKHd2qjl+hO8ThyADrDEPSW4
	gl6Tb/matqpQK3iLv9ODg+Ols+wQoRBJr8KpyGihdOcMXbFtARyDCOGOmoEhT1kzyZ4EbqaBa1v
	2fIE3x77FKJwcG9zAN9ALmNTf7JpQZzF5UeyFgejaXRA+h63Cxnn6iOBeStcld5b+Kr4Z4IpSVq
	RYOZbdv7nKAu1fV/U/O96q5Td4p2Bbm4P0
X-Received: by 2002:a25:bcca:0:b0:dcc:3020:e68 with SMTP id l10-20020a25bcca000000b00dcc30200e68mr11442882ybm.64.1712139570897;
        Wed, 03 Apr 2024 03:19:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1pbpDKhYXQOe3zZv/yIiBMp0aLzykqZY7QDBxwg2EqhK34VOkEOCvEtBzx2zePFFuXoiqJpiXO677UQJcE+A=
X-Received: by 2002:a25:bcca:0:b0:dcc:3020:e68 with SMTP id
 l10-20020a25bcca000000b00dcc30200e68mr11442870ybm.64.1712139570604; Wed, 03
 Apr 2024 03:19:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240328162203.3775114-1-jonah.palmer@oracle.com> <20240328162203.3775114-2-jonah.palmer@oracle.com>
In-Reply-To: <20240328162203.3775114-2-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 3 Apr 2024 12:18:54 +0200
Message-ID: <CAJaqyWdyZdu48+cZ2umafLRi9NTz3YHxSxmyq6SD9d4noTR2jQ@mail.gmail.com>
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

On Thu, Mar 28, 2024 at 5:22=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.c=
om> wrote:
>
> Initialize sequence variables for VirtQueue and VirtQueueElement
> structures. A VirtQueue's sequence variables are initialized when a
> VirtQueue is being created or reset. A VirtQueueElement's sequence
> variable is initialized when a VirtQueueElement is being initialized.
> These variables will be used to support the VIRTIO_F_IN_ORDER feature.
>
> A VirtQueue's used_seq_idx represents the next expected index in a
> sequence of VirtQueueElements to be processed (put on the used ring).
> The next VirtQueueElement added to the used ring must match this
> sequence number before additional elements can be safely added to the
> used ring. It's also particularly useful for helping find the number of
> new elements added to the used ring.
>
> A VirtQueue's current_seq_idx represents the current sequence index.
> This value is essentially a counter where the value is assigned to a new
> VirtQueueElement and then incremented. Given its uint16_t type, this
> sequence number can be between 0 and 65,535.
>
> A VirtQueueElement's seq_idx represents the sequence number assigned to
> the VirtQueueElement when it was created. This value must match with the
> VirtQueue's used_seq_idx before the element can be put on the used ring
> by the device.
>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  hw/virtio/virtio.c         | 18 ++++++++++++++++++
>  include/hw/virtio/virtio.h |  1 +
>  2 files changed, 19 insertions(+)
>
> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> index fb6b4ccd83..069d96df99 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -132,6 +132,10 @@ struct VirtQueue
>      uint16_t used_idx;
>      bool used_wrap_counter;
>
> +    /* In-Order sequence indices */
> +    uint16_t used_seq_idx;
> +    uint16_t current_seq_idx;
> +

I'm having a hard time understanding the difference between these and
last_avail_idx and used_idx. It seems to me if we replace them
everything will work? What am I missing?

>      /* Last used index value we have signalled on */
>      uint16_t signalled_used;
>
> @@ -1621,6 +1625,11 @@ static void *virtqueue_split_pop(VirtQueue *vq, si=
ze_t sz)
>          elem->in_sg[i] =3D iov[out_num + i];
>      }
>
> +    /* Assign sequence index for in-order processing */
> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
> +        elem->seq_idx =3D vq->current_seq_idx++;
> +    }
> +
>      vq->inuse++;
>
>      trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
> @@ -1760,6 +1769,11 @@ static void *virtqueue_packed_pop(VirtQueue *vq, s=
ize_t sz)
>      vq->shadow_avail_idx =3D vq->last_avail_idx;
>      vq->shadow_avail_wrap_counter =3D vq->last_avail_wrap_counter;
>
> +    /* Assign sequence index for in-order processing */
> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
> +        elem->seq_idx =3D vq->current_seq_idx++;
> +    }
> +
>      trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
>  done:
>      address_space_cache_destroy(&indirect_desc_cache);
> @@ -2087,6 +2101,8 @@ static void __virtio_queue_reset(VirtIODevice *vdev=
, uint32_t i)
>      vdev->vq[i].notification =3D true;
>      vdev->vq[i].vring.num =3D vdev->vq[i].vring.num_default;
>      vdev->vq[i].inuse =3D 0;
> +    vdev->vq[i].used_seq_idx =3D 0;
> +    vdev->vq[i].current_seq_idx =3D 0;
>      virtio_virtqueue_reset_region_cache(&vdev->vq[i]);
>  }
>
> @@ -2334,6 +2350,8 @@ VirtQueue *virtio_add_queue(VirtIODevice *vdev, int=
 queue_size,
>      vdev->vq[i].vring.align =3D VIRTIO_PCI_VRING_ALIGN;
>      vdev->vq[i].handle_output =3D handle_output;
>      vdev->vq[i].used_elems =3D g_new0(VirtQueueElement, queue_size);
> +    vdev->vq[i].used_seq_idx =3D 0;
> +    vdev->vq[i].current_seq_idx =3D 0;
>
>      return &vdev->vq[i];
>  }
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index b3c74a1bca..910b2a3427 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -75,6 +75,7 @@ typedef struct VirtQueueElement
>      hwaddr *out_addr;
>      struct iovec *in_sg;
>      struct iovec *out_sg;
> +    uint16_t seq_idx;
>  } VirtQueueElement;
>
>  #define VIRTIO_QUEUE_MAX 1024
> --
> 2.39.3
>

