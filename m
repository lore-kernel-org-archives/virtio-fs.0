Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC153A4F5F
	for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 22:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845880; cv=none; b=uaoo7tcV6PhKP7ay1UCPgrR32n/21otQf/Edn/UGtQQVX0Cl1cEXXT3on+HBwmw8OISrwQl/6LTaVZtUDTEaURxR5rYYbyL6EbsgF+UELXlHUD0H73gbm0Aqcgyd5T8n3bugmz8Sl4VUymmVMaeHL2gcmZBK5yFxV5Or0yf3IN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845880; c=relaxed/simple;
	bh=04f7EERf9vN/x+nrTxJ0MQEJIkC9u9fbifj56dOif+M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=S0eRM1qRZYnDVJpDzJiXz70jnS8T7XxKcgiRBFLRl/sEC4Ydtt4Y9TPIaGlJi2jpnaQ70R7NdniurWXUBM2DzdQ68cNCmi0PFcMIFK9sAUBMmhQP7hj1e15hlMsI5sWl6iBNUVvyqR6Fdj/xqRSvohYfNlH9zTuYkxuWpGMFQgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hUj6qWMO; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hUj6qWMO"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-81f36179dd5so10646817b3.2
        for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 15:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845878; x=1785450678; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ylRn09y+xnzIXfbeVocInrK2nRf4OiszJaVCpi6B21A=;
        b=hUj6qWMOyOgNfc/gck6975O9xtat1hr3BrOWPwnuxV4+WSr+HZ0nnYIWr9PXL+JGJp
         nRsP3e6jxadtfjkNU3S6O+1cRBGqfnHcpQnUNG/6QybHednM5xD26D5gllDbx7oNAFlm
         nchnLvK0UXgLMJbMN1KHGzGxFhCGChgdlWQ15As61r/GM88AMlK/21ZjjibIbto+/eU5
         rv1UARIektn0C0A65BQ/69FWJ6ytAUjayZgqyqdNwEoAxBartf0c8FuZgV4me9SRj4MW
         Ez5wnxsfQHmSiz1cqPlzjmG2XFUmhFZ0gPjU7FG3rT3KWHyAlAFZH8E95/akqo49HZfR
         Uing==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845878; x=1785450678;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ylRn09y+xnzIXfbeVocInrK2nRf4OiszJaVCpi6B21A=;
        b=URA8vsuGpJW47SWSwUFcUWdq6S7BP4xvi1JrvyvyWWx2Psu5hIy8kXIObAqfwx0HfM
         Qsvd+mgASq6fhzjGGRMfclD4/b7+4Z3J0WrNG6zQ7uZGtmjEtb2oo2aptcvHnUhYuJYQ
         GDIfQJ2WvYcSjlu51+r5VskqGYvDcxzxgLOTKQDAvkp3ocO4MEmPnIgLF0x2p4VtL1pS
         V8mSunjxdQOKXGSa8wbYt2a1x7AFFRfmgXPFy+HSdOF/aheS1nappZD963B192exinFi
         py/NgdRJMR2YYDYvYFRc45MRyd08Al2CC6foXuImN64IxlJRHTBYuMXgVTF5/uTHj4U/
         3cMw==
X-Forwarded-Encrypted: i=1; AHgh+RqFL1gwJB/+h/2M7Z2luey/coBJAejJSiSSQjmp5wjY0Mpw/QYOD9mhGX4te2a1pH3l1XeJmXb64Pg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPPBC2aqxU5rTTVecsCeS/cLQNfQY6vdMKgnBJlytUxaeXbOs7
	L9EtM1q/Vo1KzODy19waF7mZAIi9opQyRa8kRMWAMippcarhtHWy4+g9
