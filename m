Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740697F46B
	for <virtio-fs@lists.linux.dev>; Tue,  5 Mar 2024 08:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709626235; cv=none; b=DGhKHZqH91cb0fxlA+YGt1KtJFH1B+3JNzcrbt7you2qV6t6PntkBzcOgUUgdW/e03vOt9liVCRYtmTGIbxHF3vPOEZORqbFMz6kBfXfyMRWXp5V0bBu5S22YDMzCEBLcxxADVqdk4fICVgU2XnyPW3I5OxRT3rO6DusRjOto6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709626235; c=relaxed/simple;
	bh=82zP8RDbhqKKCseHVQnigF5yuE5zYX4qmAINXeD5As4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K+DWfcG/O8EMK5kBdWMkJBb/KK6zBroR0eBSAikKCjGT8yTgYamSsgT3vKTKu5sPFQDOYl1AyxxpM0m2myKxEe3i+oCM3peWdFj5b+T63VW6TQ5kZWSWfmxEfmaRoQY28eKkJQxq/ArHuvlLxUFJfOmXxZmY99R44FFPOK/ixAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SImVjEP1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SImVjEP1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709626232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z3adD3uiPjEOwLSm8EeWzBQaHJetS1oLKIdTLsoeUyY=;
	b=SImVjEP11CUHS4fyEka4Y/pGWzbI+8GV4iYCri4HLOPeV1wfy0WmqWmaEIyQrC2sIrlmnP
	E5D5lV5qsLDmpaiEmAc/yyGUApzFxuKwSiDSOzEhvAtIDtMXjsrL7wDU+NKxNb66AJU5ZL
	HF3Wl9exMgKZD1b3TRf/J6H8kxvR7rE=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-ZyuejKYDPyOZhq01rZKVCg-1; Tue, 05 Mar 2024 03:10:30 -0500
X-MC-Unique: ZyuejKYDPyOZhq01rZKVCg-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-6099e707622so7983877b3.3
        for <virtio-fs@lists.linux.dev>; Tue, 05 Mar 2024 00:10:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709626230; x=1710231030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z3adD3uiPjEOwLSm8EeWzBQaHJetS1oLKIdTLsoeUyY=;
        b=Y/yRLImPfQBzVu1U8sawbk582dDblboCfaGM7XxmMPdytXj6awn7UdZHrOXVyoEF0J
         mLNWWXsN+jm8lm5rGXjxQQL8ZquQtIm+mcVTop7LhxFrwi7evBXjWxeUsgjcfaqOUqc3
         VciKxNqxmAxFmauoSW7zbr8NMaDpHUevCCU5dpO7piPWGdFF3uOG7vN2JC9Wc046+jDH
         qYTeG3vGSrBi3kHAXcWASFzDQ2K9o59VfxFP1dRvnoyk0wAhvvUPKAy8OeselVfbTDb6
         Gux3KhexZLOtDWhXK3R/Fmr5Px2vXzS8n4uGX+Gxcx3QwgRY4mz/u7VDtu6WZ+4GnHua
         YaKA==
X-Forwarded-Encrypted: i=1; AJvYcCXthCDTk662gRsnndyXrxC5wsNNniajQLzNWaRtdPELmEX/dHWoCF7VTGq7BDr+721Ftkk4bNtxlJ8cx7m6fzMsWL13swoWBreT
X-Gm-Message-State: AOJu0YxMxxRC3Q1LvuPHW0ddYGNL/gDMyiYROmDn9mnrNqriCGWI0uVp
	MKgytZKysNvUratpYOSVtYNG5i1j9PSGAaVQz4OJzUk49hGg2/hNETp5p6zv7jpOB1XU7rRktSw
	dyzozrWGxWn0Jc+0ueioJSg4sxY804Q9F9IAnb+UOCmtDfzdo/+jfXot/8RmJXC8uUE6OUxkmOb
	muPjeIIkVYwmksnJdyY4ruj2mpAsGQSdEU
X-Received: by 2002:a0d:fb83:0:b0:609:716a:4cb5 with SMTP id l125-20020a0dfb83000000b00609716a4cb5mr12770037ywf.12.1709626230034;
        Tue, 05 Mar 2024 00:10:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFwOB264u5Z7CcsO/tA8R/hXv04MCoxPMXJP4LJsfSSpWR9z+Aj4edkjgOLwZm2se7jgazvgkHxvBCURqqDpZw=
X-Received: by 2002:a0d:fb83:0:b0:609:716a:4cb5 with SMTP id
 l125-20020a0dfb83000000b00609716a4cb5mr12770014ywf.12.1709626229796; Tue, 05
 Mar 2024 00:10:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240301134330.4191007-1-jonah.palmer@oracle.com>
 <CAJaqyWfD96Dh9gVavzC22KuaG4bwJ0m7sbWOsy9fR4y1HJ3-Gg@mail.gmail.com> <PH0PR13MB56827829C8502484EACF080D88222@PH0PR13MB5682.namprd13.prod.outlook.com>
