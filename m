Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57738396D39
	for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 12:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768393594; cv=none; b=U8Tn7vehmJ1U1e7SfXhGKqS/QtJvmNG2D6fzakj7GQSLGiS3D1oy6w3YDIeg5AGll7Xzb/xumXU0kFZlOAqeS3L1ALkvmPIrQQPAIRVOrhi3sIk6OTIklo1bWCAUyaG4E9SVgFsQWJ4yGb5jB7UH6b90WHsKc7/WZXLTNhyFXsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768393594; c=relaxed/simple;
	bh=NsdO2BH3wq3bky0BUoxIVf61Bl9oax1CIqcvXBa8y4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=FJ3WZTHt5ouXaY7f5lssWHFueC/qA0HD6/Fiy+QcZFhgKxsSwEQqEx+AubKSknb1BqIM48jZnve8dd6JXztkYYnJGJmfUy6K4UD8lXNkgHWpaLRbyzx19IsYrnS7YUHC+HSvcZx91hIRTf2LEmAYNI/LE5Kh8M2uEHWUx4q50l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NIaHBBf7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NIaHBBf7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768393591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3W1TBgpVWgkAGfz0fTl0gxUhHHatXchW+EtU/acZiK8=;
	b=NIaHBBf7hLqVwdvo0aGIq5Wnw7lLl3nt3tl9Pr0773eQSfB+KSg7Tjv2wOQEBb1sXAUgi0
	TUrLdSxO/9eOW2t4NW3epRtvtatouJR01hcc5kDJjSxRFuJUR9Xr+DOU1PG4jXKzJuD2QJ
	7SZ10Osx6KumD3DBsuZNPNbJNBjqNiw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-c3K0jFa6PVmzqrv_nJoWdQ-1; Wed, 14 Jan 2026 07:26:28 -0500
X-MC-Unique: c3K0jFa6PVmzqrv_nJoWdQ-1
X-Mimecast-MFC-AGG-ID: c3K0jFa6PVmzqrv_nJoWdQ_1768393588
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c530da0691so135281685a.3
        for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 04:26:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768393587; x=1768998387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3W1TBgpVWgkAGfz0fTl0gxUhHHatXchW+EtU/acZiK8=;
        b=fPvLoV+XiNIjNz1EkwjH012BmuYqP7JGSIfZu5yaD26VN7hKG4D2eXjCBuId7+06YF
         8yZZGKuGgj8Z4KlO8l84uQAwJDoA8t5KqcD5N/R5/oV/VkluT+gJLenTZ8aKumeQb3ev
         C5vD+cNKT6cULdeZJv25WxcJyDtZjkeT3lk/+bHx1ARoSIbT2hM54WNv1NbLHH0Iq3gV
         bm4fU6eI5h70zfbLqJPxm3/PX0In06k5qfkkm35aq5xK9PJo6Rd1m2/5bmBfLQnav7Rm
         bQfgVKM1sh8KFFdhDHE1nTf2MKus5coJFK6Tp3YDCYBQ1fQ5N8ZX2ZNt2PyUTC0q+8kz
         OAxw==
X-Forwarded-Encrypted: i=1; AJvYcCUt+Cu4gnGEJ2R1pdovJpetKs42g89Fuy3UaYP4hRBccxu2x/IzqaQD+r4q4l6WzGcpxKOTlLiwAOE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3l4zB1uKRJrl5JbmEEBCQn6TDmAEKQUPuX3SL59InoZwUdBn7
	Fu0Fo+YxJ4XMNrP+7SSmfZEsMqeyer1CQx7FpVGTDpJ2I+kyTfvcL2Zm00x2VY/1s3KA4zEIGVe
	i38TnG5pOiLhlyPSR48yGe0Ip6JWQnM6WW+L99hcZQSaX3dQX0zfE5mhuqPL/7Q==
X-Gm-Gg: AY/fxX6zyd4vEEMsJA8Pc/hsYmr9TZX4+2SROTR1A8SjbL/oOoni8Di1FpKfe+pVTdd
	nCpx4yGVH+mLIw1haqGOW6MmNk+Iqez0AtEJoWv4Rhtxp8pR3lJVMgExKGxGStMdiAZrCbnGLtH
	G6RQnBHI6SCuo5on2wnWngDbppkztmLe/SoWRnur9M7SSF2T/8O2jSTF4IJCLi6xpQXpmLQomeO
	qvWjWWqbc5Dzg/uhBRS5pzqTJYcNfb39FWY0IX3rvDQTnxzK8KIwArcLjyEuVKSu+O5DLmfnJAc
	FIx/YcJ01Uy4e2j+knaJxqGsdPhOcvfMO8yHQ+Xy/cfU7BUZRSBU57B8SFFB9dSA/XrPC0FYsS9
	hAGY=
X-Received: by 2002:a05:620a:400d:b0:8b2:f145:7f28 with SMTP id af79cd13be357-8c52fb1d058mr307022885a.33.1768393587402;
        Wed, 14 Jan 2026 04:26:27 -0800 (PST)
X-Received: by 2002:a05:620a:400d:b0:8b2:f145:7f28 with SMTP id af79cd13be357-8c52fb1d058mr307019485a.33.1768393586882;
        Wed, 14 Jan 2026 04:26:26 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c530ba54b8sm152072785a.42.2026.01.14.04.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 04:26:26 -0800 (PST)
