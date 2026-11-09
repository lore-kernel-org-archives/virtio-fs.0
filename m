Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.154.239.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794205459;
	b=WIOzVq9EWJqZxBOPKhzMAsuuKFWV4L0idYldSBPqsRX3afEjkXAywjIKAoPgxPo+bykW
	 UvreGmvrkAGISowEUJey6x5FoXz+WLWMZ3WTL7uR/Oh+t2HCQ7WPfSlVhwKPB8SI4UZnD
	 ZJ+XH9U5FUDtycDtgvHDc0lOu+mMer/FA73F6TiIMXuZIJaW0bI0ys1KhxoXsN+wb3SoC
	 n4KE+PpolxhVy2zNJvMi3Ay/HdcR2G8BHlFynWuLAQO/ahC5nAuhpDrnjBGXNFOY3I7aY
	 8KfiY/PvcohNz8n/6kdjR3s9KCcUETzq13IDTlxnlItiUlqnT8Qfw3N4i65WihWQe3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794205459;
	h=DMARC-Filter:Received:Received:Precedence:List-Unsubscribe:
	 X-Yandex-Fwd:DKIM-Signature:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=54Yt/HRHUf73M1ZeOD79PJvJP775P4DcRNSZq34Dw+o=;
	b=yt3nE23N0I69AG2VI7D0o4aidcqiJmypi55wUDw7wCrOFzveQiY8iSwPFScXkguG2OBl
	 y0zKp4kG2IOjFPsTLAyql8iQ+KqWLPAZKwJ0qkWvdzL4XeBUE3jG6cTWY0kCFG5JTXQyH
	 d6TEKmWrX3D1uE2rEa0qvt7wE+G+84ykEZIly1bypYxnoRTf9R04rAK8h1AaF0WHdPxK3
	 wA+9eaYA/gBWVcYjoF8stGNQdXDyAXeMDocf+GJFilxEBnjmJCXPeD6b7r4cuPAfD32wP
	 TnZnz/s8dOlkpZi0fNJ35sIBN7DRYybqpNjAqx4s1QOynNq8Kr0N/Rmc60K+cmnEwPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex-team.ru;
	spf=pass smtp.mailfrom=yandex-team.ru;
	dkim=pass header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b=aYaEtiYQ;
	arc=none smtp.remote-ip=178.154.239.200
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF9D606A31C
	for <virtio-fs@lists.linux.dev>; Mon,  9 Nov 2026 06:24:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EF9D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b=aYaEtiYQ
Received: from mail-nwsmtp-smtp-corp-main-68 (mail-nwsmtp-smtp-corp-main-68.yp-c.yandex.net)
	by forwardcorp1d.mail.yandex.net (postfix) with ESMTPS id 2D18480844;
	Mon, 09 Nov 2026 09:24:07 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru
	by mail-nwsmtp-smtp-corp-main-68 with ESMTPSA id nNKLppCamiE0-HKe8ksFt;
	Mon, 09 Nov 2026 09:24:06 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1794205446;
	bh=54Yt/HRHUf73M1ZeOD79PJvJP775P4DcRNSZq34Dw+o=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=aYaEtiYQPsf0eCxIz0iBy2oElQFaUnCvxxPvXx7oQUJlUT78MGlTayMYn1LVKArVf
	 tlKXRzIDiqCD8UKCegw9VACD37zPweQdHVuOfnZcIMmvHnBXm+u7/+9TwA6e7O/uwR
	 5DAFlSt6Wz4yoaGv9ot7BcIGndf1GBeVJnHlGlQc=
Authentication-Results: mail-nwsmtp-smtp-corp-main-68; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtio-fs@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v2] vhost-user-fs: fix virtqueue array leak on realize failure
Date: Mon,  9 Nov 2026 11:24:01 +0500
Message-Id: <20261109062401.81161-1-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Post: <mailto:virtio-fs@lists.linux.dev>
List-Help: <mailto:virtio-fs+help@lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
List-Owner: <mailto:virtio-fs+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On failure, vhost_dev_init() clears vhost_dev, so the error path frees
NULL instead of the virtqueue array. Keep the pointer in the existing
vhost_vqs field and use it to free the array on failure and unrealize.

Fixes: 98fc1ada4cf7 ("virtio: add vhost-user-fs base device")
Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
v1 -> v2:
 - use the existing VHostUserFS.vhost_vqs field in realize and unrealize
   instead of local vars.

 hw/virtio/vhost-user-fs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 0d8842817a..f26b5b611a 100644
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
2.34.1

