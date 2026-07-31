Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4062BE7DD
	for <virtio-fs@lists.linux.dev>; Fri, 31 Jul 2026 08:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785485005; cv=none; b=ONU+etw+tYumgN2G+KmmhkcMuZ1eswYg9y/Gz6R/SOsPczxzYPvIGaNibh7XJWPw1KcSRhfiG6syOHnpLVM7Z3F6y2n5EbA2O94PuA2z+T/NdKk6KjxhLtMinfxRzUKGp0ec0VUSiF6sjesEA7gpeWY5oH/XYMkz9QaI3HMG4/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785485005; c=relaxed/simple;
	bh=QpIfy3SyLPl9Q/poKCT16HNQkx9w47AUVjeJYOIXzls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=seXaqTLisYcdXcMEUQC91l0huWpLkKridNpAO+DSiFb3vhZWiSVZRy/xO0bTvdKw4t3qbP/ydYr8hs67wYF0Z8kXwC+HPU7FmP4SmhJj7J5D3ow0uWs6L3bWzSDDxayI4ygxVqzAwTaDgrUH/l0m2lUcMy5A28l8nOIYO9NasJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BAYU1c/f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BAYU1c/f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785485002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BytVVY100176dgRFsU3ZMXCvMsAoP9CGt2YQFyjEo08=;
	b=BAYU1c/f/8QK8zGNb9mHBoyIUUEgFtFEqt6hMXZPLseXwoRZtujks1o5hUOqkNf//XWtTl
	K/YQmIHoBLPRbz8QBuCJXol6nqBy4izVyVWPSdQHPui/5oBAuBvAfsJyiisHYfsG/4ZYdQ
	Uyiphfccyh9lx0WtOwY9omANT966Izc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-21-2BJTnr3vPLuRZZ39bmQVYQ-1; Fri,
 31 Jul 2026 04:03:17 -0400
X-MC-Unique: 2BJTnr3vPLuRZZ39bmQVYQ-1
X-Mimecast-MFC-AGG-ID: 2BJTnr3vPLuRZZ39bmQVYQ_1785484994
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63093180044D;
	Fri, 31 Jul 2026 08:03:13 +0000 (UTC)
Received: from redhat.com (unknown [10.44.48.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C60D230002EC;
	Fri, 31 Jul 2026 08:03:03 +0000 (UTC)
Date: Fri, 31 Jul 2026 10:03:01 +0200
From: Kevin Wolf <kwolf@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	virtio-fs@lists.linux.dev, Hanna Reitz <hreitz@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Christian Schoenebeck <qemu_oss@crudebyte.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Dorjoy Chowdhury <dorjoychy111@gmail.com>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Alexander Graf <graf@amazon.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, qemu-block@nongnu.org,
	Greg Kurz <groug@kaod.org>, Raphael Norwitz <rnorwitz@nvidia.com>,
	Eric Auger <eric.auger@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Kuan-Wei Chiu <visitorckw@gmail.com>, Amit Shah <amit@kernel.org>
Subject: Re: [PATCH v2 2/2] virtio: use Error for queue size validation in
 virtio_add_queue()
Message-ID: <amxWta_aGJnb6lPE@redhat.com>
References: <20260730205846.19479-1-stefanha@redhat.com>
 <20260730205846.19479-3-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260730205846.19479-3-stefanha@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 86gbl0kJvDpo90L9qRi35z6C5b-cG8GcKerVTMrtbag_1785484994
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Am 30.07.2026 um 22:58 hat Stefan Hajnoczi geschrieben:
> Coverity is unhappy with the code path where the x-override-queue-size
> property value is passed to g_new0() since it is a signed int rather
> than an unsigned int:
> 
>       *** CID 1664271:         Error handling issues  (NEGATIVE_RETURNS)
>       /builds/qemu-project/qemu/hw/virtio/virtio.c: 2595             in virtio_add_queue()
>       2589         }
>       2590
>       2591         vdev->vq[i].vring.num = queue_size;
>       2592         vdev->vq[i].vring.num_default = queue_size;
>       2593         vdev->vq[i].vring.align = VIRTIO_PCI_VRING_ALIGN;
>       2594         vdev->vq[i].handle_output = handle_output;
>       >>>     CID 1664271:         Error handling issues  (NEGATIVE_RETURNS)
>       >>>     "__n" is passed to a parameter that cannot be negative.
>       2595         vdev->vq[i].used_elems = g_new0(VirtQueueElement, queue_size);
> 
> Introduce an Error **errp argument to virtio_add_queue() and set it when
> the queue_size argument or the x-override-queue-size property value are
> invalid.
> 
> At the moment none of the callers propagate the Error object. Instead
> they are all modified to pass &error_abort so that the error message is
> printed and the program terminates (it also terminated before). Further
> work, especially in new device emulation code, could actually propagate
> the Error object but is left for the future.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

What's the point of adding an Error object when not even a single caller
makes use of it?

At least the semantic change in virtio_add_queue() (checking if override
is valid) should be a separate patch from the refactoring that pushes
the existing &error_abort into all callers.

> @@ -2574,15 +2575,43 @@ VirtQueue *virtio_add_queue(VirtIODevice *vdev, unsigned int queue_size,
>              break;
>      }
>  
> -    if (i == VIRTIO_QUEUE_MAX || queue_size > VIRTQUEUE_MAX_SIZE)
> -        abort();
> +    if (i == VIRTIO_QUEUE_MAX) {
> +        error_setg(errp, "Exceeded maximum number of virtqueues (%d)", i);
> +        return NULL;
> +    }
> +
> +    if (queue_size > VIRTQUEUE_MAX_SIZE) {
> +        error_setg(errp, "Virtqueue size %u exceeds the max (%u)",
> +                   queue_size, VIRTQUEUE_MAX_SIZE);
> +        return NULL;
> +    }
>  
>      BusState *qbus = qdev_get_parent_bus(DEVICE(vdev));
>      if (qbus && qbus->parent &&
>          object_property_find(OBJECT(qbus->parent), VIRTIO_QUEUE_SIZE_OVERRIDE)) {
>          int override = object_property_get_int(OBJECT(qbus->parent),
>                                                 VIRTIO_QUEUE_SIZE_OVERRIDE,
> -                                               &error_abort);
> +                                               errp);
> +
> +        if (*errp) {
> +            return NULL;
> +        }
> +        if (override < 0) {
> +            /*
> +             * The property type should be UINT16, so this can't happen, but
> +             * help out Coverity.
> +             */
> +            error_setg(errp, "%s (%d) cannot be negative",
> +                       VIRTIO_QUEUE_SIZE_OVERRIDE, override);
> +            return NULL;
> +        }

Wouldn't it be more proper to use object_property_get_uint() instead of
getting an unsigned property as signed and then checking for negative
values?

> +        if (override > VIRTQUEUE_MAX_SIZE) {
> +            error_setg(errp, "%s (%d) exceeds the max (%d)",
> +                       VIRTIO_QUEUE_SIZE_OVERRIDE, override,
> +                       VIRTQUEUE_MAX_SIZE);
> +            return NULL;
> +        }
> +
>          if (override) {
>              queue_size = override;
>          }

Kevin

