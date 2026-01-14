Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAA233033C
	for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768413300; cv=none; b=aovKOPM/fvIFkcMtXFkgqfH74HFjuxHMUNH6Q8VIrj1JJBINmG+YjfsJdpTRm7T2cw1qtzqTCPDZvGpgaGlWwIpGeAOFddt3LStNp7h6ZUcrC4HqjH3Y9PViaqVtk34zU1hAtxQOrKlN6tvJQlhbrOO5ZRdg1bjejtfZdm2BAqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768413300; c=relaxed/simple;
	bh=2ihRtd0Uz68RIZCR2L/atEs4qQiA+9QxwRgv1bYFEWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IxGHCWV4J3FWcD/RbtgBZCr2IGXCvTjtYu1DIbVne46P2wwAnIJZtWNIJDeAkVQeGDwyfMq8CkyQR64v+Htc4FFXmoBwz4TviWaSC3ClGZm68E8/GJVJ/jNTSPaVvYsFM/JxRLEem+hLKjhAmg5a6IfcekVERbXjl3X8mMTwhmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=0GBc273V; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="0GBc273V"
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 9D572C02C8;
	Wed, 14 Jan 2026 20:54:52 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:c88::1:7] (unknown [2a02:6bf:8080:c88::1:7])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id osYk8G0AtmI0-f6zcrlHI;
	Wed, 14 Jan 2026 20:54:52 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768413292;
	bh=l2hhGgOopvhCBxO4xytx/xL/4yJaI+IULU+1glcfZ+I=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=0GBc273VanSIBGrWdySnnDcGkuB0uJ+nw4VNN9LdQ8wLIi8Z2UlsLSqNNMz10yuN7
	 rVaLqUqCS3KsASvZ5vpdkfzEn8uFokzksMrZAsxN6uvGtWERrtWo4t21DuzKr+cLpg
	 8za8zEgtWeP/eZW1G7YAkxo4J05PbWBcjJ3oiKWA=
Authentication-Results: mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <d5c106d9-9e37-4f44-b0e9-4321d12f8bf1@yandex-team.ru>
Date: Wed, 14 Jan 2026 20:54:50 +0300
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] support inflight migration
To: Peter Xu <peterx@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
 Alexandr Moshkov <dtalexundeer@yandex-team.ru>, qemu-devel@nongnu.org,
 "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 Zhenwei Pi <pizhenwei@bytedance.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 Raphael Norwitz <raphael@enfabrica.net>, Kevin Wolf <kwolf@redhat.com>,
 Hanna Reitz <hreitz@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, mzamazal@redhat.com,
 Fabiano Rosas <farosas@suse.de>, qemu-block@nongnu.org,
 virtio-fs@lists.linux.dev, "yc-core@yandex-team.ru"
 <yc-core@yandex-team.ru>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>
References: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
 <20260113181242.GB528940@fedora> <aWaVVJh13ctiW9Ku@x1.local>
 <2af404d1-5e50-4caa-bee6-f8aab6a30a7e@yandex-team.ru>
 <aWeKn5A7-tWaWv0z@x1.local>
 <832f4005-2e51-49fd-91e8-9f4cbe9f2adf@yandex-team.ru>
 <aWezg94AB5a3F0EV@x1.local>
Content-Language: en-US
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
In-Reply-To: <aWezg94AB5a3F0EV@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.01.26 18:17, Peter Xu wrote:
> On Wed, Jan 14, 2026 at 05:35:53PM +0300, Vladimir Sementsov-Ogievskiy wrote:
>> On 14.01.26 15:22, Peter Xu wrote:
>>> On Wed, Jan 14, 2026 at 09:19:10AM +0300, Vladimir Sementsov-Ogievskiy wrote:
>>>> On 13.01.26 21:56, Peter Xu wrote:
>>>>> On Tue, Jan 13, 2026 at 01:12:42PM -0500, Stefan Hajnoczi wrote:
>>>>>> On Tue, Jan 13, 2026 at 02:58:09PM +0500, Alexandr Moshkov wrote:
>>>>>>
>>>>>> Peter: Please review the migration aspects (especially the vmstates).
>>>>>> Thank you!
>>>>>
>>>>> Looks good from my side as long as it's based on VMSD, I appreciate that
>>>>> change from the old versions where it used to use qemufile APIs.
>>>>>
>>>>> The major question here is if this series depends on Vladimir's other
>>>>> series
>>>>
>>>> No, it does not. And if we can proceed with merging these series first, I'll
>>>> be happy to rebase on top of it.
>>>
>>> I thought it requires migrate_local_vhost_user_blk() be present?  The
>>> inflight feature should not be enabled only if there's a hint that it's a
>>> local migration..
>>
>> Oh right, I missed it.
>>
>> We discussed that Alexandr will rebase the series on master without dependency
>> on my RFC.
> 
> The problem is IIUC the new INFLIGHT feature bit will be declared as
> supported to vhost-user-block after applying this series.  Then if we start
> a remote migration (rather than local) it'll be automatically (and wrongly)
> enabled?
> 

No, not so.

We develop inflight-region migraiton (this series) exactly for remote migration,
not for local.

My series about backend transfer (fd-migration) will migrate inflight-region the
other way - by migrating its FD.

> AFAIU, the dependency makes sense, at least to the patch to introduce the
> "local" / ... capability?
> 


-- 
Best regards,
Vladimir
