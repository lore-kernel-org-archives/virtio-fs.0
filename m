Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9907B403AF1
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 12:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760607; cv=none; b=oJq3it7AhfIEsiSqgz+Yk8xKSHL5wTWPCgaYPMJ4yP+HnA0mMbYm0RWXrVLeu5CDbCQ4771DpTbP8wsLT5giUqOf9y+Cq5zKBLUDHJY5US7+ysf8oPjRqzi0Oee8SbtR+FbooegKTiBUT282gMjyhWSMv2tJIKE8pzfFc6RkhIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760607; c=relaxed/simple;
	bh=1wHwDS/fqXSdONGlSm+AU5ZnMmbWH11FSxY8gj8Og7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YUVrgZFWvyp4QIxsAu2cv0ZtlINUS4L3LYzEDWMukcy24/STEfpZMbOOcZ38W9jIII2i5gmvhKpSX1+ndxCpjwZSbdp9LY6sPvObwAyEDgZnRYv7D4flOM0os3jhZ6QfFHIzZC3e82im7IO6WzrOHCsydeCbReb1ioc3a9NhVlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PJ8C4Qhy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PJ8C4Qhy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785760605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PxHISWqf5pgrRXOkzRFXQxsDfQ2sN0hwCWX8wTNkvq0=;
	b=PJ8C4Qhyap3ieqt+3G2H3yvPCR3j7V0IFLsSTEFypjpy5yhsXwFsbKbvgROGrsYbVQEU37
	x3ev0RFpu+0y6MtmmTzTBd/VpNZzQ9eKa7YPOdrn141f5jTtBRV8p1wT1U2kUaS+Avit0W
	3mGJ4KMhQD34qQ/NkDahnOWLuvDcTKg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-RFOl0qLAP02DvkTWbbojqg-1; Mon, 03 Aug 2026 08:36:44 -0400
X-MC-Unique: RFOl0qLAP02DvkTWbbojqg-1
X-Mimecast-MFC-AGG-ID: RFOl0qLAP02DvkTWbbojqg_1785760603
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5b015ed1b78so2035109e87.3
        for <virtio-fs@lists.linux.dev>; Mon, 03 Aug 2026 05:36:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785760603; x=1786365403;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PxHISWqf5pgrRXOkzRFXQxsDfQ2sN0hwCWX8wTNkvq0=;
        b=Is9m7cxGYh4zVLTFXcJW7lxo+kWAUryyg+qL7Yjj9e5CheeW4tE0/GRFL4sEv8ObE/
         2aqPfpt+v6p45wC6rEG7qbpt/APumF1P3grt1ey1aWIWTgPLMJJhtzzgVQyP53cIM/rf
         sSEZyUAK0oCCuuQRrk53k030oZzfPyYppZ9EGC5Ab/Q83OX3IojSQ8Q3PhXI4i7wr7n1
         giI9EKZCw/jTGCPTbfb8tO8k/DdxSdkm7u1m1jjQ0MELan+hUEhBZmnSgiezpqa24fuD
         zSbZbfM2bTTQBiMT8sfRO5QthQhmfj5KYx7XlULHoLYmqWOPYUKI5Xk2VSnCSIhAcUkC
         Avuw==
X-Forwarded-Encrypted: i=1; AHgh+Rr0+oyi5cGjanOeeutffKX1+CoZMNIWfVliQqKI9TZ+WrRhZPV7569ckml0Mrtte+GvdShxRa8aCHw=@lists.linux.dev
X-Gm-Message-State: AOJu0YynkySn3+bsu2it2yjQfrxBVxzO1XvmJ9qQOngYtJa1OwPIyk/m
	19iNqgkng0SkIw+GXFHca0aRZ70eEmHgCqyW8UgHAV8tIpzDrnWWILE5iiLfTowZUc9j7hcpxK4
	ZUewitOmecflPwMblLA/lTz9kQcGcV16IOx/aYyv9hIWefBzOIo9yIgVReYYj/Q==
