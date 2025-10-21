Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D4522FDFF
	for <virtio-fs@lists.linux.dev>; Tue, 21 Oct 2025 14:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761056590; cv=none; b=DqAecq7kSS05GTFAfHUJ6kCZ9C2L5T/sG3pRQPvPa5M3zxPyp1gUksxaob6CFGT4rUV7ANyMnSrDruKQoknYkr7HuVUh0U2KU04bsW+UA39ES7gLJ353UcW/Yr35f7HRWOC+68uzk+ovf6cR0Ie1v5p9WWflzjKu73WFS+fy9M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761056590; c=relaxed/simple;
	bh=j5FNKTIb90XI1/116x7LUM9yV11xv+mRdMhYDzLPti4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fggIpJpIGd/3exUYZPXLLInVNX3El8U00uaXPT6Ltq0G8AdH/vMPAtnNTwE+yMZNAnbHoJC8ptU9v7IeC4GagzeC+m3xbaNKi8QzfqF6atGm3RjNw13Nxsy0SS7dtnJgqqF/Hmen9obPHjHK5/LjWqs6S0gNt9HqPZWn0tScdTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WKbQTv1+; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WKbQTv1+"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e6a6a5e42so31074495e9.0
        for <virtio-fs@lists.linux.dev>; Tue, 21 Oct 2025 07:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761056587; x=1761661387; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lujhmAKv4qj3zqFSyJwljj3Hbz9BgNvxk1iEvf3EvUc=;
        b=WKbQTv1+z6LVe/R0T7VNqJpj14/0jo5aI+vLso16p19sYQo6UWGqQBsnfeHCcfyeFm
         pwswAxGmkVY1MvIUmPM4SV6zbYKsJwBrLOo6P3m0KHiCcpsvHU3y8XTd3rzmyoV5OXfw
         z3Mt5VjDJhnnezflWvh6UbF0shWHC6xUzXyOZAu2Mo8D7GIH+NA+M3Frn2Uau1jdMKUQ
         fTTjvRaHIAiQz3bXlFnF1mk4QEqaNSEvfDjmiSrfCaGktpnOqIapVJq6OftITfkkvPt1
         KEBizbl23oV2JwJs30H0R1Ix+ZuPfgl06IlCCiXmPf+TwPdoIXUTGlaKg9cy+9pIpgFX
         XHNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761056587; x=1761661387;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lujhmAKv4qj3zqFSyJwljj3Hbz9BgNvxk1iEvf3EvUc=;
        b=k/83Pn82uCq1em77iM5k+Q2o/MfdYb/53QKTESNmLZsxxOyOuYRdu9lg1HTpzAY1YN
         DTExxIHm2pmRfiA+eTuRixoJloIOdw8Ib+Err4YYlr1xWKgyGGKdCdO7gRsdzgNPnYy3
         uixODOnnBC+HD4XPsifE9HsRSfaUfj2zs2b8W6EMParjlnsOZxndZtxiLcA2hJ3Eq636
         8R/XekDWYaKdTmsgpbB5WlNCwg2eT2WPKiXS0eTk5Ex9zDgSyRHzg7+nRPAM27R8yx/L
         /Jivn1A+UJ5T99QMfp3VCQoX0dtzIXlF7d7Fg+3Hov91vGsuZLpTlVOtA+SC4iQFVg15
         wzxw==
X-Forwarded-Encrypted: i=1; AJvYcCU4R+cEU5XGlMDa09otbeU7kdZOogOIZYVc71AxFXn0NuzbpZdTx/LIsdJs5TJjk/uct3Ip+KTJGKw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxy/3zpZdqWgwfdAm2p/lU3BQKZFnQgfTejO9e7JuXdPWrZyk04
	4NcpsSWDG+gMC9ilcIYhUQowp5Jjbvhmxrv+vTPy3qfEto2Z2ru1gjVvoLbxUEhVN34=
X-Gm-Gg: ASbGncvAY48Id+izEIYkWYwCVXEtzLs+BkX0qu4MzNzSYJkbZH7Rmljx88GfwgC+2Nz
	nCXuSdi3GOuQ6Mf0XDCFFjAyCC29irnn/Q/41aqqAO2lny40r/XY8h4jY/XcycvOETLP9KVsBG0
	/PJU5N4mTLmgQiJwKJVHsW97fVs4cijVtjkvlaSr5esWo5gxB+7jg4qekmhpB08Wntpit+V9Xbs
	9XqwlDDRGmuPJ5QLdYu64l5+1oh893TqNRmRUpU58Ww9j9/CI45bVCXrNXYx0Xh2Tia3o723lic
	Kdv+eSVrLKJ3seskKMlD/Si3CcNtpIeFgV5iNrnI45hm3/EPKU+BqgV28Fwo2Z5cmUVfQzOwZr1
	2F1P3BkVFO6nQOr07Bjbe+OCPAtPnuJmNYaXe+EbhmTtStRC/DTiAfjQlUf/WpDP4QoSKubXJiU
	cEV6CuknyfNe8q2OwHv2javb8QW/G3W8Puf7OHeEPVgxd/x0u7u7vuXQ==
