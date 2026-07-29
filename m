Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF7A3B42E3
	for <virtio-fs@lists.linux.dev>; Wed, 29 Jul 2026 12:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327207; cv=none; b=IG85ANLWqI0Nl9azPpZxgRCyXRlGE4T6hmo5ZWsPtT9RcsbayXSZpg1eos9KzYTet/yWggXuTi76ehnZqKMLAK9SvFDjC0gzxyRbagUMvbyQHvXnRjTnybmKtf7pgqZMIAvb0IFDNTDz0S2Xckoe1Ml7JUmTpa4E5LUauSYRP74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327207; c=relaxed/simple;
	bh=0PJk9QuBnEUCyHR9gynuZsk/WnHsTKpIkP0jBaHcY1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=RtOmXWBNJZgMKlzawrmj/onzTdy1hJikc9FRjuJjtUg7CBsWnjOvirboGaYO8TGxoMxVFNKdC4AF/DS1IPaXUx/B61CzrAOPpTVbiwsl/v54xjcddyruKF72iaqOTH9zkvWyav+Aw9Wzz3A+VBronJX8JYutqaCD6sNIDH2k3zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DVFDZSai; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DVFDZSai"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785327205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=THvdhvNtSPM3uYfk7F11gDa6rQECqt7z01fPOqYKnF8=;
	b=DVFDZSaiw521y4XMnx+P4yCBkYXhvJGCq9TbqHz54stOh3kwTTXrKdIQVMRXRFskB5hzW5
	a+O5zfF8/MD13K/EpHkvCnltzLIddO8IzgVm/SAytzja8OVFFOiChvsaTcpJ8nR+xt+HFo
	Ni3bX5ZrE3zNMBJ3N/koJRn9BNyGvKo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-JXv6JK2XPuKYnnTVxzLoSA-1; Wed, 29 Jul 2026 08:13:23 -0400
X-MC-Unique: JXv6JK2XPuKYnnTVxzLoSA-1
X-Mimecast-MFC-AGG-ID: JXv6JK2XPuKYnnTVxzLoSA_1785327202
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47eaa4006a1so419995f8f.0
        for <virtio-fs@lists.linux.dev>; Wed, 29 Jul 2026 05:13:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785327202; x=1785932002;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=THvdhvNtSPM3uYfk7F11gDa6rQECqt7z01fPOqYKnF8=;
        b=GwInAn5BGQp9V+JQ25wb+5+Wyq7Mey8umxIK+U7MBxuFTkdkjJitRB7aTEmPd4uhLu
         9YtVBVp9cRN1HPpsjPGfhExry9xyBGTIpdMoLJGzgHVij1IZBeMrQaj1rALFbqbuNclp
         5GjoaYpH/snXgf7MzOPefckBfT9APFUto3xKt8ix+ohXYvbp66qbVPMuNiw/6hpMgf6B
         fZQLN7Jt0/X/Si7i96SDePWWcNla5NubIZtvtbhU+nKPuNdtAbJyFM9HAf3jmKckvnH5
         3pVvhTx5XKePtZF02kGIkCUCfOzMNv4izQwlxGCRASd8oUlfIn8+ZVE+a3L0phUUHzgi
         yq4g==
X-Forwarded-Encrypted: i=1; AHgh+RrLme/zJeM3/b5TjXKRCXCtpasaJkF6H6MEV5a/aql9XcbGnuDK0Bt+fty0CRAaX1WnPDB9xq12+GE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQizqCqoUnuVk2YTqzYvQQ6wKUq2K0WPuRTN/h/6N1OET3okZp
	EW6WGKd+vIQWNSxfDWWtraQ4KoPtsctp8IcTmi7jNvgU2jTq/JY+lt4bNnMcilD23kmn37rFCrw
	eM/+vJhYZnz+8ys7xZ5geHuyfIbIZJyu4Jzro+/Ju9K/r2OIuXOkKT9m8wDJ/yQ==
X-Gm-Gg: AR+sD12zKInQubUL12ouxfvM2dl8MIjZAPlXEA2MOcxc6lpWhU6ldvxYVsGiH6BtDfy
	VAYtKIaZoi13belsaMoG9OzrUulJ5R7AvHQPSV6ULl9K50hBOLnrYFMEbRIV9HXrcXPZWDxG7J9
	qocfhO/v+40UOK8T/qKh5SeDLBhIBx8WddBtrSOxEWBTtSRn/NtGYMcmNP05yI2NbFOwp/vXPA1
	mA07ERd2czUqR++jZ23bFABIPGX580bYfkTQG7mpXlckqtaMaMWAbHjoqKRRS5qxWyYgOx9n5VE
	c5RHB6UMvpWvmsOBMxegKFzVwr/RPGhXHQq14bBawNlYcroeS7FKMNNtQ2bQAmk6DvhVMOrHdM+
	xNpdl1pDEoZeb0MM0V0k/JNA=
