Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F911DFFB
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 12:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785761794; cv=none; b=FlOR9EEWqnveECxF+a7aVpkIgTgUmz3+TLlwy1hW2DCveI6eFuQJw1O4V32F3A7HPrMYDvnMycIAbAdVazPMJW6thlAQp2oYBz+YQIGE90ndb76dK0jYuWeu6Y7B8DpDRlP+a+yhxMj+b7Jjp2VjxN7LxtoS2gL+iPjUYqxCnBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785761794; c=relaxed/simple;
	bh=MpZspS0al7VH9IuthUmpGycxSgYqYSxETkkgyx9Xi/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UknxTL1hSLHmfprB+ihY5sctQn8Atgu3Tj9E5Bx3lExJpFpaCGYfIscCglv140QJURI6ynCdnJQHMgk5WDthdgNkpdBPHfm9+Bqi2NNcsas2pajQ9ujUHM2XzV/ctG8eaQUtDw/6unR4FRPJRWa9jtSLewM/UuFTpSDNtGHHUH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iwmwWpzd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iwmwWpzd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785761791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j/DmcwM+Uh6OE4okcJAw3UWbpV7nfREwvzmcz3XNS5k=;
	b=iwmwWpzdNWzCmxNPgI3L6N9ubRXefH9vemuUZDAjs0ATOUfbJde8LcvHC5NTmfXmEOz2Wg
	fUdrtNMkaFkyXFu5zaRn4soBxUi9F0aAtyGsrgpd6BAvxRQg+gwyWYF9JiWRludp9xQcZX
	YUuJheYxEmxylnipjlsGihXob24kJ1Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-ELWQVHZSNEaW0KCy-GvfxQ-1; Mon, 03 Aug 2026 08:56:28 -0400
X-MC-Unique: ELWQVHZSNEaW0KCy-GvfxQ-1
X-Mimecast-MFC-AGG-ID: ELWQVHZSNEaW0KCy-GvfxQ_1785761787
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4955e865174so12010205e9.3
        for <virtio-fs@lists.linux.dev>; Mon, 03 Aug 2026 05:56:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785761787; x=1786366587;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j/DmcwM+Uh6OE4okcJAw3UWbpV7nfREwvzmcz3XNS5k=;
        b=QFrJVRjIgA7aV01AUg2O6sob/n18RQE7WVjeMGB2WLLtBQZEoiwg0573L8NKv6oq13
         7iiL1H1Kecw4dOPIxvLlOUUOIA80KKG9WO1ZS2qgKQQ+9gix8kGPHtxjy52iw8PPwihZ
         2Lb6WSGEJxyGlEO2kowHeI6YERcWNTuRoznyq2rvyyBFj7lfRcOaMHg5GjrqBPsMHQvQ
         ZspNQF0MrKPPkZCCIbb8gXv0LcikDZpvwIrtg1nJqxYfzCGtJo3/54G7JqRzHN8P5iof
         fh4uEHZaxtmPa9f7BHUWYY7mn29cSsrL/K/odHOKr+RKnA5C+oDlRuNjaKY0Ls1/FRds
         y9MA==
X-Forwarded-Encrypted: i=1; AHgh+RrTUaGIb0WuzYqv12rg7GYWYSlCYC1CJFLzaawDZVV56X1FtkXUs8k/iRaVStXQUJxitYizYd6VsiI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGNHe18FsT2WVu1FXYqDtMBRwV4Uo8P1NaMVdfm6Nuv1s8e7dR
	6kC6tJHleC27qUyKHJovsz9uhSJhdmAOAzlu8gAw2eN7meA/NBA2N7kP2mIK1/ffdO+SNaXF/l6
	GynwzTi0HI6FaqXm3utqQpAw0iV2zIaGidqmsVpuVeRwy2vSxqqlA/DYdB3J8aA==
