Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD31373BE6
	for <virtio-fs@lists.linux.dev>; Fri, 28 Aug 2026 12:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787919395; cv=none; b=j/7vOXx6Quuqk+mXXjcqjUOZr39Hclqfg+TmqScZBn3/YKurV86q8ccNSmV6PxWS96Y0Y3JfrLqhVPejglpNaWYENCk5P/EK7Q97Rl6Du37QQ4pgAjF/a6OBuE2fezqnN9606GoofIC9luE7XXGyM9YfxtVpmO/+SoGnS90BK00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787919395; c=relaxed/simple;
	bh=ZM2HAzMtB1fziR+eMeoSLoWTGf7cwPuECYh0S5mpKSk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FtFayQ/DaVtwrfTQ5fjU22CkJyk+Zq7kXJv2TjrlqtLxiDOEeuvOpC4ihR+Er6tzi2bYLMpUqkpSdNuonhUNeh/l0yM41g7s/qSIVNalMHV4rCDnYsExqbEi/Eg7qKVA2cNWbHWuGWRY/RxJP8ctmQWiAo9ZBCTlDPi/MRHXRSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ets9WLvz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ets9WLvz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787919383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NP7iQyp3d3npFz2QPR3YGYYaTucClh7lCRmDMNIgu4s=;
	b=ets9WLvzQvsak3McveHkpiOZnxVVZOTmxhHkIgUxZpG2M0WECX60mYTwTLNE2n2IvRPhf2
	tz5QGrKemptOiIOAAd/j6H4wORb6vaIB9RXK+V93KJb5uwS8kQTLb6lZbs9UeuS8FVQ4wh
	jxAl6m+0qftsPHH+ce3BKvS8QwV6oDw=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-JLJXuXmiOoygAKQah7P-NA-1; Fri, 28 Aug 2026 08:16:22 -0400
X-MC-Unique: JLJXuXmiOoygAKQah7P-NA-1
X-Mimecast-MFC-AGG-ID: JLJXuXmiOoygAKQah7P-NA_1787919382
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-81e6bb29581so12002577b3.2
        for <virtio-fs@lists.linux.dev>; Fri, 28 Aug 2026 05:16:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787919382; x=1788524182;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NP7iQyp3d3npFz2QPR3YGYYaTucClh7lCRmDMNIgu4s=;
        b=W8E4bBsDZ6GJSuOLven+5TAqoraZMbKZr+Beiw0GJdehDICrayDPtVygtCt7cCDemo
         vz0SRG9Mgayt9lnVipmGQbwBszzljQ3CEYAyvBse4VZsvW80GZiD1IUOIlg9C7d/bzKB
         w972cY37twsj2No6yj9qR44Yy+z38xYpkPKU7OGpDKwyyF22XWbmNB/ldM7KNv1mqooZ
         a07xRamfM6Gul3wfgNTLbbnvGeyQBipZ9rP+RYi/b/m3rVd7p53Psz4kaldOU0pKd7+J
         X4g1qc9LzLPEk+ySLfXjIFUIYksJuv1AU5rxF+7gkn9UNesiLsy92cdXk2sKjC2BcU7V
         7PzQ==
X-Forwarded-Encrypted: i=1; AKwUvByHm10cEg+tti9RyV1EJuet9RZXYzr/OSVP/pesY25DcxQJgMcMhltVMMlhG63xfcbwJ76hl7zWGTM=@lists.linux.dev
X-Gm-Message-State: AFuF++kgUBpFLBuBmiSd0tM8SHRsPlqAuI9bKxubw/UDR7zLhXUxOsEU
	6n6rnUS6oVaZY73kytESD3CISQWq9wxjFVibQAWEGnA5vxAGdjaIDKV+Bgqv6QNPtenxPnxjrfw
	TepFPSqLBf/MwNRN8hja6n/8aYeGPlwHcSXjxVZKj3tb5Ky5eBbT1aN9iMv6SpLxp8i0bfjlpYJ
	goE8+MAHLu8LN+wjSmqSyTrAXRZxurJW4TVLbg
X-Gm-Gg: AYBFou3NAcsHGw2RO2Ot2HthGqgBwlrSa9p8gcSWVcV/WqlJuNrgarAZa1zVLBpirDu
	TQNnTCZDugYGAojjaMgM1gaUkY2Rwv6C34Jq54m4Tjfg97RaC1aCNNb+VRaOGXnwaSMziDDdqrm
	4ssK7Ti6LOLUlmuAYY1xSOgx2k4lqKB90znljb71b8LiKyRICdIrxnssVMDXYdBVRluXdlhPAI4
	hoJzLgPaqcu2FBq/cqg5ZYCA/x1YbD4LV8kdsxaqq/7QxFgeBMLvU9ocXE=
X-Received: by 2002:a05:690c:c4f1:b0:814:585f:73c8 with SMTP id 00721157ae682-85d5feceaf2mr28516247b3.0.1787919381642;
        Fri, 28 Aug 2026 05:16:21 -0700 (PDT)
