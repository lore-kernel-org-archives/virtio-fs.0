Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8B245C708
	for <virtio-fs@lists.linux.dev>; Tue,  4 Aug 2026 11:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785841389; cv=none; b=S5mpRW/qE8VgLA0Bo3GkZ7oKOzmiZ/mKvdZIoMD0+3CRitcr6npAxHrlqaG7q+ka9KhcK1B1HacBN9r3i+PwEmqNZ09OtVoVJWSwGX5tUzjrtSD5iKBkENwqBA0bn2SifegP37lusS6VBG2ePX0XmhNx40dMWweGoyv6NwShgVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785841389; c=relaxed/simple;
	bh=Pm26sXP4XQDPlXU59tDeGjwY7h/rCHTkIWsohyfuJ9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D8vAO6u86bGajv4+cs85Qj6hJCyCX1iNLJFtWaZ7fKgnhDDnUbknD9VxTuWwQtw41o3rj4Q/IAHSqVK/CKWuy1HyWAQfWV6BdQxme2wLRk5VdLtyyWj5VoBi03PT+dIJeHpqBDmKbOstz8yku4p4ARnm0yQzL+xGqu3DqgC+dQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P08dMH6w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P08dMH6w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785841386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DPp8clQhujwMsgaTXoGjXN+e/jriPRTsEeqJ2pEtOOc=;
	b=P08dMH6whiOyVCOhU/kpVSVWd19hExBG+Mne1/3Si7hpznZ8JFFi3D5WQz/a+4nI2UaabO
	MUQNZwBVEZVykfEDkSIyLY9OSfOJ8gKULaFDUEqhwkcOBTRgMCbqmLNxZeUYnrIR4a8FV3
	q+6Tbhweh3r4/nK0ueQg+7RZVMx2zV4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-VVrsEAeqPcansh1WHO_s6w-1; Tue, 04 Aug 2026 07:03:05 -0400
X-MC-Unique: VVrsEAeqPcansh1WHO_s6w-1
X-Mimecast-MFC-AGG-ID: VVrsEAeqPcansh1WHO_s6w_1785841384
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4954dcd6131so33367445e9.3
        for <virtio-fs@lists.linux.dev>; Tue, 04 Aug 2026 04:03:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785841384; x=1786446184;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DPp8clQhujwMsgaTXoGjXN+e/jriPRTsEeqJ2pEtOOc=;
        b=bLv0e7TvvIoghmiAoMIOc/8dFAlTK29DLdgoO7CsUixNsvu/xDbQwcSvCP4Z/GapjI
         eAvkutjs1k8E9hgVhiFMLHFWd3a2+kK9RMkMTx8DBhQHF6mFlRh+Ivt64ok1g6XRbpzR
         7LVsf1y8n2QXZd5uByQIDqs38sLiyj8k5+Ssr6TUBY0v1fu4SiAkO3kX27sPJSQPbnnD
         hlYfJPwJd/mr19jK0ZXIYpFMpS4OB+0jV6f5u52HsU0mtw64RipV8CHuIckAazeVXx1e
         Fb3nuFJSKRJz78L596SEm+sHk64ljPKcG1fkSU3wRT5Mqb0uQdPQTfc7NNE2vBmBU1+3
         BPow==
X-Forwarded-Encrypted: i=1; AHgh+RqmUqOb2jr+KSethuoJbbBlUUFHMvhy8kT4RGnn02sLFs8G5iXxGuPnM3A9294EL5f2gnf13kpH/hA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxdKYIOMqhLQKoDGAt0ZtdKynSWddA20VI6I7c9fVgrR4LN1p9G
	uPJ+Pbqe68/Vz+ZxI49Ypn5gxNDk2xxTWyxybRGJSCxVmz8BvjG7glSGro/YVSt6xqHhY3zguNG
	8U9a9NM5PcfSaJuwbGsegE420Nhg4KHXmavSxGN2y+mGFRF/DvVictQny/AqIlw==
