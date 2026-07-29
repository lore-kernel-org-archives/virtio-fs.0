Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BD6446053
	for <virtio-fs@lists.linux.dev>; Wed, 29 Jul 2026 09:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785317581; cv=none; b=Y2bAYxYxCFwQ1focsqyN3SrOiZSdtjrmZDnmN+PXN5baaoyjK6X+iO2q6csnV3fW95TkyNw+8c7rFk5CdTbxUkVNKtT3OkYdjKNzvWh/YD4deO4RtHFu/LtwUwpoHMLqFZMbCbu3g/joVDxxFs1vZagj2ZkbuyX+22niUk6K+6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785317581; c=relaxed/simple;
	bh=RPApaGJBO4GywamngTg029Z+UtMs8Yp6QET2tAvRt+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=diokQaQee9rf21K159Xe7Olqy7nRd4Y+ufwhh3A1OO193qU156IDG3kb0AO05GnaFuQzip4lGvV1oF0hwGoVDo5YNduZSURD/K4BBduWMSjzMEq2z2TO40lF5MhNSGzWjWXh0guxLugal1UcpDJBaLBYbvn1iEB/p2pvMqp6NBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LBXBD6Ny; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LBXBD6Ny"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785317577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h5ZGAi7O8dLqh6Z353nyUXQvQytJAAXxypSOhF8311U=;
	b=LBXBD6NyrQ9pkZrUqSgDWwv1WLFMTtbGsN4WtkVYVjLK57tWhc9Ca6vV42jfn/mr1Ugzdd
	7HNw07C9JfoVdcpyJFZiQBLv+GurZUCimQo12hqEnXOmmmQ86/OuZSSE9uOpMRGmdlsjiv
	G0AtlMAmF8NBlhc2dx1bF38HKqembH0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-koMytVQsPiSC_EzzNBciLw-1; Wed, 29 Jul 2026 05:32:56 -0400
X-MC-Unique: koMytVQsPiSC_EzzNBciLw-1
X-Mimecast-MFC-AGG-ID: koMytVQsPiSC_EzzNBciLw_1785317575
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-495569acf8dso5196205e9.1
        for <virtio-fs@lists.linux.dev>; Wed, 29 Jul 2026 02:32:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785317575; x=1785922375;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=h5ZGAi7O8dLqh6Z353nyUXQvQytJAAXxypSOhF8311U=;
        b=tGxZuQpXJIZbOPyV+UcSAcfT4fVAphKrME1acpfxhiot7fPBRz/2h0Xpo++Bz3vWrc
         Gl/vZJaj8YjyVi+255VjkqI32BGzSiRfK0TC/frf/M6vjER4mAOa66pQKhtIlb6d8jiA
         J+mfzoyXy3WL8lZItpGSjlaTfiEanPPxaYLQyd0Xtk7ugb9uRqRey/t8y40hzffocjav
         M1ni60S1wR8vYklk+YpqYNlHlJg1sewP3KX+L0xI5vnvc1x96b7vqqQUUMp6ac3zsGFf
         3PHbFsMPDnY0x1CGbIyU6gJgNjtROrOZf0ML9hM5NzZRVz/zDdyhhWuFG/mURWSQKRW0
         +5Kg==
X-Forwarded-Encrypted: i=1; AHgh+RpDmqxspOS7L9TZ8sN18zkQceUF64TeMSOeD7lqzlSgCNku957diz+I7gUG7914xARD37fNGtj8vjw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4IZTwrsPLHmHEp1ePMtaATYBXwsfYsw339v55Lqzdzf+4BWo5
	D8a/EDFzjkqM8zem/Saq9CordGjqgkQ+Au7NEmxX8znxO4Z2BnSmwEBaXCbVdsbzrZJ6+tZC5hW
	tkfNauYOWrBeIt0gOAGrOb2ybt/Onynu6cQCqthVfa8H/3DUV0XSINI2z6Xabjw==
X-Gm-Gg: AR+sD10w5mmtoVN57AQR4DW4xL/SFwftAXSk7tbDOED4RMC7VCmWS5LxMEeB1br04gA
	d2TggeGdY1VvKDbsoG3WWFuKWXC+niIJO5TpzepkwasxtWA15LZmgshiKWZw1T0VjsL236ciTEW
	koIFrgNk5/du2MBrhm8yIYkSk5SW0eCimeUmFkY1kImbhuDcHddGCBR4shjS2rJXs7AbA6LCFfg
	EhnCgVBf8wxB+XAVVj1u9MmHJwQ4/MV4d3gg0Rp5ryhZomyFLSsjc985lwnkd90snfyGD6D8Zu7
	dUq+ZuIeLt8VNbIntqiJyK7+uB0e181xe9xrFtQBcwCmwq2t13yL0BACOPXr0KXOUS80Cup2StS
	aienWJhwxah6dvweidyT08KM=