X-Received: by 2002:a05:6000:1787:b0:47f:95ce:85be with SMTP id ffacd0b85a97d-47fbac063a1mr2903007f8f.30.1785327201973;
        Wed, 29 Jul 2026 05:13:21 -0700 (PDT)
X-Received: by 2002:a05:6000:1787:b0:47f:95ce:85be with SMTP id ffacd0b85a97d-47fbac063a1mr2902936f8f.30.1785327201302;
        Wed, 29 Jul 2026 05:13:21 -0700 (PDT)
Received: from redhat.com (ppp-94-66-118-61.home.otenet.gr. [94.66.118.61])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6abc703sm7550126f8f.9.2026.07.29.05.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 05:13:20 -0700 (PDT)
Date: Wed, 29 Jul 2026 08:13:13 -0400
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
Message-ID: <20260729074711-mutt-send-email-mst@kernel.org>
References: <20260728100841.3475774-1-dtalexundeer@yandex-team.ru>
 <20260728100841.3475774-5-dtalexundeer@yandex-team.ru>
 <20260729051509-mutt-send-email-mst@kernel.org>
 <679a33d1-0f6c-4456-ac76-1f9e1251f2ec@yandex-team.ru>
 <20260729061316-mutt-send-email-mst@kernel.org>
 <a4db1b40-d48c-473b-86a7-63a0c0cc5ccf@yandex-team.ru>
 <20260729064648-mutt-send-email-mst@kernel.org>
 <dd1f5830-75ff-4256-a179-6a8341a3b4ec@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <dd1f5830-75ff-4256-a179-6a8341a3b4ec@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: l4jMs5S0sC-Ii9s29P9PzDAeCtGMSOpvWtZNUfvYSFY_1785327202
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026 at 03:56:54PM +0500, Alexandr Moshkov wrote:
> 
> On 7/29/26 15:48, Michael S. Tsirkin wrote:
> 
>     On Wed, Jul 29, 2026 at 03:35:31PM +0500, Alexandr Moshkov wrote:
> 
>         On 7/29/26 15:14, Michael S. Tsirkin wrote:
> 
>             On Wed, Jul 29, 2026 at 03:09:57PM +0500, Alexandr Moshkov wrote:
> 
>                 On 7/29/26 14:32, Michael S. Tsirkin wrote:
> 
>                      On Tue, Jul 28, 2026 at 03:08:39PM +0500, Alexandr Moshkov wrote:
> 
>                          When migrating from a QEMU version that supports inflight-migration to
>                          an older one that does not, there is no way to disable the feature at
>                          runtime — the VM must be stopped and reconfigured. This is impractical
>                          in production environments.
> 
>                          Make the inflight-migration property mutable after device realization
>                          so it can be toggled via qom-set without restarting the VM.
> 
>                          Acked-by: Raphael Norwitz <rnorwitz@nvidia.com>
>                          Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> 
> 
> 
>                      I think I am beginning to understand.
> 
> 
>                      You are running qemu with inflight-migration on and want to migrate
>                      to qemu without inflight-migration at all.
> 
> 
>                      Since it is guest transparent you could retrofit it like this.
> 
>                      My question is why is it worth it, we do not normally support
>                      migrating between qemu versions with different command lines.
> 
>                 I think you right. Maybe I've been focusing too much on the ability to migrate
>                 between versions of qemu with and without inflight migration.
> 
>                 This series allows to turn off and on the inflight-migration feature at runtime
>                 without recreating the VM

restarting you mean.

> (it was the only way to turn off the feature, since
>                 the protocol feature could no longer be turned off, after initialization with
>                 the backend). This is more important feature, and it leads to the fact that
>                 this feature allows to migrate between different versions of qemu (with and
>                 without inflight-migration support).

so again it's not the 1st feature we have like this. we tie migration
to the machine type and same set of command line flags
specifically to keep things manageable.

really cross version migration is a pain as it is.