X-Gm-Gg: AR+sD12/0/U3fQVGrGt5Pqxcsj7X8UF0CvjcWJWvqfJ02xIsbuqJSrB3flPkbOoDm3c
	ZARFQ4oskStijFuqG/jJCGzLF+wA7oF+MP+dI8eXpaU8nSRRUIE4YW9QNnAZM0jMPYUyUPa0Zs1
	dg54WgmpQQYl3KoLY+4YvbULkOIJIEFJhktVUhfkhGGGB6VT2afPBLc17Q55RXRhSQ7HPf3EvY1
	lyR8qkK0F5eHTE2cip0grbB3UC3FfAfSKca1Qzr5D8zfGY38ilTCJuOySfLCiI6Q44Iu8yDbCVO
	783oJgKykM30av1W3/eoKDPk+FjK3cXJeAKl97kdke1u8+NqnT9u9vdHovex5hJM4qS+KeYWRUT
	aGCCHYKKiVnBisxWTb9Edbgpksj089mijM2DG35crVrYbYZKJsO9TnBOwgPycphDwUjVFlL23x9
	Q5fv0xe9iPt3EUP/cs/KrtQX4yz+OS5Q==
X-Received: by 2002:a05:600c:a4d:b0:493:e46e:157d with SMTP id 5b1f17b1804b1-4980c693eaemr230430365e9.19.1785761787510;
        Mon, 03 Aug 2026 05:56:27 -0700 (PDT)
X-Received: by 2002:a05:600c:a4d:b0:493:e46e:157d with SMTP id 5b1f17b1804b1-4980c693eaemr230429425e9.19.1785761787086;
        Mon, 03 Aug 2026 05:56:27 -0700 (PDT)
Received: from ?IPV6:2003:cf:d73d:549a:e584:7c7b:2611:32a1? (p200300cfd73d549ae5847c7b261132a1.dip0.t-ipconnect.de. [2003:cf:d73d:549a:e584:7c7b:2611:32a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd458ab61sm33503288f8f.25.2026.08.03.05.56.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 05:56:26 -0700 (PDT)
Message-ID: <ba6158dd-7b7b-4457-9256-497ab60a27d3@redhat.com>
Date: Mon, 3 Aug 2026 14:56:24 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/15] hw/virtio/vhost-shadow-virtqueue: range
 boundary in translation
To: Connor Kite <connorkite@gmail.com>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
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
 <20260723-vhost-user-isolated-memory-v1-10-6b97c439eb28@gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-10-6b97c439eb28@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yNQ8jxa0yJfCpL4TDuYa7xd30vM4mCzCw9bZkOjUtH8_1785761787
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 24.07.26 00:30, Connor Kite wrote:
> iova-tree expects inclusive range sizing when maps are allocated or searched.
> Currently, svqs use exclusive sizing when searching their
> vhost-iova-tree for a match to the region to be translated.  This could
> lead to errors if the region to be translated is at the edge of an iova
> region.
>
> Fix this by reducing `needle.size` by 1 in
> vhost_svq_translate_addr to bring then it line with DMAMap and iova-tree
> convention.
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   hw/virtio/vhost-shadow-virtqueue.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
> index 9e3c359f50..20e5c7d2f1 100644
> --- a/hw/virtio/vhost-shadow-virtqueue.c
> +++ b/hw/virtio/vhost-shadow-virtqueue.c
> @@ -104,14 +104,14 @@ static bool vhost_svq_translate_addr(const VhostShadowVirtqueue *svq,
>               /* Search the GPA->IOVA tree */
>               needle = (DMAMap) {
>                   .translated_addr = gpas[i],
> -                .size = iovec[i].iov_len,
> +                .size = iovec[i].iov_len - 1,  /* Inclusive */
>               };
>               map = vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
>           } else {
>               /* Search the IOVA->HVA tree */
>               needle = (DMAMap) {
>                   .translated_addr = (hwaddr)(uintptr_t)iovec[i].iov_base,
> -                .size = iovec[i].iov_len,
> +                .size = iovec[i].iov_len - 1, /* Inclusive */
>               };
>               map = vhost_iova_tree_find_iova(svq->iova_tree, &needle);
>           }

It’s not immediately obvious what is ensuring that `iov_len` can never 
be 0. Sure, it would be wrong and makes no sense, but that is why I 
think an `assert(iovec[i].iov_len > 0)` would be appropriate.

(Looks like `virtqueue_map_desc()` is what rejects zero length, but that 
is not really local to this code path, so not immediately obvious.)

Hanna

