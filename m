Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528A944684C
	for <virtio-fs@lists.linux.dev>; Wed, 29 Jul 2026 10:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322110; cv=none; b=Om9xApFxC1WPbbhYfnsQywFzUPXlWHN/Ghf4/r8jMRwbDOeAqbk2kwLTbkArRl/N2sbV9VR3Vi2L17MlfpJy6mP12HgHBwGdFjBsuLCaiTQnrN8Tiu6/dPA9AQwomZK1M5+jb4pkC7ClZM0y/2nuHoNp9cj2XdSRiYAmiT3hGp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322110; c=relaxed/simple;
	bh=dkJ2n7MEPfokK0+/047V64JLKYdukvCPX2vfpDTs0WQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=YQk0HsNEU878ueHs1nAb3m5IITv/RagliqaSzEKhBJ0c8x2k7nMXoqsWFB6qr/8Z/rkZwzi0MPkZ3J7li5CIspHmiNqfGRFx6/y87YW9uTnN8iAqAcrkgtLKe+DIhuPqKke27GvqigQ7Xd/0Xxq6aQN9GdH+FDwnW2rVrNhcRuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q/OKWapJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q/OKWapJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785322107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZywnHiJedGnDH0gAQ+IBNB/UgtoW/0D+aEiAO17wQm8=;
	b=Q/OKWapJ1L1Vj3s7gf/CpAxlHjZh+u3O7PqkFW9SMUa1iHrG+kLFn/WXvI3DkHsv40rYfL
	S9jDaVIWOlQGgQ7kgoBzZKsHndC7j/RtLxtOeClNb+VnPKx+9whKKGrB1JGtMKWdZpjM1V
	uAG2AoEhsU8oQgpNQf9gVIOQoai6d0c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-yn-8a6YbP8yV3Z_c1ePfrg-1; Wed, 29 Jul 2026 06:48:25 -0400
X-MC-Unique: yn-8a6YbP8yV3Z_c1ePfrg-1
X-Mimecast-MFC-AGG-ID: yn-8a6YbP8yV3Z_c1ePfrg_1785322105
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-473ac08a6a4so782243f8f.0
        for <virtio-fs@lists.linux.dev>; Wed, 29 Jul 2026 03:48:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785322104; x=1785926904;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZywnHiJedGnDH0gAQ+IBNB/UgtoW/0D+aEiAO17wQm8=;
        b=tARPbt0x+pL1hPWGzF+CwK14XTfjgr7t/H2c0XWvwdJvMd5zi4M1by/31BmZfi6IXW
         H36uyrtv6R7bYVCZjRUChq2bMBC5BflTGXBOkzW/YN//CUuK/vsNrTwfyCiLDyyAKcq9
         hmNd5uCEqIwOijO/UpXGzw9ACyk6n1tHqD0doq8omrS2W0VyNN47v5/9K5VZl0Dc34Fq
         2z765JRxO4xvnMWCCmel9/PyTmhw8MxdZZG7Ar0LA8DnPnbjJlBZSQHDGQL6FDPh6vir
         cnjY4oNKzg4im3F6w6Jo/AvWqK16g+MC+knKz6EG79SGxJy5+ruh516lys+U1Ax7zkb1
         3A+Q==
X-Forwarded-Encrypted: i=1; AHgh+RqyjGPilKZuRNmowfcGuIVpyLwzEp0UickWgYGkA5p8u/IAmQ0D1Ri37ebeia+lT+Tq68yJBNsFvT0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDXLdg477ye4eOrLIlX7f+rtadmAc3ly+6aANvnJaA4x6HjfVc
	ltJ+s8gib3UDs74sDp6RtsuGlTL482XpvjUt03ayDntaedE4qD+a42T2SV2nrE+ov/eFYcUo6t8
	Pn1HDBAKUN8FTwWUh8NyfFR9leo1Ns3plAM2lbmBVH0SFR1D4VX03mplvNhl5cA==
