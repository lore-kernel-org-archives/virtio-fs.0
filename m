Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15263E51D3
	for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 22:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845897; cv=none; b=c8UnKxauIkrgfwZRkfACBHgQpCQ2v4zKu/XrL4M83fjPQiibWqhKLQcLQl3ivFBv/bY0xpsFKWgM0ID4qWIJVbN23wxH0JicWS8xofGxPNXJfxvmI56UMl2/qF1UpiSMekNOb8TXoe4ZYxv3/0S7jlkIEdFH3A0QnZ4aEV4zaR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845897; c=relaxed/simple;
	bh=pisgaTgm+ZiObME3tqs8+StA8fZGh7Ia1Av4+zrft74=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XPIr4uQDjTFbKdBGBO/PZdn5fG6VeSdRHL5tNifqt09IEA8DV87DpPyn2SMyVTqcendTVYr8dRyVcf0EsfPGMrpKxVPgP+plLq2kf4O9rV2O6NJVFuQ/qP0/HkFnynEN6mIBn2rGmrM4K36tBL5Ppueoeu2F1tXaFbM+NS4n3Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pqt+OVvL; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pqt+OVvL"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-81ec29f1d07so9906897b3.1
        for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 15:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845895; x=1785450695; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wsH8kj/3dWv6cLIAPdQqtziw/Fcf/VIereTmaACRGrU=;
        b=pqt+OVvL+lqpyjqsIPGDATRFBkycOjgnl+neBYHtGUvnC+OrZ5xV5OZe7sA9liI7Cb
         7ssYTqoQ4hhtzxTj8WeO7vOU7+tWzESLiRtaO+/s9EJ8OD02pFw97GejGZUUg8Y50F7m
         7RX2DO96+5DyoCE9EWI61V2VjbEL/VCrLKKvtZ12MfmKb2jTpPYuqYzdqlYrGViIjr0q
         JpjCSE/xjP4nuyqMdARkvth5BDAsJzB64mUyUuCPR4UBZcywtY3kyJ5eIjFPHLIa6gQY
         vl+7ydBTjTZ2P1SXHYOYsaiQlvjhQEeUr8Z+cECN7R2fO8T4XtqOYe3ifDBT0JiYKQLV
         ZI8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845895; x=1785450695;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wsH8kj/3dWv6cLIAPdQqtziw/Fcf/VIereTmaACRGrU=;
        b=lnEpRfI6M5Rhhe3OuWn8QoUzjoQizR4lylb7tVZ188DGykBIXzwOHJGiHG4QPBtDEc
         9ZWk2ZOIqMB+6z8FpsaUSNdUzZ+i/ctE+hu/Cj8LH7hUqGdz7Mnbb4u/ZrapsPl9BFbg
         SSbyXxrrR0fduyvQv3cjXJpCmxcc2L4MfdiUsWaW0gB3EpTzKJRKrbOj7aZKjIgbWAH2
         zVw2LB1klx4yOt1m1puqrrtyZW50GSzknXF43fx+AmjKrC9afrt5+6b3gMWun/Z6PQRr
         rvWtw32XmmFey+/aaxRsmO4rPU5skNNo3CVmCE3fsdXsV1B7wp88P0Fwt0jxv6LoZYhd
         ltlQ==
X-Forwarded-Encrypted: i=1; AHgh+RrEwcMPTL2gopALGiI9fxASBB1EfaIZfSvzpoyR0ah7y7Y8BJmSxT6SjIamtsbfmlDIPDz+3roKWnI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdHdvuShLm7Xv3LkRnGU7oIXadqwZiMi/jawoV6XIoCasElwMw
	yiKBYnWZgm15E1CcxhZmVBXwzqmPYZnwqH1sNehhe2RRlUGpCI95rsbj
X-Gm-Gg: AR+sD13vid2aCR4uotuthsZbY5mX4yB2iYPyqJvVNKdoGG2X/LU9+QbBmcnDyK3Al9D
	AwrG+V7b3e7vudAxLhiWaMx8x+P4C7mW76/QYfeEczGLOKIDMxUqSCq7HPrIcPHfrlxSVBRccVq
	pHJrtcRpsevp49fvDZjZqB2FNCdZAf4Mh0vJjrztpTj4AazB05vDF6qtgBT6r9cb2A8u+qO/YjE
	hisI8bWkAjhSN7CuxTMq0YwQ9HjRxbN4Xhi3C3QxMKnHbRtBB5XOU0f3/9Bih3gbof9XxRtIERG
	a74KLhThh0e4g5rVXy8Z66BwUEFDjP42iwtO1CC03qsAsCm+88iy5JFC4iyHjvF9mSHwQ2ZxCLd
	XoTuBzqfs/mw9mufy6J/QobH9HVIgD0TcZDLD/uTkYxf2CAIKM/5nAH192XBNtKZrKkLBPgtrOJ
	+k3eeU+is=
X-Received: by 2002:a05:690c:6e0f:b0:81e:fbcd:7d5b with SMTP id 00721157ae682-81f4c322550mr16240747b3.48.1784845894768;
        Thu, 23 Jul 2026 15:31:34 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:446f:49ff:37bd:d45a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33c3c1c5sm35766777b3.17.2026.07.23.15.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:31:34 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 23 Jul 2026 15:30:14 -0700
Subject: [PATCH RFC 15/15] hw/virtio/vhost-user: shadow vq cleanup
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-vhost-user-isolated-memory-v1-15-6b97c439eb28@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784845839; l=1307;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=pisgaTgm+ZiObME3tqs8+StA8fZGh7Ia1Av4+zrft74=;
 b=TKTPDfMHj7ZdjHO/ODp2CBOHuJLnh0vD84p1jGP0HewGtInAJEuyxPU1ExLs8Hpdj392t+hFk
 aqkNu70i+oaA+6Qkgwug3b6ISRANc5tQC0LoyjBr6aCpMgIFECkEtSD
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Implements functionality to cleanup svqs on cleanup of isolation
regions.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 hw/virtio/vhost-user.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index e65f877f9a..bb4de78b95 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -1140,6 +1140,15 @@ static int vhost_user_set_mem_table_postcopy(struct vhost_dev *dev,
     return 0;
 }
 
+static void vhost_user_svq_cleanup(struct vhost_user *u)
+{
+    for (int i = 0; i < u->shadow_vqs->len; i++) {
+        vhost_svq_stop(g_ptr_array_index(u->shadow_vqs, i));
+    }
+
+    g_ptr_array_free(u->shadow_vqs, true);
+}
+
 /* TODO: Is there any notifier cleanup required here?*/
 static void cleanup_isolation_regions(struct vhost_dev *dev)
 {
@@ -1147,6 +1156,7 @@ static void cleanup_isolation_regions(struct vhost_dev *dev)
     if (u->iso_memory.base_addr) {
         vhost_iova_tree_delete(u->iso_iova_tree);
         u->iso_iova_tree = NULL;
+        vhost_user_svq_cleanup(u);
         memset(&u->iso_memory, 0, sizeof(IsolationRegion));
         qemu_memfd_free((gpointer) u->iso_memory.base_addr, u->iso_memory.size,
                          u->iso_memory.iso_fd);

-- 
2.43.0

