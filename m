Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7149443A819
	for <virtio-fs@lists.linux.dev>; Thu,  6 Aug 2026 10:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786012105; cv=none; b=sOOO57d1WZrKaOHwrMUcJn4c5AqZZuIiNlB/bB1VywHGXGJ5ybLCH0xA9OGQXlQt+QvlVlc+aCsrTyUC2AtNi+WeNPtPS8jkaMJZUyD22H0QVUp409Cx/MXymmK71JGRnKpB5GfcE6f/vUst3eUIUv23KaRpqd0TKa3EvlDZ7tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786012105; c=relaxed/simple;
	bh=SUz9xIIWo0a0TyRKUM4kLBNNcqRyaypfZT5J2/wArcg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dqlWU2q4I8UjZtIJ0cIWHzmlKhLx76NJeD4Awal9XsIQmSzWCT3kPjiWmTVMFRxRuuuH5nJKfO0UmmwG5pUJdfH/wsRnjOzqJXMc1cjXpGZF2b/UfCaXd4qQTHfRs7/fj+gLSbidNefQJDxV/yQODILnffJiIqJQgzlNrsZ9Tec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V0eYz1hA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V0eYz1hA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786012102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mhw1/EUHAkm8HexVtFz8Jxi41Jjd/FjijtMau9/paKQ=;
	b=V0eYz1hA7TUj1XbtDndzIJGXVLAXZ9pWrD29YmFThd4YEu+SnDh26RJAOkXoIJhFFij8H+
	6PLvpHzauRWhs0rs8XiBuOwUQc9PxJwKUc7HMdBbZmA/N4M5zNyH98DgzASPf/1lsEpRaj
	qUH6zoWJaS97dd/QWvWqwXd7siy7Dl4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-4f6tne6ZPCqU06roG3AJ3A-1; Thu, 06 Aug 2026 06:28:19 -0400
X-MC-Unique: 4f6tne6ZPCqU06roG3AJ3A-1
X-Mimecast-MFC-AGG-ID: 4f6tne6ZPCqU06roG3AJ3A_1786012098
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4740be00302so1628101f8f.2
        for <virtio-fs@lists.linux.dev>; Thu, 06 Aug 2026 03:28:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786012098; x=1786616898;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mhw1/EUHAkm8HexVtFz8Jxi41Jjd/FjijtMau9/paKQ=;
        b=USkAIPut4spPoQZSDZPq5PEcbWd4m5gYSk4mP+7Ueim1Bx4nAOCCKOcX+rJ3PJXT0g
         MAcChDZGE4uA3p0CXt9HiYRRft+PspPtD9xSrDq2ImfQ5vgUChL9SbTScjzCtSxvzTNs
         JXgWUNPprfKt76MEdZpxps6A6NIbYwthAzzbnQv2f1bizTiOEW0BtZWfKlMBRZMss6bi
         8Ns6GOC7T7CdAL3CrNT7NlbrTySwoeZMJPz+q1nHkHBgNMJPnbS7Ji41JiZ22rpW0QY0
         2jwjPFCMecUJm4eqHs5JbnStykv4VY3StgeaL4Hh8jfa2/rC+Xz2ZVik+dDamlyzO8N+
         WLYg==
X-Forwarded-Encrypted: i=1; AHgh+RqaTawJl6sDfpNCkSqPUE/htTETrlkLMCR9gmqDBZ5fuc7j4EI8NwMPMdoQYM6QZ/N856Q6JMAVIEk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtftWRg5623SJ3KOrp+KWBsgI4jrTdoZ9o80BwKa3d7k28yAGc
	g8+Fg5J7tlXA5h6IR/8xqOuLu+kTVKiwq5nv9BmdP9OmGcKJu0qCoUHLacvaDYJ5nIThlDBnjR6
	PhXe/T3zJiz1rpbWm7t/+fzqhAU4wILJIKTlhdsBEVeDUavXCPvw0FOQ3y4CNmw==
X-Gm-Gg: AR+sD12k54LYwJHfe6cYJtJZY7bN6piARUm1+TxJ+Nk6TAgGgVUXlY9vYylJmJ3gWgv
	uHAeD5U5Zcp6ffpbqYe+hwNLBY2c/ApdYlz70BE4/Tm2wyU+8gQy8ZAcTkEwPKOXlItAU9zKqDO
	MtCYWTLPXmiE4VRYeGAB4wLPFsQYd+F0911MDzAUCH9nH9XpPLyW+VV/1GpWlvkRxH8ah3mNolC
	rk8eyoY42jNGMAIQ+ZetRSnzVfTGDNAT3Yvgn6ngORV5Bx3tMsRxf34H0U8D82lI6tPL2XE75+c
	Yz24Lhw6sznzAM/vFvCtU3T7iuduqs4/svYzzfoEEZR9bPDk9mSIm0R9Dv5z4hlCQ+JPjW5+fCJ
	bfDqhHKcgkC2OgJUULkAL0ZACWmoRs5wjBxLqJS7mXMG7XCMzUjEmj+xSD8gOaEN5k2rxZkccwm
	727bmdi9+nHHoNo+AHFAMPOIyDBP3mRg==
