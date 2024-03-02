Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B52182AF
	for <virtio-fs@lists.linux.dev>; Sat,  2 Mar 2024 15:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709393640; cv=none; b=N7Ek4qAKu/fN06D5SJsSCxECVGRVAEgWS9r75lXuv52WFayPZK663UK2lrCZBv5ll1oycAO55eV9YaBun/2b/NzsjrpVc7nrowIQ1q6sDHHszHb658et8wiyigARrEwGg6t8+ZTmmke1scTduT71ghS2oYQK5uNfQgil4878ytE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709393640; c=relaxed/simple;
	bh=ZfA/FwN4sZsu2AfG7LViEnUexMsrZgIrVGxGvbu9FGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aT0BOBVQfDmv9mrmpon1EYzLKp/dKsgPMt9D3REkPDdVUV9MJYvKL1jZHLRXePEX5jDWALmSgeXAkQ8PAPJ8HD6fdJfZu2LCLDtg+OsREgxKjG791bIKaLlhpz+CuOKTx5bE3ocfp26xiXU/T1txBQFtdyux5Yl+z0XVjkIM+wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SnPYqAhK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SnPYqAhK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709393637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=54pAYSo8hZvMTDgBLslAFWG2BSBhNyIksapSarakzGo=;
	b=SnPYqAhKtfPXFEEpQJBGbdqDU/F7jI/y983uHPZ8UrfqKpAOqbKy1lduuiSm+8aN0sxEEw
	wlssLIQq9asqhhLqb2n/27+dtmZQQp96y5g8uWPZCV4AJ5AbvGPfsdWHcFyl7hrTK8PFNu
	xxjPQmazv071DB1U68xt2uoH9dB7O+E=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-oIZVo7jFMhmRNVHO8Yemvg-1; Sat, 02 Mar 2024 10:33:56 -0500
X-MC-Unique: oIZVo7jFMhmRNVHO8Yemvg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a44508b6b22so167726066b.2
        for <virtio-fs@lists.linux.dev>; Sat, 02 Mar 2024 07:33:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709393635; x=1709998435;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=54pAYSo8hZvMTDgBLslAFWG2BSBhNyIksapSarakzGo=;
        b=kLfeG6mhZmyaH5Vt09fIIRDt0TzJjW7M5Mt8UTkSIXn0+GqGGcEKrbkMsXFCVZm3jM
         Mo232caGRbhXN7HfLMEBe8+LfVX0TEvhsD9YjRwihnT2sNvXhjDNyKbcZ58SFlxekByg
         uP57DdZNJE35uQT8kYvW+OU4XLRJUQ9/pDd71mqWEeMXOi/TtF69QzcGeOZdk2q26qLZ
         CB9kPpGGHXMp0PsFYqNOtGNiGs8RQSnhxhfEi45Pt8vvAqcose9K1iXgKyrjpUwFyPuN
         F0pZpomeaqIcNxkW6ySRJCufYkYNSp39HP/AFX12NdnB5GSfF3wQfDmQ9zPjCBcP3sIb
         LADQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkt0p0oH85Tt5eHCQWSCT8xUCpGzCfRRa243v4XleGPO7MWX785LR1PiYVzKzLWtT/pJSkuGo7cgLNnF/HqJRNMK5voVulxh/I
X-Gm-Message-State: AOJu0YzP4pWzy2a6IvjMHWu1Iwgq5CERq5tIYAzblbJUhzX/P6wqay//
	uXcJMnkRQOC6s9ZMQ4mimo474aHen99cwihHwBCSmGDMD7N8VofpoEScaEbp+TCZXFvV0kkUkP5
	T0eT+eeeMidLqX9rXijLTO65cCLVYWzMFN51idfsp14Vf0lYcrJ+VE7KPsg==
