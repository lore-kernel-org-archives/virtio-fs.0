Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85513D5C2A
	for <virtio-fs@lists.linux.dev>; Tue, 18 Aug 2026 05:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029977; cv=none; b=I1i++o9fW4QTELz1sjFYHDSvYYRINoofBrtps+Fu08CcxOSQfey1j4BFZU2lMJcFZsror5/XLKJtu9S6YNexbj973zxul6+vsPdmHfllUyBjturBDvoPPOwgR2jVp7dNFx9bhC0bc00i4bU7yYaIqeFQEJgwQcOzRVeKrVDmOLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029977; c=relaxed/simple;
	bh=c1m9/46t7T/yFXDXSgz1vdQxYZX3+5KvcmxIw/DGGZM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aRYFF9m0YYaYz01W6Ez/czOdQHRDA910cVLY9unx06F93irpZfogztsoz8GCuhCY+pKnscdxFp0gKb0n8Y00/qJeB9GozefNXIKgweb23AvlLS5zCtgx7mvR4rwb2cG1MakNS0ApMu4jHzzvjiATTkQpjwHrZ+YTFrvwIUBg6+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cAt+XiOe; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cAt+XiOe"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-ca00f126b7eso2756824a12.2
        for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 22:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787029975; x=1787634775; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6J8o1AExw8TA5IVqQ+lEqAQiF7xrSW0tFYRCpllyDsY=;
        b=cAt+XiOedAJoU7nfA5v2SRMaqsd7pITF8yAwkfVZaGY3gAXfqUKUczQ1gbR3HIInDm
         6cIas103zISkhuhFKodtQk0R61rYoSkhbEU5uQ4ed/13GNg4BATgMw0a7N4cnd8e8zfG
         TKOQTRB4Vl5aCFiVAXmH3jGqAXqnw9Pr7hmE1mBbY9ecWpytqHezIH5CnhTxxbDvjx5C
         4Pb/Alq03JzAqT4KzzkfrWNLLoy2HeU+wa3/zQUjuF2VoE6S1dPefZxoQkBYRFLyKY22
         8fSom5hdVhc6vnzbYtWVc/HQ6EvPkDvFgMwFEFzCRzyVB581N2+OGGCsJRKRIUXARLEP
         +BUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787029975; x=1787634775;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6J8o1AExw8TA5IVqQ+lEqAQiF7xrSW0tFYRCpllyDsY=;
        b=fuTIS47uAfEJE82H+Vu0GDf5ntN1/WgWpJ/XdKAjEIaw6+28+gATfJF6S0muXL48gJ
         4jNhhBlGFfuGB1BLbmuU4Hupd26+zpq4/pCixIfPjBa+nXQhaMVZsniS+xipLfBkgisq
         6jvDxlGwqmlbzRfOOtg1uqBHbvP5hqWkNOiEOh+/LrVKhI6QDQzyW7HOijj/HTlRfIJO
         YU2yxs3ByjjNO25tJ5SkpBcam8UY5cqP6x1KYOo04YSNy8H4aCyf5kt0ub7FgGfVGtv9
         eJA6qZ5B93caNHQP9mPTeB19UqvBqCR9R/2lVcjq/id3+KbcWzJqS3/vE88uERdcA1+/
         Kumg==
X-Forwarded-Encrypted: i=1; AHgh+RoDEe2ngPXJAmg8N9of40xiitZdecRNgysjWQPK6QhlQsiZjUGWeuj/Ur4ZJuPSeIYOW6aQc/NiUEA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4QICWvlL1j4JT/y3YXEAYJMa30ZywiSlqIBzW4+EDUl5UNtuS
	BHnswALOee/NxeQLC2Ffr3Xvj73rjXD60GEjQuTqGBM3radfCLoEFaob
