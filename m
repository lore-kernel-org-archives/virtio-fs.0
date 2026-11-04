Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.154.239.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793779795;
	b=dcdB/1Q7dq+rNX3zzKT/CAhpowOihMGhFEpWRklWVV8kGcvY+KjzC1Z2NP6WT3lUUNQ0
	 HP0xb8cwW+sxoDPK+md1JPyHzZZ9BwcAzNUWSAIvAJByc3jq9HVXAmFox+kbcjzEszXTN
	 V8Vx2WfL4wx5jowth1cFQGFPGxWs4TZPX2mYRPjeYz9j03F1u2wsBBp7rMJQ2CfQnX2HL
	 xDh8ot70Zin3Ztbfq628OyBHjmn8MMcOGegNqD3J5sXN5N/KpAkqa5TQuIUb2bmDX8nX0
	 xLgPQmoXZzAHAsyBu5hq3LXP8S3B0WaiXOPtz8Wc9p/xi3dh7qAmyNDRpPDvc8y0cyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793779795;
	h=DMARC-Filter:Received:Received:Precedence:List-Unsubscribe:
	 X-Yandex-Fwd:DKIM-Signature:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=PSmy8jzFUS9WxzXBQPmZHSDVhGXtMsL0D/UQGilfZmo=;
	b=tmTg/IIVH1hWk4+3eofjiQPEf+4j8N3wz1VSQXoxRzRxx+Gs7xjPQI37RibwIDzO1cdh
	 ahaZd+RkOrt0LpT68umOvBfzxqDdLuosaYlhAuXFNBgLIzPDiCXKkI/F7ZE/VK19981UO
	 km4OJ8yCNlX/wr+GIq5FN58NzsFNgUlsRAAIlAaFtST3q+qV2d3KhIroXPJKXyjuaqL3j
	 o0prp+WIfYWEn9/Epzo5qbM2fKavusS8viIsHJeBGB9+n+hyds08K652guWvIHJubIfb1
	 W/mGAmg8pi7u8JKvzFj0O73oSWfvLvPvr4B43FBu949XicnQ8OCQp1zURfwPQlnR4lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex-team.ru;
	spf=pass smtp.mailfrom=yandex-team.ru;
	dkim=pass header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b=mHL1wxtb;
	arc=none smtp.remote-ip=178.154.239.207
Received: from forwardcorp2d.mail.yandex.net (forwardcorp2d.mail.yandex.net [178.154.239.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05637606A31B
	for <virtio-fs@lists.linux.dev>; Wed,  4 Nov 2026 08:09:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05637606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b=mHL1wxtb
Received: from mail-nwsmtp-smtp-corp-main-68 (mail-nwsmtp-smtp-corp-main-68.yp-c.yandex.net)
	by forwardcorp2d.mail.yandex.net (postfix) with ESMTPS id E9A9A80C2B;
	Wed, 04 Nov 2026 11:09:44 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru
	by mail-nwsmtp-smtp-corp-main-68 with ESMTPSA id d9HpgM5agCg0-bxk21wZr;
	Wed, 04 Nov 2026 11:09:44 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1793779784;
	bh=PSmy8jzFUS9WxzXBQPmZHSDVhGXtMsL0D/UQGilfZmo=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=mHL1wxtbIVCsCjn+JS3x3rF8oA24EsZrQdTVCqjPAa3vJHDzwbs8AFQFzQce7gTa1
	 c8gPAPALpoCj1JEXEAjoLLxtjiqoIIReiNLfCa+KhhGWDJKT5Tulca2NdfRP/tkD7k
	 X1tt++yBrYI/2wXnkFqhkWPQyUsRL9wuzJLpM9X0=
Authentication-Results: mail-nwsmtp-smtp-corp-main-68; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	"Dr . David Alan Gilbert" <dgilbert@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtio-fs@lists.linux.dev,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH] vhost-user-fs: fix virtqueue array leak on realize failure
Date: Wed,  4 Nov 2026 13:09:39 +0500
Message-Id: <20261104080939.439160-1-dtalexundeer@yandex-team.ru>
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
NULL instead of the virtqueue array. Save the pointer locally and use
it to free the array on failure.

Fixes: 98fc1ada4cf7 ("virtio: add vhost-user-fs base device")
Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 hw/virtio/vhost-user-fs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 0d8842817a..9b33fe13bb 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -198,6 +198,7 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
     VHostUserFS *fs = VHOST_USER_FS(dev);
+    struct vhost_virtqueue *vhost_vqs;
     unsigned int i;
     size_t len;
     int ret;
@@ -255,7 +256,8 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
 
     /* 1 high prio queue, plus the number configured */
     fs->vhost_dev.nvqs = 1 + fs->conf.num_request_queues;
-    fs->vhost_dev.vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
+    vhost_vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
+    fs->vhost_dev.vqs = vhost_vqs;
     ret = vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
                          VHOST_BACKEND_TYPE_USER, 0, errp);
     if (ret < 0) {
@@ -272,7 +274,7 @@ err_virtio:
     }
     g_free(fs->req_vqs);
     virtio_cleanup(vdev);
-    g_free(fs->vhost_dev.vqs);
+    g_free(vhost_vqs);
 }
 
 static void vuf_device_unrealize(DeviceState *dev)
-- 
2.34.1

