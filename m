Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650C8456290
	for <virtio-fs@lists.linux.dev>; Wed, 29 Jul 2026 18:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785351025; cv=none; b=bNOTpV9PgE2kG1Tx9dw5gu3djnqr4JVuVxP/pwX35sqCxoelRRQbiFfb3F7IvTcXnASR/D8xWMXEaM4U/kTb3fvs07Clv9wQUHC/7rUjCCta4+C1KBzHeYnJZ7uCyPWz7BUGgA7P4YA+Ker1gcGqbXwpC/AQ/4hgG1qxhSpBcf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785351025; c=relaxed/simple;
	bh=rIjaUyuNs/AqE6XyudPl/2eUFsX9EJE/Re7kD2MGQfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=pItuJc13aHSGpvdtRMW87i9hHivS4K8ifYwCgy63t8PkKhChBzlwaPFWyvkSdhJtKq8KeV3RX7qZ9VzA8m50y+DgK3mn4kc3m9sD8MAgviGd5ACiYl1PLuReM4pHK24fBJbqEQNIn9t/PaapwRxxFsM1ei3L8EnTnrMYzyEbGfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U4AXFTkJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U4AXFTkJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785351022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F2KR7Ygtxq3CMEldrrUjrY8KygKhil3J0JPreMiYqQ0=;
	b=U4AXFTkJM1KDD/KyeDalKmmxJOthr2M1tdlSFsarKyoLB+np7TWUgRp9vXcTpX4nxNbR7g
	CAcNBOZvMbdD1FZvpd0bsRff3hXVIHaVoo+Sv4tgqMfix9zuPNQW5MpH/RHLOrNdo2fna0
	tuKdCFRyD2dj8SDB3TGfGDHrj6bIAoc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-RpmgNULqPLGWYxoDn6tGfw-1; Wed, 29 Jul 2026 14:50:20 -0400
X-MC-Unique: RpmgNULqPLGWYxoDn6tGfw-1
X-Mimecast-MFC-AGG-ID: RpmgNULqPLGWYxoDn6tGfw_1785351020
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-698557ec1e9so969358a12.1
        for <virtio-fs@lists.linux.dev>; Wed, 29 Jul 2026 11:50:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785351020; x=1785955820;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=F2KR7Ygtxq3CMEldrrUjrY8KygKhil3J0JPreMiYqQ0=;
        b=nobL2kIZUBYmP/BbuDjgVlNzOGBLTuTCjknAg8TTLQeyrajxx08tFaguhyE9DjZZq8
         Zo99YAzpLGrNfpYWLLj3YEfBH4tZwx1TOVQNyNjC6CDnpYdv0nJHDYwqWNH9yYhl2sE3
         8Wulb/4mjPt/eSlFJT4eloyxabEMDLDb/O/5i22JT5ZyJ/j10zS7H5mteJ0NoTs9f4nd
         WKayEJPI/tsUV3Ou9LapnjtJa/4oy5mG6dgA3QYyML/qw+P9vxS0ZvB50+EmpVv+BTay
         3zDsuNLs6Fbo26Lpr9/bk/b/4PBgDDgu82houJxUvzzRN6hJ/rEGlMvIS8/nCzfcEE/0
         u2Iw==
X-Forwarded-Encrypted: i=1; AHgh+RojrChjOyhiEK/+6yGCHEXvpJHa8zl48R6q1QOPJ2peQB20tP9H12qHs03kjYOkP8EAW6IGZfWiTYg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxb2ZS+PLtanRUcVprXj3fVvRLVmn46HXRQSqus8eSyX3+NVhWK
	aIu1GR49eNzy/0jk2MP79Ik02WZ6/IndTxUPHnWWylsCzg4UktpNGXBwWPTS2SzRje0s0QmTPFL
	job+9cHloeqKO1tH0GhFOIQEmEJTB1IvgF8Uu6manfsDDh10yd4BAKjQeuoZ7JQ==
X-Gm-Gg: AR+sD10kuNdcVuLMb3hgfD6K4nvqe31teBLFtsuxQ3h1LRLf9leZCApIT+r3F9H8AGQ
	6RF8kXdfB3y1/4a9UDI2SDSDr5JX4Daj0ig5xoBg0PcrG3Gc352XUXXYZGbU9AtdmyS9I+oMfUW
	WZ74octuvVsHNBOVP6Zuv96CuteLZ1e9HLNWz/dEZjB8GA/Q6B15zmpvKqLeXzmXY4aQBOH30nb
	gMLKb3wcSLgd9w8c/zUDoJ1VLk3V7E7svg/15962agBNuDF3iz/Mz2v2gpEweqo7f1S31v63XKP
	FzQL0fxJ+bMKxiqUkxUKrfFqjgEZ1BKsL1isoU35KCTTzvaz6+OTZ93iVdGX5zHsAY2Wlg==
