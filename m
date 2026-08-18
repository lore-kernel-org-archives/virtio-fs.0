Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93009221546
	for <virtio-fs@lists.linux.dev>; Tue, 18 Aug 2026 12:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787056556; cv=none; b=eKAJCmxoQtpBiCgqz+hzM9wgHIesh+gKV4NYmHu1imEhxPmd91ilK67wYF2DKxDEdref9plvRWVvgMFN8FHtbWsU7FeSzp8zdYglfNh+jXjniQHu/brqbSFejpBVQrwZIdp/MzFccZtbk4tdZYLHy7JsDWcfL0ey18zETczZhQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787056556; c=relaxed/simple;
	bh=H86VwNk9z2BZmnoZ+lgAjzlZTCaeatgJ+VHhGwVRDqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=inU7u57H18ntiaz8WBdlnBBlD1VnHkhM6qf0xuOVS5YDGulu2lGuMsKPBMu2MKkVXFXiUqD100oPyuTrN5NfMFKks7pBFTXMm6LvgA0vnjSjP0FjmDssiR/dXzZWpHTO9LLDHt3SmzBne8CW8rU91w49X1/Rpiwci3Ry22J8ZhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=r3WyYSTk; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="r3WyYSTk"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 67ICYwMb092544
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 18 Aug 2026 21:34:58 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=LUeb38oMvvESBEacWa+JwwNRjf77ZX6fuQUxFwXE74w=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1787056498; v=1;
        b=r3WyYSTkKKLZVNJZ9ziyNTDdeJ6W7AkVZk4NmAcdQvdNoGs0v1Ww3wrFvq1g+OXw
         lp9I0M+K/L22+958hR5B4b1PenmoJH0XlMt9ErdiGqWWVF18TA+e0y1xeQG8Rf5i
         mpERmlG6IhdSVuuOk7EThxUzCK/WNqxZkYADmAFuFh21q69bTIpIPLMsf0ZXvjmG
         RfsQWxce8YqXjbiN4ir3p4mpeE+PFC24sZbsSgF0DD3kPpxNsOZwS1BHcuK9/yp1
         Zg8en8zfNpbxippYicCFDglQ6N8MXcshEP9e0lBkwcsv0tGi/9Xo4JGZo26bup1u
         za3nLjpDg5DFJHlCK7RqSg==
Message-ID: <7b4d2e3d-4593-492c-887a-db560d590ac6@rsg.ci.i.u-tokyo.ac.jp>
Date: Tue, 18 Aug 2026 21:34:58 +0900
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 09/13] hw/virtio/vhost-user: add shadow virtqueues
 and eventfd intercepts
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
 <20260817-vhost-user-isolated-memory-v2-9-948aae960abb@gmail.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-9-948aae960abb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/08/18 14:12, Connor Kite wrote:
