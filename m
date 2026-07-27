Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49161374E5B
	for <virtio-fs@lists.linux.dev>; Mon, 27 Jul 2026 05:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785131676; cv=none; b=JYcpgnTeNEzP9hDdx/FRC4QWJeP7PazoHPKlpNY1aj5kDW1OzuM+BtseZK91b5y7SytDgvlC4jJlwiRt/tIr2mN9Y+gsYKbVFMk9Mmr8bWfU6YYuFzdyQUH/tW53bedVKUTwxteQ2biXF18QKXKKtd5pSVR2YPAhTU/ydFFc3wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785131676; c=relaxed/simple;
	bh=SwhFmL3YqiTsB1DO77Qiptk32EWX/NhZ6FavHtU3040=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B9LVeeut7K8xVGksoCF6C3IGhrX/mDnbPbijsCmQqma9pwFvlMs1oSqxTvjlQH3vXFhPikb9JmFnMLhlyEE9HVS0wrMl/Cfy+3Zs7DoxpYBE/EHStQTPCpd07UPm2vc5x9Bl/LVoTRWKpCeVm15rLSe1f8xOA+EZmsv2w+V6OIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=UK4l7Bxb; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="UK4l7Bxb"
Received: from mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:86a0:0:640:75de:0])
	by forwardcorp1d.mail.yandex.net (postfix) with ESMTPS id 03CE380B11;
	Mon, 27 Jul 2026 08:50:21 +0300 (MSK)
Received: from [IPV6:2a02:6bf:803e:400:bea7:2940:6406:4130] (unknown [2a02:6bf:803e:400:bea7:2940:6406:4130])
	by mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net (smtpcorp) with ESMTPSA id 7oUooL3h78c0-kCefQyDF;
	Mon, 27 Jul 2026 08:50:20 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1785131420;
	bh=ApUu1XBttSABZmu3OrRXGLuO/GVExIO6x2kbPh+Plzo=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=UK4l7BxbQ4xaDGQiMYl+CDKQARjR+iohGbjXaVhk7Aqdfp7CJt7AAwu7Y8a+zQL9w
	 1Wvkjqj+E91MaKSrcwapXNKrpexCGvUX3bD7O/d3E1TTP2C5OcAZeHXDdnsu5oP9/J
	 dkmDvktHhVEAMfpFD91sft7Uk3YqK7UGG93b6xL4=
Authentication-Results: mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <a8841f42-c8b4-4a11-a7e9-014ddc06f105@yandex-team.ru>
Date: Mon, 27 Jul 2026 10:50:07 +0500
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] vhost-user-blk: fix compatibility with older qemu
 versions
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: qemu-devel@nongnu.org, Jason Wang <jasowangio@gmail.com>,
 Milan Zamazal <mzamazal@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
 zhenwei pi <zhenwei.pi@linux.dev>, Stefan Hajnoczi <stefanha@redhat.com>,
 "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
 virtio-fs@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
 "yc-core@yandex-team.ru" <yc-core@yandex-team.ru>, qemu-block@nongnu.org,
 Raphael Norwitz <rnorwitz@nvidia.com>,
 Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
References: <20260702091023.3306378-1-dtalexundeer@yandex-team.ru>
 <d95a174d-83ec-4bc0-ac5f-46628262bd0a@yandex-team.ru>
 <20260725011415-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
In-Reply-To: <20260725011415-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/25/26 10:32, Michael S. Tsirkin wrote:
> On Thu, Jul 16, 2026 at 12:30:33PM +0500, Alexandr Moshkov wrote:
>> Ping :)
Thanks for reply!
>
> I don't know what to do with this one. IIUC in flight migration is in 11.0
> so I doubt we can just introduce new messages without a protocol flag.

The original plan was to push this series before the 11.0 release, using 
the existing VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT flag - since 
the new message is a direct extension of that feature.
Now I agree that we need a separate protocol feature flag (like 
VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN) for new 
GET_VRING_BASE_SKIP_DRAIN message.

>
> It says fix compatibility but really it's a feature, right?
I called it a "fix" because I saw missing migration compatibility as a 
deficiency, but from protocol perspective its more like "feature" - 
you're right. I'll update the subject.
>
> And this is somehow related to GET_BASE?
Yes, GET_VRING_BASE_SKIP_DRAIN is a variant of GET_VRING_BASE - it stops 
the vring the same way, but tells the backend to immediately suspend 
in-flight I/O, rather than wait for it to complete.
>
> Half the commits here have no or a single line of comment, those that
> do, repeat what the commit does instead of explaining why.
>
> That's not how it should be.
>
> Here's a good template to use:
>
> Currently .... This is a problem because ... We can not do .... because
> ... To address .... And then ....
Agreed, the descriptions are poor. I'll rewrite them following your 
template. Thanks!
>
> HTH
>
