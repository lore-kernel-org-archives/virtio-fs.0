Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F60C31B108
	for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 15:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768403851; cv=none; b=IWGCehT8/q7X6H83AetdphJRhSNsRqaNuQ+8p2546d2dzkxDxVSKDdf0N9KwDcRi3TCmOwJ59g5q0fonlDOmsFbnvYE9TJXUHDC6SoEEGrDqk1iHP13xC79DezCVHC1KY9mFnrt3aHBpYCwHUy3wan3X98Zq0SZ/Q5hxUcJeW3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768403851; c=relaxed/simple;
	bh=cGkhVVGjqKZjapfrZbkJvS3W+9rk9KxRselyODaRqLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=qOI3psSobX1V7CgK7fgEWv29ie9mQAcX123ul4MXMegv8S12xisy9uCRj0KjoNeHYUdC75HTUJLgXbo7+EDhVsGBnSWMUoTTyjS4md4VdUp9C0d1J1vkNzAuuAlS3mQYFnY/1kOV2vCjTRsYWDvZuPll8aXVayweo2voF9QXpVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dv3UIKDw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dv3UIKDw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768403848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j3seQXZjw+28+mx3Tr/xlZXK2Idg9HhvWuCCmUoYFyo=;
	b=dv3UIKDwEA1yV2/5T65msHZw7yEGI1Vo1IUPZhEZS2MmMEe6hyKQ+NrgQF9iyqbLrp/sMn
	TBjABtIzYDvvtKi4H7JXHcgK8+UgJ96eM2GxZ3Z2Do32HEYvDXdH4PXN4zVQagKAJFqR+y
	u9bU2MK9wnspNxmdkm45XLPlwLgQGdM=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-XfPoF-OcO5u24A0ct3B3OA-1; Wed, 14 Jan 2026 10:17:27 -0500
X-MC-Unique: XfPoF-OcO5u24A0ct3B3OA-1
X-Mimecast-MFC-AGG-ID: XfPoF-OcO5u24A0ct3B3OA_1768403846
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-5ec87b2b4ddso6959244137.3
        for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 07:17:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768403846; x=1769008646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j3seQXZjw+28+mx3Tr/xlZXK2Idg9HhvWuCCmUoYFyo=;
        b=w76bBm5ohN6BdHnGgW7j2jHHmH3r0aDnlKrcJ82Zgcx5jH+kmgDx9lZKB3/FJtkJtN
         hKZY9G/7MMAPMDeakqb5lYMk4qv2uXbnzHcrgq6/9JXlfFClS/9O2blCZPU3OihBN+2a
         FZOoQnnxlbmStHg8FickSfw/tWkC0bMIfptHSrh9LW0jZvVdXjdKJID74SQ+nMrfhPoA
         0Ibi2vIkf9hQ1ZgK6HJNN+ux+QmEzG5ojZGMULjG6Eah5kb5GBPx/UzN56Xzm7iJdJ/n
         bk5Q38aeWIwuibNtBCo+BKDKlyzUU5mRbHtqZCkgRDfeelAn68iuf7JwwRb6gtc+EqK7
         nVjw==
X-Forwarded-Encrypted: i=1; AJvYcCWB62np8YxcX9D3tYe4EbsGUKAoAMm0rMB5illXc64zAcYoca7AEOL90AuJRHTRcv8dCyXN/tWK4vs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxTcMmzoYj6ZVARm+xS/OCT6n0NFDu4MFDbQw+pEIcyRU9/EpDj
	FsZKW8ZswrAp6Mb0YsMIOQCeP2GEIOFiIcbONMfAFP/zt1NyLl00m5hKBwx2zp7gSKgBOyBhrZ9
	sly6tGGfxZTj7reKbZrtX3nHqmF3Cm2DqUwCgNtAdkRWUXkE/Rx69MMxV+XtF7w==