> Adds shadow virtqueues that will eventually be used to transfer data
> between device and host via bounce buffers when isolation mode is
> active.  The svqs are initalized, and eventfd assignments are
> intercepted so that notifications come to svqs first before
> the guest or backend receive them.
> 
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-user.c | 136 ++++++++++++++++++++++++++++++++++++++++++-------
>   1 file changed, 119 insertions(+), 17 deletions(-)
> 
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index e1e5cba53d..ace328f5eb 100644
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
> @@ -331,6 +332,7 @@ typedef struct {
>       size_t size; /* size of the mapped shared memory */
>       int fd; /* descriptor of anonymous file backing shared iso region */
>       Int128 iso_iova_offset; /* translation from IOVA to hva of iso region */
> +    GPtrArray *shadow_vqs; /* shadow vqs with vrings in iso region*/

A whitespace problem remains here.

>   } IsolationModeCtx;
>   
>   struct vhost_user {
> @@ -1128,15 +1130,38 @@ static int vhost_user_set_mem_table_postcopy(struct vhost_dev *dev,
>       return 0;
>   }
>   
> -static void cleanup_isolation_regions(struct vhost_dev *dev)
> +static void vhost_user_svq_cleanup(struct vhost_user *u, bool reset)
> +{
> +    VhostShadowVirtqueue *svq;
> +    for (int i = 0; i < u->iso_mem_ctx.shadow_vqs->len; i++) {
> +        svq = g_ptr_array_index(u->iso_mem_ctx.shadow_vqs, i);
> +        vhost_svq_stop(svq);
> +        event_notifier_cleanup(&svq->hdev_call);
> +        event_notifier_cleanup(&svq->hdev_kick);
> +    }
> +
> +    if (!reset) {
> +        g_ptr_array_free(u->iso_mem_ctx.shadow_vqs, true);
> +    }
> +}
> +
> +static void cleanup_isolation_regions(struct vhost_dev *dev, bool reset)
>   {
>       struct vhost_user *u = dev->opaque;
>       if (u->iso_mem_ctx.shared_mem_addr) {

If vhost_dev_init() fails after vhost_user_init_svq(), shadow_vqs is 
present but shared_mem_addr is not because init_isolation_regions() is 
not called yet. shadow_vqs will be leaked then.

> +        vhost_user_svq_cleanup(u, reset);
>           vhost_iova_tree_delete(u->iso_mem_ctx.tree);
>           qemu_memfd_free(u->iso_mem_ctx.shared_mem_addr,
>                           u->iso_mem_ctx.size,
>                           u->iso_mem_ctx.fd);
> +
> +        GPtrArray *temp = u->iso_mem_ctx.shadow_vqs;

This is a mixed declaration prohibited in docs/devel/style.rst

>           memset(&u->iso_mem_ctx, 0, sizeof(IsolationModeCtx));
> +
> +        if (!reset) {

This condition is inverted. When reset is true, vhost_user_svq_cleanup() 
retains the array so the pointer to it should be kept.

> +            u->iso_mem_ctx.shadow_vqs = temp;
> +        }> +
>       }
>   }
>   
> @@ -1234,7 +1259,7 @@ static int init_isolation_regions(struct vhost_dev *dev,
>       msg->hdr.request = VHOST_USER_SET_MEM_TABLE;
>   
>       /* In case of reset, clear old regions */
> -    cleanup_isolation_regions(dev);
> +    cleanup_isolation_regions(dev, true);
>   
>       /* Gather information for bounce buffers to be mapped */
>       for (u_int32_t i = 0; i < nregions; i++) {
> @@ -1267,7 +1292,7 @@ static int init_isolation_regions(struct vhost_dev *dev,
>   
>       if (err) {
>           error_report_err(err);
> -        cleanup_isolation_regions(dev);
> +        cleanup_isolation_regions(dev, false);
>           return -1;
>       }
>   
> @@ -1295,7 +1320,7 @@ static int init_isolation_regions(struct vhost_dev *dev,
>                                     (hwaddr)u->iso_mem_ctx.shared_mem_addr);
>   
>       if (r != IOVA_OK) {
> -        cleanup_isolation_regions(dev);
> +        cleanup_isolation_regions(dev, false);
>           return r;
>       }
>   
> @@ -1310,7 +1335,7 @@ static int init_isolation_regions(struct vhost_dev *dev,
>                                             dev->mem->regions[i].guest_phys_addr);
>   
>           if (r != IOVA_OK) {
> -            cleanup_isolation_regions(dev);
> +            cleanup_isolation_regions(dev, false);
>               return r;
>           }
>       }
> @@ -1738,11 +1763,49 @@ static int vhost_set_vring_file(struct vhost_dev *dev,
>       return 0;
>   }
>   
> +static int vhost_user_get_vq_index(struct vhost_dev *dev, int idx)
> +{
> +    assert(idx >= dev->vq_index && idx < dev->vq_index + dev->nvqs);
> +
> +    return idx;
> +}
> +
>   static int vhost_user_set_vring_kick(struct vhost_dev *dev,
>                                        struct vhost_vring_file *file)
>   {
> -    int ret = vhost_set_vring_file(dev, VHOST_USER_SET_VRING_KICK, file);
> +    struct vhost_user *u = dev->opaque;
> +    int svq_idx = file->index - dev->vq_index;
> +    VhostShadowVirtqueue *svq = NULL;
> +    struct vhost_vring_file vr_file = *file;
> +    int ret;
> +
> +    vhost_user_get_vq_index(dev, file->index); /* bounds checking */
> +
> +    if (u->user->memory_isolation) {
> +        svq = g_ptr_array_index(u->iso_mem_ctx.shadow_vqs, svq_idx);
> +        vhost_svq_set_svq_kick_fd(svq, file->fd);

The svq->svq_kick EventNotifier is left set in the error paths.

Regards,
Akihiko Odaki

> +
> +        if (file->fd != -1) {
> +            if (!svq->hdev_kick.initialized) {
> +                ret = event_notifier_init(&svq->hdev_kick, 0);
> +                if (ret < 0) {
> +                    event_notifier_cleanup(&svq->hdev_kick);
> +                    error_report("Failed to create kick event notifier");
> +                    return ret;
> +                }
> +            }
> +
> +            vr_file.fd = event_notifier_get_fd(&svq->hdev_kick);
> +        } else {
> +            event_notifier_cleanup(&svq->hdev_kick);
> +        }
> +    }
> +
> +    ret = vhost_set_vring_file(dev, VHOST_USER_SET_VRING_KICK, &vr_file);
>       if (ret < 0) {
> +        if (svq != NULL) {
> +            event_notifier_cleanup(&svq->hdev_kick);
> +        }
>           return ret;
>       }
>   
> @@ -1750,15 +1813,18 @@ static int vhost_user_set_vring_kick(struct vhost_dev *dev,
>        * Inject a kick in case the back-end only starts vring processing upon
>        * receiving a kick. The spec suggests this to improve compatibility.
>        */
> -    if (file->fd != -1) {
> +    if (vr_file.fd != -1) {
>           uint64_t val = 1;
>           ssize_t nwritten;
>   
>           do {
> -            nwritten = write(file->fd, &val, sizeof(val));
> +            nwritten = write(vr_file.fd, &val, sizeof(val));
>           } while (nwritten < 0 && errno == EINTR);
>   
>           if (nwritten < 0 && errno != EAGAIN /* back-end can already read */) {
> +            if (svq != NULL) {
> +                event_notifier_cleanup(&svq->hdev_kick);
> +            }
>               return -errno;
>           }
>       }
> @@ -1769,7 +1835,35 @@ static int vhost_user_set_vring_kick(struct vhost_dev *dev,
>   static int vhost_user_set_vring_call(struct vhost_dev *dev,
>                                        struct vhost_vring_file *file)
>   {
> -    return vhost_set_vring_file(dev, VHOST_USER_SET_VRING_CALL, file);
> +    struct vhost_user *u = dev->opaque;
> +    int svq_idx = file->index - dev->vq_index;
> +    VhostShadowVirtqueue *svq = NULL;
> +    struct vhost_vring_file vr_file = *file;
> +    int ret;
> +
> +    vhost_user_get_vq_index(dev, file->index); /* bounds checking */
> +
> +    if (u->user->memory_isolation) {
> +        svq = g_ptr_array_index(u->iso_mem_ctx.shadow_vqs, svq_idx);
> +        vhost_svq_set_svq_call_fd(svq, file->fd);
> +
> +        if (file->fd != -1) {
> +            if (!svq->hdev_call.initialized) {
> +                ret = event_notifier_init(&svq->hdev_call, 0);
> +                if (ret < 0) {
> +                    event_notifier_cleanup(&svq->hdev_call);
> +                    error_report("Failed to create call event notifier");
> +                    return ret;
> +                }
> +            }
> +
> +            vr_file.fd = event_notifier_get_fd(&svq->hdev_call);
> +        } else {
> +            event_notifier_cleanup(&svq->hdev_call);
> +        }
> +    }
> +
> +    return vhost_set_vring_file(dev, VHOST_USER_SET_VRING_CALL, &vr_file);

Clean up svq->hdev_call when this fails.

>   }
>   
>   static int vhost_user_set_vring_err(struct vhost_dev *dev,
> @@ -2763,6 +2857,17 @@ static int vhost_user_postcopy_notifier(NotifierWithReturn *notifier,
>       return 0;
>   }
>   
> +static void vhost_user_init_svq(struct vhost_dev *dev, struct vhost_user *u)
> +{
> +    /*Modified from vhost-vdpa*/
> +    u->iso_mem_ctx.shadow_vqs = g_ptr_array_new_full(dev->nvqs, vhost_svq_free);
> +    for (int i = 0; i < dev->nvqs; i++) {
> +        VhostShadowVirtqueue *svq;
> +        svq = vhost_svq_new(NULL, NULL);
> +        g_ptr_array_add(u->iso_mem_ctx.shadow_vqs, svq);
> +    }
> +}
> +
>   static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
>                                      Error **errp)
>   {
> @@ -2907,6 +3012,10 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
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
> @@ -2935,20 +3044,13 @@ static int vhost_user_backend_cleanup(struct vhost_dev *dev)
>       g_free(u->region_rb_offset);
>       u->region_rb_offset = NULL;
>       u->region_rb_len = 0;
> -    cleanup_isolation_regions(dev);
> +    cleanup_isolation_regions(dev, false);
>       g_free(u);
>       dev->opaque = 0;
>   
>       return 0;
>   }
>   
> -static int vhost_user_get_vq_index(struct vhost_dev *dev, int idx)
> -{
> -    assert(idx >= dev->vq_index && idx < dev->vq_index + dev->nvqs);
> -
> -    return idx;
> -}
> -
>   static int vhost_user_memslots_limit(struct vhost_dev *dev)
>   {
>       struct vhost_user *u = dev->opaque;
> 

