Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A908433E61
	for <virtio-fs@lists.linux.dev>; Fri, 24 Jul 2026 13:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900763; cv=none; b=dP3QK8q2FtkZW++OFAk3h1BSONZOFWUdGT1Tz/J6ro09kYtY1TCM5TLkJixUXy72ZbFCuTN3l5rbjbTxXRgMqbO6H/WAdf0a6tEAz4tByQHduK2B9R5tOATu2KTCMQ9yQYDnzFkj/ZTLpwrJnsi0U3Dp1PBNAiYfKEbuBqggLW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900763; c=relaxed/simple;
	bh=qFpor79lXCY4Pxn0Q51TVFAu2udDrg1BCXIxNsrKQ0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nxn7IcuzDxTXtiP/phJygbHWH+9GX7ENMA0MrnCKuscW7q2hVY/K5anZYNm1OjkKv0/tm63BL8RhPzzk+v8F/PHIwCYch6K+47fdzpoTCcZVnzqTupvMHEL2aBOTuoYzwI0SvDNo5uFpln1iy3I3/OvJnqtzC1hRcuWalGH+Rec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=PP1G0Esf; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="PP1G0Esf"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66ODjQaC096366
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 24 Jul 2026 22:45:26 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=QMM9s/pspcGf+yijGeRsi/GEP1Gw467iZ1bFMPZ/R+U=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1784900727; v=1;
        b=PP1G0EsfioGKROeVvy6up9AF4t09xfnFDs2/oq9aVA/ODsDPvQEM/yAB+uayf4xr
         0hvpY6wzhPwAgT+pwIgfXIACvW0g+kHGIZMpacyE6tXneKnm/gMVrhdRu+4DHDGb
         +0gDzaCQLBHp5cX/hZAU3tuXH8dJDrZ2zW2Xisym4mEAOMhryUs7yeqCoQWn9/gc
         u3J7RgqLXWxpblsD92zTXskU9G+29fRJf2/QHf1Wt0psBi9DN3mZPDgbV7ZFSKNf
         n1syUhQFMKQFEFo4RkNk31r9Tv5U4PIBMkrKMmIm2jHvAYxiAvBir069lXZfKouA
         lV8KxcJAhffqeiwXHkgwxg==
Message-ID: <82cd1e6f-85f8-409d-9214-00c696fbdcae@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 24 Jul 2026 22:45:26 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 13/15] hw/virtio/vhost-user: add shadow virtqueues and
 eventfd intercepts
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
 <20260723-vhost-user-isolated-memory-v1-13-6b97c439eb28@gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-13-6b97c439eb28@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/07/24 7:30, Connor Kite wrote:
> Adds shadow virtqueues that will eventually be used to transfer data
> between device and host via bounce buffers when isolation mode is
> active.  The svqs are initalized, and eventfd assignments are
> intercepted so that notifications come to svqs first before
> the guest or backend receive them.
> 
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-user.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 54 insertions(+)
> 
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index acabfb7f1c..75858289a2 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -18,6 +18,7 @@
>   #include "hw/virtio/vhost-backend.h"
>   #include "hw/virtio/virtio.h"
>   #include "hw/virtio/virtio-net.h"
> +#include "hw/virtio/vhost-shadow-virtqueue.h"
>   #include "hw/virtio/vhost-iova-tree.h"
>   #include "chardev/char-fe.h"
>   #include "io/channel-socket.h"
> @@ -365,7 +366,9 @@ struct vhost_user {
>   
>       /* Isolated memory data*/
>       struct IsolationRegion iso_memory;
> +    GPtrArray *shadow_vqs;
>       VhostIOVATree *iso_iova_tree;
> +    bool svqs_allocated;
>   };
>   
>   struct scrub_regions {
> @@ -1693,6 +1696,24 @@ static int vhost_set_vring_file(struct vhost_dev *dev,
>   static int vhost_user_set_vring_kick(struct vhost_dev *dev,
>                                        struct vhost_vring_file *file)
>   {
> +    struct vhost_user *u = dev->opaque;
> +    int svq_idx = file->index - dev->vq_index;
> +    if (u->user->memory_isolation) {
> +        VhostShadowVirtqueue *svq = g_ptr_array_index(u->shadow_vqs,
> +                                                      svq_idx);
> +        vhost_svq_set_svq_kick_fd(svq, file->fd);

This is not undone in case of errors.

> +
> +        if (svq->hdev_kick.initialized == false) {

Simpler: if (!svq->hdev_kick.initialized)

Regards,
Akihiko Odaki

> +            int r = event_notifier_init(&svq->hdev_kick, 0);
> +            if (r) {
> +                error_report("Failed to create kick event notifier");
> +                return r;
> +            }
> +        }
> +
> +        file->fd = event_notifier_get_fd(&svq->hdev_kick);
> +    }
> +
>       int ret = vhost_set_vring_file(dev, VHOST_USER_SET_VRING_KICK, file);
>       if (ret < 0) {
>           return ret;
> @@ -1721,6 +1742,24 @@ static int vhost_user_set_vring_kick(struct vhost_dev *dev,
>   static int vhost_user_set_vring_call(struct vhost_dev *dev,
>                                        struct vhost_vring_file *file)
>   {
> +    struct vhost_user *u = dev->opaque;
> +    int svq_idx = file->index - dev->vq_index;
> +    if (u->user->memory_isolation) {
> +        VhostShadowVirtqueue *svq = g_ptr_array_index(u->shadow_vqs,
> +                                                      svq_idx);
> +        vhost_svq_set_svq_call_fd(svq, file->fd);
> +
> +        if (svq->hdev_call.initialized == false) {
> +            int r = event_notifier_init(&svq->hdev_call, 0);
> +            if (r) {
> +                error_report("Failed to create call event notifier");
> +                return r;
> +            }
> +        }
> +
> +        file->fd = event_notifier_get_fd(&svq->hdev_call);
> +    }
> +
>       return vhost_set_vring_file(dev, VHOST_USER_SET_VRING_CALL, file);
>   }
>   
> @@ -2715,6 +2754,17 @@ static int vhost_user_postcopy_notifier(NotifierWithReturn *notifier,
>       return 0;
>   }
>   
> +static void vhost_user_init_svq(struct vhost_dev *dev, struct vhost_user *u)
> +{
> +    /*Modified from vhost-vdpa*/
> +    u->shadow_vqs = g_ptr_array_new_full(dev->nvqs, vhost_svq_free);
> +    for (int i = 0; i < dev->nvqs; i++) {
> +        VhostShadowVirtqueue *svq;
> +        svq = vhost_svq_new(NULL, NULL);
> +        g_ptr_array_add(u->shadow_vqs, svq);
> +    }
> +}
> +
>   static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
>                                      Error **errp)
>   {
> @@ -2859,6 +2909,10 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
>       u->postcopy_notifier.notify = vhost_user_postcopy_notifier;
>       postcopy_add_notifier(&u->postcopy_notifier);
>   
> +    if (vus->memory_isolation) {
> +        vhost_user_init_svq(dev, u);
> +    }
> +
>       return 0;
>   }
>   
> 

