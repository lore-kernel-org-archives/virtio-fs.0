Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705DF1CD0A
	for <virtio-fs@lists.linux.dev>; Fri,  8 Mar 2024 17:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709917262; cv=none; b=u82DjegPvOZkUCbvIe09ODvdnSU2sSCjz7s09ZElzAdge6tELPkx/0NZnE6JvRM4vaqvAYRhq1QK7E8sQZIRVa3Jd/QRcWyE4vJz2pdYLjZoWopb4Tizb7HzjEcMnZCblWKM5esUKhkf/hf+4NG2vKvOKFW5TRLeGU6Li3aE4TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709917262; c=relaxed/simple;
	bh=xC83gSoR7sniK8lc0eEiVJFtKWJs6Cd7QnzcqJ9/U2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=FaV2dDn1b5Qule7qWj4XYx7G/q1dtBWmQUiSjV0bzFrnN9MdOEr+tRbONO2gWkS+jfbyCQFp8mTPrVW078xgbiC4HSJrlTRLhPF8XDBgo19ACAIkXsuf+j1UAjA+Xqe/JvgbAIKolHXEYbcAXMoxNKI5lazpgahu3nrJ3y4qYpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QIxxkbjF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QIxxkbjF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709917259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G5mlJPTdJkWjqRDFmHZCmG622raxGwhz9st2Ydsv++Y=;
	b=QIxxkbjFGlQPZxxu+17dwtcDfLtdt8xOWIoVAc7zHhXS/YXyS2hTQKZnpciYW4C+JwO5F1
	ioF0Yfb5wlewqwEQ5O+NDc5jAITd4NjhUyUx5vFg1siu1gOTSNGJN+EfTJMTErMRf1ZCFZ
	rLfc9vjWuqGJQxMT7rxGKRxT85cYEug=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-PkHZCQGIPFy2UODUI9_1yQ-1; Fri, 08 Mar 2024 12:00:57 -0500
X-MC-Unique: PkHZCQGIPFy2UODUI9_1yQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-33d308b0c76so1671651f8f.0
        for <virtio-fs@lists.linux.dev>; Fri, 08 Mar 2024 09:00:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709917256; x=1710522056;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G5mlJPTdJkWjqRDFmHZCmG622raxGwhz9st2Ydsv++Y=;
        b=IRgc3yjqfE80POoC1XUJ2yxT9h+6TtjZsV7bIFv72rvTb5qGPDG+RWQ30sz/5OLaPw
         a41wwaeO3qrsk1H315gBKDubqULhoiKe/0f439zIsQGYAy0n/R0NT11jT+pEyfNsPIqa
         x0pE0L/A9b1jDfkgZiQtRgtSpqbutXTzJ13YwcJT45JG2x+aOsWsLPmLA2qZyjxKjwM8
         iwMSHvxw7dkiG/7/mIvbDMhM9IsCTRsXFhSgL7A75XqB1GGa5x7OIEFtKVNWVL/UofuU
         ZhIJ85uEmmmZ91kG3JFAwpE4PEucfwlAOWWFHJ0M9q1eAilsd0wPa5y44M6ztbSy/RXN
         U7Cw==
X-Forwarded-Encrypted: i=1; AJvYcCUoQ8osAiawfXo4XQNCh+IHu+X65rYWjooBRFMQ5uFAUvSz039+sYOWegf0KmPOW7QgQhomx9FfPnJXysMRQc3fuf0LCWTZPo5F
X-Gm-Message-State: AOJu0YxL0wTe7ruSaAr4l3mcfhfssMTXpnm60WbDGAkKKpzDrzAaQB51
	bBX9vviG6DWC2DUesS/1H83oVLj9LSkghABhC/j47Hs1ZTi0JNPEbFUHAwGKB9Y2t24mTyD5Q+8
	hbI3bR2Bwl3SlmVA6/refMQJt/feaeDsVGARBsGp4OEeyt1xwANAFrQS+hw==
X-Received: by 2002:adf:f74d:0:b0:33e:6a81:d8b9 with SMTP id z13-20020adff74d000000b0033e6a81d8b9mr964624wrp.20.1709917256549;
        Fri, 08 Mar 2024 09:00:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE5+HudhTCCO9/AQo1CbSQZRDzjKBZSZp57vnRV8/sIdymJYpEjcFBPYQEqzecM/mPOfNdlCA==
X-Received: by 2002:adf:f74d:0:b0:33e:6a81:d8b9 with SMTP id z13-20020adff74d000000b0033e6a81d8b9mr964568wrp.20.1709917255979;
        Fri, 08 Mar 2024 09:00:55 -0800 (PST)
Received: from redhat.com ([2a06:c701:73cd:f300:bc74:daca:b316:492a])
        by smtp.gmail.com with ESMTPSA id f14-20020a5d50ce000000b0033b66c2d61esm23296385wrt.48.2024.03.08.09.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 09:00:55 -0800 (PST)
Date: Fri, 8 Mar 2024 12:00:52 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, jasowang@redhat.com, eperezma@redhat.com,
	si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
	raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
	pasic@linux.ibm.com, borntraeger@linux.ibm.com,
	farman@linux.ibm.com, thuth@redhat.com,
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
	cohuck@redhat.com, pbonzini@redhat.com, fam@euphon.net,
	stefanha@redhat.com, qemu-block@nongnu.org, qemu-s390x@nongnu.org,
	virtio-fs@lists.linux.dev
Subject: Re: [PATCH v1 2/8] virtio-pci: Lock ioeventfd state with
 VIRTIO_F_NOTIFICATION_DATA
Message-ID: <20240308115951-mutt-send-email-mst@kernel.org>
References: <20240304194612.611660-1-jonah.palmer@oracle.com>
 <20240304194612.611660-3-jonah.palmer@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240304194612.611660-3-jonah.palmer@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Mar 04, 2024 at 02:46:06PM -0500, Jonah Palmer wrote:
> Prevent ioeventfd from being enabled/disabled when a virtio-pci
> device has negotiated the VIRTIO_F_NOTIFICATION_DATA transport
> feature.
> 
> Due to ioeventfd not being able to carry the extra data associated with
> this feature, the ioeventfd should be left in a disabled state for
> emulated virtio-pci devices using this feature.
> 
> Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>

I thought hard about this. I propose that for now,
instead of disabling ioevetfd silently we error out unless
user disabled it for us.
WDYT?


> ---
>  hw/virtio/virtio-pci.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> index d12edc567f..287b8f7720 100644
> --- a/hw/virtio/virtio-pci.c
> +++ b/hw/virtio/virtio-pci.c
> @@ -417,13 +417,15 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
>          }
>          break;
>      case VIRTIO_PCI_STATUS:
> -        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK)) {
> +        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK) &&
> +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>              virtio_pci_stop_ioeventfd(proxy);
>          }
>  
>          virtio_set_status(vdev, val & 0xFF);
>  
> -        if (val & VIRTIO_CONFIG_S_DRIVER_OK) {
> +        if ((val & VIRTIO_CONFIG_S_DRIVER_OK) &&
> +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>              virtio_pci_start_ioeventfd(proxy);
>          }
>  
> -- 
> 2.39.3

