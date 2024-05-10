Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE14115ECCF
	for <virtio-fs@lists.linux.dev>; Fri, 10 May 2024 07:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715327352; cv=none; b=JA39cZrSWeWb2AEGsfXZCUy89tdEVQbvQqv+3/FyL1Nk32EUReTHxCZdyIIw0lpd2DsPmzh1ct2uJXUaq/bhd3FvQBbxfZqxMJsPoSrjiWFtGKI/75326dyQ518XI9qN97Y/wLFu4LLDKT1y04MlEyfUbuc9jDfXpiXDt45cGyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715327352; c=relaxed/simple;
	bh=tvKywJ10hYj7f4eDtVwPPNbhnpcTNd25062gX00t79o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pKH8Gi7yEWSnA1MhymE2Ye3Lgy5tM1vfGT7IXwgKNZfnEradqnF2+1oXSB+S5nQHV5vpPQHhVlzso9WudtZzrbWpOhYsIIpZh6P8ldAO7bT+fZgviLSNB8oZNwIq5zLvzcEUJoNnJJPbUla/Q2/B/5FBD7qGf1tQbHWMEDDEOsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NT6wEqLL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NT6wEqLL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715327349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wt0dTIt6d4wjvyBofQFW28KQCSensSnHLBQWx9Uno0Q=;
	b=NT6wEqLLxJSu9GnHKRDp9m262WJMXTRBAQb7rFLLM3KwITw1VEgc91fyuP05dnll2fciau
	IMvkkvVRjtLLWwsxwgfMUdNJuKGHynmSWBJj07llor6ti4S/Ct6lBYeGWsPaJ3pjCRfyc+
	030TMskNlUher86qy1JPrAKVUZ9y/0U=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-8vWI1FO9PheibwPZyf9Myg-1; Fri, 10 May 2024 03:49:06 -0400
X-MC-Unique: 8vWI1FO9PheibwPZyf9Myg-1
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-de617c7649dso2620763276.0
        for <virtio-fs@lists.linux.dev>; Fri, 10 May 2024 00:49:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715327346; x=1715932146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wt0dTIt6d4wjvyBofQFW28KQCSensSnHLBQWx9Uno0Q=;
        b=rhc6+8n3Djd+m7oAVOdwz10c572fo1rG6xDalj9pKpL3S6aFikdzjn6l+y2yW4SDKq
         duA7aoYnIkMheBqZRfRhSbAGKj09y4D4dr8DnCUnqtpsGKN65YhFEPBOSYPlCFUrk3Jc
         jKdFC4w/WhbtBT7/jdW5dQqzOXRoBhIbxNc+85oGgrU+jVpZ8xtOiIRUN0iy6u30tctn
         lyd5TOmZLuhAFUW5gCz6urajQz36HWgR0SKwYy2PvAxQxLaSAlj+L+K1Shv/4waqK5HT
         0XTcj6+VrKBFEIKYv/OKURulc78Il3Au09wUTkQWp1lwKVAsoMn1Ta+dNLdmh87TGMX3
         Sm5w==
X-Forwarded-Encrypted: i=1; AJvYcCXFjro52CWbIyym8uu3Jme6dAmB5jtSGu8flSHCyda2vSgsXtXN19iz0iShV6Xlmdrc+V7tLqjFV7dx90ovFumGwTfsH1xY375o
X-Gm-Message-State: AOJu0Yyy5hhlDLfHrzJqPtlsDh53OaZLKEewDpy3GMppm36sPjd+ICZ9
	HiX78nncpWQgBiI1qZl7/5od9/lqO5oGkciZSpnCzwGSq5sctf8hwFnx7P987oox8x+HBSorD2M
	Z0YO5U+RxMuhOCbHKzhNOp6VTnJbNiMSx8GJOHd7GFjw70F1irJI8L5iBupO7nPfqHSrPHmLApT
	iMAaoaM30arKxKv897d/XQBmABZzQ6HQmr
X-Received: by 2002:a25:c7d1:0:b0:de5:9d13:48ac with SMTP id 3f1490d57ef6-dee4f2f6deemr1926645276.5.1715327345837;
        Fri, 10 May 2024 00:49:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFW6lIvSV6PJRfNnt0MAg8Qx5Eu3tgVC7KaSPbS66wUMfqoTkFK3NWaxowvf0IHZGExOZtYhdIRSzeah6BJyWI=
X-Received: by 2002:a25:c7d1:0:b0:de5:9d13:48ac with SMTP id
 3f1490d57ef6-dee4f2f6deemr1926624276.5.1715327345511; Fri, 10 May 2024
 00:49:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240506150428.1203387-1-jonah.palmer@oracle.com> <20240506150428.1203387-5-jonah.palmer@oracle.com>
