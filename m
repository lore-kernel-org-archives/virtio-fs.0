Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BF042AF97
	for <virtio-fs@lists.linux.dev>; Fri, 24 Jul 2026 12:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784895582; cv=none; b=kQUIfjy15nCCkEkc6wyNO+fbU3fmHkKnxQm7ipO9q9VrsVeHR0KlrQX9U5K1JVXZqTiptCzeKGDrrwt5jL7XlNxXVZ3SpjId6fYU+99/rbJVH2kPpqjRK0w6i24jLwFRhJpIrxpKiORQI6lrD8+EnqB/SFch+rc+TTsB0S87lDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784895582; c=relaxed/simple;
	bh=VVss65K0wcXzQ1ewnIUmpqtlsncCVSzw9hPKq2Mtwtg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sf/DYPRW3LQ9FbWf/WLD8g7eK5Zs6F7odYslzY0fzBgGnXBymMgixK58R4kM37cSJNuV4VYKJ4SoOpp8ZZriimyXNybvhH7zs54QD8rs/5YQ2i5zoNYSJQKy2A32g9QixPxUcAyagiW3ysJtd4gIOIb/C3VLw13MCS3nY6qlUFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=IGxpr3i/; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="IGxpr3i/"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66OCJ2go066350
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 24 Jul 2026 21:19:02 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=rTqZxBKubC3XWdeFXRGXQBsS8KUymZGaXsJKhcNTDkw=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1784895542; v=1;
        b=IGxpr3i/b2G2uzoBtK8rMeu6dAPbx5mmtVF9gjZyK0ta/GLSxlIHLXo6Wi4pZA5I
         yokFk/K12m84qZU9ezgrUBG7x2vLkloUpyreI/W6fX7Wigarj//Mp3FqVqFljwi4
         PJLtV68yi4idWdHK6O+KemeulRh1kM9cxuMugoUMXOVuRwb7JdvpZv76swsp9H9p
         CPwM5fwQUghJsvLFZ4NicGnu83gDqwXmn3kTKryws4MKj9z/glhSXQ4ZQXkbqPPI
         FrTZCU9ioCKixPqdx7JCQGIXOIO2b7UgAIqYwmLRcpThvvs0qGZs6vB2+3rjbBg2
         CtfrOjqzMchNA4MEmM0Y9w==
Message-ID: <f9125d0a-3258-46f4-93f6-0761a4acdc66@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 24 Jul 2026 21:19:02 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 09/15] hw/virtio/vhost-shadow-virtqueue: specified
 vring placement
To: Connor Kite <connorkite@gmail.com>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
        Haixu Cui <quic_haixcui@quicinc.com>,
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
        Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-9-6b97c439eb28@gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-9-6b97c439eb28@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/07/24 7:30, Connor Kite wrote:
> By default svq vrings are placed in an anonymous memory map. As svqs
> will be leveraged to enable memory isolation in vhost-user, it is useful
> to be able to place the vrings in a shared isolation memory region.
> 
> Adds the option to specify vring placement by providing a vring base
> address before starting the svq.
> 
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-shadow-virtqueue.c | 22 +++++++++++++++-------
>   hw/virtio/vhost-shadow-virtqueue.h |  3 +++
>   2 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
> index eb86c1ee37..9e3c359f50 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.c
> +++ b/hw/virtio/vhost-shadow-virtqueue.c
> @@ -857,14 +857,21 @@ void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
>   
>       svq->vring.num = virtio_queue_get_num(vdev, virtio_get_queue_index(vq));
>       svq->num_free = svq->vring.num;
> -    svq->vring.desc = mmap(NULL, vhost_svq_driver_area_size(svq),
> -                           PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS,
> -                           -1, 0);
>       desc_size = sizeof(vring_desc_t) * svq->vring.num;
> -    svq->vring.avail = (void *)((char *)svq->vring.desc + desc_size);
> -    svq->vring.used = mmap(NULL, vhost_svq_device_area_size(svq),
> -                           PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS,
> -                           -1, 0);
> +    if (svq->base_addr == NULL) {
> +        svq->vring.desc = mmap(NULL, vhost_svq_driver_area_size(svq),
> +                            PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS,
> +                            -1, 0);
> +        svq->vring.avail = (void *)((char *)svq->vring.desc + desc_size);
> +        svq->vring.used = mmap(NULL, vhost_svq_device_area_size(svq),
> +                            PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS,
> +                            -1, 0);
> +    } else {
> +        svq->vring.desc = (void *) svq->base_addr;

Nit: please remove the whitespace between (void *) and svq->base_addr.

> +        svq->vring.avail = (void *)((char *)svq->vring.desc + desc_size);
> +        svq->vring.used = (void *)((char *)svq->base_addr +
> +                          vhost_svq_driver_area_size(svq));
> +    }

Unmapping svq here can lead to use-after-unmapping because the ring is 
not stopped yet. do_vhost_dev_stop() calls do_vhost_virtqueue_stop() 
only after calling hdev->vhost_ops->vhost_dev_start(hdev, false).

>       svq->desc_state = g_new0(SVQDescState, svq->vring.num);
>       if (virtio_vdev_has_feature(svq->vdev, VIRTIO_F_IN_ORDER)) {
>           svq->batch_last.id = VIRTIO_RING_NOT_IN_BATCH;
> @@ -929,6 +936,7 @@ VhostShadowVirtqueue *vhost_svq_new(const VhostShadowVirtqueueOps *ops,
>       event_notifier_init_fd(&svq->svq_kick, VHOST_FILE_UNBIND);
>       svq->ops = ops;
>       svq->ops_opaque = ops_opaque;
> +    svq->base_addr = NULL;
>       return svq;
>   }
>   
> diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-virtqueue.h
> index ccfeee36d7..39f69e6455 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.h
> +++ b/hw/virtio/vhost-shadow-virtqueue.h
> @@ -148,6 +148,9 @@ typedef struct VhostShadowVirtqueue {
>   
>       /* Size of SVQ vring free descriptors */
>       uint16_t num_free;
> +
> +    /* Location assigned to vrings if not in default anon memory map*/

Nit: here please add a whitespace before */

Regards,
Akihiko Odaki

> +    hwaddr *base_addr;
>   } VhostShadowVirtqueue;
>   
>   bool vhost_svq_valid_features(uint64_t features, Error **errp);
> 