> 
>                          ---
>                           hw/block/vhost-user-blk.c | 10 ++++++++--
>                           1 file changed, 8 insertions(+), 2 deletions(-)
> 
>                          diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
>                          index e3b873af7c..650c004bde 100644
>                          --- a/hw/block/vhost-user-blk.c
>                          +++ b/hw/block/vhost-user-blk.c
>                          @@ -619,6 +619,8 @@ static const VMStateDescription vmstate_vhost_user_blk = {
>                               }
>                           };
> 
>                          +static PropertyInfo vhost_user_blk_inflight_migration_prop;
>                          +
>                           static const Property vhost_user_blk_properties[] = {
>                               DEFINE_PROP_CHR("chardev", VHostUserBlk, chardev),
>                               DEFINE_PROP_UINT16("num-queues", VHostUserBlk, num_queues,
>                          @@ -632,8 +634,9 @@ static const Property vhost_user_blk_properties[] = {
>                                                 VIRTIO_BLK_F_WRITE_ZEROES, true),
>                               DEFINE_PROP_BOOL("skip-get-vring-base-on-force-shutdown", VHostUserBlk,
>                                                skip_get_vring_base_on_force_shutdown, false),
>                          -    DEFINE_PROP_BOOL("inflight-migration", VHostUserBlk,
>                          -                     inflight_migration, false),
>                          +    DEFINE_PROP("inflight-migration", VHostUserBlk, inflight_migration,
>                          +                vhost_user_blk_inflight_migration_prop, bool,
>                          +                .set_default = true, .defval.u = false),
>                           };
> 
>                           static void vhost_user_blk_class_init(ObjectClass *klass, const void *data)
>                          @@ -665,6 +668,9 @@ static const TypeInfo vhost_user_blk_info = {
> 
>                           static void virtio_register_types(void)
>                           {
>                          +    vhost_user_blk_inflight_migration_prop = qdev_prop_bool;
>                          +    vhost_user_blk_inflight_migration_prop.realized_set_allowed = true;
>                          +
>                               type_register_static(&vhost_user_blk_info);
>                           }
> 
>                      So then,  for example, let us say I paused the VM, then set the flag,
>                      now inflight is on but GET_BASE did not drain it?
> 
>                 If I understood the question correctly, this is valid behavior. Before
>                 migration QEMU check protocol features to understand does the backend support
>                 inflight migration. If it does, after that QEMU migrate inflight buffer to
>                 other VM. If it's not, return error before migration started.
> 
>             I apologise i reverted the logic in the question.
> 
> 
>             I start vm and inflight is on.
>             I stop vm get base does not drain.
> 
>         In case of VM stop, backend wait to drain all requests. Ability to perform
>         drain or not available only during migration by skip_drain variable in
>         vhost_user_blk_stop().
> 
>     What if it was migration but it failed?
> 
> If migration failed, source vm just keep using inflight region, backend
> continue to execute inflight requests that was tried to migrate.


Sorry, to be more clear. I mean migration succeeded but destination failed to
start, so now vm is stopped and we are now trying migrating to a different destination.

IIUC currently on VM stop we simply send GET_BASE and this stops
backend, and depending on features things remain in the inflight buffer.
Correct me if  I am wrong.

I think that we do not want a slow flush on vm stop if we
can avoid it, and we also do not want backend to keep changing
guest memory when VM is stopped. No?




> 
> 
>         skip_drain true only if inflight_migration is on and runstate is
>         FINISH_MIGRATION.

FINISH_MIGRATE? actually i do not see where it affects it.

> 
>     This btw I don't much like, a stopped VM would preferably
>     behave the same whatever the reason to stop.
> 
> Well, I don't see any other way to implement this.


I am not 100% sure it's implementable as described, but I guess
you could block changing the property if VM and thus the backend
is not connected and running.


Which is even more complexity but at least it is consistent.






> I think backend must perform
> drain in all cases except live migration with all the necessary checks 
> (protocol features, special message GET_VRING_BASE_SKIP_DRAIN).


This is not what is going on now, right? Whether it drains depends
on protocol features not on VM state and I think we should
keep it like this.



> 
> 
>             i turn inflight off.
>             now it looks like it will happily migrate?
> 
>         So in this case, when vm migrated with inflight off, it will leads to using
>         GET_VRING_BASE message, that wait all requests to be drained.
> 
> 
>                          --
>                          2.34.1
> 
>


i mean it migrated with on. vm was stopped then it flipped to off.






-- 
MST 

