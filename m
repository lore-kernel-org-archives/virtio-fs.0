Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF0640EBB0
	for <virtio-fs@lists.linux.dev>; Tue,  4 Aug 2026 10:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785840412; cv=none; b=f89XO3NDjnSj7q5cmbWJ5d7UAm3asyEBC8ljnXC5yg8mIkU/UqbfahiF92GnPcHacS0Hq3337XYXJS4sg6TRHLZXDgJmmgT9DiK+xa/gnEkhbsgUT273+VaxXGshMzvzX2GrO3/JAoFy3u1354WYvfa/8OU1QSNEkldXWmp1A5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785840412; c=relaxed/simple;
	bh=Wa4QheAOwJaJ+3YTe6+GeYcQxZdx6XnDdlK5yasVN1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a68Wgpx9baBnCjOe8KqvpSTjGXaMP7wz2z8azEliGZguM0KtrHzLYWa77Q/qkQLsaci6yB9jTVKSnTAok4LC6OwPu9cFxzRmMKNp4+sKxjqpRWxZUO7FAks43SN3W0YfT/WOnSZQdxxlelEONULsSoA8gzE0ZhJdBE+XJY2On6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PBzq3s3F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PBzq3s3F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785840406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oh8GXVHC+JPt5ZoIGK/cVqk909kbAfgYo5EeomlA70o=;
	b=PBzq3s3Fbmj+OV4CD+fuTtw4fziFqaEXPaqVOV3RkZYEYcUwUBh84Z4VYvUwk5LONRRqNC
	kO8KLYfj7y+X9ySLnIlJhjL9N+S0CTx4Im31e9c1UAiVwim+ZaQRK2+FBa1e1SvnuN3ddO
	6sVHkqLcb8rWrYnze+6axpr/0ZbNAQ4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-5KAhFrQHOCm2WVbbO7Ivng-1; Tue, 04 Aug 2026 06:46:45 -0400
X-MC-Unique: 5KAhFrQHOCm2WVbbO7Ivng-1
X-Mimecast-MFC-AGG-ID: 5KAhFrQHOCm2WVbbO7Ivng_1785840404
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47f5a972b0eso3880104f8f.2
        for <virtio-fs@lists.linux.dev>; Tue, 04 Aug 2026 03:46:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785840404; x=1786445204;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oh8GXVHC+JPt5ZoIGK/cVqk909kbAfgYo5EeomlA70o=;
        b=WDhaytEpohZ3HLQZYKlP7VYcBIg6oFd4xe1GcTr1X+THiOFuz1JDso+PRpl15yWwcw
         8EVZibThgTpxQFM8drIY7s4ry4U3RkHOsB2MKE8kKNnjLGA7ZR0lsy7JEOKutgiBv/UT
         c8+FotfO+d67l5BSMvm5SGNlfcCMTAS1tK6LreUuJnlhAnrdKhaUc84UrKj/Oh1Q6D7X
         iEsbLxxKY63sfX4VOQtmL03P+In0j2OAqVDJ8yaJToHfdbHSZzCA4Wr8rMVnOahOOzJI
         1WY4rVOO1TAQaarH6/UWCHZkRFvGdd9wgvY0rucOdIlJ5ovuZlLfftSXkAZ3FpDvEd9N
         yLIg==
X-Forwarded-Encrypted: i=1; AHgh+Ro+Gna3jnyXuCWLen3hbYmZJu8zwVcSzm2pvkjaORbfBv5F+ym6+c53Ugw8Sj8TUggRltyn2BlI+mM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLQtByoFBPO0ftn31VlQQkE+KmDC6mblH9uyJ8TFxXbC6/L+rh
	RRyoUC+SI9D6zGc5/WwZx38l0/tafWjGqPz3rP1JaugxOQip8Yo2pxDg6eHdWEg3lec6g/etfFV
	CK+kTemD8XyVuN010sOnHpbkQzoWhJM9LlkmQSLiH/edSs27Ss/BGZYeku6yfPA==