X-Gm-Gg: AR+sD117TCJX7V21o1/KSphNgKdZ3jh3bqnunDM00ZINJZdwoYWaqRStPqWa/EZyGSP
	Z5zB/HApN2sL+QrtlRzCDMprg9aUDX7AR1RhVEAauOBd2nIjUMhPKeZq1S/oD3FVc4a8PSj81u5
	gMZzFL1bXdXEBDpahQ1ABXSxWZut81V0vHFdFRaReIeikj7g+8jK0fVA1TQeghpVScFIeZWr6O3
	lEsa+0Zqj88P5cVvk9Tf+m6OhV7heS3Rp6PySLWo7DnhGnbaZYLK3q4xMPbsaSxWsCn6ewbu4JN
	Fi5Upvy5F4mvIJgDevMf6u57b+yB43ZcGI+szdyMtbCmQzdMve+JzO7pAZNN66iPGwASnV4ukE3
	qxJKmeqTv+YvwnzfBfNCEQOs=
X-Received: by 2002:a05:6000:41ed:b0:46e:230f:d095 with SMTP id ffacd0b85a97d-47fb1e877cdmr7510698f8f.7.1785322104557;
        Wed, 29 Jul 2026 03:48:24 -0700 (PDT)
X-Received: by 2002:a05:6000:41ed:b0:46e:230f:d095 with SMTP id ffacd0b85a97d-47fb1e877cdmr7510649f8f.7.1785322104030;
        Wed, 29 Jul 2026 03:48:24 -0700 (PDT)
