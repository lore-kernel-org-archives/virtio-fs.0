Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB12442901E
	for <virtio-fs@lists.linux.dev>; Tue, 11 Aug 2026 11:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786446255; cv=none; b=XqePokRIlqD8M5PNBy2Wnk4ys4mLpU9AnM32xnTvEbEo+i6HYnZ8U8knJub5JUPUttTPyaAAN8nInpOI20j/WAKPSfHQqJuZAX8Iy78HQwhCVu/RIX3FjkrdH5YzOkYoqUcBQy9k6cWts6Jh1pWlorXz5dLIDUY7JiRA0sy28XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786446255; c=relaxed/simple;
	bh=IjpG86barOhhg9z8eBEd8wfF5exo4XZ8ucJY5U0nlyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EI1yOEKL6VFv2BlLRlDSeU2ms2UMYBty/i3/6S7U5BXdYsEBbg94LhG4bYLhaBCZtnIZaE4K8q7OlMrSwbFGj6PABD3PwkwjYXQRU8OiG0EePsDrnzPKmxYdHzOy8XgMmpq/4AZ+3CQAqNVFhawi0hKzT4tyAcfIGSVUFWOJIu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OtnWgMcg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OtnWgMcg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786446252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x+FkPEdueLwHWFyrKrhKgCEWI0VHQD9Y7/FLtdLDcRU=;
	b=OtnWgMcgvbPUbaXqKuxcRvJaKDwzugwiNXDFHTwtC0t+iTsTykJRPZ+6om15IythIB0gTh
	koTcXhaUDujcGCQg7bclLev0sFdyuY3rZWhKv/f3/z+o6krAqBFuplZDRvLF8w5QDNvFuX
	QTGFd5aWj1bKXIKCxRyJfCJGpKsuGKM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-Ez13XM4HM0muf_u7p9U1AQ-1; Tue, 11 Aug 2026 07:04:09 -0400
X-MC-Unique: Ez13XM4HM0muf_u7p9U1AQ-1
X-Mimecast-MFC-AGG-ID: Ez13XM4HM0muf_u7p9U1AQ_1786446248
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-473ac08a6a4so2032841f8f.0
        for <virtio-fs@lists.linux.dev>; Tue, 11 Aug 2026 04:04:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786446248; x=1787051048;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x+FkPEdueLwHWFyrKrhKgCEWI0VHQD9Y7/FLtdLDcRU=;
        b=b2aMPBtSU4BtkTkqd/7Stm0A9CqyhmKnjLKqBDjDAf9KDi6DVazUCsEZldDZ+9aMRa
         lYl5EyzCoBBLYTuPenLocWfA/YuBe1PXDsHFf4LNT+L1lHqzrHXgFFpWAGX0XhAkPqsv
         9815PHK8XuwPxqs5gUuzJTtIM3FiAZvlqOotFvRhlsfzsL1l9iiX4V77IN/n5ASRVrU/
         oWcdQdWzuze3AGh9vcgDXEMJKZ31PAcONwuXAwCEBx2gMmkYDgX0kvoTv4IW+vF0+6uo
         PVhkDIdpOZmnKV+fA7t8vhqfphLlYitnrld737DMxOsHYzQbPFGDPKqs561gApr1tt0r
         vh8Q==
X-Forwarded-Encrypted: i=1; AHgh+Rr3luoaAt41le2CQohl7iaCBJp30abkff4bKFygadRI/U4PXsG8J0Ae4PH+5ueL5WxCgKGQUntnrIs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyOmN+bBD49nbR430xTA2cUU0U4War9gNJW5siE84wy/CnrdVqH
	V/8sWA11cbfrMJrx+wF6wmjmDO5Osce1jnqly5wlivxWvB0erxFLu18VDhqfU4ajMuS3i4clgfh
	ooOh74nfEcIMWjleXEGq24yRDGznisxlLgM4BSPKHQSbRzcxLQT7gCmWL8v+CmQ==
