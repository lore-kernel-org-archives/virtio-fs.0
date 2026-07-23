Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A147035E1CE
	for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 22:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845860; cv=none; b=Ky6eTszdHzCmlDxqfjuMgHfPcGsH44yXImcK9l88Hatfz9iL4QsiddLNIJWtUbOE/J+wBRKT7vYEGOWdW9Ykqhq5Tys7yOVxflt0xa7TcJ//+lMhDZmOmrM95DxrN2YtOk8Edt33p1XezKtJ1PSTno2KArlm1moGiybI6xNdPTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845860; c=relaxed/simple;
	bh=kCaV9zgYB27gebvzRUkQdZHWZmFFifXRqsrHtdiCBbU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cRgfd8Dc0apc/NPFq/ULf6QCOc+pQY4p/6kaZXmQo0QlzKXqLXZSC/57ZIegGQpZPfRrByyaqsZTNYFhBDtp0P9pvDmIkwUGPI5mDbHDJx1KEYYRuhUaIV2ECxhxQuDcw6IANOft68S05E88H9S0GxIopAcsUeoQnttvvgi+QkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WDl1ojvy; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WDl1ojvy"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-81eb41c1f1aso10181707b3.2
        for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 15:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845857; x=1785450657; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RRQE/saYJaaESTpo7p1Xp5FIXQbHxoLdzskT04Eqn0k=;
        b=WDl1ojvylPr29HpTZ/XGLg7/Vt2lzU1u5BMY6s6bLjI/IBd2uJMbq36PrY2IIx5FdO
         j151MGjjzmxjfRXwCwRlomOzAAgLiR+lFHppnnuTeKv0ubu8GNKkUsP7V9yZNqp2dopz
         2CYKdP0H/Fzl9gf7KsPVqgGTQbBOBrS41uPq7RcnrKaxJeDWSg8SDRXGXpbHoUu13575
         xE3LlEUlonYOPxjdmhIvwoXJZahRoEx1zmKPEjBwFRIfjW/fbEg9D97ozf5MpLoFXOr0
         0ALD3kXhaF2mtxJl9iwyF6QXTaeU7De5e0N899HcwEnpOp7LrLp1370SgE6ude6aXusU
         ThEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845857; x=1785450657;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RRQE/saYJaaESTpo7p1Xp5FIXQbHxoLdzskT04Eqn0k=;
        b=RmvG3lG2ukTAaD/ETDf+88IxB6r2aIlR/UbTSWyk2vmOUUDpPfdU+4hti5khvPZl4v
         Hk3Jg6x1kg84bsbotSbgLPqVCKSVQU3UJ7MKNaQcHnXkl/MHiF6HRYgsWuNzbAcPXTbm
         XAfUbIkVFkR0nci8zPz+hkOBz2hcQTFXCJy0iZFO4UepTHJLANQbiy+sF2uOJM6WrmJo
         Lv70MfRE54r5EdXh5fLpldey1wvefBaAzPdCoz5Ro0b/fd69g5bAkght88uHUFVeRDom
         hJnle7kLrbzf0zqNx6ntYAR6688MR6b53U05eCjoDIpBV300rB3Gl14X3mRXnMb2QXy4
         xZUw==
X-Forwarded-Encrypted: i=1; AHgh+RpBAr1/Vl/NV6/ycNZNEFEwPyoKHL03VbX9+KFFF//I0AcfY0ciuNpMCCB/bpO1Y8yUdl8oebZCoNc=@lists.linux.dev
X-Gm-Message-State: AOJu0YycQm4pjkZrgQCxKvRGE5IHRP5qWAGZ9lyZq3334mJ5RSA3pF7q
	NtEk7cKMOYBh5c823JNOmiMCMdiQpnjv3S6DDwCZIpOGsKbRiLkn4Azl
X-Gm-Gg: AR+sD12hBbeZm5IGube1P6/iHMviQrNhaiCqRzbXIzYDzg6y0oyM3nw8G/RzKA3yu8Y
	SSCI/hcqKN8MKWg5yREKfFqCiCgbTixpYzfAlPNy+ClExQ14EPvEfJElast/pGJJ01hi8uGQgtV
	MWRuUgSVtsYpQzgFRsp3oKBfdYxP52t5C5+F4Lba3lsxlMno9pEc0KJrB7RoYk+HHR3IZoWIqR6
	TWPsUp/JIayBRgNCpWYkUcX7ueYeaZVlkXcym7ovOKFVJbuxQz421vB5r6RStIQn4TYKJzyE6FM
	NRp7zdlSHbc1ocbPS7jiy/VLSGidyYDYhO+JZqka6ckBWCtHYy5pFfMZb+iinjs0cTGokMMY593
	c9wDa6TworyOOo/KY5x/Z9wPeyYXWNZjpTHhS7R2Ml5LiexmnWn4jzMzxH9AJcQqk+UXOwo2oGY
	sEbpCWDj8=
