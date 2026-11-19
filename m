Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795081642;
	b=tJUoHFRWQ6YwOTXQWXm97e3En+sB+EWSRP3QuiuAD+/DhFT3Rp425v4xjLTH6BvzMCsz
	 5/KiZG3S1gt9ijF5YnTQ3l3dXYIPYd4QN5tAR7bfB1UQV5MF1/tjQjzDYx+0631/Mzavg
	 OW29zqoAXWsxqJf7oiNTM6Jhmb6aNeeI9yt8zB7K88xHiboU5YdYYscN/nk7deYVnUU8a
	 w+EeXNwjBmbal2O3c3Eer2wR0kFkZA++8eGSykCm3hpZiPbGmmkCfUu6Sthw907Vb3ZRz
	 crLYKLJsdQHKbZzZ1ZV0PkhvXS9i0WCjXm2FYsajWgmtE5OdU2cNEL11TXbBUvn69OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795081642;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:In-Reply-To:X-Mailer:X-Mutt-Fcc:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Disposition;
	bh=JONgt/yP3PdUvMO+MK2zi0s+xj8Vp5+Dd4F+bpae7I4=;
	b=DwmnMb4R12QQD9li9UWz6myo2PnikNiM5YYZ1Q+DMMyhgXfx1fthLXImCWad1oNCtZfn
	 3YqQBFB5bG2NmkLaL5JE+J3S7ENniOYIqX249lK3PCasNzNDLXH+xBGsD9+sELY7jPC8L
	 CvoWcyBNwTjPpyGcQUBGzbJUZNBkAxJp/NT/AoNN3zYjU5JeQqDumQVztHS/y/k3JQQIM
	 8E8JQ/2/Euowggu+4HUpp0rrcbNFSw/nOKxCzF5J2XQ6D3yoLRvnl+ZkRguNZNDN8h3eR
	 /TNzX7gWDli2dehvMWE8WRVz6KxTvDpzxHXpMztG+niHL+QRcH02pQnIw+CxJcM7M1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bpgUcQF0;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC7F606A324
	for <virtio-fs@lists.linux.dev>; Thu, 19 Nov 2026 09:47:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BC7F606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bpgUcQF0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795081640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JONgt/yP3PdUvMO+MK2zi0s+xj8Vp5+Dd4F+bpae7I4=;
	b=bpgUcQF03FWnX7ZMn3YM9pM1udZ44HdnOfqmi9aZvJETbdsrai7/ZOBXWsScA39I5fRNnA
	hUmXnZXYnBEitN3ughlpbjWlj3yPxgVPTq3fqZtMm5MQPzib5ltz/x1pBZgWHEsChr9/uh
	QErvXabOGgeF4m6iz/PQBn2jA1BmRY4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-rIfsXt3QOtm3sh4VpWOKGQ-1; Thu, 19 Nov 2026 04:47:19 -0500
X-MC-Unique: rIfsXt3QOtm3sh4VpWOKGQ-1
X-Mimecast-MFC-AGG-ID: rIfsXt3QOtm3sh4VpWOKGQ_1795081638
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4a3052225cbso1827354f8f.1
        for <virtio-fs@lists.linux.dev>; Thu, 19 Nov 2026 01:47:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795081638; x=1795686438;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JONgt/yP3PdUvMO+MK2zi0s+xj8Vp5+Dd4F+bpae7I4=;
        b=ZOw3biJJwrmK/0de1XCZkf2US7pWZG3BuxnpKpdDVyLlnd98ey96lz92eP/moDcxXv
         fSNyYeSLm5ykh7IB/sUWkYlLphZOSr/S3HLj+4OjdcxKchupUbQXYbRm1xIJDPJBj75G
         uuaMDeIGc+7F9vpwI2zcJzw1XryzR8kwrNwOBb5A3H3hB0PAlrBjyZwLfuNf9uCbZoj3
         OB1Fb+94I2I0demAI7Z2hvePsBNdnTvtC56DAr+iqgIUFm1hTpKtDUWqM4Bl9veq01Fd
         yb06PkYl170elubdoj9FxJXDO4spfdE/AJeHjBFA//e/F5QXBGkJckALbFSrBYDtaSNG
         8blw==
X-Forwarded-Encrypted: i=1; AL+hErHPZ5rRtizBdXFfUC7lVqlNlEc0+fK3dM/AGh1TsXp7I6vrQfLoNUdAejDrh+zisuxHezHOUxg2+rY=@lists.linux.dev
X-Gm-Message-State: APuU4Z9F5FXA8h1VDrvJ9wxTs+YomUhb1jBsmyVto1MgHlv07XxNxJ3f
	jNYxkoHImDomi3x/l+ic5Z3s2Lo5PtP7UUlZ/6Vs0nD4hd8eYKKU5eTlf2OjBhLHW7qVnKidIep
	O6N8l7MWLu04BuMCa9deKX6KDk08isyZRb3jH7/mXMphfPqtL7+TMxjg3N6f+q4qrT2orzw==
