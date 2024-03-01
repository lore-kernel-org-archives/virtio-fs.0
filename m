Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A001B39AD4
	for <virtio-fs@lists.linux.dev>; Fri,  1 Mar 2024 20:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709325190; cv=none; b=tJocW/I0Ptk3PPbYYRnm/dYVVtAJb/oJW2rhroQYPkjJCOK0T6J4u4wtNj4rbcxdQAUMJQxykTkwnIlggPOjersBC0h9SX1CeLuII1W/NfKeSTWesojISA4mS2T6WJrcjkQi5/FsbwCpkTclBrNQ670S1/vAfdIHEecjYxwgIiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709325190; c=relaxed/simple;
	bh=6eBRCH1BHzR2rkWrXaaHQ8DpjrnSwn150NuVaeOHTPY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vh65YP47B/zWDUc/+dd5ADSVKVGSPfUILs0wuNYmOMl9Cq+lbdO2K1OTMw6Zr/fStfm6XQilnHKFku5ohTkM5lW/czht+fzooED6aoRL4XHpun4QkdUN8FAiXs+dTZje7iplYp4ypd0/mkspBHtlJR4MZWeVZh0LhHu58FLAZtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N5w4pmcr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N5w4pmcr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709325187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JekRTZsMlrf+FEvkqJPtKIxNmwHErCIsbh0T0Zg3mA=;
	b=N5w4pmcrRWmCeKOfYzywLvKK/gfKC1e8e8vCyJsL/ZM1qRqt0E+AzqyK8DytejD/E8dKJC
	k+T+3K8bkxN25mzFKBm7LdjB1nhuYn99SBGFwCbWFDcEaN9Rd4Xi35RlzN03KKLOrip6+7
	KLQ8Pa/59Uf0FAAmQzJoWaXeNeMZiEQ=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-W90ZJ-mZPRKj9BbB-DKxDA-1; Fri, 01 Mar 2024 15:33:06 -0500
X-MC-Unique: W90ZJ-mZPRKj9BbB-DKxDA-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-dd001f821caso1146880276.0
        for <virtio-fs@lists.linux.dev>; Fri, 01 Mar 2024 12:33:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709325185; x=1709929985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7JekRTZsMlrf+FEvkqJPtKIxNmwHErCIsbh0T0Zg3mA=;
        b=VKqBT3qt52vaLzG6tYPMCPaMCHLmZJbYJN/cVBrWFYrvyStBrVHJotU9oU/37ebYLO
         mfxHeSWCm2j2+j8MgOWLU9gqsxGLdI6VmEFz0Jl0hWCszZ6W5ckJlBL2Eai2tdvjKA4v
         O3ua5scK95/DvT6VTviin+yhb+BRi2egDFNwhke5adFy2q6YE7YIzY7RAwr1eg4qM4nU
         fXB+6+ozT6mdVw+6TfF9t6wc+iEiypuOZT5BwaTFmbD5Q4lSd9b4cgbsA4t3LFXnfj9q
         Lwkju+QTAT1GIqy0OfxZe3r/XgoBz3wYn4htkSMVepURnmeLnUTwM1ySM41d18HmwuKg
         nCTg==
X-Forwarded-Encrypted: i=1; AJvYcCW1+Ejcqwdu86VmhXPpnIBShJIbECAxZVIzueOPS28/dsP6rF+0rnoFLnUbYNtc6GulC/JI7qygmrnwc7w5ZuRJ1nY/nIK5BqZo
X-Gm-Message-State: AOJu0YxEx5d5nc3j8bpFjO6562dWfySEbi0tJ8faMqp5gNCZIT+sdo7t
	Db2iMJiQsPCibUw3qIazmhRFEyjfVJRYxIiaFqrugnL+Yhp57NxJWkywEGgtXMcgQh04aBWjj8m
	XxOkYpMO0PlMpl8U56ifGG1pbMXaqzBRVRWTf1SzxjPYIlfw6yPW7END8Yy2KYXn9/d/vjDFx3H
	chiZ3KWFPtVNlPsGHRU7BxnS5MHgX3dT/E
X-Received: by 2002:a25:ba48:0:b0:dcf:9aeb:73af with SMTP id z8-20020a25ba48000000b00dcf9aeb73afmr2106879ybj.2.1709325185695;
        Fri, 01 Mar 2024 12:33:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGebWf+1TXP+6k5ZRJI3Gxcr22nlqFqDK3NKq9d2JbPHvQ5STmvxtAAYyiUDQGCC/9HqwFXhJbf0ttCfq6apRo=
X-Received: by 2002:a25:ba48:0:b0:dcf:9aeb:73af with SMTP id
 z8-20020a25ba48000000b00dcf9aeb73afmr2106869ybj.2.1709325185470; Fri, 01 Mar
 2024 12:33:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240301134330.4191007-1-jonah.palmer@oracle.com>
In-Reply-To: <20240301134330.4191007-1-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 1 Mar 2024 21:32:29 +0100
Message-ID: <CAJaqyWfD96Dh9gVavzC22KuaG4bwJ0m7sbWOsy9fR4y1HJ3-Gg@mail.gmail.com>
Subject: Re: [RFC 0/8] virtio,vhost: Add VIRTIO_F_NOTIFICATION_DATA support
To: Wentao Jia <wentao.jia@corigine.com>, Rick Zhong <zhaoyong.zhong@nephogine.com>, 
	Xinying Yu <xinying.yu@nephogine.com>
Cc: Jonah Palmer <jonah.palmer@oracle.com>, qemu-devel@nongnu.org, mst@redhat.com, 
	jasowang@redhat.com, si-wei.liu@oracle.com, boris.ostrovsky@oracle.com, 
	raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com, 
	pasic@linux.ibm.com, borntraeger@linux.ibm.com, farman@linux.ibm.com, 
	thuth@redhat.com, richard.henderson@linaro.org, david@redhat.com, 
	iii@linux.ibm.com, cohuck@redhat.com, pbonzini@redhat.com, fam@euphon.net, 
	stefanha@redhat.com, qemu-block@nongnu.org, qemu-s390x@nongnu.org, 
	virtio-fs@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Wentao / Rick / Xinying Yu,

Would it work for you to test this series on your use cases, so we
make sure everything works as expected?

Thanks!

On Fri, Mar 1, 2024 at 2:44=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.co=
m> wrote:
>
> The goal of these patches are to add support to a variety of virtio and
> vhost devices for the VIRTIO_F_NOTIFICATION_DATA transport feature. This
> feature indicates that a driver will pass extra data (instead of just a
> virtqueue's index) when notifying the corresponding device.
>
> The data passed in by the driver when this feature is enabled varies in
> format depending on if the device is using a split or packed virtqueue
> layout:
>
>  Split VQ
>   - Upper 16 bits: last_avail_idx
>   - Lower 16 bits: virtqueue index
>
>  Packed VQ
>   - Upper 16 bits: 1-bit wrap counter & 15-bit last_avail_idx
>   - Lower 16 bits: virtqueue index
>
> Also, due to the limitations of ioeventfd not being able to carry the
> extra provided by the driver, ioeventfd is left disabled for any devices
> using this feature.
>
> A significant aspect of this effort has been to maintain compatibility
> across different backends. As such, the feature is offered by backend
> devices only when supported, with fallback mechanisms where backend
> support is absent.
>

Hi Wentao,

