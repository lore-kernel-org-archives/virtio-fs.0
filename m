Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2F33D47C5
	for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 22:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845874; cv=none; b=YWbXc01J62aCsZbrH51byJKWqHcieUZb7BBM7d7y0dnb4QvljPyDE/ld0z5Z1B2W+GRQ4kuwzKdG8Ypag7+DErAw7f0Ax/e9yds70Ahv7pc1mt1yIsRIXKE86SAla9PB64oczXJEcC9Lg98uBjC7pE81xyNR67fUz//sgmpxJqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845874; c=relaxed/simple;
	bh=BA6x/hUTVMBTeCNDEULOcGlNa3xXcwfyjSTX82F/bvE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CL3vfX9aW1aFCe93z70lF57uQHCnNAfMKyF0hdbtzFX06YILankIbquYZLZfs1caT9mEPztQZDU9ztbcodrJLn90InKbUaIisJC6+s+zcYZbC2A1Fkp9q4cmYXGMwgAQDVOEoKxVCDoHbPKU0BffqkWbx+jTjtW/lnvyZ0nzlnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ap73a0e8; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ap73a0e8"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8114a4542b2so11613437b3.1
        for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 15:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845872; x=1785450672; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ylndD1RfSjtAui3jJeAFAbrXgRT2PYj5papIJW82wSE=;
        b=ap73a0e81tF1rtjxFBw6f8JhF0QkUAdD14JR43ClyozuMI6LMQl1vyewarGN014csU
         NdJxkUr/J/Y35WA6wLt3lMrC7ZZ4VmriArlj6pKwrB5K00XMb7yeVOESWNkE7+POv25o
         zI6dc5UgTXu0YHdHPKOykbhdCqAGWf63HGvkPLFyHG9DCAC45hieaFRrpyluOapOJdtK
         lMgNLaDVAh8DC3CQ2wDYHhCSgXf4ZOrHj4Kp/6ZI77HusuYIt68VmEwfR/1Cj8yOKNGS
         CkSAAgrvurBIF9uFwJtBxOzNjJ88IRmY69s0FHYCRqAIApZf4EqJWTWjzLOmfz6gX13l
         Th9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845872; x=1785450672;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ylndD1RfSjtAui3jJeAFAbrXgRT2PYj5papIJW82wSE=;
        b=Q4nFOKHcu7xFeZcNW7l11T33SaAuUOy4B6WBBFgqbKy8kQhG/k6AEyBtKkJEVarNdT
         msnOfBIwdYQxyQHNMi3O5sZ5MujNWbXicgQTJdIZ7OtNfcaiXwoW++QGa+4mk8YKuHKO
         dhLFFug3ss5KOEdTS9hv85i8a5hBfwA8MtM0EY6meZ+SEscidvfJuwkXSqJxpfV/T/1y
         BVbIn5aP8xwMYT1h8meVmlstAceUSHfmdh3x5u05Wli1CfpASwhHLlcks1GxM6cZHK2D
         tuNH9wE4vVDLUXWpf1/slBVqzXuM96jfk3nDkszswspRsi1QSdESJ/l44lobeZgiXxa5
         7o5g==
X-Forwarded-Encrypted: i=1; AHgh+RpNEJSEhNI9pQrlPCaSoIshGMl4FJcKqYeRSk6eKN5RtsgbKZYkZtrkWztLtfIMnXv/an5tMs2jul4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxhkm++UHULWXK6VVrXXRpc/0Jr8kn1DcyxPtR2LhdluDWD1kfg
	3ab232JH9irAKiIYGB1nbU1ZMfEX1qP+g11fG8aVeHZeq43EactoNtNf
