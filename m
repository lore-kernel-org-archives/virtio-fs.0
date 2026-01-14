Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C362739447C
	for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 12:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768393384; cv=none; b=P3NufvvwJA/7WBKIGlj6gv3psSO36RuwZQskM3CdcMq3VqhlYFwoc18EUJgN/hCC/tWmCs4EE15p4e5gq9IXMU/ir0FeqDPlsgioj+UHCDJPG8kHCTUNNQLuOR6oozc/OexMNCuC7COauhB8FeOhC+H1+g+hPSg6e1b37aIBSfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768393384; c=relaxed/simple;
	bh=N32EzStJqNnoeh/yWmt+oWL5pgPy4oZJBI4cmxIFXho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=B8FM7kicDdDqsHiaCF9B8soeQDZtw2u7bKFdMa8SI9C3P9alc6JVS8V5vDgQzslQ41wHH6rhpzN9EwLuNT36Ohk31Bqe4PipoKet+E/nFLvkhBgSqfTKdOtTbYLS8jJA1tPS1bPj1n4Q1gcqrmQEpG6JDtAn6vSLSY0AhA2SSi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ghZvqo+n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ghZvqo+n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768393381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6hdiooh6NrQsiBujMo60ueod3VrVFVCWn9eH7aYK3Iw=;
	b=ghZvqo+nSqiljPm7MuCLhBch+8Go8we2xNGD2CSLiwL2aweu9kxOmnvpb5oAtG1IATCjkl
	IarELquatEoxVUCfcUK/8Fk1vbqHYmGYL7umfdOEH7cP4g5daM1jwQPJLNRw+akjWt5740
	2dnlSvaKXl2U0AYkP+gikOQvZeLem2k=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-VDyW_6hLOlmhDAsOYYO6dA-1; Wed, 14 Jan 2026 07:22:59 -0500
X-MC-Unique: VDyW_6hLOlmhDAsOYYO6dA-1
X-Mimecast-MFC-AGG-ID: VDyW_6hLOlmhDAsOYYO6dA_1768393379
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-88a47331c39so238666916d6.2
        for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 04:22:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768393378; x=1768998178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6hdiooh6NrQsiBujMo60ueod3VrVFVCWn9eH7aYK3Iw=;
        b=Gn+cfW/LDORbyDiAQmSW5412pe29gq8DGGOG2JTdpTZqBV3rmTow3mQY8F5HP7wJ10
         szXHWQa6Kj5C7bQLe8Njj3TYgBjDz/SpuJEdR0gkk64ms7udA5T17Vvb1dWgcYZAeA+w
         JY1MV+joM6Ds/41INDN+8Ih1RzGHyzROdcT/YldaHqGDWmAfwS0r9+SVrTs8wfGuWR+q
         q1nDrGctbNhRWeDiE+oTbP38QU9vtOcNORZNBMYXGUpHlngSUzXGcnwuV61ZmDzXzcHz
         EwbJ4r7FB43ThnJFJkgRzn8CLDQVtgDnzBkldf1JV5PM+b8b11Z1rFB3eB7ocIj50NN/
         J/pw==
X-Forwarded-Encrypted: i=1; AJvYcCUNzV+xbUoLXU7luFhZbmGgME12g9oOk7D6wRSJr7wMnZ3wb6FCT7AuSXcKRQznYqjwgVhjqW72UyQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxbftFd6GdHyV515mNTGlm8rnDRQkw7vyBlNn4bB0q/FN2TJJbX
	0PEwR/ESFD4cQVRBUjGrl8blfoPJM95C4eHx59bpDy6G0ccN9lewdbenT1o24DRjDiBcT3shhVo
	8uwNgEkCyJgVuBvFNDKpo8ZGmxOBpuO6HzSbGkmKZkQG1QA3+Nya1UfMKR02WYA==
