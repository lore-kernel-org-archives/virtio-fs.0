Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59692BF002
	for <virtio-fs@lists.linux.dev>; Tue, 21 Oct 2025 12:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761051204; cv=none; b=aFlhZyhne7y4oyd++2Bh0CX5/q5BUkDvdJQiWbW2cc2pGNioPWrOBoN4cRLpf0ixaYktwwVB4EmO75H98cQuO1z2XqGuCvwhobnfVh/9izf3Q7bgDwL9wnW10WHNHXTavGgLDHoCmNGT3NtVCVMZB8ulNOEeaH7vCjP6mXmwyNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761051204; c=relaxed/simple;
	bh=IuSNCsRv/59+EAgZl2384UmefgwetvdfFm3jSW4yRDA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lHcDMH5Gm01IqKTwoy6104819gwzn5ZFmXnENlIv++wY6UvqGJYyeDgTq4SmL4VeKysytrMRuyxg24eKyoNPdRHDnrsTMrjF55ZFRwIoG9sjHCIMN46WnldxDBTVdFZFlsOqPyoYm16bgv6lqCo8vQ6+jNYTYGddAKL8rqo193o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uvvB3oHR; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uvvB3oHR"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-7832691f86cso72138267b3.1
        for <virtio-fs@lists.linux.dev>; Tue, 21 Oct 2025 05:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761051201; x=1761656001; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IuSNCsRv/59+EAgZl2384UmefgwetvdfFm3jSW4yRDA=;
        b=uvvB3oHRpe2Y6ds0+JFDBjUq1fEwQijnkTm43KgmndsHW/2R/q/k20ngTGx5rNvXX9
         1ECqwbDJajVSAiyclrLfEtJYUwVAzjjMe0ezWNdl9r/SZUpIys3OtP3THo8x4DQFC4Vx
         TbRAhGqyB0QClY2Y1wi7K1dMWygdrPjKovJJVGKv0qnlY2j32VVARJ8w4JJ4LJpBHV+b
         ddyV+2PtNMknPpX3RwqJZnOm4KfCt3jTezXo2ttndivd/hjcOlJy8WG7LvthD9ermp3d
         6q8SMwjS0A7v/3IBFeNf2O5qolrUQs+bCpePcEj0d+YTqB++9/6q1Fh5+FhuJxgBpeWO
         +XUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051201; x=1761656001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IuSNCsRv/59+EAgZl2384UmefgwetvdfFm3jSW4yRDA=;
        b=sRxF/v6gCEmRUf68eWdytBHYDaz6ryO5i8SQjHQ+RJioCS2X0J1dM2xBsWHJi8ws04
         1htML2f3PS107I9WMDHTV+rRQcgPs3NqMVKAowy3R8OJTjee1Be4ADgXZWk4vrSNd8vf
         k5LBkCDV6L4xVkrRTjnMZ+C3ZskSf+98UB8acuHVv3//aIvp93ACmgyXq8cq8y1zjFCn
         zTjPNk74NsVohiidV7H+r9iduGvCmeGCEhgVjXAtJocW5QN0jEKYKLeU+J9I2EkhjLWT
         BmJ4ttxl4pIAdIF44NOPeU64Aq3FT1y0YLx5Hl9GpJSh+lfbpBtYn9spKb6HPfQ36yYQ
         kTMA==
X-Forwarded-Encrypted: i=1; AJvYcCXbZi+meY/t0xN9zGqDNlLYtfXo24tuolbc3H+vJlw8Co9GYDirZLU2csqnRGTnOeetUgiWMUF0eWQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxcN6urBrD5ElX9Cuslxuf9PS/6bkXDlkDi+1Q7Hlwkwk0ygsR+
	nV09L3r4dj4AkZ8Bd1IJzRoqWYy+qmSE/Dw3hMoFypKgE12+UiC4k3On8bs1Pl1N2h6DPORPcmK
	HVJGZEJlzCUqAHfAQwi5pnIQ9vg4za7eSUMOmCg9sjQ==
X-Gm-Gg: ASbGncsMYtapiWAH5obt5aBbfrfStX+adrWTkcBRlrJNLETCd82aapskOQaxcfJ4hYl
	6sgoFYgClawB5d6+5qVnSB3mQyfavf2KTfhhcH73FV2LQQ3jvx3NVg1vJtI5MjHYMffVAYrHsD3
	Oxoe1ZKTkEoRAy/xUS93vy88e1wTKlv5YZ2cVgTeM1/lYVPPyBFxosWb8yQKT75NShr/CqlBqhO
	/O7Kg7AqQTrp+z+Xzd4TjQnA8SKddCnmQ01KAogOJZV5ClCZV2IYj5WUa3HlQ/SkHo5Ag754hMi
	4tv/IQQ=