X-Received: by 2002:a05:690c:3182:b0:81e:782b:72dd with SMTP id 00721157ae682-81f4c13eca6mr16234977b3.13.1784845857145;
        Thu, 23 Jul 2026 15:30:57 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:446f:49ff:37bd:d45a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33c3c1c5sm35766777b3.17.2026.07.23.15.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:30:56 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 23 Jul 2026 15:30:03 -0700
Subject: [PATCH RFC 04/15] net/vhost-user: add memory isolation
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-vhost-user-isolated-memory-v1-4-6b97c439eb28@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784845839; l=3194;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=kCaV9zgYB27gebvzRUkQdZHWZmFFifXRqsrHtdiCBbU=;
 b=0rwPPZPPdLUldxXIPlmWzZZKsluRInnn0dnYpM4AJ/dOhHa4yxaSxJ4BSpQYjWCEEu9du1NIy
 NSRYlfAYsUBD2crLSqh5DlOL9rL4m+ACeFxCaFF7hB2iYgq71VY6upj
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Add a memory-isolation property to NetdevPassOptions and
NetDevVhostUserOptions in net.json.  This property will
be used for vhost-user devices to disable access to guest
memory from devices.

It will be passed into vhost_user_init() in a future patch.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 net/passt.c      |  7 +++++++
 net/vhost-user.c |  4 ++++
 qapi/net.json    | 15 +++++++++++----
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/passt.c b/net/passt.c
index 45440c399b..ce80186883 100644
--- a/net/passt.c
+++ b/net/passt.c
@@ -735,6 +735,13 @@ int net_init_passt(const Netdev *netdev, const char *name,
     s->pidfile = pidfile;
 
     if (netdev->u.passt.has_vhost_user && netdev->u.passt.vhost_user) {
+        bool memory_isolation G_GNUC_UNUSED = false;
+
+        if (netdev->u.passt.has_memory_isolation &&
+           netdev->u.passt.memory_isolation) {
+            memory_isolation = true;
+        }
+
         if (net_passt_vhost_user_init(s, errp) == -1) {
             qemu_del_net_client(nc);
             return -1;
diff --git a/net/vhost-user.c b/net/vhost-user.c
index 2d0fc49b4d..8fa303f901 100644
--- a/net/vhost-user.c
+++ b/net/vhost-user.c
@@ -459,6 +459,7 @@ int net_init_vhost_user(const Netdev *netdev, const char *name,
     int queues;
     const NetdevVhostUserOptions *vhost_user_opts;
     Chardev *chr;
+    bool memory_isolation G_GNUC_UNUSED;
 
     assert(netdev->type == NET_CLIENT_DRIVER_VHOST_USER);
     vhost_user_opts = &netdev->u.vhost_user;
@@ -476,5 +477,8 @@ int net_init_vhost_user(const Netdev *netdev, const char *name,
         return -1;
     }
 
+    memory_isolation = vhost_user_opts->has_memory_isolation ?
+                       vhost_user_opts->memory_isolation : false;
+
     return net_vhost_user_init(peer, "vhost_user", name, chr, queues);
 }
diff --git a/qapi/net.json b/qapi/net.json
index 1a6382825c..4588c7014b 100644
--- a/qapi/net.json
+++ b/qapi/net.json
@@ -213,6 +213,9 @@
 #
 # @param: parameter to pass to passt command
 #
+# @memory-isolation: enable memory isolation.  Only has effect if
+#     using vhost-user.  (default: false)
+#
 # Since: 10.1
 ##
 { 'struct': 'NetdevPasstOptions',
@@ -250,7 +253,8 @@
     '*ipv6':               'bool',
     '*tcp-ports':          ['PasstPortForward'],
     '*udp-ports':          ['PasstPortForward'],
-    '*param':              ['PasstParameter'] },
+    '*param':              ['PasstParameter'],
+    '*memory-isolation':   'bool'},
     'if': 'CONFIG_PASST' }
 
 ##
@@ -685,13 +689,16 @@
 # @queues: number of queues to be created for multiqueue vhost-user
 #     (default: 1) (Since 2.5)
 #
+# @memory-isolation: isolate guest memory from device (default: false)
+#
 # Since: 2.1
 ##
 { 'struct': 'NetdevVhostUserOptions',
   'data': {
-    'chardev':        'str',
-    '*vhostforce':    'bool',
-    '*queues':        'int' } }
+    'chardev':              'str',
+    '*vhostforce':          'bool',
+    '*queues':              'int',
+    '*memory-isolation':    'bool' } }
 
 ##
 # @NetdevVhostVDPAOptions:

-- 
2.43.0