In-Reply-To: <PH0PR13MB56827829C8502484EACF080D88222@PH0PR13MB5682.namprd13.prod.outlook.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 5 Mar 2024 09:09:54 +0100
Message-ID: <CAJaqyWdr5PyxNJ2D_HMk8U2xEpfPTebi4d91V3ONs91yNibwOw@mail.gmail.com>
Subject: Re: [RFC 0/8] virtio,vhost: Add VIRTIO_F_NOTIFICATION_DATA support
To: Xinying Yu <xinying.yu@nephogine.com>
Cc: Wentao Jia <wentao.jia@nephogine.com>, Rick Zhong <zhaoyong.zhong@nephogine.com>, 
	Jonah Palmer <jonah.palmer@oracle.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, 
	"mst@redhat.com" <mst@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, 
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, 
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, 
	"raphael@enfabrica.net" <raphael@enfabrica.net>, "kwolf@redhat.com" <kwolf@redhat.com>, 
	"hreitz@redhat.com" <hreitz@redhat.com>, "pasic@linux.ibm.com" <pasic@linux.ibm.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "farman@linux.ibm.com" <farman@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, 
	"richard.henderson@linaro.org" <richard.henderson@linaro.org>, "david@redhat.com" <david@redhat.com>, 
	"iii@linux.ibm.com" <iii@linux.ibm.com>, "cohuck@redhat.com" <cohuck@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "fam@euphon.net" <fam@euphon.net>, 
	"stefanha@redhat.com" <stefanha@redhat.com>, "qemu-block@nongnu.org" <qemu-block@nongnu.org>, 
	"qemu-s390x@nongnu.org" <qemu-s390x@nongnu.org>, 
	"virtio-fs@lists.linux.dev" <virtio-fs@lists.linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 5, 2024 at 4:21=E2=80=AFAM Xinying Yu <xinying.yu@nephogine.com=
> wrote:
>
> Of course,  I am glad to do.  And I need to clarify that our use case onl=
y support VIRTIO_F_NOTIFICATION_DATA  transport feature on DPDK vDPA framew=
ork which the backend type is NET_CLIENT_DRIVER_VHOST_USER and use user_fea=
ture_bits. So the new feature add on vdpa_feature_bits  will not under veri=
fied in our case.  Not sure this meets your expectations?

As long as the driver keeps using notification data it is not able to
tell the difference between one scenario or another, so yes.

> One more thing, I would ask how do  I get the full series patch? Do I cop=
y the RFC line by line from this link[1]?
>

lore.kernel.org is a good alternative as Thomas mentioned. Another
good one IMO is b4, which allows you to download the series and apply
with "git am" too using "b4 mbox
<20240301134330.4191007-1-jonah.palmer@oracle.com>" (untested).

https://pypi.org/project/b4/

Thanks!

> Thanks,
> Xinying
>
>
> [1] https://lists.nongnu.org/archive/html/qemu-devel/2024-03/msg00090.htm=
l
>
> ________________________________
> From: Eugenio Perez Martin <eperezma@redhat.com>
> Sent: Saturday, March 2, 2024 4:32 AM
> To: Wentao Jia <wentao.jia@nephogine.com>; Rick Zhong <zhaoyong.zhong@nep=
hogine.com>; Xinying Yu <xinying.yu@nephogine.com>
> Cc: Jonah Palmer <jonah.palmer@oracle.com>; qemu-devel@nongnu.org <qemu-d=
evel@nongnu.org>; mst@redhat.com <mst@redhat.com>; jasowang@redhat.com <jas=
owang@redhat.com>; si-wei.liu@oracle.com <si-wei.liu@oracle.com>; boris.ost=
rovsky@oracle.com <boris.ostrovsky@oracle.com>; raphael@enfabrica.net <raph=
ael@enfabrica.net>; kwolf@redhat.com <kwolf@redhat.com>; hreitz@redhat.com =
<hreitz@redhat.com>; pasic@linux.ibm.com <pasic@linux.ibm.com>; borntraeger=
@linux.ibm.com <borntraeger@linux.ibm.com>; farman@linux.ibm.com <farman@li=
nux.ibm.com>; thuth@redhat.com <thuth@redhat.com>; richard.henderson@linaro=
.org <richard.henderson@linaro.org>; david@redhat.com <david@redhat.com>; i=
ii@linux.ibm.com <iii@linux.ibm.com>; cohuck@redhat.com <cohuck@redhat.com>=
; pbonzini@redhat.com <pbonzini@redhat.com>; fam@euphon.net <fam@euphon.net=
>; stefanha@redhat.com <stefanha@redhat.com>; qemu-block@nongnu.org <qemu-b=
lock@nongnu.org>; qemu-s390x@nongnu.org <qemu-s390x@nongnu.org>; virtio-fs@=
lists.linux.dev <virtio-fs@lists.linux.dev>
> Subject: Re: [RFC 0/8] virtio,vhost: Add VIRTIO_F_NOTIFICATION_DATA suppo=
rt
>
> Hi Wentao / Rick / Xinying Yu,
>
> Would it work for you to test this series on your use cases, so we
> make sure everything works as expected?
>
> Thanks!
>
> On Fri, Mar 1, 2024 at 2:44=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.=
com> wrote:
> >
> > The goal of these patches are to add support to a variety of virtio and
> > vhost devices for the VIRTIO_F_NOTIFICATION_DATA transport feature. Thi=
s
> > feature indicates that a driver will pass extra data (instead of just a
> > virtqueue's index) when notifying the corresponding device.
> >
> > The data passed in by the driver when this feature is enabled varies in
> > format depending on if the device is using a split or packed virtqueue
> > layout:
> >
> >  Split VQ
> >   - Upper 16 bits: last_avail_idx
> >   - Lower 16 bits: virtqueue index
> >
> >  Packed VQ
> >   - Upper 16 bits: 1-bit wrap counter & 15-bit last_avail_idx
> >   - Lower 16 bits: virtqueue index
> >
> > Also, due to the limitations of ioeventfd not being able to carry the
> > extra provided by the driver, ioeventfd is left disabled for any device=
s
> > using this feature.
> >
> > A significant aspect of this effort has been to maintain compatibility
> > across different backends. As such, the feature is offered by backend
> > devices only when supported, with fallback mechanisms where backend
> > support is absent.
> >
>
> Hi Wentao,
>