X-Gm-Gg: AR+sD10a+sd1RvMkIx9sb32Y2Hh3ez4h9j+ALxoY1aA6qARmHj53g9VPqNDcueItM8w
	KudoHPHv1/PTDQuvqyN3BIdzUHZ1Dozsu5ms9sCiPzjC/G0esDGm5qMJi+bFZkc+XcOeyoDUqVB
	oxjSj8H2OQbf6J2CRkCBdebpY0wlD3sI9c24gpYDrQQGCvD8EUDi/3Cl0MYdM2RGK7o6daom9mx
	eQXaYw7J6Sh/8KrLNDokoNz1EEIcdqBehSaCiKgDpIlKWDLqZX4KoHSApTQ9vQ8ams3AccUGf6k
	kwpS3CTjICzNwc13pVrP8tYunlWaLjV8VJCBW/7rwSjopmgu6g0wkkLEUc65WN/FltmDy1Ov8yW
	mcsglV+VsUn71SvDiY58WVOV9VwWm6yCStD8uqt3mjgiEE8LFq0AnsULhivtn219sBHLFT1X11t
	9xvrYdrqk+YpLtHxi4OScO+2CRZDX5dQ==
X-Received: by 2002:a05:6000:2211:b0:47f:853d:4768 with SMTP id ffacd0b85a97d-47fd72b518emr35619909f8f.20.1785841384353;
        Tue, 04 Aug 2026 04:03:04 -0700 (PDT)
X-Received: by 2002:a05:6000:2211:b0:47f:853d:4768 with SMTP id ffacd0b85a97d-47fd72b518emr35619788f8f.20.1785841383843;
        Tue, 04 Aug 2026 04:03:03 -0700 (PDT)
Received: from ?IPV6:2003:cf:d73d:54bb:1189:33b6:6950:ef97? (p200300cfd73d54bb118933b66950ef97.dip0.t-ipconnect.de. [2003:cf:d73d:54bb:1189:33b6:6950:ef97])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd64eef60sm38004874f8f.16.2026.08.04.04.03.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 04:03:03 -0700 (PDT)
Message-ID: <fa4a6c1a-6b21-47b7-8d1d-25b71cd70a8e@redhat.com>
Date: Tue, 4 Aug 2026 13:03:00 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 11/15] hw/virtio/vhost-user: create isolation region
To: Connor Kite <connorkite@gmail.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 Haixu Cui <quic_haixcui@quicinc.com>, Raphael Norwitz <rnorwitz@nvidia.com>,
 Kevin Wolf <kwolf@redhat.com>,
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
 <20260723-vhost-user-isolated-memory-v1-11-6b97c439eb28@gmail.com>
 <b6bc052c-1bf5-449b-85d0-e1c4624a5d99@redhat.com>
 <CA+spn3r9X4WST1c4LYS63xN0EFogkD1dJ6P4omk7ndMDeF9D5Q@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CA+spn3r9X4WST1c4LYS63xN0EFogkD1dJ6P4omk7ndMDeF9D5Q@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yIpZzIiC6C-tBPQIaV1J4ResVdjcGEA2A-YhkXjns2k_1785841384
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 03.08.26 21:31, Connor Kite wrote:
> On Mon, Aug 3, 2026 at 6:25 AM Hanna Czenczek <hreitz@redhat.com> wrote:
>>> +typedef struct IsolationRegion {
>>> +    uint64_t base_addr;
>>> +    uint64_t vring_base_addr;
>>> +    uint64_t size;
>>> +    int iso_fd;
>>> +} IsolationRegion;
>>> +
>> Going beyond Stefan, I would say please document each field with a
>> proper doc comment, and ideally the whole struct, too.
>>
> Roger.  I will comment all fields, except for perhaps size, which seems
> self-explanatory.
>
> ...
>
>> In general: Please put spaces after the leading /* and before the
>> trailing */.
>>
> Roger!  I believe I have this in a few places and will correct.
>
> ...
>
>> Patch 13 adds more variables to this, so I think it may make sense to
>> have a dedicated struct for these fields.
>>
> I agree that some of these make sense to be consolidated. However,
> I think I will keep the svq array outside of the struct as the svqs don't live
> inside of the isolation region.
>
> I guess the alternative would be to have an `isolation_mode_ctx`
> type of struct to hold all of the above.