X-Received: by 2002:a17:907:9451:b0:c1c:4752:b5fb with SMTP id a640c23a62f3a-c1f72116d8bmr438325866b.27.1785351019500;
        Wed, 29 Jul 2026 11:50:19 -0700 (PDT)
X-Received: by 2002:a17:907:9451:b0:c1c:4752:b5fb with SMTP id a640c23a62f3a-c1f72116d8bmr438321766b.27.1785351018894;
        Wed, 29 Jul 2026 11:50:18 -0700 (PDT)
Received: from redhat.com ([186.247.166.227])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1f83f4de50sm150186366b.37.2026.07.29.11.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 11:50:18 -0700 (PDT)
Date: Wed, 29 Jul 2026 14:50:12 -0400
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
Message-ID: <20260729144949-mutt-send-email-mst@kernel.org>
References: <20260729051509-mutt-send-email-mst@kernel.org>
 <679a33d1-0f6c-4456-ac76-1f9e1251f2ec@yandex-team.ru>
 <20260729061316-mutt-send-email-mst@kernel.org>
 <a4db1b40-d48c-473b-86a7-63a0c0cc5ccf@yandex-team.ru>
 <20260729064648-mutt-send-email-mst@kernel.org>
 <dd1f5830-75ff-4256-a179-6a8341a3b4ec@yandex-team.ru>
 <20260729074711-mutt-send-email-mst@kernel.org>
 <364c33f6-9a7e-4efa-a497-3b551095469a@yandex-team.ru>
 <20260729103653-mutt-send-email-mst@kernel.org>
 <fd6939fc-df30-499f-8313-767761270b80@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <fd6939fc-df30-499f-8313-767761270b80@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XNHGTfgXgKFuFq-Vg-_HB2gxBJ_FVGg6CktEfL23N48_1785351020
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026 at 08:18:19PM +0500, Alexandr Moshkov wrote:
> 
> On 7/29/26 19:48, Michael S. Tsirkin wrote:
> > On Wed, Jul 29, 2026 at 07:07:11PM +0500, Alexandr Moshkov wrote:
> > > On 7/29/26 17:13, Michael S. Tsirkin wrote:
> > > > On Wed, Jul 29, 2026 at 03:56:54PM +0500, Alexandr Moshkov wrote:
> > > > > On 7/29/26 15:48, Michael S. Tsirkin wrote:
> > > > > 
> > > > >       On Wed, Jul 29, 2026 at 03:35:31PM +0500, Alexandr Moshkov wrote:
> > > > > 
> > > > >           On 7/29/26 15:14, Michael S. Tsirkin wrote:
> > > > > 
> > > > >               On Wed, Jul 29, 2026 at 03:09:57PM +0500, Alexandr Moshkov wrote:
> > > > > 
> > > > >                   On 7/29/26 14:32, Michael S. Tsirkin wrote:
> > > > > 
> > > > >                        On Tue, Jul 28, 2026 at 03:08:39PM +0500, Alexandr Moshkov wrote:
> > > > > 
> > > > >                            When migrating from a QEMU version that supports inflight-migration to
> > > > >                            an older one that does not, there is no way to disable the feature at
> > > > >                            runtime — the VM must be stopped and reconfigured. This is impractical
> > > > >                            in production environments.
> > > > > 
> > > > >                            Make the inflight-migration property mutable after device realization
> > > > >                            so it can be toggled via qom-set without restarting the VM.
> > > > > 
> > > > >                            Acked-by: Raphael Norwitz <rnorwitz@nvidia.com>
> > > > >                            Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> > > > > 
> > > > > 
> > > > > 
> > > > >                        I think I am beginning to understand.
> > > > > 
> > > > > 
> > > > >                        You are running qemu with inflight-migration on and want to migrate
> > > > >                        to qemu without inflight-migration at all.
> > > > > 
> > > > > 
> > > > >                        Since it is guest transparent you could retrofit it like this.
> > > > > 
> > > > >                        My question is why is it worth it, we do not normally support
> > > > >                        migrating between qemu versions with different command lines.
> > > > > 
> > > > >                   I think you right. Maybe I've been focusing too much on the ability to migrate
> > > > >                   between versions of qemu with and without inflight migration.
> > > > > 
> > > > >                   This series allows to turn off and on the inflight-migration feature at runtime
> > > > >                   without recreating the VM
> > > > restarting you mean.
> > > Yes, sorry.
> > > > > (it was the only way to turn off the feature, since
> > > > >                   the protocol feature could no longer be turned off, after initialization with
> > > > >                   the backend). This is more important feature, and it leads to the fact that
> > > > >                   this feature allows to migrate between different versions of qemu (with and
> > > > >                   without inflight-migration support).
> > > > so again it's not the 1st feature we have like this. we tie migration
> > > > to the machine type and same set of command line flags
> > > > specifically to keep things manageable.
> > > > 
> > > > really cross version migration is a pain as it is.
> > > I understand that, thanks! Maybe we should focus on the fact that this
> > > series allows to turn inflight_migration on and off (without cross version
> > > migration) ?
> > > 
> > > Firstly, I wanted to implement this through migration capabilities, but in
> > > one of the threads,
> > > it was agreed that a separate capability only for vhost-user-blk is not a
> > > good idea.
> > I mean it's a generic thing.
> > 
> > > Therefore, I implemented it through a parameter that can be changed using
> > > qom-set.
> > > 
> > > > >                            ---
> > > > >                             hw/block/vhost-user-blk.c | 10 ++++++++--
> > > > >                             1 file changed, 8 insertions(+), 2 deletions(-)
> > > > > 
> > > > >                            diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> > > > >                            index e3b873af7c..650c004bde 100644
> > > > >                            --- a/hw/block/vhost-user-blk.c
> > > > >                            +++ b/hw/block/vhost-user-blk.c
> > > > >                            @@ -619,6 +619,8 @@ static const VMStateDescription vmstate_vhost_user_blk = {
> > > > >                                 }
> > > > >                             };
> > > > > 
> > > > >                            +static PropertyInfo vhost_user_blk_inflight_migration_prop;
> > > > >                            +
> > > > >                             static const Property vhost_user_blk_properties[] = {
> > > > >                                 DEFINE_PROP_CHR("chardev", VHostUserBlk, chardev),
> > > > >                                 DEFINE_PROP_UINT16("num-queues", VHostUserBlk, num_queues,
> > > > >                            @@ -632,8 +634,9 @@ static const Property vhost_user_blk_properties[] = {
> > > > >                                                   VIRTIO_BLK_F_WRITE_ZEROES, true),
> > > > >                                 DEFINE_PROP_BOOL("skip-get-vring-base-on-force-shutdown", VHostUserBlk,
> > > > >                                                  skip_get_vring_base_on_force_shutdown, false),
> > > > >                            -    DEFINE_PROP_BOOL("inflight-migration", VHostUserBlk,
> > > > >                            -                     inflight_migration, false),
> > > > >                            +    DEFINE_PROP("inflight-migration", VHostUserBlk, inflight_migration,
> > > > >                            +                vhost_user_blk_inflight_migration_prop, bool,
> > > > >                            +                .set_default = true, .defval.u = false),
> > > > >                             };
> > > > > 
> > > > >                             static void vhost_user_blk_class_init(ObjectClass *klass, const void *data)
> > > > >                            @@ -665,6 +668,9 @@ static const TypeInfo vhost_user_blk_info = {
> > > > > 
> > > > >                             static void virtio_register_types(void)
> > > > >                             {
> > > > >                            +    vhost_user_blk_inflight_migration_prop = qdev_prop_bool;
> > > > >                            +    vhost_user_blk_inflight_migration_prop.realized_set_allowed = true;
> > > > >                            +
> > > > >                                 type_register_static(&vhost_user_blk_info);
> > > > >                             }
> > > > > 
> > > > >                        So then,  for example, let us say I paused the VM, then set the flag,
> > > > >                        now inflight is on but GET_BASE did not drain it?
> > > > > 
> > > > >                   If I understood the question correctly, this is valid behavior. Before
> > > > >                   migration QEMU check protocol features to understand does the backend support
> > > > >                   inflight migration. If it does, after that QEMU migrate inflight buffer to
> > > > >                   other VM. If it's not, return error before migration started.
> > > > > 
> > > > >               I apologise i reverted the logic in the question.
> > > > > 
> > > > > 
> > > > >               I start vm and inflight is on.
> > > > >               I stop vm get base does not drain.
> > > > > 
> > > > >           In case of VM stop, backend wait to drain all requests. Ability to perform
> > > > >           drain or not available only during migration by skip_drain variable in
> > > > >           vhost_user_blk_stop().
> > > > > 
> > > > >       What if it was migration but it failed?
> > > > > 
> > > > > If migration failed, source vm just keep using inflight region, backend
> > > > > continue to execute inflight requests that was tried to migrate.
> > > > Sorry, to be more clear. I mean migration succeeded but destination failed to
> > > > start, so now vm is stopped and we are now trying migrating to a different destination.
> > > Is this a real case? I was thinking in case of any destination errors
> > > (migration process or starting), source vm has to work...
> > It does not start automatically in all cases, no.
> > 
> > > I guess in that case, inflight requests can only be executed on different
> > > destination or in current destination if vm be able to start.
> > > 
> > > > IIUC currently on VM stop we simply send GET_BASE and this stops
> > > > backend, and depending on features things remain in the inflight buffer.
> > > > Correct me if  I am wrong.
> > > Yes backend has to disconnect from QEMU.. So it not be changing guest
> > > memory.
> > > > I think that we do not want a slow flush on vm stop if we
> > > > can avoid it, and we also do not want backend to keep changing
> > > > guest memory when VM is stopped. No?
> > > Yes, it is
> > > > >           skip_drain true only if inflight_migration is on and runstate is
> > > > >           FINISH_MIGRATION.
> > > > FINISH_MIGRATE? actually i do not see where it affects it.
> > > Sorry, I didn't understand) Who affects who?
> > 
> > > > >       This btw I don't much like, a stopped VM would preferably
> > > > >       behave the same whatever the reason to stop.
> > > > > 
> > > > > Well, I don't see any other way to implement this.
> > > > I am not 100% sure it's implementable as described, but I guess
> > > > you could block changing the property if VM and thus the backend
> > > > is not connected and running.
> > > > 
> > > > 
> > > > Which is even more complexity but at least it is consistent.
> > > Oh, I understand what you thinking about.
> > > 
> > > I agreed, but why implementation (in this series) is not consistent? I was
> > > thinking that current (in current qemu version) impl is not, because
> > > GET_VRING_BASE has two behaviors, depending on the presence of the protocol
> > > feature (drain or not drain requests).
> > > 
> > > Now, I think it would be more clear: one message for drain GET_VRING_BASE
> > > (as it was before), one for not drain GET_VRING_BASE_SKIP_DRAIN.
> > 
> > Well the message is consistent. But its use does not seem to be.
> > 
> > > > 
> > > > 
> > > > 
> > > > 
> > > > 
> > > > > I think backend must perform
> > > > > drain in all cases except live migration with all the necessary checks
> > > > > (protocol features, special message GET_VRING_BASE_SKIP_DRAIN).
> > > > This is not what is going on now, right? Whether it drains depends
> > > > on protocol features not on VM state and I think we should
> > > > keep it like this.
> > > Well yes, now in current qemu version drain or not drain depends on protocol
> > > feature only, that try to be negotiated only if inflight_migration is set
> > > on.
> > > 
> > > In patch: in case live migration (if protocol feature and  device param)
> > > sent message GET_VRING_BASE_SKIP_DRAIN to skip drain, in other cases sent
> > > other message - GET_VRING_BASE with draining all requests.
> > > So drain or not drain depends on message that QEMU send to backend.
> > > 
> > > > 
> > > > >               i turn inflight off.
> > > > >               now it looks like it will happily migrate?
> > > > > 
> > > > >           So in this case, when vm migrated with inflight off, it will leads to using
> > > > >           GET_VRING_BASE message, that wait all requests to be drained.
> > > > > 
> > > > > 
> > > > >                            --
> > > > >                            2.34.1
> > > > > 
> > > > > 
> > > > i mean it migrated with on. vm was stopped then it flipped to off.
> > > After stop vm will send GET_VRING_BASE to backend, that lead to drain all
> > > requests. Non of the inflight requests will be missed here, If that's what
> > > you mean.
> > this:
> > 
> > +    bool skip_drain = vhost_user_blk_inflight_needed(s) &&
> > +                      runstate_check(RUN_STATE_FINISH_MIGRATE);
> > 
> > is what I dislike.
> > 
> > I dislike poking at migration state. It's painful enough that we
> > need to worry about VM running or not.
> 
> I understand that. But I don't know how to do it another way. We can't just
> erase runstate check - it will possibly leads to missing inflight requests
> during VM stop.
> 
> And don't know how to make stop more consistent. Do you have any thoughts?


Block disabling this when VM is not running.

> > > > 
> > > > 
> > > > 
> > > > 

