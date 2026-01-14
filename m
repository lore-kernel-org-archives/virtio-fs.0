Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444F729E114
	for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768401377; cv=none; b=MgvNfsTgTJ8IQ4plIzTo3at4kRuX6rJZwnnJbz7etBNqbHEywjFD7ZwBYzzPnKG2BYN+ZG8BPUcRZsQo+8dOm20gmNWr4mJcrJmGMs8chL+8MHBdda37sb6F2+L54JkrwyXn1f16P/mp1KwrWmlNfZvncAySI3Z1eKoPvI4W1Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768401377; c=relaxed/simple;
	bh=mjymXEK1ShldjBl/XYR5rSTaNXWB29Ye90dAlCxeUWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JRHliJJKlpb9cKYK20PFTCvEH/XjytD8gpP79500aboBo21HmAXOMiRJogRJt1JLjgc/+iajkSkBZc2sf7XuGqprlb8dpS1rJcU9zbXfj4G1Nrc37T3aIzChC6MB7oiwK3Wg8qu0hxVYgh5FsAPNdgQGAqcgFKa122F69mlQ+yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=euUY1iHC; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="euUY1iHC"
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:fa2:0:640:41ee:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 58AD480744;
	Wed, 14 Jan 2026 17:35:56 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:c88::1:7] (unknown [2a02:6bf:8080:c88::1:7])
	by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id sZVeXG0ACiE0-70W21c4x;
	Wed, 14 Jan 2026 17:35:55 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768401355;
	bh=CsLibKXtdk/PJxFMJ86jAnlmPnM0VJjqUv8A8vQAnPI=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=euUY1iHCZuLLLUwIWptzkniLjOpJrgZ6CvroB2Y6QXzvKBuqxm0iK+CTPY7G7baZr
	 bMz8QTCJG8GcSme6YnqJIpHyyh/qYWQLur1XfUs826jRVpEVg3fcZOFafxwYI1GmVt
	 lWQyEX99YZ8gKckFiCQoDFK1BvlI+pRM2b+8bA/U=
Authentication-Results: mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <832f4005-2e51-49fd-91e8-9f4cbe9f2adf@yandex-team.ru>
Date: Wed, 14 Jan 2026 17:35:53 +0300
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
Content-Language: en-US
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
In-Reply-To: <aWeKn5A7-tWaWv0z@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.01.26 15:22, Peter Xu wrote:
> On Wed, Jan 14, 2026 at 09:19:10AM +0300, Vladimir Sementsov-Ogievskiy wrote:
>> On 13.01.26 21:56, Peter Xu wrote:
>>> On Tue, Jan 13, 2026 at 01:12:42PM -0500, Stefan Hajnoczi wrote:
>>>> On Tue, Jan 13, 2026 at 02:58:09PM +0500, Alexandr Moshkov wrote:
>>>>
>>>> Peter: Please review the migration aspects (especially the vmstates).
>>>> Thank you!
>>>
>>> Looks good from my side as long as it's based on VMSD, I appreciate that
>>> change from the old versions where it used to use qemufile APIs.
>>>
>>> The major question here is if this series depends on Vladimir's other
>>> series
>>
>> No, it does not. And if we can proceed with merging these series first, I'll
>> be happy to rebase on top of it.
> 
> I thought it requires migrate_local_vhost_user_blk() be present?  The
> inflight feature should not be enabled only if there's a hint that it's a
> local migration..

Oh right, I missed it.

We discussed that Alexandr will rebase the series on master without dependency
on my RFC.

> 
> I'll comment inline on the patch later.
> 
>>
>>> while there's still one patch that is not-for-merge:
>>>
>>> https://lore.kernel.org/all/20251016114104.1384675-24-vsementsov@yandex-team.ru/#t
>>>
>>> Does it automatically mark this series RFC as well?
>>>
>>> Personally speaking, a new migration cap would work all fine, we should
>>> have discussed it somewhere previously.  Said that, "local-vhost-user-blk"
>>> capability is likely not the right one.  IMHO it should be either "local"
>>> or "fd-passing" / "fd-passthrough" (or something generic) as the name.  If
>>> we are not sure if we will leverage more than "passing the FDs around", we
>>> can make it as simple as "local" as a new migration capability.
>>>
>>> Then migration's misc.h should export a function migrate_is_local() then
>>> device code can probe that in its own vmstate handling paths on save/load.
>>>
>>> A note to Vladimir: please remember to add a check to enforce UNIX socket
>>> when a formal patch 23 will be proposed some day, no matter what is the
>>> name of the capability.  It should fail qmp "migrate" or qmp
>>> "migrate_incoming" command if the main URI is not a unix socket.
>>>
>>
>> Thanks! I'll keep that in mind when prepare next version.
>>
>> -- 
>> Best regards,
>> Vladimir
>>
> 


-- 
Best regards,
Vladimir