X-Received: by 2002:a17:906:dfc1:b0:a44:e5fc:d4e4 with SMTP id jt1-20020a170906dfc100b00a44e5fcd4e4mr976690ejc.33.1709393635199;
        Sat, 02 Mar 2024 07:33:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGmkLG0ADS//phIihupprRmTdKDr7lei2HdGBD9Ojq2gCroQrWFywMWB7BibZ5JMDDxDS/mJQ==
X-Received: by 2002:a17:906:dfc1:b0:a44:e5fc:d4e4 with SMTP id jt1-20020a170906dfc100b00a44e5fcd4e4mr976671ejc.33.1709393634840;
        Sat, 02 Mar 2024 07:33:54 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-133.web.vodafone.de. [109.43.178.133])
        by smtp.gmail.com with ESMTPSA id ag3-20020a1709069a8300b00a44790d06d3sm1918149ejc.71.2024.03.02.07.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Mar 2024 07:33:54 -0800 (PST)
Message-ID: <65fee13a-f927-4791-a3a9-132f53ad5ae0@redhat.com>
Date: Sat, 2 Mar 2024 16:33:52 +0100
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 5/8] virtio-ccw: Handle extra notification data
To: Jonah Palmer <jonah.palmer@oracle.com>, qemu-devel@nongnu.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
 si-wei.liu@oracle.com, boris.ostrovsky@oracle.com, raphael@enfabrica.net,
 kwolf@redhat.com, hreitz@redhat.com, pasic@linux.ibm.com,
 borntraeger@linux.ibm.com, farman@linux.ibm.com,
 richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
 cohuck@redhat.com, pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
 qemu-block@nongnu.org, qemu-s390x@nongnu.org, virtio-fs@lists.linux.dev
References: <20240301134330.4191007-1-jonah.palmer@oracle.com>
 <20240301134330.4191007-6-jonah.palmer@oracle.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240301134330.4191007-6-jonah.palmer@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/03/2024 14.43, Jonah Palmer wrote:
> Add support to virtio-ccw devices for handling the extra data sent from
> the driver to the device when the VIRTIO_F_NOTIFICATION_DATA transport
> feature has been negotiated.
> 
> The extra data that's passed to the virtio-ccw device when this feature
> is enabled varies depending on the device's virtqueue layout.
> 
> That data passed to the virtio-ccw device is in the same format as the
> data passed to virtio-pci devices.
> 
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>   hw/s390x/s390-virtio-ccw.c | 18 ++++++++++++++----
>   1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 62804cc228..b8e193956c 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -140,9 +140,11 @@ static void subsystem_reset(void)
>   static int virtio_ccw_hcall_notify(const uint64_t *args)
>   {
>       uint64_t subch_id = args[0];
> -    uint64_t queue = args[1];
> +    uint64_t data = args[1];
>       SubchDev *sch;
> +    VirtIODevice *vdev;
>       int cssid, ssid, schid, m;
> +    uint16_t vq_idx;
>   
>       if (ioinst_disassemble_sch_ident(subch_id, &m, &cssid, &ssid, &schid)) {
>           return -EINVAL;
> @@ -151,12 +153,20 @@ static int virtio_ccw_hcall_notify(const uint64_t *args)
>       if (!sch || !css_subch_visible(sch)) {
>           return -EINVAL;
>       }
> -    if (queue >= VIRTIO_QUEUE_MAX) {
> +
> +    vdev = virtio_ccw_get_vdev(sch);
> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
> +        vq_idx = data & 0xFFFF;
> +        virtio_set_notification_data(vdev, vq_idx, data);
> +    } else {
> +        vq_idx = data;
> +    }
> +
> +    if (vq_idx >= VIRTIO_QUEUE_MAX) {
>           return -EINVAL;
>       }
> -    virtio_queue_notify(virtio_ccw_get_vdev(sch), queue);
> +    virtio_queue_notify(vdev, vq_idx);
>       return 0;
> -
>   }

Acked-by: Thomas Huth <thuth@redhat.com>