X-Received: by 2002:a05:6000:1cd0:b0:47f:51bc:efe2 with SMTP id ffacd0b85a97d-47fec4f11d9mr17735628f8f.11.1786012097686;
        Thu, 06 Aug 2026 03:28:17 -0700 (PDT)
X-Received: by 2002:a05:6000:1cd0:b0:47f:51bc:efe2 with SMTP id ffacd0b85a97d-47fec4f11d9mr17735562f8f.11.1786012097276;
        Thu, 06 Aug 2026 03:28:17 -0700 (PDT)
Received: from ?IPV6:2003:cf:d706:f1b0:892a:16ba:c1b8:17c4? (p200300cfd706f1b0892a16bac1b817c4.dip0.t-ipconnect.de. [2003:cf:d706:f1b0:892a:16ba:c1b8:17c4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff79a718bsm5586258f8f.5.2026.08.06.03.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 03:28:16 -0700 (PDT)
Message-ID: <738737aa-64ed-479b-bba7-1b0326ef30c0@redhat.com>
Date: Thu, 6 Aug 2026 12:28:14 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 08/15] hw/virtio/vhost-shadow-virtqueue: used handler
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
 <20260723-vhost-user-isolated-memory-v1-8-6b97c439eb28@gmail.com>
 <39200a6f-8241-4033-ba7a-5c9bbbdc8ff1@redhat.com>
 <CA+spn3p-Fc_uLO1bwSXC39kmQ-iR-OpB-a6cjMTphb-_Ant-_w@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CA+spn3p-Fc_uLO1bwSXC39kmQ-iR-OpB-a6cjMTphb-_Ant-_w@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mUw4FjbP3FuvreikTbg2sqAld7Aiawc7H6U5Ohzq-I0_1786012098
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 06.08.26 04:50, Connor Kite wrote:
> On Fri, Jul 24, 2026 at 4:29 AM Akihiko Odaki
> <odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>>
>> The error of the handler that may have left elem stale is ignored here.
>>
>> Regards,
>> Akihiko Odaki
> I have now added in a check that returns on error without setting the guest
> notifier.  So essentially the call is ignored.  Maybe this could be expanded
> on to handle errors more gracefully depending on the error code.
>
> On Tue, Jul 28, 2026 at 8:06 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>>> +/**
>>> + * Callback to handle a used buffer
>>> + *
>>> + * @svq: Shadow virtqueue
>>> + * @elem: Element placed in the queue by the device
>>> + * @vq_callback_opaque: Used to pass arguments to callback
>>> + *
>>> + * Returns 0 if the vq is running as expected
>> The doc comment should mention what non-0 look like. Are errors reported
>> as a negative errno?
>>
> Yes, a negative errno is expected on failure.  I have added clarification to the
> comment.
>
> On Mon, Aug 3, 2026 at 5:42 AM Hanna Czenczek <hreitz@redhat.com> wrote:
>> On 24.07.26 00:30, Connor Kite wrote:
>>> Adds a handler callback to shadow virtqueues in order to enable
>>> non-default processing of used vring elements from the device.
>>>
>>> Signed-off-by: Connor Kite <connorkite@gmail.com>
>>> ---
>>>    hw/virtio/vhost-shadow-virtqueue.c |  4 ++++
>>>    hw/virtio/vhost-shadow-virtqueue.h | 14 ++++++++++++++
>>>    2 files changed, 18 insertions(+)
>> The avail handler replaces `vhost_svq_add_element()`. I find it a bit
>> unintuitive that this handler does not replace `virtqueue_fill()`, i.e.
>> that it is not a “mirror” of the avail handler; that the avail handler
>> actually handles avail elements, whereas the used handler is “just” a
>> callback on each used element. Was that intentional? (If so, I think the
>> comment should be explicit about this choice.)
>>
>> Hanna
>>
> I implemented it as a more narrowly-focused callback since virtqueue_fill
> needs to be called regardless.  If I instead called virtqueue_fill
> from the handler,
> I would need to pass in the elem index and length via svq->ops_opaque,
> which is a bit awkward as vhost_user defines ops_opaque when registering
> the callback.  That's certainly not impossible to do, but this way felt cleaner.
> For now, I will add a comment explaining that the callback should not be used
> to add elements to the underlying vq's used ring.

Then I personally wouldn’t call it a “handler” if it does not handle the 
element like the avail handler does. Maybe “callback”.

Hanna

