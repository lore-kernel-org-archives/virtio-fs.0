Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.181
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795517756;
	b=DvVTJ0f8w4KNgGGiG/+LQUANIKMRFqSFu+uCpWT3kqM1Ug44ozy4CH2sL79YbBTXJLSf
	 9IfIG01CZTZRJHd9GIpCVjPVcnr9UO4LFDGHEfSEYfYtm0MoEn5JOnzuPuxGySJ0eCqsX
	 BGbVnqo/oNvhdPKz5qwi7WYXqyjtpYslYhqgFetCVvaJB8eREZ4j2sMTGuei/c136Ny5Q
	 6kFf1aTWfLnGTKXK10qbg6WQJ4S75Ybp7XixCnPFNW+4WTyvgnj3KkuKv96bPzeokJTIN
	 EOPoePzKhohjK8vrP0B9yqFMYhV1vqkC5qPquZJt9wwrNtaAlHbSz5CJ3hEUDTxu7og==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795517756;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=f7K+OWT5/zN97AWFOPBzuexi2dmP1ajwM95QsLerSkw=;
	b=rZQkYegR5ANjBE91jDLcie8veGmdTsOo2wysOeIsKFBQNm7igNLoSHLNVH4UIBBygs1U
	 5GoSiwLv+zM8plFa1uMlEqmu6LvIyYaz+SGHO2e0shQERDoEeVTrOSWj9u3JzQYLmIq6+
	 S9lpk/meuadjh+zhdNATW4uUSccdTn+bXEkDSeBFicn0PyKsStfQTXpHkL1f31LuJVB94
	 9O6PKgbkJKecqnM5PxcyRRgSVXBJzDbuNUifx2TH5qNDBKv/92mr427SAHasZIWb/Sda3
	 z6g8VcY4YSMW+WwgvBc1qywg0Z28sbWwE8MBoVcAK38396TXX6HhL+0QUIN0KcCYfUQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=szeredi.hu;
	spf=pass smtp.mailfrom=szeredi.hu;
	dkim=pass header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=aHyUg010;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.181
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3961E606A339
	for <virtio-fs@lists.linux.dev>; Tue, 24 Nov 2026 10:55:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3961E606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=aHyUg010
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-53639b8903bso53819381cf.0
        for <virtio-fs@lists.linux.dev>; Tue, 24 Nov 2026 02:55:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795517754; cv=none;
        d=google.com; s=arc-20260327;
        b=GbvukZ5uL1aKj40pdL7OQg2PPS+WW5W20T4K0HLqzipG+2A9fbF6vsR0OMS3OLinJg
         rsiQ9DVEyK4y9Ocmcs3meTzye0S8fXvyS16nkTBM1wXBgYOB7SkqjUhp+EUzTuKdkx6E
         nQTY78KyyBKbUkiWlhUXSGXCbisI9ocdmoNjgqPlY1LPMi1ElJBl28g1lJElkWFwUAfi
         l4Dor9Ou9uit9W9GWw8z01A9zlz85fiQY/tJ/GY2GzwAxJG3frsUQsFqtjWfsd1aAYpz
         mJzpNmsbEMoVrtXTpW0QwSKvde9wor3+t5oRQyTMhgq0SfCr2EzTbLPUJzmRTxldlpJw
         +VYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=f7K+OWT5/zN97AWFOPBzuexi2dmP1ajwM95QsLerSkw=;
        fh=nLRkLmLzIEAj6XRjs3BOnGs4z/faBiHXgQltyKz/ZpU=;
        b=AP6xtRMPwsPE98vvrqAeF1V+UzOWgtbQvSwssXVLgyYJHhjE9HSJKTCQ6ruQUCWnXu
         Pa7KVWAKMftXk7V2dR17OzCHTloADxOWxMKmGtxC2zTkbaOOJQ3kvFI8181PqTZLwm4+
         C0/9F1EiHxYXR2rjbAzsCBAkuckWdAQdprx8GUhn7qPd10eov6rTByRaS2KkMdn1gYzB
         VN3vIMQi8JNfoIUIpl86+NdYYX7qAt9Zx0Rw534RkOVrbmu2XYTcos/5mKJlqV1nO7ow
         BJS8Bu/3gxatk4Ut/KvREIRQD0aGGMZ5sT0NmfW5z7vgtVjJ/z9X2Qo8Rxb4yf1fx6Dx
         0a0g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1795517754; x=1796122554; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f7K+OWT5/zN97AWFOPBzuexi2dmP1ajwM95QsLerSkw=;
        b=aHyUg010Fpa30tqfBUn1Gih+DTOzaKalA8zN1XBuoXqQay7t9Nf0/FQfF7TKBld6Na
         H+oZLrT9EDYL/2VEaZ6JqGj/vg4ixQZUUDwvM+f8N57hPXmm5vlgshvUvsJyk5JKHf6B
         iEel12hsckPmiRCfJSNtL4IHY5Bc7QyOmEMdo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795517754; x=1796122554;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=f7K+OWT5/zN97AWFOPBzuexi2dmP1ajwM95QsLerSkw=;
        b=IZS+VFTUSqlWndyov4/MvicpDyA98UcX+PmqUE/1bXkyL9NQTt18iB0ZX8x+imr8GV
         B2nfpTQS8ds7SSDleOQP+iGeJoGEq/k0OnbieACH10KGUpSpOGvH4T+lI7EhHfDi0jw/
         4ma//B07GBUq7yW8wlPchcjoMVXlUBmsPnucBPd2BqPRmcO9NkZlm5hNOtTkdt0YF/ZA
         XiwHV+rCsHD2RZV0+wfyW8bxfXFldjMUKrBLvqW8Qf5+9Gcvkij6jHwhCk41qg0QWN/I
         t1oK8l8sVTIatU/zFxr8vswV5bk1eVURCw8Upij+R+OCdiEdlEQolMZbNSKv2KpyZHCn
         A6AQ==
