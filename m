Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E113D16FC
	for <virtio-fs@lists.linux.dev>; Tue, 18 Aug 2026 05:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029974; cv=none; b=iGN/HpkHdlh99KcIQHak1j27N7pLSBPHXH7Dxyo4tbH8k4BiHCV6ED31fYrbT62XnlCRCXK42qU21mHFCjEdn8/c1S/opJ5rt6ew0M9ADGEQiNO8ZAZ+S9zoPqUdcek1vWuYZOBgrJgH6C8YVSmnNXaLK5U7xjm0dD062XTtO8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029974; c=relaxed/simple;
	bh=eS7iavmbL0ampAG6cVubHx6sNBExzuvb7v9JapDYYmM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=E5RpVlSfj9E0E51GeiabaOAeyHZCVUks1qtAaxWWqQtEJn+DY1YUuEZTaV2mIjG4PmAWg9nCOx3QLaI2HkN7pfJLMrOaGYM8ogMunMzPQ+Hfar3O9cYVz0Z4o8+/J6LGlBuUQWLvfL2OBZJe6d34zA1ZHz3l3srrhEgQkD3OEEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ds46zT29; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ds46zT29"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84874b52eabso5627713b3a.0
        for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 22:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787029972; x=1787634772; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YLd2wdLWmGn/myw/YqHvhA2qKd6cbpArYdUl+1k3wFU=;
        b=Ds46zT29pw+lyK+iIMutaT3re5nxhm8WIUyxvmpdrRxTp3FX5H+WStIphXG97Psm1u
         YjKUr1XiR7A3x3Io2XMnODrJP1fMXJYtpdb/Kd9I9c7kVO2v6sNTvvrUzX2SKV4/HC7m
         KK2pX8N+0T/eHqfVdvUn51aWsCP7A6h+m92CW6dSENocME9V1Z4hKXbgBB6chMHBHnzo
         A92M4bSoQShv7d7jjuMnuYrU4GVjCDzcX7IwPnYEhZkET6afNR+Ce5mMhCSoApq/XDjb
         6JDzd+2r+mywvBVVYZOryT4Qaj4InzICiQdKoacrBiFQ4xEIotuRBoN/TraGw4fbNpp+
         GN9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787029972; x=1787634772;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YLd2wdLWmGn/myw/YqHvhA2qKd6cbpArYdUl+1k3wFU=;
        b=JxHez/JfeUZDUIGVIElMdIZH5w54/XtYbmdf+1LI7cRlGOFSOsbRttU+xrCGziku93
         E9tRwSomuqPOQNVi6PyrFdiW0ucZ8BgElGjj0o25uNG99meM1IdZdYi44cgdAq9U4uor
         QR/kjA/ZjEPkkqzkWK43PfCLDOMlcPKSWvbZlu8pK5DV0e4UlUPNFwFGEj+cwqNgbX0I
         FtPRgJpV/t4jfldiKt5uNPgP7dnBDn4CWVflL3koHqpXqXkhDsUZtSC3AStbpUuBzbUo
         bxPzmxYGYF4SoJGaA1ySFSp7Jv5w5BFl96/v2Jhpz6CskxCQB33Og613SbwuiLpkOocp
         feIg==
X-Forwarded-Encrypted: i=1; AHgh+Rrx+KOZKrqpMMhj468VQVRONHv9mMFIyi/XOxaiC2ytHM1maWPhENG6ehS5gpxkVgc/8epAYvMf4qg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1D7F5KPox3RTzNIuAUUwikmRNPrCQah1q282t43NAWY5wa90L
	wP0V74Aq0YJTnw1OwOfexXCy0Ys0UQH5Xfbq4PYEon33FEC37Csm2oAc
X-Gm-Gg: AR+sD13TzjP354xn6ySpKslUzLp0vgzQEhD6mr7r9NiOKMib3JWF7gSyfoASvIse1qX
	CxFJBIzaKlW9DyWLigF26BmFdtzYXvtbU65HWPvDGijk5RUFl3Ljgn5PYyN+5/KouPGbNKdWtRv
	lsBvnPV8SsKwcISrq5mcrwKXP84rqa9pWgzRrMbJaixG2DrRnz0CAmq/WVvXy3uG+BnnSJf5Vmo
	Yz+oRCyRC0yXKBI7z9qe8bT2EUiKtlluACtukXh2EKJVrT8JTa0Ynxe1hm5vepbVr0YsJlcxmF6
	3YApyFUgV7AogXK5cJgUosGv/FE14x3+p7UOKerBn8Go+PXXdVoLW140wRB1UCV3VJs/mYFzfY1
	DiliPPb7q71qHEXNFp58BCRkaSZ0dyXuJAWYvT6P/RKmdaoLU4ssPL//a0GaySeW0mjWJeyMQgE
	OpdnugumNkTnejEm+vKrfV+KYPiQfKsNd0+2vJIVdNLaS5RqtDsqxABQgSXQ5Nb4v/Mb1XWqNAZ
	vQm
