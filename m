Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8E17BAE1
	for <virtio-fs@lists.linux.dev>; Tue,  5 Mar 2024 06:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709621772; cv=none; b=IvYHjKeLJzVutAHTuTqp3R43/2j+Y+hgrgZ1Vay5WfRuk7C++2mRj+VGOLjhwVQCblWz/at6/WXbc8jkBkQBLNTIYYTJlUPiaaGducNxHKznzYvMslb7Yk8S1CPkxtMdqp+ctpvUGJuRuYljonb9+snUL6yCFQJmJKqsapv1bxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709621772; c=relaxed/simple;
	bh=zmY/cY5i+Hkv0zlObtf63hq/QDBJ3oGYovwmmpDQp9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pK43hV51yG11hKBRWt89Li5CsUJJJxI5ki71xlDxx8dPrFMfhGX3bEH5hNZAJFM9j/XfMhbh9p4EOAYcNH5ABlD+33CRXIBs9kGmTWIixVF9rOBEH25cHRzqwpl8sHpSXsOUSjeT9dKH4Y4AamWh4oCCu5KdtDnQ5rOJAk1sz9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PPrCAziD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PPrCAziD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709621769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nZMRmZ/2SsjkSO0PkukIWpzEubGAMevMx9kQUeQSna0=;
	b=PPrCAziDVsANZ5/Fj/3PyAbX5Q3QAeTGbnGEAks23wbhGA9fiCYEVOwl7KEqBZ8wA8jnZV
	z+6KSlHExRDcFxcIY4HZ65sCsRZO9n2P74Aa2icAGOLcSkY/u6oi0q3CL1y0LzYaq0qJfY
	8mozqT4xz8Cncu7TVQhntYzC9CioonU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-kTirLHlbNdajjG9i7MkWQw-1; Tue, 05 Mar 2024 01:56:07 -0500
X-MC-Unique: kTirLHlbNdajjG9i7MkWQw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a457ac99155so88437266b.2
        for <virtio-fs@lists.linux.dev>; Mon, 04 Mar 2024 22:56:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709621766; x=1710226566;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nZMRmZ/2SsjkSO0PkukIWpzEubGAMevMx9kQUeQSna0=;
        b=QcOZNNGITNA2Rfn6mRj7XBdcRLi0Ox29j0iEOo20hfxJtn/2IYFHbQ0bMGmTp9ri3o
         fsGO/NnVGTckPJ8V4Y0p0n2BU0kL3478k6ctmr2dD+mHaV+hmo/18URWPP8O1SGzL3NH
         eXdDreBiPcanUwrB0kpgHaHCkkTws2uBdKHNZZ87JpJob8fQl1Xty2sQkqPW/JY6FV/9
         LeMLOTxMDxOm+AJ0s0btm47mO771X1P21pA1LwRC/UBTforSi8JQCAdB6vyR0/1tbYtO
         4H1+0q9o1xZ6LifIVaf+B077Q3jtclkxPASvLho0akJCovgfa5/C5ykB23+vmUOOlphE
         VY5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVtJyuRPpbMZ/quhw2xnofAingETa4Q4VnNDp657UDFYcVlNDc1aAQXOwWwe9VceWLzJOtoMq9OCeba2BdCxwUtPzMILHPaKo9y
X-Gm-Message-State: AOJu0Yzs5dp0bxQvGJoLb5b5yUb5mOt/mzLrrZkzf0Bhx/ZEQc2XvBnj
	m1WnWKp1rmeWLEiDc8FT0IQe7dpgG/XBg806RKzrdAHUyO13MqLANiCGU9b10pXY+oz+nWlGeKY
	DtdVUw8B4FzfLD++ZHkBhGeB8JgJJi7VEDsg+yPQRaDBC+KEx0JXkMjP+Tw==
X-Received: by 2002:a17:906:2b4e:b0:a45:622e:a0b9 with SMTP id b14-20020a1709062b4e00b00a45622ea0b9mr2386799ejg.64.1709621766797;
        Mon, 04 Mar 2024 22:56:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEPW9itF42tECIBVFWAJUABPk0V7sAEskFZPaEpiKuX64LfEF6rIZb99uyQvNgz0x0GKl/GHA==
X-Received: by 2002:a17:906:2b4e:b0:a45:622e:a0b9 with SMTP id b14-20020a1709062b4e00b00a45622ea0b9mr2386779ejg.64.1709621766468;
        Mon, 04 Mar 2024 22:56:06 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-243.web.vodafone.de. [109.43.178.243])
        by smtp.gmail.com with ESMTPSA id uz3-20020a170907118300b00a44bb63f29csm4010255ejb.47.2024.03.04.22.56.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 22:56:06 -0800 (PST)
Message-ID: <4ae198c2-37ea-4df6-bc99-2c03848cef26@redhat.com>
Date: Tue, 5 Mar 2024 07:56:03 +0100
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/8] virtio,vhost: Add VIRTIO_F_NOTIFICATION_DATA support
To: Xinying Yu <xinying.yu@nephogine.com>,
 Eugenio Perez Martin <eperezma@redhat.com>,
 Wentao Jia <wentao.jia@nephogine.com>,
 Rick Zhong <zhaoyong.zhong@nephogine.com>
Cc: Jonah Palmer <jonah.palmer@oracle.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "mst@redhat.com" <mst@redhat.com>, "jasowang@redhat.com"
 <jasowang@redhat.com>, "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
 "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
 "raphael@enfabrica.net" <raphael@enfabrica.net>,
 "kwolf@redhat.com" <kwolf@redhat.com>, "hreitz@redhat.com"
 <hreitz@redhat.com>, "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
 "farman@linux.ibm.com" <farman@linux.ibm.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "david@redhat.com" <david@redhat.com>, "iii@linux.ibm.com"
 <iii@linux.ibm.com>, "cohuck@redhat.com" <cohuck@redhat.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "fam@euphon.net"
 <fam@euphon.net>, "stefanha@redhat.com" <stefanha@redhat.com>,
 "qemu-block@nongnu.org" <qemu-block@nongnu.org>,
 "qemu-s390x@nongnu.org" <qemu-s390x@nongnu.org>,
 "virtio-fs@lists.linux.dev" <virtio-fs@lists.linux.dev>
References: <20240301134330.4191007-1-jonah.palmer@oracle.com>
 <CAJaqyWfD96Dh9gVavzC22KuaG4bwJ0m7sbWOsy9fR4y1HJ3-Gg@mail.gmail.com>
 <PH0PR13MB56827829C8502484EACF080D88222@PH0PR13MB5682.namprd13.prod.outlook.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <PH0PR13MB56827829C8502484EACF080D88222@PH0PR13MB5682.namprd13.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05/03/2024 04.21, Xinying Yu wrote:

> One more thing, I would ask how do  I get the full series patch? Do I copy 
> the RFC line by line from this link[1]?

For getting patches that you might have missed on the mailing list, I 
recommend lore.kernel.org :

 
https://lore.kernel.org/qemu-devel/20240301134330.4191007-1-jonah.palmer@oracle.com/

You can download mbox files there that you can apply locally with "git am".

  HTH,
   Thomas