Received: from redhat.com (ppp-94-66-118-61.home.otenet.gr. [94.66.118.61])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6abc703sm7017717f8f.9.2026.07.29.03.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 03:48:23 -0700 (PDT)
Date: Wed, 29 Jul 2026 06:48:19 -0400
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
Message-ID: <20260729064648-mutt-send-email-mst@kernel.org>
References: <20260728100841.3475774-1-dtalexundeer@yandex-team.ru>
 <20260728100841.3475774-5-dtalexundeer@yandex-team.ru>
 <20260729051509-mutt-send-email-mst@kernel.org>
 <679a33d1-0f6c-4456-ac76-1f9e1251f2ec@yandex-team.ru>
 <20260729061316-mutt-send-email-mst@kernel.org>
 <a4db1b40-d48c-473b-86a7-63a0c0cc5ccf@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a4db1b40-d48c-473b-86a7-63a0c0cc5ccf@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eiPD3mFWHUf-xhcL3N18iKHGYzAvw_tCNahsGbBHqVg_1785322105
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026 at 03:35:31PM +0500, Alexandr Moshkov wrote:
> 
> On 7/29/26 15:14, Michael S. Tsirkin wrote:
> > On Wed, Jul 29, 2026 at 03:09:57PM +0500, Alexandr Moshkov wrote:
> > > On 7/29/26 14:32, Michael S. Tsirkin wrote:
> > > 
> > >      On Tue, Jul 28, 2026 at 03:08:39PM +0500, Alexandr Moshkov wrote:
> > > 
> > >          When migrating from a QEMU version that supports inflight-migration to
> > >          an older one that does not, there is no way to disable the feature at
> > >          runtime — the VM must be stopped and reconfigured. This is impractical
> > >          in production environments.
> > > 
> > >          Make the inflight-migration property mutable after device realization
> > >          so it can be toggled via qom-set without restarting the VM.
> > > 
> > >          Acked-by: Raphael Norwitz <rnorwitz@nvidia.com>
> > >          Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> > > 
> > > 
> > > 
> > >      I think I am beginning to understand.
> > > 
> > > 
> > >      You are running qemu with inflight-migration on and want to migrate
> > >      to qemu without inflight-migration at all.
> > > 
> > > 
> > >      Since it is guest transparent you could retrofit it like this.
> > > 
> > >      My question is why is it worth it, we do not normally support
> > >      migrating between qemu versions with different command lines.
> > > 
> > > I think you right. Maybe I've been focusing too much on the ability to migrate
> > > between versions of qemu with and without inflight migration.
> > > 
> > > This series allows to turn off and on the inflight-migration feature at runtime
> > > without recreating the VM (it was the only way to turn off the feature, since
> > > the protocol feature could no longer be turned off, after initialization with
> > > the backend). This is more important feature, and it leads to the fact that
> > > this feature allows to migrate between different versions of qemu (with and
> > > without inflight-migration support).
> > > 
> > > 
> > >          ---
> > >           hw/block/vhost-user-blk.c | 10 ++++++++--
> > >           1 file changed, 8 insertions(+), 2 deletions(-)
> > > 
> > >          diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> > >          index e3b873af7c..650c004bde 100644
> > >          --- a/hw/block/vhost-user-blk.c
> > >          +++ b/hw/block/vhost-user-blk.c
> > >          @@ -619,6 +619,8 @@ static const VMStateDescription vmstate_vhost_user_blk = {
> > >               }
> > >           };
> > > 
> > >          +static PropertyInfo vhost_user_blk_inflight_migration_prop;
> > >          +
> > >           static const Property vhost_user_blk_properties[] = {
> > >               DEFINE_PROP_CHR("chardev", VHostUserBlk, chardev),
> > >               DEFINE_PROP_UINT16("num-queues", VHostUserBlk, num_queues,
> > >          @@ -632,8 +634,9 @@ static const Property vhost_user_blk_properties[] = {
> > >                                 VIRTIO_BLK_F_WRITE_ZEROES, true),
> > >               DEFINE_PROP_BOOL("skip-get-vring-base-on-force-shutdown", VHostUserBlk,
> > >                                skip_get_vring_base_on_force_shutdown, false),
> > >          -    DEFINE_PROP_BOOL("inflight-migration", VHostUserBlk,
> > >          -                     inflight_migration, false),
> > >          +    DEFINE_PROP("inflight-migration", VHostUserBlk, inflight_migration,
> > >          +                vhost_user_blk_inflight_migration_prop, bool,
> > >          +                .set_default = true, .defval.u = false),
> > >           };
> > > 
> > >           static void vhost_user_blk_class_init(ObjectClass *klass, const void *data)
> > >          @@ -665,6 +668,9 @@ static const TypeInfo vhost_user_blk_info = {
> > > 
> > >           static void virtio_register_types(void)
> > >           {
> > >          +    vhost_user_blk_inflight_migration_prop = qdev_prop_bool;
> > >          +    vhost_user_blk_inflight_migration_prop.realized_set_allowed = true;
> > >          +
> > >               type_register_static(&vhost_user_blk_info);
> > >           }
> > > 
> > >      So then,  for example, let us say I paused the VM, then set the flag,
> > >      now inflight is on but GET_BASE did not drain it?
> > > 
> > > If I understood the question correctly, this is valid behavior. Before
> > > migration QEMU check protocol features to understand does the backend support
> > > inflight migration. If it does, after that QEMU migrate inflight buffer to
> > > other VM. If it's not, return error before migration started.
> > 
> > I apologise i reverted the logic in the question.
> > 
> > 
> > I start vm and inflight is on.
> > I stop vm get base does not drain.
> 
> In case of VM stop, backend wait to drain all requests. Ability to perform
> drain or not available only during migration by skip_drain variable in
> vhost_user_blk_stop().

What if it was migration but it failed?

> skip_drain true only if inflight_migration is on and runstate is
> FINISH_MIGRATION.

This btw I don't much like, a stopped VM would preferably
behave the same whatever the reason to stop.

> 
> > i turn inflight off.
> > now it looks like it will happily migrate?
> 
> So in this case, when vm migrated with inflight off, it will leads to using
> GET_VRING_BASE message, that wait all requests to be drained.
> 
> > 
> > >          --
> > >          2.34.1
> > > 

