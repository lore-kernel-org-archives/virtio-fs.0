Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4128335A956
	for <virtio-fs@lists.linux.dev>; Tue, 13 Jan 2026 06:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768286970; cv=none; b=scu2DcazdAcvipqpcPuPPSlFelnL+eokAXWsOtdiaKOoXkgPa2bCYm5rCu8K76xmILyiKUqU3uXT8ZozPAVNGJd0L06neEd09Y6AGh4yXoPNRLGnNRNlLTT4dZYQ6yBHEFLQ63bwwi1dT0gmJ3jO7IEgzIP2zFBR9/btv4P3K5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768286970; c=relaxed/simple;
	bh=OJ31QzpOjyjcwuFCCatnuDMd9CY2dJkpGEoufhKATS4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MRh/aTktPEBQ07J7XOZ2RKF+1tMo6qIipWJaeEiF/JlOL/Q8yAmXywzzAvdYeoCvZs8f/+uPaS9G+2hERQ6IodIhOvhOUPt+0SuSFZi54RbEmUm03it+TJpTgkSaYqAm/bsJUvUspebaeYQqpu97TJqoVsS8OVDnxCLjXkc1se0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=WXitobGY; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="WXitobGY"
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:65a0:0:640:e1de:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 3ADC3807A6;
	Tue, 13 Jan 2026 09:49:23 +0300 (MSK)
Received: from [IPV6:2a02:6bf:803e:400:93c4:8e38:1f90:3c73] (unknown [2a02:6bf:803e:400:93c4:8e38:1f90:3c73])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id KnM80u4Ae0U0-VhpsuKWX;
	Tue, 13 Jan 2026 09:49:22 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768286962;
	bh=TZ8mu0WBWMfswijbT+e0w17mPBYTxGyZIFriIAz1Nrw=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=WXitobGYAL7gMAU136XVxcq4dI5F8CErFnHBHnE1JEb9nDW4IUsERGIoaqX+E+JLE
	 VpNydObfjJNqGSZGi1VgwsFUD8eWzk0BWvtwSHwNbU0Y2v/7Kk4oP1wSjs9OkTw6p5
	 UZB7qtgjDlAkFQE0Pknptb0+s/pTcy721IH48KFI=
Authentication-Results: mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <f1fcd806-f391-47a4-821d-2d15882cd645@yandex-team.ru>
Date: Tue, 13 Jan 2026 11:49:20 +0500
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] vhost-user-blk: support inter-host inflight
 migration
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 Zhenwei Pi <pizhenwei@bytedance.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 Raphael Norwitz <raphael@enfabrica.net>, Kevin Wolf <kwolf@redhat.com>,
 Hanna Reitz <hreitz@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, mzamazal@redhat.com,
 Peter Xu <peterx@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 qemu-block@nongnu.org, virtio-fs@lists.linux.dev,
 "yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>
References: <20260112114503.1174330-1-dtalexundeer@yandex-team.ru>
 <20260112114503.1174330-6-dtalexundeer@yandex-team.ru>
 <20260112181917.GE462084@fedora>
Content-Language: en-US
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
In-Reply-To: <20260112181917.GE462084@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/12/26 23:19, Stefan Hajnoczi wrote:
> On Mon, Jan 12, 2026 at 04:45:03PM +0500, Alexandr Moshkov wrote:
>> During inter-host migration, waiting for disk requests to be drained
>> in the vhost-user backend can incur significant downtime.
>>
>> This can be avoided if QEMU migrates the inflight region in
>> vhost-user-blk.
>> Thus, during the qemu migration, with feature flag the vhost-user
>> back-end can immediately stop vrings, so all in-flight requests will be
>> migrated to another host.
>>
>> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
>> ---
>>   hw/block/vhost-user-blk.c          | 28 ++++++++++++++++++++++++++++
>>   include/hw/virtio/vhost-user-blk.h |  1 +
>>   2 files changed, 29 insertions(+)
>>
>> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
>> index a8fd90480a..5e44f6253c 100644
>> --- a/hw/block/vhost-user-blk.c
>> +++ b/hw/block/vhost-user-blk.c
>> @@ -656,6 +656,28 @@ static struct vhost_dev *vhost_user_blk_get_vhost(VirtIODevice *vdev)
>>       return &s->dev;
>>   }
>>   
>> +static bool vhost_user_blk_inflight_needed(void *opaque)
>> +{
>> +    struct VHostUserBlk *s = opaque;
>> +
>> +    bool inflight_drain = vhost_dev_has_feature(&s->dev,
>> +                        VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT must only be negotiated
> when inflight_migration is enabled. Otherwise the backend will use this
> feature even though vhost_user_blk_inflight_needed() skips migrating the
> in-flight region.
Oh, I understand now. I'll fix this too, thanks!