X-Gm-Gg: AYBFou1nGLZJaC511RaQANWamx33wEbIbWZSE6mPksxaB16EYOugGfOaLtEokskm7Tb
	P7S6reBReOfaAUUG3R8Wpzjb9tAVBPYKDp7D4gCIm0BOXGNf4z9kpoh6iWncdkODKEUl5Arprvr
	v0OVQSrI4z2dgotIwtbx+wLix+VPAg5qW3/lU6Y4UZBlj88UYu2ekds9NsdMfIy+875URs528Cz
	LJnGvqEu7IdZUkTSYhSYsidQEnL3zOPmOqDAbW75TYYcPuvmHH92DqLePqWSHr0Z32FVIk1gU29
	/4jPrTEOg9nQ6fY3hGNCGE7SfFdK9HYNz/iK/lrl/wXyoZgwr/gu+50Mq0JAmLmWB8pfBp6RtSI
	zBtw3+DNm0JNfyuO6HTVZoxOJAftgql9mfplusU29Zyw=
X-Received: by 2002:a05:600c:45d4:b0:4bb:5f45:c97f with SMTP id 5b1f17b1804b1-4bb7da29ad4mr98626435e9.27.1795081637848;
        Thu, 19 Nov 2026 01:47:17 -0800 (PST)
X-Received: by 2002:a05:600c:45d4:b0:4bb:5f45:c97f with SMTP id 5b1f17b1804b1-4bb7da29ad4mr98625835e9.27.1795081637070;
        Thu, 19 Nov 2026 01:47:17 -0800 (PST)
Received: from redhat.com ([2a0d:6fc0:1520:4400:d78d:7b2d:2f5d:e08f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853b216esm24283345e9.12.2026.11.19.01.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 01:47:15 -0800 (PST)
Date: Thu, 19 Nov 2026 04:47:14 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@lists.linux.dev
Subject: [PULL 4/8] vhost-user-fs: fix virtqueue array leak on realize failure
Message-ID: <8efc85f1650d6db3a95f7aebd97bc40274d1c2ee.1795081539.git.mst@redhat.com>
References: <cover.1795081539.git.mst@redhat.com>
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Post: <mailto:virtio-fs@lists.linux.dev>
List-Help: <mailto:virtio-fs+help@lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
List-Owner: <mailto:virtio-fs+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <cover.1795081539.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EjYYagJWuWH2K7Lr2HWisOciWagVPIbEuZH-UJHX4hA_1795081638
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>

On failure, vhost_dev_init() clears vhost_dev, so the error path frees
NULL instead of the virtqueue array. Keep the pointer in the existing
vhost_vqs field and use it to free the array on failure and unrealize.

Fixes: 98fc1ada4cf7 ("virtio: add vhost-user-fs base device")
Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261109062401.81161-1-dtalexundeer@yandex-team.ru>
---
 hw/virtio/vhost-user-fs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 0d8842817a1..f26b5b611ac 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -255,7 +255,8 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
 
     /* 1 high prio queue, plus the number configured */
     fs->vhost_dev.nvqs = 1 + fs->conf.num_request_queues;
-    fs->vhost_dev.vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
+    fs->vhost_vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
+    fs->vhost_dev.vqs = fs->vhost_vqs;
     ret = vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
                          VHOST_BACKEND_TYPE_USER, 0, errp);
     if (ret < 0) {
@@ -272,14 +273,14 @@ err_virtio:
     }
     g_free(fs->req_vqs);
     virtio_cleanup(vdev);
-    g_free(fs->vhost_dev.vqs);
+    g_free(fs->vhost_vqs);
+    fs->vhost_vqs = NULL;
 }
 
 static void vuf_device_unrealize(DeviceState *dev)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
     VHostUserFS *fs = VHOST_USER_FS(dev);
-    struct vhost_virtqueue *vhost_vqs = fs->vhost_dev.vqs;
     int i;
 
     /* This will stop vhost backend if appropriate. */
@@ -295,7 +296,8 @@ static void vuf_device_unrealize(DeviceState *dev)
     }
     g_free(fs->req_vqs);
     virtio_cleanup(vdev);
-    g_free(vhost_vqs);
+    g_free(fs->vhost_vqs);
+    fs->vhost_vqs = NULL;
 }
 
 static struct vhost_dev *vuf_get_vhost(VirtIODevice *vdev)
-- 
MST

