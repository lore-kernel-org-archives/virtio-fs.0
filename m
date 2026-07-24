Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44767427FAE
	for <virtio-fs@lists.linux.dev>; Fri, 24 Jul 2026 11:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784892615; cv=none; b=A4HycZGwO1SFixqlfR306l9KOwbn/1JP671BcnCrkQ3xljIDXsoL7/HipilfTKZc8HnlDmSjs33AfpPVJI2Atm72Kl6jzX6/a3it+7NdDUNke2v8+ZuZimqFrGpC4VtHUaxFwF8lpyqhM83JTwLqCbHSD6r2CgNLqxoqQHOTmKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784892615; c=relaxed/simple;
	bh=YEAPjO5I/xyTwO05ptdOj5+PjEj+Nsa2PQdsWfK735Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tC4CO1HmHGajhhfxDUThwiKBO4fT2DI6erqMnWhzNmH+BEv7i1KETYVj8uulTS0BBGx7ZeddzeW5L0iiwjFCMITDFxVk7V5GDcqVvh8fwIUb2t+fC8/eAzQ1wvML0twG6knr/eWo9xyiWTA07VV4GwK5WkrABYumNKAbMEBDT9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=oHX4FvQc; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="oHX4FvQc"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66OBTeRw049149
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 24 Jul 2026 20:29:40 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=KQEdpGK6qEh+mRDMrPf5BYAsaWyjPNFWeftFntzzLWQ=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1784892580; v=1;
        b=oHX4FvQciSvoAPLlARCr4EVP3n0scqc9mliR9HuFJJRsrnBPZxcy3Imhw8m6OJlv
         QIXteqnG2WcACuo273aBhEYvaOLFOKMO9ZmmirTLcg7cRYiRfZM/lUN4+3f1RKPH
         nfjrfhhF8oritGkqIZnZeWBHwS96o0i3I2E5eZzT17lyRPXEw3qYPtCpGnQ93Vn6
         rMArVsyzQirwBXsenxvM2juD8VOkuXfpw/qEEKScJ3YOrhMQooCXzbk6OsaBY4aB
         NcK22r/t4FImzi8xBOdGqUj+WLaSuJKSew41lMUv4YzSCXXtLocIKo3gSdH5Xseq
         WyTKhVDO27WAE4/PwyrcaA==
Message-ID: <764a6acb-cf8e-49a1-8efb-320c40b17a3a@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 24 Jul 2026 20:29:39 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 08/15] hw/virtio/vhost-shadow-virtqueue: used handler
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
 <20260723-vhost-user-isolated-memory-v1-8-6b97c439eb28@gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-8-6b97c439eb28@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/07/24 7:30, Connor Kite wrote:
> Adds a handler callback to shadow virtqueues in order to enable
> non-default processing of used vring elements from the device.
> 
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-shadow-virtqueue.c |  4 ++++
>   hw/virtio/vhost-shadow-virtqueue.h | 14 ++++++++++++++
>   2 files changed, 18 insertions(+)
> 
> diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
> index bcb7f2ffc7..eb86c1ee37 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.c
> +++ b/hw/virtio/vhost-shadow-virtqueue.c
> @@ -669,6 +669,10 @@ static void vhost_svq_flush(VhostShadowVirtqueue *svq,
>                   break;
>               }
>   
> +            if (svq->ops && svq->ops->used_handler) {
> +                svq->ops->used_handler(svq, elem, svq->ops_opaque);

The error of the handler that may have left elem stale is ignored here.

Regards,
Akihiko Odaki

> +            }
> +
>               if (unlikely(i >= svq->vring.num)) {
>                   qemu_log_mask(LOG_GUEST_ERROR,
>                            "More than %u used buffers obtained in a %u size SVQ",
> diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-virtqueue.h
> index ec16a1e838..ccfeee36d7 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.h
> +++ b/hw/virtio/vhost-shadow-virtqueue.h
> @@ -56,8 +56,22 @@ typedef int (*VirtQueueAvailCallback)(VhostShadowVirtqueue *svq,
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
> + * Returns 0 if the vq is running as expected
> + */
> +typedef int (*VirtQueueUsedCallback)(VhostShadowVirtqueue *svq,
> +                                      VirtQueueElement *elem,
> +                                      void *vq_callback_opaque);
> +
>   typedef struct VhostShadowVirtqueueOps {
>       VirtQueueAvailCallback avail_handler;
> +    VirtQueueUsedCallback used_handler;
>   } VhostShadowVirtqueueOps;
>   
>   /* Shadow virtqueue to relay notifications */
> 

