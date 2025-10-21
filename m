Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA9B1DDDD
	for <virtio-fs@lists.linux.dev>; Tue, 21 Oct 2025 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761060827; cv=none; b=KNv692V7y65YGN3GslgfrNUJPV64z1m9cOWowEMge4MUbeAvjZZrDD/So2ruANaKNG289VnNRtPHCjoQIF4sUUvj8edGXV95SEKrFVupJW7uExCV/JGEwSqdkwZFmLnvWL6qahDuLfOXmjLdrRePaTxDjDEhcZdWrqxwIR6Tajc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761060827; c=relaxed/simple;
	bh=88fQYBvslhBbks/dJpliT2wH7xkm8ak270+QhoY/+/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gfV1j6mf/kFXkaWPsP0b/g0pxtdwaw9Y8cgrNXXm0J1lp6ubfwxWOb7Shrk2cfqqDyGYE/inz+B4Gz+vXJ67L6UE+0XkWwxumbO1NprG2lzgbxQd9SpNYLAlyGasV3df7/xg0bWuGT8yz3sgS6mKhFqANndbxsy+T24bkqmaeP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ENXJP/Mk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ENXJP/Mk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761060824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3cdsfW6EeBnamcgWBUdM1pu88AGzMF8ezjONmhdoV2w=;
	b=ENXJP/MkgzYbjne8CY+HFVgqzg0cFhidVdz1mvWrCCeivCo4AlEo3JVaCcdTJJ958nBzry
	WT7y2i+SEdBV/3zbwZseSuy+/jsaQ+6w6EpsNqdkdPCBR9sbGZ+p016Sblw/FKrFgSOHEI
	FuzD1dEyUwu/IST6USesGlZdj2Az1ug=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-ol4wsHEsM9KUye0FcznLDA-1; Tue, 21 Oct 2025 11:33:42 -0400
X-MC-Unique: ol4wsHEsM9KUye0FcznLDA-1
X-Mimecast-MFC-AGG-ID: ol4wsHEsM9KUye0FcznLDA_1761060821
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-471168953bdso41423205e9.1
        for <virtio-fs@lists.linux.dev>; Tue, 21 Oct 2025 08:33:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761060821; x=1761665621;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3cdsfW6EeBnamcgWBUdM1pu88AGzMF8ezjONmhdoV2w=;
        b=cXG9N1S66nbxHoaL7LrW2wOoBD6CiL5SfxAfLC8k1WnO9AgocUttUT3lz7cwjitZM7
         TESX32vdQ6eKS/Eq9fFPUUCrx4KkWrrlkOFlHgTAgHIIpeF2aBN1nmch+3zonxZdGP1y
         Q1OmGlPCvAeFVe16ZWYjfAfmW9uNLIcWsWOUwrS79k8pEZ5KmhNci3L5Qttj8coE0cwK
         tEpJ1vNwgQ0tikiiGqsHsZPnXymWj6nEGNzxjrlbNVAh1TwXGmOpTtRm4N2j2dD00YBD
         bc4Rqt347RMTZp1ebi5fhJja+2z4FrAYyTkda3dGQocQ9eEf+ZHVRbpA2NW/TPL5f+qP
         tCYg==
X-Forwarded-Encrypted: i=1; AJvYcCVhb4a4FTrAg/emLkFHMz6gzvZ5pjI+e6J3e6IrYO2ArwPvwEUbk4S9ITRnzwmx4Yy/XovRvZNzepc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyivgrKoQyWoHPDGzOqwrJ5Y+e1YzS3gDAh6ejXlW+Q70P6vFU
	b5tN86DrpvIy7+ivjxCoVnoCUORQI9nHzXlAXWy1KIKxW490Dl+QydrIUQ9lo24O9D82CCTDocP
	GFjg+uxO8XbrcP78M6UM8O+JmXQIVz9yi5Eq51CZnHcGauFpDpV1PzHouJQv1HQ==
X-Gm-Gg: ASbGncvFBGJSrWymz27e/tOa+60h1+k5vBMww2sDy9ylGOTjyixl6UDQjN2so+rW60X
	L6q8OVITW/iNNw7Q0TQwrjpnMTU1tQEoA8d7/z/czqtyaUSZaQMYGLP8UE8vCK1eCzKsrehHzE6
	e9R7a/ORTiwiI41ODv63VaF2eybgie8xmvMqNReTpYUVfRDYVaVqlmenl+QHxUcr5G2R7KllchG
	Cor9tWq2dCiahT4XTrydX53nr2cbNBN5DaFCAfi6EqdouAd6qIoqpTzpP5bgdWOzyG6nykIvu12
	XFmxHTkR2FEP11i/3XxWFrvPOH69a73KTcjxPki/Vhobmmwq8cpCZQ+j36PCDbYsISyygos1h2P
	6tHkhofNm+VWTAkCDquAozvMfieYp3EhcoEA5ewV3/Sx0X3XjDwLk627tpD2sZlwy0CB1vSjVrb
	Qfbw==
X-Received: by 2002:a05:600c:6306:b0:46e:711c:efe9 with SMTP id 5b1f17b1804b1-475c3fda615mr391915e9.13.1761060821512;
        Tue, 21 Oct 2025 08:33:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGV0hTec/tsruMD5xvsXhR4WbQsi/vpqU0IBFAMSoLN1HWd3S5vgwxQztGKB+0XOrizaVK6Mg==
X-Received: by 2002:a05:600c:6306:b0:46e:711c:efe9 with SMTP id 5b1f17b1804b1-475c3fda615mr391435e9.13.1761060821076;
        Tue, 21 Oct 2025 08:33:41 -0700 (PDT)
Received: from [192.168.10.27] ([151.61.22.175])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47114423862sm289444305e9.1.2025.10.21.08.33.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:33:40 -0700 (PDT)
Message-ID: <61198e34-d7cf-43e6-b6d2-15cc423f5fd7@redhat.com>
Date: Tue, 21 Oct 2025 17:33:35 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] char: rename CharBackend->CharFrontend
To: =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: "Dr. David Alan Gilbert" <dave@treblig.org>,
 Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org,
 "Michael S. Tsirkin" <mst@redhat.com>,
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
 <f764e4cf-d134-4c4d-a313-a5b7dd6620d0@linaro.org>
 <CAJ+F1CKG1G=5o+bDBXmLm6ywWDD19z1OFBwQQnDMxMFytFQ2SQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <CAJ+F1CKG1G=5o+bDBXmLm6ywWDD19z1OFBwQQnDMxMFytFQ2SQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: f16WFdmdA5FeA7sZszlvkCecQcWRP6oHUy8K9QzTBmY_1761060821
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/21/25 16:27, Marc-André Lureau wrote:
>>>>> I always thought the "frontend" was the device the guest
>>>>> saw (the 16650 UART or whatever). invocation.html has bits
>>>>> talking about "virtio hvc console frontend device" which
>>>>> seem like they also use that terminology.>>
>> Isn't it
>>
>> - backend -> host adapter
>> - frontend -> implementation used by guest

The frontend is whatever talks to the backend.  From QEMU's point of 
view it's the CharFrontend (which consists of a Chardev*, i.e. the 
backend, and some data identifying a specific frontend), from the user 
it could be /dev/hvc0 or whatever.

> Sort of, but I think it's too restrictive to name them after "host"
> and "guest", as they also have different purposes than strictly VM
> components/side usage.
> 
> I believe talking about backend and frontend is usually the preferred
> convention.
Yes, I agree.

Paolo