X-Received: by 2002:a05:690c:c4f1:b0:814:585f:73c8 with SMTP id
 00721157ae682-85d5feceaf2mr28515827b3.0.1787919381156; Fri, 28 Aug 2026
 05:16:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com> <20260817-vhost-user-isolated-memory-v2-5-948aae960abb@gmail.com>
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-5-948aae960abb@gmail.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 28 Aug 2026 14:15:44 +0200
X-Gm-Features: AcwNN1V9jSnTneck_2Wd0unjGb7Spui0y8bYGe2l7i_08vxr2fE-rAM-G89C-Us
Message-ID: <CAJaqyWcO3bSakzykPr-p=eBrqntNaTdUuvZdo2-B_DVxrt6wjw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 05/13] hw/virtio/vhost-shadow-virtqueue: specified
 vring placement
To: Connor Kite <connorkite@gmail.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, Alyssa Ross <hi@alyssa.is>, 
	Demi Marie Obenour <demiobenour@gmail.com>, 20260817233147.2867623-1-connorkite@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OCW4x2vgs73pyhvTjtfxh6F8q7wqvbZ-wETCyMDACAs_1787919382
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 7:12=E2=80=AFAM Connor Kite <connorkite@gmail.com> =
wrote:
>
> By default svq vrings are placed in an anonymous memory map. As svqs
> will be leveraged to enable memory isolation in vhost-user, it is useful
> to be able to place the vrings in a shared isolation memory region.
>
> Adds the option to specify vring placement by providing a vring base
> address before starting the svq.
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>  hw/virtio/vhost-shadow-virtqueue.c | 69 ++++++++++++++++++++++++++++++++=
------
>  hw/virtio/vhost-shadow-virtqueue.h |  8 ++++-
>  2 files changed, 66 insertions(+), 11 deletions(-)
>
> diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-=
virtqueue.c
> index 496e7e58a3..f54a61439a 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.c
> +++ b/hw/virtio/vhost-shadow-virtqueue.c
> @@ -812,6 +812,13 @@ size_t vhost_svq_device_area_size(const VhostShadowV=
irtqueue *svq)
>      return ROUND_UP(used_size, qemu_real_host_page_size());
>  }
>
> +size_t vhost_svq_vring_total_size(VirtIODevice *vdev, VirtQueue *vq)
> +{
> +    VhostShadowVirtqueue svq;
> +    svq.vring.num =3D virtio_queue_get_num(vdev, virtio_get_queue_index(=
vq));
> +    return vhost_svq_driver_area_size(&svq) + vhost_svq_device_area_size=
(&svq);
> +}
> +
>  /**
>   * Set a new file descriptor for the guest to kick the SVQ and notify fo=
r avail
>   *
> @@ -842,6 +849,19 @@ void vhost_svq_set_svq_kick_fd(VhostShadowVirtqueue =
*svq, int svq_kick_fd)
>      }
>  }
>
> +/**
> + * Set vring base address if using fixed locations
> + *
> + * @svq: Shadow Virtqueue
> + * @addr: Points to new base address
> + */
> +
> + void vhost_svq_set_base_addr(VhostShadowVirtqueue *svq, void *addr)
> + {
> +    svq->base_addr =3D addr;
> + }
> +

Would it work to keep that allocation detail in SVQ, instead of
letting it leak outside? Something like a flag to allocate the areas
with mmap or qemu_memfd_alloc, instead of the base_addr itself.