X-Received: by 2002:a05:6a00:2e99:b0:84e:7ec:aa42 with SMTP id d2e1a72fcca58-84fddfce17amr29977836b3a.10.1787029972164;
        Mon, 17 Aug 2026 22:12:52 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:d043:a40d:25c1:432c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc0e84sm1031160b3a.43.2026.08.17.22.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:12:51 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 17 Aug 2026 22:12:27 -0700
Subject: [PATCH RFC v2 12/13] backends/cryptodev-vhost-user: add memory
 isolation bool
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-vhost-user-isolated-memory-v2-12-948aae960abb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787029936; l=3359;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=eS7iavmbL0ampAG6cVubHx6sNBExzuvb7v9JapDYYmM=;
 b=QQC2OuLiUfEcGY5CpgdYwdIVlG/TPTJH7ZlmxUHZmp1sA4tGb7tfTiqnQlBPGifcZORQ+JMwD
 6K2JrArn0J5Ct+0HPw1nnvuKpOOZIgruSX4qtfleJJy8I0Q4U1EiBIx
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Add a memory_isolation property to CryptoDevBackendVhostUser and
add add it as an optional member of CryptodevVhostUserProperties
in qapi.

This is needed to be able to specify memory isolation for
cryptodev-vhost-user objects, and the bool will eventually be
passed to vhost_user_init() in a future patch.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 backends/cryptodev-vhost-user.c | 28 +++++++++++++++++++++++++++-
 qapi/qom.json                   |  8 +++++++-
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/backends/cryptodev-vhost-user.c b/backends/cryptodev-vhost-user.c
index fa1f9b76d3..be8631446b 100644
--- a/backends/cryptodev-vhost-user.c
+++ b/backends/cryptodev-vhost-user.c
@@ -49,6 +49,7 @@ struct CryptoDevBackendVhostUser {
     CharFrontend chr;
     char *chr_name;
     bool opened;
+    bool memory_isolation;
     CryptoDevBackendVhost *vhost_crypto[MAX_CRYPTO_QUEUE_NUM];
 };
 
@@ -213,7 +214,7 @@ static void cryptodev_vhost_user_init(
         }
     }
 
-    if (!vhost_user_init(&s->vhost_user, &s->chr, false, errp)) {
+    if (!vhost_user_init(&s->vhost_user, &s->chr, s->memory_isolation, errp)) {
         return;
     }
 
@@ -392,6 +393,27 @@ static void cryptodev_vhost_user_finalize(Object *obj)
     g_free(s->chr_name);
 }
 
+static void cryptodev_vhost_user_set_mem_isolation(Object *obj, bool value,
+                                                   Error **errp)
+{
+    CryptoDevBackendVhostUser *s =
+                      CRYPTODEV_BACKEND_VHOST_USER(obj);
+
+    if (s->opened) {
+        error_setg(errp, "Property 'memory-isolation' can no longer be set");
+    } else{
+        s->memory_isolation = value;
+    }
+}
+
+static bool cryptodev_vhost_user_get_mem_isolation(Object *obj, Error **errp)
+{
+    CryptoDevBackendVhostUser *s =
+                      CRYPTODEV_BACKEND_VHOST_USER(obj);
+
+    return s->memory_isolation;
+}
+
 static void
 cryptodev_vhost_user_class_init(ObjectClass *oc, const void *data)
 {
@@ -407,6 +429,10 @@ cryptodev_vhost_user_class_init(ObjectClass *oc, const void *data)
                                   cryptodev_vhost_user_get_chardev,
                                   cryptodev_vhost_user_set_chardev);
 
+    object_class_property_add_bool(oc, "memory-isolation",
+                                   cryptodev_vhost_user_get_mem_isolation,
+                                   cryptodev_vhost_user_set_mem_isolation);
+
 }
 
 static const TypeInfo cryptodev_vhost_user_info = {
diff --git a/qapi/qom.json b/qapi/qom.json
index c55776af7d..1024027195 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -350,11 +350,17 @@
 # @chardev: the name of a Unix domain socket character device that
 #     connects to the vhost-user server
 #
+# @memory-isolation: disable direct access from vhost-user back-end
+#     to guest memory.  The back-end will instead access data via
+#     bounce buffers residing in the QEMU virtual address space.
+#     (default: false) (Since 11.2)
+#
 # Since: 2.12
 ##
 { 'struct': 'CryptodevVhostUserProperties',
   'base': 'CryptodevBackendProperties',
-  'data': { 'chardev': 'str' },
+  'data': { 'chardev': 'str',
+            '*memory-isolation': 'bool' },
   'if': 'CONFIG_VHOST_CRYPTO' }
 
 ##

-- 
2.43.0

