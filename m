Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DACA36C0DD
	for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 06:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768371701; cv=none; b=aKKgp0NOw30xkzW2SY+oKo3rEJTr9GGAScBPsbDbUComurKtNss2nyQD2Hs5APt17HaCsgvXD0vs2McfRZxePCah5RePILpavtb8HdKoAkRXSXA5mNuAmOreNaP0boqMfITksmJ33U1qb3Q+QupxNmn9QIToSO/ZK1SR0LO4R1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768371701; c=relaxed/simple;
	bh=abHlIVLoEQa8K0mralG8bPL5X0InNAXJyjIRIUMxZFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZAAmjzY56jyLIyS2krGwznzmNc4RPvFnPb/ho+IbPuNmccF7/VEuN+WDCqJlqeedWab7/u6BdBT27bw8hcqKQmEqn9l7PzAtwjbEjAejsDfUhN8RnuGxRlRiH3o+5DorrJB3cp2xCg+lfuxs64+n4yMVBeA5r0D9btstoYGMXKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=VOrv0mKt; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="VOrv0mKt"
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 98F78C01AC;
	Wed, 14 Jan 2026 09:19:13 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:c88::1:7] (unknown [2a02:6bf:8080:c88::1:7])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id AJNmZ80AfW20-uK4vFqAX;
	Wed, 14 Jan 2026 09:19:12 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768371552;
	bh=MjZ+p+f9yJQUOy1N1T+uGF94WpII2zAukpQ58wZNqxw=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=VOrv0mKtVxZlOXgrJulmBaeG9rxA5WwV97nRzonAzt642GDyYRZQIZfx+XGVNWC9b
	 2/vrkkbWZcIYSWKdR5HmcCUJn9xqMSl1LQPfAD5HimnrhIhTxLdEyI8An6TqNVgAEF
	 zuLY/5WaPWGi523oFG+HcGt3BM/5Ls1z/ocIn7Xo=
Authentication-Results: mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <2af404d1-5e50-4caa-bee6-f8aab6a30a7e@yandex-team.ru>
Date: Wed, 14 Jan 2026 09:19:10 +0300
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] support inflight migration
To: Peter Xu <peterx@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: Alexandr Moshkov <dtalexundeer@yandex-team.ru>, qemu-devel@nongnu.org,
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
Content-Language: en-US
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
In-Reply-To: <aWaVVJh13ctiW9Ku@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.01.26 21:56, Peter Xu wrote:
> On Tue, Jan 13, 2026 at 01:12:42PM -0500, Stefan Hajnoczi wrote:
>> On Tue, Jan 13, 2026 at 02:58:09PM +0500, Alexandr Moshkov wrote:
>>
>> Peter: Please review the migration aspects (especially the vmstates).
>> Thank you!
> 
> Looks good from my side as long as it's based on VMSD, I appreciate that
> change from the old versions where it used to use qemufile APIs.
> 
> The major question here is if this series depends on Vladimir's other
> series

No, it does not. And if we can proceed with merging these series first, I'll
be happy to rebase on top of it.

> while there's still one patch that is not-for-merge:
> 
> https://lore.kernel.org/all/20251016114104.1384675-24-vsementsov@yandex-team.ru/#t
> 
> Does it automatically mark this series RFC as well?
> 
> Personally speaking, a new migration cap would work all fine, we should
> have discussed it somewhere previously.  Said that, "local-vhost-user-blk"
> capability is likely not the right one.  IMHO it should be either "local"
> or "fd-passing" / "fd-passthrough" (or something generic) as the name.  If
> we are not sure if we will leverage more than "passing the FDs around", we
> can make it as simple as "local" as a new migration capability.
> 
> Then migration's misc.h should export a function migrate_is_local() then
> device code can probe that in its own vmstate handling paths on save/load.
> 
> A note to Vladimir: please remember to add a check to enforce UNIX socket
> when a formal patch 23 will be proposed some day, no matter what is the
> name of the capability.  It should fail qmp "migrate" or qmp
> "migrate_incoming" command if the main URI is not a unix socket.
> 

Thanks! I'll keep that in mind when prepare next version.

-- 
Best regards,
Vladimir
