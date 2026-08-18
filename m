Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAD43D0905
	for <virtio-fs@lists.linux.dev>; Tue, 18 Aug 2026 05:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029952; cv=none; b=dqOaqHBWoLXu/OGFT6cr0tj3tyBY67NjGNWgDSyHCjshw/mg2sCjIZRSCzzkI0N5wkbyAeqP7yJ/imoMKN0ZtbkkzJRGvcMD75sqyAoUqUknUkrI0aWqEKdsgtwm8b2BcKoA4fSoRZykG4zs27n6q1O3DFJ6Q6yfzovmOuIoaRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029952; c=relaxed/simple;
	bh=HH0SlSvH+q+3nGir6vgptvnX9Dx9KLnOIY0C19/JvF0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Q+ZghUg7yS1jPrTSVuBzBNeJ+IY8GhDXx29ioxv8HRyTkKvFjibWCQZ7nyp0KNQV9LtRC1D4FaeD5cGKlHJd8/rCxk6OeMdxUUPv8OtNmAURTl/FH+B5esytG7t/5POWquv04tx9l+oesSBTBuMj4A9B4nHT8OXYWrJapZ0eETw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=diwjkt19; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="diwjkt19"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8486ac3f347so576396b3a.1
        for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 22:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787029950; x=1787634750; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SplFjpyfUIiEmMlzq9z3b58IchCXTHYO6ngIxMF/AIo=;
        b=diwjkt19BJzl0HRPRALs0D5mItc8vo5E0LwI3H7ZsyUw0PcxvNpPZ1rtvdXYdLcqvH
         Y+uIFoJrcvNf+fiWXu9JyQlnYRSYxDHFksl/T0m8Gfoa9rM+NSqoFkYk7oq6KggWhiCw
         2H7cf+lzSpH/X81XWekf+/d9GNFvpsknfDGiXYi49ve9JAiJdX/doxmMmiH9XSMPAoSJ
         ni9Tg8s9k6/X8z+RvUUfarDaGAj0A6qs2S4K7z5+2vCLzaOFM9G3J1q+yYlk85KS2Zy0
         Nt6SOuFbvdhrm2SrF7jIBmuFllwxfoumRwd76S3RZzp7P4mTrbcNjCQw0nwqmu6lmfzP
         iviQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787029950; x=1787634750;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SplFjpyfUIiEmMlzq9z3b58IchCXTHYO6ngIxMF/AIo=;
        b=k9Vdur9ShXdoIotPX7UBasiNaRu2cm/bqj2ezDlKQxLRRbberXWdc2sZWNAT2YvxAR
         NSOVtA0UTxmhDK742sCXiHFHrzyjoVGlTV8UhVaNedMHNajnozePvPXTmbfAcE6dxNoq
         LUvghYfIR3A3KATkkew4+skslbXR1bz0H2j0l7PbAloawhjjdcJaQzOSE5XC0MPB5vuM
         wuUK2IN4fbL1EB6eS4zM6Y19WRRnl8oJKQFOW115F2LBAFlSjZyo3/L62s6ipInriiks
         PP2zuEkzH4bULOjYPo6RmK0oAcmZ6qCK5BzOklF6/X3rWm0C9Qf1UdYwB/ApYMiIaLff
         jp2Q==
X-Forwarded-Encrypted: i=1; AHgh+RrkFtgTYBDu6QQnVG59TPzSyBGurdmgeq1QNXv4Adm4KRb3hvpYFStcBTd8mtX7JZon+jMaP19nGMg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8COc3i8ymg4Ati22Q/g0QnRHI8oG9syOU3NvR+Plkp4p5U3cU
	Jxp5EVWPszdzknZE8KFd1EL25mVrQSaGldf4zcN5tHxoko1YemvB/Jd2
