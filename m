Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DAF28EB
	for <virtio-fs@lists.linux.dev>; Sat, 20 Jul 2024 19:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721502999; cv=none; b=epCZ+DS8y+JbgCSPPw5Ot7qB0BEx9xIs00COJiBc8LQa/VqPs1XvJR0Xduhb7xl1gQ+qpH0p5cHx5Zm8M9l6xDlCfd7SMVLEmUL9f386W9Z1Jx54DwzLLErLJyvZewXcIYMvpT/hmFstFuEwzVh9sTkYViE4gUlYOmqxYcg0spw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721502999; c=relaxed/simple;
	bh=lQIlhZ8ALBTEBGIrg+2402fL3Hz5fhbwqQksy7+ZxWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=k49/WW958D+sQvhVMxgr527kcy5DAbDr0GAzi4oPaursYiJdnLpR7e47LpZMhdZixguNRKSu2audLszWgxNNB4TdsCaNhJBAAUDsYRt+WpGv6LqjP4I/z9ZNhjgLq6L6dLsoFp8I3T/zigq4/9SwtmYAI3LN38JS9746M4fpfZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CWVNUak9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CWVNUak9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721502996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TotupQWpD/GVU6gkou9HXvrJdz2NmKtSZtsiZcOY+aU=;
	b=CWVNUak9mgTzuSExsQ4s7MXd1+mn48f32oefZs7ucvlGxyrJIBggCnMgnGVwASLN/3ZRGT
	V/vCZPmrdmkAUv8ENiZn80In/xqVbkPVIog8Og+Vd5+8yMP5HQMgqJmWg177XQdVEzq60m
	V56y0ELbPItkji3OeK8kYEmCs+GP1mg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-95H0cCKHM2CpCy1B3iCzHg-1; Sat, 20 Jul 2024 15:16:31 -0400
X-MC-Unique: 95H0cCKHM2CpCy1B3iCzHg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3684ea1537fso1270331f8f.1
        for <virtio-fs@lists.linux.dev>; Sat, 20 Jul 2024 12:16:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721502990; x=1722107790;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TotupQWpD/GVU6gkou9HXvrJdz2NmKtSZtsiZcOY+aU=;
        b=jVKRcp2UPEL1gybLk04goIwZ+6Q9dqmcAmWg6qlBXag7vfQfqtKSTF8FSZphglwr3o
         6bQRpkszwIRF8YI7hhgIoRrlzMTs82vHwGy0LXvei3F1f5ly0CjIbwnzEnNCOfWl1wYW
         YQkGQsbtoJ3761tDxSAmiFMH/bUlGd8ln4vhLsm1vwU6UOaORtjK7JSM3eHDNPxj+D46
         46JAfiF3XdIdmRcuk/r7dllLwVJMOI0YroVRbX1rpmlQANPQwxc8ezkPZwX0fP4gcglZ
         GTPs5wpsQO2et+Qkp6hx8JQ+Uijpm9kG6tqwO7eB697LSsZSp99spROBKF6iJr2pECTA
         +g+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXhkTALyaj1SPianUB0uKfFXAUCh5oVoEg3BWyeZwuENk8mdUtgsG0xaIujYYi0xeG7W3Lw83Mby+CdrzjMQQY90AOxE8pJz88K
X-Gm-Message-State: AOJu0YxANCmZ0Q9GOy5wdO6nZw3PY9FKWBVaPGipLzJuFHybYEC711Mz
	Saip6ft6xg710jk6Q5w6ulQqQ0MsB/GwdxqHcnleL7gMR1zQ/WiukM4MstOWx0OW6x6yOAXin1x
	bRIxQe0H8OwCgy3UvI02w+T0HIAaEtBpXohfjPqz/b5qQczC1i4bwI5QZKw==
X-Received: by 2002:adf:e84a:0:b0:367:97b9:d5ed with SMTP id ffacd0b85a97d-369bae4a3bdmr1367709f8f.9.1721502990524;
        Sat, 20 Jul 2024 12:16:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF91mmIMjLb1LISne4ihplZUmmRSaZhE/4sGStWEsyTWSLpObllroymxZZbCCku4Fl+qJRSSQ==
X-Received: by 2002:adf:e84a:0:b0:367:97b9:d5ed with SMTP id ffacd0b85a97d-369bae4a3bdmr1367690f8f.9.1721502989968;
        Sat, 20 Jul 2024 12:16:29 -0700 (PDT)
Received: from redhat.com (mob-5-90-113-158.net.vodafone.it. [5.90.113.158])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3687868493bsm4403401f8f.24.2024.07.20.12.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jul 2024 12:16:29 -0700 (PDT)
Date: Sat, 20 Jul 2024 15:16:26 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, raphael@enfabrica.net, kwolf@redhat.com,
	hreitz@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
	fam@euphon.net, eperezma@redhat.com, stefanha@redhat.com,
	qemu-block@nongnu.org, schalla@marvell.com, leiyang@redhat.com,
	virtio-fs@lists.linux.dev, si-wei.liu@oracle.com,
	boris.ostrovsky@oracle.com
Subject: Re: [PATCH v4 6/6] virtio: Add VIRTIO_F_IN_ORDER property definition
Message-ID: <20240720151557-mutt-send-email-mst@kernel.org>
References: <20240710125522.4168043-1-jonah.palmer@oracle.com>
 <20240710125522.4168043-7-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240710125522.4168043-7-jonah.palmer@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 10, 2024 at 08:55:19AM -0400, Jonah Palmer wrote:
> Extend the virtio device property definitions to include the
> VIRTIO_F_IN_ORDER feature.
> 
> The default state of this feature is disabled, allowing it to be
> explicitly enabled where it's supported.
> 
> Acked-by: Eugenio Pérez <eperezma@redhat.com>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>


Given release is close, it's likely wise.
However, I think we should flip the default in the future
release.

> ---
>  include/hw/virtio/virtio.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index fdc827f82e..d2a1938757 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -373,7 +373,9 @@ typedef struct VirtIORNGConf VirtIORNGConf;
>      DEFINE_PROP_BIT64("packed", _state, _field, \
>                        VIRTIO_F_RING_PACKED, false), \
>      DEFINE_PROP_BIT64("queue_reset", _state, _field, \
> -                      VIRTIO_F_RING_RESET, true)
> +                      VIRTIO_F_RING_RESET, true), \
> +    DEFINE_PROP_BIT64("in_order", _state, _field, \
> +                      VIRTIO_F_IN_ORDER, false)
>  
>  hwaddr virtio_queue_get_desc_addr(VirtIODevice *vdev, int n);
>  bool virtio_queue_enabled_legacy(VirtIODevice *vdev, int n);
> -- 
> 2.43.5

