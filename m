Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358F3318EE1
	for <virtio-fs@lists.linux.dev>; Sat, 25 Jul 2026 05:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784957583; cv=none; b=R1MA6kzAg//9/bNdC+W7XA4rUr6cVQLeHr4vcaN3ZErJppRhlFcCh2RmUd0ifs/MWMC9XlZmR9kTXEKpSVsBPf2bbrDrWPotAwn7TaFtqQutyP/EM5R5QTy/Ch1JnpEJh5Py/intU7tnIRqAotZ7QSDATTw914N3zNOpryWERkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784957583; c=relaxed/simple;
	bh=2sa+2WFNvMavsE0VFdye5c90rqnztXR+oJyPl2xZLXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=lPr+Yug4wgVd2Hf1C1zOnfsDV8Z8YHr/hNCW7PmnfbdW74S0V2Iy3AgeEQ1X2G1lv5LeT3jqfKFYtJ44TvMm7D3T0HnnKl/bj3bFqZ2Pv4+BL2vPooqqOe+26ckKbCc+zk8pmR7rIFz/Loqw7Tgt+58jPoSmGBp7I28Ys4jxpgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XDzDbZeP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XDzDbZeP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784957579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t650BNQ4TcDAv5114g+Y9Qf6j6gJ5cCULhZu4PXheWY=;
	b=XDzDbZePMqo2huUsJPfS9WctZpaaaFwj1MwUebaykr8kHZ6gDdXa6afw4xmBLkICMIo1CZ
	PYlpaN2Jv3Xs8kdjQF1JbrZBd06bQ3JT/zEwNoFspmir6pw62v4iHfu1grySqVLfCijxyu
	scdD2ewcIKEqvuWNz6kMq2IH0xfRT4g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-qkgqBcS5NXuvvz-S5zA25g-1; Sat, 25 Jul 2026 01:32:56 -0400
X-MC-Unique: qkgqBcS5NXuvvz-S5zA25g-1
X-Mimecast-MFC-AGG-ID: qkgqBcS5NXuvvz-S5zA25g_1784957575
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4954fe32d6eso5586615e9.1
        for <virtio-fs@lists.linux.dev>; Fri, 24 Jul 2026 22:32:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784957575; x=1785562375;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t650BNQ4TcDAv5114g+Y9Qf6j6gJ5cCULhZu4PXheWY=;
        b=tWAJStHKbhqX0pzE8Tjhn+0uQECxcXCnU4gun+M4oVd14cMsnE8q7ihqPBSQ/lWKO1
         y1nnh5TF+Lwv30PZPBL1f1Q8gIJynUjih5p0MbeKhg2RhFHUrhi+6dwlt8zdY9PoGMTF
         2hVcyaDMFtrlCXTgNIZ0gB/joDymC43k3NcvFjQH0gfx5GoLRULCVeQ291dc4anytii5
         0LWF0+j3HPoyqdGstofhOLSSq9zBmaR/fjwEsP8kzklv/Voh8s2xpY7avgJiWsKmlM/Q
         cZgE7GuFu+lxsWzfhWpQ39iVMh7WRFOQXDCpsBfz8uEacJHC7MxPqXZFQOTor+V6ZfrI
         1pNQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro5dS3eU2VSNtKykUWEHEeBGwp61bpQTpOKWXZC0aVUiYlT58d/dheoeiS2V99FAlcIGtoDb0pFVjo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4bBYT0J+rXxro/BA5qQo+kX07+wxj6tAmILGehefhXZQcnZNq
	RTJSl8gEQKDMdDTs1kBz5cF31gKrmQW1JH2KtuU+wdqRufbFndYC/sYifRkiKZbrBBiuXncadCI
	HlvzY/ZqxGeYs2qei8VrgE/13OX4Bn874NczLoyjZF1+6Cowgmn96evHs/M6PHw==
X-Gm-Gg: AR+sD11DQNp+hAuR6Yz/LOWwq9BCBsdVsx4Sc/P2FQekrfm/lCuXGhB3+uWHxkp7Q+Y
	/242Z9Ql06xtTaY+mq6fZz1mwhTe0isqsDoELCqnZYg6T6ga+s0Qi7y1J3bqfm1ACB3D+iXBZVp
	/tz/1auHof05pGaFMVirZ+vOtPJbMCr9Giv4N/mULgZdkaFXgLPceLL4SqbDI8Zrowbp6ncty4T
	VQbhXSYQVxNJ+STnwoCFKFe7fn8UZEuPuGlsDunIOt4zO0RJSThp/lWqufgu2HmQSCPXU0/CIuT
	iwBRpBnjv5MjbxyR4Ssl70+tsB1Dzotvq4MxuGSAPxeaZs4QKJqCbaaxlO6dBLCcX7moGtmss2R
	8ymbz8fzRbPpgqWzYgznYH4Td8FE0yTE=
X-Received: by 2002:a05:600c:1991:b0:495:4bf3:2150 with SMTP id 5b1f17b1804b1-496b6a232d1mr6244075e9.8.1784957574705;
        Fri, 24 Jul 2026 22:32:54 -0700 (PDT)
X-Received: by 2002:a05:600c:1991:b0:495:4bf3:2150 with SMTP id 5b1f17b1804b1-496b6a232d1mr6243835e9.8.1784957574247;
        Fri, 24 Jul 2026 22:32:54 -0700 (PDT)
Received: from redhat.com (bzq-79-177-145-168.red.bezeqint.net. [79.177.145.168])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4f33b73sm38681325e9.14.2026.07.24.22.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 22:32:53 -0700 (PDT)
Date: Sat, 25 Jul 2026 01:32:49 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Cc: qemu-devel@nongnu.org, Jason Wang <jasowangio@gmail.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>, virtio-fs@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	qemu-block@nongnu.org, Raphael Norwitz <rnorwitz@nvidia.com>,
	Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Subject: Re: [PATCH v4 0/6] vhost-user-blk: fix compatibility with older qemu
 versions
Message-ID: <20260725011415-mutt-send-email-mst@kernel.org>
References: <20260702091023.3306378-1-dtalexundeer@yandex-team.ru>
 <d95a174d-83ec-4bc0-ac5f-46628262bd0a@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d95a174d-83ec-4bc0-ac5f-46628262bd0a@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1ysafRkj5MkSBRqPpoIoiyjLCd7rXeLZgSayuDM9SZc_1784957575
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 16, 2026 at 12:30:33PM +0500, Alexandr Moshkov wrote:
> Ping :)


I don't know what to do with this one. IIUC in flight migration is in 11.0
so I doubt we can just introduce new messages without a protocol flag.

It says fix compatibility but really it's a feature, right?

And this is somehow related to GET_BASE?

Half the commits here have no or a single line of comment, those that
do, repeat what the commit does instead of explaining why.

That's not how it should be.

Here's a good template to use:

Currently .... This is a problem because ... We can not do .... because
... To address .... And then ....

HTH

-- 
MST