X-Gm-Gg: AR+sD11rbu8pu4zcW58a/TlNY+GQq6Z5yypXBFgYuUb/fD6S51RB8mqNq9dx7xFETgI
	a+flUMBUkbcDfTPnLCht3xQoGzxZEhcRjdlbY6q5AQjPLrcGligzRRk6zIhnPceYM+oSwgp55GD
	/n4ZGxAg28bQAiwytE/+XbL7ojCQmXFV9tYSKVK40tmdRJ4/UrvT+SE/UDzl7+X7En5cnbiJJUD
	jqyKnPbV2Uak6bQwbvpDGpQCFKXKdZtkldEk4p573rHgT18ThknvUkHr5AVFl0l3bq79FlxkIWk
	1N6FoUqNYUjDce038GcB9l7RF2Eu29gRaWIs1QgoU1tyWs+M8Z3lDCKkoAmHMda+rMAEoq4uq7h
	fVCEN+ociaiprZ30AbbRDLF2QSbN7V6ibZQkJ7iKxWMYFM4ySajDNLY4umEKmmQj4sAncriUfvi
	v4PXtC+OiqClxg1HtFmw==
X-Received: by 2002:a05:690c:4b0d:b0:81c:c77b:3546 with SMTP id 00721157ae682-81f4c20e739mr14265437b3.21.1784845871777;
        Thu, 23 Jul 2026 15:31:11 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:446f:49ff:37bd:d45a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33c3c1c5sm35766777b3.17.2026.07.23.15.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:31:11 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 23 Jul 2026 15:30:07 -0700
Subject: [PATCH RFC 08/15] hw/virtio/vhost-shadow-virtqueue: used handler
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-vhost-user-isolated-memory-v1-8-6b97c439eb28@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784845839; l=2085;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=BA6x/hUTVMBTeCNDEULOcGlNa3xXcwfyjSTX82F/bvE=;
 b=7VfH4IA82HBRppUZ24zMa8oz1EFKQW87j2JcXhb+DAvu5J9rymFlCfor8xdKNfIFK5cl2i6Ds
 uyK7/eO1cXHDFKikVsmgO5gLq1g741DLSV+rBgLH3+eJYxsNttpni4o
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Adds a handler callback to shadow virtqueues in order to enable
non-default processing of used vring elements from the device.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 hw/virtio/vhost-shadow-virtqueue.c |  4 ++++
 hw/virtio/vhost-shadow-virtqueue.h | 14 ++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
index bcb7f2ffc7..eb86c1ee37 100644
--- a/hw/virtio/vhost-shadow-virtqueue.c
+++ b/hw/virtio/vhost-shadow-virtqueue.c
@@ -669,6 +669,10 @@ static void vhost_svq_flush(VhostShadowVirtqueue *svq,
                 break;
             }
 
+            if (svq->ops && svq->ops->used_handler) {
+                svq->ops->used_handler(svq, elem, svq->ops_opaque);
+            }
+
             if (unlikely(i >= svq->vring.num)) {
                 qemu_log_mask(LOG_GUEST_ERROR,
                          "More than %u used buffers obtained in a %u size SVQ",
diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-virtqueue.h
index ec16a1e838..ccfeee36d7 100644
--- a/hw/virtio/vhost-shadow-virtqueue.h
+++ b/hw/virtio/vhost-shadow-virtqueue.h
@@ -56,8 +56,22 @@ typedef int (*VirtQueueAvailCallback)(VhostShadowVirtqueue *svq,
                                       VirtQueueElement *elem,
                                       void *vq_callback_opaque);
 
+/**
+ * Callback to handle a used buffer
+ *
+ * @svq: Shadow virtqueue
+ * @elem: Element placed in the queue by the device
+ * @vq_callback_opaque: Used to pass arguments to callback
+ *
+ * Returns 0 if the vq is running as expected
+ */
+typedef int (*VirtQueueUsedCallback)(VhostShadowVirtqueue *svq,
+                                      VirtQueueElement *elem,
+                                      void *vq_callback_opaque);
+
 typedef struct VhostShadowVirtqueueOps {
     VirtQueueAvailCallback avail_handler;
+    VirtQueueUsedCallback used_handler;
 } VhostShadowVirtqueueOps;
 
 /* Shadow virtqueue to relay notifications */

-- 
2.43.0