X-Gm-Gg: AR+sD12m91PEmhitIYrC3iY3VBK57/Q2tWSJkLdPN1DxJoGsz3KOCXT04dzgJ9oMCbV
	k132FsO+aKd/I2A81kG8AHJJMaQwAtk5E2bz5Ta0FTQcBQRHf+dCR+oKMY70UUqVNk5YhcRUwsa
	90SlcXkJcvUs+LzSuOpvmCfHur0WVftMiWSCusORbJvg7OkSpPlDQGnGsmu6yX+l5ephExJllWf
	NELbNUUmH/WTvfIIzK+rJNBjUQBDNpWTTIU7M2j6SaxEIBBJo14Sw/YX2Py1LZfXcT3vk5D3HZ/
	/TvsBmptC6NcvTqqJqcd9lK7JIX0mmV9HEzqFsMAc/LyOho/qyiQR0Z9L3MrS0sWaSYzzURTlRO
	VNDxaypArRh/F1dttwXkAuFDDHPvf1QdkvcYZ+8YRXfE5MlKnblZomyw2IPdeShwyLV8s71Tq6n
	0vSBlyEyPS/d54okkt/fewhvWqIoLgYsdk92ZXj4eIIrs5iScDTGtZCq5aiN8jQJcbBgs=
X-Received: by 2002:a05:6a00:950f:b0:84c:4b58:2cec with SMTP id d2e1a72fcca58-84fde3dcf0amr31788880b3a.15.1787029974889;
        Mon, 17 Aug 2026 22:12:54 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:d043:a40d:25c1:432c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc0e84sm1031160b3a.43.2026.08.17.22.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:12:54 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 17 Aug 2026 22:12:28 -0700
Subject: [PATCH RFC v2 13/13] net/vhost-user: add memory isolation
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-vhost-user-isolated-memory-v2-13-948aae960abb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787029936; l=2866;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=c1m9/46t7T/yFXDXSgz1vdQxYZX3+5KvcmxIw/DGGZM=;
 b=0OBe+eR1e1pPM+zCBkIkB6miAajDaB38ytMDFbdnB9eJvtfYmOO9BXrKbFt1bsCkL8dbpqiAh
 mlqwoGnl/VzARSTOyl20AImpQij7EOtVhDZS+xLZvgRjJACXJyRYvKI
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Add a memory-isolation property to NetdevPassOptions and
NetDevVhostUserOptions in net.json.  This property will
be used for vhost-user devices to disable access to guest
memory from vhost-user backends.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 net/passt.c      |  5 +++++
 net/vhost-user.c |  3 +++
 qapi/net.json    | 16 ++++++++++++----
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/passt.c b/net/passt.c
index 35ec6ad6de..7bcd47ad32 100644
--- a/net/passt.c
+++ b/net/passt.c
@@ -741,6 +741,11 @@ int net_init_passt(const Netdev *netdev, const char *name,
     if (netdev->u.passt.has_vhost_user && netdev->u.passt.vhost_user) {
         bool memory_isolation = false;
 
+        if (netdev->u.passt.has_memory_isolation &&
+            netdev->u.passt.memory_isolation) {
+            memory_isolation = true;
+        }
+
         if (net_passt_vhost_user_init(s, memory_isolation, errp) == -1) {
             qemu_del_net_client(nc);
             return -1;
diff --git a/net/vhost-user.c b/net/vhost-user.c
index b6ee9ed297..bd33decadf 100644
--- a/net/vhost-user.c
+++ b/net/vhost-user.c
@@ -477,6 +477,9 @@ int net_init_vhost_user(const Netdev *netdev, const char *name,
         return -1;
     }
 
+    memory_isolation = vhost_user_opts->has_memory_isolation ?
+                       vhost_user_opts->memory_isolation : false;
+
     return net_vhost_user_init(peer, "vhost_user", name, chr, queues,
                                memory_isolation);
 }
diff --git a/qapi/net.json b/qapi/net.json
index 1a6382825c..add7cb5408 100644
--- a/qapi/net.json
+++ b/qapi/net.json
@@ -213,6 +213,9 @@
 #
 # @param: parameter to pass to passt command
 #
+# @memory-isolation: isolate guest memory from vhost-user back-end
+#     (default: false) (Since 11.2)
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
@@ -685,13 +689,17 @@
 # @queues: number of queues to be created for multiqueue vhost-user
 #     (default: 1) (Since 2.5)
 #
+# @memory-isolation: isolate guest memory from vhost-user back-end
+#     (default: false) (Since 11.2)
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