X-Gm-Gg: AY/fxX7iwMf3on3YZIgXhPKAT+8M+E1l884lErbd4Jbs3k8QfOCQYmoc5id3HTWckJt
	uyWQQs1yQW/+cCCiUBNjQIYm0IECc+1/bT2Dwms+3Q5h5BlXCBEy4xkVD7eGeng52oR7ikPdJyu
	mj2hPu7Sjb4gK/lxJ+SmREbewoMH9VIA+UppcXIy4yElSKXNute6XQP5hedBSfgSxq5VWLsE+xL
	NJUm4VbEFLNRvMGLMnueGa5iG005zBlLLboZlPVXHD/UuKxwMtBFbPkGnIyg8Htc2BB1hbdOP79
	EPB+TnK47KTPIsH6ukcxqhP8ZKVXp7ezKxcm95mcj0HsEJEEiEu9y8ppNlrigQ8MPMZ8Vv9vPFS
	xiZc=
X-Received: by 2002:a05:6102:6893:b0:5e8:1d93:921a with SMTP id ada2fe7eead31-5f1838c4bb8mr838261137.15.1768403846492;
        Wed, 14 Jan 2026 07:17:26 -0800 (PST)
X-Received: by 2002:a05:6102:6893:b0:5e8:1d93:921a with SMTP id ada2fe7eead31-5f1838c4bb8mr838209137.15.1768403845950;
        Wed, 14 Jan 2026 07:17:25 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770cc7b1sm177183316d6.5.2026.01.14.07.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 07:17:25 -0800 (PST)
Date: Wed, 14 Jan 2026 10:17:23 -0500
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
Message-ID: <aWezg94AB5a3F0EV@x1.local>
References: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
 <20260113181242.GB528940@fedora>
 <aWaVVJh13ctiW9Ku@x1.local>
 <2af404d1-5e50-4caa-bee6-f8aab6a30a7e@yandex-team.ru>
 <aWeKn5A7-tWaWv0z@x1.local>
 <832f4005-2e51-49fd-91e8-9f4cbe9f2adf@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <832f4005-2e51-49fd-91e8-9f4cbe9f2adf@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -YRkGbPbqxMk1iTqLIOmVSCe9BaIjuq7n2F6FFrhD5A_1768403846
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Jan 14, 2026 at 05:35:53PM +0300, Vladimir Sementsov-Ogievskiy wrote:
> On 14.01.26 15:22, Peter Xu wrote:
> > On Wed, Jan 14, 2026 at 09:19:10AM +0300, Vladimir Sementsov-Ogievskiy wrote:
> > > On 13.01.26 21:56, Peter Xu wrote:
> > > > On Tue, Jan 13, 2026 at 01:12:42PM -0500, Stefan Hajnoczi wrote:
> > > > > On Tue, Jan 13, 2026 at 02:58:09PM +0500, Alexandr Moshkov wrote:
> > > > > 
> > > > > Peter: Please review the migration aspects (especially the vmstates).
> > > > > Thank you!
> > > > 
> > > > Looks good from my side as long as it's based on VMSD, I appreciate that
> > > > change from the old versions where it used to use qemufile APIs.
> > > > 
> > > > The major question here is if this series depends on Vladimir's other
> > > > series
> > > 
> > > No, it does not. And if we can proceed with merging these series first, I'll
> > > be happy to rebase on top of it.
> > 
> > I thought it requires migrate_local_vhost_user_blk() be present?  The
> > inflight feature should not be enabled only if there's a hint that it's a
> > local migration..
> 
> Oh right, I missed it.
> 
> We discussed that Alexandr will rebase the series on master without dependency
> on my RFC.

The problem is IIUC the new INFLIGHT feature bit will be declared as
supported to vhost-user-block after applying this series.  Then if we start
a remote migration (rather than local) it'll be automatically (and wrongly)
enabled?

AFAIU, the dependency makes sense, at least to the patch to introduce the
"local" / ... capability?

-- 
Peter Xu

