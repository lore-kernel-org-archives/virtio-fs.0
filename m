Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A5A262FFC
	for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 19:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768417841; cv=none; b=cv4RjpFGBp5S47KFgfqrLf6asWaLVbj6YPS3ne4vDp2jPlUOwFQyUJ3RVv6iRAvxcGuKjhW35GszssF9lBPWZlTq5+BPkfSvK3kUu+XCbLCRXdAsloESAn52d/6Q8ufQiVudVq/ys5BUaFs0XK9AGcbMOA+9a9X2Batc9OXZkTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768417841; c=relaxed/simple;
	bh=pntuGKZIcrII9bi4OGLwjyfJ+XLwPz8dFl8btjU5aQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=CCsBaUPCZ9c9Qq5MjjNQ0ildJh0lGfOA8rcMWRv1UAOQz0gM5gEOjZSjoToTphDrHgJUasKdWeWIUxl79MVkIywAzcDv70UpoJ2uOT5ejruFz39bZMjPfxSCOrTFiD3yxSQXVC9hj532IzMKh0xyyv9ZkCYJ5jKl+BNLQHDLl5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YDcrEsWu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YDcrEsWu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768417839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H0RWyaklsh7/VwkNG3/F+SfJeMQuOjSuf2itmgiiaXs=;
	b=YDcrEsWuXGEjD8VN5zjWMFCy9q9qqX9JaCtHWcADr1ykEheuxYh4MaBjhxbXKp5kYcgVrL
	t2ncdQZWrfS16jfkJNm49i5RR+Ttw9pQaGIf/9YCkNgfQWgkCujoG0pUo6GM7L3O1AKnd3
	0fJUkSRVZ1sDuJrE1wKr0PwEyOcAEgo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-sPG-r9lVPzSLsE6b4uza3g-1; Wed, 14 Jan 2026 14:10:37 -0500
X-MC-Unique: sPG-r9lVPzSLsE6b4uza3g-1
X-Mimecast-MFC-AGG-ID: sPG-r9lVPzSLsE6b4uza3g_1768417836
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-88a360b8096so2633436d6.0
        for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 11:10:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768417836; x=1769022636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H0RWyaklsh7/VwkNG3/F+SfJeMQuOjSuf2itmgiiaXs=;
        b=gjNmAcT+fGcJylCbTueoTjxhDxOgWHwl1sVp4SjAUUC1ZKYq9/zWEM/glXB1MuMs/S
         ZnQyG5QWOPV/dDEMIedHiwdnxLAp5sgdAQ5PG9buWM4xuGQzWsigqtr8cNEc26ClEvBo
         LrlbsSm62xAHWk7kWSQfs6vkvSWZs3w27ywoLmCQTy55aryj1qIUEMRVH/ufIvQs6uqs
         QAuboop/7bzKHEYRTJr7/xSnJeDqjitPi6Y1wH3OnDYGyxLv/RA2PDK0kVG9QiPvH8m7
         eel3O5J2U/bFm8uxX36iY4BGLY+aR8DXhTN/0HtRTGgSR+fjGNyBsoGjrk2f7pvT7trn
         8dnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoWae/Rx9fKNrFSwvDFck4ynSZuZcNJGWRH5nc+5g7tlstWzawL2R6j83effVKW94P8O8vokbyDho=@lists.linux.dev
X-Gm-Message-State: AOJu0YyapkmYkFAwsH22lUSKOko5/KCDcK2oAV+78olsGc2FUA9UCEJy
	uj1VCPKn7JF8NToobKrQNaPioUs/bT3q5xD+i+vf8X6zPf0sUdkxIGaw/ME4/HIhOnVRbhGxeCm
	atC/Tudwy/Os3Tgw4yMn8OCLFWAqeHt39EkHZMrtkQbgKOi9rryArmkBetcKr+w==
X-Gm-Gg: AY/fxX6CO6eWVfZ8pszFRGTr8L0rYTb2t62zQSHbR9GYDMnOaaU5ZxuGPM9Nk1JrWs+
	+7x/trpFOZFXF9PoUBwCTIx3KX6B4uMMCn3uow588W63sk3HEGFcQy0iSzvRkOMgyANwUO2w/+f
	D5jTzB1L98y5NWqfN29mUJhwb6TCJg2VWC7DjAASUoWbggl3Oqf0WMyU/P5JHKV4+vAEk/8ImWX
	YPtF5b+Obm3DuI+vxhDvU02zpiUNPBgZpjxM/JydMX66reJPuZNnvS111YbfcGjMhGswGPD8XPz
	lBr6KSXkGxMYJ0lzGWyXbP2sSuw71iXJE8HQJ1myg+zCkwSb1IvP0e6qHS8il9gyt6knSfNmhd9
	vZ90=