X-Gm-Gg: AR+sD10d+6BHnjjDo/998eg5LyUvkeD74st4OiCkgiIP0Tv06ZraIcgwJgUvg/yZVEi
	r0n2s7FQUHzMytpEcE/IIFHxWigZ348EgJHBs0K1PGMgx2yKhsO3FUTH6Z6wJxzjAK7LNwOIwwW
	Kh8mEHZFEo9ThRb6cIs/HEGakc8VSGnZMOWLEyhEwYSjfrU0ZnOC9cjX/UoHwwDDPtRwzdHEyit
	RV1N7UA8g06vU84z65Fly0SHfmqZAV5+299n9K/NVazDTpTwppyccsOXwE5OYB5FGvRrbm1BvcT
	i8sQ/PJvSsP7MmKlnXmUu8zc3pLbzXhgwbB+4K0b1BWk4izz0VOft/HX1yMH2nCy1sZ63OzNNLI
	+IskEHtj6LmBvLkb4uc5HeqygHVLu+GH2Ea+J7nTE6uz3TqHuVUPfIybFekS2ivgcwHMa6TvdC8
	gUAIXqr28=
X-Received: by 2002:a05:690c:3389:b0:81e:fd36:ff73 with SMTP id 00721157ae682-81f4c15ffc8mr15595487b3.5.1784845878437;
        Thu, 23 Jul 2026 15:31:18 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:446f:49ff:37bd:d45a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33c3c1c5sm35766777b3.17.2026.07.23.15.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:31:18 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 23 Jul 2026 15:30:09 -0700
Subject: [PATCH RFC 10/15] hw/virtio/vhost-shadow-virtqueue: range boundary
 in translation
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-vhost-user-isolated-memory-v1-10-6b97c439eb28@gmail.com>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 =?utf-8?q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, 
 Haixu Cui <quic_haixcui@quicinc.com>, Raphael Norwitz <rnorwitz@nvidia.com>, 
 Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
 =?utf-8?q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
 Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
 virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
 zhenwei pi <zhenwei.pi@linux.dev>, 
 =?utf-8?q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, 
 Jason Wang <jasowangio@gmail.com>, Peter Xu <peterx@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>, 
 Connor Kite <connorkite@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784845839; l=1603;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=04f7EERf9vN/x+nrTxJ0MQEJIkC9u9fbifj56dOif+M=;
 b=i0fxAoQx7q77vNmc1kVFBCgRpGEUX6uEbuCl2hfAM5HOMSgGi3rgs4fhCEYoklxivGZougSSo
 5KxRK6PnQIJCIWR78oY8lUaZCs3lbAecaSUbGRqQRgxdv8E1xNkqEzQ
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

iova-tree expects inclusive range sizing when maps are allocated or searched.
Currently, svqs use exclusive sizing when searching their
vhost-iova-tree for a match to the region to be translated.  This could
lead to errors if the region to be translated is at the edge of an iova
region.

Fix this by reducing `needle.size` by 1 in
vhost_svq_translate_addr to bring then it line with DMAMap and iova-tree
convention.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 hw/virtio/vhost-shadow-virtqueue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
index 9e3c359f50..20e5c7d2f1 100644
--- a/hw/virtio/vhost-shadow-virtqueue.c
+++ b/hw/virtio/vhost-shadow-virtqueue.c
@@ -104,14 +104,14 @@ static bool vhost_svq_translate_addr(const VhostShadowVirtqueue *svq,
             /* Search the GPA->IOVA tree */
             needle = (DMAMap) {
                 .translated_addr = gpas[i],
-                .size = iovec[i].iov_len,
+                .size = iovec[i].iov_len - 1,  /* Inclusive */
             };
             map = vhost_iova_tree_find_gpa(svq->iova_tree, &needle);
         } else {
             /* Search the IOVA->HVA tree */
             needle = (DMAMap) {
                 .translated_addr = (hwaddr)(uintptr_t)iovec[i].iov_base,
-                .size = iovec[i].iov_len,
+                .size = iovec[i].iov_len - 1, /* Inclusive */
             };
             map = vhost_iova_tree_find_iova(svq->iova_tree, &needle);
         }

-- 
2.43.0