X-Google-Smtp-Source: AGHT+IGpNQZriF03nrUdfXcsadeGS/wWcOcHtxrbwixqf2QWNQLelRmKaF2GA7cZAx1ECPorWCWExA==
X-Received: by 2002:a05:600c:820b:b0:46e:1fc2:f9ac with SMTP id 5b1f17b1804b1-4711787dc76mr114596775e9.10.1761056586906;
        Tue, 21 Oct 2025 07:23:06 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00cdf6csm20473949f8f.43.2025.10.21.07.23.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 07:23:05 -0700 (PDT)
Message-ID: <f764e4cf-d134-4c4d-a313-a5b7dd6620d0@linaro.org>
Date: Tue, 21 Oct 2025 16:23:03 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] char: rename CharBackend->CharFrontend
Content-Language: en-US
To: =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@gmail.com>,
 "Dr. David Alan Gilbert" <dave@treblig.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org,
 pbonzini@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 Zhenwei Pi <pizhenwei@bytedance.com>, Laurent Vivier <lvivier@redhat.com>,
 Amit Shah <amit@kernel.org>, Stefan Berger <stefanb@linux.vnet.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Igor Mitsyanko <i.mitsyanko@gmail.com>, =?UTF-8?Q?Cl=C3=A9ment_Chigot?=
 <chigot@adacore.com>, Frederic Konrad <konrad.frederic@yahoo.fr>,
 Alberto Garcia <berto@igalia.com>, Thomas Huth <huth@tuxfamily.org>,
 Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Jason Herne <jjherne@linux.ibm.com>,
 Yoshinori Sato <yoshinori.sato@nifty.com>,
 Magnus Damm <magnus.damm@gmail.com>, Nicholas Piggin <npiggin@gmail.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 "Collin L. Walling" <walling@linux.ibm.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Alistair Francis <alistair@alistair23.me>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Corey Minyard <minyard@acm.org>,
 Paul Burton <paulburton@kernel.org>, Aleksandar Rikalo <arikalo@gmail.com>,
 Aurelien Jarno <aurelien@aurel32.net>, Palmer Dabbelt <palmer@dabbelt.com>,
 Weiwei Li <liwei1518@gmail.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Samuel Thibault <samuel.thibault@ens-lyon.org>,
 Michael Rolnik <mrolnik@gmail.com>, Antony Pavlov <antonynpavlov@gmail.com>,
 Joel Stanley <joel@jms.id.au>, Vijai Kumar K <vijai@behindbytes.com>,
 Samuel Tardieu <sam@rfc1149.net>, Gustavo Romero
 <gustavo.romero@linaro.org>, Raphael Norwitz <raphael@enfabrica.net>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 "reviewer:vhost-user-scmi" <mzamazal@redhat.com>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>,
 Fabiano Rosas <farosas@suse.de>, Markus Armbruster <armbru@redhat.com>,
 Zhang Chen <zhangckid@gmail.com>, Li Zhijian <lizhijian@fujitsu.com>,
 Jason Wang <jasowang@redhat.com>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 Helge Deller <deller@gmx.de>, Max Filippov <jcmvbkbc@gmail.com>,
 Lukas Straub <lukasstraub2@web.de>,
 "open list:Sharp SL-5500 Co..." <qemu-arm@nongnu.org>,
 "open list:S390 SCLP-backed..." <qemu-s390x@nongnu.org>,
 "open list:sPAPR (pseries)" <qemu-ppc@nongnu.org>,
 "open list:X86 Xen CPUs" <xen-devel@lists.xenproject.org>,
 "open list:RISC-V TCG CPUs" <qemu-riscv@nongnu.org>,
 "open list:virtiofs" <virtio-fs@lists.linux.dev>,
 "open list:Rust-related patc..." <qemu-rust@nongnu.org>
References: <20251021122533.721467-1-marcandre.lureau@redhat.com>
 <CAFEAcA-jPE_onLYLMxgcAOB7dWRXOLJrWcGPnR0NUdjYytPDVA@mail.gmail.com>
 <aPePcTKl6s4FoLCL@gallifrey>
 <CAJ+F1C+bGKtY6nf3LCXrwhZ2aEdu2npXJ9FapmsqgX0uLL5TUw@mail.gmail.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CAJ+F1C+bGKtY6nf3LCXrwhZ2aEdu2npXJ9FapmsqgX0uLL5TUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/10/25 15:58, Marc-André Lureau wrote:
> Hi
> 
> On Tue, Oct 21, 2025 at 5:52 PM Dr. David Alan Gilbert <dave@treblig.org> wrote:
>>
>> * Peter Maydell (peter.maydell@linaro.org) wrote:
>>> Marc-André Lureau <marcandre.lureau@redhat.com> wrote:
>>>> The actual backend is "Chardev", CharBackend is the frontend side of it,
>>>> let's rename it for readability.
>>>
>>> I always thought the "frontend" was the device the guest
>>> saw (the 16650 UART or whatever). invocation.html has bits
>>> talking about "virtio hvc console frontend device" which
>>> seem like they also use that terminology.
>>>
>>> If we want to clean up the naming it might be helpful to have
>>> a comment somewhere documenting the different components and
>>> what names we give them and how they fit together (or even
>>> better, something in docs/devel/...)
>>
>> Or something more descriptive like 'CharGuestSide'
> 
> If we are talking about the Chardev frontend or user, that's too
> restrictive. We have generic stream handling code (think
> mux/hub/tests/client/server etc) that do not fit that usage naming.

Isn't it

- backend -> host adapter
- frontend -> implementation used by guest

?