X-Received: by 2002:ad4:5943:0:b0:890:8436:c82e with SMTP id 6a1803df08f44-89274362aa5mr48613526d6.14.1768417836196;
        Wed, 14 Jan 2026 11:10:36 -0800 (PST)
X-Received: by 2002:ad4:5943:0:b0:890:8436:c82e with SMTP id 6a1803df08f44-89274362aa5mr48612926d6.14.1768417835661;
        Wed, 14 Jan 2026 11:10:35 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770ce985sm179809136d6.11.2026.01.14.11.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 11:10:35 -0800 (PST)
Date: Wed, 14 Jan 2026 14:10:33 -0500
From: Peter Xu <peterx@redhat.com>
To: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>,
	qemu-devel@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Zhenwei Pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raphael Norwitz <raphael@enfabrica.net>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	mzamazal@redhat.com, Fabiano Rosas <farosas@suse.de>,
	qemu-block@nongnu.org, virtio-fs@lists.linux.dev,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH v6 0/5] support inflight migration
Message-ID: <aWfqKdamP4rnZqvH@x1.local>
References: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
 <20260113181242.GB528940@fedora>
 <aWaVVJh13ctiW9Ku@x1.local>
 <2af404d1-5e50-4caa-bee6-f8aab6a30a7e@yandex-team.ru>
 <aWeKn5A7-tWaWv0z@x1.local>
 <832f4005-2e51-49fd-91e8-9f4cbe9f2adf@yandex-team.ru>
 <aWezg94AB5a3F0EV@x1.local>
 <d5c106d9-9e37-4f44-b0e9-4321d12f8bf1@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d5c106d9-9e37-4f44-b0e9-4321d12f8bf1@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fmYWZoCH2vQoW3eyF2d-t3L6RvjBpZi5kAZzmKq6JVg_1768417836
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Jan 14, 2026 at 08:54:50PM +0300, Vladimir Sementsov-Ogievskiy wrote:
> On 14.01.26 18:17, Peter Xu wrote:
> > On Wed, Jan 14, 2026 at 05:35:53PM +0300, Vladimir Sementsov-Ogievskiy wrote:
> > > On 14.01.26 15:22, Peter Xu wrote:
> > > > On Wed, Jan 14, 2026 at 09:19:10AM +0300, Vladimir Sementsov-Ogievskiy wrote:
> > > > > On 13.01.26 21:56, Peter Xu wrote:
> > > > > > On Tue, Jan 13, 2026 at 01:12:42PM -0500, Stefan Hajnoczi wrote:
> > > > > > > On Tue, Jan 13, 2026 at 02:58:09PM +0500, Alexandr Moshkov wrote:
> > > > > > > 
> > > > > > > Peter: Please review the migration aspects (especially the vmstates).
> > > > > > > Thank you!
> > > > > > 
> > > > > > Looks good from my side as long as it's based on VMSD, I appreciate that
> > > > > > change from the old versions where it used to use qemufile APIs.
> > > > > > 
> > > > > > The major question here is if this series depends on Vladimir's other
> > > > > > series
> > > > > 
> > > > > No, it does not. And if we can proceed with merging these series first, I'll
> > > > > be happy to rebase on top of it.
> > > > 
> > > > I thought it requires migrate_local_vhost_user_blk() be present?  The
> > > > inflight feature should not be enabled only if there's a hint that it's a
> > > > local migration..
> > > 
> > > Oh right, I missed it.
> > > 
> > > We discussed that Alexandr will rebase the series on master without dependency
> > > on my RFC.
> > 
> > The problem is IIUC the new INFLIGHT feature bit will be declared as
> > supported to vhost-user-block after applying this series.  Then if we start
> > a remote migration (rather than local) it'll be automatically (and wrongly)
> > enabled?
> > 
> 
> No, not so.
> 
> We develop inflight-region migraiton (this series) exactly for remote migration,
> not for local.
> 
> My series about backend transfer (fd-migration) will migrate inflight-region the
> other way - by migrating its FD.

Ah, I see.. Yes I think you're right then there's no dependency needed.
Please go ahead with the repost.

Thanks,

-- 
Peter Xu

