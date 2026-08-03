Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279893043CE
	for <virtio-fs@lists.linux.dev>; Mon,  3 Aug 2026 12:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785759685; cv=none; b=jjPiMZW15ms7KQonBt85OCYmq028ryxtiEqMO3dzUdiM2D47jzIhLmhAdxZU9LGkICLLEovUvmq+XooYEzYWwR0xXjhQRz6LzAMzy3/9qW0kLZcvem/kS4o4XUZg8boMLku4yBULpfniMJ7cz55nCYSzWVxQoROuerKI+6D8b4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785759685; c=relaxed/simple;
	bh=tk1yRNCi+JkWN2hzHu6nNJNaJiybcr1LSFzPyqXvLPo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gdc3phslpUv4uk0izkB2xCvPzj7wuCtIaU4rd9TCH90yqtf1eDjtC9ht7gXfSxVmcEShdx4LMAJN+KoLBIYMhPrw7IRqISbs01BwisRFt/7r+p0zbVb6Oc9U4uG2LktK5pkf77OLdZTddC/cLTiPaFbDlaYbj9QdsQBRMqIMS3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WLpMUyKr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WLpMUyKr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785759683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ImKDnu/DXiRULUxoPjPgQ+NFqnyR9Oyx6v/LfSKDPJ4=;
	b=WLpMUyKrg+x0M2SvzjpBYhLOIv5OdUbvCb4roa+M3OgmYAXsLhFg39uCP9xgpj51VOLM7C
	LyynQBk/t1tDRANEX6TGh2LtN4dDgt03Hua+W7RqK22ofEQTa9rw/z9OFMC/809oFqydWI
	YLBP5bGySSCaqSSEZdP7n+6WH0X66X4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-CT_F2dYbOFKnneHjEG7hBw-1; Mon, 03 Aug 2026 08:21:17 -0400
X-MC-Unique: CT_F2dYbOFKnneHjEG7hBw-1
X-Mimecast-MFC-AGG-ID: CT_F2dYbOFKnneHjEG7hBw_1785759676
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47f8398ed9fso3170210f8f.0
        for <virtio-fs@lists.linux.dev>; Mon, 03 Aug 2026 05:21:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785759676; x=1786364476;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ImKDnu/DXiRULUxoPjPgQ+NFqnyR9Oyx6v/LfSKDPJ4=;
        b=hmX1Q9kGHco1xm1H4Nl8sdCPwLDTMt1h/ROqeMQBlmfYZS6VBTqNGg91BzTpBiTXqS
         IzZBJhX9/YsXYVHOFIccQ6QVNyDpzO4u2H1ODw0nqOdOZ/4J8tunXC9N6zL0lWLbRCya
         IyRmSaXL1/5mUwafa7Hw+1D2VCLpP1E+5Ksh8NmpcfAXWm3mskMSjdiMZ2gZK8gGo+c+
         yeKLWLBJOuIzYeSygdw6EZwlW53TV5LlfwjET2jxCPsUYDap7ialRPBziF/Tdiu0esVP
         tW9EqAGcrBM/CgjKS4Shice8bdzM7UCTLV0DnoHo4JI4vzHBi2CfYqAq1izKSrtyAvEY
         729Q==
X-Forwarded-Encrypted: i=1; AHgh+RpbgBoi9wqx0zJcj7nu4nKgL4Xf+S+dZog9p9kJuUqWyjpJmofq+RVoZngX9q8Jvn3JdAtGsdJ45Wo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRWgmWw4u+DQ8D2uwkyw4QPQf8lUuzW683ptqTgcdF+ETsufTx
	MBEHUP53lG10aIUJbFV0MFQgA41J6f/m8dOU0rTLDUfikg6S8+lNsR1YFZBV/OsSihoSqLe0vzg
	zOX3NmumtpBIXjXCgvB9RiJJxHtDQk2QkXxP67EciHih4FpXEw3TT8y9xdszWfg==