Date: Wed, 14 Jan 2026 07:26:24 -0500
From: Peter Xu <peterx@redhat.com>
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Cc: qemu-devel@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Zhenwei Pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raphael Norwitz <raphael@enfabrica.net>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Stefan Hajnoczi <stefanha@redhat.com>, mzamazal@redhat.com,
	Fabiano Rosas <farosas@suse.de>, qemu-block@nongnu.org,
	virtio-fs@lists.linux.dev,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH v6 5/5] vhost-user-blk: support inter-host inflight
 migration
Message-ID: <aWeLcDtZyRpk81W6@x1.local>
References: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
 <20260113095813.134810-6-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260113095813.134810-6-dtalexundeer@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Xma8MtmqwyxA6QznQuR6NojVRFRLC1IEhU9X3h58Ixk_1768393588
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Jan 13, 2026 at 02:58:19PM +0500, Alexandr Moshkov wrote:
> During inter-host migration, waiting for disk requests to be drained
> in the vhost-user backend can incur significant downtime.
> 
> This can be avoided if QEMU migrates the inflight region in
> vhost-user-blk.
> Thus, during the qemu migration, with feature flag the vhost-user
> back-end can immediately stop vrings, so all in-flight requests will be
> migrated to another host.
> 
> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> ---
>  hw/block/vhost-user-blk.c          | 28 ++++++++++++++++++++++++++++
>  include/hw/virtio/vhost-user-blk.h |  1 +
>  2 files changed, 29 insertions(+)
> 
> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> index a8fd90480a..9093e98841 100644
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -377,6 +377,7 @@ static int vhost_user_blk_init(DeviceState *dev, bool connect, Error **errp)
>      vhost_dev_set_config_notifier(&s->dev, &blk_ops);
>  
>      s->vhost_user.supports_config = true;
> +    s->vhost_user.supports_inflight_migration = s->inflight_migration;
>      ret = vhost_dev_init(&s->dev, &s->vhost_user, VHOST_BACKEND_TYPE_USER, 0,
>                           false, errp);
>      if (ret < 0) {
> @@ -656,6 +657,27 @@ static struct vhost_dev *vhost_user_blk_get_vhost(VirtIODevice *vdev)
>      return &s->dev;
>  }
>  
> +static bool vhost_user_blk_inflight_needed(void *opaque)
> +{
> +    struct VHostUserBlk *s = opaque;
> +
> +    bool inflight_migration = vhost_dev_has_feature(&s->dev,
> +                        VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
> +
> +    return inflight_migration &&
> +           !migrate_local_vhost_user_blk();

Here's the spot that should depend on migrate_local_vhost_user_blk() from
Vladimilr's RFC patch (again, likely to be renamed..).

Btw, is this check correct against "!migrate_local_vhost_user_blk()"?  I
was expecting the feature off only if local=on, so I expect it to be:

       return inflight_migration && migrate_local_vhost_user_blk();

?

> +}
> +
> +static const VMStateDescription vmstate_vhost_user_blk_inflight = {
> +    .name = "vhost-user-blk/inflight",
> +    .version_id = 1,
> +    .needed = vhost_user_blk_inflight_needed,
> +    .fields = (const VMStateField[]) {
> +        VMSTATE_VHOST_INFLIGHT_REGION(inflight, VHostUserBlk),

One other trivial nitpick while glimpsing over the patch: should we move
the macro definition from previous patch to this one, where it is used?

> +        VMSTATE_END_OF_LIST()
> +    },
> +};
> +
>  static bool vhost_user_blk_pre_incoming(void *opaque, Error **errp)
>  {
>      VHostUserBlk *s = VHOST_USER_BLK(opaque);
> @@ -678,6 +700,10 @@ static const VMStateDescription vmstate_vhost_user_blk = {
>          VMSTATE_VIRTIO_DEVICE,
>          VMSTATE_END_OF_LIST()
>      },
> +    .subsections = (const VMStateDescription * const []) {
> +        &vmstate_vhost_user_blk_inflight,
> +        NULL
> +    }
>  };
>  
>  static bool vhost_user_needed(void *opaque)
> @@ -751,6 +777,8 @@ static const Property vhost_user_blk_properties[] = {
>                        VIRTIO_BLK_F_WRITE_ZEROES, true),
>      DEFINE_PROP_BOOL("skip-get-vring-base-on-force-shutdown", VHostUserBlk,
>                       skip_get_vring_base_on_force_shutdown, false),
> +    DEFINE_PROP_BOOL("inflight-migration", VHostUserBlk,
> +                     inflight_migration, false),
>  };
>  
>  static void vhost_user_blk_class_init(ObjectClass *klass, const void *data)
> diff --git a/include/hw/virtio/vhost-user-blk.h b/include/hw/virtio/vhost-user-blk.h
> index b06f55fd6f..e1466e5cf6 100644
> --- a/include/hw/virtio/vhost-user-blk.h
> +++ b/include/hw/virtio/vhost-user-blk.h
> @@ -52,6 +52,7 @@ struct VHostUserBlk {
>      bool started_vu;
>  
>      bool skip_get_vring_base_on_force_shutdown;
> +    bool inflight_migration;
>  
>      bool incoming_backend;
>  };
> -- 
> 2.34.1
> 

-- 
Peter Xu