X-Google-Smtp-Source: AGHT+IFpbT82ve3LXltYZEPsfJS+RyLmbXt+5DVAMiKWeQCDlh+pMWALlMmxIYO912MM0kwsJVP4r1RcRcCjaeA4YeU=
X-Received: by 2002:a53:acd9:0:10b0:63d:7ac:b991 with SMTP id
 956f58d0204a3-63e16179374mr11700457d50.5.1761051201041; Tue, 21 Oct 2025
 05:53:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251021122533.721467-1-marcandre.lureau@redhat.com>
In-Reply-To: <20251021122533.721467-1-marcandre.lureau@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 21 Oct 2025 13:53:09 +0100
X-Gm-Features: AS18NWCp0ty09wq1HmsCT7-iy0cpel_3YH3JRfs8VpJn1hbNoYoCwcqrR0HZzqM
Message-ID: <CAFEAcA-jPE_onLYLMxgcAOB7dWRXOLJrWcGPnR0NUdjYytPDVA@mail.gmail.com>
Subject: Re: [PATCH] char: rename CharBackend->CharFrontend
To: marcandre.lureau@redhat.com
Cc: qemu-devel@nongnu.org, pbonzini@redhat.com, 
	"Michael S. Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	"Gonglei (Arei)" <arei.gonglei@huawei.com>, Zhenwei Pi <pizhenwei@bytedance.com>, 
	Laurent Vivier <lvivier@redhat.com>, Amit Shah <amit@kernel.org>, 
	Stefan Berger <stefanb@linux.vnet.ibm.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Igor Mitsyanko <i.mitsyanko@gmail.com>, =?UTF-8?Q?Cl=C3=A9ment_Chigot?= <chigot@adacore.com>, 
	Frederic Konrad <konrad.frederic@yahoo.fr>, Alberto Garcia <berto@igalia.com>, 
	Thomas Huth <huth@tuxfamily.org>, Halil Pasic <pasic@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>, 
	Yoshinori Sato <yoshinori.sato@nifty.com>, Magnus Damm <magnus.damm@gmail.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Harsh Prateek Bora <harshpb@linux.ibm.com>, 
	"Collin L. Walling" <walling@linux.ibm.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>, 
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>, Alistair Francis <alistair@alistair23.me>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Corey Minyard <minyard@acm.org>, 
	Paul Burton <paulburton@kernel.org>, Aleksandar Rikalo <arikalo@gmail.com>, 
	Aurelien Jarno <aurelien@aurel32.net>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Weiwei Li <liwei1518@gmail.com>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, 
	Samuel Thibault <samuel.thibault@ens-lyon.org>, Michael Rolnik <mrolnik@gmail.com>, 
	Antony Pavlov <antonynpavlov@gmail.com>, Joel Stanley <joel@jms.id.au>, 
	Vijai Kumar K <vijai@behindbytes.com>, Samuel Tardieu <sam@rfc1149.net>, 
	Gustavo Romero <gustavo.romero@linaro.org>, Raphael Norwitz <raphael@enfabrica.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "reviewer:vhost-user-scmi" <mzamazal@redhat.com>, 
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, Fabiano Rosas <farosas@suse.de>, 
	Markus Armbruster <armbru@redhat.com>, "Dr. David Alan Gilbert" <dave@treblig.org>, Zhang Chen <zhangckid@gmail.com>, 
	Li Zhijian <lizhijian@fujitsu.com>, Jason Wang <jasowang@redhat.com>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, 
	Richard Henderson <richard.henderson@linaro.org>, Helge Deller <deller@gmx.de>, 
	Max Filippov <jcmvbkbc@gmail.com>, Lukas Straub <lukasstraub2@web.de>, 
	"open list:Sharp SL-5500 Co..." <qemu-arm@nongnu.org>, 
	"open list:S390 SCLP-backed..." <qemu-s390x@nongnu.org>, "open list:sPAPR (pseries)" <qemu-ppc@nongnu.org>, 
	"open list:X86 Xen CPUs" <xen-devel@lists.xenproject.org>, 
	"open list:RISC-V TCG CPUs" <qemu-riscv@nongnu.org>, "open list:virtiofs" <virtio-fs@lists.linux.dev>, 
	"open list:Rust-related patc..." <qemu-rust@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com> wrote:
> The actual backend is "Chardev", CharBackend is the frontend side of it,
> let's rename it for readability.

I always thought the "frontend" was the device the guest
saw (the 16650 UART or whatever). invocation.html has bits
talking about "virtio hvc console frontend device" which
seem like they also use that terminology.

If we want to clean up the naming it might be helpful to have
a comment somewhere documenting the different components and
what names we give them and how they fit together (or even
better, something in docs/devel/...)

thanks
-- PMM