X-Gm-Gg: AR+sD116x0U2y5gpvS4dSSr2peYwEjowbgc+vbuq1gAfS/JDCXZdVwahAgd1njS0joV
	m4Rufo0UyILTM5IDuSa4uFRAhBg22xBi5cSmJItYzRQeFRg9evP601kdwRaPXtK6h24AqSlqs7X
	n+5S/6Xs3oPj8Y+UDqoNHWi+myyQuVLMhbnF7YGpDRKdOrcKs0F2iIqb38TAkRnbJFIYEPWkQMi
	2HvjWs2eBWH9K6TpEYcDMSnmvn7jokq8zw1HzQKn1q4FGXeU1fGbANzDXaSd7v1w7Id4j3JNq8X
	UcjSLLxAoaUmf9jgFuBF6zvFMchEcOUA5/h5u2aIi8RAdL3IsgCrh3qome76EVEORv+0v9DNpv3
	iiaGOt14RiDDO+PYQxmCWre14xkPnu5W+Q3XXPDMlqnz2pLrofdnalBsmA60z+I3ovJj4jRQuvz
	N6CFd5C4ZEZ1Lje7K0DeRjIW+FM59swQ==
X-Received: by 2002:a5d:588e:0:b0:47f:e721:1f77 with SMTP id ffacd0b85a97d-47fe7211fedmr2880287f8f.13.1785759675754;
        Mon, 03 Aug 2026 05:21:15 -0700 (PDT)
X-Received: by 2002:a5d:588e:0:b0:47f:e721:1f77 with SMTP id ffacd0b85a97d-47fe7211fedmr2880140f8f.13.1785759675111;
        Mon, 03 Aug 2026 05:21:15 -0700 (PDT)
Received: from ?IPV6:2003:cf:d73d:549a:e584:7c7b:2611:32a1? (p200300cfd73d549ae5847c7b261132a1.dip0.t-ipconnect.de. [2003:cf:d73d:549a:e584:7c7b:2611:32a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd45a0ae0sm33651014f8f.33.2026.08.03.05.21.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 05:21:14 -0700 (PDT)
Message-ID: <eb1d8424-206a-47f5-9ad5-a833a56bb3f3@redhat.com>
Date: Mon, 3 Aug 2026 14:21:11 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 02/15] vhost-user: Add memory-isolation qdev property
 to vhost-user devices
To: ConKite <connorkite@gmail.com>, qemu-devel@nongnu.org
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
 <20260723-vhost-user-isolated-memory-v1-2-6b97c439eb28@gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-2-6b97c439eb28@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ceZlYGckBoyqo_A8guyTFnwyUgxeDbLuXx4XVMGJdk4_1785759676
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 24.07.26 00:30, ConKite wrote:
> In support of future work to add a memory isolation mode to vhost-user devices, a
> qdev property, "memory-isolation", is added to all vhost-user devices. This is
> simply a bool representing whether the mode is active or not.
>
> Signed-off-by: Connor Kite <connorkite@gmail.com>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   hw/block/vhost-user-blk.c            | 1 +
>   hw/display/vhost-user-gpu.c          | 1 +
>   hw/scsi/vhost-user-scsi.c            | 1 +
>   hw/virtio/vhost-user-base.c          | 3 ++-
>   hw/virtio/vhost-user-fs.c            | 1 +
>   hw/virtio/vhost-user-scmi.c          | 1 +
>   hw/virtio/vhost-user-vsock.c         | 1 +
>   include/hw/virtio/vhost-user-base.h  | 1 +
>   include/hw/virtio/vhost-user-blk.h   | 1 +
>   include/hw/virtio/vhost-user-fs.h    | 1 +
>   include/hw/virtio/vhost-user-scmi.h  | 1 +
>   include/hw/virtio/vhost-user-vsock.h | 1 +
>   include/hw/virtio/virtio-gpu.h       | 1 +
>   include/hw/virtio/virtio-scsi.h      | 1 +
>   14 files changed, 15 insertions(+), 1 deletion(-)

Should `vhost_user_vga_inst_initfn()` set up an alias for 
"memory-isolation", like it does for "chardev" now?

There are four lines in here that the checkpatch script notes to be over 
80 characters in length, so they should be broken up.

[...]

> diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
> index 90bd2903db..d2a74a2860 100644
> --- a/hw/virtio/vhost-user-base.c
> +++ b/hw/virtio/vhost-user-base.c
> @@ -409,7 +409,8 @@ static void vub_device_unrealize(DeviceState *dev)
>   
>   /*Define common qdev properties.  Inherited by all children*/
>   static const Property vub_properties[] = {
> -    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev)
> +    DEFINE_PROP_CHR("chardev", VHostUserBase, chardev),
> +    DEFINE_PROP_BOOL("memory-isolation", VHostUserBase, memory_isolation, false)

Nitpick: I would add a comma here. (This hunk shows specifically why 
it’s a good idea: So that future additions don’t have to change the line 
to add the comma.)

Hanna

