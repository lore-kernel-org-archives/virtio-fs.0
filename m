Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D5834677B
	for <virtio-fs@lists.linux.dev>; Wed, 22 Oct 2025 12:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761137416; cv=none; b=Bq/Lquyx7DGYRFcIQ3yo+fayPaEphYdsHkyNKdBfiKiDyQvn40GXY/KyN/Q8wO5eGC7tuoJDSMn4MVLWRBrPlYFscIdwjkIPTQAnHw2qSinKEyaEVyBsrwvdsiIbl61HrEjI53YsDas7g1iT9fPKTB+kBoqKDHj1iT+e/Bc81zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761137416; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=jYpikvh4g8HRzEdnl4ng92CfAb1eysJxuoeQiHfExjkvBH98DT93hvmxPepk8oRzjeQJogL6JGVR8Knj1UeEsLchszkLjQRT1NVunmZgGps+pfpHEJiuPvJy3n7ddd1TohjKwCpjnyfrSbDaw5T7/Rovp+ravJX5cBO/uEmha4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aAilEOob; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aAilEOob"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761137401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=aAilEOob8MMVFEkWURHCW9Vwkf2sd7OjrJ1WBZhbJ5MOrijxW6XleAuN0uUYh39DCDFF6w
	VFGLafRZMzWkZ37yctTzF1dU5+T9XI6+FZG7N5Fg6cQpvKYr+kQfa/3tqOIkpCMr95mT6X
	7n618B45nYcBF5hk8SmrWh2zc5/yd8s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-faP4oqg1PYS7Qx4drQrSkQ-1; Wed, 22 Oct 2025 08:50:00 -0400
X-MC-Unique: faP4oqg1PYS7Qx4drQrSkQ-1
X-Mimecast-MFC-AGG-ID: faP4oqg1PYS7Qx4drQrSkQ_1761137399
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47111dc7bdbso52552225e9.0
        for <virtio-fs@lists.linux.dev>; Wed, 22 Oct 2025 05:50:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761137399; x=1761742199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=xAMJyeJ+xWs1/lkLElujd4w4hpClzyT9HpvA6YzbbKiXrN4MD7Q2Az+JFvrNZi3fLd
         75yD/CIrlcj+SHE3AWhClSS9uoBkbBqTQQZk7eeHsnLqmTZLaUYXnhkhpZQoQlDpLoBo
         35RsumRax/1G0P7Ovezl9L6wlCUd9Py8F4T1sa2L+ArzX5G/MJL96EI1oqRAINGqcfCj
         IcU00m1F2/mdlYjF9NIKDYp65c40eFBJ9ntxcjc6pVsRmXTzFzquPitj93EAy15gfXEH
         qMxsDVLi4c1g6DZ6ScKhnOelVn7zVJs8JskVlIMtSL9Qz6WkCgGqXMSR+GnK5pau5yQ0
         //jA==
X-Forwarded-Encrypted: i=1; AJvYcCWHHXFhpMH2S3EKDiPxAK82hlZEE4JA97AcxrI2J80v1kYAP0rno0x/+mEWNHZ+jm5BlS4BBZsZr24=@lists.linux.dev
X-Gm-Message-State: AOJu0YxpnKeKTSnth/NQcedgUqBNZi/8t90rO07O++rL4ex+JIXYIBoH
	Atj0DvWgntperMVNwssgPh5f/Hi+DyPFtZQ5iurOFA32EZBcsTmFe6m+sdFRD5/OG5LWePzVEH3
	dajA6f3hrXZb8fUimsxs3R3k7dhfxJn0WC+4+oyXP6l3maxUodTHvSkyYLEkqgg==