X-Gm-Gg: AR+sD13kXF+8ynMjMP7Fy99/clGq7VecPR0TAoYMhbYFCs93uoPYfFc1T3UmiVI4TK+
	6o+tx3jo6XQYF0VhQVYMfK+2hWeRVYfQ38m6YT8AOhmkfLs6blE+tawv9q+Q/b6v7QVoxbjmmsA
	5OBGDaJ7mzmVNqQf19Gc9CUxqicQNQgLraWxoAkDr0AL+Tqms/YcABmaUH8wcC94XKTd6uV8qHV
	GbGqQCoYRK8c5V12O//JsppHa5/RCCi2f4aasOux7VQ55TZ3iIGb2p5vaKxiuWO07IohWRKqbrE
	OYicVhSnNFhHvMgdJTHnihX3zfUiL7NUN1xJpSVtEmnen57vtXsAToVM000+z68GedEBWr4ZBuD
	Suibt/aTmvMBwpYJsSQe8oaxdclo/SeYSCa3KD7QYAcPqqtIAdQU5M8GG8RaNUZXAtEumCE14TY
	ePFgwc/i0e7OsH2UERnFR8DYuXV4eO9w==
X-Received: by 2002:a05:6000:18ab:b0:481:45ed:cb50 with SMTP id ffacd0b85a97d-4814adc2590mr4032315f8f.16.1786446247854;
        Tue, 11 Aug 2026 04:04:07 -0700 (PDT)
X-Received: by 2002:a05:6000:18ab:b0:481:45ed:cb50 with SMTP id ffacd0b85a97d-4814adc2590mr4032229f8f.16.1786446247445;
        Tue, 11 Aug 2026 04:04:07 -0700 (PDT)
Received: from ?IPV6:2003:cf:d706:f1cb:272a:2c7d:bb01:94e8? (p200300cfd706f1cb272a2c7dbb0194e8.dip0.t-ipconnect.de. [2003:cf:d706:f1cb:272a:2c7d:bb01:94e8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a5ac6cfsm3224864f8f.4.2026.08.11.04.04.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 04:04:06 -0700 (PDT)
Message-ID: <1355454f-0dfb-463a-86d8-a09ef6204dea@redhat.com>
Date: Tue, 11 Aug 2026 13:04:04 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/15] hw/virtio/vhost-shadow-virtqueue: range
 boundary in translation
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
 <20260723-vhost-user-isolated-memory-v1-10-6b97c439eb28@gmail.com>
 <ba6158dd-7b7b-4457-9256-497ab60a27d3@redhat.com>
 <CA+spn3qP1xahLRTNutmOLvDEXJXHh9W1tMeGeKiiDiz-ntyknw@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CA+spn3qP1xahLRTNutmOLvDEXJXHh9W1tMeGeKiiDiz-ntyknw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rIFJXWqq_APal9jfIof7Dc1pWC5tzLoNESGTeOjZN4A_1786446248
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 08.08.26 07:52, Connor Kite wrote:
> On Mon, Aug 3, 2026 at 5:56 AM Hanna Czenczek <hreitz@redhat.com> wrote:
>>
>> It’s not immediately obvious what is ensuring that `iov_len` can never
>> be 0. Sure, it would be wrong and makes no sense, but that is why I
>> think an `assert(iovec[i].iov_len > 0)` would be appropriate.
>>
>> (Looks like `virtqueue_map_desc()` is what rejects zero length, but that
>> is not really local to this code path, so not immediately obvious.)
>>
>> Hanna
>>
>  From the QEMU Coding Style guidelines on error-handling it looks like
> errors that
> could be initiated by a malfunctioning guest should not cause Qemu to
> exit. Would it be
> more appropriate to return false when zero-length is detected?  That follows
> the existing error path returning up to vhost_handle_guest_kick, which
> renders the svq
> unresponsive to future kicks.

Sure, but it’s necessary only *if* a malfunctioning guest could cause 
this. As I said, it looks like `virtqueue_map_desc()` already rejects 
zero-length descriptors, so an assert should be sufficient.

Then again, if you can handle it benignly either way (without an 
assert), that’s always a good option.

Hanna