Yes, that’s what I thought, to have an object that would hold everything 
that is used by the isolation code (and rather specific to the isolation 
code).

>> As Akihiko said, the memset() should come after this, and also...
>>
>>> +        u->iso_memory.base_addr = 0;
>> ...this is just a subset of the memset().
>>
> Yes, the cleanup was not fully baked ahead of the RFC post.
> This is currently fixed on my end and will make it into the next
> rev.
>
> ...
>
>>> +    int num;
>>> +    size_t desc_size;
>>> +    size_t avail_size;
>>> +    size_t driver_area_size;
>>> +    size_t device_area_size;
>>> +    size_t total_vring_size = 0;
>>> +    size_t total_mmap_size;
>> Please do not mix variable declarations and normal code (style.rst calls
>> it “Mixed declarations”).
>>
> Got it!  This will be fixed.
>
>>> +
>>> +    /* Get space required for all vrings */
>>> +    for (int j = 0; j < dev->nvqs; j++) {
>> Why j here and i above and below?
>>
> Most likely this was inside another loop on the initial implementation, and the
> iteration variable name was not changed when the outer loop was removed.
> I will change this for next rev.
>
> ...
>
>>> +
>>> +    uint64_t last_addr = int128_get64(int128_add(u->iso_memory.base_addr,
>>> +                                                 total_mmap_size - 1));
>> I would like a comment why you went for a 128-bit operation here. I
>> assume it is because it checks for overflow, turning overflow into an
>> assertion failure, and it can be assumed `qemu_memfd_alloc()` must
>> naturally return a pointer such that adding the length of the allocated
>> area to it (minus one) will never overflow?
>>
>> The question is, do we even need to check for overflow then. Not that I
>> mind it, in principle, I just find it non-obvious. (The more obvious
>> check (imho) would be to just do a 64-bit operation and then
>> assert(last_addr >= u->iso_memory.base_addr).)
>>
> At the time I was concerned about potential overflow prior to application of
> the -1 operand in case the last memory location was at 0xFFFFFFFFFFFFFFFF.
> However, in that case, the -1 would cause the value to wrap back around before
> any use of the value, so my concern was not needed.
>
> There is a similar 128-bit op in the existing code in
> vhost-shadow-virtqueue.c at
> line 133.  To my eye, that might also be a good candidate for
> simplification unless
> I'm missing some other aspect of the use case.

But that’s a guest-provided length, no? I believe the 128-bit operation 
there is done as a genuine check of invalid guest requests. Whereas 
here, `qemu_memfd_alloc()` already must not return a pointer such that 
adding the length of the allocated buffer would overflow (because it 
guarantees that the whole range from the pointer through the given 
length is valid, right).

> ...
>
>>> +        map = &g_array_index(buffer_regions, DMAMap, i);
>> God, I *really*, *really* hate this, and find it really disgusting that
>> the documentation actually recommends doing this (`&g_array_index()`)
>> instead of just offering a separate macro to get a reference.
>>
>> And existing qemu code does it all over the place, too.
>>
>> So I cannot really fault you for it.
>>
>> Still. Too ugly for me to keep completely silent about it.
>>
>> </rant>
>>
>> Hanna
>>
> Would you typically avoid using g_array / g_array_index?

I mean, in this case, I would have just used a plain C array because the 
size is pre-determined by `nregions`, right.

In general, *I* have not used GArray yet (no particular reason), which 
is why I had not come in contact with the `&g_array_index()` pattern 
yet, which had me stare in disbelief at first. (My main problem being 
that the name `g_array_index` is written in lowercase and thus indicates 
being a normal function, whereas macros in C are generally written in 
uppercase to allow at-a-glance distinction. So it pretends to be a 
normal function, but glib recommends a pattern of use 
(`&g_array_index()`) that would never work with a normal function, and 
that I find a dreadful decision by glib.)

Hanna