X-Gm-Gg: AR+sD125og/6SPsH2f5v0O/7XwtyhmfU2qSEc8X04e3J4EtgSEvtijU6ppsC7osHM/m
	2/TKokelVvM7lqxRXdcq6ZU3BwgDSTr3YHqTOfp2UM0y6Jl3eCGwfD1zkl2IPOwfqrPcW9i+BPo
	6oi0EnPb00JpL1fLejm5Glz+8yaXcVWWC6q577vWikcS5HRZDbUrSKIoIZD7D4GDGJ53/j1owpX
	DkjXQzLem7jIDMIO0XGn6lCWlWRjM7zdWk9EENMp4RS2pDiis/tM31WREGPOYtV6pd4Ssq4hNiU
	LIzOZrY87g9P4Qzw6cw1IC7mece9COCWz+AF+zmG5BS+O0DYj3m/DpvbEoxTpfMwgBB9V6JKW3f
	XFb6VBvolgbcjPUJG9QFWZAsGi2vcHXHo6ZVJn52AQKHHB4PhtyAPgvVEtvhXD6T3jhxfW8ikDa
	NS0terDwJU3lQYChhB2npbpcF2EZ5+Wr1BZmxpSTRoxB9ci+0CwazR/yrFyhP60GFqTAGrSvPoR
	wxx
X-Received: by 2002:a05:6a21:3a96:b0:3bf:bbad:500e with SMTP id adf61e73a8af0-3cce24fc3bamr3353906637.5.1787029950143;
        Mon, 17 Aug 2026 22:12:30 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:d043:a40d:25c1:432c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc0e84sm1031160b3a.43.2026.08.17.22.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:12:29 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 17 Aug 2026 22:12:19 -0700
Subject: [PATCH RFC v2 04/13] hw/virtio/vhost-shadow-virtqueue: used
 callback
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-vhost-user-isolated-memory-v2-4-948aae960abb@gmail.com>
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 =?utf-8?q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, 
 Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>, 
 Hanna Reitz <hreitz@redhat.com>, 
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
 Connor Kite <connorkite@gmail.com>, 
 20260817233147.2867623-1-connorkite@gmail.com
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787029936; l=2434;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=HH0SlSvH+q+3nGir6vgptvnX9Dx9KLnOIY0C19/JvF0=;
 b=4pu5D0cnp4xmAOKz3RDWU/Xos+GwI2mPfbnmu6yDH3gb9L0MxXGupZxCloz5NW3k23uRSdoVi
 DOmLtpxDokJB5SnhdWlEtuB9sI0MvC9+Jv6t5oUtBm8+S/MOO015cy3
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Adds a callback to shadow virtqueues in order to enable
non-default processing of used vring elements from the device.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 hw/virtio/vhost-shadow-virtqueue.c |  9 +++++++++
 hw/virtio/vhost-shadow-virtqueue.h | 16 ++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
index c8831d52be..496e7e58a3 100644
--- a/hw/virtio/vhost-shadow-virtqueue.c
+++ b/hw/virtio/vhost-shadow-virtqueue.c
@@ -675,6 +675,15 @@ static void vhost_svq_flush(VhostShadowVirtqueue *svq,
                 break;
             }
 
+            if (svq->ops && svq->ops->used_callback) {
+                int r = svq->ops->used_callback(svq, elem, svq->ops_opaque);
+
+                if (r < 0) {
+                    /* VQ or handler is broken. Do not set guest notifier */
+                    return;
+                }
+            }
+
             if (unlikely(i >= svq->vring.num)) {
                 qemu_log_mask(LOG_GUEST_ERROR,
                          "More than %u used buffers obtained in a %u size SVQ",
diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-virtqueue.h
index ec16a1e838..fd68319fb7 100644
--- a/hw/virtio/vhost-shadow-virtqueue.h
+++ b/hw/virtio/vhost-shadow-virtqueue.h
@@ -56,8 +56,24 @@ typedef int (*VirtQueueAvailCallback)(VhostShadowVirtqueue *svq,
                                       VirtQueueElement *elem,
                                       void *vq_callback_opaque);
 
+/**
+ * Callback to handle a used buffer
+ *
+ * @svq: Shadow virtqueue
+ * @elem: Element placed in the queue by the device
+ * @vq_callback_opaque: Used to pass arguments to callback
+ *
+ * Returns 0 if the vq is running as expected. Returns a negative errno on
+ * failure.  The callback should not add used elements to the vq shadowed
+ * by the svq as that is done separately after the callback returns.
+ */
+typedef int (*VirtQueueUsedCallback)(VhostShadowVirtqueue *svq,
+                                      VirtQueueElement *elem,
+                                      void *vq_callback_opaque);
+
 typedef struct VhostShadowVirtqueueOps {
     VirtQueueAvailCallback avail_handler;
+    VirtQueueUsedCallback used_callback;
 } VhostShadowVirtqueueOps;
 
 /* Shadow virtqueue to relay notifications */

-- 
2.43.0

