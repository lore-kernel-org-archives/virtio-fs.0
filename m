Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0CB399CEE
	for <virtio-fs@lists.linux.dev>; Wed, 29 Jul 2026 10:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785320108; cv=none; b=FSqSnbCu5dzKRWSvMXTlMJ4kIjBtaawX3emLubmby46znSLtqzIsA8tRxUeVmBcPfeOdOVPOsesnapAmAOiGH9cWajwCC0+qE4CSXepIMRs9RNQP2ysZYaMBEtLUr4B0EEsPsRpagOsJYth5O/8ivjifAEqGITbjQGvOJtBbLDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785320108; c=relaxed/simple;
	bh=it143/U2YjSehj3MvyVDX/CQH4XTsNeqYITPRQtNiD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=t0o94vZ38awvS2Rpx8etIvavMDVAgy8OkQrmC5Uwd6vnw6qU4O59fJpBEdXtjYQItPvr2bg8B9ddluFlu9got3W69u6TLDmg5reSODxXCnALRK+P5+bnB8LSf/k8qyCU4rXv7HS2+ZTSH9pseA05w7HF1h8d3/ut13JvsdDLF3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X0+OtF7j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X0+OtF7j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785320104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eROq5aHdjWSnz43ds9dNZRTI0rWGEt384Vv2CIIwYso=;
	b=X0+OtF7jqAjawa80q8WXKe2OUP5ki/D+vATBJKXDMKUGzIVyEXbytDMl6FLQSzeEs0kaFq
	MIWMfy6CJ9en8sBp6XGBCkhjUUwU3XImyXN3ZfDpO8L+UL+JzbxWzeIgScaLNs162WsldT
	uJEYOdGZGze9ho31pOfMXqO8aeKWatc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-dfUc6IeSOEOLkshYR8oXTw-1; Wed, 29 Jul 2026 06:14:59 -0400
X-MC-Unique: dfUc6IeSOEOLkshYR8oXTw-1
X-Mimecast-MFC-AGG-ID: dfUc6IeSOEOLkshYR8oXTw_1785320097
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-493a7fa8481so12825725e9.1
        for <virtio-fs@lists.linux.dev>; Wed, 29 Jul 2026 03:14:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785320096; x=1785924896;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eROq5aHdjWSnz43ds9dNZRTI0rWGEt384Vv2CIIwYso=;
        b=kqZY+m6E7nNmGtVjx5DAaYEmoVInC/cRMAWNtvNNQ63zuI4JPAborzc3bv2kpSGw//
         FYlqHERDgnWXQrMCJHh8qFomGRUX1dlse0J9f1QIX6usiCDzMWGcaO0XtWP7MMum+6Ot
         foWryDAKIdYMSqVsC19A7swO4ofyuOWvkbFWoUb78Bfg3W/HBnyISrqqlJeJpjSTsb/Y
         NutW2YOU7MRZ18f+tFtiYoNRCsbqDlmAAVDcr58EFBaoUQemG1bs91WOvGOf8kTHk2Oy
         qm+74z3ZCAijDANW63mEmpVRKWh/k51aXs7MVrJKYdfip/rYNex5YxCsEG68/RIjDRcJ
         dvng==
X-Forwarded-Encrypted: i=1; AHgh+Rr+E7I+WqoG+zXaSsTJfZ+EXucCWWMXR7GsDEvPfyiFROMQgcUPFn7squ4CJTbiFSV7gMNzihn3dvQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLn+GWG2P7dXdDT7I7XmgdFM+38GhZY8RMCe3vyEPhz/K7y95p
	XsUm9d/94aATzyZxpyzVRJBlD9Q+M5Zyy3UwbVwJte71RCdZo0Ivongy45zTWIwX9DHZaUMJA+P
	Md+PTDs9Oq2oKMGY7MGVlqvwdY7msubR1Vuu87vD2kS2CVaAgYIULqTMLLcb3Yg==
X-Gm-Gg: AR+sD12IYUVUbf6L03ZNo7HDcc8uo/+znFc/ztpbSFQgr8ScuY4/UcvbBBa0fVEK7Bg
	C1Nj8zekkiV7y0RQUdeMEZLY9LJRTHIeQ4CrTr2WqcG7Rhvqp/sr8YOm+j4QjqAzW9Wd4SEveNl
	cK/zhIOB6mz4M02M2357U4B5FmZPe8h7GtkSFZvEIj6VumUBMrsj9GTXjDiLNJSFST8ig4O6hbL
	LjxIUNVaHuSnI6nd63xqvQzkPWeCTCd+0YfumKMzLUluzI7YbmKdkPIhw4a5mSMOcf1rGtAhykX
	FTnZd1ufKsJQTgUIVTq7IeZf+wwTyRO3Lc/FmvgQgB64JGn7fZckrzZ3lzHnel16pajH7+SGRS8
	OI8EdHgC3K9/8kRqOdgoisWw=
X-Received: by 2002:a05:600c:4746:b0:495:3c6f:7c18 with SMTP id 5b1f17b1804b1-497fd2f50bbmr16748215e9.3.1785320096505;
        Wed, 29 Jul 2026 03:14:56 -0700 (PDT)