X-Gm-Gg: ASbGnctw3XQ7zdBtMEpvdQFU3cOKJ4N/b3W9QJH27LbkqjJaDFkHxZmvvvTP264A6XA
	ZcMioj0sRMFMSAl14IabmcL3OrpLHo2g0YWGAsyd2Sr7h0CForWjbU+vZ74P/MhR+P4NIVEKtZU
	U66vH40KgYodRZz0aBIwMNocG/ld2MEMGqvQt24U9aa20Ye+CG7rXhn92NJsgI0Zgk6uqGljouZ
	Lv0rb8wr+Iolv0b6+HLPbXXlgUuolClJd9ewunMjZ/dNce7WBLvKbaRT0J1h1KGiUzCXjIQk2qR
	PjTpGQ8wYeuwu3GSVjVuhwnL2updTqFz5T1YjqJ3QAhmwHmKoEGr3uwS2kCx7Mn5ACQrWy9i2r6
	isk+R7pb9vB1WeQi/h+MuZTS9rU6hgpNuP7ycIrKB27ki7iUju6LsscyDmf1kiUWaa/H5iNz6oE
	jbhQ==
X-Received: by 2002:a05:600c:3e07:b0:468:7a5a:1494 with SMTP id 5b1f17b1804b1-4711787350dmr122417205e9.1.1761137399215;
        Wed, 22 Oct 2025 05:49:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/Hm2BY761ErfCQAW9TWE1D63G3DyFVH54t8V55V0H1jT6mBT86okovR2Of93UGrtI6FGtKQ==
X-Received: by 2002:a05:600c:3e07:b0:468:7a5a:1494 with SMTP id 5b1f17b1804b1-4711787350dmr122416435e9.1.1761137398787;
        Wed, 22 Oct 2025 05:49:58 -0700 (PDT)
Received: from [192.168.10.48] ([151.61.22.175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c428a534sm50029055e9.6.2025.10.22.05.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 05:49:57 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: marcandre.lureau@redhat.com
Cc: qemu-devel@nongnu.org,
	Gonglei <arei.gonglei@huawei.com>,
	Zhenwei Pi <pizhenwei@bytedance.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Amit Shah <amit@kernel.org>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mitsyanko <i.mitsyanko@gmail.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Chigot?= <chigot@adacore.com>,
	Frederic Konrad <konrad.frederic@yahoo.fr>,
	Alberto Garcia <berto@igalia.com>,
	Thomas Huth <huth@tuxfamily.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Yoshinori Sato <yoshinori.sato@nifty.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	"Collin L . Walling" <walling@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	Alistair Francis <alistair@alistair23.me>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Corey Minyard <minyard@acm.org>,
	Paul Burton <paulburton@kernel.org>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	Antony Pavlov <antonynpavlov@gmail.com>,
	Joel Stanley <joel@jms.id.au>,
	Vijai Kumar K <vijai@behindbytes.com>,
	Samuel Tardieu <sam@rfc1149.net>,
	Gustavo Romero <gustavo.romero@linaro.org>,
	Raphael Norwitz <raphael@enfabrica.net>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"reviewer : vhost-user-scmi" <mzamazal@redhat.com>,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Fabiano Rosas <farosas@suse.de>,
	Markus Armbruster <armbru@redhat.com>,
	"Dr . David Alan Gilbert" <dave@treblig.org>,
	Zhang Chen <zhangckid@gmail.com>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Jason Wang <jasowang@redhat.com>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Lukas Straub <lukasstraub2@web.de>,
	"open list : Sharp SL-5500 Co . . ." <qemu-arm@nongnu.org>,
	"open list : S390 SCLP-backed . . ." <qemu-s390x@nongnu.org>,
	"open list : sPAPR pseries" <qemu-ppc@nongnu.org>,
	"open list : X86 Xen CPUs" <xen-devel@lists.xenproject.org>,
	"open list : RISC-V TCG CPUs" <qemu-riscv@nongnu.org>,
	"open list : virtiofs" <virtio-fs@lists.linux.dev>,
	"open list : Rust-related patc . . ." <qemu-rust@nongnu.org>
Subject: Re: [PATCH v2] char: rename CharBackend->CharFrontend
Date: Wed, 22 Oct 2025 14:49:51 +0200
Message-ID: <20251022124952.3691010-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251022074612.1258413-1-marcandre.lureau@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8yzXB1h-iTehb2lgfgc9-7CA6c0loWvKcqURFmSWyro_1761137399
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Queued, thanks.

Paolo