X-Gm-Gg: AY/fxX7ejL/7khGh27dAKFHnFDxIXCtsVkSb3XpvXPDgYU5Bmh2dnDRyq8eBpbjT94p
	dcVS/irXDBTCSKHkL8PaBncsJU0lBlR8eDRDX/hz4XyXQJPsBr00iYYWFvoEYlfBgrA4uWZ6j+N
	mp6wxJmqhU8/QoJQUdjGOeiGnDOo7uEm7BJzDnPV0lgGFLzFp9QM8jfSfG+dVdw9VF70LMPgVJs
	+bcH671fSQsU6ZDB0y9HYpdsYMWqHRdRGa+7k4rstDzfBT7N58GUHvuPzJ9b+qFCz2D9aaeTGIA
	P11FkV5iZG4Xha+i4SJNYQAfZ7XZUicKDJ/OW7am/JbHdJ6hVfHkxtQXd0KZVFw7fr3PFNFSmCA
	RpXg=
X-Received: by 2002:a05:6214:21ed:b0:880:5193:1102 with SMTP id 6a1803df08f44-892743cf6a6mr28041986d6.56.1768393378078;
        Wed, 14 Jan 2026 04:22:58 -0800 (PST)
X-Received: by 2002:a05:6214:21ed:b0:880:5193:1102 with SMTP id 6a1803df08f44-892743cf6a6mr28041436d6.56.1768393377556;
        Wed, 14 Jan 2026 04:22:57 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770e2a8fsm176650066d6.16.2026.01.14.04.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 04:22:57 -0800 (PST)
Date: Wed, 14 Jan 2026 07:22:55 -0500
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
Message-ID: <aWeKn5A7-tWaWv0z@x1.local>
References: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
 <20260113181242.GB528940@fedora>
 <aWaVVJh13ctiW9Ku@x1.local>
 <2af404d1-5e50-4caa-bee6-f8aab6a30a7e@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2af404d1-5e50-4caa-bee6-f8aab6a30a7e@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zPkV-0w45qz6AfWf3TRDZhJjSe-scz2XO32vd2znG_k_1768393379
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Jan 14, 2026 at 09:19:10AM +0300, Vladimir Sementsov-Ogievskiy wrote:
> On 13.01.26 21:56, Peter Xu wrote:
> > On Tue, Jan 13, 2026 at 01:12:42PM -0500, Stefan Hajnoczi wrote:
> > > On Tue, Jan 13, 2026 at 02:58:09PM +0500, Alexandr Moshkov wrote:
> > > 
> > > Peter: Please review the migration aspects (especially the vmstates).
> > > Thank you!
> > 
> > Looks good from my side as long as it's based on VMSD, I appreciate that
> > change from the old versions where it used to use qemufile APIs.
> > 
> > The major question here is if this series depends on Vladimir's other
> > series
> 
> No, it does not. And if we can proceed with merging these series first, I'll
> be happy to rebase on top of it.

I thought it requires migrate_local_vhost_user_blk() be present?  The
inflight feature should not be enabled only if there's a hint that it's a
local migration..

I'll comment inline on the patch later.

> 
> > while there's still one patch that is not-for-merge:
> > 
> > https://lore.kernel.org/all/20251016114104.1384675-24-vsementsov@yandex-team.ru/#t
> > 
> > Does it automatically mark this series RFC as well?
> > 
> > Personally speaking, a new migration cap would work all fine, we should
> > have discussed it somewhere previously.  Said that, "local-vhost-user-blk"
> > capability is likely not the right one.  IMHO it should be either "local"
> > or "fd-passing" / "fd-passthrough" (or something generic) as the name.  If
> > we are not sure if we will leverage more than "passing the FDs around", we
> > can make it as simple as "local" as a new migration capability.
> > 
> > Then migration's misc.h should export a function migrate_is_local() then
> > device code can probe that in its own vmstate handling paths on save/load.
> > 
> > A note to Vladimir: please remember to add a check to enforce UNIX socket
> > when a formal patch 23 will be proposed some day, no matter what is the
> > name of the capability.  It should fail qmp "migrate" or qmp
> > "migrate_incoming" command if the main URI is not a unix socket.
> > 
> 
> Thanks! I'll keep that in mind when prepare next version.
> 
> -- 
> Best regards,
> Vladimir
> 

-- 
Peter Xu