X-Received: by 2002:a05:600c:4f86:b0:496:c933:c276 with SMTP id 5b1f17b1804b1-496c933c2afmr52300275e9.25.1785317575007;
        Wed, 29 Jul 2026 02:32:55 -0700 (PDT)
X-Received: by 2002:a05:600c:4f86:b0:496:c933:c276 with SMTP id 5b1f17b1804b1-496c933c2afmr52299645e9.25.1785317574423;
        Wed, 29 Jul 2026 02:32:54 -0700 (PDT)
Received: from redhat.com (ppp-94-66-118-61.home.otenet.gr. [94.66.118.61])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49764d779e4sm41572705e9.6.2026.07.29.02.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 02:32:53 -0700 (PDT)
Date: Wed, 29 Jul 2026 05:32:50 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Cc: qemu-devel@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Jason Wang <jasowang@redhat.com>, Fam Zheng <fam@euphon.net>,
	qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>,
	virtio-fs@lists.linux.dev, Kevin Wolf <kwolf@redhat.com>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Raphael Norwitz <rnorwitz@nvidia.com>
Subject: Re: [PATCH v5 4/6] vhost-user-blk: make inflight-migration prop
 mutable
Message-ID: <20260729051509-mutt-send-email-mst@kernel.org>
References: <20260728100841.3475774-1-dtalexundeer@yandex-team.ru>
 <20260728100841.3475774-5-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260728100841.3475774-5-dtalexundeer@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X6G7UuSNTih3xqdXx9uPkVfVPI9Gk42BVYQNbhVGd8Q_1785317575
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jul 28, 2026 at 03:08:39PM +0500, Alexandr Moshkov wrote:
> When migrating from a QEMU version that supports inflight-migration to
> an older one that does not, there is no way to disable the feature at
> runtime — the VM must be stopped and reconfigured. This is impractical
> in production environments.
> 
> Make the inflight-migration property mutable after device realization
> so it can be toggled via qom-set without restarting the VM.
> 
> Acked-by: Raphael Norwitz <rnorwitz@nvidia.com>
> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>



I think I am beginning to understand.


You are running qemu with inflight-migration on and want to migrate
to qemu without inflight-migration at all.


Since it is guest transparent you could retrofit it like this.

My question is why is it worth it, we do not normally support
migrating between qemu versions with different command lines.

> ---
>  hw/block/vhost-user-blk.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> index e3b873af7c..650c004bde 100644
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -619,6 +619,8 @@ static const VMStateDescription vmstate_vhost_user_blk = {
>      }
>  };
>  
> +static PropertyInfo vhost_user_blk_inflight_migration_prop;
> +
>  static const Property vhost_user_blk_properties[] = {
>      DEFINE_PROP_CHR("chardev", VHostUserBlk, chardev),
>      DEFINE_PROP_UINT16("num-queues", VHostUserBlk, num_queues,
> @@ -632,8 +634,9 @@ static const Property vhost_user_blk_properties[] = {
>                        VIRTIO_BLK_F_WRITE_ZEROES, true),
>      DEFINE_PROP_BOOL("skip-get-vring-base-on-force-shutdown", VHostUserBlk,
>                       skip_get_vring_base_on_force_shutdown, false),
> -    DEFINE_PROP_BOOL("inflight-migration", VHostUserBlk,
> -                     inflight_migration, false),
> +    DEFINE_PROP("inflight-migration", VHostUserBlk, inflight_migration,
> +                vhost_user_blk_inflight_migration_prop, bool,
> +                .set_default = true, .defval.u = false),
>  };
>  
>  static void vhost_user_blk_class_init(ObjectClass *klass, const void *data)
> @@ -665,6 +668,9 @@ static const TypeInfo vhost_user_blk_info = {
>  
>  static void virtio_register_types(void)
>  {
> +    vhost_user_blk_inflight_migration_prop = qdev_prop_bool;
> +    vhost_user_blk_inflight_migration_prop.realized_set_allowed = true;
> +
>      type_register_static(&vhost_user_blk_info);
>  }

So then,  for example, let us say I paused the VM, then set the flag,
now inflight is on but GET_BASE did not drain it?

> -- 
> 2.34.1