> +
>  /**
>   * Start the shadow virtqueue operation.
>   *
> @@ -849,8 +869,10 @@ void vhost_svq_set_svq_kick_fd(VhostShadowVirtqueue =
*svq, int svq_kick_fd)
>   * @vdev: VirtIO device
>   * @vq: Virtqueue to shadow
>   * @iova_tree: Tree to perform descriptors translations
> + *
> + * Return 0 on success, -errno on failure
>   */
> -void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
> +int vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
>                       VirtQueue *vq, VhostIOVATree *iova_tree)
>  {
>      size_t desc_size;
> @@ -868,14 +890,27 @@ void vhost_svq_start(VhostShadowVirtqueue *svq, Vir=
tIODevice *vdev,
>
>      svq->vring.num =3D virtio_queue_get_num(vdev, virtio_get_queue_index=
(vq));
>      svq->num_free =3D svq->vring.num;
> -    svq->vring.desc =3D mmap(NULL, vhost_svq_driver_area_size(svq),
> -                           PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANON=
YMOUS,
> -                           -1, 0);
>      desc_size =3D sizeof(vring_desc_t) * svq->vring.num;
> -    svq->vring.avail =3D (void *)((char *)svq->vring.desc + desc_size);
> -    svq->vring.used =3D mmap(NULL, vhost_svq_device_area_size(svq),
> -                           PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANON=
YMOUS,
> -                           -1, 0);
> +    if (svq->base_addr =3D=3D NULL) {
> +        svq->vring.desc =3D mmap(NULL, vhost_svq_driver_area_size(svq),
> +                            PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANO=
NYMOUS,
> +                            -1, 0);
> +        svq->vring.avail =3D (void *)((char *)svq->vring.desc + desc_siz=
e);
> +        svq->vring.used =3D mmap(NULL, vhost_svq_device_area_size(svq),
> +                            PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANO=
NYMOUS,
> +                            -1, 0);
> +    } else {
> +        svq->vring.desc =3D (void *)svq->base_addr;
> +        svq->vring.avail =3D (void *)((char *)svq->vring.desc + desc_siz=
e);
> +        svq->vring.used =3D (void *)((char *)svq->base_addr +
> +                          vhost_svq_driver_area_size(svq));
> +
> +        if ((uint64_t)svq->vring.used + vhost_svq_device_area_size(svq) =
- 1 <
> +           (uint64_t)svq->vring.desc) {
> +                error_report("Invalid shadow vring location");
> +                return -ENOMEM;
> +        }
> +    }
>      svq->desc_state =3D g_new0(SVQDescState, svq->vring.num);
>      if (virtio_vdev_has_feature(svq->vdev, VIRTIO_F_IN_ORDER)) {
>          svq->batch_last.id =3D VIRTIO_RING_NOT_IN_BATCH;
> @@ -884,6 +919,8 @@ void vhost_svq_start(VhostShadowVirtqueue *svq, VirtI=
ODevice *vdev,
>              svq->desc_state[i].next =3D i + 1;
>          }
>      }
> +
> +    return 0;
>  }
>
>  /**
> @@ -920,8 +957,19 @@ void vhost_svq_stop(VhostShadowVirtqueue *svq)
>      }
>      svq->vq =3D NULL;
>      g_free(svq->desc_state);
> -    munmap(svq->vring.desc, vhost_svq_driver_area_size(svq));
> -    munmap(svq->vring.used, vhost_svq_device_area_size(svq));
> +
> +    if (!svq->base_addr) {
> +        munmap(svq->vring.desc, vhost_svq_driver_area_size(svq));
> +        munmap(svq->vring.used, vhost_svq_device_area_size(svq));
> +    } else{
> +        if (svq->vring.desc) {
> +            memset(svq->vring.desc, 0, vhost_svq_driver_area_size(svq));
> +        }
> +        if (svq->vring.used) {
> +            memset(svq->vring.used, 0, vhost_svq_device_area_size(svq));
> +        }
> +    }
> +
>      event_notifier_set_handler(&svq->hdev_call, NULL);
>  }
>
> @@ -940,6 +988,7 @@ VhostShadowVirtqueue *vhost_svq_new(const VhostShadow=
VirtqueueOps *ops,
>      event_notifier_init_fd(&svq->svq_kick, VHOST_FILE_UNBIND);
>      svq->ops =3D ops;
>      svq->ops_opaque =3D ops_opaque;
> +    svq->base_addr =3D NULL;
>      return svq;
>  }
>
> diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-=
virtqueue.h
> index fd68319fb7..1e0cc9e5e4 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.h
> +++ b/hw/virtio/vhost-shadow-virtqueue.h
> @@ -150,6 +150,9 @@ typedef struct VhostShadowVirtqueue {
>
>      /* Size of SVQ vring free descriptors */
>      uint16_t num_free;
> +
> +    /* Location assigned to vrings if not in default anon memory map */
> +    void *base_addr;
>  } VhostShadowVirtqueue;
>
>  bool vhost_svq_valid_features(uint64_t features, Error **errp);
> @@ -169,8 +172,9 @@ void vhost_svq_get_vring_addr(const VhostShadowVirtqu=
eue *svq,
>                                struct vhost_vring_addr *addr);
>  size_t vhost_svq_driver_area_size(const VhostShadowVirtqueue *svq);
>  size_t vhost_svq_device_area_size(const VhostShadowVirtqueue *svq);
> +size_t vhost_svq_vring_total_size(VirtIODevice *vdev, VirtQueue *vq);
>
> -void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
> +int vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
>                       VirtQueue *vq, VhostIOVATree *iova_tree);
>  void vhost_svq_stop(VhostShadowVirtqueue *svq);
>
> @@ -178,6 +182,8 @@ VhostShadowVirtqueue *vhost_svq_new(const VhostShadow=
VirtqueueOps *ops,
>                                      void *ops_opaque);
>
>  void vhost_svq_free(gpointer vq);
> +void vhost_svq_set_base_addr(VhostShadowVirtqueue *svq, void *addr);
> +
>  G_DEFINE_AUTOPTR_CLEANUP_FUNC(VhostShadowVirtqueue, vhost_svq_free);
>
>  #endif
>
> --
> 2.43.0
>