X-Gm-Gg: AR+sD12JGIE0Po3p6NoRZVN7s+EeUVxroWRZc6p2QfT6sVJgCroEGfOqqrdFG3wZMi/
	pbQZEdNHA3/QxdSrs9aGH6NA5QvMUyYsZ5fZJs3e/rc7xxBEp/i7HHaqHDjKWSmrOJU8t4Owx2w
	DfwkEgLvf2JH92YVFIUrfv9GfN0355KekiBl2gwRX43TKLESBGMl38AP0BCH7CcWpDaDhOPTdfF
	oiK3XGTuNFMjuA86aW0/jxanKo2YTWpOPh15hL22ZROZqvoMJdvFZKCVuO5Anq1imXOD5XRXD70
	qvrPIptTg3Kxu5gXwJD7z1ZrNqcda6tKqb2Hk3rI0MggiFl+3/nfKy6diwPtfIYIEbfvFSK6EBK
	Fz8h4NZLN3kNFH4IOglYMxldz90WkmeJ0uFH1on0yBr0kG6H9J0FsLmEwP2WHewl71kkNBbh5o9
	/YmfyxaIA16dWbbFoQL0n8N2a5mb66QQ==
X-Received: by 2002:a05:6000:c90:b0:47f:d0fb:ea40 with SMTP id ffacd0b85a97d-47fd72db353mr30197999f8f.21.1785840403887;
        Tue, 04 Aug 2026 03:46:43 -0700 (PDT)
X-Received: by 2002:a05:6000:c90:b0:47f:d0fb:ea40 with SMTP id ffacd0b85a97d-47fd72db353mr30197933f8f.21.1785840403435;
        Tue, 04 Aug 2026 03:46:43 -0700 (PDT)
Received: from ?IPV6:2003:cf:d73d:54bb:1189:33b6:6950:ef97? (p200300cfd73d54bb118933b66950ef97.dip0.t-ipconnect.de. [2003:cf:d73d:54bb:1189:33b6:6950:ef97])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd4562667sm44648120f8f.24.2026.08.04.03.46.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 03:46:42 -0700 (PDT)
Message-ID: <95fe9d1a-dab1-477f-948f-4a42a1e3f09e@redhat.com>
Date: Tue, 4 Aug 2026 12:46:35 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 02/15] vhost-user: Add memory-isolation qdev property
 to vhost-user devices
To: Connor Kite <connorkite@gmail.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
 Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org,
 virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Alyssa Ross <hi@alyssa.is>,
 Demi Marie Obenour <demiobenour@gmail.com>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-2-6b97c439eb28@gmail.com>
 <eb1d8424-206a-47f5-9ad5-a833a56bb3f3@redhat.com>
 <CA+spn3pLkHn_Wk+-xa-k2PKXdDSa-S9c1Dd94t=Kj5tajPyzSA@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CA+spn3pLkHn_Wk+-xa-k2PKXdDSa-S9c1Dd94t=Kj5tajPyzSA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xCq2r7AsIV2RFOuQKlEnrj1FI_WhF8q2CPMvfNd60xE_1785840404
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 03.08.26 22:32, Connor Kite wrote:
> On Mon, Aug 3, 2026 at 5:21 AM Hanna Czenczek <hreitz@redhat.com> wrote:
>> Should `vhost_user_vga_inst_initfn()` set up an alias for
>> "memory-isolation", like it does for "chardev" now?
>>
> I am not 100% sure but I can test to see.  If an alias is needed, I suspect
> that would also apply to vhost-user-gpu-pci, right?

Right, that makes sense. (If your testing confirms that it’s needed.)

Hanna

>> There are four lines in here that the checkpatch script notes to be over
>> 80 characters in length, so they should be broken up.
>>
> Got it.  This will be fixed for the next rev.
>
>> [...]
>>
>>> diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
>>> index 90bd2903db..d2a74a2860 100644
>>> --- a/hw/virtio/vhost-user-base.c
>>> +++ b/hw/virtio/vhost-user-base.c
>>> @@ -409,7 +409,8 @@ static void vub_device_unrealize(DeviceState *dev)
>>>
>>>    /*Define common qdev properties.  Inherited by all children*/
>>>    static const Property vub_properties[] = {
>>> -    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev)
>>> +    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
>>> +    DEFINE_PROP_BOOL("memory-isolation", VHostUserBase, memory_isolation, false)
>> Nitpick: I would add a comma here. (This hunk shows specifically why
>> it’s a good idea: So that future additions don’t have to change the line
>> to add the comma.)
>>
> Ah, I was wondering why I was seeing so many hanging commas .  That makes sense.
> I will add the comma in.
>