X-Forwarded-Encrypted: i=1; AL+hErHIBHrkdE6j5p6YIMFDDPgxGPW4fWrZry1rBYlDh+hAanLB6U2IyF1LNduBUGmkAPubshcJCvM4Bds=@lists.linux.dev
X-Gm-Message-State: APuU4Z8vBi6cYeCnC8CikLhjDQojelWtyXPkV80+z9RvdjfHjylpK07y
	6wuEE2rlV7H7CVEBcK0U2naCR0wp6mNKtQL77WbQMGxsJTqnBG4r5WpRL+AS1i9R4VW34S0QWwk
	0FhdTRABh2FiyqCgi10q5jNUpkaoMRZr8ph7AV4AoDw==
X-Gm-Gg: AZFdTZcvkKjoOcVx6PooPJ2gZ9o8tqKy4RZ+6Qwrsed8S0/2m8EMUYvgykJ3j6sgev5
	4ooUSk2Ty079qE5+r+NRYe1NHuvM8Qp1lC8DLSeCWE6oHrp2U9wquZBY90/Pr5WKztXgCj/W6LU
	b+mf9xbbwyEYsbcFyEPw+EYmzB6lNTcZo/CKi6nkzZIZtVm2mfdukxvwBnWV18oEbUSefWF+3nS
	xMDgHtC7I3Tq/a4C4pfQCA1VI4hEvji84QQj7aGRmtdbacShTuqooVtvdIyYmQMjZsot2mySe3X
	QR/SRSWpbV6PfWdOnlQDKJyF+/QG08ZBLW8fdk2xmTKuODuczc5dN64HvUU6pi4dLSFVr3GV8J3
	engZxk+45Xyos7zbLC6zlSwoi6eSHWAm8BS85/EVaS6wplUxkFrD/F5NUtQGVliNkJA==
X-Received: by 2002:ac8:5d04:0:b0:54f:50e7:6d69 with SMTP id
 d75a77b69052e-55d6fbfc728mr265521821cf.1.1795517753910; Tue, 24 Nov 2026
 02:55:53 -0800 (PST)
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Post: <mailto:virtio-fs@lists.linux.dev>
List-Help: <mailto:virtio-fs+help@lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
List-Owner: <mailto:virtio-fs+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6c6cea56-1af2-4a37-b081-83244d5e09cd@kylinos.cn> <20261123063609.82014-1-q.h.hack.winter@gmail.com>
In-Reply-To: <20261123063609.82014-1-q.h.hack.winter@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 24 Nov 2026 11:55:42 +0100
X-Gm-Features: Aa3M54r7eAE856Qdq3AsqWMUaoTcqR2q2T6lCT40Ts3802VL14VNSmjueVArc1E
Message-ID: <CAJfpeguspTb0w7DK8-4ALHMcHbH0+Qs8nfh78mOJRwN3VQcAdg@mail.gmail.com>
Subject: Re: [PATCH v5] fuse: virtio-fs: fix lost wakeup on a full virtqueue
To: Qihang <q.h.hack.winter@gmail.com>
Cc: Li Wang <liwang@kylinos.cn>, German Maglione <gmaglione@redhat.com>, 
	Vivek Goyal <vgoyal@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Eugenio Perez <eperezma@redhat.com>, virtualization@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtio-fs@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, 23 Nov 2026 at 07:36, Qihang <q.h.hack.winter@gmail.com> wrote:

> On -ENOSPC, add the request to queued_reqs before releasing fsvq->lock,
> as send_forget_request() does.  This prevents
> virtio_fs_requests_done_work() from checking queued_reqs between the
> failed submission and the insertion.  Both callers can then return
> immediately on -ENOSPC.

Applied, thanks.

Miklos
