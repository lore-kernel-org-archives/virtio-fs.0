Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DAF26A1AC
	for <virtio-fs@lists.linux.dev>; Wed, 19 Aug 2026 06:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787120663; cv=none; b=NXXb9uQQlb+uJFDv1uPNHWqjSYRjeVRCr+K7mqrcV03rj66qRPe+g6v+v7BlUTqclWRiuaWxKPIKJALS7/oU65XdoNxzJVo4P+Uqx0ln50McApMNlY3uRMA3GKt4eLDNCU06LOr/XbtXHH5Fgpu7N3s9MhcDOIoBv8aCtv7GN7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787120663; c=relaxed/simple;
	bh=cBs5tcjJMEId9ht+3FMMtCGVkH9P2QW6aPM/dtsQe1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P1lGnuXP/vHqODBxJNkyTmU3VO0ArRxYUwNbH4clTYdRgsfZ+VJvEwQ32M0+G5Qa96AM3iMDG1vu8S38ViWEPt647qnDYRpNSgnwr+m3Se8tk2NQZKN7KnLZNX0a72ddKM2xhfT3gr8ySm30O1GFQPX2bJYF03x/MTjnulbRP/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=pV+sgUGc; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="pV+sgUGc"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 67J6NbTN005720
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 19 Aug 2026 15:23:37 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=T3tEXd0syhzyFAfdE1g8TCL6cqnp3afNMsnHjclz8LI=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1787120618; v=1;
        b=pV+sgUGc0ff9swG+SbMY62GQm5+qCGgN14aryaVuB0LxUdjd9ykRrX1f5T5m8pW7
         nCB3oBJ7A47QYwy2b9+UfAAqdalpK3XpDYfXKXYXIbRa/piXYGtPU+D03XOwKBa3
         LvIpxsjFVsR9bIrzWaVsBnmeCfeKUu7pxS0qkKTaGz3bwAyz26GPndUDHnkikbrl
         by4qdxISULmwztMSxeNBhC+CqBXUe/ASeeMKn2P1neLY8ACBd7A4PL2wOKK8J8o9
         DOuZ8NCcMvgTmnSc4iW6ks+VkFuLVHL7gQ7BlnZwVLbaWzATcuKLehpqzdpBRQM2
         eOmi+sZ6I2/QvQ9PwDuOGg==
Message-ID: <b6f79ec9-7842-47ff-b210-855036712547@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 19 Aug 2026 15:23:37 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 04/13] hw/virtio/vhost-shadow-virtqueue: used
 callback
To: Connor Kite <connorkite@gmail.com>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
        Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Milan Zamazal <mzamazal@redhat.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org,
        virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        zhenwei pi <zhenwei.pi@linux.dev>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
        Jason Wang <jasowangio@gmail.com>, Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>,
        Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>,
        20260817233147.2867623-1-connorkite@gmail.com
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
 <20260817-vhost-user-isolated-memory-v2-4-948aae960abb@gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-4-948aae960abb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/08/18 14:12, Connor Kite wrote:
> Adds a callback to shadow virtqueues in order to enable
> non-default processing of used vring elements from the device.
> 
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-shadow-virtqueue.c |  9 +++++++++
>   hw/virtio/vhost-shadow-virtqueue.h | 16 ++++++++++++++++
>   2 files changed, 25 insertions(+)
> 
> diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
> index c8831d52be..496e7e58a3 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.c
> +++ b/hw/virtio/vhost-shadow-virtqueue.c
> @@ -675,6 +675,15 @@ static void vhost_svq_flush(VhostShadowVirtqueue *svq,
>                   break;
>               }
>   
> +            if (svq->ops && svq->ops->used_callback) {
> +                int r = svq->ops->used_callback(svq, elem, svq->ops_opaque);
> +
> +                if (r < 0) {
> +                    /* VQ or handler is broken. Do not set guest notifier */

This comment is extraneous. It is obvious that event_notifier_set() 
below is not called, and it is same with the existing error path below.

What matters here is the difference with the existing error path. Why 
doesn't it call virtqueue_fill() nor virtqueue_flush()? They need to be 
addressed here.

Regards,
Akihiko Odaki

> +                    return;
> +                }
> +            }
> +
>               if (unlikely(i >= svq->vring.num)) {
>                   qemu_log_mask(LOG_GUEST_ERROR,
>                            "More than %u used buffers obtained in a %u size SVQ",
> diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-virtqueue.h
> index ec16a1e838..fd68319fb7 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.h
> +++ b/hw/virtio/vhost-shadow-virtqueue.h
> @@ -56,8 +56,24 @@ typedef int (*VirtQueueAvailCallback)(VhostShadowVirtqueue *svq,
>                                         VirtQueueElement *elem,
>                                         void *vq_callback_opaque);
>   
> +/**
> + * Callback to handle a used buffer
> + *
> + * @svq: Shadow virtqueue
> + * @elem: Element placed in the queue by the device
> + * @vq_callback_opaque: Used to pass arguments to callback
> + *
> + * Returns 0 if the vq is running as expected. Returns a negative errno on
> + * failure.  The callback should not add used elements to the vq shadowed
> + * by the svq as that is done separately after the callback returns.
> + */
> +typedef int (*VirtQueueUsedCallback)(VhostShadowVirtqueue *svq,
> +                                      VirtQueueElement *elem,
> +                                      void *vq_callback_opaque);
> +
>   typedef struct VhostShadowVirtqueueOps {
>       VirtQueueAvailCallback avail_handler;
> +    VirtQueueUsedCallback used_callback;
>   } VhostShadowVirtqueueOps;
>   
>   /* Shadow virtqueue to relay notifications */
> 

