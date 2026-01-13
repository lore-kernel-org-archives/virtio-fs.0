Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306611DEFE9
	for <virtio-fs@lists.linux.dev>; Tue, 13 Jan 2026 18:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768330587; cv=none; b=rxw+rygLaQgUu/fovN88kVioKqUHjptMkLDmtIhdQF09tpx5p356CBopXM8zX5VzYYbtyiBx0oq8DPiQOlhczbphnjILBVwmCl/a88rPgerL+WZoI4gIHASN6ZB7VZJcYj1qrL8r524n8yG6DdYVw7nt3p6WEdupODbCdYJDUm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768330587; c=relaxed/simple;
	bh=RtTWtXx8drx3mv4ikMRNDOd24pLE08Px4ZCLe+HF09M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=adEIIWFcxgd18zSEPnC+IsKAL57DhbpL9KLaGAbqw5P/P6UrWRNrPmX9RcGCNj0O8D4MkYvM20uCPGby/zm9SukTbANwuAE4osWaS7xfp9kf2Rqr8ICbQkhWtrbdlaj0KCInXt6ZuhE58B5607dXbhA+J1/S5nLS415Zd9weS08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MPYJnCN+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MPYJnCN+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768330585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=reko9w298o6jWNDWosmuAMSax8bMqyxzRVAiUIt2M1A=;
	b=MPYJnCN+GJz35mKgrZupWb2SxVXQm/OghCx6Z+K9CFYaCn74BUIOZlzz+diTXXvF1wBN7W
	igikNjci6d49JSomKl8tiTmzczjAEYigpXrSnmjAtQ5Kpj8Vlf6uHbKzbDUm3tSRnWOf8b
	N6L4j+OkjR4F2AegwuXCqYo7PELPolM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-1DTbZT0TMwiC_LczzqS9Qg-1; Tue, 13 Jan 2026 13:56:23 -0500
X-MC-Unique: 1DTbZT0TMwiC_LczzqS9Qg-1
X-Mimecast-MFC-AGG-ID: 1DTbZT0TMwiC_LczzqS9Qg_1768330583
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ffb4222a4eso172107471cf.0
        for <virtio-fs@lists.linux.dev>; Tue, 13 Jan 2026 10:56:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768330583; x=1768935383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=reko9w298o6jWNDWosmuAMSax8bMqyxzRVAiUIt2M1A=;
        b=pI4AYGLUrKAp13mveBWvJRPmDwtyTnewJ/JHF93nAcCxpBte+/6G3hy4ca3jtoQS8r
         woATwYKuzFX/jOn2aTcA6fzw5cEHjLpkzZTuAOguRIxekQHloQJGNFZTz8k+/Y3oSQF3
         HIh+5E8I3Tu1cMy1F1FDC9LhvDj11gcpXLAQzyFRNwRLbRraRGcHbgDbNj3IIC+N7+w3
         V5VqXyZLHK7Biz8iliVZsmbqLm1N3A9boTXmfZPlnx4JrJJ+bWSeZM6DQggFSEElrsUD
         YH2MxpPkEsCViyB2XHn6yiV4yxIA8OmLpemoiWfyzpVYEFGh4IipUGsrP0U9Of6OzZvd
         Mgyw==
X-Forwarded-Encrypted: i=1; AJvYcCVENmP9rHHb/FnOl+jpkwiBw3HstrGQLGB8gctiqmP42WLZo5vwCX36NHloCUJ/+P83m8q/MKQSLY4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQYOoyK+RgJZJPByJ0lE6lzLYohk8N6vaM0yBka+sWUig9elny
	wCMVDNqWJbKWoP/BEta55da9bTQBcxgjgRUhufPZJBlJO5gG+7cyip3bFE3D6aIYzklGgw218ZD
	7xhJgQrQzTcbVpJ1Tcb/Be3haH5VLGmWXYBEogpSqVX9GJWZ8VSCY5QP12DGT3A==
X-Gm-Gg: AY/fxX7Mn370BiStklBQYiQzHHpJ/w5/2VnXlhCwoqbIa2r7qGRy7QA8IIV0xrTT7Hw
	DGLZxDui/NdMxKFdr52Ml0hhF2oM1DFJd23blfgBGrfwzRc4FVVBmB0tisIukeC4/iSx7Tp/70c
	Lxyc9s8I6OT9YufYZ63CpNvPEJm5kP+8iEhZDBOpuAvO8MOOdwg6/GZ5KFREU8xv16yehmkSUVa
	1EeZZ/w09ogwqvVFez4ugOJOmZo/U0SMITiMqdp8dGydG2/WZkG12XKPw06yNzBCV2MJ2wvr1Is
	/3BRtF5h6AFCA9Q5SdyY3p4eYfPCykN5Ik+3Jugt9mOqnddmYa02zZeKsUeWid5cM1Me/rqhBCj
	xtU8=
X-Received: by 2002:ac8:6f1a:0:b0:4ee:61f8:68d6 with SMTP id d75a77b69052e-501481e3cddmr2501611cf.6.1768330583085;
        Tue, 13 Jan 2026 10:56:23 -0800 (PST)
X-Received: by 2002:ac8:6f1a:0:b0:4ee:61f8:68d6 with SMTP id d75a77b69052e-501481e3cddmr2501221cf.6.1768330582672;
        Tue, 13 Jan 2026 10:56:22 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffa8d3d34fsm145674301cf.4.2026.01.13.10.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 10:56:22 -0800 (PST)
Date: Tue, 13 Jan 2026 13:56:20 -0500
From: Peter Xu <peterx@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Cc: Alexandr Moshkov <dtalexundeer@yandex-team.ru>, qemu-devel@nongnu.org,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
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
Message-ID: <aWaVVJh13ctiW9Ku@x1.local>
References: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
 <20260113181242.GB528940@fedora>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260113181242.GB528940@fedora>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i9rafPsEozN6wsOREet53Mz78oAHrnOxcBBP_Rrkk0U_1768330583
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Jan 13, 2026 at 01:12:42PM -0500, Stefan Hajnoczi wrote:
> On Tue, Jan 13, 2026 at 02:58:09PM +0500, Alexandr Moshkov wrote:
> 
> Peter: Please review the migration aspects (especially the vmstates).
> Thank you!

Looks good from my side as long as it's based on VMSD, I appreciate that
change from the old versions where it used to use qemufile APIs.

The major question here is if this series depends on Vladimir's other
series, while there's still one patch that is not-for-merge:

https://lore.kernel.org/all/20251016114104.1384675-24-vsementsov@yandex-team.ru/#t

Does it automatically mark this series RFC as well?

Personally speaking, a new migration cap would work all fine, we should
have discussed it somewhere previously.  Said that, "local-vhost-user-blk"
capability is likely not the right one.  IMHO it should be either "local"
or "fd-passing" / "fd-passthrough" (or something generic) as the name.  If
we are not sure if we will leverage more than "passing the FDs around", we
can make it as simple as "local" as a new migration capability.

Then migration's misc.h should export a function migrate_is_local() then
device code can probe that in its own vmstate handling paths on save/load.

A note to Vladimir: please remember to add a check to enforce UNIX socket
when a formal patch 23 will be proposed some day, no matter what is the
name of the capability.  It should fail qmp "migrate" or qmp
"migrate_incoming" command if the main URI is not a unix socket.

Thanks,

-- 
Peter Xu