In-Reply-To: <20240506150428.1203387-5-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 10 May 2024 09:48:29 +0200
Message-ID: <CAJaqyWd8ALnpr5BVOFpWo1ndUu9Y3XHO0UKtHFzEOFW3FsmWpA@mail.gmail.com>
Subject: Re: [PATCH 4/6] virtio: virtqueue_ordered_flush - VIRTIO_F_IN_ORDER support
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
> Add VIRTIO_F_IN_ORDER feature support for virtqueue_flush operations.
>
> The goal of the virtqueue_flush operation when the VIRTIO_F_IN_ORDER
> feature has been negotiated is to write elements to the used/descriptor
> ring in-order and then update used_idx.
>
> The function iterates through the VirtQueueElement used_elems array
> in-order starting at vq->used_idx. If the element is valid (filled), the
> element is written to the used/descriptor ring. This process continues
> until we find an invalid (not filled) element.
>
> If any elements were written, the used_idx is updated.
>
> Tested-by: Lei Yang <leiyang@redhat.com>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  hw/virtio/virtio.c | 75 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 74 insertions(+), 1 deletion(-)
>
> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> index 064046b5e2..0efed2c88e 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -1006,6 +1006,77 @@ static void virtqueue_packed_flush(VirtQueue *vq, =
unsigned int count)
>      }
>  }
>
> +static void virtqueue_ordered_flush(VirtQueue *vq)
> +{
> +    unsigned int i =3D vq->used_idx;
> +    unsigned int ndescs =3D 0;
> +    uint16_t old =3D vq->used_idx;
> +    bool packed;
> +    VRingUsedElem uelem;
> +
> +    packed =3D virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED);
> +
> +    if (packed) {
> +        if (unlikely(!vq->vring.desc)) {
> +            return;
> +        }
> +    } else if (unlikely(!vq->vring.used)) {
> +        return;
> +    }
> +
> +    /* First expected in-order element isn't ready, nothing to do */
> +    if (!vq->used_elems[i].filled) {
> +        return;
> +    }
> +
> +    /* Write first expected in-order element to used ring (split VQs) */
> +    if (!packed) {
> +        uelem.id =3D vq->used_elems[i].index;
> +        uelem.len =3D vq->used_elems[i].len;
> +        vring_used_write(vq, &uelem, i);
> +    }
> +
> +    ndescs +=3D vq->used_elems[i].ndescs;
> +    i +=3D ndescs;
> +    if (i >=3D vq->vring.num) {
> +        i -=3D vq->vring.num;
> +    }
> +
> +    /* Search for more filled elements in-order */
> +    while (vq->used_elems[i].filled) {
> +        if (packed) {
> +            virtqueue_packed_fill_desc(vq, &vq->used_elems[i], ndescs, f=
alse);
> +        } else {
> +            uelem.id =3D vq->used_elems[i].index;
> +            uelem.len =3D vq->used_elems[i].len;
> +            vring_used_write(vq, &uelem, i);
> +        }
> +
> +        vq->used_elems[i].filled =3D false;
> +        ndescs +=3D vq->used_elems[i].ndescs;
> +        i +=3D ndescs;
> +        if (i >=3D vq->vring.num) {
> +            i -=3D vq->vring.num;
> +        }
> +    }
> +

I may be missing something, but you have split out the first case as a
special one, totally out of the while loop. Can't it be contained in
the loop checking !(packed && i =3D=3D vq->used_idx)? That would avoid
code duplication.

A comment can be added in the line of "first entry of packed is
written the last so the guest does not see invalid descriptors".

> +    if (packed) {
> +        virtqueue_packed_fill_desc(vq, &vq->used_elems[vq->used_idx], 0,=
 true);
> +        vq->used_idx +=3D ndescs;
> +        if (vq->used_idx >=3D vq->vring.num) {
> +            vq->used_idx -=3D vq->vring.num;
> +            vq->used_wrap_counter ^=3D 1;
> +            vq->signalled_used_valid =3D false;
> +        }
> +    } else {
> +        vring_used_idx_set(vq, i);
> +        if (unlikely((int16_t)(i - vq->signalled_used) < (uint16_t)(i - =
old))) {
> +            vq->signalled_used_valid =3D false;
> +        }
> +    }
> +    vq->inuse -=3D ndescs;
> +}
> +
>  void virtqueue_flush(VirtQueue *vq, unsigned int count)
>  {
>      if (virtio_device_disabled(vq->vdev)) {
> @@ -1013,7 +1084,9 @@ void virtqueue_flush(VirtQueue *vq, unsigned int co=
unt)
>          return;
>      }
>
> -    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
> +    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
> +        virtqueue_ordered_flush(vq);
> +    } else if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) =
{
>          virtqueue_packed_flush(vq, count);
>      } else {
>          virtqueue_split_flush(vq, count);
> --
> 2.39.3
>