X-Received: by 2002:a05:600c:4746:b0:495:3c6f:7c18 with SMTP id 5b1f17b1804b1-497fd2f50bbmr16747845e9.3.1785320095897;
        Wed, 29 Jul 2026 03:14:55 -0700 (PDT)
Received: from redhat.com (ppp-94-66-118-61.home.otenet.gr. [94.66.118.61])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c4615f5fsm139025205e9.9.2026.07.29.03.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 03:14:55 -0700 (PDT)
Date: Wed, 29 Jul 2026 06:14:51 -0400
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
Message-ID: <20260729061316-mutt-send-email-mst@kernel.org>
References: <20260728100841.3475774-1-dtalexundeer@yandex-team.ru>
 <20260728100841.3475774-5-dtalexundeer@yandex-team.ru>
 <20260729051509-mutt-send-email-mst@kernel.org>
 <679a33d1-0f6c-4456-ac76-1f9e1251f2ec@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <679a33d1-0f6c-4456-ac76-1f9e1251f2ec@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fUMmp7ZjLu9_uRZbbF4VudoJUGSdfgG6rmBBLEpdSso_1785320097
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026 at 03:09:57PM +0500, Alexandr Moshkov wrote:
> 
> On 7/29/26 14:32, Michael S. Tsirkin wrote:
> 
>     On Tue, Jul 28, 2026 at 03:08:39PM +0500, Alexandr Moshkov wrote:
> 
>         When migrating from a QEMU version that supports inflight-migration to
>         an older one that does not, there is no way to disable the feature at
>         runtime — the VM must be stopped and reconfigured. This is impractical
>         in production environments.
> 
>         Make the inflight-migration property mutable after device realization
>         so it can be toggled via qom-set without restarting the VM.
> 
>         Acked-by: Raphael Norwitz <rnorwitz@nvidia.com>
>         Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> 
> 
> 
>     I think I am beginning to understand.
> 
> 
>     You are running qemu with inflight-migration on and want to migrate
>     to qemu without inflight-migration at all.
> 
> 
>     Since it is guest transparent you could retrofit it like this.
> 
>     My question is why is it worth it, we do not normally support
>     migrating between qemu versions with different command lines.
> 
> I think you right. Maybe I've been focusing too much on the ability to migrate 
> between versions of qemu with and without inflight migration.
> 
> This series allows to turn off and on the inflight-migration feature at runtime
> without recreating the VM (it was the only way to turn off the feature, since
> the protocol feature could no longer be turned off, after initialization with
> the backend). This is more important feature, and it leads to the fact that
> this feature allows to migrate between different versions of qemu (with and
> without inflight-migration support).
> 
>     
> 
>         ---
>          hw/block/vhost-user-blk.c | 10 ++++++++--
>          1 file changed, 8 insertions(+), 2 deletions(-)
> 
>         diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
>         index e3b873af7c..650c004bde 100644
>         --- a/hw/block/vhost-user-blk.c
>         +++ b/hw/block/vhost-user-blk.c
>         @@ -619,6 +619,8 @@ static const VMStateDescription vmstate_vhost_user_blk = {
>              }
>          };
> 
>         +static PropertyInfo vhost_user_blk_inflight_migration_prop;
>         +
>          static const Property vhost_user_blk_properties[] = {
>              DEFINE_PROP_CHR("chardev", VHostUserBlk, chardev),
>              DEFINE_PROP_UINT16("num-queues", VHostUserBlk, num_queues,
>         @@ -632,8 +634,9 @@ static const Property vhost_user_blk_properties[] = {
>                                VIRTIO_BLK_F_WRITE_ZEROES, true),
>              DEFINE_PROP_BOOL("skip-get-vring-base-on-force-shutdown", VHostUserBlk,
>                               skip_get_vring_base_on_force_shutdown, false),
>         -    DEFINE_PROP_BOOL("inflight-migration", VHostUserBlk,
>         -                     inflight_migration, false),
>         +    DEFINE_PROP("inflight-migration", VHostUserBlk, inflight_migration,
>         +                vhost_user_blk_inflight_migration_prop, bool,
>         +                .set_default = true, .defval.u = false),
>          };
> 
>          static void vhost_user_blk_class_init(ObjectClass *klass, const void *data)
>         @@ -665,6 +668,9 @@ static const TypeInfo vhost_user_blk_info = {
> 
>          static void virtio_register_types(void)
>          {
>         +    vhost_user_blk_inflight_migration_prop = qdev_prop_bool;
>         +    vhost_user_blk_inflight_migration_prop.realized_set_allowed = true;
>         +
>              type_register_static(&vhost_user_blk_info);
>          }
> 
>     So then,  for example, let us say I paused the VM, then set the flag,
>     now inflight is on but GET_BASE did not drain it?
> 
> If I understood the question correctly, this is valid behavior. Before
> migration QEMU check protocol features to understand does the backend support
> inflight migration. If it does, after that QEMU migrate inflight buffer to
> other VM. If it's not, return error before migration started.  


I apologise i reverted the logic in the question.


I start vm and inflight is on.
I stop vm get base does not drain.
i turn inflight off.
now it looks like it will happily migrate?

>         --
>         2.34.1
> 