X-Gm-Gg: AR+sD10rVS25ZjPPHc2ckzJGH+POhYTFsU11aNIBZhwoj9SOKC4qpaa4cc4EMyDcduA
	zo6u7p1wuDwOkFn3+RwfUR/DNmRUNXN9KztSttnWJj2mP9Z6eTuNdCBFzQOx8kEIFIicIXbgwRy
	kYENspLq5pj1iw2WweZnXaNuZ5m5CCMzZP7FDvR+oVT9qARFE/GFhZ+onVuZPhUOUGDZc93y6BE
	G/4uuzKH4TVqZcMgocRV7MqALgdy8onr7TN8ZCind7t35Bfro+B74IeTogBuLIily5534h1vqB9
	YxbhyCsTYnqhJNeEfsh2oUdBiEqJ6OW5XwTjKS3R5Gs+Of0juiZ0y8jIqvYFM8ErbcGXlDs1pbv
	VkPoEQezYpW4eoaJkCLlGMHjbPcBcVdnFNDiheuAw7YtW4fnvbcyha3/z5kQfhH1qtSo9CoS4ua
	lNVmfQC0+Yl5Qh+tHp3UVKkL0aNH7O4A==
X-Received: by 2002:a05:6512:b93:b0:5b0:1af0:2a2a with SMTP id 2adb3069b0e04-5b2e4f922e2mr2093331e87.61.1785760602598;
        Mon, 03 Aug 2026 05:36:42 -0700 (PDT)
X-Received: by 2002:a05:6512:b93:b0:5b0:1af0:2a2a with SMTP id 2adb3069b0e04-5b2e4f922e2mr2093300e87.61.1785760602082;
        Mon, 03 Aug 2026 05:36:42 -0700 (PDT)
Received: from ?IPV6:2003:cf:d73d:549a:e584:7c7b:2611:32a1? (p200300cfd73d549ae5847c7b261132a1.dip0.t-ipconnect.de. [2003:cf:d73d:549a:e584:7c7b:2611:32a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e2441e8asm1970073e87.44.2026.08.03.05.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 05:36:41 -0700 (PDT)
Message-ID: <f7776822-106c-47d0-ada9-fab75f68c76d@redhat.com>
Date: Mon, 3 Aug 2026 14:36:37 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 06/15] util/iova-tree: g_tree_foreach wrapper
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
 <20260723-vhost-user-isolated-memory-v1-6-6b97c439eb28@gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-6-6b97c439eb28@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AkWQhHb1KbkThlLHhIA6h46q8FM-IdcthRCcdidRWPQ_1785760603
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.07.26 00:30, Connor Kite wrote:
> Add a wrapper to iova-tree to call g_tree_foreach.  Provies a means to
> execute some function on each node of the iova-tree.
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> ---
>   include/qemu/iova-tree.h | 13 +++++++++++++
>   util/iova-tree.c         |  5 +++++
>   2 files changed, 18 insertions(+)
>
> diff --git a/include/qemu/iova-tree.h b/include/qemu/iova-tree.h
> index 14e82a22d5..4d77f4dc57 100644
> --- a/include/qemu/iova-tree.h
> +++ b/include/qemu/iova-tree.h
> @@ -161,4 +161,17 @@ int iova_tree_alloc_map(IOVATree *tree, DMAMap *map, hwaddr iova_begin,
>    */
>   void iova_tree_destroy(IOVATree *tree);
>   
> +/**
> + * iova_tree_foreach:
> + *
> + * @tree: the iova tree to traverse
> + * @func: the function called at every node. A true return value ends traversal

Can you document roughly what the function looks like? Because the type 
(`GTraverseFunc`) is not defined in qemu. I know it has a boolean as a 
return type, and that one argument of it is going to be `gpointer data`, 
but surely it will also take a tree element.

Hanna

> + * @data: an argument passed to func
> + *
> + * Wrapper to call g_tree_foreach on underlying g_tree
> + *
> + * Return: None
> + */
> +void iova_tree_foreach(IOVATree *tree, GTraverseFunc func, gpointer data);
> +
>   #endif

