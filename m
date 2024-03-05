Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D0D7EEFD
	for <virtio-fs@lists.linux.dev>; Tue,  5 Mar 2024 08:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709625976; cv=none; b=ZdszDxaZU6C+SCbuNHUSeGT/dFJDuNd9Smggl83p5xreoi6qi7RMviTpVFzukl3xDZgSyGJ67ihswNkQghHBYeZcRgxID+8kKfC9DQkRa8t07/XtJP4Rq4CUBEPhS1DxN6/pDgxqW9mGvfQJRB2tQ/AyOHxCiaZ1ZBSq5vxL9ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709625976; c=relaxed/simple;
	bh=4MyHWx6WJ2dSAn3e+131RFurYfJNPua0V7S+Sz93q6U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MpBWc29R4/0BRwiw/1/BNvMFyYkyakZ707g4syC71XYGQHBSnQY66bKhm5WDWASaeLW4Fw3mwEUU3SNf70Rd0vKzSGfXGgzDbYOMMVpkgppOAmyk9wl/U5JcFf5GrPu6/jXwjo3X02EWnrUio8671LwpCATqfWyP9jySyxq8zTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lza9QL+S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lza9QL+S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709625973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cRRPoViki63qm7Pnqx/HO7LHcA0o0KblBv1fRsjeFSY=;
	b=Lza9QL+S4dqwI7kLPqMxxQLDAtSTfwxAh0zquzQ+FqvmmPDqekJr9yPpEcyalx+S6biZp1
	C+oHLrrhTVe/vujSvuU5WWlmauaWaxswPK+gKj39lVzFvAAOC/c0QfnpcTINFgNJAmTXHr
	Fa6U1FeLx8FFUcDB7WLCR3agh6hKOwA=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-570-q49iIKiqPgKxrFo4z21WmQ-1; Tue, 05 Mar 2024 03:06:10 -0500
X-MC-Unique: q49iIKiqPgKxrFo4z21WmQ-1
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-dcd1779adbeso787138276.3
        for <virtio-fs@lists.linux.dev>; Tue, 05 Mar 2024 00:06:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709625970; x=1710230770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cRRPoViki63qm7Pnqx/HO7LHcA0o0KblBv1fRsjeFSY=;
        b=naV/8CjFnoFr281+riAmVK25Pv90HHpR8Eb2vmhpfMrJoRfzj96QRwri2tBoGS5O/S
         CJ+zqQoXbSUzN/MucRKX31dhP+dm6haMaD+JVn2XcZmr6Yhv7BhPSmKi7VZ7/Hajfs/t
         LgvTkecvHUldCa3a0WLMc3QNbkLi5MxGJLtDc5+2pQi8J0+wTu+0pyUmZXs2bfbp2jxF
         /+F/AMvhYm4k3Xyy0MVbcZPg2xqMMeILJwZTeptgw1V3uhNbYyOQ2t1lPNur8Idx9ATr
         g3XGlqHhAai80GnZ0cfIkq88z6kOv+ngXNQjIf1CuYCMd1wwcZer+j5NSDNQdg8NKhGu
         tG0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXQ/0BsxCv/OwLYNxiiNuPAittC5HrfpGVXVUZi64JNcx0/NObv1JLdWGFvpD8FTy2fWWkw88u7g8gq8P1NvtmaOMugdrrMrv2c
X-Gm-Message-State: AOJu0YxR8MvJOTtS6QUMBJaARwe8wSwJIV+FK91fNf6ZKN/WusS5jBet
	Sk50/T4LHB9ozolQAIraooM7kpmeypiEY9/l4ynM0mwCYdodHKUEIhxs2bTwnL4DLo0w9yLmgL2
	YOv3cKnRCYmxQni8ukoGe1oAQWpEwwB2n2S9+kTV8a7iNEdKG8GhJpYYWYL1eiFQSsFl8dnMxB+
	5hoYSKfV72xi1/gYjlwzYFBfBZSezl7QpT
X-Received: by 2002:a25:6645:0:b0:dc7:32ea:c89f with SMTP id z5-20020a256645000000b00dc732eac89fmr9247230ybm.15.1709625970032;
        Tue, 05 Mar 2024 00:06:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGugrxHL2sIY5QLA6tQbPvVtgO/26HzPW3QY1YMP/uardUs/mAkNQfpvfGghjGyh34jCCAxPtV7w7chgeiZbXs=
X-Received: by 2002:a25:6645:0:b0:dc7:32ea:c89f with SMTP id
 z5-20020a256645000000b00dc732eac89fmr9247216ybm.15.1709625969819; Tue, 05 Mar
 2024 00:06:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304194612.611660-1-jonah.palmer@oracle.com> <20240304194612.611660-5-jonah.palmer@oracle.com>
In-Reply-To: <20240304194612.611660-5-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 5 Mar 2024 09:05:33 +0100
Message-ID: <CAJaqyWeFKL-UaQvtURxVw3FHtBcvL-hsB081rWf=FWa_yqtfgA@mail.gmail.com>
Subject: Re: [PATCH v1 4/8] virtio-mmio: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, jasowang@redhat.com, 
	si-wei.liu@oracle.com, boris.ostrovsky@oracle.com, raphael@enfabrica.net, 
	kwolf@redhat.com, hreitz@redhat.com, pasic@linux.ibm.com, 
	borntraeger@linux.ibm.com, farman@linux.ibm.com, thuth@redhat.com, 
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com, 
	cohuck@redhat.com, pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com, 
	qemu-block@nongnu.org, qemu-s390x@nongnu.org, virtio-fs@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 4, 2024 at 8:46=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.co=
m> wrote:
>
> Prevent ioeventfd from being enabled/disabled when a virtio-mmio device
> has negotiated the VIRTIO_F_NOTIFICATION_DATA transport feature.
>
> Due to ioeventfd not being able to carry the extra data associated with
> this feature, the ioeventfd should be left in a disabled state for
> emulated virtio-mmio devices using this feature.
>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  hw/virtio/virtio-mmio.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/hw/virtio/virtio-mmio.c b/hw/virtio/virtio-mmio.c
> index f99d5851a2..f42ed5c512 100644
> --- a/hw/virtio/virtio-mmio.c
> +++ b/hw/virtio/virtio-mmio.c
> @@ -421,7 +421,8 @@ static void virtio_mmio_write(void *opaque, hwaddr of=
fset, uint64_t value,
>          virtio_update_irq(vdev);
>          break;
>      case VIRTIO_MMIO_STATUS:
> -        if (!(value & VIRTIO_CONFIG_S_DRIVER_OK)) {
> +        if (!(value & VIRTIO_CONFIG_S_DRIVER_OK) &&
> +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) =
{
>              virtio_mmio_stop_ioeventfd(proxy);
>          }
>
> @@ -433,7 +434,8 @@ static void virtio_mmio_write(void *opaque, hwaddr of=
fset, uint64_t value,
>
>          virtio_set_status(vdev, value & 0xff);
>
> -        if (value & VIRTIO_CONFIG_S_DRIVER_OK) {
> +        if ((value & VIRTIO_CONFIG_S_DRIVER_OK) &&
> +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) =
{
>              virtio_mmio_start_ioeventfd(proxy);
>          }
>
> --
> 2.39.3
>

